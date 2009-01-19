Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZASSem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZASSem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZASSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:34:31 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:34399 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZASSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=T0gMe3LFhNkP4oat7ZMpihJEL0aXT60ODCbS+6JyP7pTBiMldtC8n5vSBqGAYi9sWD
         Tc7mdSDssDjNR2f8VqyL1Ew3DY+ylcmZlmKzDyfNgAM8/czdrJnKOh+L5POaMj108P7Z
         gRejOI9iKM8yE6hnVg6ewRAQJnuU751kV6CG4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: fix ->init_chipset method to return 'int' value
Date: Mon, 19 Jan 2009 19:31:31 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191931.32044.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix ->init_chipset method to return 'int' value

* Return 0 instead of dev->irq in ->init_chipset implementations.

* Fix ->init_chipset method to return 'int' value instead of
  'unsigned int' one.

This fixes ->init_chipset handling for host drivers (cs5530, hpt366
and pdc202xx_new) for which it is possible for this method to fail.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c      |    4 ++--
 drivers/ide/alim15x3.c     |    2 +-
 drivers/ide/amd74xx.c      |    4 ++--
 drivers/ide/cmd64x.c       |    2 +-
 drivers/ide/cs5530.c       |    2 +-
 drivers/ide/delkin_cb.c    |    2 +-
 drivers/ide/hpt366.c       |    4 ++--
 drivers/ide/it821x.c       |    2 +-
 drivers/ide/pdc202xx_new.c |    4 ++--
 drivers/ide/pdc202xx_old.c |    4 ++--
 drivers/ide/piix.c         |    2 +-
 drivers/ide/serverworks.c  |    4 ++--
 drivers/ide/setup-pci.c    |    2 +-
 drivers/ide/siimage.c      |    2 +-
 drivers/ide/sis5513.c      |    2 +-
 drivers/ide/sl82c105.c     |    4 ++--
 drivers/ide/via82cxxx.c    |    2 +-
 include/linux/ide.h        |    4 ++--
 18 files changed, 26 insertions(+), 26 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -139,7 +139,7 @@ static void aec_set_pio_mode(ide_drive_t
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
+static int init_chipset_aec62xx(struct pci_dev *dev)
 {
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
@@ -156,7 +156,7 @@ static unsigned int init_chipset_aec62xx
 		pci_write_config_byte(dev, 0x4a, reg4ah | 0x80);
 	}
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 atp86x_cable_detect(ide_hwif_t *hwif)
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -212,7 +212,7 @@ static int ali15x3_dma_setup(ide_drive_t
  *	appropriate also sets up the 1533 southbridge.
  */
 
-static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
+static int init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -140,7 +140,7 @@ static void amd7411_cable_detect(struct 
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
+static int init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -172,7 +172,7 @@ static unsigned int init_chipset_amd74xx
 		t |= 0xf0;
 	pci_write_config_byte(dev, AMD_IDE_CONFIG + offset, t);
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 amd_cable_detect(ide_hwif_t *hwif)
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -333,7 +333,7 @@ static int cmd646_1_dma_end(ide_drive_t 
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int init_chipset_cmd64x(struct pci_dev *dev)
+static int init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
Index: b/drivers/ide/cs5530.c
===================================================================
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -135,7 +135,7 @@ static void cs5530_set_dma_mode(ide_driv
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int init_chipset_cs5530(struct pci_dev *dev)
+static int init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -46,7 +46,7 @@ static const struct ide_port_ops delkin_
 	.quirkproc		= ide_undecoded_slave,
 };
 
-static unsigned int delkin_cb_init_chipset(struct pci_dev *dev)
+static int delkin_cb_init_chipset(struct pci_dev *dev)
 {
 	unsigned long base = pci_resource_start(dev, 0);
 	int i;
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -995,7 +995,7 @@ static void hpt3xx_disable_fast_irq(stru
 		pci_write_config_byte(dev, mcr_addr + 1, new_mcr);
 }
 
-static unsigned int init_chipset_hpt366(struct pci_dev *dev)
+static int init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
@@ -1237,7 +1237,7 @@ static unsigned int init_chipset_hpt366(
 	hpt3xx_disable_fast_irq(dev, 0x50);
 	hpt3xx_disable_fast_irq(dev, 0x54);
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -604,7 +604,7 @@ static void it8212_disable_raid(struct p
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int init_chipset_it821x(struct pci_dev *dev)
+static int init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -325,7 +325,7 @@ static void apple_kiwi_init(struct pci_d
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int init_chipset_pdcnew(struct pci_dev *dev)
+static int init_chipset_pdcnew(struct pci_dev *dev)
 {
 	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
@@ -444,7 +444,7 @@ static unsigned int init_chipset_pdcnew(
 #endif
 
  out:
-	return dev->irq;
+	return 0;
 }
 
 static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -264,7 +264,7 @@ static void pdc202xx_dma_timeout(ide_dri
 	ide_dma_timeout(drive);
 }
 
-static unsigned int init_chipset_pdc202xx(struct pci_dev *dev)
+static int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
@@ -290,7 +290,7 @@ static unsigned int init_chipset_pdc202x
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
 out:
-	return dev->irq;
+	return 0;
 }
 
 static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -204,7 +204,7 @@ static void piix_set_dma_mode(ide_drive_
  *	out to be nice and simple.
  */
 
-static unsigned int init_chipset_ich(struct pci_dev *dev)
+static int init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -175,7 +175,7 @@ static void svwks_set_dma_mode(ide_drive
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int init_chipset_svwks(struct pci_dev *dev)
+static int init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -270,7 +270,7 @@ static unsigned int init_chipset_svwks(s
 		pci_write_config_byte(dev, 0x5A, btr);
 	}
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 ata66_svwks_svwks(ide_hwif_t *hwif)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -524,7 +524,7 @@ static int do_ide_setup_pci_device(struc
 		if (noisy)
 			printk(KERN_INFO "%s %s: not 100%% native mode: will "
 				"probe irqs later\n", d->name, pci_name(dev));
-		pciirq = ret;
+		pciirq = 0;
 	} else if (!pciirq && noisy) {
 		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
 			d->name, pci_name(dev), pciirq);
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -464,7 +464,7 @@ static void sil_sata_pre_reset(ide_drive
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int init_chipset_siimage(struct pci_dev *dev)
+static int init_chipset_siimage(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -447,7 +447,7 @@ static int __devinit sis_find_family(str
 	return chipset_family;
 }
 
-static unsigned int init_chipset_sis5513(struct pci_dev *dev)
+static int init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -271,7 +271,7 @@ static u8 sl82c105_bridge_revision(struc
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int init_chipset_sl82c105(struct pci_dev *dev)
+static int init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
@@ -281,7 +281,7 @@ static unsigned int init_chipset_sl82c10
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return dev->irq;
+	return 0;
 }
 
 static const struct ide_port_ops sl82c105_port_ops = {
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -267,7 +267,7 @@ static void via_cable_detect(struct via8
  *	and initialize its drive independent registers.
  */
 
-static unsigned int init_chipset_via82cxxx(struct pci_dev *dev)
+static int init_chipset_via82cxxx(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -850,7 +850,7 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
-	unsigned int	(*init_chipset)(struct pci_dev *);
+	int		(*init_chipset)(struct pci_dev *);
 	unsigned long	host_flags;
 	void		*host_priv;
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
@@ -1359,7 +1359,7 @@ enum {
 
 struct ide_port_info {
 	char			*name;
-	unsigned int		(*init_chipset)(struct pci_dev *);
+	int			(*init_chipset)(struct pci_dev *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	int			(*init_dma)(ide_hwif_t *,
