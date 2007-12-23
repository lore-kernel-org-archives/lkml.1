Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXLWXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXLWXI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXLWXHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:07:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:7285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbXLWXHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TU6j2qsWvSm6YOhQwoc0QZk/55HkGWazrnEWAdGOfV9uJQ9mJ97UrkTfh/0Kv11hZlhzQS1s4s7fKzLaUZOcgXiZYtMEVtjpaR6zj2/54KFCAIc15p/sZBA+AD/I6h1WpP2ZD2u2prin/gHXCv68ZqiU2uKut4PF4quxvh+Wbi0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide-{floppy,tape}: remove debug code for dumping identify data
Date: Sun, 23 Dec 2007 22:44:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232244.44619.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


IDE core supports dumping raw identify data in hdparm friendly format now
so verbose identify dumping in ide-{floppy,tape}.c device drivers (done iff
IDE{FLOPPY,TAPE}_DEBUG_INFO is defined to '1' and it is '0' by default)
is no longer nedeed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   50 ---------------------------------------
 drivers/ide/ide-tape.c   |   59 -----------------------------------------------
 2 files changed, 109 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1658,7 +1658,6 @@ static int idefloppy_identify_device (id
 {
 	struct idefloppy_id_gcw gcw;
 #if IDEFLOPPY_DEBUG_INFO
-	u16 mask,i;
 	char buffer[80];
 #endif /* IDEFLOPPY_DEBUG_INFO */
 
@@ -1705,55 +1704,6 @@ static int idefloppy_identify_device (id
 		default: sprintf(buffer, "Reserved");break;
 	}
 	printk(KERN_INFO "Command Packet Size: %s\n", buffer);
-	printk(KERN_INFO "Model: %.40s\n",id->model);
-	printk(KERN_INFO "Firmware Revision: %.8s\n",id->fw_rev);
-	printk(KERN_INFO "Serial Number: %.20s\n",id->serial_no);
-	printk(KERN_INFO "Write buffer size(?): %d bytes\n",id->buf_size*512);
-	printk(KERN_INFO "DMA: %s",id->capability & 0x01 ? "Yes\n":"No\n");
-	printk(KERN_INFO "LBA: %s",id->capability & 0x02 ? "Yes\n":"No\n");
-	printk(KERN_INFO "IORDY can be disabled: %s",id->capability & 0x04 ? "Yes\n":"No\n");
-	printk(KERN_INFO "IORDY supported: %s",id->capability & 0x08 ? "Yes\n":"Unknown\n");
-	printk(KERN_INFO "ATAPI overlap supported: %s",id->capability & 0x20 ? "Yes\n":"No\n");
-	printk(KERN_INFO "PIO Cycle Timing Category: %d\n",id->tPIO);
-	printk(KERN_INFO "DMA Cycle Timing Category: %d\n",id->tDMA);
-	printk(KERN_INFO "Single Word DMA supported modes:\n");
-	for (i=0,mask=1;i<8;i++,mask=mask << 1) {
-		if (id->dma_1word & mask)
-			printk(KERN_INFO "   Mode %d%s\n", i,
-			(id->dma_1word & (mask << 8)) ? " (active)" : "");
-	}
-	printk(KERN_INFO "Multi Word DMA supported modes:\n");
-	for (i=0,mask=1;i<8;i++,mask=mask << 1) {
-		if (id->dma_mword & mask)
-			printk(KERN_INFO "   Mode %d%s\n", i,
-			(id->dma_mword & (mask << 8)) ? " (active)" : "");
-	}
-	if (id->field_valid & 0x0002) {
-		printk(KERN_INFO "Enhanced PIO Modes: %s\n",
-			id->eide_pio_modes & 1 ? "Mode 3":"None");
-		if (id->eide_dma_min == 0)
-			sprintf(buffer, "Not supported");
-		else
-			sprintf(buffer, "%d ns",id->eide_dma_min);
-		printk(KERN_INFO "Minimum Multi-word DMA cycle per word: %s\n", buffer);
-		if (id->eide_dma_time == 0)
-			sprintf(buffer, "Not supported");
-		else
-			sprintf(buffer, "%d ns",id->eide_dma_time);
-		printk(KERN_INFO "Manufacturer\'s Recommended Multi-word cycle: %s\n", buffer);
-		if (id->eide_pio == 0)
-			sprintf(buffer, "Not supported");
-		else
-			sprintf(buffer, "%d ns",id->eide_pio);
-		printk(KERN_INFO "Minimum PIO cycle without IORDY: %s\n",
-			buffer);
-		if (id->eide_pio_iordy == 0)
-			sprintf(buffer, "Not supported");
-		else
-			sprintf(buffer, "%d ns",id->eide_pio_iordy);
-		printk(KERN_INFO "Minimum PIO cycle with IORDY: %s\n", buffer);
-	} else
-		printk(KERN_INFO "According to the device, fields 64-70 are not valid.\n");
 #endif /* IDEFLOPPY_DEBUG_INFO */
 
 	if (gcw.protocol != 2)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -4291,9 +4291,6 @@ static int idetape_identify_device (ide_
 {
 	struct idetape_id_gcw gcw;
 	struct hd_driveid *id = drive->id;
-#if IDETAPE_DEBUG_INFO
-	unsigned short mask,i;
-#endif /* IDETAPE_DEBUG_INFO */
 
 	if (drive->id_read == 0)
 		return 1;
@@ -4333,62 +4330,6 @@ static int idetape_identify_device (ide_
 		case 1: printk("16 bytes\n");break;
 		default: printk("Reserved\n");break;
 	}
-	printk(KERN_INFO "ide-tape: Model: %.40s\n",id->model);
-	printk(KERN_INFO "ide-tape: Firmware Revision: %.8s\n",id->fw_rev);
-	printk(KERN_INFO "ide-tape: Serial Number: %.20s\n",id->serial_no);
-	printk(KERN_INFO "ide-tape: Write buffer size: %d bytes\n",id->buf_size*512);
-	printk(KERN_INFO "ide-tape: DMA: %s",id->capability & 0x01 ? "Yes\n":"No\n");
-	printk(KERN_INFO "ide-tape: LBA: %s",id->capability & 0x02 ? "Yes\n":"No\n");
-	printk(KERN_INFO "ide-tape: IORDY can be disabled: %s",id->capability & 0x04 ? "Yes\n":"No\n");
-	printk(KERN_INFO "ide-tape: IORDY supported: %s",id->capability & 0x08 ? "Yes\n":"Unknown\n");
-	printk(KERN_INFO "ide-tape: ATAPI overlap supported: %s",id->capability & 0x20 ? "Yes\n":"No\n");
-	printk(KERN_INFO "ide-tape: PIO Cycle Timing Category: %d\n",id->tPIO);
-	printk(KERN_INFO "ide-tape: DMA Cycle Timing Category: %d\n",id->tDMA);
-	printk(KERN_INFO "ide-tape: Single Word DMA supported modes: ");
-	for (i=0,mask=1;i<8;i++,mask=mask << 1) {
-		if (id->dma_1word & mask)
-			printk("%d ",i);
-		if (id->dma_1word & (mask << 8))
-			printk("(active) ");
-	}
-	printk("\n");
-	printk(KERN_INFO "ide-tape: Multi Word DMA supported modes: ");
-	for (i=0,mask=1;i<8;i++,mask=mask << 1) {
-		if (id->dma_mword & mask)
-			printk("%d ",i);
-		if (id->dma_mword & (mask << 8))
-			printk("(active) ");
-	}
-	printk("\n");
-	if (id->field_valid & 0x0002) {
-		printk(KERN_INFO "ide-tape: Enhanced PIO Modes: %s\n",
-			id->eide_pio_modes & 1 ? "Mode 3":"None");
-		printk(KERN_INFO "ide-tape: Minimum Multi-word DMA cycle per word: ");
-		if (id->eide_dma_min == 0)
-			printk("Not supported\n");
-		else
-			printk("%d ns\n",id->eide_dma_min);
-
-		printk(KERN_INFO "ide-tape: Manufacturer\'s Recommended Multi-word cycle: ");
-		if (id->eide_dma_time == 0)
-			printk("Not supported\n");
-		else
-			printk("%d ns\n",id->eide_dma_time);
-
-		printk(KERN_INFO "ide-tape: Minimum PIO cycle without IORDY: ");
-		if (id->eide_pio == 0)
-			printk("Not supported\n");
-		else
-			printk("%d ns\n",id->eide_pio);
-
-		printk(KERN_INFO "ide-tape: Minimum PIO cycle with IORDY: ");
-		if (id->eide_pio_iordy == 0)
-			printk("Not supported\n");
-		else
-			printk("%d ns\n",id->eide_pio_iordy);
-		
-	} else
-		printk(KERN_INFO "ide-tape: According to the device, fields 64-70 are not valid.\n");
 #endif /* IDETAPE_DEBUG_INFO */
 
 	/* Check that we can support this device */
