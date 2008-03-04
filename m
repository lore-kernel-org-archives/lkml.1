Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYCDDNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYCDDNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYCDDKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:22 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:38307 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbYCDDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x9bbLj3HdtgiSuFztrXJxSVP48anY/S2bR34f0YNT+Z4HSmQrW+moZIPyMB0RIK04qEgilczOn6r4klnWPumxQgfFP+YOdNyOlPDqkwkBZ6mBrs6w2jIw1FGf8gJlykfjMeRTgRLZFCLHyJqe/y+RsK3V3tAxBBejXl0PpXoEL4=
Subject: [PATCH 09/14] ide: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:50 -0800
Message-Id: <1204600190.22933.89.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ide/ide-acpi.c         |   12 ++++++------
 drivers/ide/ide-cd.c           |   12 ++++++------
 drivers/ide/ide-dma.c          |    2 +-
 drivers/ide/ide-lib.c          |    2 +-
 drivers/ide/ide-probe.c        |    2 +-
 drivers/ide/ide-proc.c         |    6 +++---
 drivers/ide/ide-scan-pci.c     |    2 +-
 drivers/ide/ide-taskfile.c     |   12 ++++++------
 drivers/ide/legacy/ht6560b.c   |    4 ++--
 drivers/ide/mips/au1xxx-ide.c  |    8 ++++----
 drivers/ide/pci/cmd640.c       |    2 +-
 drivers/ide/pci/hpt366.c       |    4 ++--
 drivers/ide/pci/pdc202xx_new.c |    2 +-
 drivers/ide/pci/scc_pata.c     |    2 +-
 drivers/ide/pci/sgiioc4.c      |   26 +++++++++++++-------------
 drivers/ide/pci/siimage.c      |    2 +-
 drivers/ide/pci/sl82c105.c     |    4 ++--
 drivers/ide/ppc/mpc8xx.c       |    2 +-
 18 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index e07b189..3e0745b 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -55,7 +55,7 @@ struct ide_acpi_hwif_link {
 /* note: adds function name and KERN_DEBUG */
 #ifdef DEBUGGING
 #define DEBPRINT(fmt, args...)	\
-		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args)
+		printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
 #else
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
@@ -309,7 +309,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_DEBUG
 		       "%s: Run _GTF error: status = 0x%x\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		goto out;
 	}
 
@@ -335,7 +335,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	    out_obj->buffer.length % REGS_PER_GTF) {
 		printk(KERN_ERR
 		       "%s: unexpected GTF length (%d) or addr (0x%p)\n",
-		       __FUNCTION__, out_obj->buffer.length,
+		       __func__, out_obj->buffer.length,
 		       out_obj->buffer.pointer);
 		err = -ENOENT;
 		kfree(output.pointer);
@@ -384,7 +384,7 @@ static int taskfile_load_raw(ide_drive_t *drive,
 	err = ide_no_data_taskfile(drive, &args);
 	if (err)
 		printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 
 	return err;
 }
@@ -422,7 +422,7 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 	if (gtf_length % REGS_PER_GTF) {
 		printk(KERN_ERR "%s: unexpected GTF length (%d)\n",
-		       __FUNCTION__, gtf_length);
+		       __func__, gtf_length);
 		goto out;
 	}
 
@@ -547,7 +547,7 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 		printk(KERN_ERR
 			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
 			"addr (0x%p)\n",
-			__FUNCTION__, out_obj->buffer.length,
+			__func__, out_obj->buffer.length,
 			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
 		return;
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c8d0e87..ad480b0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -685,7 +685,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 
 		/* Whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
-				drive->name, __FUNCTION__);
+				drive->name, __func__);
 
 		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
 		ide_cd_pad_transfer(drive, xf, len);
@@ -698,7 +698,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __FUNCTION__, ireason);
+				drive->name, __func__, ireason);
 	}
 
 	if (rq->cmd_type == REQ_TYPE_ATA_PC)
@@ -720,7 +720,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 		return 0;
 
 	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
-			drive->name, __FUNCTION__, len);
+			drive->name, __func__, len);
 
 	if (cd->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
 		printk(KERN_ERR "  This drive is not supported by "
@@ -824,7 +824,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
 				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				cdrom_end_request(drive, 0);
 				return ide_stopped;
@@ -1055,7 +1055,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (rq->current_nr_sectors > 0) {
 				printk(KERN_ERR "%s: %s: data underrun "
 						"(%d blocks)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
@@ -2032,7 +2032,7 @@ static void ide_cd_release(struct kref *kref)
 	kfree(info->toc);
 	if (devinfo->handle == drive && unregister_cdrom(devinfo))
 		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
-				"driver.\n", __FUNCTION__, drive->name);
+				"driver.\n", __func__, drive->name);
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 2de99e4..01b0c6e 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -542,7 +542,7 @@ static int __ide_dma_test_irq(ide_drive_t *drive)
 		return 1;
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __FUNCTION__);
+			drive->name, __func__);
 	return 0;
 }
 #else
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 29e2c97..c1a0992 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -85,7 +85,7 @@ static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 			mode = XFER_PIO_4;
 	}
 
-//	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
+//	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed);
 
 	return min(speed, mode);
 }
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 194ecb0..534dea4 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -641,7 +641,7 @@ static void ide_register_port(ide_hwif_t *hwif)
 	ret = device_register(&hwif->gendev);
 	if (ret < 0)
 		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
-			__FUNCTION__, ret);
+			__func__, ret);
 }
 
 /**
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index bab88ca..91d2c71 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -601,14 +601,14 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	err = device_attach(dev);
 	if (err < 0)
 		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
 			printk(KERN_WARNING
 				"IDE: %s: device_attach(2) error: %d\n",
-				__FUNCTION__, err);
+				__func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
@@ -840,7 +840,7 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
 	if (err < 0)
 		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 93d2e41..527e50e 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -107,7 +107,7 @@ static int __init ide_scan_pcibus(void)
 		if (__pci_register_driver(d, d->driver.owner,
 					  d->driver.mod_name))
 			printk(KERN_ERR "%s: failed to register %s driver\n",
-					__FUNCTION__, d->driver.mod_name);
+					__func__, d->driver.mod_name);
 	}
 
 	return 0;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 0518a2e..b1d72b4 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -434,7 +434,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 	/* new way for dealing with premature shared PCI interrupts */
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		if (stat & (ERR_STAT | DRQ_STAT))
-			return task_error(drive, rq, __FUNCTION__, stat);
+			return task_error(drive, rq, __func__, stat);
 		/* No data yet, so wait for another IRQ. */
 		ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
 		return ide_started;
@@ -446,7 +446,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 	if (!hwif->nleft) {
 		stat = wait_drive_not_busy(drive);
 		if (!OK_STAT(stat, 0, BAD_STAT))
-			return task_error(drive, rq, __FUNCTION__, stat);
+			return task_error(drive, rq, __func__, stat);
 		task_end_request(drive, rq, stat);
 		return ide_stopped;
 	}
@@ -467,11 +467,11 @@ static ide_startstop_t task_out_intr (ide_drive_t *drive)
 	u8 stat = ide_read_status(drive);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
-		return task_error(drive, rq, __FUNCTION__, stat);
+		return task_error(drive, rq, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
 	if (((stat & DRQ_STAT) == 0) ^ !hwif->nleft)
-		return task_error(drive, rq, __FUNCTION__, stat);
+		return task_error(drive, rq, __func__, stat);
 
 	if (!hwif->nleft) {
 		task_end_request(drive, rq, stat);
@@ -654,7 +654,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				/* (hs): give up if multcount is not set */
 				printk(KERN_ERR "%s: %s Multimode Write " \
 					"multcount is not set\n",
-					drive->name, __FUNCTION__);
+					drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -671,7 +671,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 				/* (hs): give up if multcount is not set */
 				printk(KERN_ERR "%s: %s Multimode Read failure " \
 					"multcount is not set\n",
-					drive->name, __FUNCTION__);
+					drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 78ca68e..86e85c1 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -348,12 +348,12 @@ static int __init ht6560b_init(void)
 
 	if (!request_region(HT_CONFIG_PORT, 1, hwif->name)) {
 		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
-			__FUNCTION__);
+			__func__);
 		return -ENODEV;
 	}
 
 	if (!try_to_init_ht6560b()) {
-		printk(KERN_NOTICE "%s: HBA not found\n", __FUNCTION__);
+		printk(KERN_NOTICE "%s: HBA not found\n", __func__);
 		goto release_region;
 	}
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 0f4bf5d..6c207ff 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -66,7 +66,7 @@ void auide_insw(unsigned long port, void *addr, u32 count)
 
 	if(!put_dest_flags(ahwif->rx_chan, (void*)addr, count << 1, 
 			   DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __FUNCTION__, __LINE__);
+		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->rx_chan);
@@ -84,7 +84,7 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 
 	if(!put_source_flags(ahwif->tx_chan, (void*)addr,
 			     count << 1, DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __FUNCTION__, __LINE__);
+		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->tx_chan);
@@ -255,7 +255,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 						     (void*) sg_virt(sg),
 						     tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
-					       __FUNCTION__, __LINE__);
+					       __func__, __LINE__);
 				}
 			} else 
 			{
@@ -263,7 +263,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 						   (void*) sg_virt(sg),
 						   tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
-					       __FUNCTION__, __LINE__);
+					       __func__, __LINE__);
 				}
 			}
 
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index ec66798..1bf98a0 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -632,7 +632,7 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	while (drive != cmd_drives[index]) {
 		if (++index > 3) {
 			printk(KERN_ERR "%s: bad news in %s\n",
-					drive->name, __FUNCTION__);
+					drive->name, __func__);
 			return;
 		}
 	}
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 6357bb6..28c671b 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -776,7 +776,7 @@ static void hpt366_dma_lost_irq(ide_drive_t *drive)
 	pci_read_config_byte(dev, 0x52, &mcr3);
 	pci_read_config_byte(dev, 0x5a, &scr1);
 	printk("%s: (%s)  mcr1=0x%02x, mcr3=0x%02x, scr1=0x%02x\n",
-		drive->name, __FUNCTION__, mcr1, mcr3, scr1);
+		drive->name, __func__, mcr1, mcr3, scr1);
 	if (scr1 & 0x10)
 		pci_write_config_byte(dev, 0x5a, scr1 & ~0x10);
 	ide_dma_lost_irq(drive);
@@ -858,7 +858,7 @@ static int hpt374_ide_dma_test_irq(ide_drive_t *drive)
 
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-				drive->name, __FUNCTION__);
+				drive->name, __func__);
 	return 0;
 }
 
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 1c8cb77..3cb73f7 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -34,7 +34,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...) printk("%s: " fmt, __FUNCTION__, ## args)
+#define DBG(fmt, args...) printk("%s: " fmt, __func__, ## args)
 #else
 #define DBG(fmt, args...)
 #endif
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 238e3e1..58a1195 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -447,7 +447,7 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 
 	if (!drive->waiting_for_dma)
 		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __FUNCTION__);
+			drive->name, __func__);
 	return 0;
 }
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 0546264..2a4483b 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -171,10 +171,10 @@ sgiioc4_clearirq(ide_drive_t * drive)
 			printk(KERN_ERR
 			       "%s(%s) : PCI Bus Error when doing DMA:"
 				   " status-cmd reg is 0x%x\n",
-			       __FUNCTION__, drive->name, pci_stat_cmd_reg);
+			       __func__, drive->name, pci_stat_cmd_reg);
 			printk(KERN_ERR
 			       "%s(%s) : PCI Error Address is 0x%x%x\n",
-			       __FUNCTION__, drive->name,
+			       __func__, drive->name,
 			       pci_err_addr_high, pci_err_addr_low);
 			/* Clear the PCI Error indicator */
 			pci_write_config_dword(dev, PCI_COMMAND, 0x00000146);
@@ -233,7 +233,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 		printk(KERN_ERR
 		       "%s(%s): IOC4 DMA STOP bit is still 1 :"
 		       "ioc4_dma_reg 0x%x\n",
-		       __FUNCTION__, drive->name, ioc4_dma);
+		       __func__, drive->name, ioc4_dma);
 		dma_stat = 1;
 	}
 
@@ -252,7 +252,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 		udelay(1);
 	}
 	if (!valid) {
-		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __FUNCTION__,
+		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __func__,
 		       drive->name);
 		dma_stat = 1;
 	}
@@ -265,7 +265,7 @@ sgiioc4_ide_dma_end(ide_drive_t * drive)
 			printk(KERN_ERR
 			       "%s(%s): WARNING!! byte_count_dev %d "
 			       "!= byte_count_mem %d\n",
-			       __FUNCTION__, drive->name, bc_dev, bc_mem);
+			       __func__, drive->name, bc_dev, bc_mem);
 		}
 	}
 
@@ -344,7 +344,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 		printk(KERN_ERR
 		       "%s(%s) -- ERROR, Addresses 0x%p to 0x%p "
 		       "ALREADY in use\n",
-		       __FUNCTION__, hwif->name, (void *) dma_base,
+		       __func__, hwif->name, (void *) dma_base,
 		       (void *) dma_base + num_ports - 1);
 		return -1;
 	}
@@ -353,7 +353,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 	if (virt_dma_base == NULL) {
 		printk(KERN_ERR
 		       "%s(%s) -- ERROR, Unable to map addresses 0x%lx to 0x%lx\n",
-		       __FUNCTION__, hwif->name, dma_base, dma_base + num_ports - 1);
+		       __func__, hwif->name, dma_base, dma_base + num_ports - 1);
 		goto dma_remap_failure;
 	}
 	hwif->dma_base = (unsigned long) virt_dma_base;
@@ -379,7 +379,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 			    hwif->dmatable_cpu, hwif->dmatable_dma);
 	printk(KERN_INFO
 	       "%s() -- Error! Unable to allocate DMA Maps for drive %s\n",
-	       __FUNCTION__, hwif->name);
+	       __func__, hwif->name);
 	printk(KERN_INFO
 	       "Changing from DMA to PIO mode for Drive %s\n", hwif->name);
 
@@ -407,14 +407,14 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	if (ioc4_dma & IOC4_S_DMA_ACTIVE) {
 		printk(KERN_WARNING
 			"%s(%s):Warning!! DMA from previous transfer was still active\n",
-		       __FUNCTION__, drive->name);
+		       __func__, drive->name);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
 			printk(KERN_ERR
 			       "%s(%s) : IOC4 Dma STOP bit is still 1\n",
-			       __FUNCTION__, drive->name);
+			       __func__, drive->name);
 	}
 
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
@@ -422,14 +422,14 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 		printk(KERN_WARNING
 		       "%s(%s) : Warning!! - DMA Error during Previous"
 		       " transfer | status 0x%x\n",
-		       __FUNCTION__, drive->name, ioc4_dma);
+		       __func__, drive->name, ioc4_dma);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
 			printk(KERN_ERR
 			       "%s(%s) : IOC4 DMA STOP bit is still 1\n",
-			       __FUNCTION__, drive->name);
+			       __func__, drive->name);
 	}
 
 	/* Address of the Scatter Gather List */
@@ -630,7 +630,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 		printk(KERN_ERR
 			"%s : %s -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __FUNCTION__, hwif->name, (void *) cmd_phys_base,
+		       __func__, hwif->name, (void *) cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index cc4be96..178ea68 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -347,7 +347,7 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
 				"watchdog = %d, %s\n",
 				drive->name, sata_error, watchdog,
-				__FUNCTION__);
+				__func__);
 
 		} else {
 			watchdog = (ext_stat & 0x8000) ? 1 : 0;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index ee261ae..9f758e6 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -179,7 +179,7 @@ static void sl82c105_dma_start(ide_drive_t *drive)
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
-	DBG(("%s(drive:%s)\n", __FUNCTION__, drive->name));
+	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
 	pci_write_config_word(dev, reg, drive->drive_data >> 16);
 
@@ -203,7 +203,7 @@ static int sl82c105_dma_end(ide_drive_t *drive)
 	int reg 		= 0x44 + drive->dn * 4;
 	int ret;
 
-	DBG(("%s(drive:%s)\n", __FUNCTION__, drive->name));
+	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
 	ret = __ide_dma_end(drive);
 
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 38fbfb8..60a1756 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -468,7 +468,7 @@ static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #elif defined(CONFIG_IDE_EXT_DIRECT)
 
 	printk("%s[%d] %s: not implemented yet!\n",
-		__FILE__,__LINE__,__FUNCTION__);
+		__FILE__,__LINE__,__func__);
 #endif /* defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_PCMCIA */
 }
 
-- 
1.5.4.3.500.g83a2c


