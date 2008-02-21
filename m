Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbYBUNSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbYBUNSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYBUNRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:17:55 -0500
Received: from 75.neteffect.com ([204.57.75.75]:63866 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbYBUNRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:17:54 -0500
Date: Thu, 21 Feb 2008 08:12:06 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211412.m1LEC6Pt005040@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 3/8] infiniband/hw/nes/nes_cm.c: fix a memory leak
Cc: bunk@kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes a memory leak spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
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
