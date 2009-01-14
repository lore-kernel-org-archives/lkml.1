Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZANSjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZANSjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZANSi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:38:56 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33771 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZANSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:38:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=agchj4dNPoiZwawO+QiHg+LZ3Uzob924hlvRCPNuYP8dj4203kWhOfS9ch4mGtDpvX
         SvOjlOfSWQU9WKqciNtjK8OwvyuCR+Rvj8M1SVVb6GXE2r5ZX98RLqmJGXw2HYzuiHOJ
         xuF+o6bwUWJmxDrXfGqso13mxRlV1IDZbEn5w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes for 2.6.29-rc1
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 14 Jan 2009 19:38:06 +0100
Message-Id: <200901141938.06512.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes suspend regression and couple other smaller fall outs,
also adds support for Vortex86SX to it821x host driver.

[ As usual more detailed changelog/credits below. ]


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/mips/AU1xxx_IDE.README |    6 +-----
 drivers/ide/Kconfig                  |    5 -----
 drivers/ide/ide-disk.c               |    2 +-
 drivers/ide/ide-iops.c               |    2 +-
 drivers/ide/ide-pm.c                 |   12 ++++++++----
 drivers/ide/ide-probe.c              |    2 +-
 drivers/ide/it821x.c                 |   15 +++++++++++++--
 drivers/ide/sl82c105.c               |    4 ----
 drivers/ide/tx4938ide.c              |    1 -
 drivers/ide/via82cxxx.c              |    2 --
 include/linux/ide.h                  |    2 +-
 include/linux/pci_ids.h              |    1 +
 12 files changed, 27 insertions(+), 27 deletions(-)


Atsushi Nemoto (1):
      tx4938ide: Fix build error due to read_sff_dma_status moving

Bartlomiej Zolnierkiewicz (6):
      ide: fix accidental LOCKDEP breakage caused by local_irq_set() removal
      ide: can't use SSD/non-rotational queue flag for all CFA devices
      via82cxxx: fix cable warning message
      sl82c105: remove dead code
      ide: remove unused CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ
      ide: fix suspend regression

Ben Dooks (1):
      IDE: fix sparse signed-ness errors with host->host_busy

Brandon Philips (2):
      it821x: Add ultra_mask quirk for Vortex86SX
      it821x.c: use dev->revision instead of pci_read_config_byte


diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/mips/AU1xxx_IDE.README
index f54962a..8ace35e 100644
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -52,14 +52,12 @@ Two files are introduced:
   b) 'drivers/ide/mips/au1xxx-ide.c'
      contains the functionality of the AU1XXX IDE driver
 
-Four configs variables are introduced:
+Following extra configs variables are introduced:
 
   CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA    - enable the PIO+DBDMA mode
   CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA  - enable the MWDMA mode
   CONFIG_BLK_DEV_IDE_AU1XXX_BURSTABLE_ON - set Burstable FIFO in DBDMA
                                            controller
-  CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ - maximum transfer size
-                                           per descriptor
 
 
 SUPPORTED IDE MODES
@@ -87,7 +85,6 @@ CONFIG_BLK_DEV_IDEDMA_PCI=y
 CONFIG_IDEDMA_PCI_AUTO=y
 CONFIG_BLK_DEV_IDE_AU1XXX=y
 CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA=y
-CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ=128
 CONFIG_BLK_DEV_IDEDMA=y
 CONFIG_IDEDMA_AUTO=y
 
@@ -105,7 +102,6 @@ CONFIG_BLK_DEV_IDEDMA_PCI=y
 CONFIG_IDEDMA_PCI_AUTO=y
 CONFIG_BLK_DEV_IDE_AU1XXX=y
 CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA=y
-CONFIG_BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ=128
 CONFIG_BLK_DEV_IDEDMA=y
 CONFIG_IDEDMA_AUTO=y
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 3f95038..b1c6f68 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -701,11 +701,6 @@ config BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
        depends on SOC_AU1200 && BLK_DEV_IDE_AU1XXX
 endchoice
 
-config BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ
-       int "Maximum transfer size (KB) per request (up to 128)"
-       default "128"
-       depends on BLK_DEV_IDE_AU1XXX
-
 config BLK_DEV_IDE_TX4938
 	tristate "TX4938 internal IDE support"
 	depends on SOC_TX4938
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 4088a62..806760d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -633,7 +633,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
 		q->max_sectors / 2);
 
-	if (ata_id_is_ssd(id) || ata_id_is_cfa(id))
+	if (ata_id_is_ssd(id))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	/* calculate drive capacity, and select LBA if possible */
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index e728cfe..753b92e 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -493,7 +493,7 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 	stat = tp_ops->read_status(hwif);
 
 	if (stat & ATA_BUSY) {
-		local_irq_save(flags);
+		local_save_flags(flags);
 		local_irq_enable_in_hardirq();
 		timeout += jiffies;
 		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 4b3bf6a..60538d9 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -186,12 +186,10 @@ void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
 	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
 #endif
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_pm_suspend_request(rq)) {
+	if (blk_pm_suspend_request(rq))
 		blk_stop_queue(q);
-	} else {
+	else
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
-		blk_start_queue(q);
-	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	drive->hwif->rq = NULL;
@@ -219,6 +217,8 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		 * point.
 		 */
 		ide_hwif_t *hwif = drive->hwif;
+		struct request_queue *q = drive->queue;
+		unsigned long flags;
 		int rc;
 #ifdef DEBUG_PM
 		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
@@ -231,5 +231,9 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 0ccbb44..312127e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -796,7 +796,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	local_irq_save(flags);
+	local_save_flags(flags);
 	local_irq_enable_in_hardirq();
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 0be27ac..e1c4f54 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -68,6 +68,8 @@
 
 #define DRV_NAME "it821x"
 
+#define QUIRK_VORTEX86 1
+
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -79,6 +81,7 @@ struct it821x_dev
 	u16	pio[2];			/* Cached PIO values */
 	u16	mwdma[2];		/* Cached MWDMA values */
 	u16	udma[2];		/* Cached UDMA values (per drive) */
+	u16	quirks;
 };
 
 #define ATA_66		0
@@ -557,8 +560,7 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	 *	this is necessary.
 	 */
 
-	pci_read_config_byte(dev, 0x08, &conf);
-	if (conf == 0x10) {
+	if (dev->revision == 0x10) {
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		if (idev->smart == 0)
@@ -577,6 +579,12 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
+
+	/* Vortex86SX quirk: prevent Ultra-DMA mode to fix BadCRC issue */
+	if (idev->quirks & QUIRK_VORTEX86) {
+		if (dev->revision == 0x11)
+			hwif->ultra_mask = 0;
+	}
 }
 
 static void it8212_disable_raid(struct pci_dev *dev)
@@ -649,6 +657,8 @@ static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_devic
 		return -ENOMEM;
 	}
 
+	itdevs->quirks = id->driver_data;
+
 	rc = ide_pci_init_one(dev, &it821x_chipset, itdevs);
 	if (rc)
 		kfree(itdevs);
@@ -668,6 +678,7 @@ static void __devexit it821x_remove(struct pci_dev *dev)
 static const struct pci_device_id it821x_pci_tbl[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), 0 },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), 0 },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), QUIRK_VORTEX86 },
 	{ 0, },
 };
 
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index 48cc748..6297956 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -310,10 +310,6 @@ static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.dma_ops	= &sl82c105_dma_ops,
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
-/* FIXME: check for Compatibility mode in generic IDE PCI code */
-#if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
-			  IDE_HFLAG_FORCE_LEGACY_IRQS |
-#endif
 			  IDE_HFLAG_SERIALIZE_DMA |
 			  IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO5,
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index b4ef218..d909534 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -202,7 +202,6 @@ static const struct ide_tp_ops tx4938ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index fecc0e0..703c3ee 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -432,8 +432,6 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	if (via_clock < 20000 || via_clock > 50000) {
 		printk(KERN_WARNING DRV_NAME ": User given PCI clock speed "
 			"impossible (%d), using 33 MHz instead.\n", via_clock);
-		printk(KERN_WARNING DRV_NAME ": Use ide0=ata66 if you want "
-			"to assume 80-wire cable.\n");
 		via_clock = 33333;
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 3644f63..194da5a 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -871,7 +871,7 @@ struct ide_host {
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
 
 	/* used for hosts requiring serialization */
-	volatile long	host_busy;
+	volatile unsigned long	host_busy;
 };
 
 #define IDE_HOST_BUSY 0
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d543365..d56ad9c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2174,6 +2174,7 @@
 #define PCI_DEVICE_ID_RDC_R6040		0x6040
 #define PCI_DEVICE_ID_RDC_R6060		0x6060
 #define PCI_DEVICE_ID_RDC_R6061		0x6061
+#define PCI_DEVICE_ID_RDC_D1010		0x1010
 
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
