Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYBPQ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYBPQ2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYBPQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:25:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:28566 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYBPQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AYw+Ix6Cb4tAQ9XlJrKpx97Fpni5aTyEIID9VvA8o9/KhvLazmE0jFkzwyAkpQzPGlAVHfduv1jX7lquWRFIfBc3RUuD55icKfxEbFr2mzfjfgQW4uPRdtqAgcCt5m7wyDDhC7TxFvVf0KEIwvIWJhmG3mbiBJuwhZr8LN7ZmL8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:40:20 +0100
Message-Id: <20080216164020.10174.9344.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/12] ide: cleanup ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer needed matching against I/O base and 'base' argument.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c        |    2 +-
 drivers/ide/arm/icside.c          |    2 +-
 drivers/ide/arm/ide_arm.c         |    2 +-
 drivers/ide/arm/palm_bk3710.c     |    2 +-
 drivers/ide/arm/rapide.c          |    2 +-
 drivers/ide/cris/ide-cris.c       |    2 +-
 drivers/ide/h8300/ide-h8300.c     |    3 +--
 drivers/ide/ide-generic.c         |    2 +-
 drivers/ide/ide-pnp.c             |    2 +-
 drivers/ide/ide.c                 |   15 +++------------
 drivers/ide/legacy/buddha.c       |    2 +-
 drivers/ide/legacy/falconide.c    |    2 +-
 drivers/ide/legacy/gayle.c        |    2 +-
 drivers/ide/legacy/ide-cs.c       |    2 +-
 drivers/ide/legacy/ide_platform.c |    2 +-
 drivers/ide/legacy/macide.c       |    2 +-
 drivers/ide/legacy/q40ide.c       |    2 +-
 drivers/ide/pci/delkin_cb.c       |    2 +-
 include/linux/ide.h               |    2 +-
 19 files changed, 21 insertions(+), 31 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -41,7 +41,7 @@ static int __init bastide_register(unsig
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out;
 
Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -400,7 +400,7 @@ icside_setup(void __iomem *base, struct 
 	unsigned long port = (unsigned long)base + info->dataoffset;
 	ide_hwif_t *hwif;
 
-	hwif = ide_find_port(port);
+	hwif = ide_find_port();
 	if (hwif) {
 		int i;
 
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -34,7 +34,7 @@ static int __init ide_arm_init(void)
 	ide_std_init_ports(&hw, IDE_ARM_IO, IDE_ARM_IO + 0x206);
 	hw.irq = IDE_ARM_IRQ;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -378,7 +378,7 @@ static int __devinit palm_bk3710_probe(s
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out;
 
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -44,7 +44,7 @@ rapide_probe(struct expansion_card *ec, 
 		goto release;
 	}
 
-	hwif = ide_find_port((unsigned long)base);
+	hwif = ide_find_port();
 	if (hwif) {
 		memset(&hw, 0, sizeof(hw));
 		rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -804,7 +804,7 @@ static int __init init_e100_ide(void)
 
 		cris_setup_ports(&hw, cris_ide_base_address(h));
 
-		hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+		hwif = ide_find_port();
 		if (hwif == NULL)
 			continue;
 		ide_init_port_data(hwif, hwif->index);
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -99,8 +99,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	/* register if */
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL) {
 		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
 		return -ENOENT;
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -33,7 +33,7 @@ static ssize_t store_add(struct class *c
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
 		return -EINVAL;
 
-	hwif = ide_find_port(base);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		return -ENOENT;
 
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -38,7 +38,7 @@ static int idepnp_probe(struct pnp_dev *
 				pnp_port_start(dev, 1));
 	hw.irq = pnp_irq(dev, 0);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -234,28 +234,19 @@ static int ide_system_bus_speed(void)
 	return pci_dev_present(pci_default) ? 33 : 50;
 }
 
-ide_hwif_t * ide_find_port(unsigned long base)
+ide_hwif_t *ide_find_port(void)
 {
 	ide_hwif_t *hwif;
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
-			goto found;
-	}
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
 		if (hwif->chipset == ide_unknown)
-			goto found;
+			return hwif;
 	}
 
-	hwif = NULL;
-found:
-	return hwif;
+	return NULL;
 }
-
 EXPORT_SYMBOL_GPL(ide_find_port);
 
 static struct resource* hwif_request_region(ide_hwif_t *hwif,
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -221,7 +221,7 @@ fail_base2:
 
 			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
 
-			hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+			hwif = ide_find_port();
 			if (hwif) {
 				u8 index = hwif->index;
 
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -76,7 +76,7 @@ static int __init falconide_init(void)
 
 	falconide_setup_ports(&hw);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -175,7 +175,7 @@ found:
 
 	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
 
-	hwif = ide_find_port(base);
+	hwif = ide_find_port();
 	if (hwif) {
 	    u8 index = hwif->index;
 
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -156,7 +156,7 @@ static int idecs_register(unsigned long 
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    hwif = ide_find_port();
     if (hwif == NULL)
 	return -1;
 
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -89,7 +89,7 @@ static int __devinit plat_ide_probe(stru
 			res_alt->start, res_alt->end - res_alt->start + 1);
 	}
 
-	hwif = ide_find_port((unsigned long)base);
+	hwif = ide_find_port();
 	if (!hwif) {
 		ret = -ENODEV;
 		goto out;
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -120,7 +120,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -137,7 +137,7 @@ static int __init q40ide_init(void)
 //			m68kide_iops,
 			q40ide_default_irq(pcide_bases[i]));
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -78,7 +78,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port();
 	if (hwif == NULL)
 		goto out_disable;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -171,7 +171,7 @@ typedef struct hw_regs_s {
 	struct device	*dev;
 } hw_regs_t;
 
-struct hwif_s * ide_find_port(unsigned long);
+struct hwif_s *ide_find_port(void);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
