Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYHQRTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYHQRTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYHQRST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:18:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:30781 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbYHQRSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QhYbwFEMG8S26D8pfhsdXekM9silA8tYGfz40zp4qN9hFzNO9Qt9E7Dt6koFXcAGww
         mq+KfDI0SmxmParXdTF7m5y2D3Zz5vUpfVtg8uJjiVLFc1dJtUuGVOtUYYaoru2B+3gL
         7ZK5w23Jd8zrKBR4jH+CfTj+0vG8mdyP598kw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:15:56 +0200
Message-Id: <20080817171556.27943.29369.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: remove superfluous ->waiting_for_dma checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c         |    4 +---
 drivers/ide/mips/au1xxx-ide.c |    6 +-----
 drivers/ide/pci/hpt366.c      |    3 ---
 drivers/ide/pci/scc_pata.c    |    3 ---
 drivers/ide/ppc/pmac.c        |    3 ---
 5 files changed, 2 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -578,9 +578,7 @@ int ide_dma_test_irq(ide_drive_t *drive)
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
 		return 1;
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __func__);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_dma_test_irq);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -322,11 +322,7 @@ static int auide_dma_setup(ide_drive_t *
 }
 
 static int auide_dma_test_irq(ide_drive_t *drive)
-{	
-	if (drive->waiting_for_dma == 0)
-		printk(KERN_WARNING "%s: ide_dma_test_irq \
-                                     called while not waiting\n", drive->name);
-
+{
 	/* If dbdma didn't execute the STOP command yet, the
 	 * active bit is still set
 	 */
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -861,9 +861,6 @@ static int hpt374_dma_test_irq(ide_drive
 	if (dma_stat & 4)
 		return 1;
 
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-				drive->name, __func__);
 	return 0;
 }
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -509,9 +509,6 @@ static int scc_dma_test_irq(ide_drive_t 
 	if (int_stat & INTSTS_IOIRQS)
 		return 1;
 
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __func__);
 	return 0;
 }
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1672,9 +1672,6 @@ pmac_ide_dma_test_irq (ide_drive_t *driv
 	status = readl(&dma->status);
 	if (!(status & ACTIVE))
 		return 1;
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			called while not waiting\n", HWIF(drive)->index);
 
 	/* If dbdma didn't execute the STOP command yet, the
 	 * active bit is still set. We consider that we aren't
