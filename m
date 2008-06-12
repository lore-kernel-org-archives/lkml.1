Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYFLMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYFLMbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbYFLMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:31:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3408 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761525AbYFLMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:31:27 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 10/23] checkpatch: allow printk strings to exceed 80 characters to maintain their searchability
Date: Thu, 12 Jun 2008 13:05:49 +0100
Message-Id: <1213272362-19457-11-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow printk strings to break the 80 character width limits, thus keeping
them complete and searchable.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 89177c3..614999f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1138,7 +1138,9 @@ sub process {
 		}
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ && $length > 80)
+		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
+		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+		    $length > 80)
 		{
 			WARN("line over 80 characters\n" . $herecurr);
 		}
-- 
1.5.6.rc0.140.ga9675

