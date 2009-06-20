Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZFTLzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZFTLzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFTLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:55:37 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:46531 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZFTLzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=SBZpV/iEht052bUKpf2IDlkYC/1bCTEqvS87HDV7yg7BWVyKYKzYNymH1clkeoZDYm
         CUC0aW8m8MYOQJcOUSsuFWMJGrvihujE4Xrf/zY6RjXhSk8QwHu3D1UpXD6A8mPPcYdJ
         tKuMr4JtWl/xe8sAKEe05xhAzTuqH0Vs5nvcE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 3
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 20 Jun 2009 13:56:18 +0200
Message-Id: <200906201356.18953.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The last part of IDE changes for 2.6.31 merge window:

* Fix ide-cd OOPSing on failed commands. (Rainer Weikusat)

* IORDY handling fixes.

* Sanitize methods for IRQ clearing/testing. (Sergei Shtylyov)

* ATAPI support update. (Borislav Petkov)

* Misc fixes/cleanups.


Linus, please pull from 'for-2.6.31' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-2.6.31

to receive the following updates:

 drivers/ide/at91_ide.c         |    3 +-
 drivers/ide/buddha.c           |   40 +++++----
 drivers/ide/cmd640.c           |   13 +++
 drivers/ide/cmd64x.c           |  103 +++++++---------------
 drivers/ide/cs5536.c           |   23 +++--
 drivers/ide/falconide.c        |    1 -
 drivers/ide/gayle.c            |   33 ++++---
 drivers/ide/ht6560b.c          |   33 +++++--
 drivers/ide/icside.c           |   10 ++-
 drivers/ide/ide-atapi.c        |  138 +++++++++++++++++++-----------
 drivers/ide/ide-cd.c           |   78 +++--------------
 drivers/ide/ide-disk.c         |    9 +--
 drivers/ide/ide-floppy.c       |   56 +++++-------
 drivers/ide/ide-floppy_ioctl.c |   43 +++++-----
 drivers/ide/ide-io.c           |    8 +-
 drivers/ide/ide-ioctls.c       |   13 +--
 drivers/ide/ide-probe.c        |   17 +++-
 drivers/ide/ide-tape.c         |  186 ++++++++++++++++++----------------------
 drivers/ide/ide-xfer-mode.c    |   12 +++
 drivers/ide/it8172.c           |    2 +-
 drivers/ide/it8213.c           |    2 +-
 drivers/ide/macide.c           |   30 ++++---
 drivers/ide/opti621.c          |    8 +-
 drivers/ide/pdc202xx_old.c     |   24 +++++-
 drivers/ide/piix.c             |    2 +-
 drivers/ide/q40ide.c           |    7 +-
 drivers/ide/qd65xx.c           |   11 ++-
 drivers/ide/qd65xx.h           |   11 ++-
 drivers/ide/sgiioc4.c          |  119 ++++++++++++--------------
 drivers/ide/siimage.c          |   42 +++------
 drivers/ide/sl82c105.c         |   32 +++++--
 drivers/ide/slc90e66.c         |    2 +-
 include/linux/ata.h            |   14 +++
 include/linux/ide.h            |   47 +++++-----
 34 files changed, 598 insertions(+), 574 deletions(-)


Bartlomiej Zolnierkiewicz (7):
      Merge branch 'bp-remove-pc-buf' into for-next
      ata: add ata_id_pio_need_iordy() helper (v2)
      ide: IORDY handling fixes
      ide: don't enable IORDY at a probe time
      ide: filter out invalid DMA xfer mode changes in HDIO_DRIVE_CMD ioctl handler
      ide: BUG() on unknown requests
      Merge branch 'for-2.6.31' into 2.6.31

Borislav Petkov (16):
      ide-tape: fix potential fs requests bug
      ide-atapi: switch to blk_rq_bytes() on do_request() path
      ide-atapi: switch to rq->resid_len
      ide-atapi: add a len-parameter to ide_queue_pc_tail
      ide-atapi: add a buffer-arg to ide_queue_pc_tail
      ide-floppy/ide_floppy_get_flexible_disk_page: use local buffer
      ide-floppy/ide_floppy_get_sfrp_bit: use local buffer
      ide-floppy/ide_floppy_format_unit: use local buffer
      ide-atapi: use local sense buffer
      ide-floppy/ide_floppy_get_format_progress: use local sense buffer
      ide-tape/ide_tape_get_bsize_from_bdesc: use local buffer
      ide-tape: fix READ POSITION cmd handling
      ide-atapi: remove pc->buf
      ide-cd: use whole request_sense buffer in EH
      ide: unify interrupt reason checking
      ide-tape: fix build issue

Joao Ramos (1):
      ide: do not access ide_drive_t 'drive_data' field directly

Rainer Weikusat (1):
      ide-cd: prevent null pointer deref via cdrom_newpc_intr

Sergei Shtylyov (11):
      sgiioc4: coding style cleanup
      ide: call clear_irq() method in ide_timer_expiry()
      cmd64x: implement clear_irq() method (take 2)
      siimage: use ide_dma_test_irq() (take 2)
      ide: move IRQ clearing from ack_intr() method to clear_irq() method (take 2)
      ide: move ack_intr() method into 'struct ide_port_ops' (take 2)
      cmd640: implement test_irq() method
      cmd64x: implement test_irq() method
      pdc202xx_old: implement test_irq() method (take 2)
      siimage: implement test_irq() method
      sl82c105: implement test_irq() method


diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index fc0949a..dbfeda4 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -185,8 +185,7 @@ static void at91_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	timing = ide_timing_find_mode(XFER_PIO_0 + pio);
 	BUG_ON(!timing);
 
-	if ((pio > 2 || ata_id_has_iordy(drive->id)) &&
-	    !(ata_id_is_cfa(drive->id) && pio > 4))
+	if (ide_pio_need_iordy(drive, pio))
 		use_iordy = 1;
 
 	apply_timings(chipselect, pio, timing, use_iordy);
diff --git a/drivers/ide/buddha.c b/drivers/ide/buddha.c
index e3c6a59..ab4f169 100644
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -99,7 +99,7 @@ static const char *buddha_board_name[] = { "Buddha", "Catweasel", "X-Surf" };
      *  Check and acknowledge the interrupt status
      */
 
-static int buddha_ack_intr(ide_hwif_t *hwif)
+static int buddha_test_irq(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
@@ -109,21 +109,16 @@ static int buddha_ack_intr(ide_hwif_t *hwif)
     return 1;
 }
 
-static int xsurf_ack_intr(ide_hwif_t *hwif)
+static void xsurf_clear_irq(ide_drive_t *drive)
 {
-    unsigned char ch;
-
-    ch = z_readb(hwif->io_ports.irq_addr);
-    /* X-Surf needs a 0 written to IRQ register to ensure ISA bit A11 stays at 0 */
-    z_writeb(0, hwif->io_ports.irq_addr);
-    if (!(ch & 0x80))
-	    return 0;
-    return 1;
+    /*
+     * X-Surf needs 0 written to IRQ register to ensure ISA bit A11 stays at 0
+     */
+    z_writeb(0, drive->hwif->io_ports.irq_addr);
 }
 
 static void __init buddha_setup_ports(struct ide_hw *hw, unsigned long base,
-				      unsigned long ctl, unsigned long irq_port,
-				      ide_ack_intr_t *ack_intr)
+				      unsigned long ctl, unsigned long irq_port)
 {
 	int i;
 
@@ -138,10 +133,19 @@ static void __init buddha_setup_ports(struct ide_hw *hw, unsigned long base,
 	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
-	hw->ack_intr = ack_intr;
 }
 
+static const struct ide_port_ops buddha_port_ops = {
+	.test_irq		= buddha_test_irq,
+};
+
+static const struct ide_port_ops xsurf_port_ops = {
+	.clear_irq		= xsurf_clear_irq,
+	.test_irq		= buddha_test_irq,
+};
+
 static const struct ide_port_info buddha_port_info = {
+	.port_ops		= &buddha_port_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
 	.chipset		= ide_generic,
@@ -161,6 +165,7 @@ static int __init buddha_init(void)
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
 		struct ide_hw hw[MAX_NUM_HWIFS], *hws[MAX_NUM_HWIFS];
+		struct ide_port_info d = buddha_port_info;
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
@@ -171,6 +176,7 @@ static int __init buddha_init(void)
 		} else if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF) {
 			buddha_num_hwifs = XSURF_NUM_HWIFS;
 			type=BOARD_XSURF;
+			d.port_ops = &xsurf_port_ops;
 		} else 
 			continue;
 		
@@ -203,28 +209,24 @@ fail_base2:
 
 		for (i = 0; i < buddha_num_hwifs; i++) {
 			unsigned long base, ctl, irq_port;
-			ide_ack_intr_t *ack_intr;
 
 			if (type != BOARD_XSURF) {
 				base = buddha_board + buddha_bases[i];
 				ctl = base + BUDDHA_CONTROL;
 				irq_port = buddha_board + buddha_irqports[i];
-				ack_intr = buddha_ack_intr;
 			} else {
 				base = buddha_board + xsurf_bases[i];
 				/* X-Surf has no CS1* (Control/AltStat) */
 				ctl = 0;
 				irq_port = buddha_board + xsurf_irqports[i];
-				ack_intr = xsurf_ack_intr;
 			}
 
-			buddha_setup_ports(&hw[i], base, ctl, irq_port,
-					   ack_intr);
+			buddha_setup_ports(&hw[i], base, ctl, irq_port);
 
 			hws[i] = &hw[i];
 		}
 
-		ide_host_add(&buddha_port_info, hws, i, NULL);
+		ide_host_add(&d, hws, i, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 1683ed5..1a32d62 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -153,6 +153,7 @@ static int cmd640_vlb;
 #define ARTTIM23	0x57
 #define   ARTTIM23_DIS_RA2	0x04
 #define   ARTTIM23_DIS_RA3	0x08
+#define   ARTTIM23_IDE23INTR	0x10
 #define DRWTIM23	0x58
 #define BRST		0x59
 
@@ -629,12 +630,24 @@ static void cmd640_init_dev(ide_drive_t *drive)
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
+static int cmd640_test_irq(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
+	u8  irq_stat, irq_mask	= hwif->channel ? ARTTIM23_IDE23INTR :
+						  CFR_IDE01INTR;
+
+	pci_read_config_byte(dev, irq_reg, &irq_stat);
+
+	return (irq_stat & irq_mask) ? 1 : 0;
+}
 
 static const struct ide_port_ops cmd640_port_ops = {
 	.init_dev		= cmd640_init_dev,
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	.set_pio_mode		= cmd640_set_pio_mode,
 #endif
+	.test_irq		= cmd640_test_irq,
 };
 
 static int pci_conf1(void)
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index 80b777e..03c8620 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -7,7 +7,7 @@
  * Copyright (C) 1998		David S. Miller (davem@redhat.com)
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
+ * Copyright (C) 2007,2009	MontaVista Software, Inc. <source@mvista.com>
  */
 
 #include <linux/module.h>
@@ -118,8 +118,9 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
+	unsigned long setup_count;
 	unsigned int cycle_time;
-	u8 setup_count, arttim = 0;
+	u8 arttim = 0;
 
 	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
 	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
@@ -140,10 +141,11 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 	if (hwif->channel) {
 		ide_drive_t *pair = ide_get_pair_dev(drive);
 
-		drive->drive_data = setup_count;
+		ide_set_drivedata(drive, (void *)setup_count);
 
 		if (pair)
-			setup_count = max_t(u8, setup_count, pair->drive_data);
+			setup_count = max_t(u8, setup_count,
+					(unsigned long)ide_get_drivedata(pair));
 	}
 
 	if (setup_count > 5)		/* shouldn't actually happen... */
@@ -226,11 +228,11 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		(void) pci_write_config_byte(dev, pciU, regU);
 }
 
-static int cmd648_dma_end(ide_drive_t *drive)
+static void cmd648_clear_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
-	int err			= ide_dma_end(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long base	= pci_resource_start(dev, 4);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
 	u8  mrdmode		= inb(base + 1);
@@ -238,11 +240,9 @@ static int cmd648_dma_end(ide_drive_t *drive)
 	/* clear the interrupt bit */
 	outb((mrdmode & ~(MRDMODE_INTR_CH0 | MRDMODE_INTR_CH1)) | irq_mask,
 	     base + 1);
-
-	return err;
 }
 
-static int cmd64x_dma_end(ide_drive_t *drive)
+static void cmd64x_clear_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -250,62 +250,40 @@ static int cmd64x_dma_end(ide_drive_t *drive)
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
 	u8  irq_stat		= 0;
-	int err			= ide_dma_end(drive);
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
 	/* clear the interrupt bit */
 	(void) pci_write_config_byte(dev, irq_reg, irq_stat | irq_mask);
-
-	return err;
 }
 
-static int cmd648_dma_test_irq(ide_drive_t *drive)
+static int cmd648_test_irq(ide_hwif_t *hwif)
 {
-	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long base	= pci_resource_start(dev, 4);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
-	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 mrdmode		= inb(base + 1);
 
-#ifdef DEBUG
-	printk("%s: dma_stat: 0x%02x mrdmode: 0x%02x irq_mask: 0x%02x\n",
-	       drive->name, dma_stat, mrdmode, irq_mask);
-#endif
-	if (!(mrdmode & irq_mask))
-		return 0;
-
-	/* return 1 if INTR asserted */
-	if (dma_stat & 4)
-		return 1;
+	pr_debug("%s: mrdmode: 0x%02x irq_mask: 0x%02x\n",
+		 hwif->name, mrdmode, irq_mask);
 
-	return 0;
+	return (mrdmode & irq_mask) ? 1 : 0;
 }
 
-static int cmd64x_dma_test_irq(ide_drive_t *drive)
+static int cmd64x_test_irq(ide_hwif_t *hwif)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
-	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8  irq_stat		= 0;
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
 
-#ifdef DEBUG
-	printk("%s: dma_stat: 0x%02x irq_stat: 0x%02x irq_mask: 0x%02x\n",
-	       drive->name, dma_stat, irq_stat, irq_mask);
-#endif
-	if (!(irq_stat & irq_mask))
-		return 0;
-
-	/* return 1 if INTR asserted */
-	if (dma_stat & 4)
-		return 1;
+	pr_debug("%s: irq_stat: 0x%02x irq_mask: 0x%02x\n",
+		 hwif->name, irq_stat, irq_mask);
 
-	return 0;
+	return (irq_stat & irq_mask) ? 1 : 0;
 }
 
 /*
@@ -370,18 +348,17 @@ static u8 cmd64x_cable_detect(ide_hwif_t *hwif)
 static const struct ide_port_ops cmd64x_port_ops = {
 	.set_pio_mode		= cmd64x_set_pio_mode,
 	.set_dma_mode		= cmd64x_set_dma_mode,
+	.clear_irq		= cmd64x_clear_irq,
+	.test_irq		= cmd64x_test_irq,
 	.cable_detect		= cmd64x_cable_detect,
 };
 
-static const struct ide_dma_ops cmd64x_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_start		= ide_dma_start,
-	.dma_end		= cmd64x_dma_end,
-	.dma_test_irq		= cmd64x_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_sff_read_status	= ide_dma_sff_read_status,
+static const struct ide_port_ops cmd648_port_ops = {
+	.set_pio_mode		= cmd64x_set_pio_mode,
+	.set_dma_mode		= cmd64x_set_dma_mode,
+	.clear_irq		= cmd648_clear_irq,
+	.test_irq		= cmd648_test_irq,
+	.cable_detect		= cmd64x_cable_detect,
 };
 
 static const struct ide_dma_ops cmd646_rev1_dma_ops = {
@@ -395,24 +372,12 @@ static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_dma_ops cmd648_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_start		= ide_dma_start,
-	.dma_end		= cmd648_dma_end,
-	.dma_test_irq		= cmd648_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_sff_read_status	= ide_dma_sff_read_status,
-};
-
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	{	/* 0: CMD643 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
-		.dma_ops	= &cmd64x_dma_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
@@ -423,8 +388,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.port_ops	= &cmd64x_port_ops,
-		.dma_ops	= &cmd648_dma_ops,
+		.port_ops	= &cmd648_port_ops,
 		.host_flags	= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
@@ -435,8 +399,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.port_ops	= &cmd64x_port_ops,
-		.dma_ops	= &cmd648_dma_ops,
+		.port_ops	= &cmd648_port_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -446,8 +409,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.port_ops	= &cmd64x_port_ops,
-		.dma_ops	= &cmd648_dma_ops,
+		.port_ops	= &cmd648_port_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -484,10 +446,9 @@ static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_devic
 			 */
 			if (dev->revision < 3) {
 				d.enablebits[0].reg = 0;
+				d.port_ops = &cmd64x_port_ops;
 				if (dev->revision == 1)
 					d.dma_ops = &cmd646_rev1_dma_ops;
-				else
-					d.dma_ops = &cmd64x_dma_ops;
 			}
 		}
 	}
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index 0332a95..9623b85 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -146,14 +146,16 @@ static void cs5536_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int cshift = (drive->dn & 1) ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u32 cast;
 	u8 cmd_pio = pio;
 
 	if (pair)
 		cmd_pio = min(pio, ide_get_best_pio_mode(pair, 255, 4));
 
-	drive->drive_data &= (IDE_DRV_MASK << 8);
-	drive->drive_data |= drv_timings[pio];
+	timings &= (IDE_DRV_MASK << 8);
+	timings |= drv_timings[pio];
+	ide_set_drivedata(drive, (void *)timings);
 
 	cs5536_program_dtc(drive, drv_timings[pio]);
 
@@ -186,6 +188,7 @@ static void cs5536_set_dma_mode(ide_drive_t *drive, const u8 mode)
 
 	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
 	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u32 etc;
 
 	cs5536_read(pdev, ETC, &etc);
@@ -195,8 +198,9 @@ static void cs5536_set_dma_mode(ide_drive_t *drive, const u8 mode)
 		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
 	} else { /* MWDMA */
 		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
-		drive->drive_data &= IDE_DRV_MASK;
-		drive->drive_data |= mwdma_timings[mode - XFER_MW_DMA_0] << 8;
+		timings &= IDE_DRV_MASK;
+		timings |= mwdma_timings[mode - XFER_MW_DMA_0] << 8;
+		ide_set_drivedata(drive, (void *)timings);
 	}
 
 	cs5536_write(pdev, ETC, etc);
@@ -204,9 +208,11 @@ static void cs5536_set_dma_mode(ide_drive_t *drive, const u8 mode)
 
 static void cs5536_dma_start(ide_drive_t *drive)
 {
+	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
+
 	if (drive->current_speed < XFER_UDMA_0 &&
-	    (drive->drive_data >> 8) != (drive->drive_data & IDE_DRV_MASK))
-		cs5536_program_dtc(drive, drive->drive_data >> 8);
+	    (timings >> 8) != (timings & IDE_DRV_MASK))
+		cs5536_program_dtc(drive, timings >> 8);
 
 	ide_dma_start(drive);
 }
@@ -214,10 +220,11 @@ static void cs5536_dma_start(ide_drive_t *drive)
 static int cs5536_dma_end(ide_drive_t *drive)
 {
 	int ret = ide_dma_end(drive);
+	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 
 	if (drive->current_speed < XFER_UDMA_0 &&
-	    (drive->drive_data >> 8) != (drive->drive_data & IDE_DRV_MASK))
-		cs5536_program_dtc(drive, drive->drive_data & IDE_DRV_MASK);
+	    (timings >> 8) != (timings & IDE_DRV_MASK))
+		cs5536_program_dtc(drive, timings & IDE_DRV_MASK);
 
 	return ret;
 }
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index 22fa273..a5a07cc 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -128,7 +128,6 @@ static void __init falconide_setup_ports(struct ide_hw *hw)
 	hw->io_ports.ctl_addr = ATA_HD_BASE + ATA_HD_CONTROL;
 
 	hw->irq = IRQ_MFP_IDE;
-	hw->ack_intr = NULL;
 }
 
     /*
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index 4451a6a..b9e517d 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
      *  Check and acknowledge the interrupt status
      */
 
-static int gayle_ack_intr_a4000(ide_hwif_t *hwif)
+static int gayle_test_irq(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
@@ -76,21 +76,16 @@ static int gayle_ack_intr_a4000(ide_hwif_t *hwif)
     return 1;
 }
 
-static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
+static void gayle_a1200_clear_irq(ide_drive_t *drive)
 {
-    unsigned char ch;
+    ide_hwif_t *hwif = drive->hwif;
 
-    ch = z_readb(hwif->io_ports.irq_addr);
-    if (!(ch & GAYLE_IRQ_IDE))
-	return 0;
     (void)z_readb(hwif->io_ports.status_addr);
     z_writeb(0x7c, hwif->io_ports.irq_addr);
-    return 1;
 }
 
 static void __init gayle_setup_ports(struct ide_hw *hw, unsigned long base,
-				     unsigned long ctl, unsigned long irq_port,
-				     ide_ack_intr_t *ack_intr)
+				     unsigned long ctl, unsigned long irq_port)
 {
 	int i;
 
@@ -105,9 +100,17 @@ static void __init gayle_setup_ports(struct ide_hw *hw, unsigned long base,
 	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
-	hw->ack_intr = ack_intr;
 }
 
+static const struct ide_port_ops gayle_a4000_port_ops = {
+	.test_irq		= gayle_test_irq,
+};
+
+static const struct ide_port_ops gayle_a1200_port_ops = {
+	.clear_irq		= gayle_a1200_clear_irq,
+	.test_irq		= gayle_test_irq,
+};
+
 static const struct ide_port_info gayle_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
@@ -123,9 +126,9 @@ static int __init gayle_init(void)
 {
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
-    ide_ack_intr_t *ack_intr;
     int a4000, i, rc;
     struct ide_hw hw[GAYLE_NUM_HWIFS], *hws[GAYLE_NUM_HWIFS];
+    struct ide_port_info d = gayle_port_info;
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
@@ -148,11 +151,11 @@ found:
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
 	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_4000);
-	    ack_intr = gayle_ack_intr_a4000;
+	    d.port_ops = &gayle_a4000_port_ops;
 	} else {
 	    phys_base = GAYLE_BASE_1200;
 	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_1200);
-	    ack_intr = gayle_ack_intr_a1200;
+	    d.port_ops = &gayle_a1200_port_ops;
 	}
 
 	res_start = ((unsigned long)phys_base) & ~(GAYLE_NEXT_PORT-1);
@@ -165,12 +168,12 @@ found:
 	base = (unsigned long)ZTWO_VADDR(phys_base + i * GAYLE_NEXT_PORT);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
-	gayle_setup_ports(&hw[i], base, ctrlport, irqport, ack_intr);
+	gayle_setup_ports(&hw[i], base, ctrlport, irqport);
 
 	hws[i] = &hw[i];
     }
 
-    rc = ide_host_add(&gayle_port_info, hws, i, NULL);
+    rc = ide_host_add(&d, hws, i, NULL);
     if (rc)
 	release_mem_region(res_start, res_n);
 
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index 2fb0f29..aafed80 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -44,7 +44,12 @@
  *    bit3 (0x08): "1" 3 cycle time, "0" 2 cycle time	      (?)
  */
 #define HT_CONFIG_PORT	  0x3e6
-#define HT_CONFIG(drivea) (u8)(((drivea)->drive_data & 0xff00) >> 8)
+
+static inline u8 HT_CONFIG(ide_drive_t *drive)
+{
+	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
+}
+
 /*
  * FIFO + PREFETCH (both a/b-model)
  */
@@ -90,7 +95,11 @@
  * Active Time for each drive. Smaller value gives higher speed.
  * In case of failures you should probably fall back to a higher value.
  */
-#define HT_TIMING(drivea) (u8)((drivea)->drive_data & 0x00ff)
+static inline u8 HT_TIMING(ide_drive_t *drive)
+{
+	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
+}
+
 #define HT_TIMING_DEFAULT 0xff
 
 /*
@@ -242,23 +251,27 @@ static DEFINE_SPINLOCK(ht6560b_lock);
  */
 static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 {
-	unsigned long flags;
+	unsigned long flags, config;
 	int t = HT_PREFETCH_MODE << 8;
 
 	spin_lock_irqsave(&ht6560b_lock, flags);
 
+	config = (unsigned long)ide_get_drivedata(drive);
+
 	/*
 	 *  Prefetch mode and unmask irq seems to conflict
 	 */
 	if (state) {
-		drive->drive_data |= t;   /* enable prefetch mode */
+		config |= t;   /* enable prefetch mode */
 		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
 		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 	} else {
-		drive->drive_data &= ~t;  /* disable prefetch mode */
+		config &= ~t;  /* disable prefetch mode */
 		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
 	}
 
+	ide_set_drivedata(drive, (void *)config);
+
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
 
 #ifdef DEBUG
@@ -268,7 +281,7 @@ static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 
 static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	unsigned long flags;
+	unsigned long flags, config;
 	u8 timing;
 	
 	switch (pio) {
@@ -281,8 +294,10 @@ static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	timing = ht_pio2timings(drive, pio);
 
 	spin_lock_irqsave(&ht6560b_lock, flags);
-	drive->drive_data &= 0xff00;
-	drive->drive_data |= timing;
+	config = (unsigned long)ide_get_drivedata(drive);
+	config &= 0xff00;
+	config |= timing;
+	ide_set_drivedata(drive, (void *)config);
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
 
 #ifdef DEBUG
@@ -299,7 +314,7 @@ static void __init ht6560b_init_dev(ide_drive_t *drive)
 	if (hwif->channel)
 		t |= (HT_SECONDARY_IF << 8);
 
-	drive->drive_data = t;
+	ide_set_drivedata(drive, (void *)t);
 }
 
 static int probe_ht6560b;
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 5af3d0f..0f67f1a 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -187,7 +187,8 @@ static const expansioncard_ops_t icside_ops_arcin_v6 = {
  */
 static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 {
-	int cycle_time, use_dma_info = 0;
+	unsigned long cycle_time;
+	int use_dma_info = 0;
 
 	switch (xfer_mode) {
 	case XFER_MW_DMA_2:
@@ -218,10 +219,11 @@ static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 	if (use_dma_info && drive->id[ATA_ID_EIDE_DMA_TIME] > cycle_time)
 		cycle_time = drive->id[ATA_ID_EIDE_DMA_TIME];
 
-	drive->drive_data = cycle_time;
+	ide_set_drivedata(drive, (void *)cycle_time);
 
 	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
-		ide_xfer_verbose(xfer_mode), 2000 / drive->drive_data);
+		ide_xfer_verbose(xfer_mode),
+		2000 / (unsigned long)ide_get_drivedata(drive));
 }
 
 static const struct ide_port_ops icside_v6_port_ops = {
@@ -277,7 +279,7 @@ static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	/*
 	 * Select the correct timing for this drive.
 	 */
-	set_dma_speed(ec->dma, drive->drive_data);
+	set_dma_speed(ec->dma, (unsigned long)ide_get_drivedata(drive));
 
 	/*
 	 * Tell the DMA engine about the SG table and
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 702ef64..eb2181a 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -10,6 +10,9 @@
 
 #include <scsi/scsi.h>
 
+#define DRV_NAME "ide-atapi"
+#define PFX DRV_NAME ": "
+
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
 	printk(KERN_INFO "ide: " fmt, ## args)
@@ -74,8 +77,6 @@ EXPORT_SYMBOL_GPL(ide_check_atapi_device);
 void ide_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDE_PC_BUFFER_SIZE;
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
@@ -84,7 +85,7 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * and wait for it to be serviced.
  */
 int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
-		      struct ide_atapi_pc *pc)
+		      struct ide_atapi_pc *pc, void *buf, unsigned int bufflen)
 {
 	struct request *rq;
 	int error;
@@ -93,8 +94,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = (char *)pc;
 
-	if (pc->req_xfer) {
-		error = blk_rq_map_kern(drive->queue, rq, pc->buf, pc->req_xfer,
+	if (buf && bufflen) {
+		error = blk_rq_map_kern(drive->queue, rq, buf, bufflen,
 					GFP_NOIO);
 		if (error)
 			goto put_req;
@@ -117,7 +118,7 @@ int ide_do_test_unit_ready(ide_drive_t *drive, struct gendisk *disk)
 	ide_init_pc(&pc);
 	pc.c[0] = TEST_UNIT_READY;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_test_unit_ready);
 
@@ -132,7 +133,7 @@ int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
 	if (drive->media == ide_tape)
 		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_start_stop);
 
@@ -147,7 +148,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc.c[4] = on;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
@@ -172,8 +173,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	unsigned int cmd_len, sense_len;
 	int err;
 
-	debug_log("%s: enter\n", __func__);
-
 	switch (drive->media) {
 	case ide_floppy:
 		cmd_len = 255;
@@ -201,8 +200,8 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 			      GFP_NOIO);
 	if (unlikely(err)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING "%s: failed to map sense buffer\n",
-			       drive->name);
+			printk(KERN_WARNING PFX "%s: failed to map sense "
+					    "buffer\n", drive->name);
 		return;
 	}
 
@@ -223,7 +222,7 @@ int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 {
 	/* deferred failure from ide_prep_sense() */
 	if (!drive->sense_rq_armed) {
-		printk(KERN_WARNING "%s: failed queue sense request\n",
+		printk(KERN_WARNING PFX "%s: error queuing a sense request\n",
 		       drive->name);
 		return -ENOMEM;
 	}
@@ -255,8 +254,6 @@ void ide_retry_pc(ide_drive_t *drive)
 	/* init pc from sense_rq */
 	ide_init_pc(pc);
 	memcpy(pc->c, sense_rq->cmd, 12);
-	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */
-	pc->req_xfer = blk_rq_bytes(sense_rq);
 
 	if (drive->media == ide_tape)
 		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
@@ -298,7 +295,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "cmd 0x%x timed out\n",
+			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
 					 rq->cmd[0]);
 		wait = 0;
 		break;
@@ -332,6 +329,55 @@ void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
 /*
+ * Check the contents of the interrupt reason register and attempt to recover if
+ * there are problems.
+ *
+ * Returns:
+ * - 0 if everything's ok
+ * - 1 if the request has to be terminated.
+ */
+int ide_check_ireason(ide_drive_t *drive, struct request *rq, int len,
+		      int ireason, int rw)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	debug_log("ireason: 0x%x, rw: 0x%x\n", ireason, rw);
+
+	if (ireason == (!rw << 1))
+		return 0;
+	else if (ireason == (rw << 1)) {
+		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
+				drive->name, __func__);
+
+		if (dev_is_idecd(drive))
+			ide_pad_transfer(drive, rw, len);
+	} else if (!rw && ireason == ATAPI_COD) {
+		if (dev_is_idecd(drive)) {
+			/*
+			 * Some drives (ASUS) seem to tell us that status info
+			 * is available.  Just get it and ignore.
+			 */
+			(void)hwif->tp_ops->read_status(hwif);
+			return 0;
+		}
+	} else {
+		if (ireason & ATAPI_COD)
+			printk(KERN_ERR PFX "%s: CoD != 0 in %s\n", drive->name,
+					__func__);
+
+		/* drive wants a command packet, or invalid ireason... */
+		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
+				drive->name, __func__, ireason);
+	}
+
+	if (dev_is_idecd(drive) && rq->cmd_type == REQ_TYPE_ATA_PC)
+		rq->cmd_flags |= REQ_FAILED;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ide_check_ireason);
+
+/*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
  * and will re-point interrupt handler to us.
@@ -365,12 +411,12 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
-				printk(KERN_ERR "%s: DMA %s error\n",
+				printk(KERN_ERR PFX "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else
-			pc->xferred = pc->req_xfer;
+			rq->resid_len = 0;
 		debug_log("%s: DMA finished\n", drive->name);
 	}
 
@@ -379,7 +425,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		int uptodate, error;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
-			  pc->xferred);
+			  blk_rq_bytes(rq));
 
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
@@ -397,8 +443,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 				pc->rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
+				printk(KERN_ERR PFX "%s: I/O error in request "
+						"sense command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 
@@ -446,8 +492,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
+		printk(KERN_ERR PFX "%s: The device wants to issue more "
+				"interrupts in DMA mode\n", drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -455,33 +501,22 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* Get the number of bytes to transfer on this interrupt. */
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
-	if (ireason & ATAPI_COD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+	if (ide_check_ireason(drive, rq, bcount, ireason, write))
 		return ide_do_reset(drive);
-	}
-
-	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & ATAPI_IO) ? "Write" : "Read",
-				(ireason & ATAPI_IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
 
 	done = min_t(unsigned int, bcount, cmd->nleft);
 	ide_pio_bytes(drive, cmd, write, done);
 
 	/* Update transferred byte count */
-	pc->xferred += done;
+	rq->resid_len -= done;
 
 	bcount -= done;
 
 	if (bcount)
 		ide_pad_transfer(drive, write, bcount);
 
-	debug_log("[cmd %x] transferred %d bytes, padded %d bytes\n",
-		  rq->cmd[0], done, bcount);
+	debug_log("[cmd %x] transferred %d bytes, padded %d bytes, resid: %u\n",
+		  rq->cmd[0], done, bcount, rq->resid_len);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, ide_pc_intr, timeout);
@@ -515,13 +550,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 
 	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
 		(ireason & ATAPI_IO))) {
-		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+		printk(KERN_ERR PFX "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
 		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
-			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-					"a packet command, ignoring\n",
+			printk(KERN_ERR PFX "%s: (IO,CoD != (0,1) while issuing"
+					" a packet command, ignoring\n",
 					drive->name);
 			ireason |= ATAPI_COD;
 			ireason &= ~ATAPI_IO;
@@ -552,7 +587,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+		printk(KERN_ERR PFX "%s: Strange, packet command initiated yet "
 				"DRQ isn't asserted\n", drive->name);
 		return startstop;
 	}
@@ -594,8 +629,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			ireason = ide_wait_ireason(drive, ireason);
 
 		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-			printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-					"a packet command\n", drive->name);
+			printk(KERN_ERR PFX "%s: (IO,CoD) != (0,1) while "
+				"issuing a packet command\n", drive->name);
 
 			return ide_do_reset(drive);
 		}
@@ -633,7 +668,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
-	unsigned int timeout;
+	unsigned int timeout, bytes;
 	u16 bcount;
 	u8 valid_tf;
 	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
@@ -649,13 +684,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	} else {
 		pc = drive->pc;
 
-		/* We haven't transferred any data yet */
-		pc->xferred = 0;
-
 		valid_tf = IDE_VALID_DEVICE;
-		bcount = ((drive->media == ide_tape) ?
-				pc->req_xfer :
-				min(pc->req_xfer, 63 * 1024));
+		bytes = blk_rq_bytes(rq);
+		bcount = ((drive->media == ide_tape) ? bytes
+						     : min_t(unsigned int,
+							     bytes, 63 * 1024));
+
+		/* We haven't transferred any data yet */
+		rq->resid_len = bcount;
 
 		if (pc->flags & PC_FLAG_DMA_ERROR) {
 			pc->flags &= ~PC_FLAG_DMA_ERROR;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 424140c..4a19686 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -92,16 +92,16 @@ static void cdrom_saw_media_change(ide_drive_t *drive)
 	drive->atapi_flags &= ~IDE_AFLAG_TOC_VALID;
 }
 
-static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
-			   struct request_sense *sense)
+static int cdrom_log_sense(ide_drive_t *drive, struct request *rq)
 {
+	struct request_sense *sense = &drive->sense_data;
 	int log = 0;
 
-	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
-
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
 
+	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
+
 	switch (sense->sense_key) {
 	case NO_SENSE:
 	case RECOVERED_ERROR:
@@ -140,12 +140,12 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 }
 
 static void cdrom_analyze_sense_data(ide_drive_t *drive,
-			      struct request *failed_command,
-			      struct request_sense *sense)
+				     struct request *failed_command)
 {
+	struct request_sense *sense = &drive->sense_data;
+	struct cdrom_info *info = drive->driver_data;
 	unsigned long sector;
 	unsigned long bio_sectors;
-	struct cdrom_info *info = drive->driver_data;
 
 	ide_debug_log(IDE_DBG_SENSE, "error_code: 0x%x, sense_key: 0x%x",
 				     sense->error_code, sense->sense_key);
@@ -154,7 +154,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 		ide_debug_log(IDE_DBG_SENSE, "failed cmd: 0x%x",
 					     failed_command->cmd[0]);
 
-	if (!cdrom_log_sense(drive, failed_command, sense))
+	if (!cdrom_log_sense(drive, failed_command))
 		return;
 
 	/*
@@ -225,15 +225,14 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 			 * sense pointer set.
 			 */
 			memcpy(failed->sense, sense, 18);
-			sense = failed->sense;
 			failed->sense_len = rq->sense_len;
 		}
-		cdrom_analyze_sense_data(drive, failed, sense);
+		cdrom_analyze_sense_data(drive, failed);
 
 		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
 			BUG();
 	} else
-		cdrom_analyze_sense_data(drive, NULL, sense);
+		cdrom_analyze_sense_data(drive, NULL);
 }
 
 
@@ -410,50 +409,6 @@ end_request:
 		return 2;
 }
 
-/*
- * Check the contents of the interrupt reason register from the cdrom
- * and attempt to recover if there are problems.  Returns  0 if everything's
- * ok; nonzero if the request has been terminated.
- */
-static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
-				int len, int ireason, int rw)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	ide_debug_log(IDE_DBG_FUNC, "ireason: 0x%x, rw: 0x%x", ireason, rw);
-
-	/*
-	 * ireason == 0: the drive wants to receive data from us
-	 * ireason == 2: the drive is expecting to transfer data to us
-	 */
-	if (ireason == (!rw << 1))
-		return 0;
-	else if (ireason == (rw << 1)) {
-
-		/* whoops... */
-		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
-				drive->name, __func__);
-
-		ide_pad_transfer(drive, rw, len);
-	} else  if (rw == 0 && ireason == 1) {
-		/*
-		 * Some drives (ASUS) seem to tell us that status info is
-		 * available.  Just get it and ignore.
-		 */
-		(void)hwif->tp_ops->read_status(hwif);
-		return 0;
-	} else {
-		/* drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __func__, ireason);
-	}
-
-	if (rq->cmd_type == REQ_TYPE_ATA_PC)
-		rq->cmd_flags |= REQ_FAILED;
-
-	return -1;
-}
-
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct request *rq = cmd->rq;
@@ -645,8 +600,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		goto out_end;
 	}
 
-	/* check which way to transfer data */
-	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
+	rc = ide_check_ireason(drive, rq, len, ireason, write);
 	if (rc)
 		goto out_end;
 
@@ -713,7 +667,7 @@ out_end:
 				rq->errors = -EIO;
 		}
 
-		if (uptodate == 0)
+		if (uptodate == 0 && rq->bio)
 			ide_cd_error_cmd(drive, cmd);
 
 		/* make sure it's fully ended */
@@ -831,12 +785,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		/* right now this can only be a reset... */
 		uptodate = 1;
 		goto out_end;
-	} else {
-		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
-		if (rq->errors == 0)
-			rq->errors = -EIO;
-		goto out_end;
-	}
+	} else
+		BUG();
 
 	/* prepare sense request for this command */
 	ide_prep_sense(drive, rq);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 6a1de21..6951811 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,14 +184,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
-
-	if (!blk_fs_request(rq)) {
-		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
-		if (rq->errors == 0)
-			rq->errors = -EIO;
-		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
-		return ide_stopped;
-	}
+	BUG_ON(!blk_fs_request(rq));
 
 	ledtrig_ide_activity();
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 6509817..8b3f204 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -77,7 +77,8 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 	    (rq && blk_pc_request(rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-		u8 *buf = pc->buf;
+
+		u8 *buf = bio_data(rq->bio);
 
 		if (!pc->error) {
 			floppy->sense_key = buf[2] & 0x0F;
@@ -209,8 +210,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->rq = rq;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buf = NULL;
-	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
+
 	pc->flags |= PC_FLAG_DMA_OK;
 }
 
@@ -225,9 +225,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 		if (rq_data_dir(rq) == WRITE)
 			pc->flags |= PC_FLAG_WRITING;
 	}
-	/* pio will be performed by ide_pio_bytes() which handles sg fine */
-	pc->buf = NULL;
-	pc->req_xfer = pc->buf_size = blk_rq_bytes(rq);
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
@@ -272,10 +269,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
-	} else {
-		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
-		goto out_end;
-	}
+	} else
+		BUG();
 
 	ide_prep_sense(drive, rq);
 
@@ -286,8 +281,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 
 	cmd.rq = rq;
 
-	if (blk_fs_request(rq) || pc->req_xfer) {
-		ide_init_sg_cmd(&cmd, pc->req_xfer);
+	if (blk_fs_request(rq) || blk_rq_bytes(rq)) {
+		ide_init_sg_cmd(&cmd, blk_rq_bytes(rq));
 		ide_map_sg(drive, &cmd);
 	}
 
@@ -311,33 +306,33 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
-	u8 *page;
+	u8 *page, buf[40];
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (ide_queue_pc_tail(drive, disk, pc)) {
+	if (ide_queue_pc_tail(drive, disk, pc, buf, pc->req_xfer)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
-	if (pc->buf[3] & 0x80)
+	if (buf[3] & 0x80)
 		drive->dev_flags |= IDE_DFLAG_WP;
 	else
 		drive->dev_flags &= ~IDE_DFLAG_WP;
 
 	set_disk_ro(disk, !!(drive->dev_flags & IDE_DFLAG_WP));
 
-	page = &pc->buf[8];
+	page = &buf[8];
 
-	transfer_rate = be16_to_cpup((__be16 *)&pc->buf[8 + 2]);
-	sector_size   = be16_to_cpup((__be16 *)&pc->buf[8 + 6]);
-	cyls          = be16_to_cpup((__be16 *)&pc->buf[8 + 8]);
-	rpm           = be16_to_cpup((__be16 *)&pc->buf[8 + 28]);
-	heads         = pc->buf[8 + 4];
-	sectors       = pc->buf[8 + 5];
+	transfer_rate = be16_to_cpup((__be16 *)&buf[8 + 2]);
+	sector_size   = be16_to_cpup((__be16 *)&buf[8 + 6]);
+	cyls          = be16_to_cpup((__be16 *)&buf[8 + 8]);
+	rpm           = be16_to_cpup((__be16 *)&buf[8 + 28]);
+	heads         = buf[8 + 4];
+	sectors       = buf[8 + 5];
 
 	capacity = cyls * heads * sectors * sector_size;
 
@@ -387,22 +382,19 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
-	pc.buf = &pc_buf[0];
-	pc.buf_size = sizeof(pc_buf);
-
-	if (ide_queue_pc_tail(drive, disk, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
 	}
-	header_len = pc.buf[3];
-	cap_desc = &pc.buf[4];
+	header_len = pc_buf[3];
+	cap_desc = &pc_buf[4];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	for (i = 0; i < desc_cnt; i++) {
 		unsigned int desc_start = 4 + i*8;
 
-		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc_buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc_buf[desc_start + 6]);
 
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
 					     "%d sector size",
@@ -415,7 +407,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		 * the code below is valid only for the 1st descriptor, ie i=0
 		 */
 
-		switch (pc.buf[desc_start + 4] & 0x03) {
+		switch (pc_buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
@@ -464,7 +456,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			break;
 		}
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d",
-					     pc.buf[desc_start + 4] & 0x03);
+					     pc_buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index cd8a420..9c22882 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -47,15 +47,13 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
-	pc->buf = &pc_buf[0];
-	pc->buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc_buf, pc->req_xfer)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
 
-	header_len = pc->buf[3];
+	header_len = pc_buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
@@ -72,8 +70,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpup((__be32 *)&pc->buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc->buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc_buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc_buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return -EFAULT;
@@ -94,40 +92,42 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	return 0;
 }
 
-static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
+static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc,
+					      u8 *buf, int b, int l,
+					      int flags)
 {
 	ide_init_pc(pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
-	memset(pc->buf, 0, 12);
-	pc->buf[1] = 0xA2;
+	memset(buf, 0, 12);
+	buf[1] = 0xA2;
 	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
 
 	if (flags & 1)				/* Verify bit on... */
-		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buf[3] = 8;
+		buf[1] ^= 0x20;			/* ... turn off DCRT bit */
+	buf[3] = 8;
 
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
-	pc->buf_size = 12;
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&buf[8]));
+	pc->req_xfer = 12;
 	pc->flags |= PC_FLAG_WRITING;
 }
 
 static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 buf[20];
 
 	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, buf, pc->req_xfer))
 		return 1;
 
-	if (pc->buf[8 + 2] & 0x40)
+	if (buf[8 + 2] & 0x40)
 		drive->atapi_flags |= IDE_AFLAG_SRFP;
 
 	return 0;
@@ -137,6 +137,7 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 buf[12];
 	int blocks, length, flags, err = 0;
 
 	if (floppy->openers > 1) {
@@ -170,9 +171,9 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	ide_floppy_get_sfrp_bit(drive, pc);
-	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
+	ide_floppy_create_format_unit_cmd(pc, buf, blocks, length, flags);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, buf, pc->req_xfer))
 		err = -EIO;
 
 out:
@@ -196,11 +197,13 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 					  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 sense_buf[18];
 	int progress_indication = 0x10000;
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
 		ide_create_request_sense_cmd(drive, pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, pc))
+		if (ide_queue_pc_tail(drive, floppy->disk, pc, sense_buf,
+				      pc->req_xfer))
 			return -EIO;
 
 		if (floppy->sense_key == 2 &&
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 272cc38..1059f80 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -683,8 +683,9 @@ void ide_timer_expiry (unsigned long data)
 		} else if (drive_is_ready(drive)) {
 			if (drive->waiting_for_dma)
 				hwif->dma_ops->dma_lost_irq(drive);
-			if (hwif->ack_intr)
-				hwif->ack_intr(hwif);
+			if (hwif->port_ops && hwif->port_ops->clear_irq)
+				hwif->port_ops->clear_irq(drive);
+
 			printk(KERN_WARNING "%s: lost interrupt\n",
 				drive->name);
 			startstop = handler(drive);
@@ -803,7 +804,8 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 
 	spin_lock_irqsave(&hwif->lock, flags);
 
-	if (hwif->ack_intr && hwif->ack_intr(hwif) == 0)
+	if (hwif->port_ops && hwif->port_ops->test_irq &&
+	    hwif->port_ops->test_irq(hwif) == 0)
 		goto out;
 
 	handler = hwif->handler;
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 5991b23..82f252c 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -118,7 +118,6 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	u8 args[4], xfer_rate = 0;
 	struct ide_cmd cmd;
 	struct ide_taskfile *tf = &cmd.tf;
-	u16 *id = drive->id;
 
 	if (NULL == (void *) arg) {
 		struct request *rq;
@@ -161,14 +160,10 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	if (tf->command == ATA_CMD_SET_FEATURES &&
 	    tf->feature == SETFEATURES_XFER &&
-	    tf->nsect >= XFER_SW_DMA_0 &&
-	    (id[ATA_ID_UDMA_MODES] ||
-	     id[ATA_ID_MWDMA_MODES] ||
-	     id[ATA_ID_SWDMA_MODES])) {
-		xfer_rate = args[1];
-		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
+	    tf->nsect >= XFER_SW_DMA_0) {
+		xfer_rate = ide_find_dma_mode(drive, XFER_UDMA_6);
+		if (xfer_rate != tf->nsect) {
+			err = -EINVAL;
 			goto abort;
 		}
 	}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 79e0af3..51af4ee 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1170,7 +1170,6 @@ static void ide_init_port_hw(ide_hwif_t *hwif, struct ide_hw *hw)
 	hwif->irq = hw->irq;
 	hwif->dev = hw->dev;
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
-	hwif->ack_intr = hw->ack_intr;
 	hwif->config_data = hw->config;
 }
 
@@ -1378,6 +1377,9 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 
 		ide_init_port(hwif, i & 1, d);
 		ide_port_cable_detect(hwif);
+
+		hwif->port_flags |= IDE_PFLAG_PROBING;
+
 		ide_port_init_devices(hwif);
 	}
 
@@ -1388,6 +1390,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		if (ide_probe_port(hwif) == 0)
 			hwif->present = 1;
 
+		hwif->port_flags &= ~IDE_PFLAG_PROBING;
+
 		if ((hwif->host_flags & IDE_HFLAG_4DRIVES) == 0 ||
 		    hwif->mate == NULL || hwif->mate->present == 0) {
 			if (ide_register_port(hwif)) {
@@ -1569,11 +1573,20 @@ EXPORT_SYMBOL_GPL(ide_host_remove);
 
 void ide_port_scan(ide_hwif_t *hwif)
 {
+	int rc;
+
 	ide_port_apply_params(hwif);
 	ide_port_cable_detect(hwif);
+
+	hwif->port_flags |= IDE_PFLAG_PROBING;
+
 	ide_port_init_devices(hwif);
 
-	if (ide_probe_port(hwif) < 0)
+	rc = ide_probe_port(hwif);
+
+	hwif->port_flags &= ~IDE_PFLAG_PROBING;
+
+	if (rc < 0)
 		return;
 
 	hwif->present = 1;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4b447a8..013dc59 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -279,10 +279,12 @@ static void ide_tape_put(struct ide_tape_obj *tape)
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
-static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
+static void idetape_analyze_error(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->failed_pc;
+	struct request *rq = drive->hwif->rq;
+	u8 *sense = bio_data(rq->bio);
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -291,11 +293,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->xferred by asking the tape.	 */
+	/* correct remaining bytes to transfer */
 	if (pc->flags & PC_FLAG_DMA_ERROR)
-		pc->xferred = pc->req_xfer -
-			tape->blk_size *
-			get_unaligned_be32(&sense[3]);
+		rq->resid_len = tape->blk_size * get_unaligned_be32(&sense[3]);
 
 	/*
 	 * If error was the result of a zero-length read or write command,
@@ -329,7 +329,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
-		    pc->xferred)
+		    (blk_rq_bytes(rq) - rq->resid_len))
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -354,12 +354,13 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 
 	if (pc->c[0] == REQUEST_SENSE) {
 		if (uptodate)
-			idetape_analyze_error(drive, pc->buf);
+			idetape_analyze_error(drive);
 		else
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		int blocks = pc->xferred / tape->blk_size;
+		unsigned int blocks =
+			(blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
 
@@ -371,38 +372,12 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->resid_len -= blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
 			err = pc->error;
 		}
-	} else if (pc->c[0] == READ_POSITION && uptodate) {
-		u8 *readpos = pc->buf;
-
-		debug_log(DBG_SENSE, "BOP - %s\n",
-				(readpos[0] & 0x80) ? "Yes" : "No");
-		debug_log(DBG_SENSE, "EOP - %s\n",
-				(readpos[0] & 0x40) ? "Yes" : "No");
-
-		if (readpos[0] & 0x4) {
-			printk(KERN_INFO "ide-tape: Block location is unknown"
-					 "to the tape\n");
-			clear_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
-				  &drive->atapi_flags);
-			uptodate = 0;
-			err = IDE_DRV_ERROR_GENERAL;
-		} else {
-			debug_log(DBG_SENSE, "Block Location - %u\n",
-					be32_to_cpup((__be32 *)&readpos[4]));
-
-			tape->partition = readpos[1];
-			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
-			set_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
-				&drive->atapi_flags);
-		}
 	}
-
 	rq->errors = err;
 
 	return uptodate;
@@ -477,6 +452,7 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 					 struct ide_atapi_pc *pc)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct request *rq = drive->hwif->rq;
 
 	if (drive->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		drive->failed_pc = pc;
@@ -486,7 +462,6 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
 		(pc->flags & PC_FLAG_ABORT)) {
-		unsigned int done = blk_rq_bytes(drive->hwif->rq);
 
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
@@ -510,7 +485,7 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
-		ide_complete_rq(drive, -EIO, done);
+		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
@@ -579,15 +554,13 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 				   struct ide_atapi_pc *pc, struct request *rq,
 				   u8 opcode)
 {
-	unsigned int length = blk_rq_sectors(rq);
+	unsigned int length = blk_rq_sectors(rq) / (tape->blk_size >> 9);
 
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->buf = NULL;
-	pc->buf_size = length * tape->blk_size;
-	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->buffer_size)
+
+	if (blk_rq_bytes(rq) == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_OK;
 
 	if (opcode == READ_6)
@@ -613,15 +586,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
 		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
 
-	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
-		/* We do not support buffer cache originated requests. */
-		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
-			"request queue (%d)\n", drive->name, rq->cmd_type);
-		if (blk_fs_request(rq) == 0 && rq->errors == 0)
-			rq->errors = -EIO;
-		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
-		return ide_stopped;
-	}
+	BUG_ON(!(blk_special_request(rq) || blk_sense_request(rq)));
 
 	/* Retry a failed packet command */
 	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
@@ -713,7 +678,7 @@ out:
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd, pc->req_xfer);
+	ide_init_sg_cmd(&cmd, blk_rq_bytes(rq));
 	ide_map_sg(drive, &cmd);
 
 	return ide_tape_issue_pc(drive, &cmd, pc);
@@ -767,33 +732,53 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	rc = ide_queue_pc_tail(drive, tape->disk, &pc);
+	rc = ide_queue_pc_tail(drive, tape->disk, &pc, NULL, 0);
 	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	return 0;
 }
 
-static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = READ_POSITION;
-	pc->req_xfer = 20;
-}
-
-static int idetape_read_position(ide_drive_t *drive)
+static int ide_tape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	int position;
+	u8 buf[20];
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	idetape_create_read_position_cmd(&pc);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc))
+	/* prep cmd */
+	ide_init_pc(&pc);
+	pc.c[0] = READ_POSITION;
+	pc.req_xfer = 20;
+
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer))
 		return -1;
-	position = tape->first_frame;
-	return position;
+
+	if (!pc.error) {
+		debug_log(DBG_SENSE, "BOP - %s\n",
+				(buf[0] & 0x80) ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n",
+				(buf[0] & 0x40) ? "Yes" : "No");
+
+		if (buf[0] & 0x4) {
+			printk(KERN_INFO "ide-tape: Block location is unknown"
+					 "to the tape\n");
+			clear_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				  &drive->atapi_flags);
+			return -1;
+		} else {
+			debug_log(DBG_SENSE, "Block Location - %u\n",
+					be32_to_cpup((__be32 *)&buf[4]));
+
+			tape->partition = buf[1];
+			tape->first_frame = be32_to_cpup((__be32 *)&buf[4]);
+			set_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				&drive->atapi_flags);
+		}
+	}
+
+	return tape->first_frame;
 }
 
 static void idetape_create_locate_cmd(ide_drive_t *drive,
@@ -836,19 +821,21 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct gendisk *disk = tape->disk;
-	int retval;
+	int ret;
 	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
-	if (retval)
-		return (retval);
+	ret = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
+	if (ret)
+		return ret;
 
-	idetape_create_read_position_cmd(&pc);
-	return ide_queue_pc_tail(drive, disk, &pc);
+	ret = ide_tape_read_position(drive);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -859,7 +846,7 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 
 	__ide_tape_discard_merge_buffer(drive);
 	if (restore_position) {
-		position = idetape_read_position(drive);
+		position = ide_tape_read_position(drive);
 		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
 			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
@@ -1039,20 +1026,19 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct gendisk *disk = tape->disk;
-	int retval;
 	struct ide_atapi_pc pc;
+	int ret;
 
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
-	if (retval)
-		return retval;
+	ret = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
+	if (ret)
+		return ret;
 
-	idetape_create_read_position_cmd(&pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
-	if (retval)
-		return retval;
+	ret = ide_tape_read_position(drive);
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 
@@ -1119,7 +1105,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	case MTBSF:
 		idetape_create_space_cmd(&pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTFSFM:
 	case MTBSFM:
 		if (!sprev)
@@ -1259,7 +1245,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, NULL, 0)) {
 		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
@@ -1345,11 +1331,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
 		idetape_create_erase_cmd(&pc);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTSETBLK:
 		if (mt_count) {
 			if (mt_count < tape->blk_size ||
@@ -1415,7 +1401,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
 		block_offset = tape->valid /
 			(tape->blk_size * tape->user_bs_factor);
-		position = idetape_read_position(drive);
+		position = ide_tape_read_position(drive);
 		if (position < 0)
 			return -EIO;
 	}
@@ -1458,9 +1444,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
+	u8 buf[12];
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -1469,10 +1456,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 		}
 		return;
 	}
-	tape->blk_size = (pc.buf[4 + 5] << 16) +
-				(pc.buf[4 + 6] << 8)  +
-				 pc.buf[4 + 7];
-	tape->drv_write_prot = (pc.buf[2] & 0x80) >> 7;
+	tape->blk_size = (buf[4 + 5] << 16) +
+				(buf[4 + 6] << 8)  +
+				 buf[4 + 7];
+	tape->drv_write_prot = (buf[2] & 0x80) >> 7;
 }
 
 static int idetape_chrdev_open(struct inode *inode, struct file *filp)
@@ -1517,7 +1504,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		goto out_put_tape;
 	}
 
-	idetape_read_position(drive);
+	ide_tape_read_position(drive);
 	if (!test_bit(ilog2(IDE_AFLAG_ADDRESS_VALID), &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
@@ -1615,17 +1602,14 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
-	pc.buf = &pc_buf[0];
-	pc.buf_size = sizeof(pc_buf);
-
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
 		return;
 	}
-	memcpy(vendor_id, &pc.buf[8], 8);
-	memcpy(product_id, &pc.buf[16], 16);
-	memcpy(fw_rev, &pc.buf[32], 4);
+	memcpy(vendor_id, &pc_buf[8], 8);
+	memcpy(product_id, &pc_buf[16], 16);
+	memcpy(fw_rev, &pc_buf[32], 4);
 
 	ide_fixstring(vendor_id, 8, 0);
 	ide_fixstring(product_id, 16, 0);
@@ -1643,11 +1627,11 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	u8 *caps;
+	u8 buf[24], *caps;
 	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
 		tape->blk_size = 512;
@@ -1656,7 +1640,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	caps = pc.buf + 4 + pc.buf[3];
+	caps = buf + 4 + buf[3];
 
 	/* convert to host order and save for later use */
 	speed = be16_to_cpup((__be16 *)&caps[14]);
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index af44be9..46d203c 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -107,6 +107,18 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 }
 EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
 
+int ide_pio_need_iordy(ide_drive_t *drive, const u8 pio)
+{
+	/*
+	 * IORDY may lead to controller lock up on certain controllers
+	 * if the port is not occupied.
+	 */
+	if (pio == 0 && (drive->hwif->port_flags & IDE_PFLAG_PROBING))
+		return 0;
+	return ata_id_pio_need_iordy(drive->id, pio);
+}
+EXPORT_SYMBOL_GPL(ide_pio_need_iordy);
+
 int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/it8172.c b/drivers/ide/it8172.c
index e021078..0d266a5 100644
--- a/drivers/ide/it8172.c
+++ b/drivers/ide/it8172.c
@@ -66,7 +66,7 @@ static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (drive->media == ide_disk)
 		/* enable prefetch */
 		drive_enables |= 0x0004 << (drive->dn * 4);
-	if (ata_id_has_iordy(drive->id))
+	if (ide_pio_need_iordy(drive, pio))
 		/* enable IORDY sample-point */
 		drive_enables |= 0x0002 << (drive->dn * 4);
 
diff --git a/drivers/ide/it8213.c b/drivers/ide/it8213.c
index d7969b6..4797616 100644
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -50,7 +50,7 @@ static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		control |= 1;	/* Programmable timing on */
 	if (drive->media != ide_disk)
 		control |= 4;	/* ATAPI */
-	if (pio > 2)
+	if (ide_pio_need_iordy(drive, pio))
 		control |= 2;	/* IORDY */
 	if (is_slave) {
 		master_data |=  0x4000;
diff --git a/drivers/ide/macide.c b/drivers/ide/macide.c
index 1447c8c..505ec43 100644
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -53,17 +53,20 @@
 
 volatile unsigned char *ide_ifr = (unsigned char *) (IDE_BASE + IDE_IFR);
 
-int macide_ack_intr(ide_hwif_t* hwif)
+int macide_test_irq(ide_hwif_t *hwif)
 {
-	if (*ide_ifr & 0x20) {
-		*ide_ifr &= ~0x20;
+	if (*ide_ifr & 0x20)
 		return 1;
-	}
 	return 0;
 }
 
+static void macide_clear_irq(ide_drive_t *drive)
+{
+	*ide_ifr &= ~0x20;
+}
+
 static void __init macide_setup_ports(struct ide_hw *hw, unsigned long base,
-				      int irq, ide_ack_intr_t *ack_intr)
+				      int irq)
 {
 	int i;
 
@@ -75,10 +78,15 @@ static void __init macide_setup_ports(struct ide_hw *hw, unsigned long base,
 	hw->io_ports.ctl_addr = base + IDE_CONTROL;
 
 	hw->irq = irq;
-	hw->ack_intr = ack_intr;
 }
 
+static const struct ide_port_ops macide_port_ops = {
+	.clear_irq		= macide_clear_irq,
+	.test_irq		= macide_test_irq,
+};
+
 static const struct ide_port_info macide_port_info = {
+	.port_ops		= &macide_port_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
 	.chipset		= ide_generic,
@@ -93,10 +101,10 @@ static const char *mac_ide_name[] =
 
 static int __init macide_init(void)
 {
-	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
 	struct ide_hw hw, *hws[] = { &hw };
+	struct ide_port_info d = macide_port_info;
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
@@ -104,17 +112,15 @@ static int __init macide_init(void)
 	switch (macintosh_config->ide_type) {
 	case MAC_IDE_QUADRA:
 		base = IDE_BASE;
-		ack_intr = macide_ack_intr;
 		irq = IRQ_NUBUS_F;
 		break;
 	case MAC_IDE_PB:
 		base = IDE_BASE;
-		ack_intr = macide_ack_intr;
 		irq = IRQ_NUBUS_C;
 		break;
 	case MAC_IDE_BABOON:
 		base = BABOON_BASE;
-		ack_intr = NULL;
+		d.port_ops = NULL;
 		irq = IRQ_BABOON_1;
 		break;
 	default:
@@ -124,9 +130,9 @@ static int __init macide_init(void)
 	printk(KERN_INFO "ide: Macintosh %s IDE controller\n",
 			 mac_ide_name[macintosh_config->ide_type - 1]);
 
-	macide_setup_ports(&hw, base, irq, ack_intr);
+	macide_setup_ports(&hw, base, irq);
 
-	return ide_host_add(&macide_port_info, hws, 1, NULL);
+	return ide_host_add(&d, hws, 1, NULL);
 }
 
 module_init(macide_init);
diff --git a/drivers/ide/opti621.c b/drivers/ide/opti621.c
index 6048eda..f1d70d6 100644
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -138,6 +138,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	unsigned long flags;
+	unsigned long mode = XFER_PIO_0 + pio, pair_mode;
 	u8 tim, misc, addr_pio = pio, clk;
 
 	/* DRDY is default 2 (by OPTi Databook) */
@@ -150,11 +151,12 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		{ 0x48, 0x34, 0x21, 0x10, 0x10 }	/* 25 MHz */
 	};
 
-	drive->drive_data = XFER_PIO_0 + pio;
+	ide_set_drivedata(drive, (void *)mode);
 
 	if (pair) {
-		if (pair->drive_data && pair->drive_data < drive->drive_data)
-			addr_pio = pair->drive_data - XFER_PIO_0;
+		pair_mode = (unsigned long)ide_get_drivedata(pair);
+		if (pair_mode && pair_mode < mode)
+			addr_pio = pair_mode - XFER_PIO_0;
 	}
 
 	spin_lock_irqsave(&opti621_lock, flags);
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index b6abf7e..cb812f3 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -73,7 +73,7 @@ static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
 		 */
 		AP &= ~0x3f;
-		if (ata_id_iordy_disable(drive->id))
+		if (ide_pio_need_iordy(drive, speed - XFER_PIO_0))
 			AP |= 0x20;	/* set IORDY_EN bit */
 		if (drive->media == ide_disk)
 			AP |= 0x10;	/* set Prefetch_EN bit */
@@ -104,6 +104,27 @@ static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
+static int pdc202xx_test_irq(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long high_16	= pci_resource_start(dev, 4);
+	u8 sc1d			= inb(high_16 + 0x1d);
+
+	if (hwif->channel) {
+		/*
+		 * bit 7: error, bit 6: interrupting,
+		 * bit 5: FIFO full, bit 4: FIFO empty
+		 */
+		return ((sc1d & 0x50) == 0x40) ? 1 : 0;
+	} else	{
+		/*
+		 * bit 3: error, bit 2: interrupting,
+		 * bit 1: FIFO full, bit 0: FIFO empty
+		 */
+		return ((sc1d & 0x05) == 0x04) ? 1 : 0;
+	}
+}
+
 static u8 pdc2026x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -231,6 +252,7 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 static const struct ide_port_ops pdc20246_port_ops = {
 	.set_pio_mode		= pdc202xx_set_pio_mode,
 	.set_dma_mode		= pdc202xx_set_mode,
+	.test_irq		= pdc202xx_test_irq,
 };
 
 static const struct ide_port_ops pdc2026x_port_ops = {
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index 69860de..bf14f39 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -98,7 +98,7 @@ static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		control |= 1;	/* Programmable timing on */
 	if (drive->media == ide_disk)
 		control |= 4;	/* Prefetch, post write */
-	if (pio > 2)
+	if (ide_pio_need_iordy(drive, pio))
 		control |= 2;	/* IORDY */
 	if (is_slave) {
 		master_data |=  0x4000;
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index ab49a97..9078608 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -51,9 +51,7 @@ static int q40ide_default_irq(unsigned long base)
 /*
  * Addresses are pretranslated for Q40 ISA access.
  */
-static void q40_ide_setup_ports(struct ide_hw *hw, unsigned long base,
-			ide_ack_intr_t *ack_intr,
-			int irq)
+static void q40_ide_setup_ports(struct ide_hw *hw, unsigned long base, int irq)
 {
 	memset(hw, 0, sizeof(*hw));
 	/* BIG FAT WARNING: 
@@ -69,7 +67,6 @@ static void q40_ide_setup_ports(struct ide_hw *hw, unsigned long base,
 	hw->io_ports.ctl_addr = Q40_ISA_IO_B(base + 0x206);
 
 	hw->irq = irq;
-	hw->ack_intr = ack_intr;
 }
 
 static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
@@ -156,7 +153,7 @@ static int __init q40ide_init(void)
 		release_region(pcide_bases[i], 8);
 		continue;
 	}
-	q40_ide_setup_ports(&hw[i], pcide_bases[i], NULL,
+	q40_ide_setup_ports(&hw[i], pcide_bases[i],
 			q40ide_default_irq(pcide_bases[i]));
 
 	hws[i] = &hw[i];
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index c9a1349..74696ed 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -180,8 +180,11 @@ static int qd_find_disk_type (ide_drive_t *drive,
 
 static void qd_set_timing (ide_drive_t *drive, u8 timing)
 {
-	drive->drive_data &= 0xff00;
-	drive->drive_data |= timing;
+	unsigned long data = (unsigned long)ide_get_drivedata(drive);
+
+	data &= 0xff00;
+	data |= timing;
+	ide_set_drivedata(drive, (void *)data);
 
 	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
 }
@@ -292,7 +295,7 @@ static void __init qd6500_init_dev(ide_drive_t *drive)
 	u8 base = (hwif->config_data & 0xff00) >> 8;
 	u8 config = QD_CONFIG(hwif);
 
-	drive->drive_data = QD6500_DEF_DATA;
+	ide_set_drivedata(drive, (void *)QD6500_DEF_DATA);
 }
 
 static void __init qd6580_init_dev(ide_drive_t *drive)
@@ -308,7 +311,7 @@ static void __init qd6580_init_dev(ide_drive_t *drive)
 	} else
 		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
 
-	drive->drive_data = (drive->dn & 1) ? t2 : t1;
+	ide_set_drivedata(drive, (void *)((drive->dn & 1) ? t2 : t1));
 }
 
 static const struct ide_tp_ops qd65xx_tp_ops = {
diff --git a/drivers/ide/qd65xx.h b/drivers/ide/qd65xx.h
index d7e67a1..1fba2a5 100644
--- a/drivers/ide/qd65xx.h
+++ b/drivers/ide/qd65xx.h
@@ -31,8 +31,15 @@
 
 #define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
 
-#define QD_TIMING(drive)	(u8)(((drive)->drive_data) & 0x00ff)
-#define QD_TIMREG(drive)	(u8)((((drive)->drive_data) & 0xff00) >> 8)
+static inline u8 QD_TIMING(ide_drive_t *drive)
+{
+	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
+}
+
+static inline u8 QD_TIMREG(ide_drive_t *drive)
+{
+	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
+}
 
 #define QD6500_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0c : 0x08))
 #define QD6580_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index 5f37f16..b7d61dc 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
- * Copyright (C) 2008 MontaVista Software, Inc.
+ * Copyright (C) 2008-2009 MontaVista Software, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License
@@ -29,8 +29,7 @@
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
 #include <linux/ioc4.h>
-#include <asm/io.h>
-
+#include <linux/io.h>
 #include <linux/ide.h>
 
 #define DRV_NAME "SGIIOC4"
@@ -72,7 +71,7 @@
 #define IOC4_CMD_CTL_BLK_SIZE	0x20
 #define IOC4_SUPPORTED_FIRMWARE_REV 46
 
-typedef struct {
+struct ioc4_dma_regs {
 	u32 timing_reg0;
 	u32 timing_reg1;
 	u32 low_mem_ptr;
@@ -82,17 +81,18 @@ typedef struct {
 	u32 dev_byte_count;
 	u32 mem_byte_count;
 	u32 status;
-} ioc4_dma_regs_t;
+};
 
 /* Each Physical Region Descriptor Entry size is 16 bytes (2 * 64 bits) */
 /* IOC4 has only 1 IDE channel */
-#define IOC4_PRD_BYTES       16
-#define IOC4_PRD_ENTRIES     (PAGE_SIZE /(4*IOC4_PRD_BYTES))
+#define IOC4_PRD_BYTES		16
+#define IOC4_PRD_ENTRIES	(PAGE_SIZE / (4 * IOC4_PRD_BYTES))
 
 
-static void
-sgiioc4_init_hwif_ports(struct ide_hw *hw, unsigned long data_port,
-			unsigned long ctrl_port, unsigned long irq_port)
+static void sgiioc4_init_hwif_ports(struct ide_hw *hw,
+				    unsigned long data_port,
+				    unsigned long ctrl_port,
+				    unsigned long irq_port)
 {
 	unsigned long reg = data_port;
 	int i;
@@ -105,13 +105,11 @@ sgiioc4_init_hwif_ports(struct ide_hw *hw, unsigned long data_port,
 	hw->io_ports.irq_addr = irq_port;
 }
 
-static int
-sgiioc4_checkirq(ide_hwif_t * hwif)
+static int sgiioc4_checkirq(ide_hwif_t *hwif)
 {
-	unsigned long intr_addr =
-		hwif->io_ports.irq_addr + IOC4_INTR_REG * 4;
+	unsigned long intr_addr = hwif->io_ports.irq_addr + IOC4_INTR_REG * 4;
 
-	if ((u8)readl((void __iomem *)intr_addr) & 0x03)
+	if (readl((void __iomem *)intr_addr) & 0x03)
 		return 1;
 
 	return 0;
@@ -119,8 +117,7 @@ sgiioc4_checkirq(ide_hwif_t * hwif)
 
 static u8 sgiioc4_read_status(ide_hwif_t *);
 
-static int
-sgiioc4_clearirq(ide_drive_t * drive)
+static int sgiioc4_clearirq(ide_drive_t *drive)
 {
 	u32 intr_reg;
 	ide_hwif_t *hwif = drive->hwif;
@@ -158,12 +155,10 @@ sgiioc4_clearirq(ide_drive_t * drive)
 				readl((void __iomem *)(io_ports->irq_addr + 4));
 			pci_read_config_dword(dev, PCI_COMMAND,
 					      &pci_stat_cmd_reg);
-			printk(KERN_ERR
-			       "%s(%s) : PCI Bus Error when doing DMA:"
-				   " status-cmd reg is 0x%x\n",
+			printk(KERN_ERR "%s(%s): PCI Bus Error when doing DMA: "
+			       "status-cmd reg is 0x%x\n",
 			       __func__, drive->name, pci_stat_cmd_reg);
-			printk(KERN_ERR
-			       "%s(%s) : PCI Error Address is 0x%x%x\n",
+			printk(KERN_ERR "%s(%s): PCI Error Address is 0x%x%x\n",
 			       __func__, drive->name,
 			       pci_err_addr_high, pci_err_addr_low);
 			/* Clear the PCI Error indicator */
@@ -189,8 +184,7 @@ static void sgiioc4_dma_start(ide_drive_t *drive)
 	writel(temp_reg, (void __iomem *)ioc4_dma_addr);
 }
 
-static u32
-sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u64 dma_base)
+static u32 sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u64 dma_base)
 {
 	unsigned long ioc4_dma_addr = dma_base + IOC4_DMA_CTRL * 4;
 	u32	ioc4_dma;
@@ -227,7 +221,7 @@ static int sgiioc4_dma_end(ide_drive_t *drive)
 	}
 
 	/*
-	 * The IOC4 will DMA 1's to the ending dma area to indicate that
+	 * The IOC4 will DMA 1's to the ending DMA area to indicate that
 	 * previous data DMA is complete.  This is necessary because of relaxed
 	 * ordering between register reads and DMA writes on the Altix.
 	 */
@@ -265,7 +259,7 @@ static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 }
 
-/* returns 1 if dma irq issued, 0 otherwise */
+/* Returns 1 if DMA IRQ issued, 0 otherwise */
 static int sgiioc4_dma_test_irq(ide_drive_t *drive)
 {
 	return sgiioc4_checkirq(drive->hwif);
@@ -286,8 +280,7 @@ static void sgiioc4_resetproc(ide_drive_t *drive)
 	sgiioc4_clearirq(drive);
 }
 
-static void
-sgiioc4_dma_lost_irq(ide_drive_t * drive)
+static void sgiioc4_dma_lost_irq(ide_drive_t *drive)
 {
 	sgiioc4_resetproc(drive);
 
@@ -313,13 +306,13 @@ static u8 sgiioc4_read_status(ide_hwif_t *hwif)
 	return reg;
 }
 
-/* Creates a dma map for the scatter-gather list entries */
-static int __devinit
-ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
+/* Creates a DMA map for the scatter-gather list entries */
+static int __devinit ide_dma_sgiioc4(ide_hwif_t *hwif,
+				     const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
-	int num_ports = sizeof (ioc4_dma_regs_t);
+	int num_ports = sizeof(struct ioc4_dma_regs);
 	void *pad;
 
 	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
@@ -362,8 +355,7 @@ dma_pci_alloc_failure:
 }
 
 /* Initializes the IOC4 DMA Engine */
-static void
-sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
+static void sgiioc4_configure_for_dma(int dma_direction, ide_drive_t *drive)
 {
 	u32 ioc4_dma;
 	ide_hwif_t *hwif = drive->hwif;
@@ -374,31 +366,27 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
 
 	if (ioc4_dma & IOC4_S_DMA_ACTIVE) {
-		printk(KERN_WARNING
-			"%s(%s):Warning!! DMA from previous transfer was still active\n",
-		       __func__, drive->name);
+		printk(KERN_WARNING "%s(%s): Warning!! DMA from previous "
+		       "transfer was still active\n", __func__, drive->name);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR
-			       "%s(%s) : IOC4 Dma STOP bit is still 1\n",
-			       __func__, drive->name);
+			printk(KERN_ERR "%s(%s): IOC4 DMA STOP bit is "
+			       "still 1\n", __func__, drive->name);
 	}
 
 	ioc4_dma = readl((void __iomem *)ioc4_dma_addr);
 	if (ioc4_dma & IOC4_S_DMA_ERROR) {
-		printk(KERN_WARNING
-		       "%s(%s) : Warning!! - DMA Error during Previous"
-		       " transfer | status 0x%x\n",
+		printk(KERN_WARNING "%s(%s): Warning!! DMA Error during "
+		       "previous transfer, status 0x%x\n",
 		       __func__, drive->name, ioc4_dma);
 		writel(IOC4_S_DMA_STOP, (void __iomem *)ioc4_dma_addr);
 		ioc4_dma = sgiioc4_ide_dma_stop(hwif, dma_base);
 
 		if (ioc4_dma & IOC4_S_DMA_STOP)
-			printk(KERN_ERR
-			       "%s(%s) : IOC4 DMA STOP bit is still 1\n",
-			       __func__, drive->name);
+			printk(KERN_ERR "%s(%s): IOC4 DMA STOP bit is "
+			       "still 1\n", __func__, drive->name);
 	}
 
 	/* Address of the Scatter Gather List */
@@ -408,20 +396,22 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 	/* Address of the Ending DMA */
 	memset(ide_get_hwifdata(hwif), 0, IOC4_IDE_CACHELINE_SIZE);
 	ending_dma_addr = cpu_to_le32(hwif->extra_base);
-	writel(ending_dma_addr, (void __iomem *)(dma_base + IOC4_DMA_END_ADDR * 4));
+	writel(ending_dma_addr, (void __iomem *)(dma_base +
+						 IOC4_DMA_END_ADDR * 4));
 
 	writel(dma_direction, (void __iomem *)ioc4_dma_addr);
 }
 
-/* IOC4 Scatter Gather list Format 					 */
+/* IOC4 Scatter Gather list Format					 */
 /* 128 Bit entries to support 64 bit addresses in the future		 */
 /* The Scatter Gather list Entry should be in the BIG-ENDIAN Format	 */
 /* --------------------------------------------------------------------- */
-/* | Upper 32 bits - Zero           |	 	Lower 32 bits- address | */
+/* | Upper 32 bits - Zero	    |		Lower 32 bits- address | */
 /* --------------------------------------------------------------------- */
 /* | Upper 32 bits - Zero	    |EOL| 15 unused     | 16 Bit Length| */
 /* --------------------------------------------------------------------- */
-/* Creates the scatter gather list, DMA Table */
+/* Creates the scatter gather list, DMA Table				 */
+
 static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -448,8 +438,10 @@ static int sgiioc4_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 				if (bcount > cur_len)
 					bcount = cur_len;
 
-				/* put the addr, length in
-				 * the IOC4 dma-table format */
+				/*
+				 * Put the address, length in
+				 * the IOC4 dma-table format
+				 */
 				*table = 0x0;
 				table++;
 				*table = cpu_to_be32(cur_addr);
@@ -540,8 +532,7 @@ static const struct ide_port_info sgiioc4_port_info __devinitconst = {
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
-static int __devinit
-sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
+static int __devinit sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
@@ -549,7 +540,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	struct ide_hw hw, *hws[] = { &hw };
 	int rc;
 
-	/*  Get the CmdBlk and CtrlBlk Base Registers */
+	/* Get the CmdBlk and CtrlBlk base registers */
 	bar0 = pci_resource_start(dev, 0);
 	virt_base = pci_ioremap_bar(dev, 0);
 	if (virt_base == NULL) {
@@ -557,9 +548,9 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 				DRV_NAME, bar0);
 		return -ENOMEM;
 	}
-	cmd_base = (unsigned long) virt_base + IOC4_CMD_OFFSET;
-	ctl = (unsigned long) virt_base + IOC4_CTRL_OFFSET;
-	irqport = (unsigned long) virt_base + IOC4_INTR_OFFSET;
+	cmd_base = (unsigned long)virt_base + IOC4_CMD_OFFSET;
+	ctl = (unsigned long)virt_base + IOC4_CTRL_OFFSET;
+	irqport = (unsigned long)virt_base + IOC4_INTR_OFFSET;
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
@@ -577,7 +568,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 
-	/* Initializing chipset IRQ Registers */
+	/* Initialize chipset IRQ registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
 	rc = ide_host_add(&sgiioc4_port_info, hws, 1, NULL);
@@ -590,8 +581,7 @@ req_mem_rgn_err:
 	return rc;
 }
 
-static unsigned int __devinit
-pci_init_sgiioc4(struct pci_dev *dev)
+static unsigned int __devinit pci_init_sgiioc4(struct pci_dev *dev)
 {
 	int ret;
 
@@ -611,10 +601,10 @@ out:
 	return ret;
 }
 
-int __devinit
-ioc4_ide_attach_one(struct ioc4_driver_data *idd)
+int __devinit ioc4_ide_attach_one(struct ioc4_driver_data *idd)
 {
-	/* PCI-RT does not bring out IDE connection.
+	/*
+	 * PCI-RT does not bring out IDE connection.
 	 * Do not attach to this particular IOC4.
 	 */
 	if (idd->idd_variant == IOC4_VARIANT_PCI_RT)
@@ -627,7 +617,6 @@ static struct ioc4_submodule __devinitdata ioc4_ide_submodule = {
 	.is_name = "IOC4_ide",
 	.is_owner = THIS_MODULE,
 	.is_probe = ioc4_ide_attach_one,
-/*	.is_remove = ioc4_ide_remove_one,	*/
 };
 
 static int __init ioc4_ide_init(void)
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index bd82d22..d95df52 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -32,7 +32,6 @@
  *  smarter code in libata.
  *
  * TODO:
- * - IORDY fixes
  * - VDMA support
  */
 
@@ -234,8 +233,7 @@ static u8 sil_sata_udma_filter(ide_drive_t *drive)
  *	@pio: PIO mode number
  *
  *	Load the timing settings for this device mode into the
- *	controller. If we are in PIO mode 3 or 4 turn on IORDY
- *	monitoring (bit 9). The TF timing is bits 31:16
+ *	controller.
  */
 
 static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
@@ -276,13 +274,16 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	/* now set up IORDY */
 	speedp = sil_ioread16(dev, tfaddr - 2);
 	speedp &= ~0x200;
-	if (pio > 2)
-		speedp |= 0x200;
-	sil_iowrite16(dev, speedp, tfaddr - 2);
 
 	mode = sil_ioread8(dev, base + addr_mask);
 	mode &= ~(unit ? 0x30 : 0x03);
-	mode |= unit ? 0x10 : 0x01;
+
+	if (ide_pio_need_iordy(drive, pio)) {
+		speedp |= 0x200;
+		mode |= unit ? 0x10 : 0x01;
+	}
+
+	sil_iowrite16(dev, speedp, tfaddr - 2);
 	sil_iowrite8(dev, mode, base + addr_mask);
 }
 
@@ -337,24 +338,14 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	sil_iowrite16(dev, ultra, ua);
 }
 
-/* returns 1 if dma irq issued, 0 otherwise */
-static int siimage_io_dma_test_irq(ide_drive_t *drive)
+static int sil_test_irq(ide_hwif_t *hwif)
 {
-	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 dma_altstat		= 0;
 	unsigned long addr	= siimage_selreg(hwif, 1);
+	u8 val			= sil_ioread8(dev, addr);
 
-	/* return 1 if INTR asserted */
-	if (inb(hwif->dma_base + ATA_DMA_STATUS) & 4)
-		return 1;
-
-	/* return 1 if Device INTR asserted */
-	pci_read_config_byte(dev, addr, &dma_altstat);
-	if (dma_altstat & 8)
-		return 0;	/* return 1; */
-
-	return 0;
+	/* Return 1 if INTRQ asserted */
+	return (val & 8) ? 1 : 0;
 }
 
 /**
@@ -368,7 +359,6 @@ static int siimage_io_dma_test_irq(ide_drive_t *drive)
 static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long addr	= siimage_selreg(hwif, 0x1);
 	void __iomem *sata_error_addr
 		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
 
@@ -397,10 +387,6 @@ static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 	if (readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS)) & 4)
 		return 1;
 
-	/* return 1 if Device INTR asserted */
-	if (readb((void __iomem *)addr) & 8)
-		return 0;	/* return 1; */
-
 	return 0;
 }
 
@@ -409,7 +395,7 @@ static int siimage_dma_test_irq(ide_drive_t *drive)
 	if (drive->hwif->host_flags & IDE_HFLAG_MMIO)
 		return siimage_mmio_dma_test_irq(drive);
 	else
-		return siimage_io_dma_test_irq(drive);
+		return ide_dma_test_irq(drive);
 }
 
 /**
@@ -694,6 +680,7 @@ static const struct ide_port_ops sil_pata_port_ops = {
 	.set_pio_mode		= sil_set_pio_mode,
 	.set_dma_mode		= sil_set_dma_mode,
 	.quirkproc		= sil_quirkproc,
+	.test_irq		= sil_test_irq,
 	.udma_filter		= sil_pata_udma_filter,
 	.cable_detect		= sil_cable_detect,
 };
@@ -704,6 +691,7 @@ static const struct ide_port_ops sil_sata_port_ops = {
 	.reset_poll		= sil_sata_reset_poll,
 	.pre_reset		= sil_sata_pre_reset,
 	.quirkproc		= sil_quirkproc,
+	.test_irq		= sil_test_irq,
 	.udma_filter		= sil_sata_udma_filter,
 	.cable_detect		= sil_cable_detect,
 };
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index 0924abf..d698da4 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -61,8 +61,7 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 	if (cmd_off == 0)
 		cmd_off = 1;
 
-	if ((pio > 2 || ata_id_has_iordy(drive->id)) &&
-	    !(pio > 4 && ata_id_is_cfa(drive->id)))
+	if (ide_pio_need_iordy(drive, pio))
 		iordy = 0x40;
 
 	return (cmd_on - 1) << 8 | (cmd_off - 1) | iordy;
@@ -74,6 +73,7 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
+	unsigned long timings	= (unsigned long)ide_get_drivedata(drive);
 	int reg			= 0x44 + drive->dn * 4;
 	u16 drv_ctrl;
 
@@ -83,8 +83,9 @@ static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	 * Store the PIO timings so that we can restore them
 	 * in case DMA will be turned off...
 	 */
-	drive->drive_data &= 0xffff0000;
-	drive->drive_data |= drv_ctrl;
+	timings &= 0xffff0000;
+	timings |= drv_ctrl;
+	ide_set_drivedata(drive, (void *)timings);
 
 	pci_write_config_word(dev, reg,  drv_ctrl);
 	pci_read_config_word (dev, reg, &drv_ctrl);
@@ -100,6 +101,7 @@ static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
+	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
 	u16 drv_ctrl;
 
  	DBG(("sl82c105_tune_chipset(drive:%s, speed:%s)\n",
@@ -111,8 +113,19 @@ static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	 * Store the DMA timings so that we can actually program
 	 * them when DMA will be turned on...
 	 */
-	drive->drive_data &= 0x0000ffff;
-	drive->drive_data |= (unsigned long)drv_ctrl << 16;
+	timings &= 0x0000ffff;
+	timings |= (unsigned long)drv_ctrl << 16;
+	ide_set_drivedata(drive, (void *)timings);
+}
+
+static int sl82c105_test_irq(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
+
+	pci_read_config_dword(dev, 0x40, &val);
+
+	return (val & mask) ? 1 : 0;
 }
 
 /*
@@ -185,7 +198,8 @@ static void sl82c105_dma_start(ide_drive_t *drive)
 
 	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
-	pci_write_config_word(dev, reg, drive->drive_data >> 16);
+	pci_write_config_word(dev, reg,
+			      (unsigned long)ide_get_drivedata(drive) >> 16);
 
 	sl82c105_reset_host(dev);
 	ide_dma_start(drive);
@@ -210,7 +224,8 @@ static int sl82c105_dma_end(ide_drive_t *drive)
 
 	ret = ide_dma_end(drive);
 
-	pci_write_config_word(dev, reg, drive->drive_data);
+	pci_write_config_word(dev, reg,
+			      (unsigned long)ide_get_drivedata(drive));
 
 	return ret;
 }
@@ -289,6 +304,7 @@ static const struct ide_port_ops sl82c105_port_ops = {
 	.set_pio_mode		= sl82c105_set_pio_mode,
 	.set_dma_mode		= sl82c105_set_dma_mode,
 	.resetproc		= sl82c105_resetproc,
+	.test_irq		= sl82c105_test_irq,
 };
 
 static const struct ide_dma_ops sl82c105_dma_ops = {
diff --git a/drivers/ide/slc90e66.c b/drivers/ide/slc90e66.c
index f55d7d6..9aec78d 100644
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -44,7 +44,7 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		control |= 1;	/* Programmable timing on */
 	if (drive->media == ide_disk)
 		control |= 4;	/* Prefetch, post write */
-	if (pio > 2)
+	if (ide_pio_need_iordy(drive, pio))
 		control |= 2;	/* IORDY */
 	if (is_slave) {
 		master_data |=  0x4000;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 915da43..9c75921 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -800,6 +800,20 @@ static inline int ata_id_is_ssd(const u16 *id)
 	return id[ATA_ID_ROT_SPEED] == 0x01;
 }
 
+static inline int ata_id_pio_need_iordy(const u16 *id, const u8 pio)
+{
+	/* CF spec. r4.1 Table 22 says no IORDY on PIO5 and PIO6. */
+	if (pio > 4 && ata_id_is_cfa(id))
+		return 0;
+	/* For PIO3 and higher it is mandatory. */
+	if (pio > 2)
+		return 1;
+	/* Turn it on when possible. */
+	if (ata_id_has_iordy(id))
+		return 1;
+	return 0;
+}
+
 static inline int ata_drive_40wire(const u16 *dev_id)
 {
 	if (ata_id_is_sata(dev_id))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a6c6a2f..95c6e00 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -157,12 +157,6 @@ enum {
 #define REQ_UNPARK_HEADS	0x23
 
 /*
- * Check for an interrupt and acknowledge the interrupt status
- */
-struct hwif_s;
-typedef int (ide_ack_intr_t)(struct hwif_s *);
-
-/*
  * hwif_chipset_t is used to keep track of the specific hardware
  * chipset used by each IDE interface, if known.
  */
@@ -185,7 +179,6 @@ struct ide_hw {
 	};
 
 	int		irq;			/* our irq number */
-	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	struct device	*dev, *parent;
 	unsigned long	config;
 };
@@ -331,11 +324,6 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 };
 
-/*
- * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
- * This is used for several packet commands (not for READ/WRITE commands).
- */
-#define IDE_PC_BUFFER_SIZE	64
 #define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {
@@ -347,12 +335,6 @@ struct ide_atapi_pc {
 
 	/* bytes to transfer */
 	int req_xfer;
-	/* bytes actually transferred */
-	int xferred;
-
-	/* data buffer */
-	u8 *buf;
-	int buf_size;
 
 	/* the corresponding request */
 	struct request *rq;
@@ -363,8 +345,6 @@ struct ide_atapi_pc {
 	 * those are more or less driver-specific and some of them are subject
 	 * to change/removal later.
 	 */
-	u8 pc_buf[IDE_PC_BUFFER_SIZE];
-
 	unsigned long timeout;
 };
 
@@ -552,7 +532,7 @@ struct ide_drive_s {
 
 	unsigned int	bios_cyl;	/* BIOS/fdisk/LILO number of cyls */
 	unsigned int	cyl;		/* "real" number of cyls */
-	unsigned int	drive_data;	/* used by set_pio_mode/dev_select() */
+	void		*drive_data;	/* used by set_pio_mode/dev_select() */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
 	u64		probed_capacity;/* initial/native media capacity */
@@ -649,6 +629,7 @@ struct ide_port_ops {
 	void	(*maskproc)(ide_drive_t *, int);
 	void	(*quirkproc)(ide_drive_t *);
 	void	(*clear_irq)(ide_drive_t *);
+	int	(*test_irq)(struct hwif_s *);
 
 	u8	(*mdma_filter)(ide_drive_t *);
 	u8	(*udma_filter)(ide_drive_t *);
@@ -674,6 +655,10 @@ struct ide_dma_ops {
 	u8	(*dma_sff_read_status)(struct hwif_s *);
 };
 
+enum {
+	IDE_PFLAG_PROBING		= (1 << 0),
+};
+
 struct ide_host;
 
 typedef struct hwif_s {
@@ -690,6 +675,8 @@ typedef struct hwif_s {
 
 	ide_drive_t	*devices[MAX_DRIVES + 1];
 
+	unsigned long	port_flags;
+
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
 	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
@@ -708,8 +695,6 @@ typedef struct hwif_s {
 
 	struct device *dev;
 
-	ide_ack_intr_t *ack_intr;
-
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
 	const struct ide_tp_ops		*tp_ops;
@@ -1130,6 +1115,8 @@ void SELECT_MASK(ide_drive_t *, int);
 u8 ide_read_error(ide_drive_t *);
 void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
 
+int ide_check_ireason(ide_drive_t *, struct request *, int, int, int);
+
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
@@ -1154,7 +1141,8 @@ enum {
 	REQ_IDETAPE_WRITE	= (1 << 3),
 };
 
-int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
+int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
+		      void *, unsigned int);
 
 int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
@@ -1524,6 +1512,7 @@ int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
 int ide_scan_pio_blacklist(char *);
 const char *ide_xfer_verbose(u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
+int ide_pio_need_iordy(ide_drive_t *, const u8);
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
 void ide_set_pio(ide_drive_t *, u8);
@@ -1561,6 +1550,16 @@ static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
 
+static inline void *ide_get_drivedata(ide_drive_t *drive)
+{
+	return drive->drive_data;
+}
+
+static inline void ide_set_drivedata(ide_drive_t *drive, void *data)
+{
+	drive->drive_data = data;
+}
+
 #define ide_port_for_each_dev(i, dev, port) \
 	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++)
 
