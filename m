Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZCYAHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZCYAHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZCYAGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:06:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56648 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZCYAGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=W3E+aQlpfSCA0veXyldKtfr7jqReaTx7g5Ppy7QmPb8wlMemwkV23nxgXmirGIFL7y
         ZMtqPSRb/TMnH19jkr9FlrQ00KZ51/wBiTQcpBiYYd2XoF0f8Qzp2EROw4+oBmia28aN
         vTkviWXkXEU2PEirI5/HHzTwvC22y8zc+bC04=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 1
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 25 Mar 2009 00:07:44 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903250007.45165.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Nothing really earthshaking here:

- IDE ACPI cleanup
- IRQ setup sanitization
- saner code layout
- unified IDENTIFY handling
- by-the-way fixes/cleanups


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig           |    8 +
 drivers/ide/Makefile          |    4 +-
 drivers/ide/aec62xx.c         |    4 +-
 drivers/ide/alim15x3.c        |    2 +-
 drivers/ide/amd74xx.c         |   14 +-
 drivers/ide/atiixp.c          |    3 +-
 drivers/ide/cmd64x.c          |    2 +-
 drivers/ide/cs5520.c          |    3 +-
 drivers/ide/cs5530.c          |    2 +-
 drivers/ide/delkin_cb.c       |    2 +-
 drivers/ide/hpt366.c          |    4 +-
 drivers/ide/ide-acpi.c        |  214 +++---------
 drivers/ide/ide-atapi.c       |   41 +++-
 drivers/ide/ide-cd.c          |    4 +-
 drivers/ide/ide-devsets.c     |  190 +++++++++++
 drivers/ide/ide-dma.c         |   57 ++++
 drivers/ide/ide-eh.c          |  428 ++++++++++++++++++++++++
 drivers/ide/ide-io-std.c      |  316 ++++++++++++++++++
 drivers/ide/ide-io.c          |  320 ++----------------
 drivers/ide/ide-iops.c        |  742 ++---------------------------------------
 drivers/ide/ide-lib.c         |  240 -------------
 drivers/ide/ide-park.c        |   25 ++
 drivers/ide/ide-pci-generic.c |    4 +-
 drivers/ide/ide-probe.c       |  248 +++-----------
 drivers/ide/ide-proc.c        |    2 +-
 drivers/ide/ide-xfer-mode.c   |  246 ++++++++++++++
 drivers/ide/ide.c             |  156 +---------
 drivers/ide/it821x.c          |    2 +-
 drivers/ide/ns87415.c         |    4 +-
 drivers/ide/pdc202xx_new.c    |    4 +-
 drivers/ide/pdc202xx_old.c    |    4 +-
 drivers/ide/piix.c            |   13 +-
 drivers/ide/serverworks.c     |   13 +-
 drivers/ide/setup-pci.c       |   27 +-
 drivers/ide/siimage.c         |    2 +-
 drivers/ide/sis5513.c         |    4 +-
 drivers/ide/sl82c105.c        |    4 +-
 drivers/ide/slc90e66.c        |    1 -
 drivers/ide/trm290.c          |    3 -
 drivers/ide/via82cxxx.c       |   12 +-
 include/asm-frv/ide.h         |   24 --
 include/asm-mn10300/ide.h     |   39 ---
 include/asm-mn10300/pci.h     |    5 +
 include/linux/ata.h           |    2 -
 include/linux/ide.h           |   78 ++---
 45 files changed, 1571 insertions(+), 1951 deletions(-)
 create mode 100644 drivers/ide/ide-devsets.c
 create mode 100644 drivers/ide/ide-eh.c
 create mode 100644 drivers/ide/ide-io-std.c
 create mode 100644 drivers/ide/ide-xfer-mode.c
 delete mode 100644 include/asm-frv/ide.h
 delete mode 100644 include/asm-mn10300/ide.h


Bartlomiej Zolnierkiewicz (52):
      ide: move ide_pktcmd_tf_load() to ide-atapi.c
      ide: no need to touch local IRQs in ide_probe_port()
      ide: move ->lock and ->timer init from init_irq() to ide_init_port_data()
      ide: init_irq() doesn't need to hold ide_cfg_mtx
      ide: remove superfluous check from ide_proc_port_register_devices()
      ide-acpi: no need to zero ->acpidata for devices
      ide-acpi: init ACPI handles early for devices
      ide: add ide_for_each_present_dev() iterator
      ide: sanitize ACPI initialization
      ide-acpi: cleanup do_drive_get_GTF()
      ide-acpi: cleanup do_drive_set_taskfiles()
      ide-acpi: remove taskfile_load_raw()
      ide: remove stale comments from drive_is_ready()
      ide: unexport ide_devset_execute()
      ide: move drive_is_ready() to ide-io.c
      ide: move ide_dma_timeout_retry() to ide-dma.c
      ide: remove ide_do_drive_cmd()
      ide: factor out processing of special commands from ide_special_rq()
      ide: move ide_do_park_unpark() to ide-park.c
      ide: move device settings code to ide-devsets.c
      ide: move xfer mode tuning code to ide-xfer-mode.c
      ide: move ide_read_bcount_and_ireason() to ide-atapi.c
      ide: move standard I/O code to ide-io-std.c
      ide: fix printk() levels in [atapi_]reset_pollfunc()
      ide: fix comments in ide_config_drive_speed()
      ide: checkpatch.pl fixes for ide-iops.c
      ide: move error handling code to ide-eh.c (v2)
      mn10300: add pci_get_legacy_ide_irq() to <asm/pci.h>
      amd74xx: use ide_pci_is_in_compatibility_mode()
      ns87415: use pci_get_legacy_ide_irq()
      ns87415: small ->init_hwif cleanup
      trm290: small ->init_hwif cleanup
      ide: handle IDE_HFLAG[_FORCE]_LEGACY_IRQS in ide_pci_init_{one,two}()
      ide: use pci_get_legacy_ide_irq() in ide_pci_init_{one,two}()
      ide: use ide_pci_is_in_compatibility_mode() in ide_pci_init_{one,two}()
      ide: remove no longer needed IDE_HFLAG[_FORCE]_LEGACY_IRQS
      amd74xx: remove no longer needed ->init_hwif method
      ide: remove no longer needed IRQ fallback code from hwif_init()
      ide: remove no longer needed IRQ auto-probing from try_to_identify() (v2)
      ide: remove try_to_identify() wrapper
      ide: fix ->init_chipset method to return 'int' value
      ide: remove pciirq argument from ide_pci_setup_ports()
      frv: remove <asm/ide.h>
      mn10300: remove <asm/ide.h>
      ide: fix kmalloc() failure handling in ide_driveid_update()
      ide: propagate AltStatus workarounds to ide_driveid_update()
      ide: shorten timeout value in ide_driveid_update()
      ide: remove broken EXABYTENEST support
      ide: classify device type in do_probe()
      ide: sanitize SELECT_MASK() usage in ide_driveid_update()
      ide: clear drive IRQ after re-enabling local IRQs in ide_driveid_update()
      ide: use try_to_identify() in ide_driveid_update()


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5ea3bfa..640c992 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -56,8 +56,12 @@ if IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_XFER_MODE
+	bool
+
 config IDE_TIMINGS
 	bool
+	select IDE_XFER_MODE
 
 config IDE_ATAPI
 	bool
@@ -698,6 +702,7 @@ config BLK_DEV_IDE_PMAC_ATA100FIRST
 config BLK_DEV_IDE_AU1XXX
        bool "IDE for AMD Alchemy Au1200"
        depends on SOC_AU1200
+       select IDE_XFER_MODE
 choice
        prompt "IDE Mode for AMD Alchemy Au1200"
        default CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
@@ -871,6 +876,7 @@ config BLK_DEV_ALI14XX
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
+	select IDE_XFER_MODE
 	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "dtc2278.probe" kernel
@@ -902,6 +908,7 @@ config BLK_DEV_QD65XX
 
 config BLK_DEV_UMC8672
 	tristate "UMC-8672 support"
+	select IDE_XFER_MODE
 	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "umc8672.probe" kernel
@@ -915,5 +922,6 @@ endif
 config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	select IDE_XFER_MODE
 
 endif # IDE
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 1c326d9..9b4bbe1 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,9 +5,11 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o ide-sysfs.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o \
+	      ide-io-std.o ide-eh.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_XFER_MODE)	+= ide-pio-blacklist.o ide-xfer-mode.o
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
diff --git a/drivers/ide/aec62xx.c b/drivers/ide/aec62xx.c
index 4485b9c..878f8ec 100644
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -139,7 +139,7 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
+static int init_chipset_aec62xx(struct pci_dev *dev)
 {
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
@@ -156,7 +156,7 @@ static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
 		pci_write_config_byte(dev, 0x4a, reg4ah | 0x80);
 	}
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 atp86x_cable_detect(ide_hwif_t *hwif)
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 66f4308..d3513b6 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -212,7 +212,7 @@ static int ali15x3_dma_setup(ide_drive_t *drive)
  *	appropriate also sets up the 1533 southbridge.
  */
 
-static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
+static int init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index 77267c8..628cd2e 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -140,7 +140,7 @@ static void amd7411_cable_detect(struct pci_dev *dev)
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
+static int init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -172,7 +172,7 @@ static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
 		t |= 0xf0;
 	pci_write_config_byte(dev, AMD_IDE_CONFIG + offset, t);
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 amd_cable_detect(ide_hwif_t *hwif)
@@ -183,14 +183,6 @@ static u8 amd_cable_detect(ide_hwif_t *hwif)
 		return ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (hwif->irq == 0) /* 0 is bogus but will do for now */
-		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
-}
-
 static const struct ide_port_ops amd_port_ops = {
 	.set_pio_mode		= amd_set_pio_mode,
 	.set_dma_mode		= amd_set_drive,
@@ -207,7 +199,6 @@ static const struct ide_port_ops amd_port_ops = {
 	{								\
 		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
-		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
 		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
@@ -221,7 +212,6 @@ static const struct ide_port_ops amd_port_ops = {
 	{								\
 		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
-		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
 		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
diff --git a/drivers/ide/atiixp.c b/drivers/ide/atiixp.c
index ecd1e62..923cbfe 100644
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -142,7 +142,6 @@ static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.port_ops	= &atiixp_port_ops,
-		.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -151,7 +150,7 @@ static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
 		.port_ops	= &atiixp_port_ops,
-		.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_LEGACY_IRQS,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index 2f9688d..aeee036 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -333,7 +333,7 @@ static int cmd646_1_dma_end(ide_drive_t *drive)
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int init_chipset_cmd64x(struct pci_dev *dev)
+static int init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index d003bec..58fb90e 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -133,7 +133,8 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
+	hw[0].irq = 14;
 
 	return ide_host_add(d, hws, NULL);
 }
diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
index d8ede85..8e8b35a 100644
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -135,7 +135,7 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int init_chipset_cs5530(struct pci_dev *dev)
+static int init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index 8f1b2d9..bacb119 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -46,7 +46,7 @@ static const struct ide_port_ops delkin_cb_port_ops = {
 	.quirkproc		= ide_undecoded_slave,
 };
 
-static unsigned int delkin_cb_init_chipset(struct pci_dev *dev)
+static int delkin_cb_init_chipset(struct pci_dev *dev)
 {
 	unsigned long base = pci_resource_start(dev, 0);
 	int i;
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 3eb9b5c..d3b3e82 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -995,7 +995,7 @@ static void hpt3xx_disable_fast_irq(struct pci_dev *dev, u8 mcr_addr)
 		pci_write_config_byte(dev, mcr_addr + 1, new_mcr);
 }
 
-static unsigned int init_chipset_hpt366(struct pci_dev *dev)
+static int init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
@@ -1237,7 +1237,7 @@ static unsigned int init_chipset_hpt366(struct pci_dev *dev)
 	hpt3xx_disable_fast_irq(dev, 0x50);
 	hpt3xx_disable_fast_irq(dev, 0x54);
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index ec7d07f..5b704f1 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -20,9 +20,6 @@
 #include <acpi/acpi_bus.h>
 
 #define REGS_PER_GTF		7
-struct taskfile_array {
-	u8	tfa[REGS_PER_GTF];	/* regs. 0x1f1 - 0x1f7 */
-};
 
 struct GTM_buffer {
 	u32	PIO_speed0;
@@ -89,12 +86,8 @@ static const struct dmi_system_id ide_acpi_dmi_table[] = {
 	{ }	/* terminate list */
 };
 
-static int ide_acpi_blacklist(void)
+int ide_acpi_init(void)
 {
-	static int done;
-	if (done)
-		return 0;
-	done = 1;
 	dmi_check_system(ide_acpi_dmi_table);
 	return 0;
 }
@@ -202,40 +195,6 @@ static acpi_handle ide_acpi_hwif_get_handle(ide_hwif_t *hwif)
 }
 
 /**
- * ide_acpi_drive_get_handle - Get ACPI object handle for a given drive
- * @drive: device to locate
- *
- * Retrieves the object handle of a given drive. According to the ACPI
- * spec the drive is a child of the hwif.
- *
- * Returns handle on success, 0 on error.
- */
-static acpi_handle ide_acpi_drive_get_handle(ide_drive_t *drive)
-{
-	ide_hwif_t	*hwif = drive->hwif;
-	int		 port;
-	acpi_handle	 drive_handle;
-
-	if (!hwif->acpidata)
-		return NULL;
-
-	if (!hwif->acpidata->obj_handle)
-		return NULL;
-
-	port = hwif->channel ? drive->dn - 2: drive->dn;
-
-	DEBPRINT("ENTER: %s at channel#: %d port#: %d\n",
-		 drive->name, hwif->channel, port);
-
-
-	/* TBD: could also check ACPI object VALID bits */
-	drive_handle = acpi_get_child(hwif->acpidata->obj_handle, port);
-	DEBPRINT("drive %s handle 0x%p\n", drive->name, drive_handle);
-
-	return drive_handle;
-}
-
-/**
  * do_drive_get_GTF - get the drive bootup default taskfile settings
  * @drive: the drive for which the taskfile settings should be retrieved
  * @gtf_length: number of bytes of _GTF data returned at @gtf_address
@@ -257,47 +216,15 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	acpi_status			status;
 	struct acpi_buffer		output;
 	union acpi_object 		*out_obj;
-	ide_hwif_t			*hwif = drive->hwif;
-	struct device			*dev = hwif->gendev.parent;
 	int				err = -ENODEV;
-	int				port;
 
 	*gtf_length = 0;
 	*gtf_address = 0UL;
 	*obj_loc = 0UL;
 
-	if (ide_noacpi)
-		return 0;
-
-	if (!dev) {
-		DEBPRINT("no PCI device for %s\n", hwif->name);
-		goto out;
-	}
-
-	if (!hwif->acpidata) {
-		DEBPRINT("no ACPI data for %s\n", hwif->name);
-		goto out;
-	}
-
-	port = hwif->channel ? drive->dn - 2: drive->dn;
-
-	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
-		 hwif->name, dev_name(dev), port, hwif->channel);
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
-		DEBPRINT("%s drive %d:%d not present\n",
-			 hwif->name, hwif->channel, port);
-		goto out;
-	}
-
-	/* Get this drive's _ADR info. if not already known. */
 	if (!drive->acpidata->obj_handle) {
-		drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
-		if (!drive->acpidata->obj_handle) {
-			DEBPRINT("No ACPI object found for %s\n",
-				 drive->name);
-			goto out;
-		}
+		DEBPRINT("No ACPI object found for %s\n", drive->name);
+		goto out;
 	}
 
 	/* Setting up output buffer */
@@ -355,43 +282,6 @@ out:
 }
 
 /**
- * taskfile_load_raw - send taskfile registers to drive
- * @drive: drive to which output is sent
- * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
- *
- * Outputs IDE taskfile to the drive.
- */
-static int taskfile_load_raw(ide_drive_t *drive,
-			      const struct taskfile_array *gtf)
-{
-	ide_task_t args;
-	int err = 0;
-
-	DEBPRINT("(0x1f1-1f7): hex: "
-	       "%02x %02x %02x %02x %02x %02x %02x\n",
-	       gtf->tfa[0], gtf->tfa[1], gtf->tfa[2],
-	       gtf->tfa[3], gtf->tfa[4], gtf->tfa[5], gtf->tfa[6]);
-
-	memset(&args, 0, sizeof(ide_task_t));
-
-	/* convert gtf to IDE Taskfile */
-	memcpy(&args.tf_array[7], &gtf->tfa, 7);
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-
-	if (!ide_acpigtf) {
-		DEBPRINT("_GTF execution disabled\n");
-		return err;
-	}
-
-	err = ide_no_data_taskfile(drive, &args);
-	if (err)
-		printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-		       __func__, err);
-
-	return err;
-}
-
-/**
  * do_drive_set_taskfiles - write the drive taskfile settings from _GTF
  * @drive: the drive to which the taskfile command should be sent
  * @gtf_length: total number of bytes of _GTF taskfiles
@@ -404,43 +294,41 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 				  unsigned int gtf_length,
 				  unsigned long gtf_address)
 {
-	int			rc = -ENODEV, err;
+	int			rc = 0, err;
 	int			gtf_count = gtf_length / REGS_PER_GTF;
 	int			ix;
-	struct taskfile_array	*gtf;
-
-	if (ide_noacpi)
-		return 0;
-
-	DEBPRINT("ENTER: %s, hard_port#: %d\n", drive->name, drive->dn);
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		goto out;
-
-	if (!gtf_count)		/* shouldn't be here */
-		goto out;
 
 	DEBPRINT("total GTF bytes=%u (0x%x), gtf_count=%d, addr=0x%lx\n",
 		 gtf_length, gtf_length, gtf_count, gtf_address);
 
-	if (gtf_length % REGS_PER_GTF) {
-		printk(KERN_ERR "%s: unexpected GTF length (%d)\n",
-		       __func__, gtf_length);
-		goto out;
-	}
-
-	rc = 0;
+	/* send all taskfile registers (0x1f1-0x1f7) *in*that*order* */
 	for (ix = 0; ix < gtf_count; ix++) {
-		gtf = (struct taskfile_array *)
-			(gtf_address + ix * REGS_PER_GTF);
+		u8 *gtf = (u8 *)(gtf_address + ix * REGS_PER_GTF);
+		ide_task_t task;
 
-		/* send all TaskFile registers (0x1f1-0x1f7) *in*that*order* */
-		err = taskfile_load_raw(drive, gtf);
-		if (err)
+		DEBPRINT("(0x1f1-1f7): "
+			 "hex: %02x %02x %02x %02x %02x %02x %02x\n",
+			 gtf[0], gtf[1], gtf[2],
+			 gtf[3], gtf[4], gtf[5], gtf[6]);
+
+		if (!ide_acpigtf) {
+			DEBPRINT("_GTF execution disabled\n");
+			continue;
+		}
+
+		/* convert GTF to taskfile */
+		memset(&task, 0, sizeof(ide_task_t));
+		memcpy(&task.tf_array[7], gtf, REGS_PER_GTF);
+		task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+		err = ide_no_data_taskfile(drive, &task);
+		if (err) {
+			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
+					__func__, err);
 			rc = err;
+		}
 	}
 
-out:
 	return rc;
 }
 
@@ -647,26 +535,23 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 		DEBPRINT("no ACPI data for %s\n", hwif->name);
 		return;
 	}
+
 	/* channel first and then drives for power on and verse versa for power off */
 	if (on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (!drive->acpidata->obj_handle)
-			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
-
-		if (drive->acpidata->obj_handle &&
-		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		if (drive->acpidata->obj_handle)
 			acpi_bus_set_power(drive->acpidata->obj_handle,
-				on? ACPI_STATE_D0: ACPI_STATE_D3);
-		}
+					   on ? ACPI_STATE_D0 : ACPI_STATE_D3);
 	}
+
 	if (!on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
 }
 
 /**
- * ide_acpi_init - initialize the ACPI link for an IDE interface
+ * ide_acpi_init_port - initialize the ACPI link for an IDE interface
  * @hwif: target IDE interface (channel)
  *
  * The ACPI spec is not quite clear when the drive identify buffer
@@ -676,10 +561,8 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
  * So we get the information during startup; but this means that
  * any changes during run-time will be lost after resume.
  */
-void ide_acpi_init(ide_hwif_t *hwif)
+void ide_acpi_init_port(ide_hwif_t *hwif)
 {
-	ide_acpi_blacklist();
-
 	hwif->acpidata = kzalloc(sizeof(struct ide_acpi_hwif_link), GFP_KERNEL);
 	if (!hwif->acpidata)
 		return;
@@ -708,15 +591,24 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	hwif->devices[0]->acpidata = &hwif->acpidata->master;
 	hwif->devices[1]->acpidata = &hwif->acpidata->slave;
 
-	/*
-	 * Send IDENTIFY for each drive
-	 */
-	ide_port_for_each_dev(i, drive, hwif) {
-		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
+	/* get _ADR info for each device */
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		acpi_handle dev_handle;
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
+		DEBPRINT("ENTER: %s at channel#: %d port#: %d\n",
+			 drive->name, hwif->channel, drive->dn & 1);
+
+		/* TBD: could also check ACPI object VALID bits */
+		dev_handle = acpi_get_child(hwif->acpidata->obj_handle,
+					    drive->dn & 1);
+
+		DEBPRINT("drive %s handle 0x%p\n", drive->name, dev_handle);
+
+		drive->acpidata->obj_handle = dev_handle;
+	}
 
+	/* send IDENTIFY for each device */
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
 		if (err)
 			DEBPRINT("identify device %s failed (%d)\n",
@@ -736,9 +628,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT)
-			/* Execute ACPI startup code */
-			ide_acpi_exec_tfs(drive);
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_acpi_exec_tfs(drive);
 	}
 }
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e9d042d..6adc5b4 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -149,7 +149,10 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
-	ide_do_drive_cmd(drive, rq);
+
+	drive->hwif->rq = NULL;
+
+	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
 /*
@@ -297,6 +300,21 @@ int ide_cd_get_xferlen(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
+void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+			IDE_TFLAG_IN_NSECT;
+
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
+	*ireason = task.tf.nsect & 3;
+}
+EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
+
 /*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
@@ -456,6 +474,25 @@ next_irq:
 	return ide_started;
 }
 
+static void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t task;
+	u8 dma = drive->dma;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+			IDE_TFLAG_OUT_FEATURE | tf_flags;
+	task.tf.feature = dma;		/* Use PIO/DMA */
+	task.tf.lbam    = bcount & 0xff;
+	task.tf.lbah    = (bcount >> 8) & 0xff;
+
+	ide_tf_dump(drive->name, &task.tf);
+	hwif->tp_ops->set_irq(hwif, 1);
+	SELECT_MASK(drive, 0);
+	hwif->tp_ops->tf_load(drive, &task);
+}
+
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
 	ide_task_t task;
@@ -629,7 +666,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 						       : WAIT_TAPE_CMD;
 	}
 
-	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
+	ide_pktcmd_tf_load(drive, tf_flags, bcount);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ddfbea4..2177cd1 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -242,7 +242,9 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
 			      failed_command->cmd[0]);
 
-	ide_do_drive_cmd(drive, rq);
+	drive->hwif->rq = NULL;
+
+	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
new file mode 100644
index 0000000..7c39534
--- /dev/null
+++ b/drivers/ide/ide-devsets.c
@@ -0,0 +1,190 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+DEFINE_MUTEX(ide_setting_mtx);
+
+ide_devset_get(io_32bit, io_32bit);
+
+static int set_io_32bit(ide_drive_t *drive, int arg)
+{
+	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
+		return -EPERM;
+
+	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
+		return -EINVAL;
+
+	drive->io_32bit = arg;
+
+	return 0;
+}
+
+ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
+
+static int set_ksettings(ide_drive_t *drive, int arg)
+{
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
+
+	return 0;
+}
+
+ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
+
+static int set_using_dma(ide_drive_t *drive, int arg)
+{
+#ifdef CONFIG_BLK_DEV_IDEDMA
+	int err = -EPERM;
+
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (ata_id_has_dma(drive->id) == 0)
+		goto out;
+
+	if (drive->hwif->dma_ops == NULL)
+		goto out;
+
+	err = 0;
+
+	if (arg) {
+		if (ide_set_dma(drive))
+			err = -EIO;
+	} else
+		ide_dma_off(drive);
+
+out:
+	return err;
+#else
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	return -EPERM;
+#endif
+}
+
+/*
+ * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
+ */
+static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
+{
+	switch (req_pio) {
+	case 202:
+	case 201:
+	case 200:
+	case 102:
+	case 101:
+	case 100:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
+	case 9:
+	case 8:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
+	case 7:
+	case 6:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
+static int set_pio_mode(ide_drive_t *drive, int arg)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (arg < 0 || arg > 255)
+		return -EINVAL;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return -ENOSYS;
+
+	if (set_pio_mode_abuse(drive->hwif, arg)) {
+		if (arg == 8 || arg == 9) {
+			unsigned long flags;
+
+			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
+			spin_lock_irqsave(&hwif->lock, flags);
+			port_ops->set_pio_mode(drive, arg);
+			spin_unlock_irqrestore(&hwif->lock, flags);
+		} else
+			port_ops->set_pio_mode(drive, arg);
+	} else {
+		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+
+		ide_set_pio(drive, arg);
+
+		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
+			if (keep_dma)
+				ide_dma_on(drive);
+		}
+	}
+
+	return 0;
+}
+
+ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
+
+static int set_unmaskirq(ide_drive_t *drive, int arg)
+{
+	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
+		return -EPERM;
+
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
+
+	return 0;
+}
+
+ide_ext_devset_rw_sync(io_32bit, io_32bit);
+ide_ext_devset_rw_sync(keepsettings, ksettings);
+ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
+ide_ext_devset_rw_sync(using_dma, using_dma);
+__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
+
+int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
+		       int arg)
+{
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	int ret = 0;
+
+	if (!(setting->flags & DS_SYNC))
+		return setting->set(drive, arg);
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 5;
+	rq->cmd[0] = REQ_DEVSET_EXEC;
+	*(int *)&rq->cmd[1] = arg;
+	rq->special = setting->set;
+
+	if (blk_execute_rq(q, NULL, rq, 0))
+		ret = rq->errors;
+	blk_put_request(rq);
+
+	return ret;
+}
+
+ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
+{
+	int err, (*setfunc)(ide_drive_t *, int) = rq->special;
+
+	err = setfunc(drive, *(int *)&rq->cmd[1]);
+	if (err)
+		rq->errors = err;
+	else
+		err = 1;
+	ide_end_request(drive, err, 0);
+	return ide_stopped;
+}
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 059c90b..a878f47 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -470,6 +470,63 @@ void ide_dma_timeout(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_dma_timeout);
 
+/*
+ * un-busy the port etc, and clear any pending DMA status. we want to
+ * retry the current request in pio mode instead of risking tossing it
+ * all away
+ */
+ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq;
+	ide_startstop_t ret = ide_stopped;
+
+	/*
+	 * end current dma transaction
+	 */
+
+	if (error < 0) {
+		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
+		(void)hwif->dma_ops->dma_end(drive);
+		ret = ide_error(drive, "dma timeout error",
+				hwif->tp_ops->read_status(hwif));
+	} else {
+		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
+		hwif->dma_ops->dma_timeout(drive);
+	}
+
+	/*
+	 * disable dma for now, but remember that we did so because of
+	 * a timeout -- we'll reenable after we finish this next request
+	 * (or rather the first chunk of it) in pio.
+	 */
+	drive->dev_flags |= IDE_DFLAG_DMA_PIO_RETRY;
+	drive->retry_pio++;
+	ide_dma_off_quietly(drive);
+
+	/*
+	 * un-busy drive etc and make sure request is sane
+	 */
+
+	rq = hwif->rq;
+	if (!rq)
+		goto out;
+
+	hwif->rq = NULL;
+
+	rq->errors = 0;
+
+	if (!rq->bio)
+		goto out;
+
+	rq->sector = rq->bio->bi_sector;
+	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
+	rq->hard_cur_sectors = rq->current_nr_sectors;
+	rq->buffer = bio_data(rq->bio);
+out:
+	return ret;
+}
+
 void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
new file mode 100644
index 0000000..1231b5e
--- /dev/null
+++ b/drivers/ide/ide-eh.c
@@ -0,0 +1,428 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/delay.h>
+
+static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
+				     u8 stat, u8 err)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+		/* other bits are useless when BUSY */
+		rq->errors |= ERROR_RESET;
+	} else if (stat & ATA_ERR) {
+		/* err has different meaning on cdrom and tape */
+		if (err == ATA_ABORTED) {
+			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
+			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
+			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
+				return ide_stopped;
+		} else if ((err & BAD_CRC) == BAD_CRC) {
+			/* UDMA crc error, just retry the operation */
+			drive->crc_count++;
+		} else if (err & (ATA_BBK | ATA_UNC)) {
+			/* retries won't help these */
+			rq->errors = ERROR_MAX;
+		} else if (err & ATA_TRK0NF) {
+			/* help it find track zero */
+			rq->errors |= ERROR_RECAL;
+		}
+	}
+
+	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
+	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
+		int nsect = drive->mult_count ? drive->mult_count : 1;
+
+		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
+	}
+
+	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
+		ide_kill_rq(drive, rq);
+		return ide_stopped;
+	}
+
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
+		rq->errors |= ERROR_RESET;
+
+	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
+		++rq->errors;
+		return ide_do_reset(drive);
+	}
+
+	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
+		drive->special.b.recalibrate = 1;
+
+	++rq->errors;
+
+	return ide_stopped;
+}
+
+static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
+				       u8 stat, u8 err)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+		/* other bits are useless when BUSY */
+		rq->errors |= ERROR_RESET;
+	} else {
+		/* add decoding error stuff */
+	}
+
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
+		/* force an abort */
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
+
+	if (rq->errors >= ERROR_MAX) {
+		ide_kill_rq(drive, rq);
+	} else {
+		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
+			++rq->errors;
+			return ide_do_reset(drive);
+		}
+		++rq->errors;
+	}
+
+	return ide_stopped;
+}
+
+static ide_startstop_t __ide_error(ide_drive_t *drive, struct request *rq,
+				   u8 stat, u8 err)
+{
+	if (drive->media == ide_disk)
+		return ide_ata_error(drive, rq, stat, err);
+	return ide_atapi_error(drive, rq, stat, err);
+}
+
+/**
+ *	ide_error	-	handle an error on the IDE
+ *	@drive: drive the error occurred on
+ *	@msg: message to report
+ *	@stat: status bits
+ *
+ *	ide_error() takes action based on the error returned by the drive.
+ *	For normal I/O that may well include retries. We deal with
+ *	both new-style (taskfile) and old style command handling here.
+ *	In the case of taskfile command handling there is work left to
+ *	do
+ */
+
+ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
+{
+	struct request *rq;
+	u8 err;
+
+	err = ide_dump_status(drive, msg, stat);
+
+	rq = drive->hwif->rq;
+	if (rq == NULL)
+		return ide_stopped;
+
+	/* retry only "normal" I/O: */
+	if (!blk_fs_request(rq)) {
+		rq->errors = 1;
+		ide_end_drive_cmd(drive, stat, err);
+		return ide_stopped;
+	}
+
+	return __ide_error(drive, rq, stat, err);
+}
+EXPORT_SYMBOL_GPL(ide_error);
+
+static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
+{
+	struct request *rq = drive->hwif->rq;
+
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
+		ide_end_request(drive, err ? err : 1, 0);
+}
+
+/* needed below */
+static ide_startstop_t do_reset1(ide_drive_t *, int);
+
+/*
+ * atapi_reset_pollfunc() gets invoked to poll the interface for completion
+ * every 50ms during an atapi drive reset operation.  If the drive has not yet
+ * responded, and we have not yet hit our maximum waiting time, then the timer
+ * is restarted for another 50ms.
+ */
+static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat;
+
+	SELECT_DRIVE(drive);
+	udelay(10);
+	stat = hwif->tp_ops->read_status(hwif);
+
+	if (OK_STAT(stat, 0, ATA_BUSY))
+		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
+	else {
+		if (time_before(jiffies, hwif->poll_timeout)) {
+			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
+					NULL);
+			/* continue polling */
+			return ide_started;
+		}
+		/* end of polling */
+		hwif->polling = 0;
+		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
+			drive->name, stat);
+		/* do it the old fashioned way */
+		return do_reset1(drive, 1);
+	}
+	/* done polling */
+	hwif->polling = 0;
+	ide_complete_drive_reset(drive, 0);
+	return ide_stopped;
+}
+
+static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
+{
+	static const char *err_master_vals[] =
+		{ NULL, "passed", "formatter device error",
+		  "sector buffer error", "ECC circuitry error",
+		  "controlling MPU error" };
+
+	u8 err_master = err & 0x7f;
+
+	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	if (err_master && err_master < 6)
+		printk(KERN_CONT "%s", err_master_vals[err_master]);
+	else
+		printk(KERN_CONT "error (0x%02x?)", err);
+	if (err & 0x80)
+		printk(KERN_CONT "; slave: failed");
+	printk(KERN_CONT "\n");
+}
+
+/*
+ * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
+ * during an ide reset operation. If the drives have not yet responded,
+ * and we have not yet hit our maximum waiting time, then the timer is restarted
+ * for another 50ms.
+ */
+static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+	u8 tmp;
+	int err = 0;
+
+	if (port_ops && port_ops->reset_poll) {
+		err = port_ops->reset_poll(drive);
+		if (err) {
+			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
+				hwif->name, drive->name);
+			goto out;
+		}
+	}
+
+	tmp = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
+			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+			/* continue polling */
+			return ide_started;
+		}
+		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
+			hwif->name, tmp);
+		drive->failures++;
+		err = -EIO;
+	} else  {
+		tmp = ide_read_error(drive);
+
+		if (tmp == 1) {
+			printk(KERN_INFO "%s: reset: success\n", hwif->name);
+			drive->failures = 0;
+		} else {
+			ide_reset_report_error(hwif, tmp);
+			drive->failures++;
+			err = -EIO;
+		}
+	}
+out:
+	hwif->polling = 0;	/* done polling */
+	ide_complete_drive_reset(drive, err);
+	return ide_stopped;
+}
+
+static void ide_disk_pre_reset(ide_drive_t *drive)
+{
+	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
+
+	drive->special.all = 0;
+	drive->special.b.set_geometry = legacy;
+	drive->special.b.recalibrate  = legacy;
+
+	drive->mult_count = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PARKED;
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
+		drive->mult_req = 0;
+
+	if (drive->mult_req != drive->mult_count)
+		drive->special.b.set_multmode = 1;
+}
+
+static void pre_reset(ide_drive_t *drive)
+{
+	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
+
+	if (drive->media == ide_disk)
+		ide_disk_pre_reset(drive);
+	else
+		drive->dev_flags |= IDE_DFLAG_POST_RESET;
+
+	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
+		if (drive->crc_count)
+			ide_check_dma_crc(drive);
+		else
+			ide_dma_off(drive);
+	}
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
+			drive->io_32bit = 0;
+		}
+		return;
+	}
+
+	if (port_ops && port_ops->pre_reset)
+		port_ops->pre_reset(drive);
+
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
+}
+
+/*
+ * do_reset1() attempts to recover a confused drive by resetting it.
+ * Unfortunately, resetting a disk drive actually resets all devices on
+ * the same interface, so it can really be thought of as resetting the
+ * interface rather than resetting the drive.
+ *
+ * ATAPI devices have their own reset mechanism which allows them to be
+ * individually reset without clobbering other devices on the same interface.
+ *
+ * Unfortunately, the IDE interface does not generate an interrupt to let
+ * us know when the reset operation has finished, so we must poll for this.
+ * Equally poor, though, is the fact that this may a very long time to complete,
+ * (up to 30 seconds worstcase).  So, instead of busy-waiting here for it,
+ * we set a timer to poll at 50ms intervals.
+ */
+static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	const struct ide_port_ops *port_ops;
+	ide_drive_t *tdrive;
+	unsigned long flags, timeout;
+	int i;
+	DEFINE_WAIT(wait);
+
+	spin_lock_irqsave(&hwif->lock, flags);
+
+	/* We must not reset with running handlers */
+	BUG_ON(hwif->handler != NULL);
+
+	/* For an ATAPI device, first try an ATAPI SRST. */
+	if (drive->media != ide_disk && !do_not_try_atapi) {
+		pre_reset(drive);
+		SELECT_DRIVE(drive);
+		udelay(20);
+		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
+		ndelay(400);
+		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+		hwif->polling = 1;
+		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		return ide_started;
+	}
+
+	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
+	do {
+		unsigned long now;
+
+		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
+		timeout = jiffies;
+		ide_port_for_each_present_dev(i, tdrive, hwif) {
+			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
+			    time_after(tdrive->sleep, timeout))
+				timeout = tdrive->sleep;
+		}
+
+		now = jiffies;
+		if (time_before_eq(timeout, now))
+			break;
+
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		timeout = schedule_timeout_uninterruptible(timeout - now);
+		spin_lock_irqsave(&hwif->lock, flags);
+	} while (timeout);
+	finish_wait(&ide_park_wq, &wait);
+
+	/*
+	 * First, reset any device state data we were maintaining
+	 * for any of the drives on this interface.
+	 */
+	ide_port_for_each_dev(i, tdrive, hwif)
+		pre_reset(tdrive);
+
+	if (io_ports->ctl_addr == 0) {
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		ide_complete_drive_reset(drive, -ENXIO);
+		return ide_stopped;
+	}
+
+	/*
+	 * Note that we also set nIEN while resetting the device,
+	 * to mask unwanted interrupts from the interface during the reset.
+	 * However, due to the design of PC hardware, this will cause an
+	 * immediate interrupt due to the edge transition it produces.
+	 * This single interrupt gives us a "fast poll" for drives that
+	 * recover from reset very quickly, saving us the first 50ms wait time.
+	 *
+	 * TODO: add ->softreset method and stop abusing ->set_irq
+	 */
+	/* set SRST and nIEN */
+	tp_ops->set_irq(hwif, 4);
+	/* more than enough time */
+	udelay(10);
+	/* clear SRST, leave nIEN (unless device is on the quirk list) */
+	tp_ops->set_irq(hwif, drive->quirk_list == 2);
+	/* more than enough time */
+	udelay(10);
+	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+	hwif->polling = 1;
+	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+
+	/*
+	 * Some weird controller like resetting themselves to a strange
+	 * state when the disks are reset this way. At least, the Winbond
+	 * 553 documentation says that
+	 */
+	port_ops = hwif->port_ops;
+	if (port_ops && port_ops->resetproc)
+		port_ops->resetproc(drive);
+
+	spin_unlock_irqrestore(&hwif->lock, flags);
+	return ide_started;
+}
+
+/*
+ * ide_do_reset() is the entry point to the drive/interface reset code.
+ */
+
+ide_startstop_t ide_do_reset(ide_drive_t *drive)
+{
+	return do_reset1(drive, 0);
+}
+EXPORT_SYMBOL(ide_do_reset);
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
new file mode 100644
index 0000000..45b43dd
--- /dev/null
+++ b/drivers/ide/ide-io-std.c
@@ -0,0 +1,316 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+/*
+ *	Conventional PIO operations for ATA devices
+ */
+
+static u8 ide_inb(unsigned long port)
+{
+	return (u8) inb(port);
+}
+
+static void ide_outb(u8 val, unsigned long port)
+{
+	outb(val, port);
+}
+
+/*
+ *	MMIO operations, typically used for SATA controllers
+ */
+
+static u8 ide_mm_inb(unsigned long port)
+{
+	return (u8) readb((void __iomem *) port);
+}
+
+static void ide_mm_outb(u8 value, unsigned long port)
+{
+	writeb(value, (void __iomem *) port);
+}
+
+void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
+	else
+		outb(cmd, hwif->io_ports.command_addr);
+}
+EXPORT_SYMBOL_GPL(ide_exec_command);
+
+u8 ide_read_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.status_addr);
+	else
+		return inb(hwif->io_ports.status_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_status);
+
+u8 ide_read_altstatus(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		return inb(hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_read_altstatus);
+
+void ide_set_irq(ide_hwif_t *hwif, int on)
+{
+	u8 ctl = ATA_DEVCTL_OBS;
+
+	if (on == 4) { /* hack for SRST */
+		ctl |= 4;
+		on &= ~4;
+	}
+
+	ctl |= on ? 0 : 2;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
+	else
+		outb(ctl, hwif->io_ports.ctl_addr);
+}
+EXPORT_SYMBOL_GPL(ide_set_irq);
+
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (mmio)
+		tf_outb = ide_mm_outb;
+	else
+		tf_outb = ide_outb;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		if (mmio)
+			writew(data, (void __iomem *)io_ports->data_addr);
+		else
+			outw(data, io_ports->data_addr);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		tf_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		tf_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		tf_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		tf_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		tf_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		tf_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tf_outb((tf->device & HIHI) | drive->select,
+			 io_ports->device_addr);
+}
+EXPORT_SYMBOL_GPL(ide_tf_load);
+
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	void (*tf_outb)(u8 addr, unsigned long port);
+	u8 (*tf_inb)(unsigned long port);
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	if (mmio) {
+		tf_outb = ide_mm_outb;
+		tf_inb  = ide_mm_inb;
+	} else {
+		tf_outb = ide_outb;
+		tf_inb  = ide_inb;
+	}
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		if (mmio)
+			data = readw((void __iomem *)io_ports->data_addr);
+		else
+			data = inw(io_ports->data_addr);
+
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = tf_inb(io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = tf_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = tf_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = tf_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = tf_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = tf_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = tf_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_tf_read);
+
+/*
+ * Some localbus EIDE interfaces require a special access sequence
+ * when using 32-bit I/O instructions to transfer data.  We call this
+ * the "vlb_sync" sequence, which consists of three successive reads
+ * of the sector count register location, with interrupts disabled
+ * to ensure that the reads all happen together.
+ */
+static void ata_vlb_sync(unsigned long port)
+{
+	(void)inb(port);
+	(void)inb(port);
+	(void)inb(port);
+}
+
+/*
+ * This is used for most PIO data transfers *from* the IDE interface
+ *
+ * These routines will round up any request for an odd number of bytes,
+ * so if an odd len is specified, be sure that there's at least one
+ * extra byte allocated for the buffer.
+ */
+void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+		    unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
+	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	len++;
+
+	if (io_32bit) {
+		unsigned long uninitialized_var(flags);
+
+		if ((io_32bit & 2) && !mmio) {
+			local_irq_save(flags);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
+
+		if (mmio)
+			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
+		else
+			insl(data_addr, buf, len / 4);
+
+		if ((io_32bit & 2) && !mmio)
+			local_irq_restore(flags);
+
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_insw((void __iomem *)data_addr,
+						(u8 *)buf + (len & ~3), 1);
+			else
+				insw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
+		else
+			insw(data_addr, buf, len / 2);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_input_data);
+
+/*
+ * This is used for most PIO data transfers *to* the IDE interface
+ */
+void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+		     unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
+	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+
+	len++;
+
+	if (io_32bit) {
+		unsigned long uninitialized_var(flags);
+
+		if ((io_32bit & 2) && !mmio) {
+			local_irq_save(flags);
+			ata_vlb_sync(io_ports->nsect_addr);
+		}
+
+		if (mmio)
+			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
+		else
+			outsl(data_addr, buf, len / 4);
+
+		if ((io_32bit & 2) && !mmio)
+			local_irq_restore(flags);
+
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_outsw((void __iomem *)data_addr,
+						 (u8 *)buf + (len & ~3), 1);
+			else
+				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
+		else
+			outsw(data_addr, buf, len / 2);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_output_data);
+
+const struct ide_tp_ops default_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index a9a6c20..2e92497 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -196,7 +196,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 }
 EXPORT_SYMBOL(ide_end_drive_cmd);
 
-static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
+void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
 	if (rq->rq_disk) {
 		struct ide_driver *drv;
@@ -207,133 +207,6 @@ static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 		ide_end_request(drive, 0, 0);
 }
 
-static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
-		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
-	} else if (stat & ATA_ERR) {
-		/* err has different meaning on cdrom and tape */
-		if (err == ATA_ABORTED) {
-			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
-			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
-			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
-				return ide_stopped;
-		} else if ((err & BAD_CRC) == BAD_CRC) {
-			/* UDMA crc error, just retry the operation */
-			drive->crc_count++;
-		} else if (err & (ATA_BBK | ATA_UNC)) {
-			/* retries won't help these */
-			rq->errors = ERROR_MAX;
-		} else if (err & ATA_TRK0NF) {
-			/* help it find track zero */
-			rq->errors |= ERROR_RECAL;
-		}
-	}
-
-	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
-	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
-		int nsect = drive->mult_count ? drive->mult_count : 1;
-
-		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
-	}
-
-	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
-		ide_kill_rq(drive, rq);
-		return ide_stopped;
-	}
-
-	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		rq->errors |= ERROR_RESET;
-
-	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-		++rq->errors;
-		return ide_do_reset(drive);
-	}
-
-	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-		drive->special.b.recalibrate = 1;
-
-	++rq->errors;
-
-	return ide_stopped;
-}
-
-static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
-		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
-	} else {
-		/* add decoding error stuff */
-	}
-
-	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
-
-	if (rq->errors >= ERROR_MAX) {
-		ide_kill_rq(drive, rq);
-	} else {
-		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-			++rq->errors;
-			return ide_do_reset(drive);
-		}
-		++rq->errors;
-	}
-
-	return ide_stopped;
-}
-
-static ide_startstop_t
-__ide_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	if (drive->media == ide_disk)
-		return ide_ata_error(drive, rq, stat, err);
-	return ide_atapi_error(drive, rq, stat, err);
-}
-
-/**
- *	ide_error	-	handle an error on the IDE
- *	@drive: drive the error occurred on
- *	@msg: message to report
- *	@stat: status bits
- *
- *	ide_error() takes action based on the error returned by the drive.
- *	For normal I/O that may well include retries. We deal with
- *	both new-style (taskfile) and old style command handling here.
- *	In the case of taskfile command handling there is work left to
- *	do
- */
- 
-ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
-{
-	struct request *rq;
-	u8 err;
-
-	err = ide_dump_status(drive, msg, stat);
-
-	rq = drive->hwif->rq;
-	if (rq == NULL)
-		return ide_stopped;
-
-	/* retry only "normal" I/O: */
-	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
-		ide_end_drive_cmd(drive, stat, err);
-		return ide_stopped;
-	}
-
-	return __ide_error(drive, rq, stat, err);
-}
-EXPORT_SYMBOL_GPL(ide_error);
-
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
@@ -490,71 +363,16 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  	return ide_stopped;
 }
 
-int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
-		       int arg)
-{
-	struct request_queue *q = drive->queue;
-	struct request *rq;
-	int ret = 0;
-
-	if (!(setting->flags & DS_SYNC))
-		return setting->set(drive, arg);
-
-	rq = blk_get_request(q, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_len = 5;
-	rq->cmd[0] = REQ_DEVSET_EXEC;
-	*(int *)&rq->cmd[1] = arg;
-	rq->special = setting->set;
-
-	if (blk_execute_rq(q, NULL, rq, 0))
-		ret = rq->errors;
-	blk_put_request(rq);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ide_devset_execute);
-
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
 	u8 cmd = rq->cmd[0];
 
-	if (cmd == REQ_PARK_HEADS || cmd == REQ_UNPARK_HEADS) {
-		ide_task_t task;
-		struct ide_taskfile *tf = &task.tf;
-
-		memset(&task, 0, sizeof(task));
-		if (cmd == REQ_PARK_HEADS) {
-			drive->sleep = *(unsigned long *)rq->special;
-			drive->dev_flags |= IDE_DFLAG_SLEEPING;
-			tf->command = ATA_CMD_IDLEIMMEDIATE;
-			tf->feature = 0x44;
-			tf->lbal = 0x4c;
-			tf->lbam = 0x4e;
-			tf->lbah = 0x55;
-			task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
-		} else		/* cmd == REQ_UNPARK_HEADS */
-			tf->command = ATA_CMD_CHK_POWER;
-
-		task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-		task.rq = rq;
-		drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
-		return do_rw_taskfile(drive, &task);
-	}
-
 	switch (cmd) {
+	case REQ_PARK_HEADS:
+	case REQ_UNPARK_HEADS:
+		return ide_do_park_unpark(drive, rq);
 	case REQ_DEVSET_EXEC:
-	{
-		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
-
-		err = setfunc(drive, *(int *)&rq->cmd[1]);
-		if (err)
-			rq->errors = err;
-		else
-			err = 1;
-		ide_end_request(drive, err, 0);
-		return ide_stopped;
-	}
+		return ide_do_devset(drive, rq);
 	case REQ_DRIVE_RESET:
 		return ide_do_reset(drive);
 	default:
@@ -820,63 +638,6 @@ plug_device_2:
 		blk_plug_device(q);
 }
 
-/*
- * un-busy the port etc, and clear any pending DMA status. we want to
- * retry the current request in pio mode instead of risking tossing it
- * all away
- */
-static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq;
-	ide_startstop_t ret = ide_stopped;
-
-	/*
-	 * end current dma transaction
-	 */
-
-	if (error < 0) {
-		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)hwif->dma_ops->dma_end(drive);
-		ret = ide_error(drive, "dma timeout error",
-				hwif->tp_ops->read_status(hwif));
-	} else {
-		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_ops->dma_timeout(drive);
-	}
-
-	/*
-	 * disable dma for now, but remember that we did so because of
-	 * a timeout -- we'll reenable after we finish this next request
-	 * (or rather the first chunk of it) in pio.
-	 */
-	drive->dev_flags |= IDE_DFLAG_DMA_PIO_RETRY;
-	drive->retry_pio++;
-	ide_dma_off_quietly(drive);
-
-	/*
-	 * un-busy drive etc and make sure request is sane
-	 */
-
-	rq = hwif->rq;
-	if (!rq)
-		goto out;
-
-	hwif->rq = NULL;
-
-	rq->errors = 0;
-
-	if (!rq->bio)
-		goto out;
-
-	rq->sector = rq->bio->bi_sector;
-	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->buffer = bio_data(rq->bio);
-out:
-	return ret;
-}
-
 static void ide_plug_device(ide_drive_t *drive)
 {
 	struct request_queue *q = drive->queue;
@@ -888,6 +649,29 @@ static void ide_plug_device(ide_drive_t *drive)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+static int drive_is_ready(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = 0;
+
+	if (drive->waiting_for_dma)
+		return hwif->dma_ops->dma_test_irq(drive);
+
+	if (hwif->io_ports.ctl_addr &&
+	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0)
+		stat = hwif->tp_ops->read_altstatus(hwif);
+	else
+		/* Note: this may clear a pending IRQ!! */
+		stat = hwif->tp_ops->read_status(hwif);
+
+	if (stat & ATA_BUSY)
+		/* drive busy: definitely not interrupting */
+		return 0;
+
+	/* drive ready: *might* be interrupting */
+	return 1;
+}
+
 /**
  *	ide_timer_expiry	-	handle lack of an IDE interrupt
  *	@data: timer callback magic (hwif)
@@ -1164,54 +948,6 @@ out_early:
 }
 EXPORT_SYMBOL_GPL(ide_intr);
 
-/**
- *	ide_do_drive_cmd	-	issue IDE special command
- *	@drive: device to issue command
- *	@rq: request to issue
- *
- *	This function issues a special IDE device request
- *	onto the request queue.
- *
- *	the rq is queued at the head of the request queue, displacing
- *	the currently-being-processed request and this function
- *	returns immediately without waiting for the new rq to be
- *	completed.  This is VERY DANGEROUS, and is intended for
- *	careful use by the ATAPI tape/cdrom driver code.
- */
-
-void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
-{
-	struct request_queue *q = drive->queue;
-	unsigned long flags;
-
-	drive->hwif->rq = NULL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(ide_do_drive_cmd);
-
-void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			IDE_TFLAG_OUT_FEATURE | tf_flags;
-	task.tf.feature = dma;		/* Use PIO/DMA */
-	task.tf.lbam    = bcount & 0xff;
-	task.tf.lbah    = (bcount >> 8) & 0xff;
-
-	ide_tf_dump(drive->name, &task.tf);
-	hwif->tp_ops->set_irq(hwif, 1);
-	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &task);
-}
-
-EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
-
 void ide_pad_transfer(ide_drive_t *drive, int write, int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index b1892bd..317c5da 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -27,35 +27,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-/*
- *	Conventional PIO operations for ATA devices
- */
-
-static u8 ide_inb (unsigned long port)
-{
-	return (u8) inb(port);
-}
-
-static void ide_outb (u8 val, unsigned long port)
-{
-	outb(val, port);
-}
-
-/*
- *	MMIO operations, typically used for SATA controllers
- */
-
-static u8 ide_mm_inb (unsigned long port)
-{
-	return (u8) readb((void __iomem *) port);
-}
-
-static void ide_mm_outb (u8 value, unsigned long port)
-{
-	writeb(value, (void __iomem *) port);
-}
-
-void SELECT_DRIVE (ide_drive_t *drive)
+void SELECT_DRIVE(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
@@ -78,277 +50,6 @@ void SELECT_MASK(ide_drive_t *drive, int mask)
 		port_ops->maskproc(drive, mask);
 }
 
-void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
-	else
-		outb(cmd, hwif->io_ports.command_addr);
-}
-EXPORT_SYMBOL_GPL(ide_exec_command);
-
-u8 ide_read_status(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.status_addr);
-	else
-		return inb(hwif->io_ports.status_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_status);
-
-u8 ide_read_altstatus(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		return inb(hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_altstatus);
-
-void ide_set_irq(ide_hwif_t *hwif, int on)
-{
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		outb(ctl, hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_set_irq);
-
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (mmio)
-		tf_outb = ide_mm_outb;
-	else
-		tf_outb = ide_outb;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		if (mmio)
-			writew(data, (void __iomem *)io_ports->data_addr);
-		else
-			outw(data, io_ports->data_addr);
-	}
-
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tf_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tf_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select,
-			 io_ports->device_addr);
-}
-EXPORT_SYMBOL_GPL(ide_tf_load);
-
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 (*tf_inb)(unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	if (mmio) {
-		tf_outb = ide_mm_outb;
-		tf_inb  = ide_mm_inb;
-	} else {
-		tf_outb = ide_outb;
-		tf_inb  = ide_inb;
-	}
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data;
-
-		if (mmio)
-			data = readw((void __iomem *)io_ports->data_addr);
-		else
-			data = inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
-	/* be sure we're looking at the low order bits */
-	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
-
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tf_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tf_inb(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = tf_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_tf_read);
-
-/*
- * Some localbus EIDE interfaces require a special access sequence
- * when using 32-bit I/O instructions to transfer data.  We call this
- * the "vlb_sync" sequence, which consists of three successive reads
- * of the sector count register location, with interrupts disabled
- * to ensure that the reads all happen together.
- */
-static void ata_vlb_sync(unsigned long port)
-{
-	(void)inb(port);
-	(void)inb(port);
-	(void)inb(port);
-}
-
-/*
- * This is used for most PIO data transfers *from* the IDE interface
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd len is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
-		    unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	len++;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
-		else
-			insl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_insw((void __iomem *)data_addr,
-						(u8 *)buf + (len & ~3), 1);
-			else
-				insw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
-		else
-			insw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_input_data);
-
-/*
- * This is used for most PIO data transfers *to* the IDE interface
- */
-void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
-		     unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	len++;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
-		else
-			outsl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_outsw((void __iomem *)data_addr,
-						 (u8 *)buf + (len & ~3), 1);
-			else
-				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
-		else
-			outsw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_output_data);
-
 u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_task_t task;
@@ -362,35 +63,6 @@ u8 ide_read_error(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
-void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
-{
-	ide_task_t task;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-			IDE_TFLAG_IN_NSECT;
-
-	drive->hwif->tp_ops->tf_read(drive, &task);
-
-	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
-	*ireason = task.tf.nsect & 3;
-}
-EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
-
-const struct ide_tp_ops default_tp_ops = {
-	.exec_command		= ide_exec_command,
-	.read_status		= ide_read_status,
-	.read_altstatus		= ide_read_altstatus,
-
-	.set_irq		= ide_set_irq,
-
-	.tf_load		= ide_tf_load,
-	.tf_read		= ide_tf_read,
-
-	.input_data		= ide_input_data,
-	.output_data		= ide_output_data,
-};
-
 void ide_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
@@ -412,7 +84,7 @@ void ide_fix_driveid(u16 *id)
  * returned by the ATA_CMD_ID_ATA[PI] commands.
  */
 
-void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
+void ide_fixstring(u8 *s, const int bytecount, const int byteswap)
 {
 	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
 
@@ -435,44 +107,9 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 	while (p != end)
 		*p++ = '\0';
 }
-
 EXPORT_SYMBOL(ide_fixstring);
 
 /*
- * Needed for PCI irq sharing
- */
-int drive_is_ready (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	u8 stat			= 0;
-
-	if (drive->waiting_for_dma)
-		return hwif->dma_ops->dma_test_irq(drive);
-
-	/*
-	 * We do a passive status test under shared PCI interrupts on
-	 * cards that truly share the ATA side interrupt, but may also share
-	 * an interrupt with another pci card/device.  We make no assumptions
-	 * about possible isa-pnp and pci-pnp issues yet.
-	 */
-	if (hwif->io_ports.ctl_addr &&
-	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0)
-		stat = hwif->tp_ops->read_altstatus(hwif);
-	else
-		/* Note: this may clear a pending IRQ!! */
-		stat = hwif->tp_ops->read_status(hwif);
-
-	if (stat & ATA_BUSY)
-		/* drive busy:  definitely not interrupting */
-		return 0;
-
-	/* drive ready: *might* be interrupting */
-	return 1;
-}
-
-EXPORT_SYMBOL(drive_is_ready);
-
-/*
  * This routine busy-waits for the drive status to be not "busy".
  * It then checks the status for all of the "good" bits and none
  * of the "bad" bits, and if all is okay it returns 0.  All other
@@ -483,7 +120,8 @@ EXPORT_SYMBOL(drive_is_ready);
  * setting a timer to wake up at half second intervals thereafter,
  * until timeout is achieved, before timing out.
  */
-static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
+static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad,
+			   unsigned long timeout, u8 *rstat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
@@ -541,7 +179,8 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
  * The caller should return the updated value of "startstop" in this case,
  * "startstop" is unchanged when the function returns 0.
  */
-int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout)
+int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good,
+		  u8 bad, unsigned long timeout)
 {
 	int err;
 	u8 stat;
@@ -561,7 +200,6 @@ int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 ba
 
 	return err;
 }
-
 EXPORT_SYMBOL(ide_wait_stat);
 
 /**
@@ -582,7 +220,6 @@ int ide_in_drive_list(u16 *id, const struct drive_list_entry *table)
 			return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ide_in_drive_list);
 
 /*
@@ -607,7 +244,7 @@ static const struct drive_list_entry ivb_list[] = {
  *  All hosts that use the 80c ribbon must use!
  *  The name is derived from upper byte of word 93 and the 80c ribbon.
  */
-u8 eighty_ninty_three (ide_drive_t *drive)
+u8 eighty_ninty_three(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
@@ -652,47 +289,19 @@ no_80w:
 
 int ide_driveid_update(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u16 *id;
-	unsigned long flags;
-	u8 stat;
-
-	/*
-	 * Re-read drive->id for possible DMA mode
-	 * change (copied from ide-probe.c)
-	 */
-
-	SELECT_MASK(drive, 1);
-	tp_ops->set_irq(hwif, 0);
-	msleep(50);
-	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
+	int rc;
 
-	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 1)) {
-		SELECT_MASK(drive, 0);
+	id = kmalloc(SECTOR_SIZE, GFP_ATOMIC);
+	if (id == NULL)
 		return 0;
-	}
-
-	msleep(50);	/* wait for IRQ and ATA_DRQ */
-	stat = tp_ops->read_status(hwif);
 
-	if (!OK_STAT(stat, ATA_DRQ, BAD_R_STAT)) {
-		SELECT_MASK(drive, 0);
-		printk("%s: CHECK for good STATUS\n", drive->name);
-		return 0;
-	}
-	local_irq_save(flags);
+	SELECT_MASK(drive, 1);
+	rc = ide_dev_read_id(drive, ATA_CMD_ID_ATA, id);
 	SELECT_MASK(drive, 0);
-	id = kmalloc(SECTOR_SIZE, GFP_ATOMIC);
-	if (!id) {
-		local_irq_restore(flags);
-		return 0;
-	}
-	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
-	(void)tp_ops->read_status(hwif);	/* clear drive IRQ */
-	local_irq_enable();
-	local_irq_restore(flags);
-	ide_fix_driveid(id);
+
+	if (rc)
+		goto out_err;
 
 	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
 	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
@@ -705,6 +314,12 @@ int ide_driveid_update(ide_drive_t *drive)
 		ide_dma_off(drive);
 
 	return 1;
+out_err:
+	SELECT_MASK(drive, 0);
+	if (rc == 2)
+		printk(KERN_ERR "%s: %s: bad status\n", drive->name, __func__);
+	kfree(id);
+	return 0;
 }
 
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
@@ -731,18 +346,15 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	 * but for some reason these don't work at
 	 * this point (lost interrupt).
 	 */
-        /*
-         * Select the drive, and issue the SETFEATURES command
-         */
-	disable_irq_nosync(hwif->irq);
-	
+
 	/*
 	 *	FIXME: we race against the running IRQ here if
 	 *	this is called from non IRQ context. If we use
 	 *	disable_irq() we hang on the error path. Work
 	 *	is needed.
 	 */
-	 
+	disable_irq_nosync(hwif->irq);
+
 	udelay(1);
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 1);
@@ -812,8 +424,8 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
  *
  * See also ide_execute_command
  */
-static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
-		      unsigned int timeout, ide_expiry_t *expiry)
+void __ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
+		       unsigned int timeout, ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
@@ -835,9 +447,8 @@ void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 	__ide_set_handler(drive, handler, timeout, expiry);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
-
 EXPORT_SYMBOL(ide_set_handler);
- 
+
 /**
  *	ide_execute_command	-	execute an IDE command
  *	@drive: IDE drive to issue the command against
@@ -847,7 +458,7 @@ EXPORT_SYMBOL(ide_set_handler);
  *	@expiry:  handler to run on timeout
  *
  *	Helper function to issue an IDE command. This handles the
- *	atomicity requirements, command timing and ensures that the 
+ *	atomicity requirements, command timing and ensures that the
  *	handler and IRQ setup do not race. All IDE command kick off
  *	should go via this function or do equivalent locking.
  */
@@ -884,301 +495,6 @@ void ide_execute_pkt_cmd(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
-static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
-{
-	struct request *rq = drive->hwif->rq;
-
-	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
-		ide_end_request(drive, err ? err : 1, 0);
-}
-
-/* needed below */
-static ide_startstop_t do_reset1 (ide_drive_t *, int);
-
-/*
- * atapi_reset_pollfunc() gets invoked to poll the interface for completion every 50ms
- * during an atapi drive reset operation. If the drive has not yet responded,
- * and we have not yet hit our maximum waiting time, then the timer is restarted
- * for another 50ms.
- */
-static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	SELECT_DRIVE(drive);
-	udelay (10);
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (OK_STAT(stat, 0, ATA_BUSY))
-		printk("%s: ATAPI reset complete\n", drive->name);
-	else {
-		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-			/* continue polling */
-			return ide_started;
-		}
-		/* end of polling */
-		hwif->polling = 0;
-		printk("%s: ATAPI reset timed-out, status=0x%02x\n",
-				drive->name, stat);
-		/* do it the old fashioned way */
-		return do_reset1(drive, 1);
-	}
-	/* done polling */
-	hwif->polling = 0;
-	ide_complete_drive_reset(drive, 0);
-	return ide_stopped;
-}
-
-static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
-{
-	static const char *err_master_vals[] =
-		{ NULL, "passed", "formatter device error",
-		  "sector buffer error", "ECC circuitry error",
-		  "controlling MPU error" };
-
-	u8 err_master = err & 0x7f;
-
-	printk(KERN_ERR "%s: reset: master: ", hwif->name);
-	if (err_master && err_master < 6)
-		printk(KERN_CONT "%s", err_master_vals[err_master]);
-	else
-		printk(KERN_CONT "error (0x%02x?)", err);
-	if (err & 0x80)
-		printk(KERN_CONT "; slave: failed");
-	printk(KERN_CONT "\n");
-}
-
-/*
- * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
- * during an ide reset operation. If the drives have not yet responded,
- * and we have not yet hit our maximum waiting time, then the timer is restarted
- * for another 50ms.
- */
-static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-	u8 tmp;
-	int err = 0;
-
-	if (port_ops && port_ops->reset_poll) {
-		err = port_ops->reset_poll(drive);
-		if (err) {
-			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
-				hwif->name, drive->name);
-			goto out;
-		}
-	}
-
-	tmp = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
-		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
-			/* continue polling */
-			return ide_started;
-		}
-		printk("%s: reset timed-out, status=0x%02x\n", hwif->name, tmp);
-		drive->failures++;
-		err = -EIO;
-	} else  {
-		tmp = ide_read_error(drive);
-
-		if (tmp == 1) {
-			printk(KERN_INFO "%s: reset: success\n", hwif->name);
-			drive->failures = 0;
-		} else {
-			ide_reset_report_error(hwif, tmp);
-			drive->failures++;
-			err = -EIO;
-		}
-	}
-out:
-	hwif->polling = 0;	/* done polling */
-	ide_complete_drive_reset(drive, err);
-	return ide_stopped;
-}
-
-static void ide_disk_pre_reset(ide_drive_t *drive)
-{
-	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
-
-	drive->special.all = 0;
-	drive->special.b.set_geometry = legacy;
-	drive->special.b.recalibrate  = legacy;
-
-	drive->mult_count = 0;
-	drive->dev_flags &= ~IDE_DFLAG_PARKED;
-
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
-		drive->mult_req = 0;
-
-	if (drive->mult_req != drive->mult_count)
-		drive->special.b.set_multmode = 1;
-}
-
-static void pre_reset(ide_drive_t *drive)
-{
-	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
-
-	if (drive->media == ide_disk)
-		ide_disk_pre_reset(drive);
-	else
-		drive->dev_flags |= IDE_DFLAG_POST_RESET;
-
-	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
-		if (drive->crc_count)
-			ide_check_dma_crc(drive);
-		else
-			ide_dma_off(drive);
-	}
-
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
-			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-			drive->io_32bit = 0;
-		}
-		return;
-	}
-
-	if (port_ops && port_ops->pre_reset)
-		port_ops->pre_reset(drive);
-
-	if (drive->current_speed != 0xff)
-		drive->desired_speed = drive->current_speed;
-	drive->current_speed = 0xff;
-}
-
-/*
- * do_reset1() attempts to recover a confused drive by resetting it.
- * Unfortunately, resetting a disk drive actually resets all devices on
- * the same interface, so it can really be thought of as resetting the
- * interface rather than resetting the drive.
- *
- * ATAPI devices have their own reset mechanism which allows them to be
- * individually reset without clobbering other devices on the same interface.
- *
- * Unfortunately, the IDE interface does not generate an interrupt to let
- * us know when the reset operation has finished, so we must poll for this.
- * Equally poor, though, is the fact that this may a very long time to complete,
- * (up to 30 seconds worstcase).  So, instead of busy-waiting here for it,
- * we set a timer to poll at 50ms intervals.
- */
-static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	const struct ide_port_ops *port_ops;
-	ide_drive_t *tdrive;
-	unsigned long flags, timeout;
-	int i;
-	DEFINE_WAIT(wait);
-
-	spin_lock_irqsave(&hwif->lock, flags);
-
-	/* We must not reset with running handlers */
-	BUG_ON(hwif->handler != NULL);
-
-	/* For an ATAPI device, first try an ATAPI SRST. */
-	if (drive->media != ide_disk && !do_not_try_atapi) {
-		pre_reset(drive);
-		SELECT_DRIVE(drive);
-		udelay (20);
-		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
-		ndelay(400);
-		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
-		hwif->polling = 1;
-		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		return ide_started;
-	}
-
-	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
-	do {
-		unsigned long now;
-
-		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
-		timeout = jiffies;
-		ide_port_for_each_dev(i, tdrive, hwif) {
-			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
-			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
-			    time_after(tdrive->sleep, timeout))
-				timeout = tdrive->sleep;
-		}
-
-		now = jiffies;
-		if (time_before_eq(timeout, now))
-			break;
-
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		timeout = schedule_timeout_uninterruptible(timeout - now);
-		spin_lock_irqsave(&hwif->lock, flags);
-	} while (timeout);
-	finish_wait(&ide_park_wq, &wait);
-
-	/*
-	 * First, reset any device state data we were maintaining
-	 * for any of the drives on this interface.
-	 */
-	ide_port_for_each_dev(i, tdrive, hwif)
-		pre_reset(tdrive);
-
-	if (io_ports->ctl_addr == 0) {
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		ide_complete_drive_reset(drive, -ENXIO);
-		return ide_stopped;
-	}
-
-	/*
-	 * Note that we also set nIEN while resetting the device,
-	 * to mask unwanted interrupts from the interface during the reset.
-	 * However, due to the design of PC hardware, this will cause an
-	 * immediate interrupt due to the edge transition it produces.
-	 * This single interrupt gives us a "fast poll" for drives that
-	 * recover from reset very quickly, saving us the first 50ms wait time.
-	 *
-	 * TODO: add ->softreset method and stop abusing ->set_irq
-	 */
-	/* set SRST and nIEN */
-	tp_ops->set_irq(hwif, 4);
-	/* more than enough time */
-	udelay(10);
-	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	tp_ops->set_irq(hwif, drive->quirk_list == 2);
-	/* more than enough time */
-	udelay(10);
-	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
-	hwif->polling = 1;
-	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
-
-	/*
-	 * Some weird controller like resetting themselves to a strange
-	 * state when the disks are reset this way. At least, the Winbond
-	 * 553 documentation says that
-	 */
-	port_ops = hwif->port_ops;
-	if (port_ops && port_ops->resetproc)
-		port_ops->resetproc(drive);
-
-	spin_unlock_irqrestore(&hwif->lock, flags);
-	return ide_started;
-}
-
-/*
- * ide_do_reset() is the entry point to the drive/interface reset code.
- */
-
-ide_startstop_t ide_do_reset (ide_drive_t *drive)
-{
-	return do_reset1(drive, 0);
-}
-
-EXPORT_SYMBOL(ide_do_reset);
-
 /*
  * ide_wait_not_busy() waits for the currently selected device on the hwif
  * to report a non-busy status, see comments in ide_probe_port().
@@ -1187,7 +503,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 {
 	u8 stat = 0;
 
-	while(timeout--) {
+	while (timeout--) {
 		/*
 		 * Turn this into a schedule() sleep once I'm sure
 		 * about locking issues (2.5 work ?).
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 09526a0..f6c683d 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -5,163 +5,6 @@
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
-static const char *udma_str[] =
-	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
-	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
-static const char *mwdma_str[] =
-	{ "MWDMA0", "MWDMA1", "MWDMA2" };
-static const char *swdma_str[] =
-	{ "SWDMA0", "SWDMA1", "SWDMA2" };
-static const char *pio_str[] =
-	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
-
-/**
- *	ide_xfer_verbose	-	return IDE mode names
- *	@mode: transfer mode
- *
- *	Returns a constant string giving the name of the mode
- *	requested.
- */
-
-const char *ide_xfer_verbose(u8 mode)
-{
-	const char *s;
-	u8 i = mode & 0xf;
-
-	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
-		s = udma_str[i];
-	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
-		s = mwdma_str[i];
-	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
-		s = swdma_str[i];
-	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
-		s = pio_str[i & 0x7];
-	else if (mode == XFER_PIO_SLOW)
-		s = "PIO SLOW";
-	else
-		s = "XFER ERROR";
-
-	return s;
-}
-EXPORT_SYMBOL(ide_xfer_verbose);
-
-/**
- *	ide_rate_filter		-	filter transfer mode
- *	@drive: IDE device
- *	@speed: desired speed
- *
- *	Given the available transfer modes this function returns
- *	the best available speed at or below the speed requested.
- *
- *	TODO: check device PIO capabilities
- */
-
-static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 mode = ide_find_dma_mode(drive, speed);
-
-	if (mode == 0) {
-		if (hwif->pio_mask)
-			mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
-		else
-			mode = XFER_PIO_4;
-	}
-
-/*	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed); */
-
-	return min(speed, mode);
-}
-
-/**
- *	ide_get_best_pio_mode	-	get PIO mode from drive
- *	@drive: drive to consider
- *	@mode_wanted: preferred mode
- *	@max_mode: highest allowed mode
- *
- *	This routine returns the recommended PIO settings for a given drive,
- *	based on the drive->id information and the ide_pio_blacklist[].
- *
- *	Drive PIO mode is auto-selected if 255 is passed as mode_wanted.
- *	This is used by most chipset support modules when "auto-tuning".
- */
-
-u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
-{
-	u16 *id = drive->id;
-	int pio_mode = -1, overridden = 0;
-
-	if (mode_wanted != 255)
-		return min_t(u8, mode_wanted, max_mode);
-
-	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
-		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
-
-	if (pio_mode != -1) {
-		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
-	} else {
-		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
-		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
-			pio_mode = 2;
-			overridden = 1;
-		}
-
-		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
-			if (ata_id_has_iordy(id)) {
-				if (id[ATA_ID_PIO_MODES] & 7) {
-					overridden = 0;
-					if (id[ATA_ID_PIO_MODES] & 4)
-						pio_mode = 5;
-					else if (id[ATA_ID_PIO_MODES] & 2)
-						pio_mode = 4;
-					else
-						pio_mode = 3;
-				}
-			}
-		}
-
-		if (overridden)
-			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
-					 drive->name);
-	}
-
-	if (pio_mode > max_mode)
-		pio_mode = max_mode;
-
-	return pio_mode;
-}
-EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
-
-/* req_pio == "255" for auto-tune */
-void ide_set_pio(ide_drive_t *drive, u8 req_pio)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-	u8 host_pio, pio;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return;
-
-	BUG_ON(hwif->pio_mask == 0x00);
-
-	host_pio = fls(hwif->pio_mask) - 1;
-
-	pio = ide_get_best_pio_mode(drive, req_pio, host_pio);
-
-	/*
-	 * TODO:
-	 * - report device max PIO mode
-	 * - check req_pio != 255 against device max PIO mode
-	 */
-	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
-			  drive->name, host_pio, req_pio,
-			  req_pio == 255 ? "(auto-tune)" : "", pio);
-
-	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
-}
-EXPORT_SYMBOL_GPL(ide_set_pio);
-
 /**
  *	ide_toggle_bounce	-	handle bounce buffering
  *	@drive: drive to update
@@ -188,89 +31,6 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
 		blk_queue_bounce_limit(drive->queue, addr);
 }
 
-int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL)
-		return -1;
-
-	/*
-	 * TODO: temporary hack for some legacy host drivers that didn't
-	 * set transfer mode on the device in ->set_pio_mode method...
-	 */
-	if (port_ops->set_dma_mode == NULL) {
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return 0;
-	}
-
-	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
-		if (ide_config_drive_speed(drive, mode))
-			return -1;
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return 0;
-	} else {
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return ide_config_drive_speed(drive, mode);
-	}
-}
-
-int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
-
-	if (port_ops == NULL || port_ops->set_dma_mode == NULL)
-		return -1;
-
-	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
-		if (ide_config_drive_speed(drive, mode))
-			return -1;
-		port_ops->set_dma_mode(drive, mode);
-		return 0;
-	} else {
-		port_ops->set_dma_mode(drive, mode);
-		return ide_config_drive_speed(drive, mode);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_set_dma_mode);
-
-/**
- *	ide_set_xfer_rate	-	set transfer rate
- *	@drive: drive to set
- *	@rate: speed to attempt to set
- *
- *	General helper for setting the speed of an IDE device. This
- *	function knows about user enforced limits from the configuration
- *	which ->set_pio_mode/->set_dma_mode does not.
- */
-
-int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return -1;
-
-	rate = ide_rate_filter(drive, rate);
-
-	BUG_ON(rate < XFER_PIO_0);
-
-	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
-		return ide_set_pio_mode(drive, rate);
-
-	return ide_set_dma_mode(drive, rate);
-}
-
 static void ide_dump_opcode(ide_drive_t *drive)
 {
 	struct request *rq = drive->hwif->rq;
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index c875a95..f30e521 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 #include <linux/jiffies.h>
 #include <linux/blkdev.h>
 
@@ -60,6 +61,30 @@ out:
 	return;
 }
 
+ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
+{
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+
+	memset(&task, 0, sizeof(task));
+	if (rq->cmd[0] == REQ_PARK_HEADS) {
+		drive->sleep = *(unsigned long *)rq->special;
+		drive->dev_flags |= IDE_DFLAG_SLEEPING;
+		tf->command = ATA_CMD_IDLEIMMEDIATE;
+		tf->feature = 0x44;
+		tf->lbal = 0x4c;
+		tf->lbam = 0x4e;
+		tf->lbah = 0x55;
+		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+	} else		/* cmd == REQ_UNPARK_HEADS */
+		tf->command = ATA_CMD_CHK_POWER;
+
+	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	task.rq = rq;
+	drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, &task);
+}
+
 ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index bddae2b..61111fd 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -33,8 +33,6 @@ static int ide_generic_all;		/* Set to claim all devices */
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
 
-#define IDE_HFLAGS_UMC (IDE_HFLAG_NO_DMA | IDE_HFLAG_FORCE_LEGACY_IRQS)
-
 #define DECLARE_GENERIC_PCI_DEV(extra_flags) \
 	{ \
 		.name		= DRV_NAME, \
@@ -61,7 +59,7 @@ static const struct ide_port_info generic_chipsets[] __devinitdata = {
 	/*  2: SAMURAI / HT6565 / HINT_IDE */
 	DECLARE_GENERIC_PCI_DEV(0),
 	/*  3: UM8673F / UM8886A / UM8886BF */
-	DECLARE_GENERIC_PCI_DEV(IDE_HFLAGS_UMC),
+	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_DMA),
 	/*  4: VIA_IDE / OPTI621V / Piccolo010{2,3,5} */
 	DECLARE_GENERIC_PCI_DEV(IDE_HFLAG_NO_AUTODMA),
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 97ea532..9740670 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -181,16 +181,16 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
  *	do_identify	-	identify a drive
  *	@drive: drive to identify 
  *	@cmd: command used
+ *	@id: buffer for IDENTIFY data
  *
  *	Called when we have issued a drive identify command to
  *	read and parse the results. This function is run with
  *	interrupts disabled. 
  */
 
-static void do_identify(ide_drive_t *drive, u8 cmd)
+static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long flags;
 	int bswap = 1;
@@ -233,16 +233,6 @@ static void do_identify(ide_drive_t *drive, u8 cmd)
 	drive->dev_flags |= IDE_DFLAG_PRESENT;
 	drive->dev_flags &= ~IDE_DFLAG_DEAD;
 
-	/*
-	 * Check for an ATAPI device
-	 */
-	if (cmd == ATA_CMD_ID_ATAPI)
-		ide_classify_atapi_dev(drive);
-	else
-	/*
-	 * Not an ATAPI device: looks like a "regular" hard disk
-	 */
-		ide_classify_ata_dev(drive);
 	return;
 err_misc:
 	kfree(id);
@@ -250,21 +240,19 @@ err_misc:
 }
 
 /**
- *	actual_try_to_identify	-	send ata/atapi identify
+ *	ide_dev_read_id	-	send ATA/ATAPI IDENTIFY command
  *	@drive: drive to identify
  *	@cmd: command to use
+ *	@id: buffer for IDENTIFY data
  *
- *	try_to_identify() sends an ATA(PI) IDENTIFY request to a drive
- *	and waits for a response.  It also monitors irqs while this is
- *	happening, in hope of automatically determining which one is
- *	being used by the interface.
+ *	Sends an ATA(PI) IDENTIFY request to a drive and waits for a response.
  *
  *	Returns:	0  device was identified
  *			1  device timed-out (no response to identify request)
  *			2  device aborted the command (refused to identify itself)
  */
 
-static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
+int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -273,6 +261,13 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	unsigned long timeout;
 	u8 s = 0, a = 0;
 
+	/*
+	 * Disable device IRQ.  Otherwise we'll get spurious interrupts
+	 * during the identify phase that the IRQ handler isn't expecting.
+	 */
+	if (io_ports->ctl_addr)
+		tp_ops->set_irq(hwif, 0);
+
 	/* take a deep breath */
 	msleep(50);
 
@@ -317,7 +312,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 
 	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
 		/* drive returned ID */
-		do_identify(drive, cmd);
+		do_identify(drive, cmd, id);
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
@@ -329,63 +324,6 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	return rc;
 }
 
-/**
- *	try_to_identify	-	try to identify a drive
- *	@drive: drive to probe
- *	@cmd: command to use
- *
- *	Issue the identify command and then do IRQ probing to
- *	complete the identification when needed by finding the
- *	IRQ the drive is attached to
- */
- 
-static int try_to_identify (ide_drive_t *drive, u8 cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	int retval;
-	int autoprobe = 0;
-	unsigned long cookie = 0;
-
-	/*
-	 * Disable device irq unless we need to
-	 * probe for it. Otherwise we'll get spurious
-	 * interrupts during the identify-phase that
-	 * the irq handler isn't expecting.
-	 */
-	if (hwif->io_ports.ctl_addr) {
-		if (!hwif->irq) {
-			autoprobe = 1;
-			cookie = probe_irq_on();
-		}
-		tp_ops->set_irq(hwif, autoprobe);
-	}
-
-	retval = actual_try_to_identify(drive, cmd);
-
-	if (autoprobe) {
-		int irq;
-
-		tp_ops->set_irq(hwif, 0);
-		/* clear drive IRQ */
-		(void)tp_ops->read_status(hwif);
-		udelay(5);
-		irq = probe_irq_off(cookie);
-		if (!hwif->irq) {
-			if (irq > 0) {
-				hwif->irq = irq;
-			} else {
-				/* Mmmm.. multiple IRQs..
-				 * don't know which was ours
-				 */
-				printk(KERN_ERR "%s: IRQ probe failed (0x%lx)\n",
-					drive->name, cookie);
-			}
-		}
-	}
-	return retval;
-}
-
 int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 {
 	u8 stat;
@@ -440,6 +378,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	u16 *id = drive->id;
 	int rc;
 	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
 
@@ -475,11 +414,10 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
 	    present || cmd == ATA_CMD_ID_ATAPI) {
-		/* send cmd and wait */
-		if ((rc = try_to_identify(drive, cmd))) {
+		rc = ide_dev_read_id(drive, cmd, id);
+		if (rc)
 			/* failed: try again */
-			rc = try_to_identify(drive,cmd);
-		}
+			rc = ide_dev_read_id(drive, cmd, id);
 
 		stat = tp_ops->read_status(hwif);
 
@@ -494,7 +432,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
-			rc = try_to_identify(drive, cmd);
+			rc = ide_dev_read_id(drive, cmd, id);
 		}
 
 		/* ensure drive IRQ is clear */
@@ -517,37 +455,6 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	return rc;
 }
 
-/*
- *
- */
-static void enable_nest (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	u8 stat;
-
-	printk(KERN_INFO "%s: enabling %s -- ",
-		hwif->name, (char *)&drive->id[ATA_ID_PROD]);
-
-	SELECT_DRIVE(drive);
-	msleep(50);
-	tp_ops->exec_command(hwif, ATA_EXABYTE_ENABLE_NEST);
-
-	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 0)) {
-		printk(KERN_CONT "failed (timeout)\n");
-		return;
-	}
-
-	msleep(50);
-
-	stat = tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, 0, BAD_STAT))
-		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
-	else
-		printk(KERN_CONT "success\n");
-}
-
 /**
  *	probe_for_drives	-	upper level drive probe
  *	@drive: drive to probe for
@@ -563,6 +470,8 @@ static void enable_nest (ide_drive_t *drive)
 static u8 probe_for_drive(ide_drive_t *drive)
 {
 	char *m;
+	int rc;
+	u8 cmd;
 
 	/*
 	 *	In order to keep things simple we have an id
@@ -586,21 +495,19 @@ static u8 probe_for_drive(ide_drive_t *drive)
 
 	/* skip probing? */
 	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
-retry:
 		/* if !(success||timed-out) */
-		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
+		cmd = ATA_CMD_ID_ATA;
+		rc = do_probe(drive, cmd);
+		if (rc >= 2) {
 			/* look for ATAPI device */
-			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
+			cmd = ATA_CMD_ID_ATAPI;
+			rc = do_probe(drive, cmd);
+		}
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			/* drive not found */
 			return 0;
 
-		if (strstr(m, "E X A B Y T E N E S T")) {
-			enable_nest(drive);
-			goto retry;
-		}
-
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
@@ -614,8 +521,12 @@ retry:
 				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
+		} else {
+			if (cmd == ATA_CMD_ID_ATAPI)
+				ide_classify_atapi_dev(drive);
+			else
+				ide_classify_ata_dev(drive);
 		}
-		/* drive was found */
 	}
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
@@ -779,7 +690,6 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 static int ide_probe_port(ide_hwif_t *hwif)
 {
 	ide_drive_t *drive;
-	unsigned long flags;
 	unsigned int irqd;
 	int i, rc = -ENODEV;
 
@@ -797,9 +707,6 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	local_save_flags(flags);
-	local_irq_enable_in_hardirq();
-
 	if (ide_port_wait_ready(hwif) == -EBUSY)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
@@ -813,8 +720,6 @@ static int ide_probe_port(ide_hwif_t *hwif)
 			rc = 0;
 	}
 
-	local_irq_restore(flags);
-
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
@@ -831,22 +736,18 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	ide_drive_t *drive;
 	int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			if (port_ops && port_ops->quirkproc)
-				port_ops->quirkproc(drive);
-		}
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		if (port_ops && port_ops->quirkproc)
+			port_ops->quirkproc(drive);
 	}
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			ide_set_max_pio(drive);
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_set_max_pio(drive);
 
-			drive->dev_flags |= IDE_DFLAG_NICE1;
+		drive->dev_flags |= IDE_DFLAG_NICE1;
 
-			if (hwif->dma_ops)
-				ide_set_dma(drive);
-		}
+		if (hwif->dma_ops)
+			ide_set_dma(drive);
 	}
 }
 
@@ -917,10 +818,7 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (ide_init_queue(drive)) {
 			printk(KERN_ERR "ide: failed to init %s\n",
 					drive->name);
@@ -946,13 +844,6 @@ static int init_irq (ide_hwif_t *hwif)
 	irq_handler_t irq_handler;
 	int sa = 0;
 
-	mutex_lock(&ide_cfg_mtx);
-	spin_lock_init(&hwif->lock);
-
-	init_timer(&hwif->timer);
-	hwif->timer.function = &ide_timer_expiry;
-	hwif->timer.data = (unsigned long)hwif;
-
 	irq_handler = hwif->host->irq_handler;
 	if (irq_handler == NULL)
 		irq_handler = ide_intr;
@@ -990,10 +881,8 @@ static int init_irq (ide_hwif_t *hwif)
 		printk(KERN_CONT " (serialized)");
 	printk(KERN_CONT "\n");
 
-	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_up:
-	mutex_unlock(&ide_cfg_mtx);
 	return 1;
 }
 
@@ -1092,14 +981,9 @@ static void drive_release_dev (struct device *dev)
 
 static int hwif_init(ide_hwif_t *hwif)
 {
-	int old_irq;
-
 	if (!hwif->irq) {
-		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
-		if (!hwif->irq) {
-			printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
-			return 0;
-		}
+		printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
+		return 0;
 	}
 
 	if (register_blkdev(hwif->major, hwif->name))
@@ -1117,29 +1001,12 @@ static int hwif_init(ide_hwif_t *hwif)
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
-	if (init_irq(hwif) == 0)
-		goto done;
-
-	old_irq = hwif->irq;
-	/*
-	 *	It failed to initialise. Find the default IRQ for 
-	 *	this port and try that.
-	 */
-	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
-	if (!hwif->irq) {
-		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
-			hwif->name, old_irq);
-		goto out;
-	}
 	if (init_irq(hwif)) {
-		printk(KERN_ERR "%s: probed IRQ %d and default IRQ %d failed\n",
-			hwif->name, old_irq, hwif->irq);
+		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
+			hwif->name, hwif->irq);
 		goto out;
 	}
-	printk(KERN_WARNING "%s: probed IRQ %d failed, using default\n",
-		hwif->name, hwif->irq);
 
-done:
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	return 1;
@@ -1154,13 +1021,10 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 	ide_drive_t *drive;
 	unsigned int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		struct device *dev = &drive->gendev;
 		int ret;
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
 		dev_set_name(dev, "%u.%u", hwif->index, i);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
@@ -1208,10 +1072,6 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	if (d->init_iops)
 		d->init_iops(hwif);
 
-	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
-	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
-		hwif->irq = port ? 15 : 14;
-
 	/* ->host_flags may be set by ->init_iops (or even earlier...) */
 	hwif->host_flags |= d->host_flags;
 	hwif->pio_mask = d->pio_mask;
@@ -1312,6 +1172,12 @@ static void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 	hwif->name[2]	= 'e';
 	hwif->name[3]	= '0' + index;
 
+	spin_lock_init(&hwif->lock);
+
+	init_timer(&hwif->timer);
+	hwif->timer.function = &ide_timer_expiry;
+	hwif->timer.data = (unsigned long)hwif;
+
 	init_completion(&hwif->gendev_rel_comp);
 
 	hwif->tp_ops = &default_tp_ops;
@@ -1562,7 +1428,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 
 		j++;
 
-		ide_acpi_init(hwif);
+		ide_acpi_init_port(hwif);
 
 		if (hwif->present)
 			ide_acpi_port_init_devices(hwif);
@@ -1619,11 +1485,9 @@ static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 	ide_drive_t *drive;
 	int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			device_unregister(&drive->gendev);
-			wait_for_completion(&drive->gendev_rel_comp);
-		}
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		device_unregister(&drive->gendev);
+		wait_for_completion(&drive->gendev_rel_comp);
 	}
 }
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index a7b9287..417cde5 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -600,7 +600,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 	int i;
 
 	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
diff --git a/drivers/ide/ide-xfer-mode.c b/drivers/ide/ide-xfer-mode.c
new file mode 100644
index 0000000..6910f6a
--- /dev/null
+++ b/drivers/ide/ide-xfer-mode.c
@@ -0,0 +1,246 @@
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/ide.h>
+#include <linux/bitops.h>
+
+static const char *udma_str[] =
+	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
+	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
+static const char *mwdma_str[] =
+	{ "MWDMA0", "MWDMA1", "MWDMA2" };
+static const char *swdma_str[] =
+	{ "SWDMA0", "SWDMA1", "SWDMA2" };
+static const char *pio_str[] =
+	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
+
+/**
+ *	ide_xfer_verbose	-	return IDE mode names
+ *	@mode: transfer mode
+ *
+ *	Returns a constant string giving the name of the mode
+ *	requested.
+ */
+
+const char *ide_xfer_verbose(u8 mode)
+{
+	const char *s;
+	u8 i = mode & 0xf;
+
+	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		s = udma_str[i];
+	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
+		s = mwdma_str[i];
+	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
+		s = swdma_str[i];
+	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
+		s = pio_str[i & 0x7];
+	else if (mode == XFER_PIO_SLOW)
+		s = "PIO SLOW";
+	else
+		s = "XFER ERROR";
+
+	return s;
+}
+EXPORT_SYMBOL(ide_xfer_verbose);
+
+/**
+ *	ide_get_best_pio_mode	-	get PIO mode from drive
+ *	@drive: drive to consider
+ *	@mode_wanted: preferred mode
+ *	@max_mode: highest allowed mode
+ *
+ *	This routine returns the recommended PIO settings for a given drive,
+ *	based on the drive->id information and the ide_pio_blacklist[].
+ *
+ *	Drive PIO mode is auto-selected if 255 is passed as mode_wanted.
+ *	This is used by most chipset support modules when "auto-tuning".
+ */
+
+u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
+{
+	u16 *id = drive->id;
+	int pio_mode = -1, overridden = 0;
+
+	if (mode_wanted != 255)
+		return min_t(u8, mode_wanted, max_mode);
+
+	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
+		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
+
+	if (pio_mode != -1) {
+		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
+	} else {
+		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
+		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
+			pio_mode = 2;
+			overridden = 1;
+		}
+
+		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
+			if (ata_id_has_iordy(id)) {
+				if (id[ATA_ID_PIO_MODES] & 7) {
+					overridden = 0;
+					if (id[ATA_ID_PIO_MODES] & 4)
+						pio_mode = 5;
+					else if (id[ATA_ID_PIO_MODES] & 2)
+						pio_mode = 4;
+					else
+						pio_mode = 3;
+				}
+			}
+		}
+
+		if (overridden)
+			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
+					 drive->name);
+	}
+
+	if (pio_mode > max_mode)
+		pio_mode = max_mode;
+
+	return pio_mode;
+}
+EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
+
+int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL)
+		return -1;
+
+	/*
+	 * TODO: temporary hack for some legacy host drivers that didn't
+	 * set transfer mode on the device in ->set_pio_mode method...
+	 */
+	if (port_ops->set_dma_mode == NULL) {
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	}
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	} else {
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+
+int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL)
+		return -1;
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		port_ops->set_dma_mode(drive, mode);
+		return 0;
+	} else {
+		port_ops->set_dma_mode(drive, mode);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_set_dma_mode);
+
+/* req_pio == "255" for auto-tune */
+void ide_set_pio(ide_drive_t *drive, u8 req_pio)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+	u8 host_pio, pio;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return;
+
+	BUG_ON(hwif->pio_mask == 0x00);
+
+	host_pio = fls(hwif->pio_mask) - 1;
+
+	pio = ide_get_best_pio_mode(drive, req_pio, host_pio);
+
+	/*
+	 * TODO:
+	 * - report device max PIO mode
+	 * - check req_pio != 255 against device max PIO mode
+	 */
+	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
+			  drive->name, host_pio, req_pio,
+			  req_pio == 255 ? "(auto-tune)" : "", pio);
+
+	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
+}
+EXPORT_SYMBOL_GPL(ide_set_pio);
+
+/**
+ *	ide_rate_filter		-	filter transfer mode
+ *	@drive: IDE device
+ *	@speed: desired speed
+ *
+ *	Given the available transfer modes this function returns
+ *	the best available speed at or below the speed requested.
+ *
+ *	TODO: check device PIO capabilities
+ */
+
+static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mode = ide_find_dma_mode(drive, speed);
+
+	if (mode == 0) {
+		if (hwif->pio_mask)
+			mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
+		else
+			mode = XFER_PIO_4;
+	}
+
+/*	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed); */
+
+	return min(speed, mode);
+}
+
+/**
+ *	ide_set_xfer_rate	-	set transfer rate
+ *	@drive: drive to set
+ *	@rate: speed to attempt to set
+ *
+ *	General helper for setting the speed of an IDE device. This
+ *	function knows about user enforced limits from the configuration
+ *	which ->set_pio_mode/->set_dma_mode does not.
+ */
+
+int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return -1;
+
+	rate = ide_rate_filter(drive, rate);
+
+	BUG_ON(rate < XFER_PIO_0);
+
+	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
+		return ide_set_pio_mode(drive, rate);
+
+	return ide_set_dma_mode(drive, rate);
+}
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 0920e3b..92c9b90 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -62,160 +62,6 @@
 
 struct class *ide_port_class;
 
-/*
- *	Locks for IDE setting functionality
- */
-
-DEFINE_MUTEX(ide_setting_mtx);
-
-ide_devset_get(io_32bit, io_32bit);
-
-static int set_io_32bit(ide_drive_t *drive, int arg)
-{
-	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
-		return -EPERM;
-
-	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
-		return -EINVAL;
-
-	drive->io_32bit = arg;
-
-	return 0;
-}
-
-ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
-
-static int set_ksettings(ide_drive_t *drive, int arg)
-{
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (arg)
-		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
-	else
-		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
-
-	return 0;
-}
-
-ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
-
-static int set_using_dma(ide_drive_t *drive, int arg)
-{
-#ifdef CONFIG_BLK_DEV_IDEDMA
-	int err = -EPERM;
-
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (ata_id_has_dma(drive->id) == 0)
-		goto out;
-
-	if (drive->hwif->dma_ops == NULL)
-		goto out;
-
-	err = 0;
-
-	if (arg) {
-		if (ide_set_dma(drive))
-			err = -EIO;
-	} else
-		ide_dma_off(drive);
-
-out:
-	return err;
-#else
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	return -EPERM;
-#endif
-}
-
-/*
- * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
- */
-static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
-{
-	switch (req_pio) {
-	case 202:
-	case 201:
-	case 200:
-	case 102:
-	case 101:
-	case 100:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
-	case 9:
-	case 8:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
-	case 7:
-	case 6:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
-	default:
-		return 0;
-	}
-}
-
-static int set_pio_mode(ide_drive_t *drive, int arg)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (arg < 0 || arg > 255)
-		return -EINVAL;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return -ENOSYS;
-
-	if (set_pio_mode_abuse(drive->hwif, arg)) {
-		if (arg == 8 || arg == 9) {
-			unsigned long flags;
-
-			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
-			spin_lock_irqsave(&hwif->lock, flags);
-			port_ops->set_pio_mode(drive, arg);
-			spin_unlock_irqrestore(&hwif->lock, flags);
-		} else
-			port_ops->set_pio_mode(drive, arg);
-	} else {
-		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-
-		ide_set_pio(drive, arg);
-
-		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-			if (keep_dma)
-				ide_dma_on(drive);
-		}
-	}
-
-	return 0;
-}
-
-ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
-
-static int set_unmaskirq(ide_drive_t *drive, int arg)
-{
-	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
-		return -EPERM;
-
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (arg)
-		drive->dev_flags |= IDE_DFLAG_UNMASK;
-	else
-		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-
-	return 0;
-}
-
-ide_ext_devset_rw_sync(io_32bit, io_32bit);
-ide_ext_devset_rw_sync(keepsettings, ksettings);
-ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
-ide_ext_devset_rw_sync(using_dma, using_dma);
-__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
-
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
  * @drive:	device to get a reference to
@@ -527,6 +373,8 @@ static int __init ide_init(void)
 		goto out_port_class;
 	}
 
+	ide_acpi_init();
+
 	proc_ide_create();
 
 	return 0;
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 13b8153..6b9fc95 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -603,7 +603,7 @@ static void it8212_disable_raid(struct pci_dev *dev)
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int init_chipset_it821x(struct pci_dev *dev)
+static int init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 83643ed..ea48a3e 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -286,9 +286,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	}
 
 	if (!using_inta)
-		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
-	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
-		hwif->irq = hwif->mate->irq;	/* share IRQ with mate */
+		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
 
 	if (!hwif->dma_base)
 		return;
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index f21290c..b68906c 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -325,7 +325,7 @@ static void apple_kiwi_init(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int init_chipset_pdcnew(struct pci_dev *dev)
+static int init_chipset_pdcnew(struct pci_dev *dev)
 {
 	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
@@ -444,7 +444,7 @@ static unsigned int init_chipset_pdcnew(struct pci_dev *dev)
 #endif
 
  out:
-	return dev->irq;
+	return 0;
 }
 
 static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 9719332..cba66eb 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -264,7 +264,7 @@ static void pdc202xx_dma_timeout(ide_drive_t *drive)
 	ide_dma_timeout(drive);
 }
 
-static unsigned int init_chipset_pdc202xx(struct pci_dev *dev)
+static int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
@@ -290,7 +290,7 @@ static unsigned int init_chipset_pdc202xx(struct pci_dev *dev)
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
 out:
-	return dev->irq;
+	return 0;
 }
 
 static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index f1e2e4e..2aa6999 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -204,7 +204,7 @@ static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
  *	out to be nice and simple.
  */
 
-static unsigned int init_chipset_ich(struct pci_dev *dev)
+static int init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
@@ -318,19 +318,12 @@ static const struct ide_port_ops ich_port_ops = {
 	.cable_detect		= piix_cable_detect,
 };
 
-#ifndef CONFIG_IA64
- #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
-#else
- #define IDE_HFLAGS_PIIX 0
-#endif
-
 #define DECLARE_PIIX_DEV(udma) \
 	{						\
 		.name		= DRV_NAME,		\
 		.init_hwif	= init_hwif_piix,	\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &piix_port_ops,	\
-		.host_flags	= IDE_HFLAGS_PIIX,	\
 		.pio_mask	= ATA_PIO4,		\
 		.swdma_mask	= ATA_SWDMA2_ONLY,	\
 		.mwdma_mask	= ATA_MWDMA12_ONLY,	\
@@ -344,7 +337,6 @@ static const struct ide_port_ops ich_port_ops = {
 		.init_hwif	= init_hwif_piix, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.port_ops	= &ich_port_ops, \
-		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
 		.mwdma_mask	= ATA_MWDMA12_ONLY, \
@@ -360,8 +352,7 @@ static const struct ide_port_info piix_pci_info[] __devinitdata = {
 		 */
 		.name		= DRV_NAME,
 		.enablebits	= {{0x6d,0xc0,0x80}, {0x6d,0xc0,0xc0}},
-		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA |
-				  IDE_HFLAGS_PIIX,
+		.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_NO_DMA,
 		.pio_mask	= ATA_PIO4,
 		/* This is a painful system best to let it self tune for now */
 	},
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index 382102b..b6554ef 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -175,7 +175,7 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int init_chipset_svwks(struct pci_dev *dev)
+static int init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -270,7 +270,7 @@ static unsigned int init_chipset_svwks(struct pci_dev *dev)
 		pci_write_config_byte(dev, 0x5A, btr);
 	}
 
-	return dev->irq;
+	return 0;
 }
 
 static u8 ata66_svwks_svwks(ide_hwif_t *hwif)
@@ -353,14 +353,11 @@ static const struct ide_port_ops svwks_port_ops = {
 	.cable_detect		= svwks_cable_detect,
 };
 
-#define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
-
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0: OSB4 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &osb4_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* UDMA is problematic on OSB4 */
@@ -369,7 +366,6 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -378,7 +374,6 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -387,7 +382,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -396,7 +391,7 @@ static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
 		.port_ops	= &svwks_port_ops,
-		.host_flags	= IDE_HFLAGS_SVWKS | IDE_HFLAG_SINGLE,
+		.host_flags	= IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index e85d1ed..24bc884 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -305,7 +305,6 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
- *	@irq: PCI IRQ
  *	@hw: hw_regs_t instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
@@ -316,7 +315,7 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
  */
 
 static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
-			    unsigned int port, int irq, hw_regs_t *hw)
+			    unsigned int port, hw_regs_t *hw)
 {
 	unsigned long ctl = 0, base = 0;
 
@@ -344,7 +343,6 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	}
 
 	memset(hw, 0, sizeof(*hw));
-	hw->irq = irq;
 	hw->dev = &dev->dev;
 	hw->chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(hw, base, ctl | 2);
@@ -448,7 +446,6 @@ out:
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
  *	@d: IDE port info
- *	@pciirq: IRQ line
  *	@hw: hw_regs_t instances corresponding to this PCI IDE device
  *	@hws: hw_regs_t pointers table to update
  *
@@ -462,7 +459,7 @@ out:
  */
 
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
-			 int pciirq, hw_regs_t *hw, hw_regs_t **hws)
+			 hw_regs_t *hw, hw_regs_t **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	u8 tmp;
@@ -481,7 +478,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 			continue;	/* port not enabled */
 		}
 
-		if (ide_hw_configure(dev, d, port, pciirq, hw + port))
+		if (ide_hw_configure(dev, d, port, hw + port))
 			continue;
 
 		*(hws + port) = hw + port;
@@ -524,7 +521,7 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 		if (noisy)
 			printk(KERN_INFO "%s %s: not 100%% native mode: will "
 				"probe irqs later\n", d->name, pci_name(dev));
-		pciirq = ret;
+		pciirq = 0;
 	} else if (!pciirq && noisy) {
 		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
 			d->name, pci_name(dev), pciirq);
@@ -549,7 +546,7 @@ int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
 	if (ret < 0)
 		goto out;
 
-	ide_pci_setup_ports(dev, d, 0, &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 
 	host = ide_host_alloc(d, hws);
 	if (host == NULL) {
@@ -568,7 +565,11 @@ int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
 		goto out;
 
 	/* fixup IRQ */
-	hw[1].irq = hw[0].irq = ret;
+	if (ide_pci_is_in_compatibility_mode(dev)) {
+		hw[0].irq = pci_get_legacy_ide_irq(dev, 0);
+		hw[1].irq = pci_get_legacy_ide_irq(dev, 1);
+	} else
+		hw[1].irq = hw[0].irq = ret;
 
 	ret = ide_host_register(host, d, hws);
 	if (ret)
@@ -591,7 +592,7 @@ int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
 		if (ret < 0)
 			goto out;
 
-		ide_pci_setup_ports(pdev[i], d, 0, &hw[i*2], &hws[i*2]);
+		ide_pci_setup_ports(pdev[i], d, &hw[i*2], &hws[i*2]);
 	}
 
 	host = ide_host_alloc(d, hws);
@@ -619,7 +620,11 @@ int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
 			goto out;
 
 		/* fixup IRQ */
-		hw[i*2 + 1].irq = hw[i*2].irq = ret;
+		if (ide_pci_is_in_compatibility_mode(pdev[i])) {
+			hw[i*2].irq = pci_get_legacy_ide_irq(pdev[i], 0);
+			hw[i*2 + 1].irq = pci_get_legacy_ide_irq(pdev[i], 1);
+		} else
+			hw[i*2 + 1].irq = hw[i*2].irq = ret;
 	}
 
 	ret = ide_host_register(host, d, hws);
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index cb2b352..1811ae9 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -464,7 +464,7 @@ static void sil_sata_pre_reset(ide_drive_t *drive)
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int init_chipset_siimage(struct pci_dev *dev)
+static int init_chipset_siimage(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
diff --git a/drivers/ide/sis5513.c b/drivers/ide/sis5513.c
index 9ec1a4a..afca22b 100644
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -447,7 +447,7 @@ static int __devinit sis_find_family(struct pci_dev *dev)
 	return chipset_family;
 }
 
-static unsigned int init_chipset_sis5513(struct pci_dev *dev)
+static int init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
@@ -563,7 +563,7 @@ static const struct ide_port_info sis5513_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
+	.host_flags	= IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 };
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index 6297956..dba213c 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -271,7 +271,7 @@ static u8 sl82c105_bridge_revision(struct pci_dev *dev)
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int init_chipset_sl82c105(struct pci_dev *dev)
+static int init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
@@ -281,7 +281,7 @@ static unsigned int init_chipset_sl82c105(struct pci_dev *dev)
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return dev->irq;
+	return 0;
 }
 
 static const struct ide_port_ops sl82c105_port_ops = {
diff --git a/drivers/ide/slc90e66.c b/drivers/ide/slc90e66.c
index 40b4b94..f55d7d6 100644
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -136,7 +136,6 @@ static const struct ide_port_info slc90e66_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
-	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
 	.mwdma_mask	= ATA_MWDMA12_ONLY,
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index b6a1285..1c09e54 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -277,9 +277,6 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 	if (reg & 0x10)
 		/* legacy mode */
 		hwif->irq = hwif->channel ? 15 : 14;
-	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
-		/* sharing IRQ with mate */
-		hwif->irq = hwif->mate->irq;
 
 #if 1
 	{
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 6092fe3..3ff7231 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -267,7 +267,7 @@ static void via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
  *	and initialize its drive independent registers.
  */
 
-static unsigned int init_chipset_via82cxxx(struct pci_dev *dev)
+static int init_chipset_via82cxxx(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
@@ -443,16 +443,6 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 	if ((via_config->flags & VIA_NO_UNMASK) == 0)
 		d.host_flags |= IDE_HFLAG_UNMASK_IRQS;
 
-#ifdef CONFIG_PPC_CHRP
-	if (machine_is(chrp) && _chrp_type == _CHRP_Pegasos)
-		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
-#endif
-
-#ifdef CONFIG_AMIGAONE
-	if (machine_is(amigaone))
-		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
-#endif
-
 	d.udma_mask = via_config->udma_mask;
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
diff --git a/include/asm-frv/ide.h b/include/asm-frv/ide.h
deleted file mode 100644
index 3610766..0000000
--- a/include/asm-frv/ide.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* ide.h: FRV IDE declarations
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_IDE_H
-#define _ASM_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm/setup.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_IDE_H */
diff --git a/include/asm-mn10300/ide.h b/include/asm-mn10300/ide.h
deleted file mode 100644
index 6adcdd9..0000000
--- a/include/asm-mn10300/ide.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/* MN10300 Arch-specific IDE code
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from include/asm-i386/ide.h
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_IDE_H
-#define _ASM_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm/intctl-regs.h>
-
-#undef SUPPORT_SLOW_DATA_PORTS
-#define SUPPORT_SLOW_DATA_PORTS 0
-
-#undef SUPPORT_VLB_SYNC
-#define SUPPORT_VLB_SYNC 0
-
-/*
- * some bits needed for parts of the IDE subsystem to compile
- */
-#define __ide_mm_insw(port, addr, n) \
-	insw((unsigned long) (port), (addr), (n))
-#define __ide_mm_insl(port, addr, n) \
-	insl((unsigned long) (port), (addr), (n))
-#define __ide_mm_outsw(port, addr, n) \
-	outsw((unsigned long) (port), (addr), (n))
-#define __ide_mm_outsl(port, addr, n) \
-	outsl((unsigned long) (port), (addr), (n))
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_IDE_H */
diff --git a/include/asm-mn10300/pci.h b/include/asm-mn10300/pci.h
index cd9cc5c..0517b45 100644
--- a/include/asm-mn10300/pci.h
+++ b/include/asm-mn10300/pci.h
@@ -121,4 +121,9 @@ pcibios_select_root(struct pci_dev *pdev, struct resource *res)
 
 #define pcibios_scan_all_fns(a, b)	0
 
+static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
+{
+	return channel ? 15 : 14;
+}
+
 #endif /* _ASM_PCI_H */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 9a061ac..68132c4 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -244,8 +244,6 @@ enum {
 	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-	/* EXABYTE specific */
-	ATA_EXABYTE_ENABLE_NEST	= 0xF0,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 25087ae..854eba8 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,7 +26,7 @@
 #include <asm/io.h>
 #include <asm/mutex.h>
 
-#if defined(CONFIG_CRIS) || defined(CONFIG_FRV)
+#if defined(CONFIG_CRIS) || defined(CONFIG_FRV) || defined(CONFIG_MN10300)
 # define SUPPORT_VLB_SYNC 0
 #else
 # define SUPPORT_VLB_SYNC 1
@@ -193,24 +193,8 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
-/* for IDE PCI controllers in legacy mode, temporary */
-static inline int __ide_default_irq(unsigned long base)
-{
-	switch (base) {
-#ifdef CONFIG_IA64
-	case 0x1f0: return isa_irq_to_vector(14);
-	case 0x170: return isa_irq_to_vector(15);
-#else
-	case 0x1f0: return 14;
-	case 0x170: return 15;
-#endif
-	}
-	return 0;
-}
-
-#if defined(CONFIG_ARM) || defined(CONFIG_FRV) || defined(CONFIG_M68K) || \
-    defined(CONFIG_MIPS) || defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
-    || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || defined(CONFIG_SPARC64)
+#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
+    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
 #include <asm/ide.h>
 #else
 #include <asm-generic/ide_iops.h>
@@ -866,7 +850,7 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
-	unsigned int	(*init_chipset)(struct pci_dev *);
+	int		(*init_chipset)(struct pci_dev *);
 	irq_handler_t	irq_handler;
 	unsigned long	host_flags;
 	void		*host_priv;
@@ -1146,11 +1130,14 @@ int generic_ide_ioctl(ide_drive_t *, struct block_device *, unsigned, unsigned l
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
-int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, int nr_sectors);
+int ide_end_request(ide_drive_t *, int, int);
+int ide_end_dequeued_request(ide_drive_t *, struct request *, int, int);
+void ide_kill_rq(ide_drive_t *, struct request *);
 
-extern void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry);
+void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
+		       ide_expiry_t *);
+void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
+		     ide_expiry_t *);
 
 void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
 			 ide_expiry_t *);
@@ -1169,13 +1156,14 @@ int ide_busy_sleep(ide_hwif_t *, unsigned long, int);
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
+ide_startstop_t ide_do_park_unpark(ide_drive_t *, struct request *);
+ide_startstop_t ide_do_devset(ide_drive_t *, struct request *);
+
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
 extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
-extern void ide_do_drive_cmd(ide_drive_t *, struct request *);
-
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
@@ -1200,10 +1188,6 @@ void SELECT_MASK(ide_drive_t *, int);
 u8 ide_read_error(ide_drive_t *);
 void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
 
-extern int drive_is_ready(ide_drive_t *);
-
-void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
-
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
@@ -1251,6 +1235,8 @@ int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
+int ide_dev_read_id(ide_drive_t *, u8, u16 *);
+
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
@@ -1280,7 +1266,7 @@ static inline int ide_pci_is_in_compatibility_mode(struct pci_dev *dev)
 	return 0;
 }
 
-void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int,
+void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *,
 			 hw_regs_t *, hw_regs_t **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
@@ -1349,10 +1335,6 @@ enum {
 	IDE_HFLAG_ERROR_STOPS_FIFO	= (1 << 19),
 	/* serialize ports */
 	IDE_HFLAG_SERIALIZE		= (1 << 20),
-	/* use legacy IRQs */
-	IDE_HFLAG_LEGACY_IRQS		= (1 << 21),
-	/* force use of legacy IRQs */
-	IDE_HFLAG_FORCE_LEGACY_IRQS	= (1 << 22),
 	/* host is TRM290 */
 	IDE_HFLAG_TRM290		= (1 << 23),
 	/* use 32-bit I/O ops */
@@ -1380,7 +1362,7 @@ enum {
 
 struct ide_port_info {
 	char			*name;
-	unsigned int		(*init_chipset)(struct pci_dev *);
+	int			(*init_chipset)(struct pci_dev *);
 	void			(*init_iops)(ide_hwif_t *);
 	void                    (*init_hwif)(ide_hwif_t *);
 	int			(*init_dma)(ide_hwif_t *,
@@ -1471,6 +1453,7 @@ static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 
 void ide_dma_lost_irq(ide_drive_t *);
 void ide_dma_timeout(ide_drive_t *);
+ide_startstop_t ide_dma_timeout_retry(ide_drive_t *, int);
 
 #else
 static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
@@ -1482,21 +1465,24 @@ static inline void ide_dma_on(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
+static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
+int ide_acpi_init(void);
 extern int ide_acpi_exec_tfs(ide_drive_t *drive);
 extern void ide_acpi_get_timing(ide_hwif_t *hwif);
 extern void ide_acpi_push_timing(ide_hwif_t *hwif);
-extern void ide_acpi_init(ide_hwif_t *hwif);
+void ide_acpi_init_port(ide_hwif_t *);
 void ide_acpi_port_init_devices(ide_hwif_t *);
 extern void ide_acpi_set_state(ide_hwif_t *hwif, int on);
 #else
+static inline int ide_acpi_init(void) { return 0; }
 static inline int ide_acpi_exec_tfs(ide_drive_t *drive) { return 0; }
 static inline void ide_acpi_get_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_push_timing(ide_hwif_t *hwif) { ; }
-static inline void ide_acpi_init(ide_hwif_t *hwif) { ; }
+static inline void ide_acpi_init_port(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
@@ -1530,9 +1516,7 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 	hwif->hwif_data = data;
 }
 
-const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
-extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
@@ -1571,14 +1555,18 @@ void ide_timing_merge(struct ide_timing *, struct ide_timing *,
 		      struct ide_timing *, unsigned int);
 int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
 
+#ifdef CONFIG_IDE_XFER_MODE
 int ide_scan_pio_blacklist(char *);
-
+const char *ide_xfer_verbose(u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
-
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
-
 void ide_set_pio(ide_drive_t *, u8);
+int ide_set_xfer_rate(ide_drive_t *, u8);
+#else
+static inline void ide_set_pio(ide_drive_t *drive, u8 pio) { ; }
+static inline int ide_set_xfer_rate(ide_drive_t *drive, u8 rate) { return -1; }
+#endif
 
 static inline void ide_set_max_pio(ide_drive_t *drive)
 {
@@ -1611,6 +1599,10 @@ static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 #define ide_port_for_each_dev(i, dev, port) \
 	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++)
 
+#define ide_port_for_each_present_dev(i, dev, port) \
+	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++) \
+		if ((dev)->dev_flags & IDE_DFLAG_PRESENT)
+
 #define ide_host_for_each_port(i, port, host) \
 	for ((i) = 0; ((port) = (host)->ports[i]) || (i) < MAX_HOST_PORTS; (i)++)
 
