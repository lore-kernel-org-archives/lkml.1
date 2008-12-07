Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYLGSfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYLGSfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYLGSbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:36 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55725 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYLGSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:34 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 12/13] checkpatch: fix the perlcritic errors
Date: Sun,  7 Dec 2008 18:30:49 +0000
Message-Id: <1228674650-24392-13-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Clean up checkpatch using perlcritic.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 94371f6..bd6ac90 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -69,7 +69,9 @@ my $dbg_possible = 0;
 my $dbg_type = 0;
 my $dbg_attr = 0;
 for my $key (keys %debug) {
-	eval "\${dbg_$key} = '$debug{$key}';"
+	## no critic
+	eval "\${dbg_$key} = '$debug{$key}';";
+	die "$@" if ($@);
 }
 
 if ($terse) {
@@ -206,9 +208,9 @@ my @dep_includes = ();
 my @dep_functions = ();
 my $removal = "Documentation/feature-removal-schedule.txt";
 if ($tree && -f "$root/$removal") {
-	open(REMOVE, "<$root/$removal") ||
+	open(my $REMOVE, '<', "$root/$removal") ||
 				die "$P: $removal: open failed - $!\n";
-	while (<REMOVE>) {
+	while (<$REMOVE>) {
 		if (/^Check:\s+(.*\S)/) {
 			for my $entry (split(/[, ]+/, $1)) {
 				if ($entry =~ m@include/(.*)@) {
@@ -220,17 +222,21 @@ if ($tree && -f "$root/$removal") {
 			}
 		}
 	}
+	close($REMOVE);
 }
 
 my @rawlines = ();
 my @lines = ();
 my $vname;
 for my $filename (@ARGV) {
+	my $FILE;
 	if ($file) {
-		open(FILE, "diff -u /dev/null $filename|") ||
+		open($FILE, '-|', "diff -u /dev/null $filename") ||
 			die "$P: $filename: diff failed - $!\n";
+	} elsif ($filename eq '-') {
+		open($FILE, '<&STDIN');
 	} else {
-		open(FILE, "<$filename") ||
+		open($FILE, '<', "$filename") ||
 			die "$P: $filename: open failed - $!\n";
 	}
 	if ($filename eq '-') {
@@ -238,11 +244,11 @@ for my $filename (@ARGV) {
 	} else {
 		$vname = $filename;
 	}
-	while (<FILE>) {
+	while (<$FILE>) {
 		chomp;
 		push(@rawlines, $_);
 	}
-	close(FILE);
+	close($FILE);
 	if (!process($filename)) {
 		$exit = 1;
 	}
-- 
1.6.0.4.911.gc990

