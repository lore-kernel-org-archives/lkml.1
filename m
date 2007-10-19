Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbXJSHeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbXJSHeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966712AbXJSHd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:33:57 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35804 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966917AbXJSHd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:33:56 -0400
Date: Fri, 19 Oct 2007 03:33:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] aha152x: delete pointless test in irq handler
Message-ID: <20071019073354.GA5766@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit c8f14a99beb85918935334a8374e47db12608d8e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 03:17:14 2007 -0400

    [SCSI] aha152x: delete pointless test in irq handler
    
    Remove always-false test in interrupt handler.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/scsi/aha152x.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

c8f14a99beb85918935334a8374e47db12608d8e
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f08e71e..973778a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1439,15 +1439,10 @@ static void run(struct work_struct *work)
  */
 static irqreturn_t intr(int irqno, void *dev_id)
 {
-	struct Scsi_Host *shpnt = (struct Scsi_Host *)dev_id;
+	struct Scsi_Host *shpnt = dev_id;
 	unsigned long flags;
 	unsigned char rev, dmacntrl0;
 
-	if (!shpnt) {
-		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * Read a couple of registers that are known to not be all 1's. If
 	 * we read all 1's (-1), that means that either:
