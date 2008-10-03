Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYJCP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYJCP0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYJCP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:01 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57466 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 02/13] checkpatch: labels are not possible types
Date: Fri,  3 Oct 2008 16:25:43 +0100
Message-Id: <1223047554-31111-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A label is not a candidate for a possible type.  Exclude them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6b21188..17e1d94 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1324,7 +1324,7 @@ sub process {
 				possible($type, "A:" . $s);
 
 			# definitions in global scope can only start with types
-			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/s) {
+			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b\s*(?!:)/s) {
 				possible($1, "B:" . $s);
 			}
 
-- 
1.6.0.1.451.gc8d31

