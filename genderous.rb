require 'json'
require 'set'
require 'term/ansicolor'
include Term::ANSIColor

class Genderous

	def initialize()
		@content = load_json("de-en-es.json")
		@keys = @content.keys
		@error = {:gender => 0, :other => 0}
		@success =  {:success => 0}
	end

	def load_json(filename)
		fd = File.open(filename)
		JSON.load(fd)
	end

	def check_asked(asked, en, keys, index)
		while (asked.member? en)
			en = keys[rand(keys.length)]
			if asked.length == keys.length
				puts "Self ejecting. You did all the words."
				exit_with_stats
			end
		end
	end

	def increment_success
		@success[:success] += 1
	end

	def increment_error(type = :other)
		type == :gender ? @error[:gender] += 1 :  @error[:other] += 1
	end

	def exit_with_stats
		total_error = @error[:gender] + @error[:other]
		puts yellow("Total #{@success[:success]+ total_error} words")
		puts green("Success #{@success[:success]}")
		if total_error > 0
			puts red("Errors #{total_error} of which: gender #{@error[:gender]}, other #{@error[:other]}")
		end
		puts "Press any key to exit"
		gets.chomp
		exit!
	end

	def ask(lang = "deutsche", asked)

		lang =="deutsche" ? index = 0 : index = 1
		keys = @content.keys
		en = keys[rand(keys.length)]
		# Check if the word has been
		check_asked(asked, en, keys, index )
		asked.add(en)
		other = @content[en]
		puts "Was ist \"#{en}\" auf #{lang}?"
		word = gets.chomp
		if word == other
			puts green("ok")
			increment_success
		elsif word[4,word.length] == other[4,other.length] 
			puts red("Genus: Es ist ")+ yellow("#{other}")
			increment_error(:gender)
		elsif word == "exit"
			exit_with_stats
		else
			increment_error(:other)
			puts red("Oops. Nein es ist ")+ yellow("#{other}")
		end
	end

	def main
		puts "- Wilkommen in lingua :D - type exit to quit \n"
		asked = Set.new()
		ask(asked)
		while(1)
			ask(asked)
		end
	end
end

ge = Genderous.new()
ge.main
