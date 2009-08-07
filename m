Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbZHGNVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbZHGNVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZHGNVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:21:09 -0400
Received: from baron.coraid.com ([12.51.113.4]:52893 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755999AbZHGNVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:21:08 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 09:21:08 EDT
From: Ed Cashin <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH] aoe: ensure that AoE minor address is supported
Date: Fri,  7 Aug 2009 09:05:19 -0400
Message-Id: <1249650319-1646-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This aoe driver only supports a fixed number of AoE minor ("slot")
addresses per major ("shelf") address.  This check ensures that the
minor address is supported and clarifies the diagnostic message.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---

I plan to put this patch in the aoe quilt tree for linux-next.

 drivers/block/aoe/aoecmd.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 965ece2..437b95b 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -982,8 +982,12 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	}
 
 	sysminor = SYSMINOR(aoemajor, h->minor);
-	if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
-		printk(KERN_INFO "aoe: e%ld.%d: minor number too large\n",
+	if (h->minor >= NPERSHELF) {
+		printk(KERN_INFO "aoe: e%ld.%d: AoE minor address too large\n",
+			aoemajor, (int) h->minor);
+		return;
+	} else if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
+		printk(KERN_INFO "aoe: e%ld.%d: AoE major address too large\n",
 			aoemajor, (int) h->minor);
 		return;
 	}
-- 
1.5.6.5

