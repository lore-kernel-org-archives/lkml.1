Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0BJIy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:54:27 -0500
Received: from palm.sejo.be ([86.39.155.213]:46836 "EHLO palm.sejo.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0BJIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:54:26 -0500
From: Jochen Maes <jochen.maes@sejo.be>
To: apw@canonical.com
Cc: akpm@linux-foundation.org, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, Jochen Maes <jochen.maes@sejo.be>
Subject: [PATCH 2/2] scripts: Remove the 80 line limit check
Date: Wed, 10 Feb 2010 09:55:31 +0100
Message-Id: <1265792131-15835-1-git-send-email-jochen.maes@sejo.be>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As lately the 80 line limit is not really enforced anymore I think it's
cleaner not to do che checks in the checkpatch. It gives extra output
that is ignored anyway.

Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
---
 scripts/checkpatch.pl |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..c91ad29 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1374,15 +1374,6 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
-		{
-			WARN("line over 80 characters\n" . $herecurr);
-		}
-
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
-- 
1.6.6

