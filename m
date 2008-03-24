Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYCXOdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYCXOdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbYCXOcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:32:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbYCXOcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:32:52 -0400
Date: Mon, 24 Mar 2008 14:32:49 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@osdl.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] add random irq flag to natsemi network driver
Message-ID: <Pine.LNX.4.64.0803241428040.22437@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please apply this patch. On the embbeded board I work on this is the only
entropy source we have. 

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 385f69c..c6553dd 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1529,7 +1529,8 @@ static int netdev_open(struct net_device *dev)
 	/* Reset the chip, just in case. */
 	natsemi_reset(dev);
 
-	i = request_irq(dev->irq, &intr_handler, IRQF_SHARED, dev->name, dev);
+	i = request_irq(dev->irq, &intr_handler, IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+				dev->name, dev);
 	if (i) return i;
 
 	if (netif_msg_ifup(np))
