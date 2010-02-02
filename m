Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0BCF0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:26:10 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:40421 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0BCF0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:26:06 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/get_maintainer.pl: add ability to read from STDIN
Date: Wed,  3 Feb 2010 02:30:12 +0800
Message-Id: <1265135412-18391-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for finding people for the Cc: list without dumping the
patch to a file before. You can just run

  git diff --cached | scripts/get_maintainer.pl -

now.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/get_maintainer.pl |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 090f248..3394131 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -237,7 +237,7 @@ foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
     if ((-d $file)) {
 	$file =~ s@([^/])$@$1/@;
-    } elsif (!(-f $file)) {
+    } elsif ($file ne "-" && !(-f $file)) {
 	die "$P: file '${file}' not found\n";
     }
     if ($from_filename) {
@@ -255,7 +255,11 @@ foreach my $file (@ARGV) {
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
-	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
+	if ($file eq "-") {
+		open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
+	} else {
+		open(PATCH, "<") or die "$P: Can't read from STDIN\n";
+	}
 	while (<PATCH>) {
 	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
@@ -496,6 +500,7 @@ Notes:
           --git-min-signatures, --git-max-maintainers, --git-min-percent, and
           --git-blame
       Use --hg-since not --git-since to control date selection
+  You can pass '-' as argument to read the patch file from STDIN
 EOT
 }
 
-- 
1.6.3.3

