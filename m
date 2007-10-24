Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXJXBaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXJXBaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXJXBaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:30:06 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54121 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbXJXB37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:29:59 -0400
Date: Tue, 23 Oct 2007 21:29:58 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: [git patches] libata fixes and checkpatch cleanups
Message-ID: <20071024012958.GA16972@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c         |   26 +++---
 drivers/ata/ata_piix.c     |   29 +++---
 drivers/ata/libata-acpi.c  |   16 ++--
 drivers/ata/libata-core.c  |   69 +++++++------
 drivers/ata/libata-eh.c    |   14 ++--
 drivers/ata/libata-scsi.c  |  240 ++++++++++++++++++++++----------------------
 drivers/ata/libata-sff.c   |    2 +-
 drivers/ata/pata_ns87415.c |   10 +-
 drivers/ata/sata_mv.c      |   23 ++--
 drivers/ata/sata_nv.c      |   68 ++++++-------
 drivers/ata/sata_sx4.c     |    4 +-
 drivers/pci/quirks.c       |    2 +-
 include/linux/ata.h        |    6 +-
 include/linux/libata.h     |   22 ++--
 14 files changed, 265 insertions(+), 266 deletions(-)

Alan Cox (1):
      libata-core: auditting chk_status v check_status

Jeff Garzik (1):
      [libata] checkpatch-inspired cleanups

Tejun Heo (2):
      libata: add HTS542525K9SA00 to NCQ blacklist
      jmicron: update quirk for JMB361/3/5/6

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 47c8060..95229e7 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -227,7 +227,7 @@ struct ahci_port_priv {
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
-static int ahci_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static void ahci_irq_clear(struct ata_port *ap);
 static int ahci_port_start(struct ata_port *ap);
@@ -729,7 +729,7 @@ static int ahci_stop_engine(struct ata_port *ap)
 
 	/* wait for engine to stop. This could be as long as 500 msec */
 	tmp = ata_wait_register(port_mmio + PORT_CMD,
-			        PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
+				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
 	if (tmp & PORT_CMD_LIST_ON)
 		return -EIO;
 
@@ -1564,9 +1564,9 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	if (!irq_stat)
 		return IRQ_NONE;
 
-        spin_lock(&host->lock);
+	spin_lock(&host->lock);
 
-        for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap;
 
 		if (!(irq_stat & (1 << i)))
@@ -1829,9 +1829,9 @@ static int ahci_port_start(struct ata_port *ap)
 	pp->cmd_tbl_dma = mem_dma;
 
 	/*
- 	 * Save off initial list of interrupts to be enabled.
- 	 * This could be changed later
- 	 */
+	 * Save off initial list of interrupts to be enabled.
+	 * This could be changed later
+	 */
 	pp->intr_mask = DEF_PORT_IRQ;
 
 	ap->private_data = pp;
@@ -1918,12 +1918,12 @@ static void ahci_print_info(struct ata_host *host)
 	dev_printk(KERN_INFO, &pdev->dev,
 		"AHCI %02x%02x.%02x%02x "
 		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
-	       	,
+		,
 
-	       	(vers >> 24) & 0xff,
-	       	(vers >> 16) & 0xff,
-	       	(vers >> 8) & 0xff,
-	       	vers & 0xff,
+		(vers >> 24) & 0xff,
+		(vers >> 16) & 0xff,
+		(vers >> 8) & 0xff,
+		vers & 0xff,
 
 		((cap >> 8) & 0x1f) + 1,
 		(cap & 0x1f) + 1,
@@ -1935,7 +1935,7 @@ static void ahci_print_info(struct ata_host *host)
 		"flags: "
 		"%s%s%s%s%s%s%s"
 		"%s%s%s%s%s%s%s\n"
-	       	,
+		,
 
 		cap & (1 << 31) ? "64bit " : "",
 		cap & (1 << 30) ? "ncq " : "",
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3c6f43e..a4b2cb2 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -157,12 +157,12 @@ struct piix_host_priv {
 	const int *map;
 };
 
-static int piix_init_one (struct pci_dev *pdev,
-				    const struct pci_device_id *ent);
+static int piix_init_one(struct pci_dev *pdev,
+			 const struct pci_device_id *ent);
 static void piix_pata_error_handler(struct ata_port *ap);
-static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev);
-static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev);
-static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev);
+static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
+static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
+static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
@@ -650,9 +650,9 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 	while (lap->device) {
 		if (lap->device == pdev->device &&
 		    lap->subvendor == pdev->subsystem_vendor &&
-		    lap->subdevice == pdev->subsystem_device) {
+		    lap->subdevice == pdev->subsystem_device)
 			return ATA_CBL_PATA40_SHORT;
-		}
+
 		lap++;
 	}
 
@@ -699,7 +699,7 @@ static void piix_pata_error_handler(struct ata_port *ap)
  *	None (inherited from caller).
  */
 
-static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
@@ -786,7 +786,7 @@ static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	None (inherited from caller).
  */
 
-static void do_pata_set_dmamode (struct ata_port *ap, struct ata_device *adev, int isich)
+static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, int isich)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
@@ -813,7 +813,7 @@ static void do_pata_set_dmamode (struct ata_port *ap, struct ata_device *adev, i
 		int u_clock, u_speed;
 
 		/*
-	 	 * UDMA is handled by a combination of clock switching and
+		 * UDMA is handled by a combination of clock switching and
 		 * selection of dividers
 		 *
 		 * Handy rule: Odd modes are UDMATIMx 01, even are 02
@@ -905,7 +905,7 @@ static void do_pata_set_dmamode (struct ata_port *ap, struct ata_device *adev, i
  *	None (inherited from caller).
  */
 
-static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
+static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	do_pata_set_dmamode(ap, adev, 0);
 }
@@ -921,7 +921,7 @@ static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
  *	None (inherited from caller).
  */
 
-static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev)
+static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	do_pata_set_dmamode(ap, adev, 1);
 }
@@ -1106,8 +1106,7 @@ static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
 	u16 cfg;
 	int no_piix_dma = 0;
 
-	while((pdev = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454NX, pdev)) != NULL)
-	{
+	while ((pdev = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454NX, pdev)) != NULL) {
 		/* Look for 450NX PXB. Check for problem configurations
 		   A PCI quirk checks bit 6 already */
 		pci_read_config_word(pdev, 0x41, &cfg);
@@ -1241,7 +1240,7 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
  *	Zero on success, or -ERRNO value.
  */
 
-static int piix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3f75335..08a52dd 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -26,7 +26,7 @@
 #include <acpi/actypes.h>
 
 #define NO_PORT_MULT		0xffff
-#define SATA_ADR(root,pmp)	(((root) << 16) | (pmp))
+#define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
 
 #define REGS_PER_GTF		7
 struct ata_acpi_gtf {
@@ -96,8 +96,8 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 	}
 }
 
-static void ata_acpi_handle_hotplug (struct ata_port *ap, struct kobject *kobj,
-				     u32 event)
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
+				    u32 event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
@@ -114,7 +114,7 @@ static void ata_acpi_handle_hotplug (struct ata_port *ap, struct kobject *kobj,
 	}
 
 	if (kobj) {
-	        sprintf(event_string, "BAY_EVENT=%d", event);
+		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
 }
@@ -127,14 +127,14 @@ static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 	if (dev->sdev)
 		kobj = &dev->sdev->sdev_gendev.kobj;
 
-	ata_acpi_handle_hotplug (dev->link->ap, kobj, event);
+	ata_acpi_handle_hotplug(dev->link->ap, kobj, event);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug (ap, &ap->dev->kobj, event);
+	ata_acpi_handle_hotplug(ap, &ap->dev->kobj, event);
 }
 
 /**
@@ -398,11 +398,11 @@ int ata_acpi_cbl_80wire(struct ata_port *ap)
 {
 	struct ata_acpi_gtm gtm;
 	int valid = 0;
-	
+
 	/* No _GTM data, no information */
 	if (ata_acpi_gtm(ap, &gtm) < 0)
 		return 0;
-		
+
 	/* Split timing, DMA enabled */
 	if ((gtm.flags & 0x11) == 0x11 && gtm.drive[0].dma < 55)
 		valid |= 1;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 69092bc..2d147b5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -49,11 +49,11 @@
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
 #include <linux/scatterlist.h>
+#include <linux/io.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <asm/io.h>
 #include <asm/semaphore.h>
 #include <asm/byteorder.h>
 
@@ -93,7 +93,7 @@ int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
 MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
 
-static int ata_ignore_hpa = 0;
+static int ata_ignore_hpa;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
 MODULE_PARM_DESC(ignore_hpa, "Ignore HPA limit (0=keep BIOS limits, 1=ignore limits, using full disk)");
 
@@ -713,7 +713,7 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 	}
 
 	if ((tf->lbam == 0x3c) && (tf->lbah == 0xc3)) {
-		printk("ata: SEMB device ignored\n");
+		printk(KERN_INFO "ata: SEMB device ignored\n");
 		return ATA_DEV_SEMB_UNSUP; /* not yet */
 	}
 
@@ -939,7 +939,7 @@ static int ata_read_native_max_address(struct ata_device *dev, u64 *max_sectors)
 		*max_sectors = ata_tf_to_lba48(&tf);
 	else
 		*max_sectors = ata_tf_to_lba(&tf);
-        if (dev->horkage & ATA_HORKAGE_HPA_SIZE)
+	if (dev->horkage & ATA_HORKAGE_HPA_SIZE)
 		(*max_sectors)--;
 	return 0;
 }
@@ -1151,7 +1151,7 @@ void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown)
  *	LOCKING:
  *	caller.
  */
-void ata_noop_dev_select (struct ata_port *ap, unsigned int device)
+void ata_noop_dev_select(struct ata_port *ap, unsigned int device)
 {
 }
 
@@ -1171,7 +1171,7 @@ void ata_noop_dev_select (struct ata_port *ap, unsigned int device)
  *	caller.
  */
 
-void ata_std_dev_select (struct ata_port *ap, unsigned int device)
+void ata_std_dev_select(struct ata_port *ap, unsigned int device)
 {
 	u8 tmp;
 
@@ -1292,7 +1292,7 @@ static unsigned int ata_id_xfermask(const u16 *id)
 		 */
 		u8 mode = (id[ATA_ID_OLD_PIO_MODES] >> 8) & 0xFF;
 		if (mode < 5)	/* Valid PIO range */
-                	pio_mask = (2 << mode) - 1;
+			pio_mask = (2 << mode) - 1;
 		else
 			pio_mask = 1;
 
@@ -1693,7 +1693,7 @@ static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
  *	for pre-ATA4 drives.
  *
  *	FIXME: ATA_CMD_ID_ATA is optional for early drives and right
- *	now we abort if we hit that case. 
+ *	now we abort if we hit that case.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep)
@@ -1979,9 +1979,8 @@ int ata_dev_configure(struct ata_device *dev)
 					       "supports DRM functions and may "
 					       "not be fully accessable.\n");
 			snprintf(revbuf, 7, "CFA");
-		}
-		else
-			snprintf(revbuf, 7, "ATA-%d",  ata_id_major_version(id));
+		} else
+			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
 
 		dev->n_sectors = ata_id_n_sectors(id);
 
@@ -2110,7 +2109,7 @@ int ata_dev_configure(struct ata_device *dev)
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
 		   idiot */
-                if (print_info) {
+		if (print_info) {
 			ata_dev_printk(dev, KERN_WARNING,
 "Drive reports diagnostics failure. This may indicate a drive\n");
 			ata_dev_printk(dev, KERN_WARNING,
@@ -2667,8 +2666,8 @@ static const struct ata_timing ata_timing[] = {
 	{ 0xFF }
 };
 
-#define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
-#define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
+#define ENOUGH(v, unit)		(((v)-1)/(unit)+1)
+#define EZ(v, unit)		((v)?ENOUGH(v, unit):0)
 
 static void ata_timing_quantize(const struct ata_timing *t, struct ata_timing *q, int T, int UT)
 {
@@ -2695,7 +2694,7 @@ void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
 	if (what & ATA_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
 }
 
-static const struct ata_timing* ata_timing_find_mode(unsigned short speed)
+static const struct ata_timing *ata_timing_find_mode(unsigned short speed)
 {
 	const struct ata_timing *t;
 
@@ -2727,10 +2726,10 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 
 	if (adev->id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
-		if(speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
+		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
 			if (speed <= XFER_PIO_2) p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO];
 					    else p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO_IORDY];
-		} else if(speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2) {
+		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2) {
 			p.cycle = adev->id[ATA_ID_EIDE_DMA_MIN];
 		}
 		ata_timing_merge(&p, t, t, ATA_TIMING_CYCLE | ATA_TIMING_CYC8B);
@@ -2876,14 +2875,17 @@ static int ata_dev_set_mode(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_PIO;
 
 	err_mask = ata_dev_set_xfermode(dev);
+
 	/* Old CFA may refuse this command, which is just fine */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
-        	err_mask &= ~AC_ERR_DEV;
+		err_mask &= ~AC_ERR_DEV;
+
 	/* Some very old devices and some bad newer ones fail any kind of
 	   SET_XFERMODE request but support PIO0-2 timings and no IORDY */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && !ata_id_has_iordy(dev->id) &&
 			dev->pio_mode <= XFER_PIO_2)
 		err_mask &= ~AC_ERR_DEV;
+
 	if (err_mask) {
 		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
 			       "(err_mask=0x%x)\n", err_mask);
@@ -3265,7 +3267,7 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	 * the bus shows 0xFF because the odd clown forgets the D7
 	 * pulldown resistor.
 	 */
-	if (ata_check_status(ap) == 0xFF)
+	if (ata_chk_status(ap) == 0xFF)
 		return -ENODEV;
 
 	return ata_bus_post_reset(ap, devmask, deadline);
@@ -3943,7 +3945,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "SAMSUNG CD-ROM SC",	NULL,		ATA_HORKAGE_NODMA },
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
-	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
+	{ "SAMSUNG CD-ROM SN-124", "N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
 	{ "IOMEGA  ZIP 250       ATAPI       Floppy",
@@ -3959,7 +3961,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Devices where NCQ should be avoided */
 	/* NCQ is slow */
-        { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
+	{ "WDC WD740ADFD-00",	NULL,		ATA_HORKAGE_NONCQ },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
@@ -3979,6 +3981,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
 	{ "HDT722516DLA380",	"V43OA96A",	ATA_HORKAGE_NONCQ, },
 	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
+	{ "Hitachi HTS542525K9SA00", "BBFOC31P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
@@ -4106,7 +4109,7 @@ static void ata_dev_xfermask(struct ata_device *dev)
 	}
 
 	if ((host->flags & ATA_HOST_SIMPLEX) &&
-            host->simplex_claimed && host->simplex_claimed != ap) {
+	    host->simplex_claimed && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
 			       "other device, disabling DMA\n");
@@ -4128,11 +4131,11 @@ static void ata_dev_xfermask(struct ata_device *dev)
 	 */
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
-		if((ap->cbl == ATA_CBL_PATA40) ||
-   		    (ata_drive_40wire(dev->id) &&
-		     (ap->cbl == ATA_CBL_PATA_UNK ||
-                     ap->cbl == ATA_CBL_PATA80))) {
-		      	ata_dev_printk(dev, KERN_WARNING,
+		if ((ap->cbl == ATA_CBL_PATA40) ||
+		    (ata_drive_40wire(dev->id) &&
+		    (ap->cbl == ATA_CBL_PATA_UNK ||
+		     ap->cbl == ATA_CBL_PATA80))) {
+			ata_dev_printk(dev, KERN_WARNING,
 				 "limited to UDMA/33 due to 40-wire cable\n");
 			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		}
@@ -4395,7 +4398,7 @@ static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 		u32 addr, offset;
 		u32 sg_len, len, blen;
 
- 		/* determine if physical DMA addr spans 64K boundary.
+		/* determine if physical DMA addr spans 64K boundary.
 		 * Note h/w doesn't support 64-bit, so we unconditionally
 		 * truncate dma_addr_t to u32.
 		 */
@@ -4980,7 +4983,7 @@ next_sg:
 				       "%u bytes trailing data\n", bytes);
 
 		for (i = 0; i < words; i++)
-			ap->ops->data_xfer(qc->dev, (unsigned char*)pad_buf, 2, do_write);
+			ap->ops->data_xfer(qc->dev, (unsigned char *)pad_buf, 2, do_write);
 
 		ap->hsm_task_state = HSM_ST_LAST;
 		return;
@@ -5908,8 +5911,8 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
  *	One if interrupt was handled, zero if not (shared irq).
  */
 
-inline unsigned int ata_host_intr (struct ata_port *ap,
-				   struct ata_queued_cmd *qc)
+inline unsigned int ata_host_intr(struct ata_port *ap,
+				  struct ata_queued_cmd *qc)
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u8 status, host_stat = 0;
@@ -6009,7 +6012,7 @@ idle_irq:
  *	IRQ_NONE or IRQ_HANDLED.
  */
 
-irqreturn_t ata_interrupt (int irq, void *dev_instance)
+irqreturn_t ata_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
@@ -6212,7 +6215,7 @@ int ata_flush_cache(struct ata_device *dev)
 
 	/* This is wrong. On a failed flush we get back the LBA of the lost
 	   sector and we should (assuming it wasn't aborted as unknown) issue
-	   a further flush command to continue the writeback until it 
+	   a further flush command to continue the writeback until it
 	   does not error */
 	err_mask = ata_do_simple_cmd(dev, cmd);
 	if (err_mask) {
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 2eaa39f..93e2b54 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1197,7 +1197,7 @@ void ata_eh_done(struct ata_link *link, struct ata_device *dev,
  *	RETURNS:
  *	Descriptive string for @err_mask
  */
-static const char * ata_err_string(unsigned int err_mask)
+static const char *ata_err_string(unsigned int err_mask)
 {
 	if (err_mask & AC_ERR_HOST_BUS)
 		return "host bus error";
@@ -1934,7 +1934,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeq " : "",
 		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
 		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
-		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "" );
+		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
 
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		static const char *dma_str[] = {
@@ -1969,17 +1969,17 @@ static void ata_eh_link_report(struct ata_link *link)
 			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
 
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
-				    ATA_ERR) ) {
+				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
 				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { Busy }\n" );
+				  "status: { Busy }\n");
 			else
 				ata_dev_printk(qc->dev, KERN_ERR,
 				  "status: { %s%s%s%s}\n",
 				  res->command & ATA_DRDY ? "DRDY " : "",
 				  res->command & ATA_DF ? "DF " : "",
 				  res->command & ATA_DRQ ? "DRQ " : "",
-				  res->command & ATA_ERR ? "ERR " : "" );
+				  res->command & ATA_ERR ? "ERR " : "");
 		}
 
 		if (cmd->command != ATA_CMD_PACKET &&
@@ -1990,7 +1990,7 @@ static void ata_eh_link_report(struct ata_link *link)
 			  res->feature & ATA_ICRC ? "ICRC " : "",
 			  res->feature & ATA_UNC ? "UNC " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
-			  res->feature & ATA_ABORTED ? "ABRT " : "" );
+			  res->feature & ATA_ABORTED ? "ABRT " : "");
 	}
 }
 
@@ -2611,7 +2611,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		ehc->i.flags = 0;
 		continue;
 
-	dev_fail:
+dev_fail:
 		nr_failed_devs++;
 		if (ata_eh_handle_dev_fail(dev, rc))
 			nr_disabled_devs++;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5b758b9..f5d5420 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -45,7 +45,7 @@
 #include <scsi/scsi_transport.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "libata.h"
 
@@ -53,9 +53,9 @@
 
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
-static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
+static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
-static struct ata_device * ata_scsi_find_dev(struct ata_port *ap,
+static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
@@ -228,7 +228,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
-		                            block count in sector count field */
+					    block count in sector count field */
 		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
@@ -252,7 +252,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-	                          sensebuf, (10*HZ), 5, 0);
+				  sensebuf, (10*HZ), 5, 0);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
@@ -263,18 +263,18 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
-			                      &sshdr);
-			if (sshdr.sense_key==0 &&
-			    sshdr.asc==0 && sshdr.ascq==0)
+					     &sshdr);
+			if (sshdr.sense_key == 0 &&
+			    sshdr.asc == 0 && sshdr.ascq == 0)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
 		/* Send userspace a few ATA registers (same as drivers/ide) */
-		if (sensebuf[0] == 0x72 &&     /* format is "descriptor" */
-		    desc[0] == 0x09 ) {        /* code is "ATA Descriptor" */
-			args[0] = desc[13];    /* status */
-			args[1] = desc[3];     /* error */
-			args[2] = desc[5];     /* sector count (0:7) */
+		if (sensebuf[0] == 0x72 &&	/* format is "descriptor" */
+		    desc[0] == 0x09) {		/* code is "ATA Descriptor" */
+			args[0] = desc[13];	/* status */
+			args[1] = desc[3];	/* error */
+			args[2] = desc[5];	/* sector count (0:7) */
 			if (copy_to_user(arg, args, sizeof(args)))
 				rc = -EFAULT;
 		}
@@ -350,8 +350,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 						&sshdr);
-			if (sshdr.sense_key==0 &&
-				sshdr.asc==0 && sshdr.ascq==0)
+			if (sshdr.sense_key == 0 &&
+				sshdr.asc == 0 && sshdr.ascq == 0)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -975,7 +975,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		if ((qc->dev->flags & ATA_DFLAG_SPUNDOWN) &&
 		    (system_state == SYSTEM_HALT ||
 		     system_state == SYSTEM_POWER_OFF)) {
-			static unsigned long warned = 0;
+			static unsigned long warned;
 
 			if (!test_and_set_bit(0, &warned)) {
 				ata_dev_printk(qc->dev, KERN_WARNING,
@@ -1364,7 +1364,7 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	struct ata_eh_info *ehi = &qc->dev->link->eh_info;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
- 	int need_sense = (qc->err_mask != 0);
+	int need_sense = (qc->err_mask != 0);
 
 	/* We snoop the SET_FEATURES - Write Cache ON/OFF command, and
 	 * schedule EH_REVALIDATE operation to update the IDENTIFY DEVICE
@@ -1396,7 +1396,7 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	 * was no error, SK, ASC and ASCQ will all be zero.
 	 */
 	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
- 	    ((cdb[2] & 0x20) || need_sense)) {
+	    ((cdb[2] & 0x20) || need_sense)) {
 		ata_gen_passthru_sense(qc);
 	} else {
 		if (!need_sense) {
@@ -1500,7 +1500,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	return 0;
 
 early_finish:
-        ata_qc_free(qc);
+	ata_qc_free(qc);
 	qc->scsidone(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
@@ -1590,8 +1590,8 @@ static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
  */
 
 void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
-		        unsigned int (*actor) (struct ata_scsi_args *args,
-			     		   u8 *rbuf, unsigned int buflen))
+			unsigned int (*actor) (struct ata_scsi_args *args,
+					       u8 *rbuf, unsigned int buflen))
 {
 	u8 *rbuf;
 	unsigned int buflen, rc;
@@ -2140,7 +2140,7 @@ saving_not_supp:
  *	None.
  */
 unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
-			        unsigned int buflen)
+				 unsigned int buflen)
 {
 	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
 
@@ -2464,7 +2464,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static struct ata_device * ata_find_dev(struct ata_port *ap, int devno)
+static struct ata_device *ata_find_dev(struct ata_port *ap, int devno)
 {
 	if (ap->nr_pmp_links == 0) {
 		if (likely(devno < ata_link_max_devices(&ap->link)))
@@ -2477,8 +2477,8 @@ static struct ata_device * ata_find_dev(struct ata_port *ap, int devno)
 	return NULL;
 }
 
-static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
-					const struct scsi_device *scsidev)
+static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
+					      const struct scsi_device *scsidev)
 {
 	int devno;
 
@@ -2564,27 +2564,27 @@ static u8
 ata_scsi_map_proto(u8 byte1)
 {
 	switch((byte1 & 0x1e) >> 1) {
-		case 3:		/* Non-data */
-			return ATA_PROT_NODATA;
-
-		case 6:		/* DMA */
-		case 10:	/* UDMA Data-in */
-		case 11:	/* UDMA Data-Out */
-			return ATA_PROT_DMA;
-
-		case 4:		/* PIO Data-in */
-		case 5:		/* PIO Data-out */
-			return ATA_PROT_PIO;
-
-		case 0:		/* Hard Reset */
-		case 1:		/* SRST */
-		case 8:		/* Device Diagnostic */
-		case 9:		/* Device Reset */
-		case 7:		/* DMA Queued */
-		case 12:	/* FPDMA */
-		case 15:	/* Return Response Info */
-		default:	/* Reserved */
-			break;
+	case 3:		/* Non-data */
+		return ATA_PROT_NODATA;
+
+	case 6:		/* DMA */
+	case 10:	/* UDMA Data-in */
+	case 11:	/* UDMA Data-Out */
+		return ATA_PROT_DMA;
+
+	case 4:		/* PIO Data-in */
+	case 5:		/* PIO Data-out */
+		return ATA_PROT_PIO;
+
+	case 0:		/* Hard Reset */
+	case 1:		/* SRST */
+	case 8:		/* Device Diagnostic */
+	case 9:		/* Device Reset */
+	case 7:		/* DMA Queued */
+	case 12:	/* FPDMA */
+	case 15:	/* Return Response Info */
+	default:	/* Reserved */
+		break;
 	}
 
 	return ATA_PROT_UNKNOWN;
@@ -2919,94 +2919,94 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	args.done = done;
 
 	switch(scsicmd[0]) {
-		/* TODO: worth improving? */
-		case FORMAT_UNIT:
+	/* TODO: worth improving? */
+	case FORMAT_UNIT:
+		ata_scsi_invalid_field(cmd, done);
+		break;
+
+	case INQUIRY:
+		if (scsicmd[1] & 2)	           /* is CmdDt set?  */
 			ata_scsi_invalid_field(cmd, done);
+		else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
+		else switch (scsicmd[2]) {
+		case 0x00:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_00);
 			break;
-
-		case INQUIRY:
-			if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-				ata_scsi_invalid_field(cmd, done);
-			else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
-			else switch (scsicmd[2]) {
-			case 0x00:
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_00);
-				break;
-			case 0x80:
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_80);
-				break;
-			case 0x83:
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
-				break;
-			case 0x89:
-				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
-				break;
-			default:
-				ata_scsi_invalid_field(cmd, done);
-				break;
-			}
+		case 0x80:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_80);
 			break;
-
-		case MODE_SENSE:
-		case MODE_SENSE_10:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
+		case 0x83:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
 			break;
-
-		case MODE_SELECT:	/* unconditionally return */
-		case MODE_SELECT_10:	/* bad-field-in-cdb */
+		case 0x89:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
+			break;
+		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;
+		}
+		break;
+
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+		ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
+		break;
 
-		case READ_CAPACITY:
+	case MODE_SELECT:	/* unconditionally return */
+	case MODE_SELECT_10:	/* bad-field-in-cdb */
+		ata_scsi_invalid_field(cmd, done);
+		break;
+
+	case READ_CAPACITY:
+		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
+		break;
+
+	case SERVICE_ACTION_IN:
+		if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
-			break;
+		else
+			ata_scsi_invalid_field(cmd, done);
+		break;
 
-		case SERVICE_ACTION_IN:
-			if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
-				ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
-			else
-				ata_scsi_invalid_field(cmd, done);
-			break;
+	case REPORT_LUNS:
+		ata_scsi_rbuf_fill(&args, ata_scsiop_report_luns);
+		break;
 
-		case REPORT_LUNS:
-			ata_scsi_rbuf_fill(&args, ata_scsiop_report_luns);
-			break;
+	case REQUEST_SENSE:
+		ata_scsi_set_sense(cmd, 0, 0, 0);
+		cmd->result = (DRIVER_SENSE << 24);
+		done(cmd);
+		break;
 
-		case REQUEST_SENSE:
-			ata_scsi_set_sense(cmd, 0, 0, 0);
-			cmd->result = (DRIVER_SENSE << 24);
-			done(cmd);
-			break;
+	/* if we reach this, then writeback caching is disabled,
+	 * turning this into a no-op.
+	 */
+	case SYNCHRONIZE_CACHE:
+		/* fall through */
+
+	/* no-op's, complete with success */
+	case REZERO_UNIT:
+	case SEEK_6:
+	case SEEK_10:
+	case TEST_UNIT_READY:
+		ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
+		break;
 
-		/* if we reach this, then writeback caching is disabled,
-		 * turning this into a no-op.
-		 */
-		case SYNCHRONIZE_CACHE:
-			/* fall through */
-
-		/* no-op's, complete with success */
-		case REZERO_UNIT:
-		case SEEK_6:
-		case SEEK_10:
-		case TEST_UNIT_READY:
+	case SEND_DIAGNOSTIC:
+		tmp8 = scsicmd[1] & ~(1 << 3);
+		if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
-			break;
-
-		case SEND_DIAGNOSTIC:
-			tmp8 = scsicmd[1] & ~(1 << 3);
-			if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))
-				ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
-			else
-				ata_scsi_invalid_field(cmd, done);
-			break;
+		else
+			ata_scsi_invalid_field(cmd, done);
+		break;
 
-		/* all other commands */
-		default:
-			ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
-			/* "Invalid command operation code" */
-			done(cmd);
-			break;
+	/* all other commands */
+	default:
+		ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		/* "Invalid command operation code" */
+		done(cmd);
+		break;
 	}
 }
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 8227c45..48acc09 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -248,7 +248,7 @@ void ata_bmdma_setup(struct ata_queued_cmd *qc)
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void ata_bmdma_start (struct ata_queued_cmd *qc)
+void ata_bmdma_start(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	u8 dmactl;
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index bb97ef5..b9a17eb 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -17,7 +17,7 @@
  *    TODO:
  *	Test PARISC SuperIO
  *	Get someone to test on SPARC
- *	Implement lazy pio/dma switching for better performance	
+ *	Implement lazy pio/dma switching for better performance
  *	8bit shared timing.
  *	See if we need to kill the FIFO for ATAPI
  */
@@ -60,10 +60,10 @@ static void ns87415_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mo
 	u16 clocking;
 	u8 iordy;
 	u8 status;
-	
+
 	/* Timing register format is 17 - low nybble read timing with
 	   the high nybble being 16 - x for recovery time in PCI clocks */
-   
+
 	ata_timing_compute(adev, adev->pio_mode, &t, T, 0);
 
 	clocking = 17 - FIT(t.active, 2, 17);
@@ -71,7 +71,7 @@ static void ns87415_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mo
  	/* Use the same timing for read and write bytes */
 	clocking |= (clocking << 8);
 	pci_write_config_word(dev, timing, clocking);
-	
+
 	/* Set the IORDY enable versus DMA enable on or off properly */
 	pci_read_config_byte(dev, 0x42, &iordy);
 	iordy &= ~(1 << (4 + unit));
@@ -185,7 +185,7 @@ static void ns87415_bmdma_irq_clear(struct ata_port *ap)
 
 	if (!mmio)
 		return;
-	iowrite8((ioread8(mmio + ATA_DMA_CMD) | ATA_DMA_INTR | ATA_DMA_ERR), 
+	iowrite8((ioread8(mmio + ATA_DMA_CMD) | ATA_DMA_INTR | ATA_DMA_ERR),
 			mmio + ATA_DMA_CMD);
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 7f1b13e..b39648f 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -845,7 +845,7 @@ static int __mv_stop_dma(struct ata_port *ap)
 		pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 	} else {
 		WARN_ON(EDMA_EN & readl(port_mmio + EDMA_CMD_OFS));
-  	}
+	}
 
 	/* now properly wait for the eDMA to stop */
 	for (i = 1000; i > 0; i--) {
@@ -883,7 +883,7 @@ static void mv_dump_mem(void __iomem *start, unsigned bytes)
 	for (b = 0; b < bytes; ) {
 		DPRINTK("%p: ", start + b);
 		for (w = 0; b < bytes && w < 4; w++) {
-			printk("%08x ",readl(start + b));
+			printk("%08x ", readl(start + b));
 			b += sizeof(u32);
 		}
 		printk("\n");
@@ -899,8 +899,8 @@ static void mv_dump_pci_cfg(struct pci_dev *pdev, unsigned bytes)
 	for (b = 0; b < bytes; ) {
 		DPRINTK("%02x: ", b);
 		for (w = 0; b < bytes && w < 4; w++) {
-			(void) pci_read_config_dword(pdev,b,&dw);
-			printk("%08x ",dw);
+			(void) pci_read_config_dword(pdev, b, &dw);
+			printk("%08x ", dw);
 			b += sizeof(u32);
 		}
 		printk("\n");
@@ -944,9 +944,9 @@ static void mv_dump_all_regs(void __iomem *mmio_base, int port,
 	}
 	for (p = start_port; p < start_port + num_ports; p++) {
 		port_base = mv_port_base(mmio_base, p);
-		DPRINTK("EDMA regs (port %i):\n",p);
+		DPRINTK("EDMA regs (port %i):\n", p);
 		mv_dump_mem(port_base, 0x54);
-		DPRINTK("SATA regs (port %i):\n",p);
+		DPRINTK("SATA regs (port %i):\n", p);
 		mv_dump_mem(port_base+0x300, 0x60);
 	}
 #endif
@@ -1184,7 +1184,7 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	u16 flags = 0;
 	unsigned in_index;
 
- 	if (qc->tf.protocol != ATA_PROT_DMA)
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in command request block
@@ -1276,7 +1276,7 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	unsigned in_index;
 	u32 flags = 0;
 
- 	if (qc->tf.protocol != ATA_PROT_DMA)
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in Gen IIE command request block
@@ -1606,7 +1606,7 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 	writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
-		hc,relevant,hc_irq_cause);
+		hc, relevant, hc_irq_cause);
 
 	for (port = port0; port < port0 + MV_PORTS_PER_HC; port++) {
 		struct ata_port *ap = host->ports[port];
@@ -1983,9 +1983,8 @@ static int mv6_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 	for (i = 0; i < 1000; i++) {
 		udelay(1);
 		t = readl(reg);
-		if (PCI_MASTER_EMPTY & t) {
+		if (PCI_MASTER_EMPTY & t)
 			break;
-		}
 	}
 	if (!(PCI_MASTER_EMPTY & t)) {
 		printk(KERN_ERR DRV_NAME ": PCI master won't flush\n");
@@ -2668,7 +2667,7 @@ static void mv_print_info(struct ata_host *host)
  */
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version = 0;
+	static int printed_version;
 	unsigned int board_idx = (unsigned int)ent->driver_data;
 	const struct ata_port_info *ppi[] = { &mv_port_info[board_idx], NULL };
 	struct ata_host *host;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 240a892..2e0279f 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -163,7 +163,7 @@ enum {
 	NV_ADMA_STAT_STOPPED		= (1 << 10),
 	NV_ADMA_STAT_DONE		= (1 << 12),
 	NV_ADMA_STAT_ERR		= NV_ADMA_STAT_CPBERR |
-	 				  NV_ADMA_STAT_TIMEOUT,
+					  NV_ADMA_STAT_TIMEOUT,
 
 	/* port flags */
 	NV_ADMA_PORT_REGISTER_MODE	= (1 << 0),
@@ -228,7 +228,7 @@ struct nv_adma_cpb {
 	u8			reserved1;     /* 1 */
 	u8			ctl_flags;     /* 2 */
 	/* len is length of taskfile in 64 bit words */
- 	u8			len;           /* 3  */
+	u8			len;		/* 3  */
 	u8			tag;           /* 4 */
 	u8			next_cpb_idx;  /* 5 */
 	__le16			reserved2;     /* 6-7 */
@@ -244,9 +244,9 @@ struct nv_adma_port_priv {
 	dma_addr_t		cpb_dma;
 	struct nv_adma_prd	*aprd;
 	dma_addr_t		aprd_dma;
-	void __iomem *		ctl_block;
-	void __iomem *		gen_block;
-	void __iomem *		notifier_clear_block;
+	void __iomem		*ctl_block;
+	void __iomem		*gen_block;
+	void __iomem		*notifier_clear_block;
 	u8			flags;
 	int			last_issue_ncq;
 };
@@ -293,7 +293,7 @@ struct nv_swncq_port_priv {
 
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
 
-static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 #ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -301,8 +301,8 @@ static void nv_ck804_host_stop(struct ata_host *host);
 static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
-static int nv_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int nv_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
@@ -653,12 +653,12 @@ static void nv_adma_register_mode(struct ata_port *ap)
 		return;
 
 	status = readw(mmio + NV_ADMA_STAT);
-	while(!(status & NV_ADMA_STAT_IDLE) && count < 20) {
+	while (!(status & NV_ADMA_STAT_IDLE) && count < 20) {
 		ndelay(50);
 		status = readw(mmio + NV_ADMA_STAT);
 		count++;
 	}
-	if(count == 20)
+	if (count == 20)
 		ata_port_printk(ap, KERN_WARNING,
 			"timeout waiting for ADMA IDLE, stat=0x%hx\n",
 			status);
@@ -668,12 +668,12 @@ static void nv_adma_register_mode(struct ata_port *ap)
 
 	count = 0;
 	status = readw(mmio + NV_ADMA_STAT);
-	while(!(status & NV_ADMA_STAT_LEGACY) && count < 20) {
+	while (!(status & NV_ADMA_STAT_LEGACY) && count < 20) {
 		ndelay(50);
 		status = readw(mmio + NV_ADMA_STAT);
 		count++;
 	}
-	if(count == 20)
+	if (count == 20)
 		ata_port_printk(ap, KERN_WARNING,
 			 "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
 			 status);
@@ -697,13 +697,13 @@ static void nv_adma_mode(struct ata_port *ap)
 	writew(tmp | NV_ADMA_CTL_GO, mmio + NV_ADMA_CTL);
 
 	status = readw(mmio + NV_ADMA_STAT);
-	while(((status & NV_ADMA_STAT_LEGACY) ||
+	while (((status & NV_ADMA_STAT_LEGACY) ||
 	      !(status & NV_ADMA_STAT_IDLE)) && count < 20) {
 		ndelay(50);
 		status = readw(mmio + NV_ADMA_STAT);
 		count++;
 	}
-	if(count == 20)
+	if (count == 20)
 		ata_port_printk(ap, KERN_WARNING,
 			"timeout waiting for ADMA LEGACY clear and IDLE, stat=0x%hx\n",
 			status);
@@ -747,8 +747,7 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 		   on the port. */
 		adma_enable = 0;
 		nv_adma_register_mode(ap);
-	}
-	else {
+	} else {
 		bounce_limit = *ap->dev->dma_mask;
 		segment_boundary = NV_ADMA_DMA_BOUNDARY;
 		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
@@ -757,23 +756,22 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 
 	pci_read_config_dword(pdev, NV_MCP_SATA_CFG_20, &current_reg);
 
-	if(ap->port_no == 1)
+	if (ap->port_no == 1)
 		config_mask = NV_MCP_SATA_CFG_20_PORT1_EN |
 			      NV_MCP_SATA_CFG_20_PORT1_PWB_EN;
 	else
 		config_mask = NV_MCP_SATA_CFG_20_PORT0_EN |
 			      NV_MCP_SATA_CFG_20_PORT0_PWB_EN;
 
-	if(adma_enable) {
+	if (adma_enable) {
 		new_reg = current_reg | config_mask;
 		pp->flags &= ~NV_ADMA_ATAPI_SETUP_COMPLETE;
-	}
-	else {
+	} else {
 		new_reg = current_reg & ~config_mask;
 		pp->flags |= NV_ADMA_ATAPI_SETUP_COMPLETE;
 	}
 
-	if(current_reg != new_reg)
+	if (current_reg != new_reg)
 		pci_write_config_dword(pdev, NV_MCP_SATA_CFG_20, new_reg);
 
 	blk_queue_bounce_limit(sdev->request_queue, bounce_limit);
@@ -807,7 +805,7 @@ static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16 *cpb)
 {
 	unsigned int idx = 0;
 
-	if(tf->flags & ATA_TFLAG_ISADDR) {
+	if (tf->flags & ATA_TFLAG_ISADDR) {
 		if (tf->flags & ATA_TFLAG_LBA48) {
 			cpb[idx++] = cpu_to_le16((ATA_REG_ERR   << 8) | tf->hob_feature | WNB);
 			cpb[idx++] = cpu_to_le16((ATA_REG_NSECT << 8) | tf->hob_nsect);
@@ -824,12 +822,12 @@ static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16 *cpb)
 		cpb[idx++] = cpu_to_le16((ATA_REG_LBAH   << 8) | tf->lbah);
 	}
 
-	if(tf->flags & ATA_TFLAG_DEVICE)
+	if (tf->flags & ATA_TFLAG_DEVICE)
 		cpb[idx++] = cpu_to_le16((ATA_REG_DEVICE << 8) | tf->device);
 
 	cpb[idx++] = cpu_to_le16((ATA_REG_CMD    << 8) | tf->command | CMDEND);
 
-	while(idx < 12)
+	while (idx < 12)
 		cpb[idx++] = cpu_to_le16(IGN);
 
 	return idx;
@@ -850,7 +848,7 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 		int freeze = 0;
 
 		ata_ehi_clear_desc(ehi);
-		__ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x: ", flags );
+		__ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x: ", flags);
 		if (flags & NV_CPB_RESP_ATA_ERR) {
 			ata_ehi_push_desc(ehi, "ATA error");
 			ehi->err_mask |= AC_ERR_DEV;
@@ -879,7 +877,7 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
 		VPRINTK("CPB flags done, flags=0x%x\n", flags);
 		if (likely(qc)) {
-			DPRINTK("Completing qc from tag %d\n",cpb_num);
+			DPRINTK("Completing qc from tag %d\n", cpb_num);
 			ata_qc_complete(qc);
 		} else {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -952,7 +950,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
 				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
 					>> (NV_INT_PORT_SHIFT * i);
-				if(ata_tag_valid(ap->link.active_tag))
+				if (ata_tag_valid(ap->link.active_tag))
 					/** NV_INT_DEV indication seems unreliable at times
 					    at least in ADMA mode. Force it on always when a
 					    command is active, to prevent losing interrupts. */
@@ -966,7 +964,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 
 			gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
 
-			if( !NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
+			if (!NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
 			    !notifier_error)
 				/* Nothing to do */
 				continue;
@@ -990,7 +988,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				struct ata_eh_info *ehi = &ap->link.eh_info;
 
 				ata_ehi_clear_desc(ehi);
-				__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status );
+				__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status);
 				if (status & NV_ADMA_STAT_TIMEOUT) {
 					ehi->err_mask |= AC_ERR_SYSTEM;
 					ata_ehi_push_desc(ehi, "timeout");
@@ -1056,14 +1054,14 @@ static void nv_adma_freeze(struct ata_port *ap)
 		return;
 
 	/* clear any outstanding CK804 notifications */
-	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+	writeb(NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
 		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
 
 	/* Disable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( tmp & ~(NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+	writew(tmp & ~(NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
 		mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 }
 
 static void nv_adma_thaw(struct ata_port *ap)
@@ -1079,9 +1077,9 @@ static void nv_adma_thaw(struct ata_port *ap)
 
 	/* Enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( tmp | (NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+	writew(tmp | (NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
 		mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 }
 
 static void nv_adma_irq_clear(struct ata_port *ap)
@@ -1096,7 +1094,7 @@ static void nv_adma_irq_clear(struct ata_port *ap)
 	}
 
 	/* clear any outstanding CK804 notifications */
-	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+	writeb(NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
 		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
 
 	/* clear ADMA status */
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 9f9f7b3..b6026bc 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -62,13 +62,13 @@
 		submit ATA packet to hardware
 		hardware executes ATA WRITE command, w/ data in DIMM
 		hardware raises interrupt
-	
+
 	and each READ looks like this:
 
 		submit ATA packet to hardware
 		hardware executes ATA READ command, w/ data in DIMM
 		hardware raises interrupt
-	
+
 		submit HDMA packet to hardware
 		hardware copies data from DIMM to system memory
 		hardware raises interrupt
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 59d4da2..d0bb5b9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1230,7 +1230,7 @@ static void quirk_jmicron_ata(struct pci_dev *pdev)
 	case PCI_DEVICE_ID_JMICRON_JMB363:
 		/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
 		/* Set the class codes correctly and then direct IDE 0 */
-		conf1 |= 0x00C2A102; /* Set 1, 8, 13, 15, 17, 22, 23 */
+		conf1 |= 0x00C2A1B3; /* Set 0, 1, 4, 5, 7, 8, 13, 15, 17, 22, 23 */
 		break;
 
 	case PCI_DEVICE_ID_JMICRON_JMB368:
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a4f373f..8263a7b 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -178,8 +178,8 @@ enum {
 	ATA_CMD_PACKET		= 0xA0,
 	ATA_CMD_VERIFY		= 0x40,
 	ATA_CMD_VERIFY_EXT	= 0x42,
- 	ATA_CMD_STANDBYNOW1	= 0xE0,
- 	ATA_CMD_IDLEIMMEDIATE	= 0xE1,
+	ATA_CMD_STANDBYNOW1	= 0xE0,
+	ATA_CMD_IDLEIMMEDIATE	= 0xE1,
 	ATA_CMD_INIT_DEV_PARAMS	= 0x91,
 	ATA_CMD_READ_NATIVE_MAX	= 0xF8,
 	ATA_CMD_READ_NATIVE_MAX_EXT = 0x27,
@@ -458,7 +458,7 @@ static inline int ata_id_wcache_enabled(const u16 *id)
  *		ATA-3 introduces word 80 and accurate reporting
  *
  *	The practical impact of this is that ata_id_major_version cannot
- *	reliably report on drives below ATA3. 
+ *	reliably report on drives below ATA3.
  */
 
 static inline unsigned int ata_id_major_version(const u16 *id)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc3b6fc..6fd24e0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -326,7 +326,7 @@ enum {
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
 
-	 /* DMA mask for user DMA control: User visible values; DO NOT 
+	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
 	ATA_DMA_MASK_ATA	= (1 << 0),	/* DMA on ATA Disk */
 	ATA_DMA_MASK_ATAPI	= (1 << 1),	/* DMA on ATAPI */
@@ -717,7 +717,7 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v,vmin,vmax)	max_t(short,min_t(short,v,vmax),vmin)
+#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
 
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
@@ -816,14 +816,14 @@ extern void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
 extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
-extern void ata_noop_dev_select (struct ata_port *ap, unsigned int device);
-extern void ata_std_dev_select (struct ata_port *ap, unsigned int device);
+extern void ata_noop_dev_select(struct ata_port *ap, unsigned int device);
+extern void ata_std_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_check_status(struct ata_port *ap);
 extern u8 ata_altstatus(struct ata_port *ap);
 extern void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf);
-extern int ata_port_start (struct ata_port *ap);
-extern int ata_sff_port_start (struct ata_port *ap);
-extern irqreturn_t ata_interrupt (int irq, void *dev_instance);
+extern int ata_port_start(struct ata_port *ap);
+extern int ata_sff_port_start(struct ata_port *ap);
+extern irqreturn_t ata_interrupt(int irq, void *dev_instance);
 extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
 			  unsigned int buflen, int write_data);
 extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
@@ -844,8 +844,8 @@ extern void ata_id_string(const u16 *id, unsigned char *s,
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
 extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
-extern void ata_bmdma_setup (struct ata_queued_cmd *qc);
-extern void ata_bmdma_start (struct ata_queued_cmd *qc);
+extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
+extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
 extern u8   ata_bmdma_status(struct ata_port *ap);
 extern void ata_bmdma_irq_clear(struct ata_port *ap);
@@ -920,9 +920,9 @@ static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
 #ifdef CONFIG_PCI
 struct pci_dev;
 
-extern int ata_pci_init_one (struct pci_dev *pdev,
+extern int ata_pci_init_one(struct pci_dev *pdev,
 			     const struct ata_port_info * const * ppi);
-extern void ata_pci_remove_one (struct pci_dev *pdev);
+extern void ata_pci_remove_one(struct pci_dev *pdev);
 #ifdef CONFIG_PM
 extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
 extern int __must_check ata_pci_device_do_resume(struct pci_dev *pdev);
