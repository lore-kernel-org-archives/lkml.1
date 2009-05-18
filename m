Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZERCV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZERCV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZERCVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:21:45 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4740 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZERCVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:21:30 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Joe Perches <joe@perches.com>
Subject: [PATCH 1/6] drivers/ide: Convert printk(KERN_DEBUG to pr_debug(
Date: Sun, 17 May 2009 19:21:09 -0700
Message-Id: <5405960caf8cf09e74b8ac42ca8056843f13c20c.1242609803.git.joe@perches.com>
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
 drivers/ide/ali14xx.c       |    8 ++++----
 drivers/ide/hpt366.c        |    2 +-
 drivers/ide/ide-acpi.c      |    9 ++++-----
 drivers/ide/ide-cs.c        |    2 +-
 drivers/ide/ide-iops.c      |    3 +--
 drivers/ide/ide-probe.c     |    9 +++++----
 drivers/ide/ide-xfer-mode.c |    6 +++---
 drivers/ide/pdc202xx_old.c  |    6 +++---
 drivers/ide/pmac.c          |    2 +-
 drivers/ide/qd65xx.c        |   11 +++++------
 drivers/ide/serverworks.c   |    4 ++--
 drivers/ide/sl82c105.c      |    6 +++---
 12 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
index 90da1f9..5ac2174 100644
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -127,8 +127,8 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		param3 += 8;
 		param4 += 8;
 	}
-	printk(KERN_DEBUG "%s: PIO mode%d, t1=%dns, t2=%dns, cycles = %d+%d, %d+%d\n",
-		drive->name, pio, time1, time2, param1, param2, param3, param4);
+	pr_debug("%s: PIO mode%d, t1=%dns, t2=%dns, cycles = %d+%d, %d+%d\n",
+		 drive->name, pio, time1, time2, param1, param2, param3, param4);
 
 	/* stuff timing parameters into controller registers */
 	driveNum = (drive->hwif->index << 1) + (drive->dn & 1);
@@ -208,8 +208,8 @@ static const struct ide_port_info ali14xx_port_info = {
 
 static int __init ali14xx_probe(void)
 {
-	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
-			  basePort, regOn);
+	pr_debug("ali14xx: base=0x%03x, regOn=0x%02x.\n",
+		 basePort, regOn);
 
 	/* initialize controller registers */
 	if (!initRegisters()) {
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 0feb66c..0debe3c 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -805,7 +805,7 @@ static void hpt370_irq_timeout(ide_drive_t *drive)
 	u8  dma_cmd;
 
 	pci_read_config_word(dev, hwif->select_data + 2, &bfifo);
-	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
+	pr_debug("%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
 
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 77f79d2..c2f7c2f 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -45,8 +45,8 @@ struct ide_acpi_hwif_link {
 #undef DEBUGGING
 /* note: adds function name and KERN_DEBUG */
 #ifdef DEBUGGING
-#define DEBPRINT(fmt, args...)	\
-		printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
+#define DEBPRINT(fmt, args...)			\
+	pr_debug("%s: " fmt, __func__, ## args)
 #else
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
@@ -236,9 +236,8 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	status = acpi_evaluate_object(drive->acpidata->obj_handle, "_GTF",
 				      NULL, &output);
 	if (ACPI_FAILURE(status)) {
-		printk(KERN_DEBUG
-		       "%s: Run _GTF error: status = 0x%x\n",
-		       __func__, status);
+		pr_debug("%s: Run _GTF error: status = 0x%x\n",
+			 __func__, status);
 		goto out;
 	}
 
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 9e47f35..10adf8e 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -64,7 +64,7 @@ MODULE_LICENSE("Dual MPL/GPL");
 
 #ifdef CONFIG_PCMCIA_DEBUG
 INT_MODULE_PARM(pc_debug, 0);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
+#define DEBUG(n, args...) if (pc_debug>(n)) pr_debug(args)
 #else
 #define DEBUG(n, args...)
 #endif
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c19a221..b245f39 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -236,8 +236,7 @@ u8 eighty_ninty_three(ide_drive_t *drive)
 		return 1;
 
 	if (ivb)
-		printk(KERN_DEBUG "%s: skipping word 93 validity check\n",
-				  drive->name);
+		pr_debug("%s: skipping word 93 validity check\n", drive->name);
 
 	if (ata_id_is_sata(id) && !ivb)
 		return 1;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 7f264ed..8849e55 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -604,7 +604,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 	ide_drive_t *drive;
 	int i, rc;
 
-	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
+	pr_debug("Probing IDE interface %s...\n", hwif->name);
 
 	/* Let HW settle down a bit from whatever init state we
 	 * come from */
@@ -630,8 +630,8 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 			if (rc)
 				goto out;
 		} else
-			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
-					  drive->name);
+			pr_debug("%s: ide_wait_not_busy() skipped\n",
+				 drive->name);
 	}
 out:
 	/* Exit function with master reselected (let's be sane) */
@@ -700,7 +700,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		disable_irq(hwif->irq);
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
-		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
+		pr_debug("%s: Wait for ready failed before probe !\n",
+			 hwif->name);
 
 	/*
 	 * Second drive should only exist if first drive was found,
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index af44be9..e9d75e7 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -183,9 +183,9 @@ void ide_set_pio(ide_drive_t *drive, u8 req_pio)
 	 * - report device max PIO mode
 	 * - check req_pio != 255 against device max PIO mode
 	 */
-	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
-			  drive->name, host_pio, req_pio,
-			  req_pio == 255 ? "(auto-tune)" : "", pio);
+	pr_debug("%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
+		 drive->name, host_pio, req_pio,
+		 req_pio == 255 ? "(auto-tune)" : "", pio);
 
 	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
 }
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 248a54b..3e07c0b 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -103,9 +103,9 @@ static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 	}
 
 #if PDC202XX_DEBUG_DRIVE_INFO
-	printk(KERN_DEBUG "%s: %s drive%d 0x%08x ",
-		drive->name, ide_xfer_verbose(speed),
-		drive->dn, drive_conf);
+	pr_debug("%s: %s drive%d 0x%08x ",
+		 drive->name, ide_xfer_verbose(speed),
+		 drive->dn, drive_conf);
 	pci_read_config_dword(dev, drive_pci, &drive_conf);
 	printk("0x%08x\n", drive_conf);
 #endif
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index f76e4e6..a719a61 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1508,7 +1508,7 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 		return 1;
 	}
 
-	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
+	pr_debug("%s: empty DMA table?\n", drive->name);
 
 	return 0; /* revert to PIO for this request */
 }
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index c9a1349..550aa95 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -163,7 +163,7 @@ static int qd_find_disk_type (ide_drive_t *drive,
 
 	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
 		if (!strncmp(p->model, model+p->offset, 4)) {
-			printk(KERN_DEBUG "%s: listed !\n", drive->name);
+			pr_debug("%s: listed !\n", drive->name);
 			*active_time = p->active;
 			*recovery_time = p->recovery;
 			return 1;
@@ -183,7 +183,7 @@ static void qd_set_timing (ide_drive_t *drive, u8 timing)
 	drive->drive_data &= 0xff00;
 	drive->drive_data |= timing;
 
-	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
+	pr_debug("%s: %#x\n", drive->name, timing);
 }
 
 static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -378,8 +378,7 @@ static int __init qd_probe(int base)
 		}
 
 		printk(KERN_NOTICE "qd6500 at %#x\n", base);
-		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
-			config, QD_ID3);
+		pr_debug("qd6500: config=%#x, ID3=%u\n", config, QD_ID3);
 
 		d.port_ops = &qd6500_port_ops;
 		d.host_flags |= IDE_HFLAG_SINGLE;
@@ -392,8 +391,8 @@ static int __init qd_probe(int base)
 		control = inb(QD_CONTROL_PORT);
 
 		printk(KERN_NOTICE "qd6580 at %#x\n", base);
-		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
-			config, control, QD_ID3);
+		pr_debug("qd6580: config=%#x, control=%#x, ID3=%u\n",
+			 config, control, QD_ID3);
 
 		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index b6554ef..28e6083 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -191,8 +191,8 @@ static int init_chipset_svwks(struct pci_dev *dev)
 			pci_read_config_dword(isa_dev, 0x64, &reg);
 			reg &= ~0x00002000; /* disable 600ns interrupt mask */
 			if(!(reg & 0x00004000))
-				printk(KERN_DEBUG DRV_NAME " %s: UDMA not BIOS "
-					"enabled.\n", pci_name(dev));
+				pr_debug(DRV_NAME " %s: UDMA not BIOS enabled.\n",
+					 pci_name(dev));
 			reg |=  0x00004000; /* enable UDMA/33 support */
 			pci_write_config_dword(isa_dev, 0x64, reg);
 		}
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index b0a4606..21df560 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -89,9 +89,9 @@ static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pci_write_config_word(dev, reg,  drv_ctrl);
 	pci_read_config_word (dev, reg, &drv_ctrl);
 
-	printk(KERN_DEBUG "%s: selected %s (%dns) (%04X)\n", drive->name,
-			  ide_xfer_verbose(pio + XFER_PIO_0),
-			  ide_pio_cycle_time(drive, pio), drv_ctrl);
+	pr_debug("%s: selected %s (%dns) (%04X)\n", drive->name,
+		 ide_xfer_verbose(pio + XFER_PIO_0),
+		 ide_pio_cycle_time(drive, pio), drv_ctrl);
 }
 
 /*
-- 
1.6.3.1.10.g659a0.dirty

