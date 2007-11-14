Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXKNCFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXKNCFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXKNCEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:04:54 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4742 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761251AbXKNCEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:04:52 -0500
Subject: [PATCH] - [2/15] - remove defconfig ptr comparisons to 0 -
	drivers/net
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Chan <mchan@broadcom.com>, Jeff Garzik <jgarzik@pobox.com>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:04:50 -0800
Message-Id: <1195005890.5163.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index da767d3..cec3cb4 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -2495,7 +2495,7 @@ reuse_rx:
 		}
 
 #ifdef BCM_VLAN
-		if ((status & L2_FHDR_STATUS_L2_VLAN_TAG) && (bp->vlgrp != 0)) {
+		if ((status & L2_FHDR_STATUS_L2_VLAN_TAG) && bp->vlgrp) {
 			vlan_hwaccel_receive_skb(skb, bp->vlgrp,
 				rx_hdr->l2_fhdr_vlan_tag);
 		}
@@ -5134,7 +5134,7 @@ bnx2_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		vlan_tag_flags |= TX_BD_FLAGS_TCP_UDP_CKSUM;
 	}
 
-	if (bp->vlgrp != 0 && vlan_tx_tag_present(skb)) {
+	if (bp->vlgrp && vlan_tx_tag_present(skb)) {
 		vlan_tag_flags |=
 			(TX_BD_FLAGS_VLAN_TAG | (vlan_tx_tag_get(skb) << 16));
 	}
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 4942f7d..b189c47 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12576,7 +12576,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 		tg3reg_len = pci_resource_len(pdev, 2);
 
 		tp->aperegs = ioremap_nocache(tg3reg_base, tg3reg_len);
-		if (tp->aperegs == 0UL) {
+		if (!tp->aperegs) {
 			printk(KERN_ERR PFX "Cannot map APE registers, "
 			       "aborting.\n");
 			err = -ENOMEM;


