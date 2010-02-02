Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0BBR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:27:40 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52784 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0BBR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pH4AuxcKqFrqGbJxC9rLcPqC0UtlKjjeIbcnZRDV616rwe+AOJ7HM2WADVb3eehgNt
         /lZ4MS/UpJ0hahpYWGLQ7Awoo6db9DQNAjiI+6osyX6pjaTIZtd7mnPpnn1xrSQ2IMqG
         UqEoC6+2O7r2kCmCgjgwS8sTdbnSkzmmwmCUc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 18:27:16 +0100
Message-Id: <20100202172716.7599.61632.sendpatchset@localhost>
In-Reply-To: <20100202172701.7599.2028.sendpatchset@localhost>
References: <20100202172701.7599.2028.sendpatchset@localhost>
Subject: [PATCH 2/2] ide: remove hwif_chipset_t type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove hwif_chipset_t type

Fix up ICSIDE DMA hack in ide_find_dma_mode() to use driver name instead
of hwif->chipset and remove no longer needed hwif_chipset_t type & co.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ali14xx.c      |    1 -
 drivers/ide/at91_ide.c     |    1 -
 drivers/ide/au1xxx-ide.c   |    1 -
 drivers/ide/buddha.c       |    1 -
 drivers/ide/cmd640.c       |    1 -
 drivers/ide/delkin_cb.c    |    1 -
 drivers/ide/dtc2278.c      |    1 -
 drivers/ide/falconide.c    |    1 -
 drivers/ide/gayle.c        |    1 -
 drivers/ide/ht6560b.c      |    1 -
 drivers/ide/icside.c       |    2 --
 drivers/ide/ide-4drives.c  |    1 -
 drivers/ide/ide-cs.c       |    1 -
 drivers/ide/ide-dma.c      |    2 +-
 drivers/ide/ide-generic.c  |    1 -
 drivers/ide/ide-h8300.c    |    1 -
 drivers/ide/ide-pnp.c      |    1 -
 drivers/ide/ide-probe.c    |    2 --
 drivers/ide/ide_platform.c |    1 -
 drivers/ide/macide.c       |    1 -
 drivers/ide/palm_bk3710.c  |    1 -
 drivers/ide/pmac.c         |    1 -
 drivers/ide/q40ide.c       |    1 -
 drivers/ide/qd65xx.c       |    1 -
 drivers/ide/rapide.c       |    1 -
 drivers/ide/scc_pata.c     |    1 -
 drivers/ide/sgiioc4.c      |    1 -
 drivers/ide/tx4938ide.c    |    1 -
 drivers/ide/tx4939ide.c    |    1 -
 drivers/ide/umc8672.c      |    1 -
 include/linux/ide.h        |   17 -----------------
 31 files changed, 1 insertion(+), 49 deletions(-)

Index: b/drivers/ide-vlb/ali14xx.c
===================================================================
--- a/drivers/staging/ide-vlb/ali14xx.c
+++ b/drivers/staging/ide-vlb/ali14xx.c
@@ -201,7 +201,6 @@ static const struct ide_port_ops ali14xx
 
 static const struct ide_port_info ali14xx_port_info = {
 	.name			= DRV_NAME,
-	.chipset		= ide_ali14xx,
 	.port_ops		= &ali14xx_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -214,7 +214,6 @@ static const struct ide_port_info at91_i
 	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
 			  IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask 	= ATA_PIO6,
-	.chipset	= ide_generic,
 };
 
 /*
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -498,7 +498,6 @@ static const struct ide_port_info au1xxx
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	.mwdma_mask		= ATA_MWDMA2,
 #endif
-	.chipset		= ide_au1xxx,
 };
 
 static int au_ide_probe(struct platform_device *dev)
Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -148,7 +148,6 @@ static const struct ide_port_info buddha
 	.port_ops		= &buddha_port_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_generic,
 };
 
     /*
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -687,7 +687,6 @@ static int pci_conf2(void)
 }
 
 static const struct ide_port_info cmd640_port_info __initdata = {
-	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_ABUSE_PREFETCH |
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -68,7 +68,6 @@ static const struct ide_port_info delkin
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
 	.init_chipset		= delkin_cb_init_chipset,
-	.chipset		= ide_pci,
 };
 
 static int __devinit
Index: b/drivers/staging/ide-vlb/dtc2278.c
===================================================================
--- a/drivers/staging/ide-vlb/dtc2278.c
+++ b/drivers/staging/ide-vlb/dtc2278.c
@@ -93,7 +93,6 @@ static const struct ide_port_ops dtc2278
 
 static const struct ide_port_info dtc2278_port_info __initdata = {
 	.name			= DRV_NAME,
-	.chipset		= ide_dtc2278,
 	.port_ops		= &dtc2278_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_UNMASK_IRQS |
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -111,7 +111,6 @@ static const struct ide_port_info falcon
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_generic,
 };
 
 static void __init falconide_setup_ports(struct ide_hw *hw)
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -115,7 +115,6 @@ static const struct ide_port_info gayle_
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_generic,
 };
 
     /*
Index: b/drivers/staging/ide-vlb/ht6560b.c
===================================================================
--- a/drivers/staging/ide-vlb/ht6560b.c
+++ b/drivers/staging/ide-vlb/ht6560b.c
@@ -345,7 +345,6 @@ static const struct ide_port_ops ht6560b
 
 static const struct ide_port_info ht6560b_port_info __initdata = {
 	.name			= DRV_NAME,
-	.chipset		= ide_ht6560b,
 	.tp_ops 		= &ht6560b_tp_ops,
 	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -405,7 +405,6 @@ static void icside_setup_ports(struct id
 
 static const struct ide_port_info icside_v5_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
-	.chipset		= ide_acorn,
 };
 
 static int __devinit
@@ -460,7 +459,6 @@ static const struct ide_port_info icside
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
-	.chipset		= ide_acorn,
 };
 
 static int __devinit
Index: b/drivers/staging/ide-vlb/ide-4drives.c
===================================================================
--- a/drivers/staging/ide-vlb/ide-4drives.c
+++ b/drivers/staging/ide-vlb/ide-4drives.c
@@ -25,7 +25,6 @@ static const struct ide_port_info ide_4d
 	.port_ops		= &ide_4drives_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_4DRIVES,
-	.chipset		= ide_4drives,
 };
 
 static int __init ide_4drives_init(void)
Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -147,7 +147,6 @@ static const struct ide_port_info idecs_
 	.port_ops		= &idecs_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_pci,
 };
 
 static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -331,7 +331,7 @@ u8 ide_find_dma_mode(ide_drive_t *drive,
 		}
 	}
 
-	if (hwif->chipset == ide_acorn && mode == 0) {
+	if (!strcmp(hwif->dev->driver->name, "icside") && mode == 0) {
 		/*
 		 * is this correct?
 		 */
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -29,7 +29,6 @@ MODULE_PARM_DESC(probe_mask, "probe mask
 
 static const struct ide_port_info ide_generic_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
-	.chipset		= ide_generic,
 };
 
 #ifdef CONFIG_ARM
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -78,7 +78,6 @@ static inline void hw_setup(struct ide_h
 static const struct ide_port_info h8300_port_info = {
 	.tp_ops			= &h8300_tp_ops,
 	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
-	.chipset		= ide_generic,
 };
 
 static int __init h8300_ide_init(void)
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,7 +29,6 @@ static struct pnp_device_id idepnp_devic
 
 static const struct ide_port_info ide_pnp_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
-	.chipset		= ide_generic,
 };
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1054,8 +1054,6 @@ static void ide_init_port(ide_hwif_t *hw
 {
 	hwif->channel = port;
 
-	hwif->chipset = d->chipset ? d->chipset : ide_pci;
-
 	if (d->init_iops)
 		d->init_iops(hwif);
 
Index: b/drivers/ide/ide_platform.c
===================================================================
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -44,7 +44,6 @@ static void __devinit plat_ide_setup_por
 
 static const struct ide_port_info platform_ide_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
-	.chipset		= ide_generic,
 };
 
 static int __devinit plat_ide_probe(struct platform_device *pdev)
Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -89,7 +89,6 @@ static const struct ide_port_info macide
 	.port_ops		= &macide_port_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_generic,
 };
 
 static const char *mac_ide_name[] =
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -305,7 +305,6 @@ static struct ide_port_info __devinitdat
 	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
-	.chipset		= ide_palm3710,
 };
 
 static int __init palm_bk3710_probe(struct platform_device *pdev)
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1006,7 +1006,6 @@ static const struct ide_dma_ops pmac_dma
 static const struct ide_port_info pmac_port_info = {
 	.name			= DRV_NAME,
 	.init_dma		= pmac_ide_init_dma,
-	.chipset		= ide_pmac,
 	.tp_ops			= &pmac_tp_ops,
 	.port_ops		= &pmac_ide_port_ops,
 	.dma_ops		= &pmac_dma_ops,
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -114,7 +114,6 @@ static const struct ide_port_info q40ide
 	.tp_ops			= &q40ide_tp_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
-	.chipset		= ide_generic,
 };
 
 /* 
Index: b/drivers/staging/ide-vlb/qd65xx.c
===================================================================
--- a/drivers/staging/ide-vlb/qd65xx.c
+++ b/drivers/staging/ide-vlb/qd65xx.c
@@ -339,7 +339,6 @@ static const struct ide_port_ops qd6580_
 static const struct ide_port_info qd65xx_port_info __initdata = {
 	.name			= DRV_NAME,
 	.tp_ops 		= &qd65xx_tp_ops,
-	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
 				  IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
Index: b/drivers/ide/rapide.c
===================================================================
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -13,7 +13,6 @@
 
 static const struct ide_port_info rapide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
-	.chipset		= ide_generic,
 };
 
 static void rapide_setup_ports(struct ide_hw *hw, void __iomem *base,
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -822,7 +822,6 @@ static const struct ide_port_info scc_ch
 	.host_flags	= IDE_HFLAG_SINGLE,
 	.irq_flags	= IRQF_SHARED,
 	.pio_mask	= ATA_PIO4,
-	.chipset	= ide_pci,
 };
 
 /**
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -522,7 +522,6 @@ static const struct ide_dma_ops sgiioc4_
 
 static const struct ide_port_info sgiioc4_port_info __devinitconst = {
 	.name			= DRV_NAME,
-	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
 	.tp_ops			= &sgiioc4_tp_ops,
 	.port_ops		= &sgiioc4_port_ops,
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -124,7 +124,6 @@ static const struct ide_port_info tx4938
 #endif
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO5,
-	.chipset		= ide_generic,
 };
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -532,7 +532,6 @@ static const struct ide_port_info tx4939
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
 	.udma_mask		= ATA_UDMA5,
-	.chipset		= ide_generic,
 };
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
Index: b/drivers/staging/ide-vlb/umc8672.c
===================================================================
--- a/drivers/staging/ide-vlb/umc8672.c
+++ b/drivers/staging/ide-vlb/umc8672.c
@@ -130,7 +130,6 @@ static const struct ide_port_ops umc8672
 
 static const struct ide_port_info umc8672_port_info __initdata = {
 	.name			= DRV_NAME,
-	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -157,19 +157,6 @@ enum {
 #define REQ_UNPARK_HEADS	0x23
 
 /*
- * hwif_chipset_t is used to keep track of the specific hardware
- * chipset used by each IDE interface, if known.
- */
-enum {		ide_unknown,	ide_generic,	ide_pci,
-		ide_cmd640,	ide_dtc2278,	ide_ali14xx,
-		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
-		ide_4drives,	ide_pmac,	ide_acorn,
-		ide_au1xxx,	ide_palm3710
-};
-
-typedef u8 hwif_chipset_t;
-
-/*
  * Structure to hold all information about the location of this port
  */
 struct ide_hw {
@@ -705,8 +692,6 @@ typedef struct hwif_s {
 
 	u8 cbl;		/* cable type */
 
-	hwif_chipset_t chipset;	/* sub-module for tuning.. */
-
 	struct device *dev;
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
@@ -1249,8 +1234,6 @@ struct ide_port_info {
 
 	struct ide_pci_enablebit	enablebits[2];
 
-	hwif_chipset_t		chipset;
-
 	u16			max_sectors;	/* if < than the default one */
 
 	u32			host_flags;
