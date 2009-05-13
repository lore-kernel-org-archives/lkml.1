Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbZEMUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbZEMUtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbZEMUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40473 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761484AbZEMUrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Tx9tUnMw3pzVHw0RcNmTNHLU4Vs/59U9JtsEN860mg8if6c053meBLpHLqJ2vLZOL6
         qZ19aYBK+hfG9Dblsh2zNcYDa5cgLqJLZfbUfWzPkzBQymcUuAtdySQ7rARCg2QowQC8
         p9yGbQ8NWvjanUKJMEQB22aArz3sj9/ti2F/s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:52:22 +0200
Message-Id: <20090513205222.28638.19386.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/7] ide: pass number of ports to ide_host_{alloc,add}()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass number of ports to ide_host_{alloc,add}() and then update
all users accordingly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/at91_ide.c     |    5 ++---
 drivers/ide/au1xxx-ide.c   |    4 ++--
 drivers/ide/buddha.c       |    4 ++--
 drivers/ide/cmd640.c       |    5 +++--
 drivers/ide/cs5520.c       |    4 ++--
 drivers/ide/delkin_cb.c    |    4 ++--
 drivers/ide/falconide.c    |    4 ++--
 drivers/ide/gayle.c        |    4 ++--
 drivers/ide/icside.c       |    8 ++++----
 drivers/ide/ide-4drives.c  |    4 ++--
 drivers/ide/ide-cs.c       |    4 ++--
 drivers/ide/ide-generic.c  |    4 ++--
 drivers/ide/ide-h8300.c    |    4 ++--
 drivers/ide/ide-legacy.c   |    4 ++--
 drivers/ide/ide-pnp.c      |    4 ++--
 drivers/ide/ide-probe.c    |    9 +++++----
 drivers/ide/ide_platform.c |    4 ++--
 drivers/ide/macide.c       |    4 ++--
 drivers/ide/palm_bk3710.c  |    4 ++--
 drivers/ide/pmac.c         |    4 ++--
 drivers/ide/q40ide.c       |    4 ++--
 drivers/ide/rapide.c       |    4 ++--
 drivers/ide/scc_pata.c     |    4 ++--
 drivers/ide/setup-pci.c    |    6 +++---
 drivers/ide/sgiioc4.c      |    4 ++--
 drivers/ide/tx4938ide.c    |    5 ++---
 drivers/ide/tx4939ide.c    |    5 ++---
 include/linux/ide.h        |    5 +++--
 28 files changed, 64 insertions(+), 64 deletions(-)

Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -247,8 +247,7 @@ irqreturn_t at91_irq_handler(int irq, vo
 static int __init at91_ide_probe(struct platform_device *pdev)
 {
 	int ret;
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	unsigned long tf_base = 0, ctl_base = 0;
@@ -307,7 +306,7 @@ static int __init at91_ide_probe(struct 
 	hw.irq = board->irq_pin;
 	hw.dev = &pdev->dev;
 
-	host = ide_host_alloc(&at91_ide_port_info, hws);
+	host = ide_host_alloc(&at91_ide_port_info, hws, 1);
 	if (!host) {
 		perr("failed to allocate ide host\n");
 		return -ENOMEM;
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -508,7 +508,7 @@ static int au_ide_probe(struct platform_
 	struct resource *res;
 	struct ide_host *host;
 	int ret = 0;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -550,7 +550,7 @@ static int au_ide_probe(struct platform_
 	hw.irq = ahwif->irq;
 	hw.dev = &dev->dev;
 
-	ret = ide_host_add(&au1xxx_port_info, hws, &host);
+	ret = ide_host_add(&au1xxx_port_info, hws, 1, &host);
 	if (ret)
 		goto out;
 
Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -160,7 +160,7 @@ static int __init buddha_init(void)
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
-		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL };
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
@@ -224,7 +224,7 @@ fail_base2:
 			hws[i] = &hw[i];
 		}
 
-		ide_host_add(&buddha_port_info, hws, NULL);
+		ide_host_add(&buddha_port_info, hws, i, NULL);
 	}
 
 	return 0;
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -708,7 +708,7 @@ static int __init cmd640x_init(void)
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
-	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { NULL, NULL };
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -822,7 +822,8 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	return ide_host_add(&cmd640_port_info, hws, NULL);
+	return ide_host_add(&cmd640_port_info, hws, second_port_cmd640 ? 2 : 1,
+			    NULL);
 }
 
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -110,7 +110,7 @@ static const struct ide_port_info cyrix_
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &cyrix_chipset;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
 
@@ -136,7 +136,7 @@ static int __devinit cs5520_init_one(str
 	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 	hw[0].irq = 14;
 
-	return ide_host_add(d, hws, NULL);
+	return ide_host_add(d, hws, 2, NULL);
 }
 
 static const struct pci_device_id cs5520_pci_tbl[] = {
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -77,7 +77,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	struct ide_host *host;
 	unsigned long base;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -99,7 +99,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 
-	rc = ide_host_add(&delkin_cb_port_info, hws, &host);
+	rc = ide_host_add(&delkin_cb_port_info, hws, 1, &host);
 	if (rc)
 		goto out_disable;
 
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -138,7 +138,7 @@ static void __init falconide_setup_ports
 static int __init falconide_init(void)
 {
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	int rc;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
@@ -153,7 +153,7 @@ static int __init falconide_init(void)
 
 	falconide_setup_ports(&hw);
 
-	host = ide_host_alloc(&falconide_port_info, hws);
+	host = ide_host_alloc(&falconide_port_info, hws, 1);
 	if (host == NULL) {
 		rc = -ENOMEM;
 		goto err;
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -125,7 +125,7 @@ static int __init gayle_init(void)
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
     int a4000, i, rc;
-    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL };
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
@@ -170,7 +170,7 @@ found:
 	hws[i] = &hw[i];
     }
 
-    rc = ide_host_add(&gayle_port_info, hws, NULL);
+    rc = ide_host_add(&gayle_port_info, hws, i, NULL);
     if (rc)
 	release_mem_region(res_start, res_n);
 
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -410,7 +410,7 @@ icside_register_v5(struct icside_state *
 {
 	void __iomem *base;
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	int ret;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
@@ -431,7 +431,7 @@ icside_register_v5(struct icside_state *
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	host = ide_host_alloc(&icside_v5_port_info, hws);
+	host = ide_host_alloc(&icside_v5_port_info, hws, 1);
 	if (host == NULL)
 		return -ENODEV;
 
@@ -467,7 +467,7 @@ icside_register_v6(struct icside_state *
 	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
-	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { &hw[0], NULL };
 	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
@@ -507,7 +507,7 @@ icside_register_v6(struct icside_state *
 	icside_setup_ports(&hw[0], easi_base, &icside_cardinfo_v6_1, ec);
 	icside_setup_ports(&hw[1], easi_base, &icside_cardinfo_v6_2, ec);
 
-	host = ide_host_alloc(&d, hws);
+	host = ide_host_alloc(&d, hws, 2);
 	if (host == NULL)
 		return -ENODEV;
 
Index: b/drivers/ide/ide-4drives.c
===================================================================
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -31,7 +31,7 @@ static const struct ide_port_info ide_4d
 static int __init ide_4drives_init(void)
 {
 	unsigned long base = 0x1f0, ctl = 0x3f6;
-	hw_regs_t hw, *hws[] = { &hw, &hw, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw, &hw };
 
 	if (probe_4drives == 0)
 		return -ENODEV;
@@ -54,7 +54,7 @@ static int __init ide_4drives_init(void)
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = 14;
 
-	return ide_host_add(&ide_4drives_port_info, hws, NULL);
+	return ide_host_add(&ide_4drives_port_info, hws, 2, NULL);
 }
 
 module_init(ide_4drives_init);
Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -164,7 +164,7 @@ static struct ide_host *idecs_register(u
     struct ide_host *host;
     ide_hwif_t *hwif;
     int i, rc;
-    hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+    hw_regs_t hw, *hws[] = { &hw };
 
     if (!request_region(io, 8, DRV_NAME)) {
 	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -184,7 +184,7 @@ static struct ide_host *idecs_register(u
     hw.irq = irq;
     hw.dev = &handle->dev;
 
-    rc = ide_host_add(&idecs_port_info, hws, &host);
+    rc = ide_host_add(&idecs_port_info, hws, 1, &host);
     if (rc)
 	goto out_release;
 
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -86,7 +86,7 @@ static void ide_generic_check_pci_legacy
 
 static int __init ide_generic_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	unsigned long io_addr;
 	int i, rc = 0, primary = 0, secondary = 0;
 
@@ -133,7 +133,7 @@ static int __init ide_generic_init(void)
 #else
 			hw.irq = legacy_irqs[i];
 #endif
-			rc = ide_host_add(&ide_generic_port_info, hws, NULL);
+			rc = ide_host_add(&ide_generic_port_info, hws, 1, NULL);
 			if (rc) {
 				release_region(io_addr + 0x206, 1);
 				release_region(io_addr, 8);
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -83,7 +83,7 @@ static const struct ide_port_info h8300_
 
 static int __init h8300_ide_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
 
@@ -96,7 +96,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	return ide_host_add(&h8300_port_info, hws, NULL);
+	return ide_host_add(&h8300_port_info, hws, 1, NULL);
 
 out_busy:
 	printk(KERN_ERR "ide-h8300: IDE I/F resource already used.\n");
Index: b/drivers/ide/ide-legacy.c
===================================================================
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -40,7 +40,7 @@ static void ide_legacy_init_one(hw_regs_
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
@@ -52,6 +52,6 @@ int ide_legacy_device_add(const struct i
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	return ide_host_add(d, hws, NULL);
+	return ide_host_add(d, hws, 2, NULL);
 }
 EXPORT_SYMBOL_GPL(ide_legacy_device_add);
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -37,7 +37,7 @@ static int idepnp_probe(struct pnp_dev *
 	struct ide_host *host;
 	unsigned long base, ctl;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
 
@@ -64,7 +64,7 @@ static int idepnp_probe(struct pnp_dev *
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
 
-	rc = ide_host_add(&ide_pnp_port_info, hws, &host);
+	rc = ide_host_add(&ide_pnp_port_info, hws, 1, &host);
 	if (rc)
 		goto out;
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1252,7 +1252,8 @@ out_nomem:
 	return -ENOMEM;
 }
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
+struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws,
+				unsigned int n_ports)
 {
 	struct ide_host *host;
 	struct device *dev = hws[0] ? hws[0]->dev : NULL;
@@ -1263,7 +1264,7 @@ struct ide_host *ide_host_alloc(const st
 	if (host == NULL)
 		return NULL;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
+	for (i = 0; i < n_ports; i++) {
 		ide_hwif_t *hwif;
 		int idx;
 
@@ -1434,12 +1435,12 @@ int ide_host_register(struct ide_host *h
 EXPORT_SYMBOL_GPL(ide_host_register);
 
 int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
-		 struct ide_host **hostp)
+		 unsigned int n_ports, struct ide_host **hostp)
 {
 	struct ide_host *host;
 	int rc;
 
-	host = ide_host_alloc(d, hws);
+	host = ide_host_alloc(d, hws, n_ports);
 	if (host == NULL)
 		return -ENOMEM;
 
Index: b/drivers/ide/ide_platform.c
===================================================================
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -54,7 +54,7 @@ static int __devinit plat_ide_probe(stru
 	struct pata_platform_info *pdata;
 	struct ide_host *host;
 	int ret = 0, mmio = 0;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
@@ -98,7 +98,7 @@ static int __devinit plat_ide_probe(stru
 	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
 
-	ret = ide_host_add(&d, hws, &host);
+	ret = ide_host_add(&d, hws, 1, &host);
 	if (ret)
 		goto out;
 
Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -96,7 +96,7 @@ static int __init macide_init(void)
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
@@ -126,7 +126,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	return ide_host_add(&macide_port_info, hws, NULL);
+	return ide_host_add(&macide_port_info, hws, 1, NULL);
 }
 
 module_init(macide_init);
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -316,7 +316,7 @@ static int __init palm_bk3710_probe(stru
 	void __iomem *base;
 	unsigned long rate, mem_size;
 	int i, rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	clk = clk_get(&pdev->dev, "IDECLK");
 	if (IS_ERR(clk))
@@ -369,7 +369,7 @@ static int __init palm_bk3710_probe(stru
 							     ATA_UDMA5;
 
 	/* Register the IDE interface with Linux */
-	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
+	rc = ide_host_add(&palm_bk3710_port_info, hws, 1, NULL);
 	if (rc)
 		goto out;
 
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1029,7 +1029,7 @@ static int __devinit pmac_ide_setup_devi
 	const int *bidp;
 	struct ide_host *host;
 	ide_hwif_t *hwif;
-	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
+	hw_regs_t *hws[] = { hw };
 	struct ide_port_info d = pmac_port_info;
 	int rc;
 
@@ -1077,7 +1077,7 @@ static int __devinit pmac_ide_setup_devi
 	/* Make sure we have sane timings */
 	sanitize_timings(pmif);
 
-	host = ide_host_alloc(&d, hws);
+	host = ide_host_alloc(&d, hws, 1);
 	if (host == NULL)
 		return -ENOMEM;
 	hwif = host->ports[0];
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -135,7 +135,7 @@ static const char *q40_ide_names[Q40IDE_
 static int __init q40ide_init(void)
 {
     int i;
-    hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
+    hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL };
 
     if (!MACH_IS_Q40)
       return -ENODEV;
@@ -162,7 +162,7 @@ static int __init q40ide_init(void)
 	hws[i] = &hw[i];
     }
 
-    return ide_host_add(&q40ide_port_info, hws, NULL);
+    return ide_host_add(&q40ide_port_info, hws, Q40IDE_NUM_HWIFS, NULL);
 }
 
 module_init(q40ide_init);
Index: b/drivers/ide/rapide.c
===================================================================
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -36,7 +36,7 @@ rapide_probe(struct expansion_card *ec, 
 	void __iomem *base;
 	struct ide_host *host;
 	int ret;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -52,7 +52,7 @@ rapide_probe(struct expansion_card *ec, 
 	rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
 	hw.dev = &ec->dev;
 
-	ret = ide_host_add(&rapide_port_info, hws, &host);
+	ret = ide_host_add(&rapide_port_info, hws, 1, &host);
 	if (ret)
 		goto release;
 
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -559,7 +559,7 @@ static int scc_ide_setup_pci_device(stru
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	int i, rc;
 
 	memset(&hw, 0, sizeof(hw));
@@ -568,7 +568,7 @@ static int scc_ide_setup_pci_device(stru
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 
-	rc = ide_host_add(d, hws, &host);
+	rc = ide_host_add(d, hws, 1, &host);
 	if (rc)
 		return rc;
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -538,7 +538,7 @@ int ide_pci_init_one(struct pci_dev *dev
 		     void *priv)
 {
 	struct ide_host *host;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { NULL, NULL };
 	int ret;
 
 	ret = ide_setup_pci_controller(dev, d, 1);
@@ -547,7 +547,7 @@ int ide_pci_init_one(struct pci_dev *dev
 
 	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 
-	host = ide_host_alloc(d, hws);
+	host = ide_host_alloc(d, hws, 2);
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -596,7 +596,7 @@ int ide_pci_init_two(struct pci_dev *dev
 		ide_pci_setup_ports(pdev[i], d, &hw[i*2], &hws[i*2]);
 	}
 
-	host = ide_host_alloc(d, hws);
+	host = ide_host_alloc(d, hws, 4);
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto out;
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -546,7 +546,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
@@ -580,7 +580,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	rc = ide_host_add(&sgiioc4_port_info, hws, NULL);
+	rc = ide_host_add(&sgiioc4_port_info, hws, 1, NULL);
 	if (!rc)
 		return 0;
 
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -130,8 +130,7 @@ static const struct ide_port_info tx4938
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	struct tx4938ide_platform_info *pdata = pdev->dev.platform_data;
@@ -183,7 +182,7 @@ static int __init tx4938ide_probe(struct
 		tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, 0);
 	else
 		d.port_ops = NULL;
-	ret = ide_host_add(&d, hws, &host);
+	ret = ide_host_add(&d, hws, 1, &host);
 	if (!ret)
 		platform_set_drvdata(pdev, host);
 	return ret;
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -537,8 +537,7 @@ static const struct ide_port_info tx4939
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw;
-	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	hw_regs_t hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	int irq, ret;
@@ -581,7 +580,7 @@ static int __init tx4939ide_probe(struct
 	hw.dev = &pdev->dev;
 
 	pr_info("TX4939 IDE interface (base %#lx, irq %d)\n", mapbase, irq);
-	host = ide_host_alloc(&tx4939ide_port_info, hws);
+	host = ide_host_alloc(&tx4939ide_port_info, hws, 1);
 	if (!host)
 		return -ENOMEM;
 	/* use extra_base for base address of the all registers */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1456,11 +1456,12 @@ void ide_undecoded_slave(ide_drive_t *);
 void ide_port_apply_params(ide_hwif_t *);
 int ide_sysfs_register_port(ide_hwif_t *);
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
+struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **,
+				unsigned int);
 void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
 		      hw_regs_t **);
-int ide_host_add(const struct ide_port_info *, hw_regs_t **,
+int ide_host_add(const struct ide_port_info *, hw_regs_t **, unsigned int,
 		 struct ide_host **);
 void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
