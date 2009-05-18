Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZERCWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZERCWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZERCWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:22:21 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4743 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZERCWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:22:16 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: [PATCH 2/6] drivers/ide: Convert printk(KERN_INFO to pr_info(
Date: Sun, 17 May 2009 19:21:10 -0700
Message-Id: <3e6c44e2b4365598d80940c292bef91a835ab30d.1242609803.git.joe@perches.com>
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
 drivers/ide/aec62xx.c         |    4 ++--
 drivers/ide/alim15x3.c        |    4 ++--
 drivers/ide/amd74xx.c         |    2 +-
 drivers/ide/au1xxx-ide.c      |    2 +-
 drivers/ide/buddha.c          |    3 +--
 drivers/ide/cmd640.c          |   12 ++++++------
 drivers/ide/cs5536.c          |    2 +-
 drivers/ide/cy82c693.c        |    6 +++---
 drivers/ide/falconide.c       |    2 +-
 drivers/ide/gayle.c           |    6 +++---
 drivers/ide/hpt366.c          |   20 ++++++++++----------
 drivers/ide/ide-atapi.c       |    5 ++---
 drivers/ide/ide-cd.c          |    4 ++--
 drivers/ide/ide-cs.c          |    4 ++--
 drivers/ide/ide-disk.c        |   33 ++++++++++++++++-----------------
 drivers/ide/ide-dma.c         |    6 +++---
 drivers/ide/ide-eh.c          |    4 ++--
 drivers/ide/ide-floppy.c      |   15 +++++++--------
 drivers/ide/ide-gd.c          |    4 ++--
 drivers/ide/ide-generic.c     |    6 +++---
 drivers/ide/ide-h8300.c       |    2 +-
 drivers/ide/ide-pci-generic.c |    4 ++--
 drivers/ide/ide-pm.c          |    2 +-
 drivers/ide/ide-pnp.c         |    2 +-
 drivers/ide/ide-probe.c       |   30 +++++++++++++++---------------
 drivers/ide/ide-tape.c        |   30 +++++++++++++-----------------
 drivers/ide/ide-xfer-mode.c   |    6 +++---
 drivers/ide/ide.c             |   22 +++++++++-------------
 drivers/ide/it821x.c          |    9 ++++-----
 drivers/ide/macide.c          |    4 ++--
 drivers/ide/opti621.c         |    2 +-
 drivers/ide/palm_bk3710.c     |    2 +-
 drivers/ide/pdc202xx_new.c    |   10 +++++-----
 drivers/ide/pdc202xx_old.c    |   11 +++++------
 drivers/ide/pmac.c            |    8 ++++----
 drivers/ide/q40ide.c          |    2 +-
 drivers/ide/qd65xx.c          |    6 +++---
 drivers/ide/rz1000.c          |    8 ++++----
 drivers/ide/scc_pata.c        |    3 +--
 drivers/ide/setup-pci.c       |   32 ++++++++++++++++----------------
 drivers/ide/sgiioc4.c         |    8 ++++----
 drivers/ide/siimage.c         |    8 ++++----
 drivers/ide/sis5513.c         |   10 +++++-----
 drivers/ide/sl82c105.c        |    4 ++--
 drivers/ide/trm290.c          |   10 +++++-----
 drivers/ide/via82cxxx.c       |    2 +-
 46 files changed, 183 insertions(+), 198 deletions(-)

diff --git a/drivers/ide/aec62xx.c b/drivers/ide/aec62xx.c
index 878f8ec..d2f9293 100644
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -273,8 +273,8 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
 		unsigned long dma_base = pci_resource_start(dev, 4);
 
 		if (inb(dma_base + 2) & 0x10) {
-			printk(KERN_INFO DRV_NAME " %s: AEC6880%s card detected"
-				"\n", pci_name(dev), (idx == 4) ? "R" : "");
+			pr_info(DRV_NAME " %s: AEC6880%s card detected\n",
+				pci_name(dev), (idx == 4) ? "R" : "");
 			d.udma_mask = ATA_UDMA6;
 		}
 	}
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 537da1c..d1bb0d2 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -485,8 +485,8 @@ static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
 	if (!hwif->channel)
 		outb(inb(base + 2) & 0x60, base + 2);
 
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-			 hwif->name, base, base + 7);
+	pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+		hwif->name, base, base + 7);
 
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index 628cd2e..f664550 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -262,7 +262,7 @@ static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_
 	    ide_pci_is_in_compatibility_mode(dev))
 		d.host_flags |= IDE_HFLAG_BROKEN_ALTSTATUS;
 
-	printk(KERN_INFO "%s %s: UDMA%s controller\n",
+	pr_info("%s %s: UDMA%s controller\n",
 		d.name, pci_name(dev), amd_dma[fls(d.udma_mask) - 1]);
 
 	/*
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 4601364..fd16686 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -558,7 +558,7 @@ static int au_ide_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, host);
 
-	printk(KERN_INFO "Au1xxx IDE(builtin) configured for %s\n", mode );
+	pr_info("Au1xxx IDE(builtin) configured for %s\n", mode);
 
  out:
 	return ret;
diff --git a/drivers/ide/buddha.c b/drivers/ide/buddha.c
index d028f88..e338368 100644
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -199,8 +199,7 @@ fail_base2:
 		if (type != BOARD_XSURF)
 			z_writeb(0, buddha_board+BUDDHA_IRQ_MR);
 
-		printk(KERN_INFO "ide: %s IDE controller\n",
-				 buddha_board_name[type]);
+		pr_info("ide: %s IDE controller\n", buddha_board_name[type]);
 
 		for (i = 0; i < buddha_num_hwifs; i++) {
 			unsigned long base, ctl, irq_port;
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 8890276..665bdad 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -618,13 +618,13 @@ static void cmd640_init_dev(ide_drive_t *drive)
 	recovery_counts[i] = 16;	/* max possible */
 	program_drive_counts(drive, i);
 	set_prefetch_mode(drive, i, 0);
-	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch cleared\n", i);
+	pr_info(DRV_NAME ": drive%d timings/prefetch cleared\n", i);
 #else
 	/*
 	 * Set the drive unmask flags to match the prefetch setting.
 	 */
 	check_prefetch(drive, i);
-	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
+	pr_info(DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
 		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
@@ -768,8 +768,8 @@ static int __init cmd640x_init(void)
 	hw[1].irq = 15;
 	hw[1].chipset = ide_cmd640;
 
-	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
-			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
+	pr_info("cmd640: buggy cmd640%c interface on %s, config=0x%02x\n",
+		'a' + cmd640_chip_version - 1, bus_type, cfr);
 
 	/*
 	 * Initialize data for primary port
@@ -817,8 +817,8 @@ static int __init cmd640x_init(void)
 	if (second_port_cmd640)
 		hws[1] = &hw[1];
 
-	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
-			 second_port_cmd640 ? "" : "not ", port2);
+	pr_info("cmd640: %sserialized, secondary interface %s\n",
+		second_port_cmd640 ? "" : "not ", port2);
 
 #ifdef CMD640_DUMP_REGS
 	cmd640_dump_regs();
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index 0332a95..f161286 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -260,7 +260,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	u32 cfg;
 
 	if (use_msr)
-		printk(KERN_INFO DRV_NAME ": Using MSR regs instead of PCI\n");
+		pr_info(DRV_NAME ": Using MSR regs instead of PCI\n");
 
 	cs5536_read(dev, CFG, &cfg);
 
diff --git a/drivers/ide/cy82c693.c b/drivers/ide/cy82c693.c
index 74fc540..7477644 100644
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -177,7 +177,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s (ch=%d, dev=%d): set DMA mode to %d (single=%d)\n",
+	pr_info("%s (ch=%d, dev=%d): set DMA mode to %d (single=%d)\n",
 		drive->name, hwif->channel, drive->dn & 1, mode & 3, single);
 #endif /* CY82C693_DEBUG_INFO */
 
@@ -196,7 +196,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
+	pr_info("%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
 		drive->name, data);
 #endif /* CY82C693_DEBUG_INFO */
 }
@@ -263,7 +263,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
+	pr_info("%s (ch=%d, dev=%d): set PIO timing to "
 		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
 		drive->name, hwif->channel, drive->dn & 1,
 		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index 0e2df67..a1268a3 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -145,7 +145,7 @@ static int __init falconide_init(void)
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
 		return -ENODEV;
 
-	printk(KERN_INFO "ide: Falcon IDE controller\n");
+	pr_info("ide: Falcon IDE controller\n");
 
 	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
 		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index c711951..a8fd35b 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -142,9 +142,9 @@ static int __init gayle_init(void)
     return -ENODEV;
 
 found:
-	printk(KERN_INFO "ide: Gayle IDE controller (A%d style%s)\n",
-			 a4000 ? 4000 : 1200,
-			 ide_doubler ? ", IDE doubler" : "");
+    pr_info("ide: Gayle IDE controller (A%d style%s)\n",
+	    a4000 ? 4000 : 1200,
+	    ide_doubler ? ", IDE doubler" : "");
 
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 0debe3c..5689f63 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1093,7 +1093,7 @@ static int init_chipset_hpt366(struct pci_dev *dev)
 		else
 			pci_clk = 66;
 
-		printk(KERN_INFO "%s %s: DPLL base: %d MHz, f_CNT: %d, "
+		pr_info("%s %s: DPLL base: %d MHz, f_CNT: %d, "
 			"assuming %d MHz PCI\n", name, pci_name(dev),
 			dpll_clk, f_cnt, pci_clk);
 	} else {
@@ -1193,13 +1193,13 @@ static int init_chipset_hpt366(struct pci_dev *dev)
 			return -EIO;
 		}
 
-		printk(KERN_INFO "%s %s: using %d MHz DPLL clock\n",
+		pr_info("%s %s: using %d MHz DPLL clock\n",
 			name, pci_name(dev), dpll_clk);
 	} else {
 		/* Mark the fact that we're not using the DPLL. */
 		dpll_clk = 0;
 
-		printk(KERN_INFO "%s %s: using %d MHz PCI clock\n",
+		pr_info("%s %s: using %d MHz PCI clock\n",
 			name, pci_name(dev), pci_clk);
 	}
 
@@ -1337,8 +1337,8 @@ static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
 
 	local_irq_restore(flags);
 
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-			 hwif->name, base, base + 7);
+	pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+		hwif->name, base, base + 7);
 
 	hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
@@ -1353,8 +1353,8 @@ static void __devinit hpt374_init(struct pci_dev *dev, struct pci_dev *dev2)
 	if (dev2->irq != dev->irq) {
 		/* FIXME: we need a core pci_set_interrupt() */
 		dev2->irq = dev->irq;
-		printk(KERN_INFO DRV_NAME " %s: PCI config space interrupt "
-			"fixed\n", pci_name(dev2));
+		pr_info(DRV_NAME " %s: PCI config space interrupt fixed\n",
+			pci_name(dev2));
 	}
 }
 
@@ -1389,8 +1389,8 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 	pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 
 	if (pin1 != pin2 && dev->irq == dev2->irq) {
-		printk(KERN_INFO DRV_NAME " %s: onboard version of chipset, "
-			"pin1=%d pin2=%d\n", pci_name(dev), pin1, pin2);
+		pr_info(DRV_NAME " %s: onboard version of chipset, pin1=%d pin2=%d\n",
+			pci_name(dev), pin1, pin2);
 		return 1;
 	}
 
@@ -1531,7 +1531,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		break;
 	}
 
-	printk(KERN_INFO DRV_NAME ": %s chipset detected\n", info->chip_name);
+	pr_info(DRV_NAME ": %s chipset detected\n", info->chip_name);
 
 	d = hpt366_chipsets[min_t(u8, idx, 1)];
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7201b17..9950b32 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -12,7 +12,7 @@
 
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
-	printk(KERN_INFO "ide: " fmt, ## args)
+	pr_info("ide: " fmt, ## args)
 #else
 #define debug_log(fmt, args...) do {} while (0)
 #endif
@@ -231,8 +231,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
+			pr_info("cmd 0x%x timed out\n", rq->cmd[0]);
 		wait = 0;
 		break;
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 925eb9e..d96dd09 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1362,7 +1362,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	ide_cdrom_update_speed(drive, buf);
 
-	printk(KERN_INFO PFX "%s: ATAPI", drive->name);
+	pr_info(PFX "%s: ATAPI", drive->name);
 
 	/* don't print speed if the drive reported 0 */
 	if (cd->max_speed)
@@ -1858,7 +1858,7 @@ static void __exit ide_cdrom_exit(void)
 
 static int __init ide_cdrom_init(void)
 {
-	printk(KERN_INFO DRV_NAME " driver " IDECD_VERSION "\n");
+	pr_info(DRV_NAME " driver " IDECD_VERSION "\n");
 	return driver_register(&ide_cdrom_driver.gen_driver);
 }
 
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 10adf8e..3b975f0 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -332,8 +332,8 @@ static int ide_config(struct pcmcia_device *link)
     info->node.minor = 0;
     info->host = host;
     link->dev_node = &info->node;
-    printk(KERN_INFO "ide-cs: %s: Vpp = %d.%d\n",
-	   info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
+    pr_info("ide-cs: %s: Vpp = %d.%d\n",
+	    info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
 
     kfree(stk);
     return 0;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index a9fbe2c..89d2568 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -323,19 +323,18 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 	if (set_max <= capacity)
 		return;
 
-	printk(KERN_INFO "%s: Host Protected Area detected.\n"
-			 "\tcurrent capacity is %llu sectors (%llu MB)\n"
-			 "\tnative  capacity is %llu sectors (%llu MB)\n",
-			 drive->name,
-			 capacity, sectors_to_MB(capacity),
-			 set_max, sectors_to_MB(set_max));
+	pr_info("%s: Host Protected Area detected.\n"
+		"\tcurrent capacity is %llu sectors (%llu MB)\n"
+		"\tnative  capacity is %llu sectors (%llu MB)\n",
+		drive->name,
+		capacity, sectors_to_MB(capacity),
+		set_max, sectors_to_MB(set_max));
 
 	set_max = idedisk_set_max_address(drive, set_max, lba48);
 
 	if (set_max) {
 		drive->capacity64 = set_max;
-		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
-				 drive->name);
+		pr_info("%s: Host Protected Area disabled.\n", drive->name);
 	}
 }
 
@@ -382,9 +381,9 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
 	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		if (drive->capacity64 > 1ULL << 28) {
-			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
-					 " will be used for accessing sectors "
-					 "> %u\n", drive->name, 1 << 28);
+			pr_info("%s: cannot use LBA48 DMA - PIO mode"
+				" will be used for accessing sectors > %u\n",
+				drive->name, 1 << 28);
 		} else
 			drive->dev_flags &= ~IDE_DFLAG_LBA48;
 	}
@@ -498,8 +497,8 @@ static void update_ordered(ide_drive_t *drive)
 			 capacity <= (1ULL << 28) ||
 			 ata_id_flush_ext_enabled(id));
 
-		printk(KERN_INFO "%s: cache flushes %ssupported\n",
-		       drive->name, barrier ? "" : "not ");
+		pr_info("%s: cache flushes %ssupported\n",
+			drive->name, barrier ? "" : "not ");
 
 		if (barrier) {
 			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
@@ -639,7 +638,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 		blk_queue_max_sectors(q, max_s);
 	}
 
-	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
+	pr_info("%s: max request size: %dKiB\n", drive->name,
 		q->max_sectors / 2);
 
 	if (ata_id_is_ssd(id))
@@ -677,8 +676,8 @@ static void ide_disk_setup(ide_drive_t *drive)
 			}
 		}
 	}
-	printk(KERN_INFO "%s: %llu sectors (%llu MB)",
-			 drive->name, capacity, sectors_to_MB(capacity));
+	pr_info("%s: %llu sectors (%llu MB)",
+		drive->name, capacity, sectors_to_MB(capacity));
 
 	/* Only print cache size when it was specified */
 	if (id[ATA_ID_BUF_SIZE])
@@ -709,7 +708,7 @@ static void ide_disk_flush(ide_drive_t *drive)
 		return;
 
 	if (do_idedisk_flushcache(drive))
-		printk(KERN_INFO "%s: wcache flush failed!\n", drive->name);
+		pr_info("%s: wcache flush failed!\n", drive->name);
 }
 
 static int ide_disk_init_media(ide_drive_t *drive, struct gendisk *disk)
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a0b8cab..2a865a7 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(ide_dma_off_quietly);
 
 void ide_dma_off(ide_drive_t *drive)
 {
-	printk(KERN_INFO "%s: DMA disabled\n", drive->name);
+	pr_info("%s: DMA disabled\n", drive->name);
 	ide_dma_off_quietly(drive);
 }
 EXPORT_SYMBOL(ide_dma_off);
@@ -342,8 +342,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 	mode = min(mode, req_mode);
 
-	printk(KERN_INFO "%s: %s mode selected\n", drive->name,
-			  mode ? ide_xfer_verbose(mode) : "no DMA");
+	pr_info("%s: %s mode selected\n", drive->name,
+		mode ? ide_xfer_verbose(mode) : "no DMA");
 
 	return mode;
 }
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 5d5fb96..c9f1fea 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -173,7 +173,7 @@ static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
-		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
+		pr_info("%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
@@ -250,7 +250,7 @@ static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 		tmp = ide_read_error(drive);
 
 		if (tmp == 1) {
-			printk(KERN_INFO "%s: reset: success\n", hwif->name);
+			pr_info("%s: reset: success\n", hwif->name);
 			drive->failures = 0;
 		} else {
 			ide_reset_report_error(hwif, tmp);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2b4868d..f001f06 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -338,10 +338,10 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	capacity = cyls * heads * sectors * sector_size;
 
 	if (memcmp(page, &floppy->flexible_disk_page, 32))
-		printk(KERN_INFO PFX "%s: %dkB, %d/%d/%d CHS, %d kBps, "
-				"%d sector size, %d rpm\n",
-				drive->name, capacity / 1024, cyls, heads,
-				sectors, transfer_rate / 8, sector_size, rpm);
+		pr_info(PFX "%s: %dkB, %d/%d/%d CHS, %d kBps, "
+			"%d sector size, %d rpm\n",
+			drive->name, capacity / 1024, cyls, heads,
+			sectors, transfer_rate / 8, sector_size, rpm);
 
 	memcpy(&floppy->flexible_disk_page, page, 32);
 	drive->bios_cyl = cyls;
@@ -423,10 +423,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
 			if (memcmp(cap_desc, &floppy->cap_desc, 8))
-				printk(KERN_INFO PFX "%s: %dkB, %d blocks, %d "
-				       "sector size\n",
-				       drive->name, blocks * length / 1024,
-				       blocks, length);
+				pr_info(PFX "%s: %dkB, %d blocks, %d sector size\n",
+					drive->name, blocks * length / 1024,
+					blocks, length);
 			memcpy(&floppy->cap_desc, cap_desc, 8);
 
 			if (!length || length % 512) {
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 4b6b71e..156e62b 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -136,7 +136,7 @@ static void ide_gd_shutdown(ide_drive_t *drive)
 		return;
 	}
 
-	printk(KERN_INFO "Shutdown: %s\n", drive->name);
+	pr_info("Shutdown: %s\n", drive->name);
 
 	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
 }
@@ -398,7 +398,7 @@ failed:
 
 static int __init ide_gd_init(void)
 {
-	printk(KERN_INFO DRV_NAME " driver " IDE_GD_VERSION "\n");
+	pr_info(DRV_NAME " driver " IDE_GD_VERSION "\n");
 	return driver_register(&ide_gd_driver.gen_driver);
 }
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 7812ca0..107235e 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -92,8 +92,8 @@ static int __init ide_generic_init(void)
 	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
 
 	if (!probe_mask) {
-		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" "
-		     "module parameter for probing all legacy ISA IDE ports\n");
+		pr_info(DRV_NAME ": please use \"probe_mask=0x3f\" "
+			"module parameter for probing all legacy ISA IDE ports\n");
 
 		if (primary == 0)
 			probe_mask |= 0x1;
@@ -101,7 +101,7 @@ static int __init ide_generic_init(void)
 		if (secondary == 0)
 			probe_mask |= 0x2;
 	} else
-		printk(KERN_INFO DRV_NAME ": enforcing probing of I/O ports "
+		pr_info(DRV_NAME ": enforcing probing of I/O ports "
 			"upon user request\n");
 
 	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index c06ebdc..e3e581a 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -85,7 +85,7 @@ static int __init h8300_ide_init(void)
 {
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
-	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
+	pr_info(DRV_NAME ": H8/300 generic IDE interface\n");
 
 	if (!request_region(CONFIG_H8300_IDE_BASE, H8300_IDE_GAP*8, "ide-h8300"))
 		goto out_busy;
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 61111fd..d0abe47 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -128,8 +128,8 @@ static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_devi
 		u16 command;
 		pci_read_config_word(dev, PCI_COMMAND, &command);
 		if (!(command & PCI_COMMAND_IO)) {
-			printk(KERN_INFO "%s %s: skipping disabled "
-				"controller\n", d->name, pci_name(dev));
+			pr_info("%s %s: skipping disabled controller\n",
+				d->name, pci_name(dev));
 			goto out;
 		}
 	}
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 0d8a151..f72a948 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -80,7 +80,7 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 	struct request_pm_state *pm = rq->data;
 
 #ifdef DEBUG_PM
-	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
+	pr_info("%s: complete_power_step(step: %d)\n",
 		drive->name, pm->pm_step);
 #endif
 	if (drive->media != ide_disk)
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 6e80b77..5c995e0 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -38,7 +38,7 @@ static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	int rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
-	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
+	pr_info(DRV_NAME ": generic PnP IDE interface\n");
 
 	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) && pnp_irq_valid(dev, 0)))
 		return -1;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 8849e55..adf7a09 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -116,7 +116,7 @@ static void ide_classify_ata_dev(ide_drive_t *drive)
 	if (!ata_id_has_unload(drive->id))
 		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 
-	printk(KERN_INFO "%s: %s, %s DISK drive\n", drive->name, m,
+	pr_info("%s: %s, %s DISK drive\n", drive->name, m,
 		is_cfa ? "CFA" : "ATA");
 }
 
@@ -126,7 +126,7 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 	char *m = (char *)&id[ATA_ID_PROD];
 	u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
-	printk(KERN_INFO "%s: %s, ATAPI ", drive->name, m);
+	pr_info("%s: %s, ATAPI ", drive->name, m);
 	switch (type) {
 	case ide_floppy:
 		if (!strstr(m, "CD-ROM")) {
@@ -203,7 +203,7 @@ static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 
 	drive->dev_flags |= IDE_DFLAG_ID_READ;
 #ifdef DEBUG
-	printk(KERN_INFO "%s: dumping identify data\n", drive->name);
+	pr_info("%s: dumping identify data\n", drive->name);
 	ide_dump_identify((u8 *)id);
 #endif
 	ide_fix_driveid(id);
@@ -271,9 +271,9 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 		s = tp_ops->read_status(hwif);
 		if ((a ^ s) & ~ATA_IDX)
 			/* ancient Seagate drives, broken interfaces */
-			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
-					 "instead of ALTSTATUS(0x%02x)\n",
-					 drive->name, s, a);
+			pr_info("%s: probing with STATUS(0x%02x) "
+				"instead of ALTSTATUS(0x%02x)\n",
+				drive->name, s, a);
 		else
 			/* use non-intrusive polling */
 			use_altstatus = 1;
@@ -376,7 +376,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		return 4;
 
 #ifdef DEBUG
-	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
+	pr_info("probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, present, drive->media,
 		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
@@ -499,11 +499,11 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
-				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
+				pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
 					drive->head, drive->sect);
 			} else if (drive->media == ide_cdrom) {
-				printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
+				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
 			} else {
 				/* nuke it */
 				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
@@ -848,11 +848,11 @@ static int init_irq (ide_hwif_t *hwif)
 		goto out_up;
 
 #if !defined(__mc68000__)
-	printk(KERN_INFO "%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
+	pr_info("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		io_ports->data_addr, io_ports->status_addr,
 		io_ports->ctl_addr, hwif->irq);
 #else
-	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
+	pr_info("%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
@@ -1072,7 +1072,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 			rc = ide_hwif_setup_dma(hwif, d);
 
 		if (rc < 0) {
-			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+			pr_info("%s: DMA disabled\n", hwif->name);
 
 			hwif->dma_ops = NULL;
 			hwif->dma_base = 0;
@@ -1329,7 +1329,7 @@ static void ide_disable_port(ide_hwif_t *hwif)
 	struct ide_host *host = hwif->host;
 	int i;
 
-	printk(KERN_INFO "%s: disabling port\n", hwif->name);
+	pr_info("%s: disabling port\n", hwif->name);
 
 	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		if (host->ports[i] == hwif) {
@@ -1392,8 +1392,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			continue;
 
 		if (hwif_init(hwif) == 0) {
-			printk(KERN_INFO "%s: failed to initialize IDE "
-					 "interface\n", hwif->name);
+			pr_info("%s: failed to initialize IDE interface\n",
+				hwif->name);
 			device_unregister(&hwif->gendev);
 			ide_disable_port(hwif);
 			continue;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cb942a9..3b63169 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -65,7 +65,7 @@ enum {
 #define debug_log(lvl, fmt, args...)			\
 {							\
 	if (tape->debug_mask & lvl)			\
-	printk(KERN_INFO "ide-tape: " fmt, ## args);	\
+		pr_info("ide-tape: " fmt, ## args);	\
 }
 #else
 #define debug_log(lvl, fmt, args...) do {} while (0)
@@ -511,8 +511,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 				(readpos[0] & 0x40) ? "Yes" : "No");
 
 		if (readpos[0] & 0x4) {
-			printk(KERN_INFO "ide-tape: Block location is unknown"
-					 "to the tape\n");
+			pr_info("ide-tape: Block location is unknown to the tape\n");
 			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 			uptodate = 0;
 			err = IDE_DRV_ERROR_GENERAL;
@@ -1159,8 +1158,8 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 		position = idetape_read_position(drive);
 		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
-					 " %s\n", tape->name, __func__);
+			pr_info("ide-tape: %s: position_tape failed in %s\n",
+				tape->name, __func__);
 			return;
 		}
 	}
@@ -1278,8 +1277,7 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 			bh = tape->bh;
 			while (i) {
 				if (bh == NULL) {
-					printk(KERN_INFO "ide-tape: bug,"
-							 " bh NULL\n");
+					pr_info("ide-tape: bug, bh NULL\n");
 					break;
 				}
 				min = min(i, (unsigned int)(bh->b_size -
@@ -2034,8 +2032,8 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	ide_fixstring(product_id, 16, 0);
 	ide_fixstring(fw_rev, 4, 0);
 
-	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
-			drive->name, tape->name, vendor_id, product_id, fw_rev);
+	pr_info("ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
+		drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 
 /*
@@ -2071,13 +2069,13 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	*(u16 *)&caps[16] = be16_to_cpup((__be16 *)&caps[16]);
 
 	if (!speed) {
-		printk(KERN_INFO "ide-tape: %s: invalid tape speed "
-				"(assuming 650KB/sec)\n", drive->name);
+		pr_info("ide-tape: %s: invalid tape speed (assuming 650KB/sec)\n",
+			drive->name);
 		*(u16 *)&caps[14] = 650;
 	}
 	if (!max_speed) {
-		printk(KERN_INFO "ide-tape: %s: invalid max_speed "
-				"(assuming 650KB/sec)\n", drive->name);
+		pr_info("ide-tape: %s: invalid max_speed (assuming 650KB/sec)\n",
+			drive->name);
 		*(u16 *)&caps[8] = 650;
 	}
 
@@ -2171,8 +2169,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
-		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
-				 tape->name);
+		pr_info("ide-tape: %s: disabling DSC overlap\n", tape->name);
 		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
 
@@ -2214,8 +2211,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 */
 	tape->best_dsc_rw_freq = clamp_t(unsigned long, t, IDETAPE_DSC_RW_MIN,
 					 IDETAPE_DSC_RW_MAX);
-	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
-		"%lums tDSC%s\n",
+	pr_info("ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
 		tape->buffer_size / 1024,
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
index e9d75e7..c60bb69 100644
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -70,7 +70,7 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
 
 	if (pio_mode != -1) {
-		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
+		pr_info("%s: is on PIO blacklist\n", drive->name);
 	} else {
 		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
 		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
@@ -96,8 +96,8 @@ u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 		}
 
 		if (overridden)
-			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
-					 drive->name);
+			pr_info("%s: tPIO > 2, assuming tPIO = 2\n",
+				drive->name);
 	}
 
 	if (pio_mode > max_mode)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 92c9b90..0df5655 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -273,25 +273,23 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 	int i = drive->hwif->index * MAX_DRIVES + unit;
 
 	if (ide_nodma & (1 << i)) {
-		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
+		pr_info("ide: disallowing DMA for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NODMA;
 	}
 	if (ide_noflush & (1 << i)) {
-		printk(KERN_INFO "ide: disabling flush requests for %s\n",
-				 drive->name);
+		pr_info("ide: disabling flush requests for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
 	if (ide_noprobe & (1 << i)) {
-		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
+		pr_info("ide: skipping probe for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 	if (ide_nowerr & (1 << i)) {
-		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
-				 drive->name);
+		pr_info("ide: ignoring the ATA_DF bit for %s\n", drive->name);
 		drive->bad_wstat = BAD_R_STAT;
 	}
 	if (ide_cdroms & (1 << i)) {
-		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
+		pr_info("ide: forcing %s as a CD-ROM\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_PRESENT;
 		drive->media = ide_cdrom;
 		/* an ATAPI device ignores DRDY */
@@ -302,9 +300,8 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 		drive->head = drive->bios_head = ide_disks_chs[i].head;
 		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
 
-		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
-				 drive->name,
-				 drive->cyl, drive->head, drive->sect);
+		pr_info("ide: forcing %s as a disk (%d/%d/%d)\n",
+			drive->name, drive->cyl, drive->head, drive->sect);
 
 		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
 		drive->media = ide_disk;
@@ -343,8 +340,7 @@ void ide_port_apply_params(ide_hwif_t *hwif)
 	int i;
 
 	if (ide_ignore_cable & (1 << hwif->index)) {
-		printk(KERN_INFO "ide: ignoring cable detection for %s\n",
-				 hwif->name);
+		pr_info("ide: ignoring cable detection for %s\n", hwif->name);
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
 
@@ -359,7 +355,7 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
+	pr_info("Uniform Multi-Platform E-IDE driver\n");
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 51aa745..97dfd81 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -467,7 +467,7 @@ static void it821x_quirkproc(ide_drive_t *drive)
 			id[ATA_ID_COMMAND_SET_2] |= 0x0400;   /* LBA48 valid */
 			id[ATA_ID_CFS_ENABLE_2]  |= 0x0400;   /* LBA48 on */
 			/* Reporting logic */
-			printk(KERN_INFO "%s: IT8212 %sRAID %d volume",
+			pr_info("%s: IT8212 %sRAID %d volume",
 				drive->name, id[147] ? "Bootable " : "",
 				id[ATA_ID_CSFO]);
 			if (id[ATA_ID_CSFO] != 1)
@@ -488,7 +488,7 @@ static void it821x_quirkproc(ide_drive_t *drive)
 			id[ATA_ID_DLF]		  = 0;
 			id[ATA_ID_CSFO]		  = 0;
 			id[ATA_ID_CFA_POWER]	  = 0;
-			printk(KERN_INFO "%s: Performing identify fixups.\n",
+			pr_info("%s: Performing identify fixups.\n",
 				drive->name);
 		}
 
@@ -609,12 +609,11 @@ static int init_chipset_it821x(struct pci_dev *dev)
 
 	/* Force the card into bypass mode if so requested */
 	if (it8212_noraid) {
-		printk(KERN_INFO DRV_NAME " %s: forcing bypass mode\n",
-			pci_name(dev));
+		pr_info(DRV_NAME " %s: forcing bypass mode\n", pci_name(dev));
 		it8212_disable_raid(dev);
 	}
 	pci_read_config_byte(dev, 0x50, &conf);
-	printk(KERN_INFO DRV_NAME " %s: controller in %s mode\n",
+	pr_info(DRV_NAME " %s: controller in %s mode\n",
 		pci_name(dev), mode[conf & 1]);
 	return 0;
 }
diff --git a/drivers/ide/macide.c b/drivers/ide/macide.c
index 4b1718e..1441a5a 100644
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -122,8 +122,8 @@ static int __init macide_init(void)
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO "ide: Macintosh %s IDE controller\n",
-			 mac_ide_name[macintosh_config->ide_type - 1]);
+	pr_info("ide: Macintosh %s IDE controller\n",
+		mac_ide_name[macintosh_config->ide_type - 1]);
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
diff --git a/drivers/ide/opti621.c b/drivers/ide/opti621.c
index 6048eda..bff3311 100644
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -173,7 +173,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	/* check CLK speed */
 	clk = read_reg(STRAP_REG) & 1;
 
-	printk(KERN_INFO "%s: CLK = %d MHz\n", hwif->name, clk ? 25 : 33);
+	pr_info("%s: CLK = %d MHz\n", hwif->name, clk ? 25 : 33);
 
 	tim  = data_rec_timings[clk][pio];
 	misc = addr_timings[clk][addr_pio];
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index 09d813d..925dd5d 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -283,7 +283,7 @@ static u8 palm_bk3710_cable_detect(ide_hwif_t *hwif)
 static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
 					  const struct ide_port_info *d)
 {
-	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+	pr_info("    %s: MMIO-DMA\n", hwif->name);
 
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index b68906c..f9b910d 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -360,7 +360,7 @@ static int init_chipset_pdcnew(struct pci_dev *dev)
 	 * registers setting.
 	 */
 	pll_input = detect_pll_input_clock(dma_base);
-	printk(KERN_INFO "%s %s: PLL input clock is %ld kHz\n",
+	pr_info("%s %s: PLL input clock is %ld kHz\n",
 		name, pci_name(dev), pll_input / 1000);
 
 	/* Sanity check */
@@ -460,8 +460,8 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 
 		if (dev2->irq != dev->irq) {
 			dev2->irq = dev->irq;
-			printk(KERN_INFO DRV_NAME " %s: PCI config space "
-				"interrupt fixed\n", pci_name(dev));
+			pr_info(DRV_NAME " %s: PCI config space interrupt fixed\n",
+				pci_name(dev));
 		}
 
 		return dev2;
@@ -532,8 +532,8 @@ static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_de
 	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 	    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 	     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-		printk(KERN_INFO DRV_NAME " %s: attached to I2O RAID controller,"
-			" skipping\n", pci_name(dev));
+		pr_info(DRV_NAME " %s: attached to I2O RAID controller, skipping\n",
+			pci_name(dev));
 		return -ENODEV;
 	}
 
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 3e07c0b..2655a1f 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -269,7 +269,7 @@ static int init_chipset_pdc202xx(struct pci_dev *dev)
 	udma_speed_flag	= inb(dmabase | 0x1f);
 	primary_mode	= inb(dmabase | 0x1a);
 	secondary_mode	= inb(dmabase | 0x1b);
-	printk(KERN_INFO "%s: (U)DMA Burst Bit %sABLED " \
+	pr_info("%s: (U)DMA Burst Bit %sABLED " \
 		"Primary %s Mode " \
 		"Secondary %s Mode.\n", pci_name(dev),
 		(udma_speed_flag & 1) ? "EN" : "DIS",
@@ -277,7 +277,7 @@ static int init_chipset_pdc202xx(struct pci_dev *dev)
 		(secondary_mode & 1) ? "MASTER" : "PCI" );
 
 	if (!(udma_speed_flag & 1)) {
-		printk(KERN_INFO "%s: FORCING BURST BIT 0x%02x->0x%02x ",
+		pr_info("%s: FORCING BURST BIT 0x%02x->0x%02x ",
 			pci_name(dev), udma_speed_flag,
 			(udma_speed_flag|1));
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
@@ -298,8 +298,8 @@ static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
 		if (irq != irq2) {
 			pci_write_config_byte(dev,
 				(PCI_INTERRUPT_LINE)|0x80, irq);     /* 0xbc */
-			printk(KERN_INFO "%s %s: PCI config space interrupt "
-				"mirror fixed\n", name, pci_name(dev));
+			pr_info("%s %s: PCI config space interrupt mirror fixed\n",
+				name, pci_name(dev));
 		}
 	}
 }
@@ -403,8 +403,7 @@ static int __devinit pdc202xx_init_one(struct pci_dev *dev, const struct pci_dev
 		    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 		    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 		     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-			printk(KERN_INFO DRV_NAME " %s: skipping Promise "
-				"PDC20265 attached to I2O RAID controller\n",
+			pr_info(DRV_NAME " %s: skipping Promise PDC20265 attached to I2O RAID controller\n",
 				pci_name(dev));
 			return -ENODEV;
 		}
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index a719a61..e39ca1a 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1110,10 +1110,10 @@ static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 		msleep(jiffies_to_msecs(IDE_WAKEUP_DELAY));
 	}
 
-	printk(KERN_INFO DRV_NAME ": Found Apple %s controller (%s), "
-			 "bus ID %d%s, irq %d\n", model_name[pmif->kind],
-			 pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
-			 pmif->mediabay ? " (mediabay)" : "", hw->irq);
+	pr_info(DRV_NAME ": Found Apple %s controller (%s), bus ID %d%s, irq %d\n",
+		model_name[pmif->kind],
+		pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
+		pmif->mediabay ? " (mediabay)" : "", hw->irq);
 
 	rc = ide_host_register(host, &d, hws);
 	if (rc) {
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index c793466..cab1e9e 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -141,7 +141,7 @@ static int __init q40ide_init(void)
     if (!MACH_IS_Q40)
       return -ENODEV;
 
-    printk(KERN_INFO "ide: Q40 IDE controller\n");
+    pr_info("ide: Q40 IDE controller\n");
 
     for (i = 0; i < Q40IDE_NUM_HWIFS; i++) {
 	const char *name = q40_ide_names[i];
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 550aa95..e027ac2 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -198,7 +198,7 @@ static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
 	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
 	    id[ATA_ID_EIDE_PIO] >= 240) {
-		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
+		pr_info("%s: PIO mode%d\n", drive->name,
 			id[ATA_ID_OLD_PIO_MODES] & 0xff);
 		active_time = 110;
 		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
@@ -245,7 +245,7 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 					recovery_time = cycle_time - active_time;
 				}
 		}
-		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,pio);
+		pr_info("%s: PIO mode%d\n", drive->name, pio);
 	}
 
 	if (!hwif->channel && drive->media != ide_disk) {
@@ -400,7 +400,7 @@ static int __init qd_probe(int base)
 		if (control & QD_CONTR_SEC_DISABLED)
 			d.host_flags |= IDE_HFLAG_SINGLE;
 
-		printk(KERN_INFO "qd6580: %s IDE board\n",
+		pr_info("qd6580: %s IDE board\n",
 			(control & QD_CONTR_SEC_DISABLED) ? "single" : "dual");
 		break;
 	default:
diff --git a/drivers/ide/rz1000.c b/drivers/ide/rz1000.c
index a6414a8..5108fce 100644
--- a/drivers/ide/rz1000.c
+++ b/drivers/ide/rz1000.c
@@ -28,12 +28,12 @@ static int __devinit rz1000_disable_readahead(struct pci_dev *dev)
 
 	if (!pci_read_config_word (dev, 0x40, &reg) &&
 	    !pci_write_config_word(dev, 0x40, reg & 0xdfff)) {
-		printk(KERN_INFO "%s: disabled chipset read-ahead "
-			"(buggy RZ1000/RZ1001)\n", pci_name(dev));
+		pr_info("%s: disabled chipset read-ahead (buggy RZ1000/RZ1001)\n",
+			pci_name(dev));
 		return 0;
 	} else {
-		printk(KERN_INFO "%s: serialized, disabled unmasking "
-			"(buggy RZ1000/RZ1001)\n", pci_name(dev));
+		pr_info("%s: serialized, disabled unmasking (buggy RZ1000/RZ1001)\n",
+			pci_name(dev));
 		return 1;
 	}
 }
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 5be41f2..2dab04b 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -499,8 +499,7 @@ static u8 scc_udma_filter(ide_drive_t *drive)
 
 	/* errata A308 workaround: limit non ide_disk drive to UDMA4 */
 	if ((drive->media != ide_disk) && (mask & 0xE0)) {
-		printk(KERN_INFO "%s: limit %s to UDMA4\n",
-		       SCC_PATA_NAME, drive->name);
+		pr_info("%s: limit %s to UDMA4\n", SCC_PATA_NAME, drive->name);
 		mask = ATA_UDMA4;
 	}
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 7a3a12d..ac7cf22 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -39,12 +39,12 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 			 (progif & 5) != 5) {
 		if ((progif & 0xa) != 0xa) {
-			printk(KERN_INFO "%s %s: device not capable of full "
-				"native PCI mode\n", name, pci_name(dev));
+			pr_info("%s %s: device not capable of full native PCI mode\n",
+				name, pci_name(dev));
 			return -EOPNOTSUPP;
 		}
-		printk(KERN_INFO "%s %s: placing both ports into native PCI "
-			"mode\n", name, pci_name(dev));
+		pr_info("%s %s: placing both ports into native PCI mode\n",
+			name, pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
@@ -115,7 +115,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
 		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
-			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
+			pr_info("%s %s: simplex device: DMA forced\n",
 				d->name, pci_name(dev));
 		goto out;
 	}
@@ -132,7 +132,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 */
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
+		pr_info("%s %s: simplex device: DMA disabled\n",
 			d->name, pci_name(dev));
 		return -1;
 	}
@@ -168,7 +168,7 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
+	pr_info("%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
 		d->name, pci_name(dev),
 		dev->vendor, dev->device, dev->revision);
 }
@@ -256,7 +256,7 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	if (ide_setup_pci_baseregs(dev, d->name) ||
 	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
-		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
+		pr_info("%s %s: device disabled (BIOS)\n",
 			d->name, pci_name(dev));
 		return -ENODEV;
 	}
@@ -385,10 +385,10 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 			return -1;
 
 		if (hwif->host_flags & IDE_HFLAG_MMIO)
-			printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+			pr_info("    %s: MMIO-DMA\n", hwif->name);
 		else
-			printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-					 hwif->name, base, base + 7);
+			pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+				hwif->name, base, base + 7);
 
 		hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
@@ -434,7 +434,7 @@ static int ide_setup_pci_controller(struct pci_dev *dev,
 		ret = ide_pci_configure(dev, d);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
+		pr_info("%s %s: device enabled (Linux)\n",
 			d->name, pci_name(dev));
 	}
 
@@ -473,7 +473,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
-			printk(KERN_INFO "%s %s: IDE port disabled\n",
+			pr_info("%s %s: IDE port disabled\n",
 				d->name, pci_name(dev));
 			continue;	/* port not enabled */
 		}
@@ -519,14 +519,14 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 
 	if (ide_pci_is_in_compatibility_mode(dev)) {
 		if (noisy)
-			printk(KERN_INFO "%s %s: not 100%% native mode: will "
-				"probe irqs later\n", d->name, pci_name(dev));
+			pr_info("%s %s: not 100%% native mode: will probe irqs later\n",
+				d->name, pci_name(dev));
 		pciirq = 0;
 	} else if (!pciirq && noisy) {
 		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
 			d->name, pci_name(dev), pciirq);
 	} else if (noisy) {
-		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
+		pr_info("%s %s: 100%% native mode on irq %d\n",
 			d->name, pci_name(dev), pciirq);
 	}
 
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index e5d2a48..40615e8 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -322,7 +322,7 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 	int num_ports = sizeof (ioc4_dma_regs_t);
 	void *pad;
 
-	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+	pr_info("    %s: MMIO-DMA\n", hwif->name);
 
 	if (request_mem_region(dma_base, num_ports, hwif->name) == NULL) {
 		printk(KERN_ERR "%s(%s) -- ERROR: addresses 0x%08lx to 0x%08lx "
@@ -353,7 +353,7 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 	printk(KERN_ERR "%s(%s) -- ERROR: Unable to allocate DMA maps\n",
 	       __func__, hwif->name);
-	printk(KERN_INFO "%s: changing from DMA to PIO mode", hwif->name);
+	pr_info("%s: changing from DMA to PIO mode\n", hwif->name);
 
 dma_pci_alloc_failure:
 	release_mem_region(dma_base, num_ports);
@@ -596,8 +596,8 @@ pci_init_sgiioc4(struct pci_dev *dev)
 {
 	int ret;
 
-	printk(KERN_INFO "%s: IDE controller at PCI slot %s, revision %d\n",
-			 DRV_NAME, pci_name(dev), dev->revision);
+	pr_info("%s: IDE controller at PCI slot %s, revision %d\n",
+		DRV_NAME, pci_name(dev), dev->revision);
 
 	if (dev->revision < IOC4_SUPPORTED_FIRMWARE_REV) {
 		printk(KERN_ERR "Skipping %s IDE controller in slot %s: "
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index e4973cd..0de1b10 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -541,7 +541,7 @@ static int init_chipset_siimage(struct pci_dev *dev)
 			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
 
 		tmp >>= 4;
-		printk(KERN_INFO DRV_NAME " %s: BASE CLOCK %s\n",
+		pr_info(DRV_NAME " %s: BASE CLOCK %s\n",
 			pci_name(dev), clk_str[tmp & 3]);
 	}
 
@@ -624,8 +624,8 @@ static int is_dev_seagate_sata(ide_drive_t *drive)
 	if ((len > 4) && (!memcmp(s, "ST", 2)))
 		if ((!memcmp(s + len - 2, "AS", 2)) ||
 		    (!memcmp(s + len - 3, "ASL", 3))) {
-			printk(KERN_INFO "%s: applying pessimistic Seagate "
-					 "errata fix\n", drive->name);
+			pr_info("%s: applying pessimistic Seagate errata fix\n",
+				drive->name);
 			return 1;
 		}
 
@@ -762,7 +762,7 @@ static int __devinit siimage_init_one(struct pci_dev *dev,
 		static int first = 1;
 
 		if (first) {
-			printk(KERN_INFO DRV_NAME ": For full SATA support you "
+			pr_info(DRV_NAME ": For full SATA support you "
 				"should use the libata sata_sil module.\n");
 			first = 0;
 		}
diff --git a/drivers/ide/sis5513.c b/drivers/ide/sis5513.c
index afca22b..a663253 100644
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -381,7 +381,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 		}
 		pci_dev_put(host);
 
-		printk(KERN_INFO DRV_NAME " %s: %s %s controller\n",
+		pr_info(DRV_NAME " %s: %s %s controller\n",
 			pci_name(dev), SiSHostChipInfo[i].name,
 			chipset_capability[chipset_family]);
 	}
@@ -398,7 +398,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 			pci_write_config_dword(dev, 0x54, idemisc);
 
 			if (trueid == 0x5518) {
-				printk(KERN_INFO DRV_NAME " %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
+				pr_info(DRV_NAME " %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
 					pci_name(dev));
 				chipset_family = ATA_133;
 
@@ -408,7 +408,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 				 */
 				if ((idemisc & 0x40000000) == 0) {
 					pci_write_config_dword(dev, 0x54, idemisc | 0x40000000);
-					printk(KERN_INFO DRV_NAME " %s: Switching to 5513 register mapping\n",
+					pr_info(DRV_NAME " %s: Switching to 5513 register mapping\n",
 						pci_name(dev));
 				}
 			}
@@ -433,11 +433,11 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 				pci_dev_put(lpc_bridge);
 
 				if (lpc_bridge->revision == 0x10 && (prefctl & 0x80)) {
-					printk(KERN_INFO DRV_NAME " %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
+					pr_info(DRV_NAME " %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
 						pci_name(dev));
 					chipset_family = ATA_133a;
 				} else {
-					printk(KERN_INFO DRV_NAME " %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
+					pr_info(DRV_NAME " %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
 						pci_name(dev));
 					chipset_family = ATA_100;
 				}
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index 21df560..baa2ede 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -326,8 +326,8 @@ static int __devinit sl82c105_init_one(struct pci_dev *dev, const struct pci_dev
 		 * Never ever EVER under any circumstances enable
 		 * DMA when the bridge is this old.
 		 */
-		printk(KERN_INFO DRV_NAME ": Winbond W83C553 bridge "
-				 "revision %d, BM-DMA disabled\n", rev);
+		pr_info(DRV_NAME ": Winbond W83C553 bridge revision %d, BM-DMA disabled\n",
+			rev);
 		d.dma_ops = NULL;
 		d.mwdma_mask = 0;
 		d.host_flags &= ~IDE_HFLAG_SERIALIZE_DMA;
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index 4b42ca0..8f710e8 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -239,17 +239,17 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	u8 reg = 0;
 
 	if ((dev->class & 5) && cfg_base)
-		printk(KERN_INFO DRV_NAME " %s: chip", pci_name(dev));
+		pr_info(DRV_NAME " %s: chip", pci_name(dev));
 	else {
 		cfg_base = 0x3df0;
-		printk(KERN_INFO DRV_NAME " %s: using default", pci_name(dev));
+		pr_info(DRV_NAME " %s: using default", pci_name(dev));
 	}
 	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
 	hwif->dma_base = (cfg_base + 4) ^ (hwif->channel ? 0x80 : 0);
 
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-	       hwif->name, hwif->dma_base, hwif->dma_base + 3);
+	pr_info("    %s: BM-DMA at 0x%04lx-0x%04lx\n",
+		hwif->name, hwif->dma_base, hwif->dma_base + 3);
 
 	if (ide_allocate_dma_engine(hwif))
 		return;
@@ -292,7 +292,7 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 			hwif->io_ports.ctl_addr = compat + 2;
 			outw(compat | 1, hwif->config_data);
 			new = inw(hwif->config_data);
-			printk(KERN_INFO "%s: control basereg workaround: "
+			pr_info("%s: control basereg workaround: "
 				"old=0x%04x, new=0x%04x\n",
 				hwif->name, old, new & ~1);
 		}
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 3ff7231..9133575 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -410,7 +410,7 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	/*
 	 * Print the boot message.
 	 */
-	printk(KERN_INFO DRV_NAME " %s: VIA %s (rev %02x) IDE %sDMA%s\n",
+	pr_info(DRV_NAME " %s: VIA %s (rev %02x) IDE %sDMA%s\n",
 		pci_name(dev), via_config->name, isa->revision,
 		via_config->udma_mask ? "U" : "MW",
 		via_dma[via_config->udma_mask ?
-- 
1.6.3.1.10.g659a0.dirty

