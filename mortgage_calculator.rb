def prompt(message)
  Kernel.puts("=>> #{message}")
end

def valid_amount?(input)
  Float(input)
rescue StandardError
  false
end

def integer?(input)
  Integer(input)
rescue StandardError
  false
end

require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

prompt(MESSAGES['language']['question'])
language = ''
loop do
  language = Kernel.gets().chomp()
  if language == '1' || language == '2'
    if language == '1'
      language = 'english'
    elsif language == '2'
      language = 'chinese'
    end
    break
  else
    prompt(MESSAGES['language']['error'])
  end
end

prompt(MESSAGES[language]['welcome'])
prompt(MESSAGES[language]['name'])
name = ''
loop do
  name = Kernel.gets().chomp()
  if name.empty?()
    prompt(MESSAGES[language]['name_error'])
  else
    break
  end
end

prompt("Hi, #{name}")

loop do
  loan_amount = ''
  loop do
    prompt(MESSAGES[language]['loan_amount'])
    loan_amount = Kernel.gets().chomp()
    if valid_amount?(loan_amount) && loan_amount.to_f() > 0
      break
    else
      prompt(MESSAGES[language]['amount_error'])
    end
  end

  monthly_interest_rate = ''
  loop do
    prompt(MESSAGES[language]['monthly_interest_rate'])
    monthly_interest_rate = Kernel.gets().chomp()
    if valid_amount?(monthly_interest_rate) && monthly_interest_rate.to_f() > 0
      monthly_interest_rate = monthly_interest_rate.to_f() / 100 / 12
      break
    else
      prompt(MESSAGES[language]['rate_error'])
    end
  end

  loan_duration_in_months = ''
  loop do
    prompt(MESSAGES[language]['loan_duration_in_months'])
    loan_duration_in_months = Kernel.gets().chomp()
    if integer?(loan_duration_in_months) && loan_duration_in_months.to_i() > 0
      break
    else
      prompt(MESSAGES[language]['months_error'])
    end
  end

  monthly_payment = loan_amount.to_f() *
    (monthly_interest_rate.to_f() / (1 - 
    (1 + monthly_interest_rate.to_f())**(-loan_duration_in_months.to_f())))

  prompt("Your monthly payment is: $#{format('%.2f', monthly_payment)}")

  prompt(MESSAGES[language]['again'])
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt(MESSAGES[language]['bye'])
