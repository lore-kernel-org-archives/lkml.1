Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbZHUVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbZHUVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbZHUVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59333 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbZHUVqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:19 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>, Hannes Eder <hannes@hanneseder.net>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 4/7] checkpatch: make -f alias --file, add --help, more verbose help message
Date: Fri, 21 Aug 2009 22:46:07 +0100
Message-Id: <1250891170-8599-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact:
  - More verbose help/usage message.
  - Make the option -f an alias for --file.
  - On -h, --help, and --version display help message and exit(0).
  - With no FILE(s) given, exit(1) with "no input files".
  - On invalid options display help/usage and exit(1).

Based on a patch by Pavel Machek.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   55 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b6f267b..e3c6b49 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -28,6 +28,41 @@ my $mailback = 0;
 my $summary_file = 0;
 my $root;
 my %debug;
+my $help = 0;
+
+sub help {
+	my ($exitcode) = @_;
+
+	print << "EOM";
+Usage: $P [OPTION]... [FILE]...
+Version: $V
+
+Options:
+  -q, --quiet                quiet
+  --no-tree                  run without a kernel tree
+  --no-signoff               do not check for 'Signed-off-by' line
+  --patch                    treat FILE as patchfile (default)
+  --emacs                    emacs compile window format
+  --terse                    one line per report
+  -f, --file                 treat FILE as regular source file
+  --subjective, --strict     enable more subjective tests
+  --root=PATH                PATH to the kernel tree root
+  --no-summary               suppress the per-file summary
+  --mailback                 only produce a report in case of warnings/errors
+  --summary-file             include the filename in summary
+  --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is one of
+                             'values', 'possible', 'type', and 'attr' (default
+                             is all off)
+  --test-only=WORD           report only warnings/errors containing WORD
+                             literally
+  -h, --help, --version      display this help and exit
+
+When FILE is - read standard input.
+EOM
+
+	exit($exitcode);
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -35,7 +70,7 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
-	'file!'		=> \$file,
+	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
@@ -45,22 +80,16 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
-) or exit;
+	'h|help'	=> \$help,
+	'version'	=> \$help
+) or help(1);
+
+help(0) if ($help);
 
 my $exit = 0;
 
 if ($#ARGV < 0) {
-	print "usage: $P [options] patchfile\n";
-	print "version: $V\n";
-	print "options: -q               => quiet\n";
-	print "         --no-tree        => run without a kernel tree\n";
-	print "         --terse          => one line per report\n";
-	print "         --emacs          => emacs compile window format\n";
-	print "         --file           => check a source file\n";
-	print "         --strict         => enable more subjective tests\n";
-	print "         --root           => path to the kernel tree root\n";
-	print "         --no-summary     => suppress the per-file summary\n";
-	print "         --summary-file   => include the filename in summary\n";
+	print "$P: no input files\n";
 	exit(1);
 }
 
-- 
1.6.3.3

