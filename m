Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXJUHxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXJUHxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXJUHw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33958 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXJUHwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:24 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: paulkf@microgate.com
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 5/17] drivers/char/pcmcia/synclink_cs.c: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075222.9320A19041B@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:22 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1c354fd1d5dd786a19d30ba4e2ae664be8f348ff
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 16:39:55 2007 -0400

    drivers/char/pcmcia/synclink_cs.c: irq handler cleanups
    
    No need to reference 'irq' function arg.
    
    Remove pointless test.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/pcmcia/synclink_cs.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

1c354fd1d5dd786a19d30ba4e2ae664be8f348ff
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 8caff0c..8f3a123 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -1226,17 +1226,15 @@ static void ri_change(MGSLPC_INFO *info)
  * irq     interrupt number that caused interrupt
  * dev_id  device ID supplied during interrupt registration
  */
-static irqreturn_t mgslpc_isr(int irq, void *dev_id)
+static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 {
-	MGSLPC_INFO * info = (MGSLPC_INFO *)dev_id;
+	MGSLPC_INFO *info = dev_id;
 	unsigned short isr;
 	unsigned char gis, pis;
 	int count=0;
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
-		printk("mgslpc_isr(%d) entry.\n", irq);
-	if (!info)
-		return IRQ_NONE;
+		printk("mgslpc_isr(%d) entry.\n", info->irq_level);
 
 	if (!(info->p_dev->_locked))
 		return IRQ_HANDLED;
@@ -1328,7 +1326,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):mgslpc_isr(%d)exit.\n",
-		       __FILE__,__LINE__,irq);
+		       __FILE__, __LINE__, info->irq_level);
 
 	return IRQ_HANDLED;
 }
