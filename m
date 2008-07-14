Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYGMPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYGMPOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYGMPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:13:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63536 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYGMPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nXSFGsUKHVb24EUjlkKC8hdHO4ydcDp0aqPfSghNJQVIjjHVLzvOxntJMn4skUWDT0
         tR38M+wvOoYTscYZCdUgVr0sheCCyTgJEf7QbuRDwK7nW0xXtkpgpE7Yw5zzsL1OzFfr
         wv89Hn1nEa61LOIythbfUGNl5w8CiYpuUdepw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2008 17:11:16 +0200
Message-Id: <20080714151116.3106.65543.sendpatchset@localhost.localdomain>
In-Reply-To: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
References: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/5] ide: prefix messages from IDE PCI host drivers by driver name
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefix messages from IDE PCI host drivers by driver name instead of marketed
chipset name (it is still possible to exactly identify the particular chipset
basing on driver messages).

As a bonus this provides nice code savings for some drivers:

   text    data     bss     dec     hex filename
   3826     112       8    3946     f6a drivers/ide/pci/amd74xx.o.before
   2786     112       8    2906     b5a drivers/ide/pci/amd74xx.o.after
    764     108       0     872     368 drivers/ide/pci/cs5520.o.before
    680     108       0     788     314 drivers/ide/pci/cs5520.o.after
   1680     112       4    1796     704 drivers/ide/pci/generic.o.before
   1155     112       4    1271     4f7 drivers/ide/pci/generic.o.after
   7128     792       0    7920    1ef0 drivers/ide/pci/hpt366.o.before
   6984     792       0    7776    1e60 drivers/ide/pci/hpt366.o.after
   2800     148       0    2948     b84 drivers/ide/pci/pdc202xx_new.o.before
   2523     148       0    2671     a6f drivers/ide/pci/pdc202xx_new.o.after
   2831     148       0    2979     ba3 drivers/ide/pci/pdc202xx_old.o.before
   2683     148       0    2831     b0f drivers/ide/pci/pdc202xx_old.o.after
   3776     112       4    3892     f34 drivers/ide/pci/piix.o.before
   2804     112       4    2920     b68 drivers/ide/pci/piix.o.after
   4693     116       0    4809    12c9 drivers/ide/pci/siimage.o.before
   4600     116       0    4716    126c drivers/ide/pci/siimage.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c      |   29 ++++++-----
 drivers/ide/pci/alim15x3.c     |    4 +
 drivers/ide/pci/amd74xx.c      |   84 +++++++++++++-------------------
 drivers/ide/pci/atiixp.c       |   11 ++--
 drivers/ide/pci/cmd64x.c       |   21 +++++---
 drivers/ide/pci/cs5520.c       |   24 +++------
 drivers/ide/pci/cs5530.c       |    4 +
 drivers/ide/pci/cs5535.c       |    4 +
 drivers/ide/pci/cy82c693.c     |    4 +
 drivers/ide/pci/generic.c      |   63 +++++++++++-------------
 drivers/ide/pci/hpt34x.c       |   10 ++-
 drivers/ide/pci/hpt366.c       |   65 ++++---------------------
 drivers/ide/pci/it8213.c       |    4 +
 drivers/ide/pci/it821x.c       |   12 ++--
 drivers/ide/pci/jmicron.c      |    4 +
 drivers/ide/pci/ns87415.c      |    4 +
 drivers/ide/pci/opti621.c      |    4 +
 drivers/ide/pci/pdc202xx_new.c |   38 ++++++--------
 drivers/ide/pci/pdc202xx_old.c |   30 ++++++-----
 drivers/ide/pci/piix.c         |  106 ++++++++++++++++++-----------------------
 drivers/ide/pci/rz1000.c       |    4 +
 drivers/ide/pci/sc1200.c       |    4 +
 drivers/ide/pci/serverworks.c  |   26 ++++++----
 drivers/ide/pci/siimage.c      |   17 +++---
 drivers/ide/pci/sis5513.c      |   14 +++--
 drivers/ide/pci/sl82c105.c     |    6 +-
 drivers/ide/pci/slc90e66.c     |    4 +
 drivers/ide/pci/tc86c001.c     |    4 -
 drivers/ide/pci/triflex.c      |    4 +
 drivers/ide/pci/trm290.c       |    8 +--
 drivers/ide/pci/via82cxxx.c    |   15 +++--
 31 files changed, 306 insertions(+), 325 deletions(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -13,6 +13,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "aec62xx"
+
 struct chipset_bus_clock_list_entry {
 	u8 xfer_speed;
 	u8 chipset_settings;
@@ -180,8 +182,8 @@ static const struct ide_port_ops atp86x_
 };
 
 static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "AEC6210",
+	{	/* 0: AEC6210 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp850_port_ops,
@@ -192,8 +194,9 @@ static const struct ide_port_info aec62x
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
-	},{	/* 1 */
-		.name		= "AEC6260",
+	},
+	{	/* 1: AEC6260 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
@@ -201,8 +204,9 @@ static const struct ide_port_info aec62x
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 2 */
-		.name		= "AEC6260R",
+	},
+	{	/* 2: AEC6260R */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
@@ -211,8 +215,9 @@ static const struct ide_port_info aec62x
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 3 */
-		.name		= "AEC6280",
+	},
+	{	/* 3: AEC6280 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
@@ -220,8 +225,9 @@ static const struct ide_port_info aec62x
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 4 */
-		.name		= "AEC6280R",
+	},
+	{	/* 4: AEC6280R */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
@@ -268,7 +274,8 @@ static int __devinit aec62xx_init_one(st
 		unsigned long dma_base = pci_resource_start(dev, 4);
 
 		if (inb(dma_base + 2) & 0x10) {
-			d.name = (idx == 4) ? "AEC6880R" : "AEC6880";
+			printk(KERN_INFO DRV_NAME " %s: AEC6880%s card detected"
+				"\n", pci_name(dev), (idx == 4) ? "R" : "");
 			d.udma_mask = ATA_UDMA6;
 		}
 	}
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -38,6 +38,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "alim15x3"
+
 /*
  * Allow UDMA on M1543C-E chipset for WDC disks that ignore CRC checking
  * (this is DANGEROUS and could result in data corruption).
@@ -515,7 +517,7 @@ static const struct ide_dma_ops ali_dma_
 };
 
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
-	.name		= "ALI15X3",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -21,6 +21,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "amd74xx"
+
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
@@ -204,9 +206,9 @@ static const struct ide_port_ops amd_por
 	 IDE_HFLAG_IO_32BIT | \
 	 IDE_HFLAG_UNMASK_IRQS)
 
-#define DECLARE_AMD_DEV(name_str, swdma, udma)				\
+#define DECLARE_AMD_DEV(swdma, udma)				\
 	{								\
-		.name		= name_str,				\
+		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
@@ -218,9 +220,9 @@ static const struct ide_port_ops amd_por
 		.udma_mask	= udma,					\
 	}
 
-#define DECLARE_NV_DEV(name_str, udma)					\
+#define DECLARE_NV_DEV(udma)					\
 	{								\
-		.name		= name_str,				\
+		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
 		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
@@ -233,31 +235,15 @@ static const struct ide_port_ops amd_por
 	}
 
 static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
-	/*  0 */ DECLARE_AMD_DEV("AMD7401",	  0x00, ATA_UDMA2),
-	/*  1 */ DECLARE_AMD_DEV("AMD7409", ATA_SWDMA2, ATA_UDMA4),
-	/*  2 */ DECLARE_AMD_DEV("AMD7411", ATA_SWDMA2, ATA_UDMA5),
-	/*  3 */ DECLARE_AMD_DEV("AMD7441", ATA_SWDMA2, ATA_UDMA5),
-	/*  4 */ DECLARE_AMD_DEV("AMD8111", ATA_SWDMA2, ATA_UDMA6),
-
-	/*  5 */ DECLARE_NV_DEV("NFORCE",		ATA_UDMA5),
-	/*  6 */ DECLARE_NV_DEV("NFORCE2",		ATA_UDMA6),
-	/*  7 */ DECLARE_NV_DEV("NFORCE2-U400R",	ATA_UDMA6),
-	/*  8 */ DECLARE_NV_DEV("NFORCE2-U400R-SATA",	ATA_UDMA6),
-	/*  9 */ DECLARE_NV_DEV("NFORCE3-150",		ATA_UDMA6),
-	/* 10 */ DECLARE_NV_DEV("NFORCE3-250",		ATA_UDMA6),
-	/* 11 */ DECLARE_NV_DEV("NFORCE3-250-SATA",	ATA_UDMA6),
-	/* 12 */ DECLARE_NV_DEV("NFORCE3-250-SATA2",	ATA_UDMA6),
-	/* 13 */ DECLARE_NV_DEV("NFORCE-CK804",		ATA_UDMA6),
-	/* 14 */ DECLARE_NV_DEV("NFORCE-MCP04",		ATA_UDMA6),
-	/* 15 */ DECLARE_NV_DEV("NFORCE-MCP51",		ATA_UDMA6),
-	/* 16 */ DECLARE_NV_DEV("NFORCE-MCP55",		ATA_UDMA6),
-	/* 17 */ DECLARE_NV_DEV("NFORCE-MCP61",		ATA_UDMA6),
-	/* 18 */ DECLARE_NV_DEV("NFORCE-MCP65",		ATA_UDMA6),
-	/* 19 */ DECLARE_NV_DEV("NFORCE-MCP67",		ATA_UDMA6),
-	/* 20 */ DECLARE_NV_DEV("NFORCE-MCP73",		ATA_UDMA6),
-	/* 21 */ DECLARE_NV_DEV("NFORCE-MCP77",		ATA_UDMA6),
+	/* 0: AMD7401 */	DECLARE_AMD_DEV(0x00, ATA_UDMA2),
+	/* 1: AMD7409 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA4),
+	/* 2: AMD7411/7441 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
+	/* 3: AMD8111 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA6),
+
+	/* 4: NFORCE */		DECLARE_NV_DEV(ATA_UDMA5),
+	/* 5: >= NFORCE2 */	DECLARE_NV_DEV(ATA_UDMA6),
 
-	/* 22 */ DECLARE_AMD_DEV("AMD5536", ATA_SWDMA2, ATA_UDMA5),
+	/* 6: AMD5536 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
 };
 
 static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_id *id)
@@ -274,7 +260,7 @@ static int __devinit amd74xx_probe(struc
 		if (dev->revision <= 7)
 			d.swdma_mask = 0;
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
-	} else if (idx == 4) {
+	} else if (idx == 3) {
 		if (dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
 		    dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
 			d.udma_mask = ATA_UDMA5;
@@ -308,30 +294,30 @@ static const struct pci_device_id amd74x
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_COBRA_7401),		 0 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7409),		 1 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7411),		 2 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_OPUS_7441),		 3 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_8111_IDE),		 4 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_IDE),	 5 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE),	 6 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE),	 7 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_OPUS_7441),		 2 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_8111_IDE),		 3 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_IDE),	 4 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE),	 5 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA),	 8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA),	 5 },
 #endif
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE),	 9 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE),	10 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE),	 5 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA),	11 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2),	12 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2),	 5 },
 #endif
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE),	13 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE),	14 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE),	15 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE),	16 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	17 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	18 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	19 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	20 },
-	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	21 },
-	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		22 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	 5 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	 5 },
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		 6 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -11,6 +11,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "atiixp"
+
 #define ATIIXP_IDE_PIO_TIMING		0x40
 #define ATIIXP_IDE_MDMA_TIMING		0x44
 #define ATIIXP_IDE_PIO_CONTROL		0x48
@@ -137,16 +139,17 @@ static const struct ide_port_ops atiixp_
 };
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
-	{	/* 0 */
-		.name		= "ATIIXP",
+	{	/* 0: IXP200/300/400/700 */
+		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 1 */
-		.name		= "SB600_PATA",
+	},
+	{	/* 1: IXP600 */
+		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
 		.port_ops	= &atiixp_port_ops,
 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -19,6 +19,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cmd64x"
+
 #define CMD_DEBUG 0
 
 #if CMD_DEBUG
@@ -407,8 +409,8 @@ static const struct ide_dma_ops cmd648_d
 };
 
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "CMD643",
+	{	/* 0: CMD643 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
@@ -418,8 +420,9 @@ static const struct ide_port_info cmd64x
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
-	},{	/* 1 */
-		.name		= "CMD646",
+	},
+	{	/* 1: CMD646 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
@@ -429,8 +432,9 @@ static const struct ide_port_info cmd64x
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
-	},{	/* 2 */
-		.name		= "CMD648",
+	},
+	{	/* 2: CMD648 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
@@ -439,8 +443,9 @@ static const struct ide_port_info cmd64x
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
-	},{	/* 3 */
-		.name		= "CMD649",
+	},
+	{	/* 3: CMD649 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -41,6 +41,8 @@
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 
+#define DRV_NAME "cs5520"
+
 struct pio_clocks
 {
 	int address;
@@ -92,18 +94,11 @@ static const struct ide_port_ops cs5520_
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-#define DECLARE_CS_DEV(name_str)				\
-	{							\
-		.name		= name_str,			\
-		.port_ops	= &cs5520_port_ops,		\
-		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_CS5520,		\
-		.pio_mask	= ATA_PIO4,			\
-	}
-
-static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_CS_DEV("Cyrix 5510"),
-	/* 1 */ DECLARE_CS_DEV("Cyrix 5520")
+static const struct ide_port_info cyrix_chipset __devinitdata = {
+	.name		= DRV_NAME,
+	.port_ops	= &cs5520_port_ops,
+	.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_CS5520,
+	.pio_mask	= ATA_PIO4,
 };
 
 /*
@@ -114,7 +109,7 @@ static const struct ide_port_info cyrix_
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
+	const struct ide_port_info *d = &cyrix_chipset;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
@@ -128,7 +123,8 @@ static int __devinit cs5520_init_one(str
 	}
 	pci_set_master(dev);
 	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
-		printk(KERN_WARNING "cs5520: No suitable DMA available.\n");
+		printk(KERN_WARNING "%s: No suitable DMA available.\n",
+			d->name);
 		return -ENODEV;
 	}
 
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -22,6 +22,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cs5530"
+
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
  * Format-0 uses fast data reg timings, with slower command reg timings.
@@ -243,7 +245,7 @@ static const struct ide_port_ops cs5530_
 };
 
 static const struct ide_port_info cs5530_chipset __devinitdata = {
-	.name		= "CS5530",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
 	.port_ops	= &cs5530_port_ops,
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -26,6 +26,8 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "cs5535"
+
 #define MSR_ATAC_BASE		0x51300000
 #define ATAC_GLD_MSR_CAP	(MSR_ATAC_BASE+0)
 #define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
@@ -169,7 +171,7 @@ static const struct ide_port_ops cs5535_
 };
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
-	.name		= "CS5535",
+	.name		= DRV_NAME,
 	.port_ops	= &cs5535_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -48,6 +48,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cy82c693"
+
 /* the current version */
 #define CY82_VERSION	"CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)"
 
@@ -398,7 +400,7 @@ static const struct ide_port_ops cy82c69
 };
 
 static const struct ide_port_info cy82c693_chipset __devinitdata = {
-	.name		= "CY82C693",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -27,6 +27,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "ide_pci_generic"
+
 static int ide_generic_all;		/* Set to claim all devices */
 
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
@@ -34,9 +36,9 @@ MODULE_PARM_DESC(all_generic_ide, "IDE g
 
 #define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
 
-#define DECLARE_GENERIC_PCI_DEV(name_str, extra_flags) \
+#define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
 				  extra_flags, \
 		.swdma_mask	= ATA_SWDMA2, \
@@ -45,10 +47,11 @@ MODULE_PARM_DESC(all_generic_ide, "IDE g
 	}
 
 static const struct ide_port_info generic_chipsets[] __devinitdata = {
-	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
+	/*  0: Unknown */
+	DECLARE_GENERIC_PCI_DEV(0),
 
-	{	/* 1 */
-		.name		= "NS87410",
+	{	/* 1: NS87410 */
+		.name		= DRV_NAME,
 		.enablebits	= { {0x43, 0x08, 0x08}, {0x47, 0x08, 0x08} },
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.swdma_mask	= ATA_SWDMA2,
@@ -56,17 +59,15 @@ static const struct ide_port_info generi
 		.udma_mask	= ATA_UDMA6,
 	},
 
-	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI",	0),
-	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565",	0),
-	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAGS_UMC),
-	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAGS_UMC),
-	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAGS_UMC),
-	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE",	0),
-	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE",	IDE_HFLAG_NO_AUTODMA),
-	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V",	IDE_HFLAG_NO_AUTODMA),
+	/*  2: SAMURAI / HT6565 / HINT_IDE */
+	DECLARE_GENERIC_PCI_DEV(0),
+	/*  3: UM8673F / UM8886A / UM8886BF */
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAGS_UMC),
+	/*  4: VIA_IDE / OPTI621V / Piccolo010{2,3,5} */
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_AUTODMA),
 
-	{	/* 10 */
-		.name		= "VIA8237SATA",
+	{	/* 5: VIA8237SATA */
+		.name		= DRV_NAME,
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
 		.swdma_mask	= ATA_SWDMA2,
@@ -74,12 +75,8 @@ static const struct ide_port_info generi
 		.udma_mask	= ATA_UDMA6,
 	},
 
-	/* 11 */ DECLARE_GENERIC_PCI_DEV("Piccolo0102",	IDE_HFLAG_NO_AUTODMA),
-	/* 12 */ DECLARE_GENERIC_PCI_DEV("Piccolo0103",	IDE_HFLAG_NO_AUTODMA),
-	/* 13 */ DECLARE_GENERIC_PCI_DEV("Piccolo0105",	IDE_HFLAG_NO_AUTODMA),
-
-	{	/* 14 */
-		.name		= "Revolution",
+	{	/* 6: Revolution */
+		.name		= DRV_NAME,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
@@ -147,20 +144,20 @@ out:
 static const struct pci_device_id generic_pci_tbl[] = {
 	{ PCI_VDEVICE(NS,	PCI_DEVICE_ID_NS_87410),		 1 },
 	{ PCI_VDEVICE(PCTECH,	PCI_DEVICE_ID_PCTECH_SAMURAI_IDE),	 2 },
-	{ PCI_VDEVICE(HOLTEK,	PCI_DEVICE_ID_HOLTEK_6565),		 3 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8673F),		 4 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886A),		 5 },
-	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886BF),		 6 },
-	{ PCI_VDEVICE(HINT,	PCI_DEVICE_ID_HINT_VXPROII_IDE),	 7 },
-	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_82C561),		 8 },
-	{ PCI_VDEVICE(OPTI,	PCI_DEVICE_ID_OPTI_82C558),		 9 },
+	{ PCI_VDEVICE(HOLTEK,	PCI_DEVICE_ID_HOLTEK_6565),		 2 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8673F),		 3 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886A),		 3 },
+	{ PCI_VDEVICE(UMC,	PCI_DEVICE_ID_UMC_UM8886BF),		 3 },
+	{ PCI_VDEVICE(HINT,	PCI_DEVICE_ID_HINT_VXPROII_IDE),	 2 },
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_82C561),		 4 },
+	{ PCI_VDEVICE(OPTI,	PCI_DEVICE_ID_OPTI_82C558),		 4 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		10 },
+	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		 5 },
 #endif
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		11 },
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	12 },
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	13 },
-	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		14 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	 4 },
+	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		 6 },
 	/*
 	 * Must come last.  If you add entries adjust
 	 * this table and generic_chipsets[] appropriately.
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -33,6 +33,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "hpt34x"
+
 #define HPT343_DEBUG_DRIVE_INFO		0
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
@@ -126,15 +128,15 @@ static const struct ide_port_ops hpt34x_
 	 IDE_HFLAG_NO_AUTODMA)
 
 static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
-	{ /* 0 */
-		.name		= "HPT343",
+	{ /* 0: HPT343 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt34x,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
-	{ /* 1 */
-		.name		= "HPT345",
+	{ /* 1: HPT345 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt34x,
 		.port_ops	= &hpt34x_port_ops,
 		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -131,6 +131,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define DRV_NAME "hpt366"
+
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
@@ -1362,7 +1364,7 @@ static void __devinit hpt374_init(struct
 	if (dev2->irq != dev->irq) {
 		/* FIXME: we need a core pci_set_interrupt() */
 		dev2->irq = dev->irq;
-		printk(KERN_INFO "HPT374 %s: PCI config space interrupt "
+		printk(KERN_INFO DRV_NAME " %s: PCI config space interrupt "
 			"fixed\n", pci_name(dev2));
 	}
 }
@@ -1398,7 +1400,7 @@ static int __devinit hpt36x_init(struct 
 	pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 
 	if (pin1 != pin2 && dev->irq == dev2->irq) {
-		printk(KERN_INFO "HPT36x %s: onboard version of chipset, "
+		printk(KERN_INFO DRV_NAME " %s: onboard version of chipset, "
 			"pin1=%d pin2=%d\n", pci_name(dev), pin1, pin2);
 		return 1;
 	}
@@ -1454,8 +1456,8 @@ static const struct ide_dma_ops hpt36x_d
 };
 
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "HPT36x",
+	{	/* 0: HPT36x */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
@@ -1471,53 +1473,9 @@ static const struct ide_port_info hpt366
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 1 */
-		.name		= "HPT372A",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 2 */
-		.name		= "HPT302",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 3 */
-		.name		= "HPT371",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 4 */
-		.name		= "HPT374",
-		.init_chipset	= init_chipset_hpt366,
-		.init_hwif	= init_hwif_hpt366,
-		.init_dma	= init_dma_hpt366,
-		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= ATA_UDMA5,
-		.port_ops	= &hpt3xx_port_ops,
-		.dma_ops	= &hpt37x_dma_ops,
-		.host_flags	= IDE_HFLAGS_HPT3XX,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 5 */
-		.name		= "HPT372N",
+	},
+	{	/* 1: HPT3xx */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
@@ -1583,9 +1541,10 @@ static int __devinit hpt366_init_one(str
 		break;
 	}
 
-	d = hpt366_chipsets[idx];
+	printk(KERN_INFO DRV_NAME ": %s chipset detected\n", info->chip_name);
+
+	d = hpt366_chipsets[min_t(u8, idx, 1)];
 
-	d.name = info->chip_name;
 	d.udma_mask = info->udma_mask;
 
 	/* fixup ->dma_ops for HPT370/HPT370A */
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -14,6 +14,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "it8213"
+
 /**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -156,7 +158,7 @@ static const struct ide_port_ops it8213_
 };
 
 static const struct ide_port_info it8213_chipset __devinitdata = {
-	.name		= "IT8213",
+	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80} },
 	.port_ops	= &it8213_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE,
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -67,6 +67,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "it821x"
+
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -563,7 +565,7 @@ static void __devinit init_hwif_it821x(i
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 		if (idev->smart == 0)
-			printk(KERN_WARNING "it821x %s: revision 0x10, "
+			printk(KERN_WARNING DRV_NAME " %s: revision 0x10, "
 				"workarounds activated\n", pci_name(dev));
 	}
 
@@ -604,12 +606,12 @@ static unsigned int __devinit init_chips
 
 	/* Force the card into bypass mode if so requested */
 	if (it8212_noraid) {
-		printk(KERN_INFO "it821x %s: forcing bypass mode\n",
+		printk(KERN_INFO DRV_NAME " %s: forcing bypass mode\n",
 			pci_name(dev));
 		it8212_disable_raid(dev);
 	}
 	pci_read_config_byte(dev, 0x50, &conf);
-	printk(KERN_INFO "it821x %s: controller in %s mode\n",
+	printk(KERN_INFO DRV_NAME " %s: controller in %s mode\n",
 		pci_name(dev), mode[conf & 1]);
 	return 0;
 }
@@ -623,7 +625,7 @@ static const struct ide_port_ops it821x_
 };
 
 static const struct ide_port_info it821x_chipset __devinitdata = {
-	.name		= "IT821X",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_it821x,
 	.init_hwif	= init_hwif_it821x,
 	.port_ops	= &it821x_port_ops,
@@ -646,7 +648,7 @@ static int __devinit it821x_init_one(str
 
 	itdevs = kzalloc(2 * sizeof(*itdevs), GFP_KERNEL);
 	if (itdevs == NULL) {
-		printk(KERN_ERR "it821x %s: out of memory\n", pci_name(dev));
+		printk(KERN_ERR DRV_NAME " %s: out of memory\n", pci_name(dev));
 		return -ENOMEM;
 	}
 
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -12,6 +12,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "jmicron"
+
 typedef enum {
 	PORT_PATA0 = 0,
 	PORT_PATA1 = 1,
@@ -102,7 +104,7 @@ static const struct ide_port_ops jmicron
 };
 
 static const struct ide_port_info jmicron_chipset __devinitdata = {
-	.name		= "JMB",
+	.name		= DRV_NAME,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.port_ops	= &jmicron_port_ops,
 	.pio_mask	= ATA_PIO5,
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -19,6 +19,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "ns87415"
+
 #ifdef CONFIG_SUPERIO
 /* SUPERIO 87560 is a PoS chip that NatSem denies exists.
  * Unfortunately, it's built-in on all Astro-based PA-RISC workstations
@@ -305,7 +307,7 @@ static const struct ide_dma_ops ns87415_
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
-	.name		= "NS87415",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
 	.dma_ops	= &ns87415_dma_ops,
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -90,6 +90,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "opti621"
+
 #define READ_REG 0	/* index of Read cycle timing register */
 #define WRITE_REG 1	/* index of Write cycle timing register */
 #define CNTRL_REG 3	/* index of Control register */
@@ -200,7 +202,7 @@ static const struct ide_port_ops opti621
 };
 
 static const struct ide_port_info opti621_chipset __devinitdata = {
-	.name		= "OPTI621/X",
+	.name		= DRV_NAME,
 	.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 	.port_ops	= &opti621_port_ops,
 	.host_flags	= IDE_HFLAG_NO_DMA,
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -31,6 +31,8 @@
 #include <asm/pci-bridge.h>
 #endif
 
+#define DRV_NAME "pdc202xx_new"
+
 #undef DEBUG
 
 #ifdef DEBUG
@@ -458,7 +460,7 @@ static struct pci_dev * __devinit pdc202
 
 		if (dev2->irq != dev->irq) {
 			dev2->irq = dev->irq;
-			printk(KERN_INFO "PDC20270 %s: PCI config space "
+			printk(KERN_INFO DRV_NAME " %s: PCI config space "
 				"interrupt fixed\n", pci_name(dev));
 		}
 
@@ -476,9 +478,9 @@ static const struct ide_port_ops pdcnew_
 	.cable_detect		= pdcnew_cable_detect,
 };
 
-#define DECLARE_PDCNEW_DEV(name_str, udma) \
+#define DECLARE_PDCNEW_DEV(udma) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_pdcnew, \
 		.port_ops	= &pdcnew_port_ops, \
 		.host_flags	= IDE_HFLAG_POST_SET_MODE | \
@@ -490,13 +492,8 @@ static const struct ide_port_ops pdcnew_
 	}
 
 static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_PDCNEW_DEV("PDC20268", ATA_UDMA5),
-	/* 1 */ DECLARE_PDCNEW_DEV("PDC20269", ATA_UDMA6),
-	/* 2 */ DECLARE_PDCNEW_DEV("PDC20270", ATA_UDMA5),
-	/* 3 */ DECLARE_PDCNEW_DEV("PDC20271", ATA_UDMA6),
-	/* 4 */ DECLARE_PDCNEW_DEV("PDC20275", ATA_UDMA6),
-	/* 5 */ DECLARE_PDCNEW_DEV("PDC20276", ATA_UDMA6),
-	/* 6 */ DECLARE_PDCNEW_DEV("PDC20277", ATA_UDMA6),
+	/* 0: PDC202{68,70} */		DECLARE_PDCNEW_DEV(ATA_UDMA5),
+	/* 1: PDC202{69,71,75,76,77} */	DECLARE_PDCNEW_DEV(ATA_UDMA6),
 };
 
 /**
@@ -510,13 +507,10 @@ static const struct ide_port_info pdcnew
  
 static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	const struct ide_port_info *d;
+	const struct ide_port_info *d = &pdcnew_chipsets[id->driver_data];
 	struct pci_dev *bridge = dev->bus->self;
-	u8 idx = id->driver_data;
-
-	d = &pdcnew_chipsets[idx];
 
-	if (idx == 2 && bridge &&
+	if (dev->device == PCI_DEVICE_ID_PROMISE_20270 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_DEC &&
 	    bridge->device == PCI_DEVICE_ID_DEC_21150) {
 		struct pci_dev *dev2;
@@ -534,11 +528,11 @@ static int __devinit pdc202new_init_one(
 		}
 	}
 
-	if (idx == 5 && bridge &&
+	if (dev->device == PCI_DEVICE_ID_PROMISE_20276 && bridge &&
 	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 	    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 	     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-		printk(KERN_INFO "PDC20276 %s: attached to I2O RAID controller,"
+		printk(KERN_INFO DRV_NAME " %s: attached to I2O RAID controller,"
 			" skipping\n", pci_name(dev));
 		return -ENODEV;
 	}
@@ -558,11 +552,11 @@ static void __devexit pdc202new_remove(s
 static const struct pci_device_id pdc202new_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20268), 0 },
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20269), 1 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20270), 2 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20271), 3 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20275), 4 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20276), 5 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20277), 6 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20270), 0 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20271), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20275), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20276), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20277), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202new_pci_tbl);
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -20,6 +20,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "pdc202xx_old"
+
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
 static const char *pdc_quirk_drives[] = {
@@ -350,9 +352,9 @@ static const struct ide_dma_ops pdc2026x
 	.dma_timeout		= pdc202xx_dma_timeout,
 };
 
-#define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
+#define DECLARE_PDC2026X_DEV(udma, extra_flags) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_pdc202xx, \
 		.port_ops	= &pdc2026x_port_ops, \
 		.dma_ops	= &pdc2026x_dma_ops, \
@@ -363,8 +365,8 @@ static const struct ide_dma_ops pdc2026x
 	}
 
 static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "PDC20246",
+	{	/* 0: PDC20246 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
 		.dma_ops	= &pdc20246_dma_ops,
@@ -374,10 +376,10 @@ static const struct ide_port_info pdc202
 		.udma_mask	= ATA_UDMA2,
 	},
 
-	/* 1 */ DECLARE_PDC2026X_DEV("PDC20262", ATA_UDMA4, 0),
-	/* 2 */ DECLARE_PDC2026X_DEV("PDC20263", ATA_UDMA4, 0),
-	/* 3 */ DECLARE_PDC2026X_DEV("PDC20265", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
-	/* 4 */ DECLARE_PDC2026X_DEV("PDC20267", ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
+	/* 1: PDC2026{2,3} */
+	DECLARE_PDC2026X_DEV(ATA_UDMA4, 0),
+	/* 2: PDC2026{5,7} */
+	DECLARE_PDC2026X_DEV(ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
 };
 
 /**
@@ -396,17 +398,17 @@ static int __devinit pdc202xx_init_one(s
 
 	d = &pdc202xx_chipsets[idx];
 
-	if (idx < 3)
+	if (idx < 2)
 		pdc202ata4_fixup_irq(dev, d->name);
 
-	if (idx == 3) {
+	if (dev->vendor == PCI_DEVICE_ID_PROMISE_20265) {
 		struct pci_dev *bridge = dev->bus->self;
 
 		if (bridge &&
 		    bridge->vendor == PCI_VENDOR_ID_INTEL &&
 		    (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
 		     bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
-			printk(KERN_INFO "pdc202xx_old %s: skipping Promise "
+			printk(KERN_INFO DRV_NAME " %s: skipping Promise "
 				"PDC20265 attached to I2O RAID controller\n",
 				pci_name(dev));
 			return -ENODEV;
@@ -419,9 +421,9 @@ static int __devinit pdc202xx_init_one(s
 static const struct pci_device_id pdc202xx_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20246), 0 },
 	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20262), 1 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20263), 2 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20265), 3 },
-	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20267), 4 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20263), 1 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20265), 2 },
+	{ PCI_VDEVICE(PROMISE, PCI_DEVICE_ID_PROMISE_20267), 2 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, pdc202xx_pci_tbl);
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -54,6 +54,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "piix"
+
 static int no_piix_dma;
 
 /**
@@ -314,9 +316,9 @@ static const struct ide_port_ops piix_po
  #define IDE_HFLAGS_PIIX 0
 #endif
 
-#define DECLARE_PIIX_DEV(name_str, udma) \
+#define DECLARE_PIIX_DEV(udma) \
 	{						\
-		.name		= name_str,		\
+		.name		= DRV_NAME,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &piix_port_ops,	\
@@ -327,9 +329,9 @@ static const struct ide_port_ops piix_po
 		.udma_mask	= udma,			\
 	}
 
-#define DECLARE_ICH_DEV(name_str, udma) \
+#define DECLARE_ICH_DEV(udma) \
 	{ \
-		.name		= name_str, \
+		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_ich, \
 		.init_hwif	= init_hwif_ich, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
@@ -342,45 +344,31 @@ static const struct ide_port_ops piix_po
 	}
 
 static const struct ide_port_info piix_pci_info[] __devinitdata = {
-	/*  0 */ DECLARE_PIIX_DEV("PIIXa",	0x00),	/* no udma */
-	/*  1 */ DECLARE_PIIX_DEV("PIIXb",	0x00),	/* no udma */
-
-	/*  2 */
+	/* 0: MPIIX */
 	{	/*
 		 * MPIIX actually has only a single IDE channel mapped to
 		 * the primary or secondary ports depending on the value
 		 * of the bit 14 of the IDETIM register at offset 0x6c
 		 */
-		.name		= "MPIIX",
+		.name		= DRV_NAME,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
 		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA |
 				  IDE_HFLAGS_PIIX,
 		.pio_mask	= ATA_PIO4,
 		/* This is a painful system best to let it self tune for now */
 	},
-
-	/*  3 */ DECLARE_PIIX_DEV("PIIX3",	0x00),	/* no udma */
-	/*  4 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/*  5 */ DECLARE_ICH_DEV("ICH0",	ATA_UDMA2),
-	/*  6 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/*  7 */ DECLARE_ICH_DEV("ICH",		ATA_UDMA4),
-	/*  8 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA4),
-	/*  9 */ DECLARE_PIIX_DEV("PIIX4",	ATA_UDMA2),
-	/* 10 */ DECLARE_ICH_DEV("ICH2",	ATA_UDMA5),
-	/* 11 */ DECLARE_ICH_DEV("ICH2M",	ATA_UDMA5),
-	/* 12 */ DECLARE_ICH_DEV("ICH3M",	ATA_UDMA5),
-	/* 13 */ DECLARE_ICH_DEV("ICH3",	ATA_UDMA5),
-	/* 14 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 15 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
-	/* 16 */ DECLARE_ICH_DEV("C-ICH",	ATA_UDMA5),
-	/* 17 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 18 */ DECLARE_ICH_DEV("ICH5-SATA",	ATA_UDMA5),
-	/* 19 */ DECLARE_ICH_DEV("ICH5",	ATA_UDMA5),
-	/* 20 */ DECLARE_ICH_DEV("ICH6",	ATA_UDMA5),
-	/* 21 */ DECLARE_ICH_DEV("ICH7",	ATA_UDMA5),
-	/* 22 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
-	/* 23 */ DECLARE_ICH_DEV("ESB2",	ATA_UDMA5),
-	/* 24 */ DECLARE_ICH_DEV("ICH8M",	ATA_UDMA5),
+	/* 1: PIIXa/PIIXb/PIIX3 */
+	DECLARE_PIIX_DEV(0x00), /* no udma */
+	/* 2: PIIX4 */
+	DECLARE_PIIX_DEV(ATA_UDMA2),
+	/* 3: ICH0 */
+	DECLARE_ICH_DEV(ATA_UDMA2),
+	/* 4: ICH */
+	DECLARE_ICH_DEV(ATA_UDMA4),
+	/* 5: PIIX4 */
+	DECLARE_PIIX_DEV(ATA_UDMA4),
+	/* 6: ICH[2-7]/ICH[2-3]M/C-ICH/ICH5-SATA/ESB2/ICH8M */
+	DECLARE_ICH_DEV(ATA_UDMA5),
 };
 
 /**
@@ -421,39 +409,39 @@ static void __devinit piix_check_450nx(v
 			no_piix_dma = 2;
 	}
 	if(no_piix_dma)
-		printk(KERN_WARNING "piix: 450NX errata present, disabling IDE DMA.\n");
+		printk(KERN_WARNING DRV_NAME ": 450NX errata present, disabling IDE DMA.\n");
 	if(no_piix_dma == 2)
-		printk(KERN_WARNING "piix: A BIOS update may resolve this.\n");
+		printk(KERN_WARNING DRV_NAME ": A BIOS update may resolve this.\n");
 }		
 
 static const struct pci_device_id piix_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),   0 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),   1 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX),     2 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371SB_1),   3 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB),     4 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AB_1),   5 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82443MX_1),   6 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AA_1),   7 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82372FB_1),   8 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82451NX),     9 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_9),  10 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_8),  11 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_10), 12 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_11), 13 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_11), 14 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_11), 15 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801E_11),  16 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_10), 17 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371MX),    0 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371SB_1),  1 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371AB),    2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AB_1),  3 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82443MX_1),  2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801AA_1),  4 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82372FB_1),  5 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82451NX),    2 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_9),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801BA_8),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_10), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801CA_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_11), 6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801E_11),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_10), 6 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_1),  18 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801EB_1),  6 },
 #endif
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB_2),      19 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH6_19),    20 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH7_21),    21 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  22 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    23 },
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     24 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB_2),      6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH6_19),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH7_21),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    6 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     6 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -21,6 +21,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "rz1000"
+
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -40,7 +42,7 @@ static void __devinit init_hwif_rz1000 (
 }
 
 static const struct ide_port_info rz1000_chipset __devinitdata = {
-	.name		= "RZ100x",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_rz1000,
 	.chipset	= ide_rz1000,
 	.host_flags	= IDE_HFLAG_NO_DMA,
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -22,6 +22,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "sc1200"
+
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
 #define SC1200_REV_B3	0x02
@@ -291,7 +293,7 @@ static const struct ide_dma_ops sc1200_d
 };
 
 static const struct ide_port_info sc1200_chipset __devinitdata = {
-	.name		= "SC1200",
+	.name		= DRV_NAME,
 	.port_ops	= &sc1200_port_ops,
 	.dma_ops	= &sc1200_dma_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -38,6 +38,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "serverworks"
+
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
 
@@ -353,40 +355,44 @@ static const struct ide_port_ops svwks_p
 #define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "SvrWks OSB4",
+	{	/* 0: OSB4 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &osb4_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
-	},{	/* 1 */
-		.name		= "SvrWks CSB5",
+	},
+	{	/* 1: CSB5 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 2 */
-		.name		= "SvrWks CSB6",
+	},
+	{	/* 2: CSB6 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 3 */
-		.name		= "SvrWks CSB6",
+	},
+	{	/* 3: CSB6-2 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
-	},{	/* 4 */
-		.name		= "SvrWks HT1000",
+	},
+	{	/* 4: HT1000 */
+		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
 		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -44,6 +44,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
+#define DRV_NAME "siimage"
+
 /**
  *	pdev_is_sata		-	check if device is SATA
  *	@pdev:	PCI device to check
@@ -717,9 +719,9 @@ static const struct ide_dma_ops sil_dma_
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
 
-#define DECLARE_SII_DEV(name_str, p_ops)		\
+#define DECLARE_SII_DEV(p_ops)				\
 	{						\
-		.name		= name_str,		\
+		.name		= DRV_NAME,		\
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
 		.port_ops	= p_ops,		\
@@ -730,9 +732,8 @@ static const struct ide_dma_ops sil_dma_
 	}
 
 static const struct ide_port_info siimage_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SII_DEV("SiI680",		&sil_pata_port_ops),
-	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA",	&sil_sata_port_ops),
-	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA",	&sil_sata_port_ops)
+	/* 0: SiI680 */  DECLARE_SII_DEV(&sil_pata_port_ops),
+	/* 1: SiI3112 */ DECLARE_SII_DEV(&sil_sata_port_ops)
 };
 
 /**
@@ -761,7 +762,7 @@ static int __devinit siimage_init_one(st
 		static int first = 1;
 
 		if (first) {
-			printk(KERN_INFO "siimage: For full SATA support you "
+			printk(KERN_INFO DRV_NAME ": For full SATA support you "
 				"should use the libata sata_sil module.\n");
 			first = 0;
 		}
@@ -780,7 +781,7 @@ static int __devinit siimage_init_one(st
 		* seem to get terminally confused in the PCI spaces.
 		*/
 		if (!request_mem_region(bar5, barsize, d.name)) {
-			printk(KERN_WARNING "siimage %s: MMIO ports not "
+			printk(KERN_WARNING DRV_NAME " %s: MMIO ports not "
 				"available\n", pci_name(dev));
 		} else {
 			ioaddr = ioremap(bar5, barsize);
@@ -823,7 +824,7 @@ static const struct pci_device_id siimag
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_680),    0 },
 #ifdef CONFIG_BLK_DEV_IDE_SATA
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_3112),   1 },
-	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_1210SA), 2 },
+	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_1210SA), 1 },
 #endif
 	{ 0, },
 };
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -52,6 +52,8 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "sis5513"
+
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -380,7 +382,7 @@ static int __devinit sis_find_family(str
 		}
 		pci_dev_put(host);
 
-		printk(KERN_INFO "SIS5513 %s: %s %s controller\n",
+		printk(KERN_INFO DRV_NAME " %s: %s %s controller\n",
 			pci_name(dev), SiSHostChipInfo[i].name,
 			chipset_capability[chipset_family]);
 	}
@@ -397,7 +399,7 @@ static int __devinit sis_find_family(str
 			pci_write_config_dword(dev, 0x54, idemisc);
 
 			if (trueid == 0x5518) {
-				printk(KERN_INFO "SIS5513 %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
+				printk(KERN_INFO DRV_NAME " %s: SiS 962/963 MuTIOL IDE UDMA133 controller\n",
 					pci_name(dev));
 				chipset_family = ATA_133;
 
@@ -407,7 +409,7 @@ static int __devinit sis_find_family(str
 				 */
 				if ((idemisc & 0x40000000) == 0) {
 					pci_write_config_dword(dev, 0x54, idemisc | 0x40000000);
-					printk(KERN_INFO "SIS5513 %s: Switching to 5513 register mapping\n",
+					printk(KERN_INFO DRV_NAME " %s: Switching to 5513 register mapping\n",
 						pci_name(dev));
 				}
 			}
@@ -432,11 +434,11 @@ static int __devinit sis_find_family(str
 				pci_dev_put(lpc_bridge);
 
 				if (lpc_bridge->revision == 0x10 && (prefctl & 0x80)) {
-					printk(KERN_INFO "SIS5513 %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
+					printk(KERN_INFO DRV_NAME " %s: SiS 961B MuTIOL IDE UDMA133 controller\n",
 						pci_name(dev));
 					chipset_family = ATA_133a;
 				} else {
-					printk(KERN_INFO "SIS5513 %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
+					printk(KERN_INFO DRV_NAME " %s: SiS 961 MuTIOL IDE UDMA100 controller\n",
 						pci_name(dev));
 					chipset_family = ATA_100;
 				}
@@ -560,7 +562,7 @@ static const struct ide_port_ops sis_ata
 };
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
-	.name		= "SIS5513",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -23,6 +23,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "sl82c105"
+
 #undef DEBUG
 
 #ifdef DEBUG
@@ -301,7 +303,7 @@ static const struct ide_dma_ops sl82c105
 };
 
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
-	.name		= "W82C105",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.port_ops	= &sl82c105_port_ops,
@@ -328,7 +330,7 @@ static int __devinit sl82c105_init_one(s
 		 * Never ever EVER under any circumstances enable
 		 * DMA when the bridge is this old.
 		 */
-		printk(KERN_INFO "W82C105_IDE: Winbond W83C553 bridge "
+		printk(KERN_INFO DRV_NAME ": Winbond W83C553 bridge "
 				 "revision %d, BM-DMA disabled\n", rev);
 		d.dma_ops = NULL;
 		d.mwdma_mask = 0;
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -15,6 +15,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "slc90e66"
+
 static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -132,7 +134,7 @@ static const struct ide_port_ops slc90e6
 };
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
-	.name		= "SLC90E66",
+	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -11,7 +11,7 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-#define DRV_NAME "TC86C001"
+#define DRV_NAME "tc86c001"
 
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
@@ -193,7 +193,7 @@ static const struct ide_dma_ops tc86c001
 };
 
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
-	.name		= "TC86C001",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
 	.dma_ops	= &tc86c001_dma_ops,
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -33,6 +33,8 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
+#define DRV_NAME "triflex"
+
 static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -93,7 +95,7 @@ static const struct ide_port_ops triflex
 };
 
 static const struct ide_port_info triflex_device __devinitdata = {
-	.name		= "TRIFLEX",
+	.name		= DRV_NAME,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
 	.port_ops	= &triflex_port_ops,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -141,6 +141,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "trm290"
+
 static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -245,10 +247,10 @@ static void __devinit init_hwif_trm290(i
 	u8 reg = 0;
 
 	if ((dev->class & 5) && cfg_base)
-		printk(KERN_INFO "TRM290 %s: chip", pci_name(dev));
+		printk(KERN_INFO DRV_NAME " %s: chip", pci_name(dev));
 	else {
 		cfg_base = 0x3df0;
-		printk(KERN_INFO "TRM290 %s: using default", pci_name(dev));
+		printk(KERN_INFO DRV_NAME " %s: using default", pci_name(dev));
 	}
 	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
@@ -325,7 +327,7 @@ static struct ide_dma_ops trm290_dma_ops
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
-	.name		= "TRM290",
+	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
 	.chipset	= ide_trm290,
 	.port_ops	= &trm290_port_ops,
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -35,6 +35,8 @@
 #include <asm/processor.h>
 #endif
 
+#define DRV_NAME "via82cxxx"
+
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
@@ -373,7 +375,7 @@ static const struct ide_port_ops via_por
 };
 
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
-	.name		= "VP_IDE",
+	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.port_ops	= &via_port_ops,
@@ -401,7 +403,7 @@ static int __devinit via_init_one(struct
 	 */
 	via_config = via_config_find(&isa);
 	if (!via_config->id) {
-		printk(KERN_WARNING "VP_IDE %s: unknown chipset, skipping\n",
+		printk(KERN_WARNING DRV_NAME " %s: unknown chipset, skipping\n",
 			pci_name(dev));
 		return -ENODEV;
 	}
@@ -409,7 +411,7 @@ static int __devinit via_init_one(struct
 	/*
 	 * Print the boot message.
 	 */
-	printk(KERN_INFO "VP_IDE %s: VIA %s (rev %02x) IDE %sDMA%s\n",
+	printk(KERN_INFO DRV_NAME " %s: VIA %s (rev %02x) IDE %sDMA%s\n",
 		pci_name(dev), via_config->name, isa->revision,
 		via_config->udma_mask ? "U" : "MW",
 		via_dma[via_config->udma_mask ?
@@ -429,9 +431,9 @@ static int __devinit via_init_one(struct
 	}
 
 	if (via_clock < 20000 || via_clock > 50000) {
-		printk(KERN_WARNING "VP_IDE: User given PCI clock speed "
+		printk(KERN_WARNING DRV_NAME ": User given PCI clock speed "
 			"impossible (%d), using 33 MHz instead.\n", via_clock);
-		printk(KERN_WARNING "VP_IDE: Use ide0=ata66 if you want "
+		printk(KERN_WARNING DRV_NAME ": Use ide0=ata66 if you want "
 			"to assume 80-wire cable.\n");
 		via_clock = 33333;
 	}
@@ -453,7 +455,8 @@ static int __devinit via_init_one(struct
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
-		printk(KERN_ERR "VP_IDE %s: out of memory :(\n", pci_name(dev));
+		printk(KERN_ERR DRV_NAME " %s: out of memory :(\n",
+			pci_name(dev));
 		return -ENOMEM;
 	}
 
