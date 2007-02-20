Return-Path: <linux-kernel-owner+w=401wt.eu-S1030515AbXBTWcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515AbXBTWcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030514AbXBTWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:32:05 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42473 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbXBTWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:32:03 -0500
Date: Tue, 20 Feb 2007 16:32:00 -0600
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kou.ishizaki@toshiba.co.jp, arnd@arndb.de,
       Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/12] spidernet: compile break.
Message-ID: <20070220223200.GB28895@austin.ibm.com>
References: <20070220221314.GU923@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220221314.GU923@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As of 2.6.20-git4, the spider_net driver does not compile. 
This appears to be due to some archaic usage involving kobjects.

It also fixes a nasty double-free during ifdown of the interface.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

----
 drivers/net/spider_net.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6.20-git16/drivers/net/spider_net.c
===================================================================
--- linux-2.6.20-git16.orig/drivers/net/spider_net.c	2007-02-20 14:24:00.000000000 -0600
+++ linux-2.6.20-git16/drivers/net/spider_net.c	2007-02-20 14:36:13.000000000 -0600
@@ -1906,8 +1906,7 @@ spider_net_stop(struct net_device *netde
 	spider_net_write_reg(card, SPIDER_NET_GHIINT1MSK, 0);
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
-	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->dev.parent)->irq, netdev);
+	free_irq(netdev->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
@@ -1919,8 +1918,6 @@ spider_net_stop(struct net_device *netde
 	spider_net_release_tx_chain(card, 1);
 	spider_net_free_rx_chain_contents(card);
 
-	spider_net_free_rx_chain_contents(card);
-
 	spider_net_free_chain(card, &card->tx_chain);
 	spider_net_free_chain(card, &card->rx_chain);
 
