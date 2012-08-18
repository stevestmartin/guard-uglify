require 'guard'
require 'guard/guard'

require 'uglifier'

module Guard
  class Uglify < Guard
    def initialize(watchers=[], options={})
      super 
      @input  = Array(options[:input])
      @output = options[:output]
    end

    def start
      uglify
    end

    def reload
      uglify
    end

    def run_all
      uglify
    end

    def run_on_change(paths)
      uglify
    end

    private
    def uglify
      begin
        uglified = Uglifier.new.compile(@input.map {|f| File.read(f)}.join)
        File.open(@output,'w'){ |f| f.write(uglified) }
        UI.info         "Uglified #{@input.join(', ')} to #{@output}"
        Notifier.notify "Uglified #{@input.join(', ')} to #{@output}", :title => 'Uglify'
        true
      rescue Exception => e
        UI.error        "Uglifying #{@input.join(', ')} failed: #{e}"
        Notifier.notify "Uglifying #{@input.join(', ')} failed: #{e}", :title => 'Uglify', :image => :failed
        false
      end
    end
  end
end
