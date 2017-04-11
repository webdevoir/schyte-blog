class SettingValidator < ActiveModel::Validator
  def validate(record)
    if record.config.present?
      global_validator(record) if record.name == 'Global'
    else
      record.errors.add(:config, "Config can't be all blank")
    end
  end

  private

  def global_validator(record)
    record.config.each do |key, value|
      case key
      when 'site_title'
        combined_validator(record, key, value, 6)
      when 'site_description'
        maximum_validator(record, key, value, 255)
      when 'site_keywords'
        maximum_validator(record, key, value, 255)
      when 'site_footer'
        maximum_validator(record, key, value, 127)
      end
    end
  end

  def combined_validator(record, key, value, limit)
    unless value.present?
      record.errors.add(key.to_sym, "#{key.humanize} can't be blank")
    else
      minimum_validator(record, key, value, limit)
    end
  end

  def minimum_validator(record, key, value, limit)
    return unless value.size < limit
    record.errors.add(key.to_sym, "#{key.humanize} is too short (minimum is #{limit} characters)")
  end

  def maximum_validator(record, key, value, limit)
    return unless value.size > limit
    record.errors.add(key.to_sym, "#{key.humanize} is too long (maximum is #{limit} characters)")
  end
end