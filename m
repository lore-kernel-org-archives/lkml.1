Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXHaJCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXHaJCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXHaJCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:02:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37963 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbXHaJCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:02:43 -0400
Date: Fri, 31 Aug 2007 05:02:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070831090242.GA28269@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes, some new ids, and a version bump that we discovered was missing
from several drivers.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_generic.c      |    2 +-
 drivers/ata/ata_piix.c         |   72 +++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c      |   16 +++++++--
 drivers/ata/pata_ali.c         |    2 +-
 drivers/ata/pata_amd.c         |    2 +-
 drivers/ata/pata_atiixp.c      |    2 +-
 drivers/ata/pata_cs5520.c      |    2 +-
 drivers/ata/pata_cs5530.c      |    2 +-
 drivers/ata/pata_isapnp.c      |    2 +-
 drivers/ata/pata_it821x.c      |    2 +-
 drivers/ata/pata_marvell.c     |    2 +
 drivers/ata/pata_mpc52xx.c     |    2 +-
 drivers/ata/pata_pcmcia.c      |    2 +-
 drivers/ata/pata_pdc2027x.c    |    2 +-
 drivers/ata/pata_platform.c    |    2 +-
 drivers/ata/pata_sc1200.c      |    2 +-
 drivers/ata/pata_scc.c         |    2 +-
 drivers/ata/pata_serverworks.c |    2 +-
 drivers/ata/pata_sil680.c      |    2 +-
 drivers/ata/pata_sl82c105.c    |    2 +-
 drivers/ata/pdc_adma.c         |    2 +-
 drivers/ata/sata_inic162x.c    |    2 +-
 drivers/ata/sata_mv.c          |    2 +-
 drivers/ata/sata_nv.c          |    2 +-
 drivers/ata/sata_promise.c     |    6 ++--
 drivers/ata/sata_qstor.c       |    2 +-
 drivers/ata/sata_sil.c         |    2 +-
 drivers/ata/sata_sil24.c       |    2 +-
 drivers/ata/sata_sis.c         |    2 +-
 drivers/ata/sata_svw.c         |    2 +-
 drivers/ata/sata_sx4.c         |    2 +-
 drivers/ata/sata_uli.c         |    2 +-
 drivers/ata/sata_via.c         |    2 +-
 drivers/ata/sata_vsc.c         |    2 +-
 include/linux/ata.h            |   13 +++++++
 include/linux/libata.h         |    1 +
 36 files changed, 133 insertions(+), 37 deletions(-)

Alan Cox (2):
      libata-core: Allow translation setting to fail
      pata_marvell: Add more identifiers

Bartlomiej Zolnierkiewicz (1):
      ata: add ATA_MWDMA* and ATA_SWDMA* defines

Jason Gaston (1):
      ata_piix: IDE mode SATA patch for Intel Tolapai

Jeff Garzik (1):
      [libata] Bump driver versions

Mikael Pettersson (1):
      sata_promise: FastTrack TX4200 is a second-generation chip

Tejun Heo (3):
      ata_piix: add Satellite U200 to broken suspend list
      libata: implement BROKEN_HPA horkage and apply it to affected drives
      ata_piix: implement IOCFG bit18 quirk

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 430fcf4..9454669 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "ata_generic"
-#define DRV_VERSION "0.2.12"
+#define DRV_VERSION "0.2.13"
 
 /*
  *	A generic parallel ATA driver using libata
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 071d274..e40c94f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -94,7 +94,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.11"
+#define DRV_VERSION	"2.12"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -130,6 +130,7 @@ enum {
 	ich6m_sata_ahci		= 8,
 	ich8_sata_ahci		= 9,
 	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
+	tolapai_sata_ahci	= 11,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -253,6 +254,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (Tolapai) */
+	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
 
 	{ }	/* terminate list */
 };
@@ -441,12 +444,25 @@ static const struct piix_map_db ich8_map_db = {
 	},
 };
 
+static const struct piix_map_db tolapai_map_db = {
+        .mask = 0x3,
+        .port_enable = 0x3,
+        .map = {
+                /* PM   PS   SM   SS       MAP */
+                {  P0,  NA,  P1,  NA }, /* 00b */
+                {  RV,  RV,  RV,  RV }, /* 01b */
+                {  RV,  RV,  RV,  RV }, /* 10b */
+                {  RV,  RV,  RV,  RV },
+        },
+};
+
 static const struct piix_map_db *piix_map_db_table[] = {
 	[ich5_sata]		= &ich5_map_db,
 	[ich6_sata]		= &ich6_map_db,
 	[ich6_sata_ahci]	= &ich6_map_db,
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
+	[tolapai_sata_ahci]	= &tolapai_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -560,6 +576,17 @@ static struct ata_port_info piix_port_info[] = {
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
 		.port_ops	= &piix_pata_ops,
 	},
+
+	/* tolapai_sata_ahci: 11: */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -908,6 +935,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "Satellite U200",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U200"),
+			},
+		},
+		{
 			.ident = "Satellite U205",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -1139,6 +1173,39 @@ static void __devinit piix_init_sata_map(struct pci_dev *pdev,
 	hpriv->map = map;
 }
 
+static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
+{
+	static struct dmi_system_id sysids[] = {
+		{
+			/* Clevo M570U sets IOCFG bit 18 if the cdrom
+			 * isn't used to boot the system which
+			 * disables the channel.
+			 */
+			.ident = "M570U",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Clevo Co."),
+				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
+			},
+		},
+	};
+	u32 iocfg;
+
+	if (!dmi_check_system(sysids))
+		return;
+
+	/* The datasheet says that bit 18 is NOOP but certain systems
+	 * seem to use it to disable a channel.  Clear the bit on the
+	 * affected systems.
+	 */
+	pci_read_config_dword(pdev, PIIX_IOCFG, &iocfg);
+	if (iocfg & (1 << 18)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "applying IOCFG bit18 quirk\n");
+		iocfg &= ~(1 << 18);
+		pci_write_config_dword(pdev, PIIX_IOCFG, iocfg);
+	}
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1200,6 +1267,9 @@ static int piix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 			      piix_map_db_table[ent->driver_data]);
 	}
 
+	/* apply IOCFG bit18 quirk */
+	piix_iocfg_bit18_quirk(pdev);
+
 	/* On ICH5, some BIOSen disable the interrupt using the
 	 * PCI_COMMAND_INTX_DISABLE bit added in PCI 2.3.
 	 * On ICH6, this bit has the same effect, but only when
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2ad4dda..a3ee087 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1911,8 +1911,9 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
-			if (ata_id_hpa_enabled(dev->id))
-				dev->n_sectors = ata_hpa_resize(dev);
+			if (!(dev->horkage & ATA_HORKAGE_BROKEN_HPA) &&
+			    ata_id_hpa_enabled(dev->id))
+ 				dev->n_sectors = ata_hpa_resize(dev);
 
 			/* config NCQ */
 			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
@@ -3795,7 +3796,11 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
-	/* Devices with NCQ limits */
+	/* devices which puke on READ_NATIVE_MAX */
+	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
+	{ "WDC WD3200JD-00KLB0", "WD-WCAMR1130137", ATA_HORKAGE_BROKEN_HPA },
+	{ "WDC WD2500JD-00HBB0", "WD-WMAL71490727", ATA_HORKAGE_BROKEN_HPA },
+	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_HORKAGE_BROKEN_HPA },
 
 	/* End Marker */
 	{ }
@@ -3985,6 +3990,11 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 	tf.device |= (heads - 1) & 0x0f; /* max head = num. of heads - 1 */
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	/* A clean abort indicates an original or just out of spec drive
+	   and we should continue as we issue the setup based on the
+	   drive reported working geometry */
+	if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
+		err_mask = 0;
 
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index e8a28e9..94e5edc 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -34,7 +34,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_ali"
-#define DRV_VERSION "0.7.4"
+#define DRV_VERSION "0.7.5"
 
 /*
  *	Cable special cases
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b09faca..04048fc 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.8"
+#define DRV_VERSION "0.3.9"
 
 /**
  *	timing_setup		-	shared timing computation and load
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 80509be..86f85a2 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_atiixp"
-#define DRV_VERSION "0.4.5"
+#define DRV_VERSION "0.4.6"
 
 enum {
 	ATIIXP_IDE_PIO_TIMING	= 0x40,
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 7dc76e7..e245908 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -41,7 +41,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_cs5520"
-#define DRV_VERSION	"0.6.5"
+#define DRV_VERSION	"0.6.6"
 
 struct pio_clocks
 {
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 68f150a..c6066aa 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -35,7 +35,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME	"pata_cs5530"
-#define DRV_VERSION	"0.7.3"
+#define DRV_VERSION	"0.7.4"
 
 static void __iomem *cs5530_port_base(struct ata_port *ap)
 {
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 91a396f..9e553c5 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -17,7 +17,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_isapnp"
-#define DRV_VERSION "0.2.1"
+#define DRV_VERSION "0.2.2"
 
 static struct scsi_host_template isapnp_sht = {
 	.module			= THIS_MODULE,
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 7225124..ed637ae 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -80,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.7"
+#define DRV_VERSION "0.3.8"
 
 struct it821x_dev
 {
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 87594c0..ae206f3 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -192,6 +192,8 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 static const struct pci_device_id marvell_pci_tbl[] = {
 	{ PCI_DEVICE(0x11AB, 0x6101), },
+	{ PCI_DEVICE(0x11AB, 0x6121), },
+	{ PCI_DEVICE(0x11AB, 0x6123), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
 	{ }	/* terminate list */
 };
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 182e83c..099f4cd 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -24,7 +24,7 @@
 
 
 #define DRV_NAME	"mpc52xx_ata"
-#define DRV_VERSION	"0.1.0ac2"
+#define DRV_VERSION	"0.1.2"
 
 
 /* Private structures used by the driver */
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 6da23fe..0f2b027 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.1"
+#define DRV_VERSION "0.3.2"
 
 /*
  *	Private data structure to glue stuff together
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index e3245b3..bb64a98 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_pdc2027x"
-#define DRV_VERSION	"0.9"
+#define DRV_VERSION	"1.0"
 #undef PDC_DEBUG
 
 #ifdef PDC_DEBUG
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index a909f79..5086d03 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -22,7 +22,7 @@
 #include <linux/pata_platform.h>
 
 #define DRV_NAME "pata_platform"
-#define DRV_VERSION "1.0"
+#define DRV_VERSION "1.1"
 
 static int pio_mask = 1;
 
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index b8b2d11..5edf67b 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -40,7 +40,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sc1200"
-#define DRV_VERSION	"0.2.5"
+#define DRV_VERSION	"0.2.6"
 
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 36cdbd2..2d048ef 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -43,7 +43,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME		"pata_scc"
-#define DRV_VERSION		"0.2"
+#define DRV_VERSION		"0.3"
 
 #define PCI_DEVICE_ID_TOSHIBA_SCC_ATA		0x01b4
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 8969154..0faf99c 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -41,7 +41,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_serverworks"
-#define DRV_VERSION "0.4.1"
+#define DRV_VERSION "0.4.2"
 
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index b0cd52d..4039580 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.6"
+#define DRV_VERSION "0.4.7"
 
 #define SIL680_MMIO_BAR		5
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 8c2813a..c0f43bb 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sl82c105"
-#define DRV_VERSION "0.3.1"
+#define DRV_VERSION "0.3.2"
 
 enum {
 	/*
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index bec1de5..5c79271 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -44,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pdc_adma"
-#define DRV_VERSION	"0.06"
+#define DRV_VERSION	"1.0"
 
 /* macro to calculate base address for ATA regs */
 #define ADMA_ATA_REGS(base,port_no)	((base) + ((port_no) * 0x40))
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index a9c948d..fdbed8e 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -28,7 +28,7 @@
 #include <scsi/scsi_device.h>
 
 #define DRV_NAME	"sata_inic162x"
-#define DRV_VERSION	"0.2"
+#define DRV_VERSION	"0.3"
 
 enum {
 	MMIO_BAR		= 5,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 3acf65e..11bf6c7 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -72,7 +72,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"0.81"
+#define DRV_VERSION	"1.0"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0b58c4d..40dc731 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -49,7 +49,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME			"sata_nv"
-#define DRV_VERSION			"3.4"
+#define DRV_VERSION			"3.5"
 
 #define NV_ADMA_DMA_BOUNDARY		0xffffffffUL
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index d39ebc2..25698cf 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.09"
+#define DRV_VERSION	"2.10"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -328,8 +328,8 @@ static const struct pci_device_id pdc_ata_pci_tbl[] = {
 
 	{ PCI_VDEVICE(PROMISE, 0x3318), board_20319 },
 	{ PCI_VDEVICE(PROMISE, 0x3319), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3515), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3519), board_20319 },
+	{ PCI_VDEVICE(PROMISE, 0x3515), board_40518 },
+	{ PCI_VDEVICE(PROMISE, 0x3519), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d17), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d18), board_40518 },
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c8f9242..5e1dfdd 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -39,7 +39,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_qstor"
-#define DRV_VERSION	"0.08"
+#define DRV_VERSION	"0.09"
 
 enum {
 	QS_MMIO_BAR		= 4,
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index db67637..8c72e71 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 enum {
 	SIL_MMIO_BAR		= 5,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 46fbbe7..ef83e6b 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -30,7 +30,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil24"
-#define DRV_VERSION	"0.9"
+#define DRV_VERSION	"1.0"
 
 /*
  * Port request block (PRB) 32 bytes
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 31a2f55..41c1d6e 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -43,7 +43,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"sata_sis"
-#define DRV_VERSION	"0.8"
+#define DRV_VERSION	"1.0"
 
 enum {
 	sis_180			= 0,
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 92e8770..d9678e7 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -53,7 +53,7 @@
 #endif /* CONFIG_PPC_OF */
 
 #define DRV_NAME	"sata_svw"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 enum {
 	/* ap->flags bits */
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 5193bd8..97aefdd 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -92,7 +92,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_sx4"
-#define DRV_VERSION	"0.11"
+#define DRV_VERSION	"0.12"
 
 
 enum {
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 78c2851..e6b8b45 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -36,7 +36,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_uli"
-#define DRV_VERSION	"1.2"
+#define DRV_VERSION	"1.3"
 
 enum {
 	uli_5289		= 0,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 86b7bfc..a4e6317 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 enum board_ids_enum {
 	vt6420,
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 24344d0..1920915 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -47,7 +47,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_vsc"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 enum {
 	VSC_MMIO_BAR			= 0,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 23a22df..c043c1c 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -73,6 +73,19 @@ enum {
 	ATA_PIO5		= ATA_PIO4 | (1 << 5),
 	ATA_PIO6		= ATA_PIO5 | (1 << 6),
 
+	ATA_SWDMA0		= (1 << 0),
+	ATA_SWDMA1		= ATA_SWDMA0 | (1 << 1),
+	ATA_SWDMA2		= ATA_SWDMA1 | (1 << 2),
+
+	ATA_SWDMA2_ONLY		= (1 << 2),
+
+	ATA_MWDMA0		= (1 << 0),
+	ATA_MWDMA1		= ATA_MWDMA0 | (1 << 1),
+	ATA_MWDMA2		= ATA_MWDMA1 | (1 << 2),
+
+	ATA_MWDMA12_ONLY	= (1 << 1) | (1 << 2),
+	ATA_MWDMA2_ONLY		= (1 << 2),
+
 	ATA_UDMA0		= (1 << 0),
 	ATA_UDMA1		= ATA_UDMA0 | (1 << 1),
 	ATA_UDMA2		= ATA_UDMA1 | (1 << 2),
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 41978a5..a67bb90 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -303,6 +303,7 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
+	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 };
 
 enum hsm_task_states {
