Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbXGaNNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbXGaNNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761896AbXGaNKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:14 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761677AbXGaNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:10:11 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125444.707405000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:27 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, David Millver <davem@davemloft.net>
Subject: [Patch 11/16] Remove unnecessary kmalloc casts in drivers/net.
Content-Disposition: inline; filename=drivers_net_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: David Millver <davem@davemloft.net>

---
 drivers/net/gianfar.c |    6 ++----
 drivers/net/lance.c   |    3 +--
 drivers/net/s2io.c    |    4 ++--
 drivers/net/sgiseeq.c |    4 ++--
 4 files changed, 7 insertions(+), 10 deletions(-)

Index: b/drivers/net/lance.c
===================================================================
--- a/drivers/net/lance.c
+++ b/drivers/net/lance.c
@@ -539,8 +539,7 @@ static int __init lance_probe1(struct ne
 	if (lance_debug > 6) printk(" (#0x%05lx)", (unsigned long)lp);
 	dev->priv = lp;
 	lp->name = chipname;
-	lp->rx_buffs = (unsigned long)kmalloc(PKT_BUF_SZ*RX_RING_SIZE,
-						  GFP_DMA | GFP_KERNEL);
+	lp->rx_buffs = kmalloc(PKT_BUF_SZ*RX_RING_SIZE, GFP_DMA | GFP_KERNEL);
 	if (!lp->rx_buffs)
 		goto out_lp;
 	if (lance_need_isa_bounce_buffers) {
Index: b/drivers/net/gianfar.c
===================================================================
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -737,8 +737,7 @@ int startup_gfar(struct net_device *dev)
 	gfar_write(&regs->rbase0, addr);
 
 	/* Setup the skbuff rings */
-	priv->tx_skbuff =
-	    (struct sk_buff **) kmalloc(sizeof (struct sk_buff *) *
+	priv->tx_skbuff = kmalloc(sizeof (struct sk_buff *) *
 					priv->tx_ring_size, GFP_KERNEL);
 
 	if (NULL == priv->tx_skbuff) {
@@ -752,8 +751,7 @@ int startup_gfar(struct net_device *dev)
 	for (i = 0; i < priv->tx_ring_size; i++)
 		priv->tx_skbuff[i] = NULL;
 
-	priv->rx_skbuff =
-	    (struct sk_buff **) kmalloc(sizeof (struct sk_buff *) *
+	priv->rx_skbuff = kmalloc(sizeof (struct sk_buff *) *
 					priv->rx_ring_size, GFP_KERNEL);
 
 	if (NULL == priv->rx_skbuff) {
Index: b/drivers/net/s2io.c
===================================================================
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -729,7 +729,7 @@ static int init_shared_mem(struct s2io_n
 				while (k != rxd_count[nic->rxd_mode]) {
 					ba = &mac_control->rings[i].ba[j][k];
 
-					ba->ba_0_org = (void *) kmalloc
+					ba->ba_0_org = kmalloc
 					    (BUF0_LEN + ALIGN_SIZE, GFP_KERNEL);
 					if (!ba->ba_0_org)
 						return -ENOMEM;
@@ -740,7 +740,7 @@ static int init_shared_mem(struct s2io_n
 					tmp &= ~((unsigned long) ALIGN_SIZE);
 					ba->ba_0 = (void *) tmp;
 
-					ba->ba_1_org = (void *) kmalloc
+					ba->ba_1_org = kmalloc
 					    (BUF1_LEN + ALIGN_SIZE, GFP_KERNEL);
 					if (!ba->ba_1_org)
 						return -ENOMEM;
Index: b/drivers/net/sgiseeq.c
===================================================================
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -167,7 +167,7 @@ static int seeq_init_ring(struct net_dev
 		if (!sp->tx_desc[i].tdma.pbuf) {
 			unsigned long buffer;
 
-			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
+			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);
 			if (!buffer)
 				return -ENOMEM;
 			sp->tx_desc[i].buf_vaddr = CKSEG1ADDR(buffer);
@@ -181,7 +181,7 @@ static int seeq_init_ring(struct net_dev
 		if (!sp->rx_desc[i].rdma.pbuf) {
 			unsigned long buffer;
 
-			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
+			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);
 			if (!buffer)
 				return -ENOMEM;
 			sp->rx_desc[i].buf_vaddr = CKSEG1ADDR(buffer);

-- 
