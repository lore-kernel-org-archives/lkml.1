Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbXA2RXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbXA2RXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXA2RXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:23:35 -0500
Received: from mail.suse.de ([195.135.220.2]:50436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbXA2RXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:23:34 -0500
Date: Mon, 29 Jan 2007 18:23:33 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Utz Bacher <utz.bacher@de.ibm.com>,
       Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix compilation problem with spider network driver on 2.6.20-rc6-mm2
Message-ID: <20070129172333.GA28870@strauss.suse.de>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Utz Bacher <utz.bacher@de.ibm.com>,
	Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation with 2.6.20-rc6-mm1.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/net/spider_net.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/net/spider_net.c
===================================================================
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -1906,8 +1906,7 @@ spider_net_stop(struct net_device *netde
 	spider_net_write_reg(card, SPIDER_NET_GHIINT1MSK, 0);
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
-	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->class_dev.dev)->irq, netdev);
+	free_irq(card->pdev->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
