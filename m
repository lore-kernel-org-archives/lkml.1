Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYFLMbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYFLMbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbYFLMav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:30:51 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3403 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760975AbYFLMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:30:50 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 11/23] checkpatch: switch -- report trailing statements on case and default
Date: Thu, 12 Jun 2008 13:05:50 +0100
Message-Id: <1213272362-19457-12-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report trailing statements on case and default lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 614999f..5f71b30 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1244,6 +1244,10 @@ sub process {
 				ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
+		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
+		    $line !~ /\G(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$/g) {
+			ERROR("trailing statements should be on next line\n" . $herecurr);
+		}
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-- 
1.5.6.rc0.140.ga9675

