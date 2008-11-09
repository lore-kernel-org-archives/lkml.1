Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYKIQ1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYKIQ1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYKIQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:24:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbYKIQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rtLbznsountBZiLcJ1obCPZU3mOyyw54b2tQe7PDcD+E11YMwA2jnkSmjyJBjzLPdW
         SgwnFwl/1OPEM3eNG+DLlVyKOnyTTZgdLOcfj+b3b5wdwqGIWg2H/iEOclesLaHxdHBd
         uL1ZT8LKFBMd5h/oC2ZPQzAXG6gw3xO3L1SOE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:22:54 +0100
Message-Id: <20081109162254.18999.52497.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/11] ide: checkpatch.pl fixes for ide-lib.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: checkpatch.pl fixes for ide-lib.c

Fix following errors/warnings detected by checkpatch.pl:

- WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
- WARNING: space prohibited between function name and open parenthesis '('
- ERROR: trailing whitespace
- ERROR: trailing statements should be on next line
- WARNING: printk() should include KERN_ facility level

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |   95 ++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 41 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -43,7 +43,6 @@ const char *ide_xfer_verbose(u8 mode)
 
 	return s;
 }
-
 EXPORT_SYMBOL(ide_xfer_verbose);
 
 /**
@@ -87,7 +86,7 @@ static u8 ide_rate_filter(ide_drive_t *d
  *	This is used by most chipset support modules when "auto-tuning".
  */
 
-u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
+u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 {
 	u16 *id = drive->id;
 	int pio_mode = -1, overridden = 0;
@@ -131,7 +130,6 @@ u8 ide_get_best_pio_mode (ide_drive_t *d
 
 	return pio_mode;
 }
-
 EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
 
 /* req_pio == "255" for auto-tune */
@@ -162,7 +160,6 @@ void ide_set_pio(ide_drive_t *drive, u8 
 
 	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
 }
-
 EXPORT_SYMBOL_GPL(ide_set_pio);
 
 /**
@@ -173,7 +170,7 @@ EXPORT_SYMBOL_GPL(ide_set_pio);
  *	Enable or disable bounce buffering for the device. Drives move
  *	between PIO and DMA and that changes the rules we need.
  */
- 
+
 void ide_toggle_bounce(ide_drive_t *drive, int on)
 {
 	u64 addr = BLK_BOUNCE_HIGH;	/* dma64_addr_t */
@@ -243,14 +240,13 @@ int ide_set_dma_mode(ide_drive_t *drive,
 		return ide_config_drive_speed(drive, mode);
 	}
 }
-
 EXPORT_SYMBOL_GPL(ide_set_dma_mode);
 
 /**
  *	ide_set_xfer_rate	-	set transfer rate
  *	@drive: drive to set
  *	@rate: speed to attempt to set
- *	
+ *
  *	General helper for setting the speed of an IDE device. This
  *	function knows about user enforced limits from the configuration
  *	which ->set_pio_mode/->set_dma_mode does not.
@@ -286,7 +282,7 @@ static void ide_dump_opcode(ide_drive_t 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 		task = rq->special;
 
-	printk("ide: failed opcode was: ");
+	printk(KERN_ERR "ide: failed opcode was: ");
 	if (task == NULL)
 		printk(KERN_CONT "unknown\n");
 	else
@@ -324,44 +320,55 @@ static void ide_dump_sector(ide_drive_t 
 	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	if (lba48 || (tf->device & ATA_LBA))
-		printk(", LBAsect=%llu",
+		printk(KERN_CONT ", LBAsect=%llu",
 			(unsigned long long)ide_get_lba_addr(tf, lba48));
 	else
-		printk(", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
-					 tf->device & 0xf, tf->lbal);
+		printk(KERN_CONT ", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
+			tf->device & 0xf, tf->lbal);
 }
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk("{ ");
-	if (err & ATA_ABORTED)	printk("DriveStatusError ");
+	printk(KERN_ERR "{ ");
+	if (err & ATA_ABORTED)
+		printk(KERN_CONT "DriveStatusError ");
 	if (err & ATA_ICRC)
-		printk((err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
-	if (err & ATA_UNC)	printk("UncorrectableError ");
-	if (err & ATA_IDNF)	printk("SectorIdNotFound ");
-	if (err & ATA_TRK0NF)	printk("TrackZeroNotFound ");
-	if (err & ATA_AMNF)	printk("AddrMarkNotFound ");
-	printk("}");
+		printk(KERN_CONT "%s",
+			(err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
+	if (err & ATA_UNC)
+		printk(KERN_CONT "UncorrectableError ");
+	if (err & ATA_IDNF)
+		printk(KERN_CONT "SectorIdNotFound ");
+	if (err & ATA_TRK0NF)
+		printk(KERN_CONT "TrackZeroNotFound ");
+	if (err & ATA_AMNF)
+		printk(KERN_CONT "AddrMarkNotFound ");
+	printk(KERN_CONT "}");
 	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
 	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
 		ide_dump_sector(drive);
 		if (HWGROUP(drive) && HWGROUP(drive)->rq)
-			printk(", sector=%llu",
+			printk(KERN_CONT ", sector=%llu",
 			       (unsigned long long)HWGROUP(drive)->rq->sector);
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk("{ ");
-	if (err & ATAPI_ILI)	printk("IllegalLengthIndication ");
-	if (err & ATAPI_EOM)	printk("EndOfMedia ");
-	if (err & ATA_ABORTED)	printk("AbortedCommand ");
-	if (err & ATA_MCR)	printk("MediaChangeRequested ");
-	if (err & ATAPI_LFS)	printk("LastFailedSense=0x%02x ",
-				       (err & ATAPI_LFS) >> 4);
-	printk("}\n");
+	printk(KERN_ERR "{ ");
+	if (err & ATAPI_ILI)
+		printk(KERN_CONT "IllegalLengthIndication ");
+	if (err & ATAPI_EOM)
+		printk(KERN_CONT "EndOfMedia ");
+	if (err & ATA_ABORTED)
+		printk(KERN_CONT "AbortedCommand ");
+	if (err & ATA_MCR)
+		printk(KERN_CONT "MediaChangeRequested ");
+	if (err & ATAPI_LFS)
+		printk(KERN_CONT "LastFailedSense=0x%02x ",
+			(err & ATAPI_LFS) >> 4);
+	printk(KERN_CONT "}\n");
 }
 
 /**
@@ -381,22 +388,29 @@ u8 ide_dump_status(ide_drive_t *drive, c
 	u8 err = 0;
 
 	local_irq_save(flags);
-	printk("%s: %s: status=0x%02x { ", drive->name, msg, stat);
+	printk(KERN_ERR "%s: %s: status=0x%02x { ", drive->name, msg, stat);
 	if (stat & ATA_BUSY)
-		printk("Busy ");
+		printk(KERN_CONT "Busy ");
 	else {
-		if (stat & ATA_DRDY)	printk("DriveReady ");
-		if (stat & ATA_DF)	printk("DeviceFault ");
-		if (stat & ATA_DSC)	printk("SeekComplete ");
-		if (stat & ATA_DRQ)	printk("DataRequest ");
-		if (stat & ATA_CORR)	printk("CorrectedError ");
-		if (stat & ATA_IDX)	printk("Index ");
-		if (stat & ATA_ERR)	printk("Error ");
+		if (stat & ATA_DRDY)
+			printk(KERN_CONT "DriveReady ");
+		if (stat & ATA_DF)
+			printk(KERN_CONT "DeviceFault ");
+		if (stat & ATA_DSC)
+			printk(KERN_CONT "SeekComplete ");
+		if (stat & ATA_DRQ)
+			printk(KERN_CONT "DataRequest ");
+		if (stat & ATA_CORR)
+			printk(KERN_CONT "CorrectedError ");
+		if (stat & ATA_IDX)
+			printk(KERN_CONT "Index ");
+		if (stat & ATA_ERR)
+			printk(KERN_CONT "Error ");
 	}
-	printk("}\n");
+	printk(KERN_CONT "}\n");
 	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
-		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
+		printk(KERN_ERR "%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
 		else
@@ -406,5 +420,4 @@ u8 ide_dump_status(ide_drive_t *drive, c
 	local_irq_restore(flags);
 	return err;
 }
-
 EXPORT_SYMBOL(ide_dump_status);
