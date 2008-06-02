Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYFBJ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYFBJ7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYFBJ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32963 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYFBJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] s2io iomem annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yv-HU@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index a20693e..b5c1e66 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -2861,7 +2861,8 @@ static int s2io_poll_msix(struct napi_struct *napi, int budget)
 	struct config_param *config;
 	struct mac_info *mac_control;
 	int pkts_processed = 0;
-	u8 *addr = NULL, val8 = 0;
+	u8 __iomem *addr = NULL;
+	u8 val8 = 0;
 	struct s2io_nic *nic = dev->priv;
 	struct XENA_dev_config __iomem *bar0 = nic->bar0;
 	int budget_org = budget;
@@ -2878,7 +2879,7 @@ static int s2io_poll_msix(struct napi_struct *napi, int budget)
 	if (pkts_processed < budget_org) {
 		netif_rx_complete(dev, napi);
 		/*Re Enable MSI-Rx Vector*/
-		addr = (u8 *)&bar0->xmsi_mask_reg;
+		addr = (u8 __iomem *)&bar0->xmsi_mask_reg;
 		addr += 7 - ring->ring_no;
 		val8 = (ring->ring_no == 0) ? 0x3f : 0xbf;
 		writeb(val8, addr);
@@ -4364,9 +4365,10 @@ static irqreturn_t s2io_msix_ring_handle(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	if (sp->config.napi) {
-		u8 *addr = NULL, val8 = 0;
+		u8 __iomem *addr = NULL;
+		u8 val8 = 0;
 
-		addr = (u8 *)&bar0->xmsi_mask_reg;
+		addr = (u8 __iomem *)&bar0->xmsi_mask_reg;
 		addr += (7 - ring->ring_no);
 		val8 = (ring->ring_no == 0) ? 0x7f : 0xff;
 		writeb(val8, addr);
