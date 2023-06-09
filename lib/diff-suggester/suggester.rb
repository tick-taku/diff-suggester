require_relative 'diff/diff_parser'
require_relative 'client/requester'

module DiffSuggester
  class Suggester

    def initialize(repo:, pr_number:, access_token:, base_url: nil)
      @pull_request = GitHubRequester::PullRequest.new(repo: repo, pr_number: pr_number, access_token: access_token, base_url: base_url)
    end

    def suggest
      diffs = GitHubDiff.parse_from_string
      diffs.each do |diff|
        diff.hunks.each do |hunk|
          @pull_request.create_comment(
            path: diff.file_path,
            body: suggestion(hunk.body),
            line: hunk.end_line,
            start_line: hunk.start_line,
            side: 'RIGHT',
            start_side: 'RIGHT'
          )
        end
      end
    end

    def suggestion(body)
        return "```suggestion\n#{body}\n```"
    end
  end
end
