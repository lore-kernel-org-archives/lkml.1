Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYANW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYANW3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYANWXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:23:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:11824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbYANWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=CbJVcPF5S1nqMOYJ214FoxN4cnSh1Nl0DqxBtO8brZjDNsj6p6N/4VH9HLjNFHqkHMLuFqCWNsIuJD8RHI5IhPXU4jeKlCX7G2BeWH6HdAbmxwxCbucgt3lgJytFx1pxUshMcybUYrCCIP7XonBAF5n0jkH+XWAdPI5Wxe4rQ54=
Date: Mon, 14 Jan 2008 23:23:39 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: apw@shadowen.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch: add filename in the summary
Message-ID: <20080114232339.2c018647@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a filename option (default to 0)
in order to get the following summary output:
./scripts/checkpatch.pl --filename --file ./arch/sparc/kernel/apc.c 
...
...
...
./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked
---

Andy, 
I wonder why checkpatch doesn't show all the command line options. 
At the moment, it only prints:
options: -q           => quiet
	--no-tree    => run without a kernel tree
        --terse      => one line per report
        --emacs      => emacs compile window format
        --file       => check a source file
        --strict     => enable more subjective tests
        --root       => path to the kernel tree root

but I see a lot more options:
	q|quiet
	tree
	signoff
	patch
	test-type
	emacs
	terse
	file
	subjective
	strict
	root=s
	summary
	mailback


 scripts/checkpatch.pl |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..1762b73 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -24,6 +24,7 @@ my $file = 0;
 my $check = 0;
 my $summary = 1;
 my $mailback = 0;
+my $patchfilename= 0;
 my $root;
 GetOptions(
 	'q|quiet+'	=> \$quiet,
@@ -39,6 +40,7 @@ GetOptions(
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
+	'filename'	=> \$patchfilename,
 ) or exit;
 
 my $exit = 0;
@@ -1579,12 +1581,18 @@ sub process {
 	}
 
 	print report_dump();
-	if ($summary) {
+	if ($summary == 1 && $patchfilename == 0) {
 		print "total: $cnt_error errors, $cnt_warn warnings, " .
 			(($check)? "$cnt_chk checks, " : "") .
 			"$cnt_lines lines checked\n";
 		print "\n" if ($quiet == 0);
 	}
+	if ($summary == 1 && $patchfilename == 1) {
+		print "$filename --> total: $cnt_error errors, $cnt_warn warnings, " .
+			(($check)? "$cnt_chk checks, " : "") .
+			"$cnt_lines lines checked\n";
+		print "\n" if ($quiet == 0);
+	}
 
 	if ($clean == 1 && $quiet == 0) {
 		print "Your patch has no obvious style problems and is ready for submission.\n"
-- 
1.5.4.rc3

