Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbZEMUtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbZEMUtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbZEMUsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:48:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:38799 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761577AbZEMUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rVJ72RUDoP0HlRMroNky48hdN9NRN/n1yKAjs4qlngD9lOuaazsXNRyLpxhVUy8Ne7
         GhW85+jZd0cg9czABXhC2MFHXmIdheqhlONbzmltN3ipfJyJ22cLy3Azus/yC6Q3JeDc
         K2hZCt3D9LSgWvyvmkC+aYhZNNcsSx1ONu730=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:52:31 +0200
Message-Id: <20090513205231.28638.12447.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/7] ide: remove hw_regs_t typedef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hw_regs_t typedef and rename struct hw_regs_s to struct ide_hw.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/at91_ide.c     |    2 +-
 drivers/ide/au1xxx-ide.c   |    4 ++--
 drivers/ide/buddha.c       |    4 ++--
 drivers/ide/cmd640.c       |    2 +-
 drivers/ide/cs5520.c       |    2 +-
 drivers/ide/delkin_cb.c    |    2 +-
 drivers/ide/falconide.c    |    4 ++--
 drivers/ide/gayle.c        |    4 ++--
 drivers/ide/icside.c       |    6 +++---
 drivers/ide/ide-4drives.c  |    2 +-
 drivers/ide/ide-cs.c       |    2 +-
 drivers/ide/ide-generic.c  |    2 +-
 drivers/ide/ide-h8300.c    |    6 +++---
 drivers/ide/ide-legacy.c   |    4 ++--
 drivers/ide/ide-pnp.c      |    2 +-
 drivers/ide/ide-probe.c    |   10 +++++-----
 drivers/ide/ide_platform.c |    4 ++--
 drivers/ide/macide.c       |    4 ++--
 drivers/ide/palm_bk3710.c  |    2 +-
 drivers/ide/pmac.c         |   11 ++++++-----
 drivers/ide/q40ide.c       |    6 +++---
 drivers/ide/rapide.c       |    4 ++--
 drivers/ide/scc_pata.c     |    2 +-
 drivers/ide/setup-pci.c    |   16 ++++++++--------
 drivers/ide/sgiioc4.c      |    4 ++--
 drivers/ide/tx4938ide.c    |    2 +-
 drivers/ide/tx4939ide.c    |    2 +-
 include/linux/ide.h        |   14 +++++++-------
 28 files changed, 65 insertions(+), 64 deletions(-)

Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -247,7 +247,7 @@ irqreturn_t at91_irq_handler(int irq, vo
 static int __init at91_ide_probe(struct platform_device *pdev)
 {
 	int ret;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	unsigned long tf_base = 0, ctl_base = 0;
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -449,7 +449,7 @@ static int auide_ddma_init(ide_hwif_t *h
 }
 #endif
 
-static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
+static void auide_setup_ports(struct ide_hw *hw, _auide_hwif *ahwif)
 {
 	int i;
 	unsigned long *ata_regs = hw->io_ports_array;
@@ -508,7 +508,7 @@ static int au_ide_probe(struct platform_
 	struct resource *res;
 	struct ide_host *host;
 	int ret = 0;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -121,7 +121,7 @@ static int xsurf_ack_intr(ide_hwif_t *hw
     return 1;
 }
 
-static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init buddha_setup_ports(struct ide_hw *hw, unsigned long base,
 				      unsigned long ctl, unsigned long irq_port,
 				      ide_ack_intr_t *ack_intr)
 {
@@ -160,7 +160,7 @@ static int __init buddha_init(void)
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
-		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL };
+		struct ide_hw hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL };
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -708,7 +708,7 @@ static int __init cmd640x_init(void)
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
-	hw_regs_t hw[2], *hws[] = { NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -110,7 +110,7 @@ static const struct ide_port_info cyrix_
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &cyrix_chipset;
-	hw_regs_t hw[2], *hws[] = { NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
 
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -77,7 +77,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	struct ide_host *host;
 	unsigned long base;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -114,7 +114,7 @@ static const struct ide_port_info falcon
 	.chipset		= ide_generic,
 };
 
-static void __init falconide_setup_ports(hw_regs_t *hw)
+static void __init falconide_setup_ports(struct ide_hw *hw)
 {
 	int i;
 
@@ -138,7 +138,7 @@ static void __init falconide_setup_ports
 static int __init falconide_init(void)
 {
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	int rc;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -88,7 +88,7 @@ static int gayle_ack_intr_a1200(ide_hwif
     return 1;
 }
 
-static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init gayle_setup_ports(struct ide_hw *hw, unsigned long base,
 				     unsigned long ctl, unsigned long irq_port,
 				     ide_ack_intr_t *ack_intr)
 {
@@ -125,7 +125,7 @@ static int __init gayle_init(void)
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
     int a4000, i, rc;
-    hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL };
+    struct ide_hw hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL };
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -381,7 +381,7 @@ static int icside_dma_off_init(ide_hwif_
 	return -EOPNOTSUPP;
 }
 
-static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
+static void icside_setup_ports(struct ide_hw *hw, void __iomem *base,
 			       struct cardinfo *info, struct expansion_card *ec)
 {
 	unsigned long port = (unsigned long)base + info->dataoffset;
@@ -410,7 +410,7 @@ icside_register_v5(struct icside_state *
 {
 	void __iomem *base;
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	int ret;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
@@ -467,7 +467,7 @@ icside_register_v6(struct icside_state *
 	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
-	hw_regs_t hw[2], *hws[] = { &hw[0], NULL };
+	struct ide_hw hw[2], *hws[] = { &hw[0], NULL };
 	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
Index: b/drivers/ide/ide-4drives.c
===================================================================
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -31,7 +31,7 @@ static const struct ide_port_info ide_4d
 static int __init ide_4drives_init(void)
 {
 	unsigned long base = 0x1f0, ctl = 0x3f6;
-	hw_regs_t hw, *hws[] = { &hw, &hw };
+	struct ide_hw hw, *hws[] = { &hw, &hw };
 
 	if (probe_4drives == 0)
 		return -ENODEV;
Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -164,7 +164,7 @@ static struct ide_host *idecs_register(u
     struct ide_host *host;
     ide_hwif_t *hwif;
     int i, rc;
-    hw_regs_t hw, *hws[] = { &hw };
+    struct ide_hw hw, *hws[] = { &hw };
 
     if (!request_region(io, 8, DRV_NAME)) {
 	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -86,7 +86,7 @@ static void ide_generic_check_pci_legacy
 
 static int __init ide_generic_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	unsigned long io_addr;
 	int i, rc = 0, primary = 0, secondary = 0;
 
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -64,11 +64,11 @@ static const struct ide_tp_ops h8300_tp_
 
 #define H8300_IDE_GAP (2)
 
-static inline void hw_setup(hw_regs_t *hw)
+static inline void hw_setup(struct ide_hw *hw)
 {
 	int i;
 
-	memset(hw, 0, sizeof(hw_regs_t));
+	memset(hw, 0, sizeof(*hw));
 	for (i = 0; i <= 7; i++)
 		hw->io_ports_array[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
 	hw->io_ports.ctl_addr = CONFIG_H8300_IDE_ALT;
@@ -83,7 +83,7 @@ static const struct ide_port_info h8300_
 
 static int __init h8300_ide_init(void)
 {
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
 
Index: b/drivers/ide/ide-legacy.c
===================================================================
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -1,7 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 
-static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
+static void ide_legacy_init_one(struct ide_hw **hws, struct ide_hw *hw,
 				u8 port_no, const struct ide_port_info *d,
 				unsigned long config)
 {
@@ -40,7 +40,7 @@ static void ide_legacy_init_one(hw_regs_
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	hw_regs_t hw[2], *hws[] = { NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -37,7 +37,7 @@ static int idepnp_probe(struct pnp_dev *
 	struct ide_host *host;
 	unsigned long base, ctl;
 	int rc;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1164,7 +1164,7 @@ static void ide_init_port_data(ide_hwif_
 	ide_port_init_devices_data(hwif);
 }
 
-static void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
+static void ide_init_port_hw(ide_hwif_t *hwif, struct ide_hw *hw)
 {
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
@@ -1252,8 +1252,8 @@ out_nomem:
 	return -ENOMEM;
 }
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws,
-				unsigned int n_ports)
+struct ide_host *ide_host_alloc(const struct ide_port_info *d,
+				struct ide_hw **hws, unsigned int n_ports)
 {
 	struct ide_host *host;
 	struct device *dev = hws[0] ? hws[0]->dev : NULL;
@@ -1340,7 +1340,7 @@ static void ide_disable_port(ide_hwif_t 
 }
 
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
-		      hw_regs_t **hws)
+		      struct ide_hw **hws)
 {
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
@@ -1434,7 +1434,7 @@ int ide_host_register(struct ide_host *h
 }
 EXPORT_SYMBOL_GPL(ide_host_register);
 
-int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
+int ide_host_add(const struct ide_port_info *d, struct ide_hw **hws,
 		 unsigned int n_ports, struct ide_host **hostp)
 {
 	struct ide_host *host;
Index: b/drivers/ide/ide_platform.c
===================================================================
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-static void __devinit plat_ide_setup_ports(hw_regs_t *hw,
+static void __devinit plat_ide_setup_ports(struct ide_hw *hw,
 					   void __iomem *base,
 					   void __iomem *ctrl,
 					   struct pata_platform_info *pdata,
@@ -54,7 +54,7 @@ static int __devinit plat_ide_probe(stru
 	struct pata_platform_info *pdata;
 	struct ide_host *host;
 	int ret = 0, mmio = 0;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -62,7 +62,7 @@ int macide_ack_intr(ide_hwif_t* hwif)
 	return 0;
 }
 
-static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
+static void __init macide_setup_ports(struct ide_hw *hw, unsigned long base,
 				      int irq, ide_ack_intr_t *ack_intr)
 {
 	int i;
@@ -96,7 +96,7 @@ static int __init macide_init(void)
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -316,7 +316,7 @@ static int __init palm_bk3710_probe(stru
 	void __iomem *base;
 	unsigned long rate, mem_size;
 	int i, rc;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	clk = clk_get(&pdev->dev, "IDECLK");
 	if (IS_ERR(clk))
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1023,13 +1023,14 @@ static const struct ide_port_info pmac_p
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI).
  */
-static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
+static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif,
+					   struct ide_hw *hw)
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
 	struct ide_host *host;
 	ide_hwif_t *hwif;
-	hw_regs_t *hws[] = { hw };
+	struct ide_hw *hws[] = { hw };
 	struct ide_port_info d = pmac_port_info;
 	int rc;
 
@@ -1124,7 +1125,7 @@ static int __devinit pmac_ide_setup_devi
 	return 0;
 }
 
-static void __devinit pmac_ide_init_ports(hw_regs_t *hw, unsigned long base)
+static void __devinit pmac_ide_init_ports(struct ide_hw *hw, unsigned long base)
 {
 	int i;
 
@@ -1144,7 +1145,7 @@ pmac_ide_macio_attach(struct macio_dev *
 	unsigned long regbase;
 	pmac_ide_hwif_t *pmif;
 	int irq, rc;
-	hw_regs_t hw;
+	struct ide_hw hw;
 
 	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
 	if (pmif == NULL)
@@ -1268,7 +1269,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 	void __iomem *base;
 	unsigned long rbase, rlen;
 	int rc;
-	hw_regs_t hw;
+	struct ide_hw hw;
 
 	np = pci_device_to_OF_node(pdev);
 	if (np == NULL) {
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -51,11 +51,11 @@ static int q40ide_default_irq(unsigned l
 /*
  * Addresses are pretranslated for Q40 ISA access.
  */
-static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
+static void q40_ide_setup_ports(struct ide_hw *hw, unsigned long base,
 			ide_ack_intr_t *ack_intr,
 			int irq)
 {
-	memset(hw, 0, sizeof(hw_regs_t));
+	memset(hw, 0, sizeof(*hw));
 	/* BIG FAT WARNING: 
 	   assumption: only DATA port is ever used in 16 bit mode */
 	hw->io_ports.data_addr = Q40_ISA_IO_W(base);
@@ -135,7 +135,7 @@ static const char *q40_ide_names[Q40IDE_
 static int __init q40ide_init(void)
 {
     int i;
-    hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL };
+    struct ide_hw hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL };
 
     if (!MACH_IS_Q40)
       return -ENODEV;
Index: b/drivers/ide/rapide.c
===================================================================
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -16,7 +16,7 @@ static const struct ide_port_info rapide
 	.chipset		= ide_generic,
 };
 
-static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
+static void rapide_setup_ports(struct ide_hw *hw, void __iomem *base,
 			       void __iomem *ctrl, unsigned int sz, int irq)
 {
 	unsigned long port = (unsigned long)base;
@@ -36,7 +36,7 @@ rapide_probe(struct expansion_card *ec, 
 	void __iomem *base;
 	struct ide_host *host;
 	int ret;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -559,7 +559,7 @@ static int scc_ide_setup_pci_device(stru
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	int i, rc;
 
 	memset(&hw, 0, sizeof(hw));
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -301,11 +301,11 @@ static int ide_pci_check_iomem(struct pc
 }
 
 /**
- *	ide_hw_configure	-	configure a hw_regs_t instance
+ *	ide_hw_configure	-	configure a struct ide_hw instance
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
- *	@hw: hw_regs_t instance corresponding to this port
+ *	@hw: struct ide_hw instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
@@ -315,7 +315,7 @@ static int ide_pci_check_iomem(struct pc
  */
 
 static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
-			    unsigned int port, hw_regs_t *hw)
+			    unsigned int port, struct ide_hw *hw)
 {
 	unsigned long ctl = 0, base = 0;
 
@@ -445,8 +445,8 @@ out:
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
  *	@d: IDE port info
- *	@hw: hw_regs_t instances corresponding to this PCI IDE device
- *	@hws: hw_regs_t pointers table to update
+ *	@hw: struct ide_hw instances corresponding to this PCI IDE device
+ *	@hws: struct ide_hw pointers table to update
  *
  *	Scan the interfaces attached to this device and do any
  *	necessary per port setup. Attach the devices and ask the
@@ -458,7 +458,7 @@ out:
  */
 
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
-			 hw_regs_t *hw, hw_regs_t **hws)
+			 struct ide_hw *hw, struct ide_hw **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	u8 tmp;
@@ -538,7 +538,7 @@ int ide_pci_init_one(struct pci_dev *dev
 		     void *priv)
 {
 	struct ide_host *host;
-	hw_regs_t hw[2], *hws[] = { NULL, NULL };
+	struct ide_hw hw[2], *hws[] = { NULL, NULL };
 	int ret;
 
 	ret = ide_setup_pci_controller(dev, d, 1);
@@ -586,7 +586,7 @@ int ide_pci_init_two(struct pci_dev *dev
 	struct pci_dev *pdev[] = { dev1, dev2 };
 	struct ide_host *host;
 	int ret, i;
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
+	struct ide_hw hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	for (i = 0; i < 2; i++) {
 		ret = ide_setup_pci_controller(pdev[i], d, !i);
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -91,7 +91,7 @@ typedef struct {
 
 
 static void
-sgiioc4_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
+sgiioc4_init_hwif_ports(struct ide_hw *hw, unsigned long data_port,
 			unsigned long ctrl_port, unsigned long irq_port)
 {
 	unsigned long reg = data_port;
@@ -546,7 +546,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -130,7 +130,7 @@ static const struct ide_port_info tx4938
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	struct tx4938ide_platform_info *pdata = pdev->dev.platform_data;
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -537,7 +537,7 @@ static const struct ide_port_info tx4939
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
 {
-	hw_regs_t hw, *hws[] = { &hw };
+	struct ide_hw hw, *hws[] = { &hw };
 	struct ide_host *host;
 	struct resource *res;
 	int irq, ret;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -178,7 +178,7 @@ typedef u8 hwif_chipset_t;
 /*
  * Structure to hold all information about the location of this port
  */
-typedef struct hw_regs_s {
+struct ide_hw {
 	union {
 		struct ide_io_ports	io_ports;
 		unsigned long		io_ports_array[IDE_NR_PORTS];
@@ -188,9 +188,9 @@ typedef struct hw_regs_s {
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	struct device	*dev, *parent;
 	unsigned long	config;
-} hw_regs_t;
+};
 
-static inline void ide_std_init_ports(hw_regs_t *hw,
+static inline void ide_std_init_ports(struct ide_hw *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
 {
@@ -1212,7 +1212,7 @@ static inline int ide_pci_is_in_compatib
 }
 
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *,
-			 hw_regs_t *, hw_regs_t **);
+			 struct ide_hw *, struct ide_hw **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -1456,12 +1456,12 @@ void ide_undecoded_slave(ide_drive_t *);
 void ide_port_apply_params(ide_hwif_t *);
 int ide_sysfs_register_port(ide_hwif_t *);
 
-struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **,
+struct ide_host *ide_host_alloc(const struct ide_port_info *, struct ide_hw **,
 				unsigned int);
 void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
-		      hw_regs_t **);
-int ide_host_add(const struct ide_port_info *, hw_regs_t **, unsigned int,
+		      struct ide_hw **);
+int ide_host_add(const struct ide_port_info *, struct ide_hw **, unsigned int,
 		 struct ide_host **);
 void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
