Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZERCYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZERCYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZERCYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:24:22 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4757 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZERCYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:24:18 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Joe Perches <joe@perches.com>
Subject: [PATCH 4/6] drivers/ide: Convert printk(KERN_WARNING to pr_warning(
Date: Sun, 17 May 2009 19:21:13 -0700
Message-Id: <fe562158a3833dcb2789863fab2746f3cd4d8304.1242609804.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/amd74xx.c      |   10 ++++------
 drivers/ide/au1xxx-ide.c   |    8 ++++----
 drivers/ide/cs5520.c       |    5 ++---
 drivers/ide/hpt366.c       |    4 ++--
 drivers/ide/ide-disk.c     |    7 +++----
 drivers/ide/ide-dma-sff.c  |    4 ++--
 drivers/ide/ide-dma.c      |    8 ++++----
 drivers/ide/ide-io.c       |    3 +--
 drivers/ide/ide-ioctls.c   |    4 ++--
 drivers/ide/ide-iops.c     |    8 ++++----
 drivers/ide/ide-pm.c       |    4 ++--
 drivers/ide/ide-probe.c    |   13 +++++++------
 drivers/ide/ide-proc.c     |   15 ++++++---------
 drivers/ide/ide-tape.c     |    4 ++--
 drivers/ide/ide.c          |    2 +-
 drivers/ide/it821x.c       |    4 ++--
 drivers/ide/palm_bk3710.c  |    2 +-
 drivers/ide/pdc202xx_new.c |    4 ++--
 drivers/ide/pdc202xx_old.c |    4 ++--
 drivers/ide/piix.c         |    4 ++--
 drivers/ide/pmac.c         |   30 +++++++++++++++---------------
 drivers/ide/qd65xx.c       |   13 +++++++------
 drivers/ide/scc_pata.c     |   15 ++++++++-------
 drivers/ide/setup-pci.c    |   12 ++++++------
 drivers/ide/sgiioc4.c      |   16 ++++++----------
 drivers/ide/siimage.c      |   13 ++++++-------
 drivers/ide/tc86c001.c     |    4 ++--
 drivers/ide/via82cxxx.c    |    8 ++++----
 28 files changed, 109 insertions(+), 119 deletions(-)

diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index f664550..48dd25d 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -129,9 +129,8 @@ static void amd7411_cable_detect(struct pci_dev *dev)
 	amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
 	for (i = 24; i >= 0; i -= 8)
 		if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
-			printk(KERN_WARNING DRV_NAME " %s: BIOS didn't set "
-				"cable bits correctly. Enabling workaround.\n",
-				pci_name(dev));
+			pr_warning(DRV_NAME " %s: BIOS didn't set cable bits correctly. Enabling workaround.\n",
+				   pci_name(dev));
 			amd_80w |= (1 << (1 - (i >> 4)));
 		}
 }
@@ -277,9 +276,8 @@ static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_
 	}
 
 	if (amd_clock < 20000 || amd_clock > 50000) {
-		printk(KERN_WARNING "%s: User given PCI clock speed impossible"
-				    " (%d), using 33 MHz instead.\n",
-				    d.name, amd_clock);
+		pr_warning("%s: User given PCI clock speed impossible (%d), using 33 MHz instead.\n",
+			   d.name, amd_clock);
 		amd_clock = 33333;
 	}
 
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 0a67651..d234b66 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -234,8 +234,8 @@ static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 			unsigned int tc = (cur_len < 0xfe00)? cur_len: 0xfe00;
 
 			if (++count >= PRD_ENTRIES) {
-				printk(KERN_WARNING "%s: DMA table too small\n",
-				       drive->name);
+				pr_warning("%s: DMA table too small\n",
+					   drive->name);
 				return 0;
 			}
 
@@ -300,8 +300,8 @@ static int auide_dma_test_irq(ide_drive_t *drive)
 	 */
 	drive->waiting_for_dma++;
 	if (drive->waiting_for_dma >= DMA_WAIT_TIMEOUT) {
-		printk(KERN_WARNING "%s: timeout waiting for ddma to \
-                                     complete\n", drive->name);
+		pr_warning("%s: timeout waiting for ddma to complete\n",
+			   drive->name);
 		return 1;
 	}
 	udelay(10);
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index 2a055af..d59a1f7 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -118,13 +118,12 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	 * BARS too and we will freak out other bits of the kernel
 	 */
 	if (pci_enable_device_io(dev)) {
-		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
+		pr_warning("%s: Unable to enable 55x0.\n", d->name);
 		return -ENODEV;
 	}
 	pci_set_master(dev);
 	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
-		printk(KERN_WARNING "%s: No suitable DMA available.\n",
-			d->name);
+		pr_warning("%s: No suitable DMA available.\n", d->name);
 		return -ENODEV;
 	}
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index f83af80..7a94e89 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1067,8 +1067,8 @@ static int init_chipset_hpt366(struct pci_dev *dev)
 		if ((temp & 0xFFFFF000) != 0xABCDE000) {
 			int i;
 
-			printk(KERN_WARNING "%s %s: no clock data saved by "
-				"BIOS\n", name, pci_name(dev));
+			pr_warning("%s %s: no clock data saved by BIOS\n",
+				   name, pci_name(dev));
 
 			/* Calculate the average value of f_CNT. */
 			for (temp = i = 0; i < 128; i++) {
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7bffc7e..1d9489d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -371,10 +371,9 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
 	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
 	    drive->capacity64 > 1ULL << 28) {
-		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
-		       "%llu sectors (%llu MB)\n",
-		       drive->name, (unsigned long long)drive->capacity64,
-		       sectors_to_MB(drive->capacity64));
+		pr_warning("%s: cannot use LBA48 - full capacity %llu sectors (%llu MB)\n",
+			   drive->name, (unsigned long long)drive->capacity64,
+			   sectors_to_MB(drive->capacity64));
 		drive->capacity64 = 1ULL << 28;
 	}
 
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index ef8fb81..b3d9fb6 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -238,8 +238,8 @@ int ide_dma_sff_timer_expiry(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
-	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
-		drive->name, __func__, dma_stat);
+	pr_warning("%s: %s: DMA status (0x%02x)\n",
+		   drive->name, __func__, dma_stat);
 
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index bf2f7a4..bd33ed4 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -220,8 +220,8 @@ int __ide_dma_bad_drive(ide_drive_t *drive)
 
 	int blacklist = ide_in_drive_list(id, drive_blacklist);
 	if (blacklist) {
-		printk(KERN_WARNING "%s: Disabling (U)DMA for %s (blacklisted)\n",
-				    drive->name, (char *)&id[ATA_ID_PROD]);
+		pr_warning("%s: Disabling (U)DMA for %s (blacklisted)\n",
+			   drive->name, (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
 	return 0;
@@ -478,14 +478,14 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 */
 
 	if (error < 0) {
-		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
+		pr_warning("%s: DMA timeout error\n", drive->name);
 		drive->waiting_for_dma = 0;
 		(void)dma_ops->dma_end(drive);
 		ide_dma_unmap_sg(drive, cmd);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
-		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
+		pr_warning("%s: DMA timeout retry\n", drive->name);
 		if (dma_ops->dma_clear)
 			dma_ops->dma_clear(drive);
 		pr_err("%s: timeout waiting for DMA\n", drive->name);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1722959..75812db 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -683,8 +683,7 @@ void ide_timer_expiry (unsigned long data)
 				hwif->dma_ops->dma_lost_irq(drive);
 			if (hwif->ack_intr)
 				hwif->ack_intr(hwif);
-			printk(KERN_WARNING "%s: lost interrupt\n",
-				drive->name);
+			pr_warning("%s: lost interrupt\n", drive->name);
 			startstop = handler(drive);
 		} else {
 			if (drive->waiting_for_dma)
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index c1c25eb..aea6cc3 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -167,8 +167,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	     id[ATA_ID_SWDMA_MODES])) {
 		xfer_rate = args[1];
 		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
+			pr_warning("%s: UDMA speeds >UDMA33 cannot be set\n",
+				   drive->name);
 			goto abort;
 		}
 	}
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index b92e39c..594ade1 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -258,10 +258,10 @@ no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
 
-	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
-			    "limiting max speed to UDMA33\n",
-			    drive->name,
-			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
+	pr_warning("%s: %s side 80-wire cable detection failed, "
+		   "limiting max speed to UDMA33\n",
+		   drive->name,
+		   hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
 	drive->dev_flags |= IDE_DFLAG_UDMA33_WARNED;
 
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index f72a948..7402bb5 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -233,12 +233,12 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 #endif
 		rc = ide_wait_not_busy(hwif, 35000);
 		if (rc)
-			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
+			pr_warning("%s: bus not ready on wakeup\n", drive->name);
 		tp_ops->dev_select(drive);
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
-			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
+			pr_warning("%s: drive not ready on wakeup\n", drive->name);
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 9411f22..3b32d25 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -506,7 +506,8 @@ static u8 probe_for_drive(ide_drive_t *drive)
 				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
 			} else {
 				/* nuke it */
-				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
+				pr_warning("%s: Unknown device on bus refused identification. Ignoring.\n",
+					   drive->name);
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		} else {
@@ -557,8 +558,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
-			__func__, ret);
+		pr_warning("IDE: %s: device_register error: %d\n",
+			   __func__, ret);
 		goto out;
 	}
 
@@ -672,7 +673,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
-	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
+	pr_warning("ide-probe: ignoring undecoded slave\n");
 
 	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
@@ -1006,8 +1007,8 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 		ret = device_register(dev);
 		if (ret < 0)
-			printk(KERN_WARNING "IDE: %s: device_register error: "
-					    "%d\n", __func__, ret);
+			pr_warning("IDE: %s: device_register error: %d\n",
+				   __func__, ret);
 	}
 }
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 3242698..0fa097e 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -241,8 +241,7 @@ static void proc_ide_settings_warn(void)
 	if (warned)
 		return;
 
-	printk(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
-			    "obsolete, and will be removed soon!\n");
+	pr_warning("Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!\n");
 	warned = 1;
 }
 
@@ -464,15 +463,13 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
 	err = device_attach(dev);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: device_attach error: %d\n", __func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
-			printk(KERN_WARNING
-				"IDE: %s: device_attach(2) error: %d\n",
-				__func__, err);
+			pr_warning("IDE: %s: device_attach(2) error: %d\n",
+				   __func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
@@ -666,8 +663,8 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 
 	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: bus_for_each_drv error: %d\n",
+			   __func__, err);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3148ea7..138c42d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1855,8 +1855,8 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		pr_err("ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
-			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
-					    "block size, assuming 32k\n");
+			pr_warning("ide-tape: Cannot deal with zero "
+				   "block size, assuming 32k\n");
 			tape->blk_size = 32768;
 		}
 		return;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 0df5655..966c2da 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -359,7 +359,7 @@ static int __init ide_init(void)
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: bus_register error: %d\n", ret);
+		pr_warning("IDE: bus_register error: %d\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index fc40689..1bac7cd 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -562,8 +562,8 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		if (idev->smart == 0)
-			printk(KERN_WARNING DRV_NAME " %s: revision 0x10, "
-				"workarounds activated\n", pci_name(dev));
+			pr_warning(DRV_NAME " %s: revision 0x10, workarounds activated\n",
+				   pci_name(dev));
 	}
 
 	if (idev->smart == 0) {
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index eee5195..2bd1cf6 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -375,7 +375,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 
 	return 0;
 out:
-	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
+	pr_warning("Palm Chip BK3710 IDE Register Fail\n");
 	return rc;
 }
 
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index 08afe7c..3f02ae3 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -218,8 +218,8 @@ static void pdcnew_reset(ide_drive_t *drive)
 	/*
 	 * Deleted this because it is redundant from the caller.
 	 */
-	printk(KERN_WARNING "pdc202xx_new: %s channel reset.\n",
-		drive->hwif->channel ? "Secondary" : "Primary");
+	pr_warning("pdc202xx_new: %s channel reset.\n",
+		   drive->hwif->channel ? "Secondary" : "Primary");
 }
 
 /**
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 2655a1f..ee3eb5f 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -237,8 +237,8 @@ static void pdc202xx_reset_host (ide_hwif_t *hwif)
 	outb(udma_speed_flag & ~0x10, high_16 | 0x001f);
 	mdelay(2000);	/* 2 seconds ?! */
 
-	printk(KERN_WARNING "PDC202XX: %s channel reset.\n",
-		hwif->channel ? "Secondary" : "Primary");
+	pr_warning("PDC202XX: %s channel reset.\n",
+		   hwif->channel ? "Secondary" : "Primary");
 }
 
 static void pdc202xx_reset (ide_drive_t *drive)
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index 2aa6999..aa49e73 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -408,9 +408,9 @@ static void __devinit piix_check_450nx(void)
 			no_piix_dma = 2;
 	}
 	if(no_piix_dma)
-		printk(KERN_WARNING DRV_NAME ": 450NX errata present, disabling IDE DMA.\n");
+		pr_warning(DRV_NAME ": 450NX errata present, disabling IDE DMA.\n");
 	if(no_piix_dma == 2)
-		printk(KERN_WARNING DRV_NAME ": A BIOS update may resolve this.\n");
+		pr_warning(DRV_NAME ": A BIOS update may resolve this.\n");
 }		
 
 static const struct pci_device_id piix_pci_tbl[] = {
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 245fb5e..11e8589 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1151,8 +1151,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 		return -ENOMEM;
 
 	if (macio_resource_count(mdev) == 0) {
-		printk(KERN_WARNING "ide-pmac: no address for %s\n",
-				    mdev->ofdev.node->full_name);
+		pr_warning("ide-pmac: no address for %s\n",
+			   mdev->ofdev.node->full_name);
 		rc = -ENXIO;
 		goto out_free_pmif;
 	}
@@ -1171,8 +1171,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	 * where that happens though...
 	 */
 	if (macio_irq_count(mdev) == 0) {
-		printk(KERN_WARNING "ide-pmac: no intrs for device %s, using "
-				    "13\n", mdev->ofdev.node->full_name);
+		pr_warning("ide-pmac: no intrs for device %s, using 13\n",
+			   mdev->ofdev.node->full_name);
 		irq = irq_create_mapping(NULL, 13);
 	} else
 		irq = macio_irq(mdev, 0);
@@ -1188,9 +1188,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 
 	if (macio_resource_count(mdev) >= 2) {
 		if (macio_request_resource(mdev, 1, "ide-pmac (dma)"))
-			printk(KERN_WARNING "ide-pmac: can't request DMA "
-					    "resource for %s!\n",
-					    mdev->ofdev.node->full_name);
+			pr_warning("ide-pmac: can't request DMA resource for %s!\n",
+				   mdev->ofdev.node->full_name);
 		else
 			pmif->dma_regs = ioremap(macio_resource_start(mdev, 1), 0x1000);
 	} else
@@ -1281,8 +1280,8 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	if (pci_enable_device(pdev)) {
-		printk(KERN_WARNING "ide-pmac: Can't enable PCI device for "
-				    "%s\n", np->full_name);
+		pr_warning("ide-pmac: Can't enable PCI device for %s\n",
+			   np->full_name);
 		rc = -ENXIO;
 		goto out_free_pmif;
 	}
@@ -1469,8 +1468,9 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		if (pmif->broken_dma && cur_addr & (L1_CACHE_BYTES - 1)) {
 			if (pmif->broken_dma_warn == 0) {
-				printk(KERN_WARNING "%s: DMA on non aligned address, "
-				       "switching to PIO on Ohare chipset\n", drive->name);
+				pr_warning("%s: DMA on non aligned address, "
+					   "switching to PIO on Ohare chipset\n",
+					   drive->name);
 				pmif->broken_dma_warn = 1;
 			}
 			return 0;
@@ -1479,8 +1479,8 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 			unsigned int tc = (cur_len < 0xfe00)? cur_len: 0xfe00;
 
 			if (count++ >= MAX_DCMDS) {
-				printk(KERN_WARNING "%s: DMA table too small\n",
-				       drive->name);
+				pr_warning("%s: DMA table too small\n",
+					   drive->name);
 				return 0;
 			}
 			st_le16(&table->command, wr? OUTPUT_MORE: INPUT_MORE);
@@ -1628,8 +1628,8 @@ pmac_ide_dma_test_irq (ide_drive_t *drive)
 		if ((status & FLUSH) == 0)
 			break;
 		if (++timeout > 100) {
-			printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			timeout flushing channel\n", hwif->index);
+			pr_warning("ide%d, ide_dma_test_irq timeout flushing channel\n",
+				   hwif->index);
 			break;
 		}
 	}	
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 498794b..5d02171 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -227,14 +227,16 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 					active_time = 86;
 					recovery_time = cycle_time - 102;
 				} else
-					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
+					pr_warning("%s: Strange recovery time !\n",
+						   drive->name);
 				break;
 			case 4:
 				if (cycle_time >= 69) {
 					active_time = 70;
 					recovery_time = cycle_time - 61;
 				} else
-					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
+					pr_warning("%s: Strange recovery time !\n",
+						   drive->name);
 				break;
 			default:
 				if (cycle_time >= 180) {
@@ -250,9 +252,8 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	if (!hwif->channel && drive->media != ide_disk) {
 		outb(0x5f, QD_CONTROL_PORT);
-		printk(KERN_WARNING "%s: ATAPI: disabled read-ahead FIFO "
-			"and post-write buffer on %s.\n",
-			drive->name, hwif->name);
+		pr_warning("%s: ATAPI: disabled read-ahead FIFO and post-write buffer on %s.\n",
+			   drive->name, hwif->name);
 	}
 
 	qd_set_timing(drive, qd6580_compute_timing(active_time, recovery_time));
@@ -373,7 +374,7 @@ static int __init qd_probe(int base)
 			 return -ENODEV;	/* bad register */
 
 		if (config & QD_CONFIG_DISABLED) {
-			printk(KERN_WARNING "qd6500 is disabled !\n");
+			pr_warning("qd6500 is disabled !\n");
 			return -ENODEV;
 		}
 
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 86861b4..094ac1d 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -380,8 +380,8 @@ static int scc_dma_end(ide_drive_t *drive)
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
 		if (!(reg & INTSTS_ACTEINT)) {
-			printk(KERN_WARNING "%s: operation failed (transfer data loss)\n",
-			       drive->name);
+			pr_warning("%s: operation failed (transfer data loss)\n",
+				   drive->name);
 			data_loss = 1;
 			if (retry++) {
 				struct request *rq = hwif->rq;
@@ -404,7 +404,7 @@ static int scc_dma_end(ide_drive_t *drive)
 		reg = in_be32((void __iomem *)intsts_port);
 
 		if (reg & INTSTS_SERROR) {
-			printk(KERN_WARNING "%s: SERROR\n", SCC_PATA_NAME);
+			pr_warning("%s: SERROR\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_SERROR|INTSTS_BMSINT);
 
 			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
@@ -418,7 +418,8 @@ static int scc_dma_end(ide_drive_t *drive)
 			maea0 = in_be32((void __iomem *)(ctl_base + 0xF50));
 			maec0 = in_be32((void __iomem *)(ctl_base + 0xF54));
 
-			printk(KERN_WARNING "%s: PRERR [addr:%x cmd:%x]\n", SCC_PATA_NAME, maea0, maec0);
+			pr_warning("%s: PRERR [addr:%x cmd:%x]\n",
+				   SCC_PATA_NAME, maea0, maec0);
 
 			out_be32((void __iomem *)intsts_port, INTSTS_PRERR|INTSTS_BMSINT);
 
@@ -427,7 +428,7 @@ static int scc_dma_end(ide_drive_t *drive)
 		}
 
 		if (reg & INTSTS_RERR) {
-			printk(KERN_WARNING "%s: Response Error\n", SCC_PATA_NAME);
+			pr_warning("%s: Response Error\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_RERR|INTSTS_BMSINT);
 
 			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
@@ -437,13 +438,13 @@ static int scc_dma_end(ide_drive_t *drive)
 		if (reg & INTSTS_ICERR) {
 			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 
-			printk(KERN_WARNING "%s: Illegal Configuration\n", SCC_PATA_NAME);
+			pr_warning("%s: Illegal Configuration\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_ICERR|INTSTS_BMSINT);
 			continue;
 		}
 
 		if (reg & INTSTS_BMSINT) {
-			printk(KERN_WARNING "%s: Internal Bus Error\n", SCC_PATA_NAME);
+			pr_warning("%s: Internal Bus Error\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_BMSINT);
 
 			ide_do_reset(drive);
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 52642d5..42887b2 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -195,12 +195,12 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
-			printk(KERN_WARNING "%s %s: couldn't enable device\n",
-				d->name, pci_name(dev));
+			pr_warning("%s %s: couldn't enable device\n",
+				   d->name, pci_name(dev));
 			goto out;
 		}
-		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
-			d->name, pci_name(dev));
+		pr_warning("%s %s: BIOS configuration fixed\n",
+			   d->name, pci_name(dev));
 	}
 
 	/*
@@ -521,8 +521,8 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 				d->name, pci_name(dev));
 		pciirq = 0;
 	} else if (!pciirq && noisy) {
-		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
-			d->name, pci_name(dev), pciirq);
+		pr_warning("%s %s: bad irq (%d): will probe later\n",
+			   d->name, pci_name(dev), pciirq);
 	} else if (noisy) {
 		pr_info("%s %s: 100%% native mode on irq %d\n",
 			d->name, pci_name(dev), pciirq);
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index c819051..b673fde 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -367,9 +367,8 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
 
 	if (ioc4_dma & IOC4_S_DMA_ACTIVE) {
-		printk(KERN_WARNING
-			"%s(%s):Warning!! DMA from previous transfer was still active\n",
-		       __func__, drive->name);
+		pr_warning("%s(%s):Warning!! DMA from previous transfer was still active\n",
+			   __func__, drive->name);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
@@ -380,10 +379,8 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
 	if (ioc4_dma & IOC4_S_DMA_ERROR) {
-		printk(KERN_WARNING
-		       "%s(%s) : Warning!! - DMA Error during Previous"
-		       " transfer | status 0x%x\n",
-		       __func__, drive->name, ioc4_dma);
+		pr_warning("%s(%s) : Warning!! - DMA Error during Previous transfer | status 0x%x\n",
+			__func__, drive->name, ioc4_dma);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
@@ -428,9 +425,8 @@ static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		while (cur_len) {
 			if (count++ >= IOC4_PRD_ENTRIES) {
-				printk(KERN_WARNING
-				       "%s: DMA table too small\n",
-				       drive->name);
+				pr_warning("%s: DMA table too small\n",
+					   drive->name);
 				return 0;
 			} else {
 				u32 bcount =
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index 0de1b10..c805017 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -382,9 +382,8 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 
 			writel(sata_error, sata_error_addr);
 			watchdog = (sata_error & 0x00680000) ? 1 : 0;
-			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
-				"watchdog = %d, %s\n",
-				drive->name, sata_error, watchdog, __func__);
+			pr_warning("%s: sata_error = 0x%08x, watchdog = %d, %s\n",
+				   drive->name, sata_error, watchdog, __func__);
 		} else
 			watchdog = (ext_stat & 0x8000) ? 1 : 0;
 
@@ -431,8 +430,8 @@ static int sil_sata_reset_poll(ide_drive_t *drive)
 		u32 sata_stat = readl(sata_status_addr);
 
 		if ((sata_stat & 0x03) != 0x03) {
-			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
-					    hwif->name, sata_stat);
+			pr_warning("%s: reset phy dead, status=0x%08x\n",
+				   hwif->name, sata_stat);
 			return -ENXIO;
 		}
 	}
@@ -781,8 +780,8 @@ static int __devinit siimage_init_one(struct pci_dev *dev,
 		* seem to get terminally confused in the PCI spaces.
 		*/
 		if (!request_mem_region(bar5, barsize, d.name)) {
-			printk(KERN_WARNING DRV_NAME " %s: MMIO ports not "
-				"available\n", pci_name(dev));
+			pr_warning(DRV_NAME " %s: MMIO ports not available\n",
+				   pci_name(dev));
 		} else {
 			ioaddr = pci_ioremap_bar(dev, 5);
 			if (ioaddr == NULL)
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index dfd1b93..9d5264b 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -74,8 +74,8 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 		unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
 		u8 dma_cmd		= inb(hwif->dma_base + ATA_DMA_CMD);
 
-		printk(KERN_WARNING "%s: DMA interrupt possibly stuck, "
-		       "attempting recovery...\n", drive->name);
+		pr_warning("%s: DMA interrupt possibly stuck, attempting recovery...\n",
+			   drive->name);
 
 		/* Stop DMA */
 		outb(dma_cmd & ~0x01, hwif->dma_base + ATA_DMA_CMD);
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 26e7dcb..b79ae8f 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -402,8 +402,8 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	 */
 	via_config = via_config_find(&isa);
 	if (!via_config->id) {
-		printk(KERN_WARNING DRV_NAME " %s: unknown chipset, skipping\n",
-			pci_name(dev));
+		pr_warning(DRV_NAME " %s: unknown chipset, skipping\n",
+			   pci_name(dev));
 		return -ENODEV;
 	}
 
@@ -430,8 +430,8 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	}
 
 	if (via_clock < 20000 || via_clock > 50000) {
-		printk(KERN_WARNING DRV_NAME ": User given PCI clock speed "
-			"impossible (%d), using 33 MHz instead.\n", via_clock);
+		pr_warning(DRV_NAME ": User given PCI clock speed impossible (%d), using 33 MHz instead.\n",
+			   via_clock);
 		via_clock = 33333;
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

