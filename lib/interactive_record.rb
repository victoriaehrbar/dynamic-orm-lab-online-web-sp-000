require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.column_names

    sql = "pragma table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []
    table_info.each do |row|
      column_names << row["name"]
    end
    column_names.compact
  end
  
    def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end
  
   def table_name_for_insert
    self.class.table_name
  end
  
    def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end
  
  def self.find_by_name(name)
  sql = "SELECT * FROM #{self.table_name} WHERE name = ?"
  DB[:conn].execute(sql, name)
end
  
  
end