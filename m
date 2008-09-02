Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYIBRZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYIBRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYIBRZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:21 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36125 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 6/7] checkpatch: ensure we only apply checks to the lines within hunks
Date: Tue,  2 Sep 2008 18:25:13 +0100
Message-Id: <1220376314-15180-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only apply source checks to lines within hunks.  Checks which are
anchored in the context may falsly trigger in the commentory.  Ensure they
only match within valid hunk lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2e513fd..fe4553c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1128,6 +1128,7 @@ sub process {
 		$linenr++;
 
 		my $rawline = $rawlines[$linenr - 1];
+		my $hunk_line = ($realcnt != 0);
 
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
@@ -1238,8 +1239,8 @@ sub process {
 			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
-#ignore lines being removed
-		if ($line=~/^-/) {next;}
+# ignore non-hunk lines and lines being removed
+		next if (!$hunk_line || $line =~ /^-/);
 
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
-- 
1.6.0.rc1.258.g80295

