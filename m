Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZKHQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZKHQAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZKHQAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:00:33 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:60905 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZKHQAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:00:32 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH]Use DMA_BIT_MASK(44) instead of deprecated DMA_44BIT_MASK
Date: Sun, 8 Nov 2009 17:59:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc6; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911081759.27263.mitov@issp.bas.bg>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Use DMA_BIT_MASK(44) instead of deprecated DMA_44BIT_MASK

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=========================================================
--- a/drivers/net/niu.c	2009-11-08 17:09:40.000000000 +0200
+++ b/drivers/net/niu.c	2009-11-08 17:10:31.000000000 +0200
@@ -45,10 +45,6 @@
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-#ifndef DMA_44BIT_MASK
-#define DMA_44BIT_MASK	0x00000fffffffffffULL
-#endif
-
 #ifndef readq
 static u64 readq(void __iomem *reg)
 {
@@ -9915,7 +9911,7 @@
 		  PCI_EXP_DEVCTL_RELAX_EN);
 	pci_write_config_word(pdev, pos + PCI_EXP_DEVCTL, val16);
 
-	dma_mask = DMA_44BIT_MASK;
+	dma_mask = DMA_BIT_MASK(44);
 	err = pci_set_dma_mask(pdev, dma_mask);
 	if (!err) {
 		dev->features |= NETIF_F_HIGHDMA;
