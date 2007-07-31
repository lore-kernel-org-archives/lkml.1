Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbXGaNNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbXGaNNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbXGaNKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:08 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761766AbXGaNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:10:05 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125446.122349000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:29 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, John Linville <linville@tuxdriver.com>
Subject: [Patch 13/16] Remove needless kmalloc casts in the wireless drivers.
Content-Disposition: inline; filename=drivers_net_wireless_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: John Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/ipw2100.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

Index: b/drivers/net/wireless/ipw2100.c
===================================================================
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -3363,11 +3363,9 @@ static int ipw2100_msg_allocate(struct i
 	void *v;
 	dma_addr_t p;
 
-	priv->msg_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(IPW_COMMAND_POOL_SIZE *
-						sizeof(struct
-						       ipw2100_tx_packet),
-						GFP_KERNEL);
+	priv->msg_buffers = kmalloc(IPW_COMMAND_POOL_SIZE *
+					sizeof(struct ipw2100_tx_packet),
+					GFP_KERNEL);
 	if (!priv->msg_buffers) {
 		printk(KERN_ERR DRV_NAME ": %s: PCI alloc failed for msg "
 		       "buffers.\n", priv->net_dev->name);
@@ -4396,11 +4394,9 @@ static int ipw2100_tx_allocate(struct ip
 		return err;
 	}
 
-	priv->tx_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(TX_PENDED_QUEUE_LENGTH *
-						sizeof(struct
-						       ipw2100_tx_packet),
-						GFP_ATOMIC);
+	priv->tx_buffers = kmalloc(TX_PENDED_QUEUE_LENGTH *
+					sizeof(struct ipw2100_tx_packet),
+					GFP_ATOMIC);
 	if (!priv->tx_buffers) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: alloc failed form tx buffers.\n",

-- 
