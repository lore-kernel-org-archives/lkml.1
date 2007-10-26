Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbXJZJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbXJZJmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXJZJlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:41:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60316 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668AbXJZJlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:41:00 -0400
To: LKML <linux-kernel@vger.kernel.org>
Message-Id: <bdce59bb00f2095c934e9931df2689e636673622.1193390975.git.jeff@garzik.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, samuel@sortiz.org, netdev@vger.kernel.org
Subject: [PATCH] drivers/net/irda/au1k_ir: fix obvious irq handler bugs
Date: Fri, 26 Oct 2007 05:40:29 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt handlers return a return value these days.

Also, kill always-true test and unneeded void* cast.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/net/irda/au1k_ir.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index 4dbdfaa..a1e4508 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -627,19 +627,16 @@ static int au1k_irda_rx(struct net_device *dev)
 }
 
 
-void au1k_irda_interrupt(int irq, void *dev_id)
+static irqreturn_t au1k_irda_interrupt(int dummy, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *) dev_id;
-
-	if (dev == NULL) {
-		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
-		return;
-	}
+	struct net_device *dev = dev_id;
 
 	writel(0, IR_INT_CLEAR); /* ack irda interrupts */
 
 	au1k_irda_rx(dev);
 	au1k_tx_ack(dev);
+
+	return IRQ_HANDLED;
 }
 
 
-- 
1.5.2.4

