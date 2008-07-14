Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYGMPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYGMPO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYGMPNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:13:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:20245 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYGMPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FZVCKzwueVjJZc1aS9u6XOtLH1/cnS2juaUSghESEM8T/R9b70jd5fvQ12vsssnNQU
         6kneLdRPGFZTiR/Alj7l26BNIrGqNZn24KwvBvFnfzd+KfqUT1NdK0tbAN3LFd+1r7eS
         +p1R/3SGEjyuyyL92tun7eOBKMs6KVbkFgVw4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2008 17:11:24 +0200
Message-Id: <20080714151124.3106.90202.sendpatchset@localhost.localdomain>
In-Reply-To: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
References: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/5] ide: drop 'name' parameter from ->init_chipset method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c      |    2 +-
 drivers/ide/pci/alim15x3.c     |    5 ++---
 drivers/ide/pci/amd74xx.c      |   19 ++++++++-----------
 drivers/ide/pci/cmd64x.c       |    2 +-
 drivers/ide/pci/cs5530.c       |    7 +++----
 drivers/ide/pci/cy82c693.c     |   10 +++++-----
 drivers/ide/pci/hpt34x.c       |    2 +-
 drivers/ide/pci/hpt366.c       |    3 ++-
 drivers/ide/pci/it821x.c       |    2 +-
 drivers/ide/pci/pdc202xx_new.c |    3 ++-
 drivers/ide/pci/pdc202xx_old.c |    3 +--
 drivers/ide/pci/piix.c         |    3 +--
 drivers/ide/pci/serverworks.c  |    6 +++---
 drivers/ide/pci/siimage.c      |    8 +++-----
 drivers/ide/pci/sis5513.c      |    3 +--
 drivers/ide/pci/sl82c105.c     |    2 +-
 drivers/ide/pci/via82cxxx.c    |    3 +--
 drivers/ide/setup-pci.c        |    2 +-
 include/linux/ide.h            |    2 +-
 19 files changed, 39 insertions(+), 48 deletions(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -140,7 +140,7 @@ static void aec_set_pio_mode(ide_drive_t
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
 {
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -209,13 +209,12 @@ static int ali15x3_dma_setup(ide_drive_t
 /**
  *	init_chipset_ali15x3	-	Initialise an ALi IDE controller
  *	@dev: PCI device
- *	@name: Name of the controller
  *
  *	This function initializes the ALI IDE controller and where 
  *	appropriate also sets up the 1533 southbridge.
  */
-  
-static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const char *name)
+
+static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -112,15 +112,13 @@ static void amd_set_pio_mode(ide_drive_t
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-static void __devinit amd7409_cable_detect(struct pci_dev *dev,
-					   const char *name)
+static void __devinit amd7409_cable_detect(struct pci_dev *dev)
 {
 	/* no host side cable detection */
 	amd_80w = 0x03;
 }
 
-static void __devinit amd7411_cable_detect(struct pci_dev *dev,
-					   const char *name)
+static void __devinit amd7411_cable_detect(struct pci_dev *dev)
 {
 	int i;
 	u32 u = 0;
@@ -131,9 +129,9 @@ static void __devinit amd7411_cable_dete
 	amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
 	for (i = 24; i >= 0; i -= 8)
 		if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
-			printk(KERN_WARNING "%s %s: BIOS didn't set cable bits "
-				"correctly. Enabling workaround.\n",
-				name, pci_name(dev));
+			printk(KERN_WARNING DRV_NAME " %s: BIOS didn't set "
+				"cable bits correctly. Enabling workaround.\n",
+				pci_name(dev));
 			amd_80w |= (1 << (1 - (i >> 4)));
 		}
 }
@@ -142,8 +140,7 @@ static void __devinit amd7411_cable_dete
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -156,9 +153,9 @@ static unsigned int __devinit init_chips
 		; /* no UDMA > 2 */
 	else if (dev->vendor == PCI_VENDOR_ID_AMD &&
 		 dev->device == PCI_DEVICE_ID_AMD_VIPER_7409)
-		amd7409_cable_detect(dev, name);
+		amd7409_cable_detect(dev);
 	else
-		amd7411_cable_detect(dev, name);
+		amd7411_cable_detect(dev);
 
 /*
  * Take care of prefetch & postwrite.
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -332,7 +332,7 @@ static int cmd646_1_dma_end(ide_drive_t 
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -129,12 +129,11 @@ static void cs5530_set_dma_mode(ide_driv
 /**
  *	init_chipset_5530	-	set up 5530 bridge
  *	@dev: PCI device
- *	@name: device name
  *
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
@@ -153,11 +152,11 @@ static unsigned int __devinit init_chips
 		}
 	}
 	if (!master_0) {
-		printk(KERN_ERR "%s: unable to locate PCI MASTER function\n", name);
+		printk(KERN_ERR DRV_NAME ": unable to locate PCI MASTER function\n");
 		goto out;
 	}
 	if (!cs5530_0) {
-		printk(KERN_ERR "%s: unable to locate CS5530 LEGACY function\n", name);
+		printk(KERN_ERR DRV_NAME ": unable to locate CS5530 LEGACY function\n");
 		goto out;
 	}
 
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -332,7 +332,7 @@ static void cy82c693_set_pio_mode(ide_dr
 /*
  * this function is called during init and is used to setup the cy82c693 chip
  */
-static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
 		return 0;
@@ -351,8 +351,8 @@ static unsigned int __devinit init_chips
 	data = inb(CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: Peripheral Configuration Register: 0x%X\n",
-		name, data);
+	printk(KERN_INFO DRV_NAME ": Peripheral Configuration Register: 0x%X\n",
+		data);
 #endif /* CY82C693_DEBUG_INFO */
 
 	/*
@@ -373,8 +373,8 @@ static unsigned int __devinit init_chips
 	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
-		name, data);
+	printk(KERN_INFO ": New Peripheral Configuration Register: 0x%X\n",
+		data);
 #endif /* CY82C693_DEBUG_INFO */
 
 #endif /* CY82C693_SETDMA_CLOCK */
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -79,7 +79,7 @@ static void hpt34x_set_pio_mode(ide_driv
  */
 #define	HPT34X_PCI_INIT_REG		0x80
 
-static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev)
 {
 	int i = 0;
 	unsigned long hpt34xIoBase = pci_resource_start(dev, 4);
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -970,11 +970,12 @@ static int __devinit hpt37x_calibrate_dp
 	return 1;
 }
 
-static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	const char *name	= DRV_NAME;
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
 	enum ata_clock	clock;
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -599,7 +599,7 @@ static void __devinit it8212_disable_rai
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -326,8 +326,9 @@ static void __devinit apple_kiwi_init(st
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev)
 {
+	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
 	unsigned long sec_dma_base = dma_base + 0x08;
 	long pll_input, pll_output, ratio;
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -265,8 +265,7 @@ static void pdc202xx_dma_timeout(ide_dri
 	ide_dma_timeout(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
-						    const char *name)
+static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -200,13 +200,12 @@ static void piix_set_dma_mode(ide_drive_
 /**
  *	init_chipset_ich	-	set up the ICH chipset
  *	@dev: PCI device to set up
- *	@name: Name of the device
  *
  *	Initialize the PCI device as required.  For the ICH this turns
  *	out to be nice and simple.
  */
 
-static unsigned int __devinit init_chipset_ich(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -174,7 +174,7 @@ static void svwks_set_dma_mode(ide_drive
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int __devinit init_chipset_svwks (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -190,8 +190,8 @@ static unsigned int __devinit init_chips
 			pci_read_config_dword(isa_dev, 0x64, &reg);
 			reg &= ~0x00002000; /* disable 600ns interrupt mask */
 			if(!(reg & 0x00004000))
-				printk(KERN_DEBUG "%s %s: UDMA not BIOS "
-					"enabled.\n", name, pci_name(dev));
+				printk(KERN_DEBUG DRV_NAME " %s: UDMA not BIOS "
+					"enabled.\n", pci_name(dev));
 			reg |=  0x00004000; /* enable UDMA/33 support */
 			pci_write_config_dword(isa_dev, 0x64, reg);
 		}
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -457,14 +457,12 @@ static void sil_sata_pre_reset(ide_drive
 /**
  *	init_chipset_siimage	-	set up an SI device
  *	@dev: PCI device
- *	@name: device name
  *
  *	Perform the initial PCI set up for this device. Attempt to switch
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
@@ -541,8 +539,8 @@ static unsigned int __devinit init_chips
 			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
 
 		tmp >>= 4;
-		printk(KERN_INFO "%s %s: BASE CLOCK %s\n",
-			name, pci_name(dev), clk_str[tmp & 3]);
+		printk(KERN_INFO DRV_NAME " %s: BASE CLOCK %s\n",
+			pci_name(dev), clk_str[tmp & 3]);
 	}
 
 	return 0;
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -448,8 +448,7 @@ static int __devinit sis_find_family(str
 	return chipset_family;
 }
 
-static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev,
-						   const char *name)
+static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -272,7 +272,7 @@ static u8 sl82c105_bridge_revision(struc
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev, const char *msg)
+static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -262,13 +262,12 @@ static void __devinit via_cable_detect(s
 /**
  *	init_chipset_via82cxxx	-	initialization handler
  *	@dev: PCI device
- *	@name: Name of interface
  *
  *	The initialization callback. Here we determine the IDE chip type
  *	and initialize its drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -515,7 +515,7 @@ static int do_ide_setup_pci_device(struc
 	 * space, place chipset into init-mode, and/or preserve
 	 * an interrupt if the card is not native ide support.
 	 */
-	ret = d->init_chipset ? d->init_chipset(dev, d->name) : 0;
+	ret = d->init_chipset ? d->init_chipset(dev) : 0;
 	if (ret < 0)
 		goto out;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1206,7 +1206,7 @@ enum {
 
 struct ide_port_info {
 	char			*name;
-	unsigned int		(*init_chipset)(struct pci_dev *, const char *);
+	unsigned int		(*init_chipset)(struct pci_dev *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	int			(*init_dma)(ide_hwif_t *,
