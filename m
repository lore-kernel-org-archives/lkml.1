Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbZLFVH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbZLFVH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934162AbZLFVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:07:53 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35184 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749AbZLFVHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:07:47 -0500
Date: Sun, 6 Dec 2009 16:07:52 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.33
Message-ID: <20091206210752.GA19268@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing world-shakingly-notable.  Notable notables:

- TRIM work from Christoph and mkp, to make SSD life a bit better
- PATA fixes and updates from Bart and Alan
- long overdue removal of 'experimental' tag from PATA driver submenu
  in Kconfig
- various bug fixes and minor updates

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig           |   41 +++++++-----
 drivers/ata/Makefile          |    1 +
 drivers/ata/ahci.c            |   28 ++++++++-
 drivers/ata/ata_generic.c     |    5 +-
 drivers/ata/ata_piix.c        |    6 +-
 drivers/ata/libata-acpi.c     |   15 +++--
 drivers/ata/libata-core.c     |    7 ++
 drivers/ata/libata-eh.c       |   94 +++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c     |  107 ++++++++++++++++++++++++++++++-
 drivers/ata/libata-sff.c      |    2 +-
 drivers/ata/pata_ali.c        |    4 +-
 drivers/ata/pata_cmd64x.c     |  125 ++++++++++++++++++++++++++++++++-----
 drivers/ata/pata_cs5520.c     |   39 +-----------
 drivers/ata/pata_cs5536.c     |    2 +-
 drivers/ata/pata_efar.c       |    9 ++-
 drivers/ata/pata_hpt366.c     |   38 +++++-------
 drivers/ata/pata_hpt37x.c     |  137 +++++++++++++++++++++-------------------
 drivers/ata/pata_hpt3x2n.c    |   40 +++++-------
 drivers/ata/pata_hpt3x3.c     |   11 +++-
 drivers/ata/pata_it8213.c     |   27 ++++----
 drivers/ata/pata_it821x.c     |    2 +-
 drivers/ata/pata_legacy.c     |   14 +++-
 drivers/ata/pata_marvell.c    |    2 +-
 drivers/ata/pata_ns87415.c    |   32 ++++++++--
 drivers/ata/pata_oldpiix.c    |    2 +-
 drivers/ata/pata_piccolo.c    |  140 +++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_radisys.c    |    4 +-
 drivers/ata/pata_rdc.c        |    2 +-
 drivers/ata/pata_rz1000.c     |   11 +++-
 drivers/ata/pata_sil680.c     |    6 +-
 drivers/ata/pata_sis.c        |  112 ++++++++++++++++++++++++++-------
 drivers/ata/pata_via.c        |   56 +++++++++++++----
 drivers/ata/sata_fsl.c        |   18 +++---
 drivers/ata/sata_mv.c         |    2 +-
 drivers/ata/sata_sil24.c      |    9 +++
 drivers/ide/ide-pci-generic.c |    3 +-
 include/linux/ata.h           |   44 ++++++++++---
 include/linux/libata.h        |    3 +-
 include/linux/pci_ids.h       |    7 +-
 39 files changed, 913 insertions(+), 294 deletions(-)
 create mode 100644 drivers/ata/pata_piccolo.c

Alan Cox (6):
      pata_via: Blacklist some combinations of Transcend Flash and via
      pata_sis: Implement MWDMA for the UDMA 133 capable chips
      pata_cmd64x: implement serialization as per notes
      [libata] PATA: Update experimental tags
      pata_ali: Fix regression with old devices
      pata_piccolo: Driver for old Toshiba chipsets

Bartlomiej Zolnierkiewicz (28):
      pata_hpt37x: add proper cable detection methods
      pata_hpt37x: unify ->pre_reset methods
      pata_hpt3x2n: fix cable detection
      pata_hpt{37x,3x2n}: add debounce delay to cable detection methods
      libata: add comment documenting PIO latency issues on UP
      libata: add private driver field to struct ata_device
      ata_piix: fix MWDMA handling on PIIX3
      pata_efar: fix wrong PIO timings being programmed
      pata_efar: fix wrong MWDMA timings being programmed
      pata_cs5520: remove dead VDMA support
      pata_hpt3x3: Power Management fix
      pata_it8213: fix UDMA handling
      pata_it8213: fix wrong PIO timings being programmed
      pata_it8213: fix PIO2 underclocking
      pata_it8213: fix wrong MWDMA timings being programmed
      pata_it8213: fix it8213_pre_reset() documentation
      pata_legacy: fix QDI6580DP support
      pata_legacy: fix access to control register for QDI6580
      pata_legacy: add pointers to QDI65x0 documentation
      pata_marvell: fix marvell_pre_reset() documentation
      pata_ns87415: Power Management fix
      pata_radisys: fix UDMA handling
      pata_rz1000: Power Management fix
      pata_sis: Power Management fix
      pata_via: clear UDMA transfer mode bit for PIO and MWDMA
      [libata] MWDMA0 is unsupported on PIIX-like PATA controllers
      pata_it8213: MWDMA0 is unsupported
      pata_hpt3x2n: fix overclocked MWDMA0 timing

Benjamin Herrenschmidt (1):
      libata/sff: Use ops->bmdma_stop instead of ata_bmdma_stop()

Christoph Hellwig (1):
      libata: add translation for SCSI WRITE SAME (aka TRIM support)

Jiri Slaby (1):
      pata_via: fix double put on isa bridge

Krzysztof Halasa (1):
      pata_cs5536: use 32-bit BM DMA template instead of 16-bit.

Mark Nelson (1):
      ahci: let users know that Promise PDC42819 support is limited to SATA devices

Martin K. Petersen (2):
      libata: Report zeroed read after TRIM and max discard size
      libata: Clarify ata_set_lba_range_entries function

Matthew Garrett (1):
      ata: Don't require newlines for link_power_management_policy

Otavio Salvador (1):
      pata-it821x: use PCI_DEVICE_ID_RDC_D1010 define

Robert Hancock (1):
      libata: remove experimental tag on PATA drivers

Sergei Shtylyov (3):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)
      pata_hpt366: fix timing register documentation
      ata: use pci_dev->revision

Shaohua Li (1):
      ahci: disable SNotification capability for ich8

Tejun Heo (2):
      libata-acpi: missing _SDD is not an error
      libata: retry failed FLUSH if device didn't fail it

Thiago Farina (1):
      sata_mv: Clean up hard coded array size calculation.

Vivek Mahajan (1):
      sata_sil24: MSI support, disabled by default

ashish kalra (1):
      sata_fsl: Add asynchronous notification support

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index f2df6e2..676f08b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -374,8 +374,8 @@ config PATA_HPT366
 	  If unsure, say N.
 
 config PATA_HPT37X
-	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "HPT 370/370A/371/372/374/302 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -383,8 +383,8 @@ config PATA_HPT37X
 	  If unsure, say N.
 
 config PATA_HPT3X2N
-	tristate "HPT 372N/302N PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "HPT 372N/302N PATA support"
+	depends on PCI
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -401,7 +401,7 @@ config PATA_HPT3X3
 	  If unsure, say N.
 
 config PATA_HPT3X3_DMA
-	bool "HPT 343/363 DMA support (Experimental)"
+	bool "HPT 343/363 DMA support"
 	depends on PATA_HPT3X3
 	help
 	  This option enables DMA support for the HPT343/363
@@ -510,8 +510,8 @@ config PATA_NETCELL
 	  If unsure, say N.
 
 config PATA_NINJA32
-	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Ninja32/Delkin Cardbus ATA support"
+	depends on PCI
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
@@ -573,6 +573,14 @@ config PATA_PCMCIA
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on PCI
+	help
+	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support"
 	depends on PCI
@@ -643,14 +651,6 @@ config PATA_SERVERWORKS
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
-	depends on PCI
-	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
-
-	  If unsure, say N.
-
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
 	depends on PCI
@@ -667,6 +667,15 @@ config PATA_SIS
 
 	  If unsure, say N.
 
+config PATA_TOSHIBA
+	tristate "Toshiba Piccolo support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  Support for the Toshiba Piccolo controllers. Currently only the
+	  primary channel is supported by this driver.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 01e126f..d909435 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
 obj-$(CONFIG_PATA_SIL680)	+= pata_sil680.o
+obj-$(CONFIG_PATA_TOSHIBA)	+= pata_piccolo.o
 obj-$(CONFIG_PATA_VIA)		+= pata_via.o
 obj-$(CONFIG_PATA_WINBOND)	+= pata_sl82c105.o
 obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a3241a1..b8bea10 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -113,6 +113,7 @@ enum {
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
 	board_ahci_yesncq	= 8,
+	board_ahci_nosntf	= 9,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -235,6 +236,7 @@ enum {
 	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
 	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
 							link offline */
+	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
 
 	/* ap->flags bits */
 
@@ -508,7 +510,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_yesncq */
+	[board_ahci_yesncq] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
@@ -516,6 +518,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_nosntf] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -531,7 +541,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x2683), board_ahci }, /* ESB2 */
 	{ PCI_VDEVICE(INTEL, 0x27c6), board_ahci }, /* ICH7-M DH */
 	{ PCI_VDEVICE(INTEL, 0x2821), board_ahci }, /* ICH8 */
-	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci }, /* ICH8 */
+	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci_nosntf }, /* ICH8 */
 	{ PCI_VDEVICE(INTEL, 0x2824), board_ahci }, /* ICH8 */
 	{ PCI_VDEVICE(INTEL, 0x2829), board_ahci }, /* ICH8M */
 	{ PCI_VDEVICE(INTEL, 0x282a), board_ahci }, /* ICH8M */
@@ -849,6 +859,12 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_PMP;
 	}
 
+	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do SNTF, turning off CAP_SNTF\n");
+		cap &= ~HOST_CAP_SNTF;
+	}
+
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
 	    port_map != 1) {
 		dev_printk(KERN_INFO, &pdev->dev,
@@ -2988,6 +3004,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
 		return -ENODEV;
 
+	/* Promise's PDC42819 is a SAS/SATA controller that has an AHCI mode.
+	 * At the moment, we can only use the AHCI mode. Let the users know
+	 * that for SAS drives they're out of luck.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_PROMISE)
+		dev_printk(KERN_INFO, &pdev->dev, "PDC42819 "
+			   "can only drive SATA devices with this driver\n");
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index ecfd22b..12e26c3 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -168,9 +168,12 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
-	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
+#if !defined(CONFIG_PATA_TOSHIBA) && !defined(CONFIG_PATA_TOSHIBA_MODULE)
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
+#endif	
 	/* Must come last. If you add entries adjust this table appropriately */
 	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
 	{ 0, },
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..0c6155f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -869,10 +869,10 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 				(timings[pio][1] << 8);
 		}
 
-		if (ap->udma_mask) {
+		if (ap->udma_mask)
 			udma_enable &= ~(1 << devid);
-			pci_write_config_word(dev, master_port, master_data);
-		}
+
+		pci_write_config_word(dev, master_port, master_data);
 	}
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b0882cd..1245838 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -807,12 +807,11 @@ static int ata_acpi_exec_tfs(struct ata_device *dev, int *nr_executed)
  * EH context.
  *
  * RETURNS:
- * 0 on success, -errno on failure.
+ * 0 on success, -ENOENT if _SDD doesn't exist, -errno on failure.
  */
 static int ata_acpi_push_id(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
-	int err;
 	acpi_status status;
 	struct acpi_object_list input;
 	union acpi_object in_params[1];
@@ -835,12 +834,16 @@ static int ata_acpi_push_id(struct ata_device *dev)
 	status = acpi_evaluate_object(dev->acpi_handle, "_SDD", &input, NULL);
 	swap_buf_le16(dev->id, ATA_ID_WORDS);
 
-	err = ACPI_FAILURE(status) ? -EIO : 0;
-	if (err < 0)
+	if (status == AE_NOT_FOUND)
+		return -ENOENT;
+
+	if (ACPI_FAILURE(status)) {
 		ata_dev_printk(dev, KERN_WARNING,
 			       "ACPI _SDD failed (AE 0x%x)\n", status);
+		return -EIO;
+	}
 
-	return err;
+	return 0;
 }
 
 /**
@@ -971,7 +974,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	/* do _SDD if SATA */
 	if (acpi_sata) {
 		rc = ata_acpi_push_id(dev);
-		if (rc)
+		if (rc && rc != -ENOENT)
 			goto acpi_err;
 	}
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index dc72690..22ff51b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6616,6 +6616,13 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
+	/*
+	 * FIXME: In UP case, there is only one workqueue thread and if you
+	 * have more than one PIO device, latency is bloody awful, with
+	 * occasional multi-second "hiccups" as one PIO device waits for
+	 * another.  It's an ugly wart that users DO occasionally complain
+	 * about; luckily most users have at most one PIO polled device.
+	 */
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
 		goto free_force_tbl;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bba2ae5..0ea97c9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -110,6 +110,13 @@ static const unsigned long ata_eh_identify_timeouts[] = {
 	ULONG_MAX,
 };
 
+static const unsigned long ata_eh_flush_timeouts[] = {
+	15000,	/* be generous with flush */
+	15000,  /* ditto */
+	30000,	/* and even more generous */
+	ULONG_MAX,
+};
+
 static const unsigned long ata_eh_other_timeouts[] = {
 	 5000,	/* same rationale as identify timeout */
 	10000,	/* ditto */
@@ -147,6 +154,8 @@ ata_eh_cmd_timeout_table[ATA_EH_CMD_TIMEOUT_TABLE_SIZE] = {
 	  .timeouts = ata_eh_other_timeouts, },
 	{ .commands = CMDS(ATA_CMD_INIT_DEV_PARAMS),
 	  .timeouts = ata_eh_other_timeouts, },
+	{ .commands = CMDS(ATA_CMD_FLUSH, ATA_CMD_FLUSH_EXT),
+	  .timeouts = ata_eh_flush_timeouts },
 };
 #undef CMDS
 
@@ -3112,6 +3121,82 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 	return 0;
 }
 
+/**
+ *	ata_eh_maybe_retry_flush - Retry FLUSH if necessary
+ *	@dev: ATA device which may need FLUSH retry
+ *
+ *	If @dev failed FLUSH, it needs to be reported upper layer
+ *	immediately as it means that @dev failed to remap and already
+ *	lost at least a sector and further FLUSH retrials won't make
+ *	any difference to the lost sector.  However, if FLUSH failed
+ *	for other reasons, for example transmission error, FLUSH needs
+ *	to be retried.
+ *
+ *	This function determines whether FLUSH failure retry is
+ *	necessary and performs it if so.
+ *
+ *	RETURNS:
+ *	0 if EH can continue, -errno if EH needs to be repeated.
+ */
+static int ata_eh_maybe_retry_flush(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ata_queued_cmd *qc;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+	int rc = 0;
+
+	/* did flush fail for this device? */
+	if (!ata_tag_valid(link->active_tag))
+		return 0;
+
+	qc = __ata_qc_from_tag(ap, link->active_tag);
+	if (qc->dev != dev || (qc->tf.command != ATA_CMD_FLUSH_EXT &&
+			       qc->tf.command != ATA_CMD_FLUSH))
+		return 0;
+
+	/* if the device failed it, it should be reported to upper layers */
+	if (qc->err_mask & AC_ERR_DEV)
+		return 0;
+
+	/* flush failed for some other reason, give it another shot */
+	ata_tf_init(dev, &tf);
+
+	tf.command = qc->tf.command;
+	tf.flags |= ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+
+	ata_dev_printk(dev, KERN_WARNING, "retrying FLUSH 0x%x Emask 0x%x\n",
+		       tf.command, qc->err_mask);
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (!err_mask) {
+		/*
+		 * FLUSH is complete but there's no way to
+		 * successfully complete a failed command from EH.
+		 * Making sure retry is allowed at least once and
+		 * retrying it should do the trick - whatever was in
+		 * the cache is already on the platter and this won't
+		 * cause infinite loop.
+		 */
+		qc->scsicmd->allowed = max(qc->scsicmd->allowed, 1);
+	} else {
+		ata_dev_printk(dev, KERN_WARNING, "FLUSH failed Emask 0x%x\n",
+			       err_mask);
+		rc = -EIO;
+
+		/* if device failed it, report it to upper layers */
+		if (err_mask & AC_ERR_DEV) {
+			qc->err_mask |= AC_ERR_DEV;
+			qc->result_tf = tf;
+			if (!(ap->pflags & ATA_PFLAG_FROZEN))
+				rc = 0;
+		}
+	}
+	return rc;
+}
+
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
@@ -3455,6 +3540,15 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			}
 		}
 
+		/* retry flush if necessary */
+		ata_for_each_dev(dev, link, ALL) {
+			if (dev->class != ATA_DEV_ATA)
+				continue;
+			rc = ata_eh_maybe_retry_flush(dev);
+			if (rc)
+				goto dev_fail;
+		}
+
 		/* configure link power saving */
 		if (ehc->i.action & ATA_EH_LPM)
 			ata_for_each_dev(dev, link, ALL)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b4ee28d..62e6b9e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -47,6 +47,7 @@
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <asm/unaligned.h>
 
 #include "libata.h"
 
@@ -154,8 +155,7 @@ static ssize_t ata_scsi_lpm_put(struct device *dev,
 	 */
 	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
 		const int len = strlen(link_pm_policy[i].name);
-		if (strncmp(link_pm_policy[i].name, buf, len) == 0 &&
-		   buf[len] == '\n') {
+		if (strncmp(link_pm_policy[i].name, buf, len) == 0) {
 			policy = link_pm_policy[i].value;
 			break;
 		}
@@ -1964,6 +1964,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0x80,	/* page 0x80, unit serial no page */
 		0x83,	/* page 0x83, device ident page */
 		0x89,	/* page 0x89, ata info page */
+		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
 	};
 
@@ -2085,6 +2086,43 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
+{
+	u32 min_io_sectors;
+
+	rbuf[1] = 0xb0;
+	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
+
+	/*
+	 * Optimal transfer length granularity.
+	 *
+	 * This is always one physical block, but for disks with a smaller
+	 * logical than physical sector size we need to figure out what the
+	 * latter is.
+	 */
+	if (ata_id_has_large_logical_sectors(args->id))
+		min_io_sectors = ata_id_logical_per_physical_sectors(args->id);
+	else
+		min_io_sectors = 1;
+	put_unaligned_be16(min_io_sectors, &rbuf[6]);
+
+	/*
+	 * Optimal unmap granularity.
+	 *
+	 * The ATA spec doesn't even know about a granularity or alignment
+	 * for the TRIM command.  We can leave away most of the unmap related
+	 * VPD page entries, but we have specifify a granularity to signal
+	 * that we support some form of unmap - in thise case via WRITE SAME
+	 * with the unmap bit set.
+	 */
+	if (ata_id_has_trim(args->id)) {
+		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
+		put_unaligned_be32(1, &rbuf[28]);
+	}
+
+	return 0;
+}
+
 static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
 	int form_factor = ata_id_form_factor(args->id);
@@ -2374,6 +2412,13 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[13] = log_per_phys;
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
+
+		if (ata_id_has_trim(args->id)) {
+			rbuf[14] |= 0x80; /* TPE */
+
+			if (ata_id_has_zero_after_trim(args->id))
+				rbuf[14] |= 0x40; /* TPRZ */
+		}
 	}
 
 	return 0;
@@ -2896,6 +2941,58 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	const u8 *cdb = scmd->cmnd;
+	u64 block;
+	u32 n_block;
+	u32 size;
+	void *buf;
+
+	/* we may not issue DMA commands if no DMA mode is set */
+	if (unlikely(!dev->dma_mode))
+		goto invalid_fld;
+
+	if (unlikely(scmd->cmd_len < 16))
+		goto invalid_fld;
+	scsi_16_lba_len(cdb, &block, &n_block);
+
+	/* for now we only support WRITE SAME with the unmap bit set */
+	if (unlikely(!(cdb[1] & 0x8)))
+		goto invalid_fld;
+
+	/*
+	 * WRITE SAME always has a sector sized buffer as payload, this
+	 * should never be a multiple entry S/G list.
+	 */
+	if (!scsi_sg_count(scmd))
+		goto invalid_fld;
+
+	buf = page_address(sg_page(scsi_sglist(scmd)));
+	size = ata_set_lba_range_entries(buf, 512, block, n_block);
+
+	tf->protocol = ATA_PROT_DMA;
+	tf->hob_feature = 0;
+	tf->feature = ATA_DSM_TRIM;
+	tf->hob_nsect = (size / 512) >> 8;
+	tf->nsect = size / 512;
+	tf->command = ATA_CMD_DSM;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 |
+		     ATA_TFLAG_WRITE;
+
+	ata_qc_set_pc_nbytes(qc);
+
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x00);
+	/* "Invalid field in cdb" */
+	return 1;
+}
+
 /**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
@@ -2920,6 +3017,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case WRITE_16:
 		return ata_scsi_rw_xlat;
 
+	case 0x93 /*WRITE_SAME_16*/:
+		return ata_scsi_write_same_xlat;
+
 	case SYNCHRONIZE_CACHE:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
@@ -3109,6 +3209,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0x89:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
 			break;
+		case 0xb0:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b0);
+			break;
 		case 0xb1:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
 			break;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bbbb1fa..51eb1e2 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2384,7 +2384,7 @@ void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
 	ap->hsm_task_state = HSM_ST_IDLE;
 
 	if (ap->ioaddr.bmdma_addr)
-		ata_bmdma_stop(qc);
+		ap->ops->bmdma_stop(qc);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 }
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 1432dc9..9434114 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -453,7 +453,9 @@ static void ali_init_chipset(struct pci_dev *pdev)
 			/* Clear CD-ROM DMA write bit */
 			tmp &= 0x7F;
 		/* Cable and UDMA */
-		pci_write_config_byte(pdev, 0x4B, tmp | 0x09);
+		if (pdev->revision >= 0xc2)
+			tmp |= 0x01;
+		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
 		/*
 		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
 		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index f98dffe..dadfc35 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.5"
+#define DRV_VERSION "0.3.1"
 
 /*
  * CMD64x specific registers definition.
@@ -254,17 +254,109 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 }
 
 /**
- *	cmd646r1_dma_stop	-	DMA stop callback
+ *	cmd64x_bmdma_stop	-	DMA stop callback
  *	@qc: Command in progress
  *
- *	Stub for now while investigating the r1 quirk in the old driver.
+ *	Track the completion of live DMA commands and clear the
+ *	host->private_data DMA tracking flag as we do.
  */
 
-static void cmd646r1_bmdma_stop(struct ata_queued_cmd *qc)
+static void cmd64x_bmdma_stop(struct ata_queued_cmd *qc)
 {
+	struct ata_port *ap = qc->ap;
 	ata_bmdma_stop(qc);
+	WARN_ON(ap->host->private_data != ap);
+	ap->host->private_data = NULL;
 }
 
+/**
+ *	cmd64x_qc_defer		-	Defer logic for chip limits
+ *	@qc: queued command
+ *
+ *	Decide whether we can issue the command. Called under the host lock.
+ */
+
+static int cmd64x_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+	int dma = 0;
+
+	/* Apply the ATA rules first */
+	rc = ata_std_qc_defer(qc);
+	if (rc)
+		return rc;
+
+	if (qc->tf.protocol == ATAPI_PROT_DMA ||
+			qc->tf.protocol == ATA_PROT_DMA)
+		dma = 1;
+
+	/* If the other port is not live then issue the command */
+	if (alt == NULL || !alt->qc_active) {
+		if (dma)
+			host->private_data = qc->ap;
+		return 0;
+	}
+	/* If there is a live DMA command then wait */
+	if (host->private_data != NULL)
+		return 	ATA_DEFER_PORT;
+	if (dma)
+		/* Cannot overlap our DMA command */
+		return ATA_DEFER_PORT;
+	return 0;
+}
+
+/**
+ *	cmd64x_interrupt - ATA host interrupt handler
+ *	@irq: irq line (unused)
+ *	@dev_instance: pointer to our ata_host information structure
+ *
+ *	Our interrupt handler for PCI IDE devices.  Calls
+ *	ata_sff_host_intr() for each port that is flagging an IRQ. We cannot
+ *	use the defaults as we need to avoid touching status/altstatus during
+ *	a DMA.
+ *
+ *	LOCKING:
+ *	Obtains host lock during operation.
+ *
+ *	RETURNS:
+ *	IRQ_NONE or IRQ_HANDLED.
+ */
+irqreturn_t cmd64x_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+	static const u8 irq_reg[2] = { CFR, ARTTIM23 };
+	static const u8 irq_mask[2] = { 1 << 2, 1 << 4 };
+
+	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
+	spin_lock_irqsave(&host->lock, flags);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+		u8 reg;
+
+		pci_read_config_byte(pdev, irq_reg[i], &reg);
+		ap = host->ports[i];
+		if (ap && (reg & irq_mask[i]) &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_queued_cmd *qc;
+
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+			    (qc->flags & ATA_QCFLAG_ACTIVE))
+				handled |= ata_sff_host_intr(ap, qc);
+		}
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
 static struct scsi_host_template cmd64x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -273,6 +365,8 @@ static const struct ata_port_operations cmd64x_base_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.set_piomode	= cmd64x_set_piomode,
 	.set_dmamode	= cmd64x_set_dmamode,
+	.bmdma_stop	= cmd64x_bmdma_stop,
+	.qc_defer	= cmd64x_qc_defer,
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
@@ -282,7 +376,6 @@ static struct ata_port_operations cmd64x_port_ops = {
 
 static struct ata_port_operations cmd646r1_port_ops = {
 	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd646r1_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 };
 
@@ -290,12 +383,11 @@ static struct ata_port_operations cmd648_port_ops = {
 	.inherits	= &cmd64x_base_ops,
 	.bmdma_stop	= cmd648_bmdma_stop,
 	.cable_detect	= cmd648_cable_detect,
+	.qc_defer	= ata_std_qc_defer
 };
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	u32 class_rev;
-
 	static const struct ata_port_info cmd_info[6] = {
 		{	/* CMD 643 - no UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
@@ -340,40 +432,43 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
 	u8 mrdmode;
 	int rc;
+	struct ata_host *host;
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
-	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xFF;
-
 	if (id->driver_data == 0)	/* 643 */
 		ata_pci_bmdma_clear_simplex(pdev);
 
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
-		if (class_rev > 4)
+		if (pdev->revision > 4)
 			ppi[0] = &cmd_info[2];
 		/* Early rev with other problems ? */
-		else if (class_rev == 1)
+		else if (pdev->revision == 1)
 			ppi[0] = &cmd_info[3];
 	}
 
+
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
 	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
 	mrdmode &= ~ 0x30;	/* IRQ set up */
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
-	/* Force PIO 0 here.. */
-
 	/* PPC specific fixup copied from old driver */
 #ifdef CONFIG_PPC
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	/* We use this pointer to track the AP which has DMA running */
+	host->private_data = NULL;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
+	pci_set_master(pdev);
+	return ata_pci_sff_activate_host(host, cmd64x_interrupt, &cmd64x_sht);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 0df83cf..95ebdac 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -90,48 +90,12 @@ static void cs5520_set_timings(struct ata_port *ap, struct ata_device *adev, int
 }
 
 /**
- *	cs5520_enable_dma	-	turn on DMA bits
- *
- *	Turn on the DMA bits for this disk. Needed because the BIOS probably
- *	has not done the work for us. Belongs in the core SATA code.
- */
-
-static void cs5520_enable_dma(struct ata_port *ap, struct ata_device *adev)
-{
-	/* Set the DMA enable/disable flag */
-	u8 reg = ioread8(ap->ioaddr.bmdma_addr + 0x02);
-	reg |= 1<<(adev->devno + 5);
-	iowrite8(reg, ap->ioaddr.bmdma_addr + 0x02);
-}
-
-/**
- *	cs5520_set_dmamode	-	program DMA timings
- *	@ap: ATA port
- *	@adev: ATA device
- *
- *	Program the DMA mode timings for the controller according to the pio
- *	clocking table. Note that this device sets the DMA timings to PIO
- *	mode values. This may seem bizarre but the 5520 architecture talks
- *	PIO mode to the disk and DMA mode to the controller so the underlying
- *	transfers are PIO timed.
- */
-
-static void cs5520_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const int dma_xlate[3] = { XFER_PIO_0, XFER_PIO_3, XFER_PIO_4 };
-	cs5520_set_timings(ap, adev, dma_xlate[adev->dma_mode]);
-	cs5520_enable_dma(ap, adev);
-}
-
-/**
  *	cs5520_set_piomode	-	program PIO timings
  *	@ap: ATA port
  *	@adev: ATA device
  *
  *	Program the PIO mode timings for the controller according to the pio
- *	clocking table. We know pio_mode will equal dma_mode because of the
- *	CS5520 architecture. At least once we turned DMA on and wrote a
- *	mode setter.
+ *	clocking table.
  */
 
 static void cs5520_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -149,7 +113,6 @@ static struct ata_port_operations cs5520_port_ops = {
 	.qc_prep		= ata_sff_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
-	.set_dmamode		= cs5520_set_dmamode,
 };
 
 static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 6da4cb4..ffee397 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -224,7 +224,7 @@ static struct scsi_host_template cs5536_sht = {
 };
 
 static struct ata_port_operations cs5536_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= cs5536_cable_detect,
 	.set_piomode		= cs5536_set_piomode,
 	.set_dmamode		= cs5536_set_dmamode,
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 2a6412f..b2e71e6 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -2,6 +2,7 @@
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
  *	(C) 2005 Red Hat
+ *	(C) 2009 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -118,12 +119,12 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= 0x0F << shift;
+		slave_data &= ap->port_no ? 0x0F : 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
@@ -200,7 +201,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= ap->port_no ? 0x0F : 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
@@ -251,7 +252,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index d7f2da1..0bd48e8 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.2"
+#define DRV_VERSION	"0.6.7"
 
 struct hpt_clock {
 	u8	xfer_mode;
@@ -36,24 +36,22 @@ struct hpt_clock {
 
 /* key for bus clock timings
  * bit
- * 0:3    data_high_time. inactive time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 4:8    data_low_time. active time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 9:12   cmd_high_time. inactive time of DIOW_/DIOR_ during task file
+ * 0:3    data_high_time. Inactive time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 4:7    data_low_time. Active time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 8:11   cmd_high_time. Inactive time of DIOW_/DIOR_ during task file
  *        register access.
- * 13:17  cmd_low_time. active time of DIOW_/DIOR_ during task file
+ * 12:15  cmd_low_time. Active time of DIOW_/DIOR_ during task file
  *        register access.
- * 18:21  udma_cycle_time. clock freq and clock cycles for UDMA xfer.
- *        during task file register access.
- * 22:24  pre_high_time. time to initialize 1st cycle for PIO and MW DMA
- *        xfer.
- * 25:27  cmd_pre_high_time. time to initialize 1st PIO cycle for task
+ * 16:18  udma_cycle_time. Clock cycles for UDMA xfer?
+ * 19:21  pre_high_time. Time to initialize 1st cycle for PIO and MW DMA xfer.
+ * 22:24  cmd_pre_high_time. Time to initialize 1st PIO cycle for task file
  *        register access.
- * 28     UDMA enable
- * 29     DMA enable
- * 30     PIO_MST enable. if set, the chip is in bus master mode during
- *        PIO.
+ * 28     UDMA enable.
+ * 29     DMA  enable.
+ * 30     PIO_MST enable. If set, the chip is in bus master mode during
+ *        PIO xfer.
  * 31     FIFO enable.
  */
 
@@ -344,7 +342,6 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { &info_hpt366, NULL };
 
 	void *hpriv = NULL;
-	u32 class_rev;
 	u32 reg1;
 	int rc;
 
@@ -352,13 +349,10 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xFF;
-
 	/* May be a later chip in disguise. Check */
 	/* Newer chips are not in the HPT36x driver. Ignore them */
-	if (class_rev > 2)
-			return -ENODEV;
+	if (dev->revision > 2)
+		return -ENODEV;
 
 	hpt36x_init_chipset(dev);
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index d0a7df2..4224cfc 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.12"
+#define DRV_VERSION	"0.6.14"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -303,72 +303,79 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 }
 
 /**
- *	hpt37x_pre_reset	-	reset the hpt37x bus
- *	@link: ATA link to reset
- *	@deadline: deadline jiffies for the operation
+ *	hpt37x_cable_detect	-	Detect the cable type
+ *	@ap: ATA port to detect on
  *
- *	Perform the initial reset handling for the 370/372 and 374 func 0
+ *	Return the cable type attached to this port
  */
 
-static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
+static int hpt37x_cable_detect(struct ata_port *ap)
 {
-	u8 scr2, ata66;
-	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static const struct pci_bits hpt37x_enable_bits[] = {
-		{ 0x50, 1, 0x04, 0x04 },
-		{ 0x54, 1, 0x04, 0x04 }
-	};
-	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
-		return -ENOENT;
+	u8 scr2, ata66;
 
 	pci_read_config_byte(pdev, 0x5B, &scr2);
 	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
+
+	udelay(10); /* debounce */
+
 	/* Cable register now active */
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Restore state */
 	pci_write_config_byte(pdev, 0x5B, scr2);
 
 	if (ata66 & (2 >> ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
 	else
-		ap->cbl = ATA_CBL_PATA80;
-
-	/* Reset the state machine */
-	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
-	udelay(100);
-
-	return ata_sff_prereset(link, deadline);
+		return ATA_CBL_PATA80;
 }
 
-static int hpt374_fn1_pre_reset(struct ata_link *link, unsigned long deadline)
+/**
+ *	hpt374_fn1_cable_detect	-	Detect the cable type
+ *	@ap: ATA port to detect on
+ *
+ *	Return the cable type attached to this port
+ */
+
+static int hpt374_fn1_cable_detect(struct ata_port *ap)
 {
-	static const struct pci_bits hpt37x_enable_bits[] = {
-		{ 0x50, 1, 0x04, 0x04 },
-		{ 0x54, 1, 0x04, 0x04 }
-	};
-	u16 mcr3;
-	u8 ata66;
-	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int mcrbase = 0x50 + 4 * ap->port_no;
-
-	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
-		return -ENOENT;
+	u16 mcr3;
+	u8 ata66;
 
 	/* Do the extra channel work */
 	pci_read_config_word(pdev, mcrbase + 2, &mcr3);
-	/* Set bit 15 of 0x52 to enable TCBLID as input
-	 */
+	/* Set bit 15 of 0x52 to enable TCBLID as input */
 	pci_write_config_word(pdev, mcrbase + 2, mcr3 | 0x8000);
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Reset TCBLID/FCBLID to output */
 	pci_write_config_word(pdev, mcrbase + 2, mcr3);
 
 	if (ata66 & (2 >> ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
 	else
-		ap->cbl = ATA_CBL_PATA80;
+		return ATA_CBL_PATA80;
+}
+
+/**
+ *	hpt37x_pre_reset	-	reset the hpt37x bus
+ *	@link: ATA link to reset
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Perform the initial reset handling for the HPT37x.
+ */
+
+static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const struct pci_bits hpt37x_enable_bits[] = {
+		{ 0x50, 1, 0x04, 0x04 },
+		{ 0x54, 1, 0x04, 0x04 }
+	};
+	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
+		return -ENOENT;
 
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
@@ -404,9 +411,8 @@ static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->pio_mode);
-	mode &= ~0x8000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -423,8 +429,7 @@ static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -436,11 +441,12 @@ static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast |= 0x01;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->dma_mode);
-	mode |= 0x8000000;	/* FIFO in MWDMA or UDMA */
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -508,9 +514,8 @@ static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	mode = hpt37x_find_mode(ap, adev->pio_mode);
 
 	printk("Find mode for %d reports %X\n", adev->pio_mode, mode);
-	mode &= ~0x80000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -527,8 +532,7 @@ static void hpt372_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -539,12 +543,13 @@ static void hpt372_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->dma_mode);
 	printk("Find mode for DMA %d reports %X\n", adev->dma_mode, mode);
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	mode |= 0x80000000;	/* FIFO in MWDMA or UDMA */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -584,6 +589,7 @@ static struct ata_port_operations hpt370_port_ops = {
 	.bmdma_stop	= hpt370_bmdma_stop,
 
 	.mode_filter	= hpt370_filter,
+	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt370_set_piomode,
 	.set_dmamode	= hpt370_set_dmamode,
 	.prereset	= hpt37x_pre_reset,
@@ -608,6 +614,7 @@ static struct ata_port_operations hpt372_port_ops = {
 
 	.bmdma_stop	= hpt37x_bmdma_stop,
 
+	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt372_set_piomode,
 	.set_dmamode	= hpt372_set_dmamode,
 	.prereset	= hpt37x_pre_reset,
@@ -620,7 +627,8 @@ static struct ata_port_operations hpt372_port_ops = {
 
 static struct ata_port_operations hpt374_fn1_port_ops = {
 	.inherits	= &hpt372_port_ops,
-	.prereset	= hpt374_fn1_pre_reset,
+	.cable_detect	= hpt374_fn1_cable_detect,
+	.prereset	= hpt37x_pre_reset,
 };
 
 /**
@@ -791,9 +799,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	static const int MHz[4] = { 33, 40, 50, 66 };
 	void *private_data = NULL;
 	const struct ata_port_info *ppi[] = { NULL, NULL };
-
+	u8 rev = dev->revision;
 	u8 irqmask;
-	u32 class_rev;
 	u8 mcr1;
 	u32 freq;
 	int prefer_dpll = 1;
@@ -808,19 +815,16 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xFF;
-
 	if (dev->device == PCI_DEVICE_ID_TTI_HPT366) {
 		/* May be a later chip in disguise. Check */
 		/* Older chips are in the HPT366 driver. Ignore them */
-		if (class_rev < 3)
+		if (rev < 3)
 			return -ENODEV;
 		/* N series chips have their own driver. Ignore */
-		if (class_rev == 6)
+		if (rev == 6)
 			return -ENODEV;
 
-		switch(class_rev) {
+		switch(rev) {
 			case 3:
 				ppi[0] = &info_hpt370;
 				chip_table = &hpt370;
@@ -836,28 +840,29 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 				chip_table = &hpt372;
 				break;
 			default:
-				printk(KERN_ERR "pata_hpt37x: Unknown HPT366 subtype please report (%d).\n", class_rev);
+				printk(KERN_ERR "pata_hpt37x: Unknown HPT366 "
+				       "subtype, please report (%d).\n", rev);
 				return -ENODEV;
 		}
 	} else {
 		switch(dev->device) {
 			case PCI_DEVICE_ID_TTI_HPT372:
 				/* 372N if rev >= 2*/
-				if (class_rev >= 2)
+				if (rev >= 2)
 					return -ENODEV;
 				ppi[0] = &info_hpt372;
 				chip_table = &hpt372a;
 				break;
 			case PCI_DEVICE_ID_TTI_HPT302:
 				/* 302N if rev > 1 */
-				if (class_rev > 1)
+				if (rev > 1)
 					return -ENODEV;
 				ppi[0] = &info_hpt372;
 				/* Check this */
 				chip_table = &hpt302;
 				break;
 			case PCI_DEVICE_ID_TTI_HPT371:
-				if (class_rev > 1)
+				if (rev > 1)
 					return -ENODEV;
 				ppi[0] = &info_hpt372;
 				chip_table = &hpt371;
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 3d59fe0..9a09a1b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.4"
+#define DRV_VERSION	"0.3.7"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -80,14 +80,13 @@ static struct hpt_clock hpt3x2n_clocks[] = {
 
 	{	XFER_MW_DMA_2,	0x2c829c62	},
 	{	XFER_MW_DMA_1,	0x2c829c66	},
-	{	XFER_MW_DMA_0,	0x2c829d2c	},
+	{	XFER_MW_DMA_0,	0x2c829d2e	},
 
 	{	XFER_PIO_4,	0x0c829c62	},
 	{	XFER_PIO_3,	0x0c829c84	},
 	{	XFER_PIO_2,	0x0c829ca6	},
 	{	XFER_PIO_1,	0x0d029d26	},
 	{	XFER_PIO_0,	0x0d029d5e	},
-	{	0,		0x0d029d5e	}
 };
 
 /**
@@ -128,12 +127,15 @@ static int hpt3x2n_cable_detect(struct ata_port *ap)
 
 	pci_read_config_byte(pdev, 0x5B, &scr2);
 	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
+
+	udelay(10); /* debounce */
+
 	/* Cable register now active */
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Restore state */
 	pci_write_config_byte(pdev, 0x5B, scr2);
 
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & (2 >> ap->port_no))
 		return ATA_CBL_PATA40;
 	else
 		return ATA_CBL_PATA80;
@@ -185,9 +187,8 @@ static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt3x2n_find_mode(ap, adev->pio_mode);
-	mode &= ~0x8000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -204,8 +205,7 @@ static void hpt3x2n_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -216,11 +216,12 @@ static void hpt3x2n_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt3x2n_find_mode(ap, adev->dma_mode);
-	mode |= 0x8000000;	/* FIFO in MWDMA or UDMA */
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -447,10 +448,8 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt3x2n_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-
+	u8 rev = dev->revision;
 	u8 irqmask;
-	u32 class_rev;
-
 	unsigned int pci_mhz;
 	unsigned int f_low, f_high;
 	int adjust;
@@ -462,26 +461,23 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-	class_rev &= 0xFF;
-
 	switch(dev->device) {
 		case PCI_DEVICE_ID_TTI_HPT366:
-			if (class_rev < 6)
+			if (rev < 6)
 				return -ENODEV;
 			break;
 		case PCI_DEVICE_ID_TTI_HPT371:
-			if (class_rev < 2)
+			if (rev < 2)
 				return -ENODEV;
 			/* 371N if rev > 1 */
 			break;
 		case PCI_DEVICE_ID_TTI_HPT372:
 			/* 372N if rev >= 2*/
-			if (class_rev < 2)
+			if (rev < 2)
 				return -ENODEV;
 			break;
 		case PCI_DEVICE_ID_TTI_HPT302:
-			if (class_rev < 2)
+			if (rev < 2)
 				return -ENODEV;
 			break;
 		case PCI_DEVICE_ID_TTI_HPT372N:
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 7e31025..c86c716 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -255,8 +255,17 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 #ifdef CONFIG_PM
 static int hpt3x3_reinit_one(struct pci_dev *dev)
 {
+	struct ata_host *host = dev_get_drvdata(&dev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(dev);
+	if (rc)
+		return rc;
+
 	hpt3x3_init_chipset(dev);
-	return ata_pci_device_resume(dev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index f156da8..8f3325a 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -22,7 +22,7 @@
 #define DRV_VERSION	"0.0.3"
 
 /**
- *	it8213_pre_reset	-	check for 40/80 pin
+ *	it8213_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
@@ -92,18 +92,17 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 2)
-		control |= 1;	/* TIME1 enable */
+	if (pio > 1)
+		control |= 1;	/* TIME */
 	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
-		control |= 2;	/* IORDY enable */
+		control |= 2;	/* IE */
 	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
 	if (adev->class != ATA_DEV_ATA)
-		control |= 4;
+		control |= 4;	/* PPE */
 
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
-	/* Enable PPE, IE and TIME as appropriate */
-
+	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
 		idetm_data &= 0xCCF0;
 		idetm_data |= control;
@@ -112,17 +111,17 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	} else {
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= 0xF0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << 4;
+		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is enabled */
+	idetm_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, idetm_port, idetm_data);
 }
 
@@ -173,10 +172,10 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 		udma_enable |= (1 << devid);
 
-		/* Load the UDMA mode number */
+		/* Load the UDMA cycle time */
 		pci_read_config_word(dev, 0x4A, &udma_timing);
 		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= (udma & 3) << (4 * devid);
+		udma_timing |= u_speed << (4 * devid);
 		pci_write_config_word(dev, 0x4A, udma_timing);
 
 		/* Load the clock selection */
@@ -211,7 +210,7 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
@@ -263,7 +262,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
 		.port_ops	= &it8213_ops,
 	};
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 188bc2f..edc5c1f 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -955,7 +955,7 @@ static int it821x_reinit_one(struct pci_dev *pdev)
 static const struct pci_device_id it821x[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), },
-	{ PCI_VDEVICE(RDC, 0x1010), },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6932e56..9df1ff7 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -25,6 +25,13 @@
  *		http://www.ryston.cz/petr/vlb/pdc20230b.html
  *		http://www.ryston.cz/petr/vlb/pdc20230c.html
  *		http://www.ryston.cz/petr/vlb/pdc20630.html
+ *	QDI65x0:
+ *		http://www.ryston.cz/petr/vlb/qd6500.html
+ *		http://www.ryston.cz/petr/vlb/qd6580.html
+ *
+ *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
+ *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
+ *	Samuel Thibault <samuel.thibault@ens-lyon.org>
  *
  *  Unsupported but docs exist:
  *	Appian/Adaptec AIC25VL01/Cirrus Logic PD7220
@@ -35,7 +42,7 @@
  *  the MPIIX where the tuning is PCI side but the IDE is "ISA side".
  *
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
- *  opti82c465mv/promise 20230c/20630/winbond83759A
+ *  opti82c465mv/promise 20230c/20630/qdi65x0/winbond83759A
  *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
@@ -672,7 +679,7 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(timing, ld_qdi->timing + 2 * ap->port_no);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
@@ -707,7 +714,7 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
@@ -787,6 +794,7 @@ static struct ata_port_operations qdi6580_port_ops = {
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6580dp_set_piomode,
+	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 2096fb7..950da39 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -58,7 +58,7 @@ static int marvell_pata_active(struct pci_dev *pdev)
 }
 
 /**
- *	marvell_pre_reset	-	check for 40/80 pin
+ *	marvell_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 773b159..061aa1c 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -325,6 +325,13 @@ static struct scsi_host_template ns87415_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
+static void ns87415_fixup(struct pci_dev *pdev)
+{
+	/* Select 512 byte sectors */
+	pci_write_config_byte(pdev, 0x55, 0xEE);
+	/* Select PIO0 8bit clocking */
+	pci_write_config_byte(pdev, 0x54, 0xB7);
+}
 
 /**
  *	ns87415_init_one - Register 87415 ATA PCI device with kernel services
@@ -371,10 +378,8 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	if (rc)
 		return rc;
 
-	/* Select 512 byte sectors */
-	pci_write_config_byte(pdev, 0x55, 0xEE);
-	/* Select PIO0 8bit clocking */
-	pci_write_config_byte(pdev, 0x54, 0xB7);
+	ns87415_fixup(pdev);
+
 	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
 }
 
@@ -384,6 +389,23 @@ static const struct pci_device_id ns87415_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
+#ifdef CONFIG_PM
+static int ns87415_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	ns87415_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_driver ns87415_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ns87415_pci_tbl,
@@ -391,7 +413,7 @@ static struct pci_driver ns87415_pci_driver = {
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
+	.resume			= ns87415_reinit_one,
 #endif
 };
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 84ac503..9a8687d 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -239,7 +239,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.port_ops	= &oldpiix_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
new file mode 100644
index 0000000..bfe0180
--- /dev/null
+++ b/drivers/ata/pata_piccolo.c
@@ -0,0 +1,140 @@
+/*
+ *  pata_piccolo.c - Toshiba Piccolo PATA/SATA controller driver.
+ *
+ *  This is basically an update to ata_generic.c to add Toshiba Piccolo support
+ *  then split out to keep ata_generic "clean".
+ *
+ *  Copyright 2005 Red Hat Inc, all rights reserved.
+ *
+ *  Elements from ide/pci/generic.c
+ *	    Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
+ *	    Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
+ *
+ *  May be copied or modified under the terms of the GNU General Public License
+ *
+ *  The timing data tables/programming info are courtesy of the NetBSD driver
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+
+#define DRV_NAME "pata_piccolo"
+#define DRV_VERSION "0.0.1"
+
+
+
+static void tosh_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u16 pio[6] = {	/* For reg 0x50 low word & E088 */
+		0x0566, 0x0433, 0x0311, 0x0201, 0x0200, 0x0100
+	};
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u16 conf;
+	pci_read_config_word(pdev, 0x50, &conf);
+	conf &= 0xE088;
+	conf |= pio[adev->pio_mode - XFER_PIO_0];
+	pci_write_config_word(pdev, 0x50, conf);
+}
+
+static void tosh_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 conf;
+	pci_read_config_dword(pdev, 0x5C, &conf);
+	conf &= 0x78FFE088;	/* Keep the other bits */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		int udma = adev->dma_mode - XFER_UDMA_0;
+		conf |= 0x80000000;
+		conf |= (udma + 2) << 28;
+		conf |= (2 - udma) * 0x111;	/* spread into three nibbles */
+	} else {
+		static const u32 mwdma[4] = {
+			0x0655, 0x0200, 0x0200, 0x0100
+		};
+		conf |= mwdma[adev->dma_mode - XFER_MW_DMA_0];
+	}
+	pci_write_config_dword(pdev, 0x5C, conf);
+}
+
+
+static struct scsi_host_template tosh_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations tosh_port_ops = {
+	.inherits	= &ata_bmdma_port_ops,
+	.cable_detect	= ata_cable_unknown,
+	.set_piomode	= tosh_set_piomode,
+	.set_dmamode	= tosh_set_dmamode
+};
+
+/**
+ *	ata_tosh_init		-	attach generic IDE
+ *	@dev: PCI device found
+ *	@id: match entry
+ *
+ *	Called each time a matching IDE interface is found. We check if the
+ *	interface is one we wish to claim and if so we perform any chip
+ *	specific hacks then let the ATA layer do the heavy lifting.
+ */
+
+static int ata_tosh_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	static const struct ata_port_info info = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO5,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
+		.port_ops = &tosh_port_ops
+	};
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	/* Just one port for the moment */
+	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL);
+}
+
+static struct pci_device_id ata_tosh[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
+	{ 0, },
+};
+
+static struct pci_driver ata_tosh_pci_driver = {
+	.name 		= DRV_NAME,
+	.id_table	= ata_tosh,
+	.probe 		= ata_tosh_init_one,
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= ata_pci_device_resume,
+#endif
+};
+
+static int __init ata_tosh_init(void)
+{
+	return pci_register_driver(&ata_tosh_pci_driver);
+}
+
+
+static void __exit ata_tosh_exit(void)
+{
+	pci_unregister_driver(&ata_tosh_pci_driver);
+}
+
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("Low level driver for Toshiba Piccolo ATA");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, ata_tosh);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(ata_tosh_init);
+module_exit(ata_tosh_exit);
+
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 4401b33..4fd25e7 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -139,9 +139,9 @@ static void radisys_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_byte(dev, 0x4A, &udma_mode);
 
 		if (adev->xfer_mode == XFER_UDMA_2)
-			udma_mode &= ~ (1 << adev->devno);
+			udma_mode &= ~(2 << (adev->devno * 4));
 		else /* UDMA 4 */
-			udma_mode |= (1 << adev->devno);
+			udma_mode |= (2 << (adev->devno * 4));
 
 		pci_write_config_byte(dev, 0x4A, udma_mode);
 
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index c843a1e..237a24d 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -284,7 +284,7 @@ static struct ata_port_info rdc_port_info = {
 
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
-	.mwdma_mask	= ATA_MWDMA2,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &rdc_pata_ops,
 };
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index a5e4dfe..2932998 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -105,11 +105,20 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 #ifdef CONFIG_PM
 static int rz1000_reinit_one(struct pci_dev *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
 	/* If this fails on resume (which is a "cant happen" case), we
 	   must stop as any progress risks data loss */
 	if (rz1000_fifo_disable(pdev))
 		panic("rz1000 fifo");
-	return ata_pci_device_resume(pdev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 4cb649d..a2ace48 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -212,13 +212,11 @@ static struct ata_port_operations sil680_port_ops = {
 
 static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 {
-	u32 class_rev	= 0;
 	u8 tmpbyte	= 0;
 
-        pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
-        class_rev &= 0xff;
         /* FIXME: double check */
-	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, (class_rev) ? 1 : 255);
+	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
+			      pdev->revision ? 1 : 255);
 
 	pci_write_config_byte(pdev, 0x80, 0x00);
 	pci_write_config_byte(pdev, 0x84, 0x00);
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 488e77b..8af0dc8 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -2,7 +2,7 @@
  *    pata_sis.c - SiS ATA driver
  *
  *	(C) 2005 Red Hat
- *	(C) 2007 Bartlomiej Zolnierkiewicz
+ *	(C) 2007,2009 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
@@ -252,24 +252,25 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	sis_133_set_piomode - Initialize host controller PATA PIO timings
+ *	sis_133_do_piomode - Initialize host controller PATA PIO/DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
  *	Set PIO mode for device, in host controller PCI config space. This
- *	function handles PIO set up for the later ATA133 devices.
+ *	function handles PIO set up for the later ATA133 devices. The same
+ *	timings are used for MWDMA.
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void sis_133_do_piomode(struct ata_port *ap, struct ata_device *adev,
+					int speed)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int port = 0x40;
 	u32 t1;
 	u32 reg54;
-	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u32 timing133[] = {
 		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
@@ -305,6 +306,42 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	sis_133_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring for.
+ *
+ *	Set PIO mode for device, in host controller PCI config space. This
+ *	function handles PIO set up for the later ATA133 devices.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
+{
+
+	sis_133_do_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+}
+
+/**
+ *	mwdma_clip_to_pio		-	clip MWDMA mode
+ *	@adev: device
+ *
+ *	As the SiS shared MWDMA and PIO timings we must program the equivalent
+ *	PIO timing for the MWDMA mode but we must not program one higher than
+ *	the permitted PIO timing of the device.
+ */
+
+static int mwdma_clip_to_pio(struct ata_device *adev)
+{
+	const int mwdma_to_pio[3] = {
+		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
+	};
+	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
+				adev->pio_mode - XFER_PIO_0);
+}
+
+/**
  *	sis_old_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -332,6 +369,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device */
+		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -372,6 +410,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device, bit 15 udma */
+		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -389,7 +428,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles UDMA66 and early UDMA100 devices.
+ *	Handles later UDMA100 devices.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -400,21 +439,25 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u8 timing;
+	u16 timing;
 
-	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
+	const u16 udma_bits[]  = {
+		0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
 
-	pci_read_config_byte(pdev, drive_pci + 1, &timing);
+	pci_read_config_word(pdev, drive_pci, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
+		speed = mwdma_clip_to_pio(adev);
+		timing &= ~0x80FF;
+		timing |= mwdma_bits[speed];
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F;
+		timing &= ~0x8F00;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_byte(pdev, drive_pci + 1, timing);
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -434,21 +477,26 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u8 timing;
-	/* Low 4 bits are timing */
-	static const u8 udma_bits[]  = { 0x8F, 0x8A, 0x87, 0x85, 0x83, 0x82, 0x81};
+	u16 timing;
+	/* Bits 15-12  are timing */
+	static const u16 udma_bits[]  = {
+		0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100
+	};
+	static const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
 
-	pci_read_config_byte(pdev, drive_pci + 1, &timing);
+	pci_read_config_word(pdev, drive_pci, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
+		speed = mwdma_clip_to_pio(adev);
+		timing &= ~0x80FF;
+		timing = mwdma_bits[speed];
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F;
+		timing &= ~0x8F00;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_byte(pdev, drive_pci + 1, timing);
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -479,13 +527,12 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (reg54 & 0x40000000)
 		port = 0x70;
 	port += (8 * ap->port_no) +  (4 * adev->devno);
-
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		t1 &= ~0x00000004;
-		/* FIXME: need data sheet to add MWDMA here. Also lacking on
-		   ide/pci driver */
+		speed = mwdma_clip_to_pio(adev);
+		sis_133_do_piomode(ap, adev, speed);
+		t1 &= ~4;	/* UDMA off */
 	} else {
 		speed = adev->dma_mode - XFER_UDMA_0;
 		/* if & 8 no UDMA133 - need info for ... */
@@ -829,6 +876,23 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset);
 }
 
+#ifdef CONFIG_PM
+static int sis_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	sis_fixup(pdev, host->private_data);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x5513), },	/* SiS 5513 */
 	{ PCI_VDEVICE(SI, 0x5518), },	/* SiS 5518 */
@@ -844,7 +908,7 @@ static struct pci_driver sis_pci_driver = {
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
+	.resume			= sis_reinit_one,
 #endif
 };
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 88984b8..0d97890 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -303,14 +303,21 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type && t.udma) {
-		u8 cable80_status;
+	if (udma_type) {
+		u8 udma_etc;
 
-		/* Get 80-wire cable detection bit */
-		pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
-		cable80_status &= 0x10;
+		pci_read_config_byte(pdev, 0x50 + offset, &udma_etc);
 
-		pci_write_config_byte(pdev, 0x50 + offset, ut | cable80_status);
+		/* clear transfer mode bit */
+		udma_etc &= ~0x20;
+
+		if (t.udma) {
+			/* preserve 80-wire cable detection bit */
+			udma_etc &= 0x10;
+			udma_etc |= ut;
+		}
+
+		pci_write_config_byte(pdev, 0x50 + offset, udma_etc);
 	}
 }
 
@@ -337,6 +344,32 @@ static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	via_mode_filter		-	filter buggy device/mode pairs
+ *	@dev: ATA device
+ *	@mask: Mode bitmask
+ *
+ *	We need to apply some minimal filtering for old controllers and at least
+ *	one breed of Transcend SSD. Return the updated mask.
+ */
+
+static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
+{
+	struct ata_host *host = dev->link->ap->host;
+	const struct via_isa_bridge *config = host->private_data;
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+
+	if (config->id == PCI_DEVICE_ID_VIA_82C586_0) {
+		ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
+		if (strcmp(model_num, "TS64GSSD25-M") == 0) {
+			ata_dev_printk(dev, KERN_WARNING,
+	"disabling UDMA mode due to reported lockups with this device.\n");
+			mask &= ~ ATA_MASK_UDMA;
+		}
+	}
+	return ata_bmdma_mode_filter(dev, mask);
+}
+
+/**
  *	via_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
  *	@tf: ATA taskfile register set
@@ -427,6 +460,7 @@ static struct ata_port_operations via_port_ops = {
 	.prereset	= via_pre_reset,
 	.sff_tf_load	= via_tf_load,
 	.port_start	= via_port_start,
+	.mode_filter	= via_mode_filter,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
@@ -526,7 +560,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops
 	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
-	struct pci_dev *isa = NULL;
+	struct pci_dev *isa;
 	const struct via_isa_bridge *config;
 	static int printed_version;
 	u8 enable;
@@ -551,15 +585,13 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if ((isa = pci_get_device(PCI_VENDOR_ID_VIA +
 			!!(config->flags & VIA_BAD_ID),
 			config->id, NULL))) {
+			u8 rev = isa->revision;
+			pci_dev_put(isa);
 
-			if (isa->revision >= config->rev_min &&
-			    isa->revision <= config->rev_max)
+			if (rev >= config->rev_min && rev <= config->rev_max)
 				break;
-			pci_dev_put(isa);
 		}
 
-	pci_dev_put(isa);
-
 	if (!(config->flags & VIA_NO_ENABLES)) {
 		/* 0x40 low bits indicate enabled channels */
 		pci_read_config_byte(pdev, 0x40 , &enable);
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 172b57e..8a5d35b 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -34,7 +34,7 @@ enum {
 
 	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				ATA_FLAG_PMP | ATA_FLAG_NCQ),
+				ATA_FLAG_PMP | ATA_FLAG_NCQ | ATA_FLAG_AN),
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
 	SATA_FSL_CMD_HDR_SIZE	= 16,	/* 4 DWORDS */
@@ -132,7 +132,7 @@ enum {
 	INT_ON_SINGL_DEVICE_ERR = (1 << 1),
 	INT_ON_CMD_COMPLETE = 1,
 
-	INT_ON_ERROR = INT_ON_FATAL_ERR |
+	INT_ON_ERROR = INT_ON_FATAL_ERR | INT_ON_SNOTIFY_UPDATE |
 	    INT_ON_PHYRDY_CHG | INT_ON_SINGL_DEVICE_ERR,
 
 	/*
@@ -153,7 +153,7 @@ enum {
 	IE_ON_CMD_COMPLETE = 1,
 
 	DEFAULT_PORT_IRQ_ENABLE_MASK = IE_ON_FATAL_ERR | IE_ON_PHYRDY_CHG |
-	    IE_ON_SIGNATURE_UPDATE |
+	    IE_ON_SIGNATURE_UPDATE | IE_ON_SNOTIFY_UPDATE |
 	    IE_ON_SINGL_DEVICE_ERR | IE_ON_CMD_COMPLETE,
 
 	EXT_INDIRECT_SEG_PRD_FLAG = (1 << 31),
@@ -992,9 +992,8 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	 */
 
 	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
-	if (unlikely(SError & 0xFFFF0000)) {
+	if (unlikely(SError & 0xFFFF0000))
 		sata_fsl_scr_write(&ap->link, SCR_ERROR, SError);
-	}
 
 	DPRINTK("error_intr,hStat=0x%x,CE=0x%x,DE =0x%x,SErr=0x%x\n",
 		hstatus, cereg, ioread32(hcr_base + DE), SError);
@@ -1007,6 +1006,10 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 		freeze = 1;
 	}
 
+	/* Handle SDB FIS receive & notify update */
+	if (hstatus & INT_ON_SNOTIFY_UPDATE)
+		sata_async_notification(ap);
+
 	/* Handle PHYRDY change notification */
 	if (hstatus & INT_ON_PHYRDY_CHG) {
 		DPRINTK("SATA FSL: PHYRDY change indication\n");
@@ -1070,9 +1073,9 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	}
 
 	/* record error info */
-	if (qc) {
+	if (qc)
 		qc->err_mask |= err_mask;
-	} else
+	else
 		ehi->err_mask |= err_mask;
 
 	ehi->action |= action;
@@ -1103,7 +1106,6 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 	if (unlikely(SError & 0xFFFF0000)) {
 		DPRINTK("serror @host_intr : 0x%x\n", SError);
 		sata_fsl_error_intr(ap);
-
 	}
 
 	if (unlikely(hstatus & INT_ON_ERROR)) {
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 6f5093b..a8a7be0 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
 	int err = 0;
 
 	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
-	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
+	err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
 	if (err)
 		return err;
 
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index e6946fc..1370df6 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -417,6 +417,10 @@ static struct ata_port_operations sil24_ops = {
 #endif
 };
 
+static int sata_sil24_msi;    /* Disable MSI */
+module_param_named(msi, sata_sil24_msi, bool, S_IRUGO);
+MODULE_PARM_DESC(msi, "Enable MSI (Default: false)");
+
 /*
  * Use bits 30-31 of port_flags to encode available port numbers.
  * Current maxium is 4.
@@ -1340,6 +1344,11 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	sil24_init_controller(host);
 
+	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
+		dev_printk(KERN_INFO, &pdev->dev, "Using MSI\n");
+		pci_intx(pdev, 0);
+	}
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, sil24_interrupt, IRQF_SHARED,
 				 &sil24_sht);
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 39d4e01..a743e68 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -162,9 +162,10 @@ static const struct pci_device_id generic_pci_tbl[] = {
 #ifdef CONFIG_BLK_DEV_IDE_SATA
 	{ PCI_VDEVICE(VIA,	PCI_DEVICE_ID_VIA_8237_SATA),		 5 },
 #endif
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO),		 4 },
 	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	 4 },
 	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),	 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),	 4 },
 	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		 6 },
 	/*
 	 * Must come last.  If you add entries adjust
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 4fb3573..38a6948 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -75,6 +75,7 @@ enum {
 	ATA_ID_EIDE_DMA_TIME	= 66,
 	ATA_ID_EIDE_PIO		= 67,
 	ATA_ID_EIDE_PIO_IORDY	= 68,
+	ATA_ID_ADDITIONAL_SUPP	= 69,
 	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
 	ATA_ID_COMMAND_SET_1	= 82,
@@ -87,6 +88,7 @@ enum {
 	ATA_ID_HW_CONFIG	= 93,
 	ATA_ID_SPG		= 98,
 	ATA_ID_LBA_CAPACITY_2	= 100,
+	ATA_ID_SECTOR_SIZE	= 106,
 	ATA_ID_LAST_LUN		= 126,
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
@@ -638,6 +640,18 @@ static inline int ata_id_flush_ext_enabled(const u16 *id)
 	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
 }
 
+static inline int ata_id_has_large_logical_sectors(const u16 *id)
+{
+	if ((id[ATA_ID_SECTOR_SIZE] & 0xc000) != 0x4000)
+		return 0;
+	return id[ATA_ID_SECTOR_SIZE] & (1 << 13);
+}
+
+static inline u8 ata_id_logical_per_physical_sectors(const u16 *id)
+{
+	return id[ATA_ID_SECTOR_SIZE] & 0xf;
+}
+
 static inline int ata_id_has_lba48(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
@@ -803,6 +817,16 @@ static inline int ata_id_has_trim(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_zero_after_trim(const u16 *id)
+{
+	/* DSM supported, deterministic read, and read zero after trim set */
+	if (ata_id_has_trim(id) &&
+	    (id[ATA_ID_ADDITIONAL_SUPP] & 0x4020) == 0x4020)
+		return 1;
+
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -958,17 +982,17 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 }
 
 /*
- * Write up to 'max' LBA Range Entries to the buffer that will cover the
- * extent from sector to sector + count.  This is used for TRIM and for
- * ADD LBA(S) TO NV CACHE PINNED SET.
+ * Write LBA Range Entries to the buffer that will cover the extent from
+ * sector to sector + count.  This is used for TRIM and for ADD LBA(S)
+ * TO NV CACHE PINNED SET.
  */
-static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
-						u64 sector, unsigned long count)
+static inline unsigned ata_set_lba_range_entries(void *_buffer,
+		unsigned buf_size, u64 sector, unsigned long count)
 {
 	__le64 *buffer = _buffer;
-	unsigned i = 0;
+	unsigned i = 0, used_bytes;
 
-	while (i < max) {
+	while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
 		u64 entry = sector |
 			((u64)(count > 0xffff ? 0xffff : count) << 48);
 		buffer[i++] = __cpu_to_le64(entry);
@@ -978,9 +1002,9 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
 		sector += 0xffff;
 	}
 
-	max = ALIGN(i * 8, 512);
-	memset(buffer + i, 0, max - i * 8);
-	return max;
+	used_bytes = ALIGN(i * 8, 512);
+	memset(buffer + i, 0, used_bytes - i * 8);
+	return used_bytes;
 }
 
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 8769864..a5b3dc7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -365,7 +365,7 @@ enum {
 	/* This should match the actual table size of
 	 * ata_eh_cmd_timeout_table in libata-eh.c.
 	 */
-	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 5,
+	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 6,
 
 	/* Horkage types. May be set by libata or controller on drives
 	   (some horkage may be drive/controller pair dependant */
@@ -595,6 +595,7 @@ struct ata_device {
 	unsigned int		horkage;	/* List of broken features */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
+	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 84cf1f3..9ca483b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1496,9 +1496,10 @@
 #define PCI_DEVICE_ID_SBE_WANXL400	0x0104
 
 #define PCI_VENDOR_ID_TOSHIBA		0x1179
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0102
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_1	0x0103
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0105
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_1	0x0101
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0102
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_3	0x0103
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_5	0x0105
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC95	0x060a
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC97	0x060f
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC100	0x0617
