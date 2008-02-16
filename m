Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYBPUPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYBPUPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbYBPUND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:13:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13719 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbYBPUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IoidUKCgF970hLmKEuAk3FpLoXLwfqJNQFnxz9QwfumJtxoNCY7kxdcx0RSlogo4mcS/7AwRyYg7J8woYkD847FnNswKzfmOnYmybFMBPam511xxPK3xlEFdnviZkDAZO9fzFqbEbsxt1tAjboE+4oDCDIBd6lgZrddG2x151Lw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:27:28 +0100
Message-Id: <20080216202728.25536.60034.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: IDE_HFLAG_BOOTABLE -> IDE_HFLAG_NON_BOOTABLE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"bootable" should be the default behavior so replace
IDE_HFLAG_BOOTABLE host flag with IDE_HFLAG_NON_BOOTABLE.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c     |    3 ++-
 drivers/ide/pci/alim15x3.c    |    1 -
 drivers/ide/pci/amd74xx.c     |    3 +--
 drivers/ide/pci/atiixp.c      |    5 ++---
 drivers/ide/pci/cmd64x.c      |    9 ++++-----
 drivers/ide/pci/cs5520.c      |    3 +--
 drivers/ide/pci/cs5530.c      |    3 +--
 drivers/ide/pci/cs5535.c      |    2 +-
 drivers/ide/pci/cy82c693.c    |    3 +--
 drivers/ide/pci/generic.c     |    6 ++----
 drivers/ide/pci/hpt34x.c      |    2 +-
 drivers/ide/pci/hpt366.c      |    2 +-
 drivers/ide/pci/it8213.c      |    3 +--
 drivers/ide/pci/it821x.c      |    1 -
 drivers/ide/pci/jmicron.c     |    1 -
 drivers/ide/pci/ns87415.c     |    3 +--
 drivers/ide/pci/opti621.c     |    6 ++----
 drivers/ide/pci/piix.c        |    4 ++--
 drivers/ide/pci/rz1000.c      |    2 +-
 drivers/ide/pci/sc1200.c      |    3 +--
 drivers/ide/pci/scc_pata.c    |    3 +--
 drivers/ide/pci/serverworks.c |    5 ++---
 drivers/ide/pci/siimage.c     |    1 -
 drivers/ide/pci/sis5513.c     |    3 +--
 drivers/ide/pci/sl82c105.c    |    3 +--
 drivers/ide/pci/slc90e66.c    |    2 +-
 drivers/ide/pci/triflex.c     |    1 -
 drivers/ide/pci/trm290.c      |    1 -
 drivers/ide/pci/via82cxxx.c   |    3 +--
 drivers/ide/setup-pci.c       |    2 +-
 include/linux/ide.h           |    8 ++++----
 31 files changed, 37 insertions(+), 60 deletions(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -220,7 +220,8 @@ static const struct ide_port_info aec62x
 		.init_hwif	= init_hwif_aec62xx,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
+				  IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -750,7 +750,6 @@ static const struct ide_port_info ali15x
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -223,8 +223,7 @@ static void __devinit init_hwif_amd74xx(
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_POST_SET_MODE | \
 	 IDE_HFLAG_IO_32BIT | \
-	 IDE_HFLAG_UNMASK_IRQS | \
-	 IDE_HFLAG_BOOTABLE)
+	 IDE_HFLAG_UNMASK_IRQS)
 
 #define DECLARE_AMD_DEV(name_str, swdma, udma)				\
 	{								\
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -151,7 +151,7 @@ static const struct ide_port_info atiixp
 		.name		= "ATIIXP",
 		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -159,8 +159,7 @@ static const struct ide_port_info atiixp
 		.name		= "SB600_PATA",
 		.init_hwif	= init_hwif_atiixp,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
- 		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -440,8 +440,7 @@ static const struct ide_port_info cmd64x
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
-				  IDE_HFLAG_ABUSE_PREFETCH |
-				  IDE_HFLAG_BOOTABLE,
+				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
@@ -451,7 +450,7 @@ static const struct ide_port_info cmd64x
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,
@@ -460,7 +459,7 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA4,
@@ -469,7 +468,7 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -122,8 +122,7 @@ static void __devinit init_hwif_cs5520(i
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |\
-				  IDE_HFLAG_BOOTABLE,		\
+				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
 	}
 
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -249,8 +249,7 @@ static const struct ide_port_info cs5530
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
-			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA2,
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -186,7 +186,7 @@ static const struct ide_port_info cs5535
 	.name		= "CS5535",
 	.init_hwif	= init_hwif_cs5535,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE | IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -410,8 +410,7 @@ static const struct ide_port_info cy82c6
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
 	.chipset	= ide_cy82c693,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_CY82C693 |
-			  IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_CY82C693,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -38,8 +38,7 @@ MODULE_PARM_DESC(all_generic_ide, "IDE g
 	{ \
 		.name		= name_str, \
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA | \
-				  extra_flags | \
-				  IDE_HFLAG_BOOTABLE, \
+				  extra_flags, \
 		.swdma_mask	= ATA_SWDMA2, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= ATA_UDMA6, \
@@ -51,8 +50,7 @@ static const struct ide_port_info generi
 	{	/* 1 */
 		.name		= "NS87410",
 		.enablebits	= {{0x43,0x08,0x08}, {0x47,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -133,7 +133,7 @@ static const struct ide_port_info hpt34x
 		.init_chipset	= init_chipset_hpt34x,
 		.init_hwif	= init_hwif_hpt34x,
 		.extra		= 16,
-		.host_flags	= IDE_HFLAGS_HPT34X,
+		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 	},
 	{ /* 1 */
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1614,7 +1614,7 @@ static int __devinit hpt366_init_one(str
 			hpt374_init(dev, dev2);
 		else {
 			if (hpt36x_init(dev, dev2))
-				d.host_flags |= IDE_HFLAG_BOOTABLE;
+				d.host_flags &= ~IDE_HFLAG_NON_BOOTABLE;
 		}
 
 		ret = ide_setup_pci_devices(dev, dev2, &d);
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -171,8 +171,7 @@ static void __devinit init_hwif_it8213(i
 		.name		= name_str,		\
 		.init_hwif	= init_hwif_it8213,	\
 		.enablebits	= {{0x41,0x80,0x80}}, \
-		.host_flags	= IDE_HFLAG_SINGLE |	\
-				  IDE_HFLAG_BOOTABLE,	\
+		.host_flags	= IDE_HFLAG_SINGLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
 		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -623,7 +623,6 @@ static unsigned int __devinit init_chips
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_it821x,	\
 		.init_hwif	= init_hwif_it821x,	\
-		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
 	}
 
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -114,7 +114,6 @@ static void __devinit init_hwif_jmicron(
 static const struct ide_port_info jmicron_chipset __devinitdata = {
 	.name		= "JMB",
 	.init_hwif	= init_hwif_jmicron,
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.pio_mask	= ATA_PIO5,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -261,8 +261,7 @@ static const struct ide_port_info ns8741
 #endif
 	.init_hwif	= init_hwif_ns87415,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-			  IDE_HFLAG_NO_ATAPI_DMA |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_NO_ATAPI_DMA,
 };
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -335,8 +335,7 @@ static const struct ide_port_info opti62
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -344,8 +343,7 @@ static const struct ide_port_info opti62
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-				  IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -307,9 +307,9 @@ static void __devinit init_hwif_ich(ide_
 }
 
 #ifndef CONFIG_IA64
- #define IDE_HFLAGS_PIIX (IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE)
+ #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
 #else
- #define IDE_HFLAGS_PIIX IDE_HFLAG_BOOTABLE
+ #define IDE_HFLAGS_PIIX 0
 #endif
 
 #define DECLARE_PIIX_DEV(name_str, udma) \
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -43,7 +43,7 @@ static const struct ide_port_info rz1000
 	.name		= "RZ100x",
 	.init_hwif	= init_hwif_rz1000,
 	.chipset	= ide_rz1000,
-	.host_flags	= IDE_HFLAG_NO_DMA | IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_NO_DMA,
 };
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -307,8 +307,7 @@ static const struct ide_port_info sc1200
 	.init_hwif	= init_hwif_sc1200,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_DMA_MODES |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_ABUSE_DMA_MODES,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA2,
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -693,8 +693,7 @@ static void __devinit init_hwif_scc(ide_
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
-      .host_flags	= IDE_HFLAG_SINGLE |		\
-			  IDE_HFLAG_BOOTABLE,		\
+      .host_flags	= IDE_HFLAG_SINGLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
 
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -350,8 +350,7 @@ static void __devinit init_hwif_svwks (i
 
 #define IDE_HFLAGS_SVWKS \
 	(IDE_HFLAG_LEGACY_IRQS | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
-	 IDE_HFLAG_BOOTABLE)
+	 IDE_HFLAG_ABUSE_SET_DMA_MODE)
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
@@ -418,7 +417,7 @@ static int __devinit svwks_init_one(stru
 	else if (idx == 2 || idx == 3) {
 		if ((PCI_FUNC(dev->devfn) & 1) == 0) {
 			if (pci_resource_start(dev, 0) != 0x01f1)
-				d.host_flags &= ~IDE_HFLAG_BOOTABLE;
+				d.host_flags |= IDE_HFLAG_NON_BOOTABLE;
 			d.host_flags |= IDE_HFLAG_SINGLE;
 		} else
 			d.host_flags &= ~IDE_HFLAG_SINGLE;
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -851,7 +851,6 @@ static void __devinit init_hwif_siimage(
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
 		.init_hwif	= init_hwif_siimage,	\
-		.host_flags	= IDE_HFLAG_BOOTABLE,	\
 		.pio_mask	= ATA_PIO4,		\
 		.mwdma_mask	= ATA_MWDMA2,		\
 		.udma_mask	= ATA_UDMA6,		\
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -569,8 +569,7 @@ static const struct ide_port_info sis551
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
 	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 };
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -332,8 +332,7 @@ static const struct ide_port_info sl82c1
 #if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
 			  IDE_HFLAG_FORCE_LEGACY_IRQS |
 #endif
-			  IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO5,
 };
 
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -137,7 +137,7 @@ static const struct ide_port_info slc90e
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
 	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_BOOTABLE,
+	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
 	.mwdma_mask	= ATA_MWDMA12_ONLY,
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -97,7 +97,6 @@ static const struct ide_port_info trifle
 	.name		= "TRIFLEX",
 	.init_hwif	= init_hwif_triflex,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
-	.host_flags	= IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -337,7 +337,6 @@ static const struct ide_port_info trm290
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 #endif
 			  IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_BOOTABLE |
 			  IDE_HFLAG_NO_LBA48,
 };
 
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -432,8 +432,7 @@ static const struct ide_port_info via82c
 			  IDE_HFLAG_PIO_NO_DOWNGRADE |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_IO_32BIT |
-			  IDE_HFLAG_BOOTABLE,
+			  IDE_HFLAG_IO_32BIT,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -322,7 +322,7 @@ static ide_hwif_t *ide_hwif_configure(st
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
-	u8 bootable = (d->host_flags & IDE_HFLAG_BOOTABLE) ? 1 : 0;
+	u8 bootable = (d->host_flags & IDE_HFLAG_NON_BOOTABLE) ? 0 : 1;
 	u8 oldnoprobe = 0;
 	struct hw_regs_s hw;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1054,8 +1054,8 @@ enum {
 	IDE_HFLAG_VDMA			= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
-	/* set if host is a "bootable" controller */
-	IDE_HFLAG_BOOTABLE		= (1 << 13),
+	/* set if host is a "non-bootable" controller */
+	IDE_HFLAG_NON_BOOTABLE		= (1 << 13),
 	/* host doesn't support DMA */
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
@@ -1096,9 +1096,9 @@ enum {
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
-# define IDE_HFLAG_OFF_BOARD	IDE_HFLAG_BOOTABLE
-#else
 # define IDE_HFLAG_OFF_BOARD	0
+#else
+# define IDE_HFLAG_OFF_BOARD	IDE_HFLAG_NON_BOOTABLE
 #endif
 
 struct ide_port_info {
