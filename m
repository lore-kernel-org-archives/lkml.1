Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYIBR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYIBR0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIBRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:23 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36135 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 4/7] checkpatch: check line endings in text format files
Date: Tue,  2 Sep 2008 18:25:11 +0100
Message-Id: <1220376314-15180-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware may be included in the kernel as .ihex files.  These are
inherantly text, but not source.  The line ending checks are applicable
to these kinds of file, allow just these checks to apply to all files.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 18646f0..a2e4a3d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1241,9 +1241,6 @@ sub process {
 #ignore lines being removed
 		if ($line=~/^-/) {next;}
 
-# check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
-
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
@@ -1253,6 +1250,10 @@ sub process {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
 		}
+
+# check we are in a valid source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-- 
1.6.0.rc1.258.g80295

