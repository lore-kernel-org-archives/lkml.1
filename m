Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYBTAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYBTAOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYBTAOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:14:21 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36198 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYBTAOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:14:17 -0500
Date: Wed, 20 Feb 2008 02:13:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/nes/nes_cm.c: fix a memory leak
Message-ID: <20080220001340.GT31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2d899a9f01001b2cccc210972b199b951b67ed51 diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index bd5cfea..78e845c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -370,11 +370,11 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	int ret = 0;
 	u32 was_timer_set;
 
+	if (!cm_node)
+		return -EINVAL;
 	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
 	if (!new_send)
 		return -1;
-	if (!cm_node)
-		return -EINVAL;
 
 	/* new_send->timetosend = currenttime */
 	new_send->retrycount = NES_DEFAULT_RETRYS;

