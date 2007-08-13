Return-Path: <linux-kernel-owner+w=401wt.eu-S1031734AbXHMNpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031734AbXHMNpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXHMKOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:14:00 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:44204 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734AbXHMKN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:13:57 -0400
Subject: drivers/net/tokenring/3c359.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: mikep@linuxtr.net, netdev@vger.kernel.org
Cc: linux-tr@linuxtr.net, Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:43:30 +0530
Message-Id: <1187000010.29518.27.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 10:14:16.0178 (UTC) FILETIME=[B4367520:01C7DD92]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in 
drivers/net/tokenring/3c359.c


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
---

diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 9f1b6ab..d36dd53 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -641,14 +641,14 @@ static int xl_open(struct net_device *dev)
 	 * Now to set up the Rx and Tx buffer structures
 	 */
 	/* These MUST be on 8 byte boundaries */
-	xl_priv->xl_tx_ring = kmalloc((sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) + 7, GFP_DMA | GFP_KERNEL) ; 
+	xl_priv->xl_tx_ring = kzalloc((sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) + 7, GFP_DMA | GFP_KERNEL) ; 
 	if (xl_priv->xl_tx_ring == NULL) {
 		printk(KERN_WARNING "%s: Not enough memory to allocate rx buffers.\n",
 				     dev->name);
 		free_irq(dev->irq,dev);
 		return -ENOMEM;
 	}
-	xl_priv->xl_rx_ring = kmalloc((sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) +7, GFP_DMA | GFP_KERNEL) ; 
+	xl_priv->xl_rx_ring = kzalloc((sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) +7, GFP_DMA | GFP_KERNEL) ; 
 	if (xl_priv->xl_tx_ring == NULL) {
 		printk(KERN_WARNING "%s: Not enough memory to allocate rx buffers.\n",
 				     dev->name);
@@ -656,8 +656,6 @@ static int xl_open(struct net_device *dev)
 		kfree(xl_priv->xl_tx_ring);
 		return -ENOMEM;
 	}
-	memset(xl_priv->xl_tx_ring,0,sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) ; 
-	memset(xl_priv->xl_rx_ring,0,sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) ; 
 
 	 /* Setup Rx Ring */
 	 for (i=0 ; i < XL_RX_RING_SIZE ; i++) { 

--
thanks
surya.
