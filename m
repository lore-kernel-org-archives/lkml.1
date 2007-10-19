Return-Path: <linux-kernel-owner+w=401wt.eu-S966607AbXJSHbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966607AbXJSHbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763093AbXJSHbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:31:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39684 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbXJSHbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:31:33 -0400
Date: Fri, 19 Oct 2007 03:31:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bluetooth: Eliminate checks for impossible conditions in
	irq handler
Message-ID: <20071019073132.GA5678@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 1c8073a42f133bf5780099c1e6efd9e48468cd29
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 03:07:30 2007 -0400

    [BLUETOOTH] Eliminate checks for impossible conditions in irq handler
    
    Our info structure and info->hdev is always passed to the irq handler,
    so we don't have to worry about these checks in every interrupt.
    
    Leave a BUG_ON() just to help unwary programmers, but these could
    probably be removed as well.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/bluetooth/bluecard_cs.c |    5 +----
 drivers/bluetooth/bt3c_cs.c     |    5 +----
 drivers/bluetooth/btuart_cs.c   |    5 +----
 drivers/bluetooth/dtl1_cs.c     |    5 +----
 4 files changed, 4 insertions(+), 16 deletions(-)

1c8073a42f133bf5780099c1e6efd9e48468cd29
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index 851de4d..bcf5792 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -503,10 +503,7 @@ static irqreturn_t bluecard_interrupt(int irq, void *dev_inst)
 	unsigned int iobase;
 	unsigned char reg;
 
-	if (!info || !info->hdev) {
-		BT_ERR("Call of irq %d for unknown device", irq);
-		return IRQ_NONE;
-	}
+	BUG_ON(!info->hdev);
 
 	if (!test_bit(CARD_READY, &(info->hw_state)))
 		return IRQ_HANDLED;
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 3951607..a18f9b8 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -344,10 +344,7 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 	unsigned int iobase;
 	int iir;
 
-	if (!info || !info->hdev) {
-		BT_ERR("Call of irq %d for unknown device", irq);
-		return IRQ_NONE;
-	}
+	BUG_ON(!info->hdev);
 
 	iobase = info->p_dev->io.BasePort1;
 
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index d7d2ea0..08f48d5 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -294,10 +294,7 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 	int boguscount = 0;
 	int iir, lsr;
 
-	if (!info || !info->hdev) {
-		BT_ERR("Call of irq %d for unknown device", irq);
-		return IRQ_NONE;
-	}
+	BUG_ON(!info->hdev);
 
 	iobase = info->p_dev->io.BasePort1;
 
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 7f9c54b..dae45cd 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -298,10 +298,7 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 	int boguscount = 0;
 	int iir, lsr;
 
-	if (!info || !info->hdev) {
-		BT_ERR("Call of irq %d for unknown device", irq);
-		return IRQ_NONE;
-	}
+	BUG_ON(!info->hdev);
 
 	iobase = info->p_dev->io.BasePort1;
 
