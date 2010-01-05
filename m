Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043Ab0AEQnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0AEQnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320Ab0AEQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:43:17 -0500
Received: from [206.15.93.42] ([206.15.93.42]:7203 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751201Ab0AEQnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:43:16 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/infiniband/hw/cxgb3/iwch_cm.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:43:16 -0700
Cc: swise@opengridcomputing.com, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050943.16904.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 66b4135..d94388b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1371,15 +1371,8 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	tim.mac_addr = req->dst_mac;
 	tim.vlan_tag = ntohs(req->vlan_tag);
 	if (tdev->ctl(tdev, GET_IFF_FROM_MAC, &tim) < 0 || !tim.dev) {
-		printk(KERN_ERR
-			"%s bad dst mac %02x %02x %02x %02x %02x %02x\n",
-			__func__,
-			req->dst_mac[0],
-			req->dst_mac[1],
-			req->dst_mac[2],
-			req->dst_mac[3],
-			req->dst_mac[4],
-			req->dst_mac[5]);
+		printk(KERN_ERR "%s bad dst mac %pM\n",
+			__func__, req->dst_mac);
 		goto reject;
 	}
 
