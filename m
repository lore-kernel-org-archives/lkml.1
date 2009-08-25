Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZHYLvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZHYLvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZHYLvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:51:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51149 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZHYLvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:51:20 -0400
Date: Tue, 25 Aug 2009 13:51:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH 4/7] checkpatch: make -f alias --file, add --help, more
	verbose help message
Message-ID: <20090825115110.GE1341@ucw.cz>
References: <1250891170-8599-1-git-send-email-apw@canonical.com> <1250891170-8599-5-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250891170-8599-5-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-21 22:46:07, Andy Whitcroft wrote:
> From: Hannes Eder <hannes@hanneseder.net>
> 
> Impact:
>   - More verbose help/usage message.
>   - Make the option -f an alias for --file.
>   - On -h, --help, and --version display help message and exit(0).
>   - With no FILE(s) given, exit(1) with "no input files".
>   - On invalid options display help/usage and exit(1).
> 
> Based on a patch by Pavel Machek.
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Pavel Machek <pavel@suse.cz>

> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Thanks!


> ---
>  scripts/checkpatch.pl |   55 +++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b6f267b..e3c6b49 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -28,6 +28,41 @@ my $mailback = 0;
>  my $summary_file = 0;
>  my $root;
>  my %debug;
> +my $help = 0;
> +
> +sub help {
> +	my ($exitcode) = @_;
> +
> +	print << "EOM";
> +Usage: $P [OPTION]... [FILE]...
> +Version: $V
> +
> +Options:
> +  -q, --quiet                quiet
> +  --no-tree                  run without a kernel tree
> +  --no-signoff               do not check for 'Signed-off-by' line
> +  --patch                    treat FILE as patchfile (default)
> +  --emacs                    emacs compile window format
> +  --terse                    one line per report
> +  -f, --file                 treat FILE as regular source file
> +  --subjective, --strict     enable more subjective tests
> +  --root=PATH                PATH to the kernel tree root
> +  --no-summary               suppress the per-file summary
> +  --mailback                 only produce a report in case of warnings/errors
> +  --summary-file             include the filename in summary
> +  --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is one of
> +                             'values', 'possible', 'type', and 'attr' (default
> +                             is all off)
> +  --test-only=WORD           report only warnings/errors containing WORD
> +                             literally
> +  -h, --help, --version      display this help and exit
> +
> +When FILE is - read standard input.
> +EOM
> +
> +	exit($exitcode);
> +}
> +
>  GetOptions(
>  	'q|quiet+'	=> \$quiet,
>  	'tree!'		=> \$tree,
> @@ -35,7 +70,7 @@ GetOptions(
>  	'patch!'	=> \$chk_patch,
>  	'emacs!'	=> \$emacs,
>  	'terse!'	=> \$terse,
> -	'file!'		=> \$file,
> +	'f|file!'	=> \$file,
>  	'subjective!'	=> \$check,
>  	'strict!'	=> \$check,
>  	'root=s'	=> \$root,
> @@ -45,22 +80,16 @@ GetOptions(
>  
>  	'debug=s'	=> \%debug,
>  	'test-only=s'	=> \$tst_only,
> -) or exit;
> +	'h|help'	=> \$help,
> +	'version'	=> \$help
> +) or help(1);
> +
> +help(0) if ($help);
>  
>  my $exit = 0;
>  
>  if ($#ARGV < 0) {
> -	print "usage: $P [options] patchfile\n";
> -	print "version: $V\n";
> -	print "options: -q               => quiet\n";
> -	print "         --no-tree        => run without a kernel tree\n";
> -	print "         --terse          => one line per report\n";
> -	print "         --emacs          => emacs compile window format\n";
> -	print "         --file           => check a source file\n";
> -	print "         --strict         => enable more subjective tests\n";
> -	print "         --root           => path to the kernel tree root\n";
> -	print "         --no-summary     => suppress the per-file summary\n";
> -	print "         --summary-file   => include the filename in summary\n";
> +	print "$P: no input files\n";
>  	exit(1);
>  }
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
