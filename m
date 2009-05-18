Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZERCYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZERCYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZERCYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:24:00 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4753 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZERCXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:23:55 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Elias Oltmanns <eo@nebensachen.de>,
       Joe Perches <joe@perches.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: [PATCH 3/6] drivers/ide: Convert printk(KERN_ERR to pr_err(
Date: Sun, 17 May 2009 19:21:12 -0700
Message-Id: <cd9628f7dc1a7421a55a6cb64a6a7a011f580f89.1242609803.git.joe@perches.com>
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
 drivers/ide/ali14xx.c          |    4 +-
 drivers/ide/au1xxx-ide.c       |    8 ++--
 drivers/ide/cmd640.c           |    9 ++--
 drivers/ide/cs5520.c           |    2 +-
 drivers/ide/cs5530.c           |    4 +-
 drivers/ide/cs5536.c           |    2 +-
 drivers/ide/cy82c693.c         |    5 +-
 drivers/ide/delkin_cb.c        |    4 +-
 drivers/ide/dtc2278.c          |    2 +-
 drivers/ide/falconide.c        |    4 +-
 drivers/ide/hpt366.c           |   12 +++---
 drivers/ide/ide-4drives.c      |    7 +--
 drivers/ide/ide-acpi.c         |   15 +++----
 drivers/ide/ide-atapi.c        |   61 ++++++++++++++--------------
 drivers/ide/ide-cd.c           |   43 ++++++++------------
 drivers/ide/ide-cd_ioctl.c     |    3 +-
 drivers/ide/ide-cd_verbose.c   |   28 ++++++-------
 drivers/ide/ide-cs.c           |    7 +--
 drivers/ide/ide-disk.c         |    4 +-
 drivers/ide/ide-dma-sff.c      |    4 +-
 drivers/ide/ide-dma.c          |   13 +++---
 drivers/ide/ide-eh.c           |   14 +++---
 drivers/ide/ide-floppy.c       |   30 ++++++-------
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 drivers/ide/ide-gd.c           |    8 ++--
 drivers/ide/ide-generic.c      |   10 ++---
 drivers/ide/ide-h8300.c        |    2 +-
 drivers/ide/ide-io.c           |   12 ++---
 drivers/ide/ide-iops.c         |    2 +-
 drivers/ide/ide-legacy.c       |    8 ++--
 drivers/ide/ide-lib.c          |   10 ++--
 drivers/ide/ide-pnp.c          |    8 ++--
 drivers/ide/ide-probe.c        |   25 ++++++------
 drivers/ide/ide-scan-pci.c     |    4 +-
 drivers/ide/ide-tape.c         |   86 +++++++++++++++++-----------------------
 drivers/ide/ide-taskfile.c     |   26 ++++++------
 drivers/ide/it821x.c           |    2 +-
 drivers/ide/palm_bk3710.c      |    8 ++--
 drivers/ide/pdc202xx_new.c     |   11 ++---
 drivers/ide/pmac.c             |   31 +++++++-------
 drivers/ide/qd65xx.c           |    6 +-
 drivers/ide/scc_pata.c         |    2 +-
 drivers/ide/setup-pci.c        |   42 +++++++++----------
 drivers/ide/sgiioc4.c          |   46 ++++++++-------------
 drivers/ide/tc86c001.c         |    2 +-
 drivers/ide/tx4939ide.c        |    4 +-
 drivers/ide/umc8672.c          |    6 +-
 drivers/ide/via82cxxx.c        |    3 +-
 48 files changed, 297 insertions(+), 354 deletions(-)

diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
index 5ac2174..8c5c936 100644
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -213,7 +213,7 @@ static int __init ali14xx_probe(void)
 
 	/* initialize controller registers */
 	if (!initRegisters()) {
-		printk(KERN_ERR "ali14xx: Chip initialization failed.\n");
+		pr_err("ali14xx: Chip initialization failed.\n");
 		return 1;
 	}
 
@@ -236,7 +236,7 @@ static int __init ali14xx_init(void)
 			return -ENODEV;
 		return 0;
 	}
-	printk(KERN_ERR "ali14xx: not found.\n");
+	pr_err("ali14xx: not found.\n");
 out:
 	return -ENODEV;
 }
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index fd16686..0a67651 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -58,7 +58,7 @@ static inline void auide_insw(unsigned long port, void *addr, u32 count)
 
 	if(!put_dest_flags(ahwif->rx_chan, (void*)addr, count << 1, 
 			   DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
+		pr_err("%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->rx_chan);
@@ -76,7 +76,7 @@ static inline void auide_outsw(unsigned long port, void *addr, u32 count)
 
 	if(!put_source_flags(ahwif->tx_chan, (void*)addr,
 			     count << 1, DDMA_FLAGS_NOIE)) {
-		printk(KERN_ERR "%s failed %d\n", __func__, __LINE__);
+		pr_err("%s failed %d\n", __func__, __LINE__);
 		return;
 	}
 	ctp = *((chan_tab_t **)ahwif->tx_chan);
@@ -249,7 +249,7 @@ static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 				if(!put_source_flags(ahwif->tx_chan, 
 						     (void*) sg_virt(sg),
 						     tc, flags)) { 
-					printk(KERN_ERR "%s failed %d\n", 
+					pr_err("%s failed %d\n", 
 					       __func__, __LINE__);
 				}
 			} else 
@@ -257,7 +257,7 @@ static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 				if(!put_dest_flags(ahwif->rx_chan, 
 						   (void*) sg_virt(sg),
 						   tc, flags)) { 
-					printk(KERN_ERR "%s failed %d\n", 
+					pr_err("%s failed %d\n", 
 					       __func__, __LINE__);
 				}
 			}
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 665bdad..1bb9064 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -685,14 +685,13 @@ static const struct ide_port_info cmd640_port_info __initdata = {
 static int cmd640x_init_one(unsigned long base, unsigned long ctl)
 {
 	if (!request_region(base, 8, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				DRV_NAME, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       DRV_NAME, base, base + 7);
 		return -EBUSY;
 	}
 
 	if (!request_region(ctl, 1, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				DRV_NAME, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n", DRV_NAME, ctl);
 		release_region(base, 8);
 		return -EBUSY;
 	}
@@ -728,7 +727,7 @@ static int __init cmd640x_init(void)
 	 */
 	put_cmd640_reg(0x5b, 0xbd);
 	if (get_cmd640_reg(0x5b) != 0xbd) {
-		printk(KERN_ERR "ide: cmd640 init failed: wrong value in reg 0x5b\n");
+		pr_err("ide: cmd640 init failed: wrong value in reg 0x5b\n");
 		return 0;
 	}
 	put_cmd640_reg(0x5b, 0);
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index 87987a7..2a055af 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -83,7 +83,7 @@ static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	printk(KERN_ERR "cs55x0: bad ide timing.\n");
+	pr_err("cs55x0: bad ide timing.\n");
 
 	cs5520_set_pio_mode(drive, 0);
 }
diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
index 40bf05e..1f1875e 100644
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -153,11 +153,11 @@ static int init_chipset_cs5530(struct pci_dev *dev)
 		}
 	}
 	if (!master_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate PCI MASTER function\n");
+		pr_err(DRV_NAME ": unable to locate PCI MASTER function\n");
 		goto out;
 	}
 	if (!cs5530_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate CS5530 LEGACY function\n");
+		pr_err(DRV_NAME ": unable to locate CS5530 LEGACY function\n");
 		goto out;
 	}
 
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index f161286..cb2976e 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -265,7 +265,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	cs5536_read(dev, CFG, &cfg);
 
 	if ((cfg & IDE_CFG_CHANEN) == 0) {
-		printk(KERN_ERR DRV_NAME ": disabled by BIOS\n");
+		pr_err(DRV_NAME ": disabled by BIOS\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/ide/cy82c693.c b/drivers/ide/cy82c693.c
index 7477644..3de2667 100644
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -212,9 +212,8 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (hwif->index > 0) {  /* drive is on the secondary channel */
 		dev = pci_get_slot(dev->bus, dev->devfn+1);
 		if (!dev) {
-			printk(KERN_ERR "%s: tune_drive: "
-				"Cannot find secondary interface!\n",
-				drive->name);
+			pr_err("%s: tune_drive: Cannot find secondary interface!\n",
+			       drive->name);
 			return;
 		}
 	}
diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index f153b95..cf54e7a 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -80,12 +80,12 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 
 	rc = pci_enable_device(dev);
 	if (rc) {
-		printk(KERN_ERR "delkin_cb: pci_enable_device failed (%d)\n", rc);
+		pr_err("delkin_cb: pci_enable_device failed (%d)\n", rc);
 		return rc;
 	}
 	rc = pci_request_regions(dev, "delkin_cb");
 	if (rc) {
-		printk(KERN_ERR "delkin_cb: pci_request_regions failed (%d)\n", rc);
+		pr_err("delkin_cb: pci_request_regions failed (%d)\n", rc);
 		pci_disable_device(dev);
 		return rc;
 	}
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
index c6b1381..0865ebe 100644
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -141,7 +141,7 @@ static int __init dtc2278_init(void)
 		return -ENODEV;
 
 	if (dtc2278_probe()) {
-		printk(KERN_ERR "dtc2278: ide interfaces already in use!\n");
+		pr_err("dtc2278: ide interfaces already in use!\n");
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index a1268a3..061cedd 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -46,7 +46,7 @@ static int falconide_intr_lock;
 static void falconide_release_lock(void)
 {
 	if (falconide_intr_lock == 0) {
-		printk(KERN_ERR "%s: bug\n", __func__);
+		pr_err("%s: bug\n", __func__);
 		return;
 	}
 	falconide_intr_lock = 0;
@@ -148,7 +148,7 @@ static int __init falconide_init(void)
 	pr_info("ide: Falcon IDE controller\n");
 
 	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
-		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		pr_err("%s: resources busy\n", DRV_NAME);
 		return -EBUSY;
 	}
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 5689f63..f83af80 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1161,8 +1161,8 @@ static int init_chipset_hpt366(struct pci_dev *dev)
 		}
 
 		if (info->timings->clock_table[clock] == NULL) {
-			printk(KERN_ERR "%s %s: unknown bus timing!\n",
-				name, pci_name(dev));
+			pr_err("%s %s: unknown bus timing!\n",
+			       name, pci_name(dev));
 			return -EIO;
 		}
 
@@ -1188,8 +1188,8 @@ static int init_chipset_hpt366(struct pci_dev *dev)
 				f_low += adjust >> 1;
 		}
 		if (adjust == 8) {
-			printk(KERN_ERR "%s %s: DPLL did not stabilize!\n",
-				name, pci_name(dev));
+			pr_err("%s %s: DPLL did not stabilize!\n",
+			       name, pci_name(dev));
 			return -EIO;
 		}
 
@@ -1546,8 +1546,8 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 
 	dyn_info = kzalloc(sizeof(*dyn_info) * (dev2 ? 2 : 1), GFP_KERNEL);
 	if (dyn_info == NULL) {
-		printk(KERN_ERR "%s %s: out of memory!\n",
-			d.name, pci_name(dev));
+		pr_err("%s %s: out of memory!\n",
+		       d.name, pci_name(dev));
 		pci_dev_put(dev2);
 		return -ENOMEM;
 	}
diff --git a/drivers/ide/ide-4drives.c b/drivers/ide/ide-4drives.c
index 78aca75..dd67b59 100644
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -36,14 +36,13 @@ static int __init ide_4drives_init(void)
 		return -ENODEV;
 
 	if (!request_region(base, 8, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				DRV_NAME, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       DRV_NAME, base, base + 7);
 		return -EBUSY;
 	}
 
 	if (!request_region(ctl, 1, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				DRV_NAME, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n", DRV_NAME, ctl);
 		release_region(base, 8);
 		return -EBUSY;
 	}
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index c2f7c2f..757d9f2 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -261,8 +261,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length % REGS_PER_GTF) {
-		printk(KERN_ERR
-		       "%s: unexpected GTF length (%d) or addr (0x%p)\n",
+		pr_err("%s: unexpected GTF length (%d) or addr (0x%p)\n",
 		       __func__, out_obj->buffer.length,
 		       out_obj->buffer.pointer);
 		err = -ENOENT;
@@ -323,8 +322,8 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
-			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-					__func__, err);
+			pr_err("%s: ide_no_data_taskfile failed: %u\n",
+			       __func__, err);
 			rc = err;
 		}
 	}
@@ -435,11 +434,9 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length != sizeof(struct GTM_buffer)) {
 		kfree(output.pointer);
-		printk(KERN_ERR
-			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
-			"addr (0x%p)\n",
-			__func__, out_obj->buffer.length,
-			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
+		pr_err("%s: unexpected _GTM length (0x%x)[should be 0x%zx] or addr (0x%p)\n",
+		       __func__, out_obj->buffer.length,
+		       sizeof(struct GTM_buffer), out_obj->buffer.pointer);
 		return;
 	}
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 9950b32..9a6ec77 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -50,21 +50,21 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
 #endif
 
 	if (protocol != 2)
-		printk(KERN_ERR "%s: %s: protocol (0x%02x) is not ATAPI\n",
-			s, drive->name, protocol);
+		pr_err("%s: %s: protocol (0x%02x) is not ATAPI\n",
+		       s, drive->name, protocol);
 	else if ((drive->media == ide_floppy && device_type != 0) ||
 		 (drive->media == ide_tape && device_type != 1))
-		printk(KERN_ERR "%s: %s: invalid device type (0x%02x)\n",
-			s, drive->name, device_type);
+		pr_err("%s: %s: invalid device type (0x%02x)\n",
+		       s, drive->name, device_type);
 	else if (removable == 0)
-		printk(KERN_ERR "%s: %s: the removable flag is not set\n",
-			s, drive->name);
+		pr_err("%s: %s: the removable flag is not set\n",
+		       s, drive->name);
 	else if (drive->media == ide_floppy && drq_type == 3)
-		printk(KERN_ERR "%s: %s: sorry, DRQ type (0x%02x) not "
-			"supported\n", s, drive->name, drq_type);
+		pr_err("%s: %s: sorry, DRQ type (0x%02x) not supported\n",
+		       s, drive->name, drq_type);
 	else if (packet_size != 0)
-		printk(KERN_ERR "%s: %s: packet size (0x%02x) is not 12 "
-			"bytes\n", s, drive->name, packet_size);
+		pr_err("%s: %s: packet size (0x%02x) is not 12 bytes\n",
+		       s, drive->name, packet_size);
 	else
 		return 1;
 	return 0;
@@ -298,9 +298,9 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
-				printk(KERN_ERR "%s: DMA %s error\n",
-					drive->name, rq_data_dir(pc->rq)
-						     ? "write" : "read");
+				pr_err("%s: DMA %s error\n",
+				       drive->name,
+				       rq_data_dir(pc->rq) ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
@@ -334,8 +334,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 				pc->rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
+				pr_err("%s: I/O error in request sense command\n",
+				       drive->name);
 				return ide_do_reset(drive);
 			}
 
@@ -383,8 +383,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
+		pr_err("%s: The device wants to issue more interrupts in DMA mode\n",
+		       drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -393,16 +393,16 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
 	if (ireason & ATAPI_COD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+		pr_err("%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 
 	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & ATAPI_IO) ? "Write" : "Read",
-				(ireason & ATAPI_IO) ? "Read" : "Write");
+		pr_err("%s: We wanted to %s, but the device wants us to %s!\n",
+		       drive->name,
+		       (ireason & ATAPI_IO) ? "Write" : "Read",
+		       (ireason & ATAPI_IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
 
@@ -462,14 +462,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 
 	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
 		(ireason & ATAPI_IO))) {
-		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-				"a packet command, retrying\n", drive->name);
+		pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, retrying\n",
+		       drive->name);
 		udelay(100);
 		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
-			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-					"a packet command, ignoring\n",
-					drive->name);
+			pr_err("%s: (IO,CoD != (0,1) while issuing a packet command, ignoring\n",
+			       drive->name);
 			ireason |= ATAPI_COD;
 			ireason &= ~ATAPI_IO;
 		}
@@ -499,8 +498,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
+		pr_err("%s: Strange, packet command initiated yet DRQ isn't asserted\n",
+		       drive->name);
 		return startstop;
 	}
 
@@ -541,8 +540,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			ireason = ide_wait_ireason(drive, ireason);
 
 		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-			printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-					"a packet command\n", drive->name);
+			pr_err("%s: (IO,CoD) != (0,1) while issuing a packet command\n",
+			       drive->name);
 
 			return ide_do_reset(drive);
 		}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d96dd09..f2836c0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -347,8 +347,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			cdrom_saw_media_change(drive);
 
 			if (blk_fs_request(rq) && !blk_rq_quiet(rq))
-				printk(KERN_ERR PFX "%s: tray open\n",
-					drive->name);
+				pr_err(PFX "%s: tray open\n", drive->name);
 		}
 		do_end_request = 1;
 		break;
@@ -469,8 +468,8 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	else if (ireason == (rw << 1)) {
 
 		/* whoops... */
-		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
-				drive->name, __func__);
+		pr_err(PFX "%s: %s: wrong transfer direction!\n",
+		       drive->name, __func__);
 
 		ide_pad_transfer(drive, rw, len);
 	} else  if (rw == 0 && ireason == 1) {
@@ -482,8 +481,8 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __func__, ireason);
+		pr_err(PFX "%s: %s: bad interrupt reason 0x%02x\n",
+		       drive->name, __func__, ireason);
 	}
 
 	if (rq->cmd_type == REQ_TYPE_ATA_PC)
@@ -624,8 +623,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		dma_error = hwif->dma_ops->dma_end(drive);
 		ide_dma_unmap_sg(drive, cmd);
 		if (dma_error) {
-			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
-					write ? "write" : "read");
+			pr_err(PFX "%s: DMA %s error\n", drive->name,
+			       write ? "write" : "read");
 			ide_dma_off(drive);
 		}
 	}
@@ -668,9 +667,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			 */
 			uptodate = 1;
 			if (cmd->nleft > 0) {
-				printk(KERN_ERR PFX "%s: %s: data underrun "
-					"(%u bytes)\n", drive->name, __func__,
-					cmd->nleft);
+				pr_err(PFX "%s: %s: data underrun (%u bytes)\n",
+				       drive->name, __func__, cmd->nleft);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
 				uptodate = 0;
@@ -718,8 +716,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (blk_fs_request(rq) == 0 || write == 0)
 			ide_pad_transfer(drive, write, len);
 		else {
-			printk(KERN_ERR PFX "%s: confused, missing data\n",
-				drive->name);
+			pr_err(PFX "%s: confused, missing data\n", drive->name);
 			blk_dump_rq_flags(rq, "cdrom_newpc_intr");
 		}
 	}
@@ -992,10 +989,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR PFX "%s: weird block size %u\n",
-				drive->name, blocklen);
-		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
-				drive->name);
+		pr_err(PFX "%s: weird block size %u\n", drive->name, blocklen);
+		pr_err(PFX "%s: default to 2kb block size\n", drive->name);
 		blocklen = 2048;
 		break;
 	}
@@ -1051,8 +1046,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk(KERN_ERR PFX "%s: No cdrom TOC buffer!\n",
-					drive->name);
+			pr_err(PFX "%s: No cdrom TOC buffer!\n", drive->name);
 			return -ENOMEM;
 		}
 		info->toc = toc;
@@ -1304,8 +1298,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
-		printk(KERN_ERR PFX "%s: ATAPI magneto-optical drive\n",
-				drive->name);
+		pr_err(PFX "%s: ATAPI magneto-optical drive\n", drive->name);
 		return nslots;
 	}
 
@@ -1602,8 +1595,8 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	blk_queue_hardsect_size(q, CD_FRAMESIZE);
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk(KERN_ERR PFX "%s: %s failed to register device with the"
-				" cdrom driver.\n", drive->name, __func__);
+		pr_err(PFX "%s: %s failed to register device with the cdrom driver.\n",
+		       drive->name, __func__);
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
@@ -1803,8 +1796,8 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
-		printk(KERN_ERR PFX "%s: Can't allocate a cdrom structure\n",
-				drive->name);
+		pr_err(PFX "%s: Can't allocate a cdrom structure\n",
+		       drive->name);
 		goto failed;
 	}
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index df3df00..6b22211 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -155,8 +155,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 	if (stat != 0 &&
 	    sense->sense_key == ILLEGAL_REQUEST &&
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
-		printk(KERN_ERR "%s: door locking not supported\n",
-			drive->name);
+		pr_err("%s: door locking not supported\n", drive->name);
 		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 		stat = 0;
 	}
diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
index 6490a2d..d05ad08 100644
--- a/drivers/ide/ide-cd_verbose.c
+++ b/drivers/ide/ide-cd_verbose.c
@@ -22,10 +22,10 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 						sense->asc == 0x3a)))
 		return;
 
-	printk(KERN_ERR "%s: error code: 0x%02x  sense_key: 0x%02x  "
-			"asc: 0x%02x  ascq: 0x%02x\n",
-			name, sense->error_code, sense->sense_key,
-			sense->asc, sense->ascq);
+	pr_err("%s: error code: 0x%02x  sense_key: 0x%02x  "
+	       "asc: 0x%02x  ascq: 0x%02x\n",
+	       name, sense->error_code, sense->sense_key,
+	       sense->asc, sense->ascq);
 }
 #else
 /* The generic packet command opcodes for CD/DVD Logical Units,
@@ -255,7 +255,7 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 	const char *s = "bad sense key!";
 	char buf[80];
 
-	printk(KERN_ERR "ATAPI device %s:\n", name);
+	pr_err("ATAPI device %s:\n", name);
 	if (sense->error_code == 0x70)
 		printk(KERN_CONT "  Error: ");
 	else if (sense->error_code == 0x71)
@@ -303,8 +303,8 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 			s = "(reserved error code)";
 	}
 
-	printk(KERN_ERR "  %s -- (asc=0x%02x, ascq=0x%02x)\n",
-			s, sense->asc, sense->ascq);
+	pr_err("  %s -- (asc=0x%02x, ascq=0x%02x)\n",
+	       s, sense->asc, sense->ascq);
 
 	if (failed_command != NULL) {
 		int lo = 0, mid, hi = ARRAY_SIZE(packet_command_texts);
@@ -324,8 +324,7 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 				lo = mid + 1;
 		}
 
-		printk(KERN_ERR "  The failed \"%s\" packet command "
-				"was: \n  \"", s);
+		pr_err("  The failed \"%s\" packet command was: \n  \"", s);
 		for (i = 0; i < BLK_MAX_CDB; i++)
 			printk(KERN_CONT "%02x ", failed_command->cmd[i]);
 		printk(KERN_CONT "\"\n");
@@ -339,16 +338,15 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 	if (sense->sense_key == NOT_READY && (sense->sks[0] & 0x80)) {
 		int progress = (sense->sks[1] << 8 | sense->sks[2]) * 100;
 
-		printk(KERN_ERR "  Command is %02d%% complete\n",
-				progress / 0xffff);
+		pr_err("  Command is %02d%% complete\n", progress / 0xffff);
 	}
 
 	if (sense->sense_key == ILLEGAL_REQUEST &&
 	    (sense->sks[0] & 0x80) != 0) {
-		printk(KERN_ERR "  Error in %s byte %d",
-				(sense->sks[0] & 0x40) != 0 ?
-				"command packet" : "command data",
-				(sense->sks[1] << 8) + sense->sks[2]);
+		pr_err("  Error in %s byte %d",
+		       (sense->sks[0] & 0x40) != 0 ?
+		       "command packet" : "command data",
+		       (sense->sks[1] << 8) + sense->sks[2]);
 
 		if ((sense->sks[0] & 0x40) != 0)
 			printk(KERN_CONT " bit %d", sense->sks[0] & 0x07);
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 3b975f0..3a97e66 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -166,14 +166,13 @@ static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
     hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
     if (!request_region(io, 8, DRV_NAME)) {
-	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-			DRV_NAME, io, io + 7);
+	    pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		   DRV_NAME, io, io + 7);
 	return NULL;
     }
 
     if (!request_region(ctl, 1, DRV_NAME)) {
-	printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-			DRV_NAME, ctl);
+	    pr_err("%s: I/O resource 0x%lX not free.\n", DRV_NAME, ctl);
 	release_region(io, 8);
 	return NULL;
     }
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 89d2568..7bffc7e 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -694,8 +694,8 @@ static void ide_disk_setup(ide_drive_t *drive)
 
 	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
 	    (drive->head == 0 || drive->head > 16)) {
-		printk(KERN_ERR "%s: invalid geometry: %d physical heads?\n",
-			drive->name, drive->head);
+		pr_err("%s: invalid geometry: %d physical heads?\n",
+		       drive->name, drive->head);
 		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 	} else
 		drive->dev_flags |= IDE_DFLAG_ATTACH;
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index e4cdf78..ef8fb81 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -162,8 +162,8 @@ int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 	}
 
 use_pio_instead:
-	printk(KERN_ERR "%s: %s\n", drive->name,
-		count ? "DMA table too small" : "empty DMA table?");
+	pr_err("%s: %s\n", drive->name,
+	       count ? "DMA table too small" : "empty DMA table?");
 
 	return 0; /* revert to PIO for this request */
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 2a865a7..bf2f7a4 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -106,8 +106,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 						cmd->rq->nr_sectors << 9);
 			return ide_stopped;
 		}
-		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
-			drive->name, __func__, dma_stat);
+		pr_err("%s: %s: bad DMA status (0x%02x)\n",
+		       drive->name, __func__, dma_stat);
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
@@ -409,7 +409,7 @@ int ide_id_dma_bug(ide_drive_t *drive)
 
 	return 0;
 err_out:
-	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
+	pr_err("%s: bad DMA info in identify block\n", drive->name);
 	return 1;
 }
 
@@ -456,7 +456,7 @@ void ide_check_dma_crc(ide_drive_t *drive)
 
 void ide_dma_lost_irq(ide_drive_t *drive)
 {
-	printk(KERN_ERR "%s: DMA interrupt recovery\n", drive->name);
+	pr_err("%s: DMA interrupt recovery\n", drive->name);
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
@@ -488,7 +488,7 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		if (dma_ops->dma_clear)
 			dma_ops->dma_clear(drive);
-		printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
+		pr_err("%s: timeout waiting for DMA\n", drive->name);
 		if (dma_ops->dma_test_irq(drive) == 0) {
 			ide_dump_status(drive, "DMA timeout",
 					hwif->tp_ops->read_status(hwif));
@@ -557,8 +557,7 @@ int ide_allocate_dma_engine(ide_hwif_t *hwif)
 						&hwif->dmatable_dma,
 						GFP_ATOMIC);
 	if (hwif->dmatable_cpu == NULL) {
-		printk(KERN_ERR "%s: unable to allocate PRD table\n",
-			hwif->name);
+		pr_err("%s: unable to allocate PRD table\n", hwif->name);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index c9f1fea..92062f0 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -182,8 +182,8 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 		}
 		/* end of polling */
 		hwif->polling = 0;
-		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
-			drive->name, stat);
+		pr_err("%s: ATAPI reset timed-out, status=0x%02x\n",
+		       drive->name, stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
@@ -202,7 +202,7 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
 
 	u8 err_master = err & 0x7f;
 
-	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	pr_err("%s: reset: master: ", hwif->name);
 	if (err_master && err_master < 6)
 		printk(KERN_CONT "%s", err_master_vals[err_master]);
 	else
@@ -228,8 +228,8 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 	if (port_ops && port_ops->reset_poll) {
 		err = port_ops->reset_poll(drive);
 		if (err) {
-			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
-				hwif->name, drive->name);
+			pr_err("%s: host reset_poll failure for %s.\n",
+			       hwif->name, drive->name);
 			goto out;
 		}
 	}
@@ -242,8 +242,8 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 			/* continue polling */
 			return ide_started;
 		}
-		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
-			hwif->name, tmp);
+		pr_err("%s: reset timed-out, status=0x%02x\n",
+		       hwif->name, tmp);
 		drive->failures++;
 		err = -EIO;
 	} else  {
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f001f06..a6edb0d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -94,8 +94,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 				      "ascq = %x", floppy->sense_key,
 				      floppy->asc, floppy->ascq);
 		} else
-			printk(KERN_ERR PFX "Error in REQUEST SENSE itself - "
-			       "Aborting request!\n");
+			pr_err(PFX "Error in REQUEST SENSE itself - Aborting request!\n");
 	}
 
 	if (blk_special_request(rq))
@@ -113,10 +112,10 @@ static void ide_floppy_report_error(struct ide_disk_obj *floppy,
 	    floppy->ascq      == 0x00)
 		return;
 
-	printk(KERN_ERR PFX "%s: I/O error, pc = %2x, key = %2x, "
-			"asc = %2x, ascq = %2x\n",
-			floppy->drive->name, pc->c[0], floppy->sense_key,
-			floppy->asc, floppy->ascq);
+	pr_err(PFX "%s: I/O error, pc = %2x, key = %2x, "
+	       "asc = %2x, ascq = %2x\n",
+	       floppy->drive->name, pc->c[0], floppy->sense_key,
+	       floppy->asc, floppy->ascq);
 
 }
 
@@ -178,7 +177,7 @@ void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 		length += 32;
 		break;
 	default:
-		printk(KERN_ERR PFX "unsupported page code in %s\n", __func__);
+		pr_err(PFX "unsupported page code in %s\n", __func__);
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->req_xfer = length;
@@ -247,7 +246,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 			ide_floppy_report_error(floppy, drive->failed_pc);
 			drive->failed_pc = NULL;
 		} else
-			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
+			pr_err(PFX "%s: I/O error\n", drive->name);
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
@@ -259,8 +258,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
-			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
-				drive->name);
+			pr_err(PFX "%s: unsupported r/w rq size\n",
+			       drive->name);
 			goto out_end;
 		}
 		pc = &floppy->queued_pc;
@@ -315,7 +314,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
 	if (ide_queue_pc_tail(drive, disk, pc)) {
-		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
+		pr_err(PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
@@ -387,7 +386,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	pc.buf_size = sizeof(pc_buf);
 
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
-		printk(KERN_ERR PFX "Can't get floppy parameters\n");
+		pr_err(PFX "Can't get floppy parameters\n");
 		return 1;
 	}
 	header_len = pc.buf[3];
@@ -450,12 +449,11 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			 * This is a KERN_ERR so it appears on screen
 			 * for the user to see
 			 */
-			printk(KERN_ERR PFX "%s: No disk in drive\n",
-			       drive->name);
+			pr_err(PFX "%s: No disk in drive\n", drive->name);
 			break;
 		case CAPACITY_INVALID:
-			printk(KERN_ERR PFX "%s: Invalid capacity for disk "
-				"in drive\n", drive->name);
+			pr_err(PFX "%s: Invalid capacity for disk in drive\n",
+			       drive->name);
 			break;
 		}
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d",
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index cd8a420..19aa555 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -51,7 +51,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	pc->buf_size = sizeof(pc_buf);
 
 	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
+		pr_err("ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 156e62b..80fd103 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -340,15 +340,15 @@ static int ide_gd_probe(ide_drive_t *drive)
 		goto failed;
 
 	if (disk_ops->check(drive, DRV_NAME) == 0) {
-		printk(KERN_ERR PFX "%s: not supported by this driver\n",
-			drive->name);
+		pr_err(PFX "%s: not supported by this driver\n",
+		       drive->name);
 		goto failed;
 	}
 
 	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
 	if (!idkp) {
-		printk(KERN_ERR PFX "%s: can't allocate a disk structure\n",
-			drive->name);
+		pr_err(PFX "%s: can't allocate a disk structure\n",
+		       drive->name);
 		goto failed;
 	}
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 107235e..13c8c7a 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -109,17 +109,15 @@ static int __init ide_generic_init(void)
 
 		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
-				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
-						"not free.\n",
-						DRV_NAME, io_addr, io_addr + 7);
+				pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+				       DRV_NAME, io_addr, io_addr + 7);
 				rc = -EBUSY;
 				continue;
 			}
 
 			if (!request_region(io_addr + 0x206, 1, DRV_NAME)) {
-				printk(KERN_ERR "%s: I/O resource 0x%lX "
-						"not free.\n",
-						DRV_NAME, io_addr + 0x206);
+				pr_err("%s: I/O resource 0x%lX not free.\n",
+				       DRV_NAME, io_addr + 0x206);
 				release_region(io_addr, 8);
 				rc = -EBUSY;
 				continue;
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index e3e581a..acb59ad 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -99,7 +99,7 @@ static int __init h8300_ide_init(void)
 	return ide_host_add(&h8300_port_info, hws, NULL);
 
 out_busy:
-	printk(KERN_ERR "ide-h8300: IDE I/F resource already used.\n");
+	pr_err("ide-h8300: IDE I/F resource already used.\n");
 
 	return -EBUSY;
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 35dc38d..1722959 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -95,8 +95,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
 	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
 		if (tf->lbal != 0xc4) {
-			printk(KERN_ERR "%s: head unload failed!\n",
-			       drive->name);
+			pr_err("%s: head unload failed!\n", drive->name);
 			ide_tf_dump(drive->name, cmd);
 		} else
 			drive->dev_flags |= IDE_DFLAG_PARKED;
@@ -204,7 +203,7 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
-		printk(KERN_ERR "%s: bad special flag: 0x%02x\n", drive->name, special);
+		pr_err("%s: bad special flag: 0x%02x\n", drive->name, special);
 		return ide_stopped;
 	}
 
@@ -355,7 +354,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 	drive->hwif->tp_ops->dev_select(drive);
 	if (ide_wait_stat(&startstop, drive, drive->ready_stat,
 			  ATA_BUSY | ATA_DRQ, WAIT_READY)) {
-		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
+		pr_err("%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
 	if (!drive->special.all) {
@@ -749,9 +748,8 @@ static void unexpected_intr(int irq, ide_hwif_t *hwif)
 
 		if (time_after(jiffies, last_msgtime + HZ)) {
 			last_msgtime = jiffies;
-			printk(KERN_ERR "%s: unexpected interrupt, "
-				"status=0x%02x, count=%ld\n",
-				hwif->name, stat, count);
+			pr_err("%s: unexpected interrupt, status=0x%02x, count=%ld\n",
+			       hwif->name, stat, count);
 		}
 	}
 }
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index b245f39..b92e39c 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -299,7 +299,7 @@ int ide_driveid_update(ide_drive_t *drive)
 out_err:
 	SELECT_MASK(drive, 0);
 	if (rc == 2)
-		printk(KERN_ERR "%s: %s: bad status\n", drive->name, __func__);
+		pr_err("%s: %s: bad status\n", drive->name, __func__);
 	kfree(id);
 	return 0;
 }
diff --git a/drivers/ide/ide-legacy.c b/drivers/ide/ide-legacy.c
index 8c5dcbf..bb42707 100644
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -19,14 +19,14 @@ static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
 	}
 
 	if (!request_region(base, 8, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				d->name, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       d->name, base, base + 7);
 		return;
 	}
 
 	if (!request_region(ctl, 1, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				d->name, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n",
+		       d->name, ctl);
 		release_region(base, 8);
 		return;
 	}
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 56ff8c4..7872af6 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -42,7 +42,7 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 		cmd = rq->special;
 
-	printk(KERN_ERR "ide: failed opcode was: ");
+	pr_err("ide: failed opcode was: ");
 	if (cmd == NULL)
 		printk(KERN_CONT "unknown\n");
 	else
@@ -91,7 +91,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
 	if (err & ATA_ABORTED)
 		printk(KERN_CONT "DriveStatusError ");
 	if (err & ATA_ICRC)
@@ -121,7 +121,7 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
 	if (err & ATAPI_ILI)
 		printk(KERN_CONT "IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
@@ -151,7 +151,7 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
 	u8 err = 0;
 
-	printk(KERN_ERR "%s: %s: status=0x%02x { ", drive->name, msg, stat);
+	pr_err("%s: %s: status=0x%02x { ", drive->name, msg, stat);
 	if (stat & ATA_BUSY)
 		printk(KERN_CONT "Busy ");
 	else {
@@ -173,7 +173,7 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 	printk(KERN_CONT "}\n");
 	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
-		printk(KERN_ERR "%s: %s: error=0x%02x ", drive->name, msg, err);
+		pr_err("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
 		else
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 5c995e0..0dd5301 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -47,14 +47,14 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	ctl = pnp_port_start(dev, 1);
 
 	if (!request_region(base, 8, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				DRV_NAME, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       DRV_NAME, base, base + 7);
 		return -EBUSY;
 	}
 
 	if (!request_region(ctl, 1, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				DRV_NAME, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n",
+		       DRV_NAME, ctl);
 		release_region(base, 8);
 		return -EBUSY;
 	}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index adf7a09..9411f22 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -414,8 +414,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			return 4;
 
 		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
-			printk(KERN_ERR "%s: no response (status = 0x%02x), "
-					"resetting drive\n", drive->name, stat);
+			pr_err("%s: no response (status = 0x%02x), resetting drive\n",
+			       drive->name, stat);
 			msleep(50);
 			tp_ops->dev_select(drive);
 			msleep(50);
@@ -428,8 +428,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		stat = tp_ops->read_status(hwif);
 
 		if (rc == 1)
-			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
-					drive->name, stat);
+			pr_err("%s: no response (status = 0x%02x)\n",
+			       drive->name, stat);
 	} else {
 		/* not present or maybe ATAPI */
 		rc = 3;
@@ -475,7 +475,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 
 	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
 	if (drive->id == NULL) {
-		printk(KERN_ERR "ide: out of memory for id data.\n");
+		pr_err("ide: out of memory for id data.\n");
 		return 0;
 	}
 
@@ -813,8 +813,7 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 	mutex_lock(&ide_cfg_mtx);
 	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (ide_init_queue(drive)) {
-			printk(KERN_ERR "ide: failed to init %s\n",
-					drive->name);
+			pr_err("ide: failed to init %s\n", drive->name);
 			kfree(drive->id);
 			drive->id = NULL;
 			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
@@ -956,7 +955,7 @@ static void drive_release_dev (struct device *dev)
 static int hwif_init(ide_hwif_t *hwif)
 {
 	if (!hwif->irq) {
-		printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
+		pr_err("%s: disabled, no IRQ\n", hwif->name);
 		return 0;
 	}
 
@@ -969,15 +968,15 @@ static int hwif_init(ide_hwif_t *hwif)
 	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
-		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
+		pr_err("%s: unable to allocate SG table.\n", hwif->name);
 		goto out;
 	}
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
 	if (init_irq(hwif)) {
-		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
-			hwif->name, hwif->irq);
+		pr_err("%s: disabled, unable to get IRQ %d\n",
+		       hwif->name, hwif->irq);
 		goto out;
 	}
 
@@ -1284,8 +1283,8 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
-			printk(KERN_ERR "%s: no free slot for interface\n",
-					d ? d->name : "ide");
+			pr_err("%s: no free slot for interface\n",
+			       d ? d->name : "ide");
 			kfree(hwif);
 			continue;
 		}
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 0e79eff..84e791a 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -101,8 +101,8 @@ static int __init ide_scan_pcibus(void)
 		d = list_entry(l, struct pci_driver, node);
 		if (__pci_register_driver(d, d->driver.owner,
 					  d->driver.mod_name))
-			printk(KERN_ERR "%s: failed to register %s driver\n",
-					__func__, d->driver.mod_name);
+			pr_err("%s: failed to register %s driver\n",
+			       __func__, d->driver.mod_name);
 	}
 
 	return 0;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3b63169..3148ea7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -362,8 +362,7 @@ static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
+			pr_err("ide-tape: bh == NULL in %s\n", __func__);
 			return;
 		}
 		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
@@ -481,8 +480,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		if (uptodate)
 			idetape_analyze_error(drive, pc->buf);
 		else
-			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
-					"itself - Aborting request!\n");
+			pr_err("ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		int blocks = pc->xferred / tape->blk_size;
 
@@ -615,8 +613,8 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 
 	if (drive->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
-		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
-			"Two request sense in serial were issued\n");
+		pr_err("ide-tape: possible ide-tape.c bug - "
+		       "Two request sense in serial were issued\n");
 	}
 
 	if (drive->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
@@ -636,12 +634,12 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
-				printk(KERN_ERR "ide-tape: %s: I/O error, "
-						"pc = %2x, key = %2x, "
-						"asc = %2x, ascq = %2x\n",
-						tape->name, pc->c[0],
-						tape->sense_key, tape->asc,
-						tape->ascq);
+				pr_err("ide-tape: %s: I/O error, "
+				       "pc = %2x, key = %2x, "
+				       "asc = %2x, ascq = %2x\n",
+				       tape->name, pc->c[0],
+				       tape->sense_key, tape->asc,
+				       tape->ascq);
 			}
 			/* Giving up */
 			pc->error = IDE_DRV_ERROR_GENERAL;
@@ -697,8 +695,7 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		if (stat & ATA_ERR) {
 			/* Error detected */
 			if (pc->c[0] != TEST_UNIT_READY)
-				printk(KERN_ERR "ide-tape: %s: I/O error, ",
-						tape->name);
+				pr_err("ide-tape: %s: I/O error, ", tape->name);
 			/* Retry operation */
 			ide_retry_pc(drive, tape->disk);
 			return ide_stopped;
@@ -775,8 +772,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
-			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
-					"Two DSC requests were queued\n");
+			pr_err("ide-tape: ide-tape.c bug - "
+			       "Two DSC requests were queued\n");
 			drive->failed_pc = NULL;
 			rq->errors = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
@@ -807,8 +804,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
-			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
-				tape->name);
+			pr_err("ide-tape: %s: DSC timeout\n", tape->name);
 			if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 				idetape_media_access_finished(drive);
 				return ide_stopped;
@@ -947,13 +943,12 @@ static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
+			pr_err("ide-tape: bh == NULL in %s\n", __func__);
 			return 1;
 		}
 		count = min((unsigned int)
-				(bh->b_size - atomic_read(&bh->b_count)),
-				(unsigned int)n);
+			    (bh->b_size - atomic_read(&bh->b_count)),
+			    (unsigned int)n);
 		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
 				count))
 			ret = 1;
@@ -979,8 +974,7 @@ static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
+			pr_err("ide-tape: bh == NULL in %s\n", __func__);
 			return 1;
 		}
 		count = min(tape->b_count, n);
@@ -1253,12 +1247,11 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
-				" but we are not writing.\n");
+		pr_err("ide-tape: bug: Trying to empty merge buffer but we are not writing.\n");
 		return;
 	}
 	if (tape->merge_bh_size > tape->buffer_size) {
-		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
+		pr_err("ide-tape: bug: merge_buffer too big\n");
 		tape->merge_bh_size = tape->buffer_size;
 	}
 	if (tape->merge_bh_size) {
@@ -1311,8 +1304,7 @@ static int idetape_init_read(ide_drive_t *drive)
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size should be"
-					 " 0 now\n");
+			pr_err("ide-tape: merge_bh_size should be 0 now\n");
 			tape->merge_bh_size = 0;
 		}
 		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
@@ -1483,8 +1475,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 		count = (MTBSFM == mt_op ? 1 : -1);
 		return idetape_space_over_filemarks(drive, MTFSF, count);
 	default:
-		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
-				mt_op);
+		pr_err("ide-tape: MTIO operation %d not supported\n", mt_op);
 		return -EIO;
 	}
 }
@@ -1586,8 +1577,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			ide_tape_discard_merge_buffer(drive, 1);
 		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size "
-				"should be 0 now\n");
+			pr_err("ide-tape: merge_bh_size should be 0 now\n");
 			tape->merge_bh_size = 0;
 		}
 		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
@@ -1618,7 +1608,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		return (0);
 	if (tape->merge_bh_size) {
 		if (tape->merge_bh_size >= tape->buffer_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
+			pr_err("ide-tape: bug: merge buf too big\n");
 			tape->merge_bh_size = 0;
 		}
 		actually_written = min((unsigned int)
@@ -1666,7 +1656,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
-		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
+		pr_err("ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
 	return 0;
@@ -1787,8 +1777,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		tape->door_locked = DOOR_UNLOCKED;
 		return 0;
 	default:
-		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
-				mt_op);
+		pr_err("ide-tape: MTIO operation %d not supported\n", mt_op);
 		return -EIO;
 	}
 }
@@ -1864,7 +1853,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
+		pr_err("ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
 					    "block size, assuming 32k\n");
@@ -1916,7 +1905,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
 		clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
-		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
+		pr_err("ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
@@ -2020,8 +2009,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	pc.buf_size = sizeof(pc_buf);
 
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
-		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
-				tape->name);
+		pr_err("ide-tape: %s: can't get INQUIRY results\n", tape->name);
 		return;
 	}
 	memcpy(vendor_id, &pc.buf[8], 8);
@@ -2049,8 +2037,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
-				" some default values\n");
+		pr_err("ide-tape: Can't get tape parameters - assuming some default values\n");
 		tape->blk_size = 512;
 		put_unaligned(52,   (u16 *)&tape->caps[12]);
 		put_unaligned(540,  (u16 *)&tape->caps[14]);
@@ -2361,14 +2348,14 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
 	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
-		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
-				" the driver\n", drive->name);
+		pr_err("ide-tape: %s: not supported by this version of the driver\n",
+		       drive->name);
 		goto failed;
 	}
 	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
-		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
-				drive->name);
+		pr_err("ide-tape: %s: Can't allocate a tape struct\n",
+		       drive->name);
 		goto failed;
 	}
 
@@ -2433,14 +2420,13 @@ static int __init idetape_init(void)
 	idetape_sysfs_class = class_create(THIS_MODULE, "ide_tape");
 	if (IS_ERR(idetape_sysfs_class)) {
 		idetape_sysfs_class = NULL;
-		printk(KERN_ERR "Unable to create sysfs class for ide tapes\n");
+		pr_err("Unable to create sysfs class for ide tapes\n");
 		error = -EBUSY;
 		goto out;
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register chrdev"
-				" interface\n");
+		pr_err("ide-tape: Failed to register chrdev interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4aa6223..baf0956 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -86,7 +86,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	if (orig_cmd->protocol == ATA_PROT_PIO &&
 	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
 	    drive->mult_count == 0) {
-		printk(KERN_ERR "%s: multimode not set!\n", drive->name);
+		pr_err("%s: multimode not set!\n", drive->name);
 		return ide_stopped;
 	}
 
@@ -215,7 +215,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	}
 
 	if (stat & ATA_BUSY)
-		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
+		pr_err("%s: drive still BUSY!\n", drive->name);
 
 	return stat;
 }
@@ -399,10 +399,10 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
-		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-			drive->name,
-			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
-			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
+		pr_err("%s: no DRQ after issuing %sWRITE%s\n",
+		       drive->name,
+		       (cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
+		       (drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
 
@@ -576,9 +576,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Write " \
-					"multcount is not set\n",
-					drive->name, __func__);
+				pr_err("%s: %s Multimode Write multcount is not set\n",
+				       drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -596,9 +595,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		case TASKFILE_MULTI_IN:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Read failure " \
-					"multcount is not set\n",
-					drive->name, __func__);
+				pr_err("%s: %s Multimode Read failure multcount is not set\n",
+				       drive->name, __func__);
 				err = -EPERM;
 				goto abort;
 			}
@@ -626,8 +624,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		nsect = (cmd.hob.nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
-			printk(KERN_ERR "%s: in/out command without data\n",
-					drive->name);
+			pr_err("%s: in/out command without data\n",
+			       drive->name);
 			err = -EFAULT;
 			goto abort;
 		}
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 97dfd81..fc40689 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -650,7 +650,7 @@ static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_devic
 
 	itdevs = kzalloc(2 * sizeof(*itdevs), GFP_KERNEL);
 	if (itdevs == NULL) {
-		printk(KERN_ERR DRV_NAME " %s: out of memory\n", pci_name(dev));
+		pr_err(DRV_NAME " %s: out of memory\n", pci_name(dev));
 		return -ENOMEM;
 	}
 
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index 925dd5d..eee5195 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -329,25 +329,25 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL) {
-		printk(KERN_ERR "failed to get memory region resource\n");
+		pr_err("failed to get memory region resource\n");
 		return -ENODEV;
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq == NULL) {
-		printk(KERN_ERR "failed to get IRQ resource\n");
+		pr_err("failed to get IRQ resource\n");
 		return -ENODEV;
 	}
 
 	mem_size = mem->end - mem->start + 1;
 	if (request_mem_region(mem->start, mem_size, "palm_bk3710") == NULL) {
-		printk(KERN_ERR "failed to request memory region\n");
+		pr_err("failed to request memory region\n");
 		return -EBUSY;
 	}
 
 	base = ioremap(mem->start, mem_size);
 	if (!base) {
-		printk(KERN_ERR "failed to map IO memory\n");
+		pr_err("failed to map IO memory\n");
 		release_mem_region(mem->start, mem_size);
 		return -ENOMEM;
 	}
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index f9b910d..08afe7c 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -365,8 +365,8 @@ static int init_chipset_pdcnew(struct pci_dev *dev)
 
 	/* Sanity check */
 	if (unlikely(pll_input < 5000000L || pll_input > 70000000L)) {
-		printk(KERN_ERR "%s %s: Bad PLL input clock %ld Hz, giving up!"
-			"\n", name, pci_name(dev), pll_input);
+		pr_err("%s %s: Bad PLL input clock %ld Hz, giving up!\n",
+		       name, pci_name(dev), pll_input);
 		goto out;
 	}
 
@@ -402,8 +402,8 @@ static int init_chipset_pdcnew(struct pci_dev *dev)
 		r = 0x00;
 	} else {
 		/* Invalid ratio */
-		printk(KERN_ERR "%s %s: Bad ratio %ld, giving up!\n",
-			name, pci_name(dev), ratio);
+		pr_err("%s %s: Bad ratio %ld, giving up!\n",
+		       name, pci_name(dev), ratio);
 		goto out;
 	}
 
@@ -413,8 +413,7 @@ static int init_chipset_pdcnew(struct pci_dev *dev)
 
 	if (unlikely(f < 0 || f > 127)) {
 		/* Invalid F */
-		printk(KERN_ERR "%s %s: F[%d] invalid!\n",
-			name, pci_name(dev), f);
+		pr_err("%s %s: F[%d] invalid!\n", name, pci_name(dev), f);
 		goto out;
 	}
 
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index e39ca1a..245fb5e 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -571,8 +571,8 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 
 #ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "%s: Set PIO timing for mode %d, reg: 0x%08x\n",
-		drive->name, pio,  *timings);
+	pr_err("%s: Set PIO timing for mode %d, reg: 0x%08x\n",
+	       drive->name, pio,  *timings);
 #endif	
 
 	*timings = t;
@@ -600,8 +600,8 @@ set_timings_udma_ata4(u32 *timings, u8 speed)
 			(addrTicks <<TR_66_UDMA_ADDRSETUP_SHIFT) |
 			TR_66_UDMA_EN;
 #ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "ide_pmac: Set UDMA timing for mode %d, reg: 0x%08x\n",
-		speed & 0xf,  *timings);
+	pr_err("ide_pmac: Set UDMA timing for mode %d, reg: 0x%08x\n",
+	       speed & 0xf, *timings);
 #endif	
 
 	return 0;
@@ -702,8 +702,8 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 		recTime = tm[i].recoveryTime;
 
 #ifdef IDE_PMAC_DEBUG
-		printk(KERN_ERR "%s: MDMA, cycleTime: %d, accessTime: %d, recTime: %d\n",
-			drive->name, cycleTime, accessTime, recTime);
+		pr_err("%s: MDMA, cycleTime: %d, accessTime: %d, recTime: %d\n",
+		       drive->name, cycleTime, accessTime, recTime);
 #endif
 	}
 	switch(intf_type) {
@@ -775,8 +775,8 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 		}
 	}
 #ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "%s: Set MDMA timing for mode %d, reg: 0x%08x\n",
-		drive->name, speed & 0xf,  *timings);
+	pr_err("%s: Set MDMA timing for mode %d, reg: 0x%08x\n",
+	       drive->name, speed & 0xf,  *timings);
 #endif	
 }
 
@@ -1159,8 +1159,8 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 
 	/* Request memory resource for IO ports */
 	if (macio_request_resource(mdev, 0, "ide-pmac (ports)")) {
-		printk(KERN_ERR "ide-pmac: can't request MMIO resource for "
-				"%s!\n", mdev->ofdev.node->full_name);
+		pr_err("ide-pmac: can't request MMIO resource for %s!\n",
+		       mdev->ofdev.node->full_name);
 		rc = -EBUSY;
 		goto out_free_pmif;
 	}
@@ -1272,7 +1272,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	np = pci_device_to_OF_node(pdev);
 	if (np == NULL) {
-		printk(KERN_ERR "ide-pmac: cannot find MacIO node for Kauai ATA interface\n");
+		pr_err("ide-pmac: cannot find MacIO node for Kauai ATA interface\n");
 		return -ENODEV;
 	}
 
@@ -1289,8 +1289,8 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 			
 	if (pci_request_regions(pdev, "Kauai ATA")) {
-		printk(KERN_ERR "ide-pmac: Cannot obtain PCI resources for "
-				"%s\n", np->full_name);
+		pr_err("ide-pmac: Cannot obtain PCI resources for %s\n",
+		       np->full_name);
 		rc = -ENXIO;
 		goto out_free_pmif;
 	}
@@ -1649,7 +1649,7 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	unsigned long status = readl(&dma->status);
 
-	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
+	pr_err("ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
 static const struct ide_dma_ops pmac_dma_ops = {
@@ -1687,8 +1687,7 @@ static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 		(MAX_DCMDS + 2) * sizeof(struct dbdma_cmd),
 		&hwif->dmatable_dma);
 	if (pmif->dma_table_cpu == NULL) {
-		printk(KERN_ERR "%s: unable to allocate DMA command list\n",
-		       hwif->name);
+		pr_err("%s: unable to allocate DMA command list\n", hwif->name);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index e027ac2..498794b 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -277,9 +277,9 @@ static int __init qd_testreg(int port)
 	local_irq_restore(flags);
 
 	if (savereg == QD_TESTVAL) {
-		printk(KERN_ERR "Outch ! the probe for qd65xx isn't reliable !\n");
-		printk(KERN_ERR "Please contact maintainers to tell about your hardware\n");
-		printk(KERN_ERR "Assuming qd65xx is not present.\n");
+		pr_err("Outch ! the probe for qd65xx isn't reliable !\n");
+		pr_err("Please contact maintainers to tell about your hardware\n");
+		pr_err("Assuming qd65xx is not present.\n");
 		return 1;
 	}
 
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 2dab04b..86861b4 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -528,7 +528,7 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 
 	ret = pci_request_selected_regions(dev, (1 << 2) - 1, name);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: can't reserve resources\n", name);
+		pr_err("%s: can't reserve resources\n", name);
 		return ret;
 	}
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index ac7cf22..52642d5 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -48,9 +48,9 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
-			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
-				"wanted 0x%04x, got 0x%04x\n",
-				name, pci_name(dev), progif | 5, progif);
+			pr_err("%s %s: rewrite of PROGIF failed, "
+			       "wanted 0x%04x, got 0x%04x\n",
+			       name, pci_name(dev), progif | 5, progif);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -92,8 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 		dma_base = pci_resource_start(dev, baridx);
 
 		if (dma_base == 0) {
-			printk(KERN_ERR "%s %s: DMA base is invalid\n",
-				d->name, pci_name(dev));
+			pr_err("%s %s: DMA base is invalid\n",
+			       d->name, pci_name(dev));
 			return 0;
 		}
 	}
@@ -155,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *dev, const char *name)
 
 		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
 		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
-			printk(KERN_ERR "%s %s: error updating PCICMD\n",
-				name, pci_name(dev));
+			pr_err("%s %s: error updating PCICMD\n",
+			       name, pci_name(dev));
 			return -EIO;
 		}
 	}
@@ -210,8 +210,7 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	ret = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: can't set DMA mask\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't set DMA mask\n", d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -229,8 +228,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 
 	ret = pci_request_selected_regions(dev, bars, d->name);
 	if (ret < 0)
-		printk(KERN_ERR "%s %s: can't reserve resources\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't reserve resources\n",
+		       d->name, pci_name(dev));
 out:
 	return ret;
 }
@@ -261,13 +260,13 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 		return -ENODEV;
 	}
 	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		return -EIO;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {
-		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: unable to enable IDE controller\n",
+		       d->name, pci_name(dev));
 		return -ENXIO;
 	}
 	return 0;
@@ -322,9 +321,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
-				"reported as MEM for port %d!\n",
-				d->name, pci_name(dev), port);
+			pr_err("%s %s: I/O baseregs (BIOS) are reported as MEM for port %d!\n",
+			       d->name, pci_name(dev), port);
 			return -EINVAL;
 		}
 
@@ -337,8 +335,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	}
 
 	if (!base || !ctl) {
-		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
-			d->name, pci_name(dev), port);
+		pr_err("%s %s: bad PCI BARs for port %d, skipping\n",
+		       d->name, pci_name(dev), port);
 		return -EINVAL;
 	}
 
@@ -426,8 +424,8 @@ static int ide_setup_pci_controller(struct pci_dev *dev,
 
 	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		goto out;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index 40615e8..c819051 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -158,12 +158,10 @@ sgiioc4_clearirq(ide_drive_t * drive)
 				readl((void __iomem *)(io_ports->irq_addr + 4));
 			pci_read_config_dword(dev, PCI_COMMAND,
 					      &pci_stat_cmd_reg);
-			printk(KERN_ERR
-			       "%s(%s) : PCI Bus Error when doing DMA:"
-				   " status-cmd reg is 0x%x\n",
+			pr_err("%s(%s) : PCI Bus Error when doing DMA:"
+			       " status-cmd reg is 0x%x\n",
 			       __func__, drive->name, pci_stat_cmd_reg);
-			printk(KERN_ERR
-			       "%s(%s) : PCI Error Address is 0x%x%x\n",
+			pr_err("%s(%s) : PCI Error Address is 0x%x%x\n",
 			       __func__, drive->name,
 			       pci_err_addr_high, pci_err_addr_low);
 			/* Clear the PCI Error indicator */
@@ -219,9 +217,7 @@ static int sgiioc4_dma_end(ide_drive_t *drive)
 	ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 	if (ioc4_dma & IOC4_S_DMA_STOP) {
-		printk(KERN_ERR
-		       "%s(%s): IOC4 DMA STOP bit is still 1 :"
-		       "ioc4_dma_reg 0x%x\n",
+		pr_err("%s(%s): IOC4 DMA STOP bit is still 1 :ioc4_dma_reg 0x%x\n",
 		       __func__, drive->name, ioc4_dma);
 		dma_stat = 1;
 	}
@@ -241,8 +237,7 @@ static int sgiioc4_dma_end(ide_drive_t *drive)
 		udelay(1);
 	}
 	if (!valid) {
-		printk(KERN_ERR "%s(%s) : DMA incomplete\n", __func__,
-		       drive->name);
+		pr_err("%s(%s) : DMA incomplete\n", __func__, drive->name);
 		dma_stat = 1;
 	}
 
@@ -251,9 +246,7 @@ static int sgiioc4_dma_end(ide_drive_t *drive)
 
 	if ((bc_dev & 0x01FF) || (bc_mem & 0x1FF)) {
 		if (bc_dev > bc_mem + 8) {
-			printk(KERN_ERR
-			       "%s(%s): WARNING!! byte_count_dev %d "
-			       "!= byte_count_mem %d\n",
+			pr_err("%s(%s): WARNING!! byte_count_dev %d != byte_count_mem %d\n",
 			       __func__, drive->name, bc_dev, bc_mem);
 		}
 	}
@@ -325,8 +318,8 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 	pr_info("    %s: MMIO-DMA\n", hwif->name);
 
 	if (request_mem_region(dma_base, num_ports, hwif->name) == NULL) {
-		printk(KERN_ERR "%s(%s) -- ERROR: addresses 0x%08lx to 0x%08lx "
-		       "already in use\n", __func__, hwif->name,
+		pr_err("%s(%s) -- ERROR: addresses 0x%08lx to 0x%08lx already in use\n",
+		       __func__, hwif->name,
 		       dma_base, dma_base + num_ports - 1);
 		return -1;
 	}
@@ -351,7 +344,7 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 	ide_release_dma_engine(hwif);
 
-	printk(KERN_ERR "%s(%s) -- ERROR: Unable to allocate DMA maps\n",
+	pr_err("%s(%s) -- ERROR: Unable to allocate DMA maps\n",
 	       __func__, hwif->name);
 	pr_info("%s: changing from DMA to PIO mode\n", hwif->name);
 
@@ -381,8 +374,7 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR
-			       "%s(%s) : IOC4 Dma STOP bit is still 1\n",
+			pr_err("%s(%s) : IOC4 Dma STOP bit is still 1\n",
 			       __func__, drive->name);
 	}
 
@@ -396,8 +388,7 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR
-			       "%s(%s) : IOC4 DMA STOP bit is still 1\n",
+			pr_err("%s(%s) : IOC4 DMA STOP bit is still 1\n",
 			       __func__, drive->name);
 	}
 
@@ -553,8 +544,8 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	bar0 = pci_resource_start(dev, 0);
 	virt_base = pci_ioremap_bar(dev, 0);
 	if (virt_base == NULL) {
-		printk(KERN_ERR "%s: Unable to remap BAR 0 address: 0x%lx\n",
-				DRV_NAME, bar0);
+		pr_err("%s: Unable to remap BAR 0 address: 0x%lx\n",
+		       DRV_NAME, bar0);
 		return -ENOMEM;
 	}
 	cmd_base = (unsigned long) virt_base + IOC4_CMD_OFFSET;
@@ -564,8 +555,8 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
 			       DRV_NAME) == NULL) {
-		printk(KERN_ERR "%s %s -- ERROR: addresses 0x%08lx to 0x%08lx "
-		       "already in use\n", DRV_NAME, pci_name(dev),
+		pr_err("%s %s -- ERROR: addresses 0x%08lx to 0x%08lx already in use\n",
+		       DRV_NAME, pci_name(dev),
 		       cmd_phys_base, cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		rc = -EBUSY;
 		goto req_mem_rgn_err;
@@ -600,10 +591,9 @@ pci_init_sgiioc4(struct pci_dev *dev)
 		DRV_NAME, pci_name(dev), dev->revision);
 
 	if (dev->revision < IOC4_SUPPORTED_FIRMWARE_REV) {
-		printk(KERN_ERR "Skipping %s IDE controller in slot %s: "
-				"firmware is obsolete - please upgrade to "
-				"revision46 or higher\n",
-				DRV_NAME, pci_name(dev));
+		pr_err("Skipping %s IDE controller in slot %s: "
+		       "firmware is obsolete - please upgrade to revision46 or higher\n",
+		       DRV_NAME, pci_name(dev));
 		ret = -EAGAIN;
 		goto out;
 	}
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index b4cf42d..dfd1b93 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -212,7 +212,7 @@ static int __devinit tc86c001_init_one(struct pci_dev *dev,
 
 	rc = pci_request_region(dev, 5, DRV_NAME);
 	if (rc) {
-		printk(KERN_ERR DRV_NAME ": system control regs already in use");
+		pr_err(DRV_NAME ": system control regs already in use\n");
 		goto out_disable;
 	}
 
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 564422d..32f03b9 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -276,8 +276,8 @@ static int tx4939ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 	}
 
 use_pio_instead:
-	printk(KERN_ERR "%s: %s\n", drive->name,
-		count ? "DMA table too small" : "empty DMA table?");
+	pr_err("%s: %s\n", drive->name,
+	       count ? "DMA table too small" : "empty DMA table?");
 
 	return 0; /* revert to PIO for this request */
 }
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 0608d41..afe5a9c 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -114,7 +114,7 @@ static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (mate)
 		spin_lock_irqsave(&mate->lock, flags);
 	if (mate && mate->handler) {
-		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
+		pr_err("umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
 		umc_set_speeds(current_speeds);
@@ -140,14 +140,14 @@ static int __init umc8672_probe(void)
 	unsigned long flags;
 
 	if (!request_region(0x108, 2, "umc8672")) {
-		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
+		pr_err("umc8672: ports 0x108-0x109 already in use.\n");
 		return 1;
 	}
 	local_irq_save(flags);
 	outb_p(0x5A, 0x108); /* enable umc */
 	if (in_umc (0xd5) != 0xa0) {
 		local_irq_restore(flags);
-		printk(KERN_ERR "umc8672: not found\n");
+		pr_err("umc8672: not found\n");
 		release_region(0x108, 2);
 		return 1;
 	}
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 9133575..26e7dcb 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -447,8 +447,7 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
-		printk(KERN_ERR DRV_NAME " %s: out of memory :(\n",
-			pci_name(dev));
+		pr_err(DRV_NAME " %s: out of memory :(\n", pci_name(dev));
 		return -ENOMEM;
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

