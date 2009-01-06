Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZAFRPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZAFRPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZAFRPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:15:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45705 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZAFRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=WYUZjGxcg8hG0b+fhUlxG8ieIG8cVKZ9RQf+0fA4mjAgDHXGcSqifKD4TPLzLw+hlu
         9PsbL0v24YXC3iPDFzK6F4fYxNp3/7EdO/MzcutjkAKk4Q2oEugVPIQEMYBIITrso+Ch
         OQl9FRAgSRjSvuBMtPF4lzw2nOFv2LT39QKZs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 3
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 6 Jan 2009 18:12:35 +0100
Message-Id: <200901061812.36145.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Part three:

* Resurrect IT8172 IDE host driver.
  (from Shane McDonald)

* Fix 32-bit I/O support for ATA-8 and ATA-1 devices.
  (from Mario Schwalbe)

* Switch ide-cd over generic ATAPI support.
  (from Borislav Petkov)

* New locking scheme (which is both simpler and more efficient) for hosts
  with serialized ports and related cleanups.

* struct ide_dma_ops sanitization and related cleanups.
  (from Sergei Shtylyov)

* Misc fixups/cleanups...

This should be the final part of IDE updates for 2.6.29 merge window
(I would like to thank all contributors!).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide/warm-plug-howto.txt |    5 +
 drivers/ide/Kconfig                   |    7 +
 drivers/ide/Makefile                  |    1 +
 drivers/ide/aec62xx.c                 |    4 +-
 drivers/ide/alim15x3.c                |   10 +-
 drivers/ide/amd74xx.c                 |    4 +-
 drivers/ide/au1xxx-ide.c              |   11 +-
 drivers/ide/cmd640.c                  |    5 +-
 drivers/ide/cmd64x.c                  |   23 +-
 drivers/ide/cs5520.c                  |    2 +-
 drivers/ide/cy82c693.c                |    2 +-
 drivers/ide/falconide.c               |    1 -
 drivers/ide/hpt366.c                  |   23 +-
 drivers/ide/icside.c                  |   12 +-
 drivers/ide/ide-acpi.c                |   22 +-
 drivers/ide/ide-atapi.c               |   13 +-
 drivers/ide/ide-cd.c                  |  118 +--------
 drivers/ide/ide-cd.h                  |   34 ++--
 drivers/ide/ide-disk.c                |    4 +-
 drivers/ide/ide-dma-sff.c             |   63 +++--
 drivers/ide/ide-dma.c                 |    2 +-
 drivers/ide/ide-floppy.c              |    2 +-
 drivers/ide/ide-gd.c                  |    3 +-
 drivers/ide/ide-gd.h                  |   10 +-
 drivers/ide/ide-h8300.c               |    1 -
 drivers/ide/ide-io.c                  |  410 ++++++++++++++---------------
 drivers/ide/ide-iops.c                |  100 +++----
 drivers/ide/ide-lib.c                 |    9 +-
 drivers/ide/ide-park.c                |   16 +-
 drivers/ide/ide-pm.c                  |    8 +-
 drivers/ide/ide-probe.c               |  474 +++++++++++++++++----------------
 drivers/ide/ide-proc.c                |   23 +-
 drivers/ide/ide-tape.c                |   20 +-
 drivers/ide/ide-taskfile.c            |   14 +-
 drivers/ide/ide.c                     |  187 +-------------
 drivers/ide/it8172.c                  |  166 ++++++++++++
 drivers/ide/it8213.c                  |    4 +-
 drivers/ide/it821x.c                  |   13 +-
 drivers/ide/ns87415.c                 |   14 +-
 drivers/ide/palm_bk3710.c             |    3 +-
 drivers/ide/pdc202xx_new.c            |    4 +-
 drivers/ide/pdc202xx_old.c            |   14 +-
 drivers/ide/piix.c                    |    8 +-
 drivers/ide/pmac.c                    |    7 +-
 drivers/ide/q40ide.c                  |    1 -
 drivers/ide/qd65xx.c                  |    7 +-
 drivers/ide/qd65xx.h                  |    4 +-
 drivers/ide/sc1200.c                  |    9 +-
 drivers/ide/scc_pata.c                |   33 ++--
 drivers/ide/serverworks.c             |    2 +-
 drivers/ide/setup-pci.c               |   12 +-
 drivers/ide/sgiioc4.c                 |   15 +-
 drivers/ide/siimage.c                 |   11 +-
 drivers/ide/sis5513.c                 |    2 +-
 drivers/ide/sl82c105.c                |    5 +-
 drivers/ide/slc90e66.c                |    4 +-
 drivers/ide/tc86c001.c                |   17 +-
 drivers/ide/triflex.c                 |    2 +-
 drivers/ide/trm290.c                  |   10 +-
 drivers/ide/tx4939ide.c               |   23 +-
 drivers/ide/umc8672.c                 |   13 +-
 drivers/ide/via82cxxx.c               |    2 +-
 include/linux/ide.h                   |  171 +++++--------
 include/linux/pci_ids.h               |    1 +
 64 files changed, 1036 insertions(+), 1184 deletions(-)
 create mode 100644 drivers/ide/it8172.c


Bartlomiej Zolnierkiewicz (32):
      ide: fix LOCKDEP warning
      ide: fix setting nIEN on idle devices
      ide: add ->cur_port to struct ide_host and use it for serialized hosts
      ide: use per-port IRQ handlers
      ide: remove hwgroup->hwif and {drive,hwif}->next
      ide: use lock bitops for ports serialization (v2)
      ide: merge ide_hwgroup_t with ide_hwif_t (v2)
      ide: update ide_unregister() documentation
      ide: move ide_init_port_data() and friends to ide-probe.c
      ide: remove HWIF() macro
      ide: remove local_irq_set() macro
      ide: remove ide_pci_enablebit_t typedef
      ide: remove 'byte' typedef
      ide: remove ide_driver_t typedef
      ide: unexport ide_wait_not_busy()
      ide: remove ->error method from struct ide_driver
      amd74xx: use ide_get_pair_dev() helper
      cmd640: use ide_get_pair_dev() helper
      cmd64x: use ide_get_pair_dev() helper
      it821x: use ide_get_pair_dev() helper
      ide: NUMA aware allocation of host and port structures
      ide: dynamic allocation of device structures
      ide: add port and host iterators
      ide: make "paranoia" ->handler check in ide_intr() more strict
      ide: use ide_pci_is_in_compatibility_mode() helper in setup-pci.c
      ide: remove superfluous hwif variable assignment from ide_timer_expiry()
      ide: struct ide_atapi_pc - remove unused fields and update documentation
      ide: remove unused ide_hwif_t.sg_mapped field
      ide: remove now redundant ->cur_dev checks
      ide: fix ide_port_scan() to do ACPI setup after initializing request queues
      ide: update warm-plug HOWTO
      piix: sync ich_laptop[] with ata_piix.c

Borislav Petkov (3):
      ide-cd: wait for DRQ to get set per default
      ide-cd: start DMA before sending the actual packet command
      ide-cd: convert to ide-atapi facilities

Mario Schwalbe (1):
      ide: Fix drive's DWORD-IO handling

Sergei Shtylyov (4):
      ide: don't set hwif->dma_ops in init_dma() method
      ide: move read_sff_dma_status() method to 'struct ide_dma_ops'
      ide-dma-sff: factor out ide_dma_sff_write_status()
      scc_pata: make use of scc_dma_sff_read_status()

Shane McDonald (1):
      Resurrect IT8172 IDE controller driver


diff --git a/Documentation/ide/warm-plug-howto.txt b/Documentation/ide/warm-plug-howto.txt
index d588546..98152bc 100644
--- a/Documentation/ide/warm-plug-howto.txt
+++ b/Documentation/ide/warm-plug-howto.txt
@@ -11,3 +11,8 @@ unplug old device(s) and plug new device(s)
 # echo -n "1" > /sys/class/ide_port/idex/scan
 
 done
+
+NOTE: please make sure that partitions are unmounted and that there are
+no other active references to devices before doing "delete_devices" step,
+also do not attempt "scan" step on devices currently in use -- otherwise
+results may be unpredictable and lead to data loss if you're unlucky
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 4ee85fc..3f95038 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -511,6 +511,13 @@ config BLK_DEV_PIIX
 	  This allows the kernel to change PIO, DMA and UDMA speeds and to
 	  configure the chip to optimum performance.
 
+config BLK_DEV_IT8172
+	tristate "IT8172 IDE support"
+	select BLK_DEV_IDEDMA_PCI
+	help
+	  This driver adds support for the IDE controller on the
+	  IT8172 System Controller.
+
 config BLK_DEV_IT8213
 	tristate "IT8213 IDE support"
 	select BLK_DEV_IDEDMA_PCI
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 4107289..c2b9c93 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.o
 obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
 obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
 obj-$(CONFIG_BLK_DEV_HPT366)		+= hpt366.o
+obj-$(CONFIG_BLK_DEV_IT8172)		+= it8172.o
 obj-$(CONFIG_BLK_DEV_IT8213)		+= it8213.o
 obj-$(CONFIG_BLK_DEV_IT821X)		+= it821x.o
 obj-$(CONFIG_BLK_DEV_JMICRON)		+= jmicron.o
diff --git a/drivers/ide/aec62xx.c b/drivers/ide/aec62xx.c
index 4142c69..4485b9c 100644
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -83,7 +83,7 @@ static u8 pci_bus_clock_list_ultra (u8 speed, struct chipset_bus_clock_list_entr
 
 static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
@@ -111,7 +111,7 @@ static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 
 static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 45d2356..66f4308 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -68,7 +68,7 @@ static struct pci_dev *isa_dev;
 
 static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	int s_time = t->setup, a_time = t->active, c_time = t->cycle;
@@ -150,7 +150,7 @@ static u8 ali_udma_filter(ide_drive_t *drive)
 
 static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 speed1		= speed;
 	u8 unit			= drive->dn & 1;
@@ -198,7 +198,7 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 static int ali15x3_dma_setup(ide_drive_t *drive)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
-		if (rq_data_dir(drive->hwif->hwgroup->rq))
+		if (rq_data_dir(drive->hwif->rq))
 			return 1;	/* try PIO instead of DMA */
 	}
 	return ide_dma_setup(drive);
@@ -490,8 +490,6 @@ static int __devinit init_dma_ali15x3(ide_hwif_t *hwif,
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	hwif->dma_ops = &sff_dma_ops;
-
 	return 0;
 }
 
@@ -511,6 +509,7 @@ static const struct ide_dma_ops ali_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
@@ -519,6 +518,7 @@ static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.init_hwif	= init_hwif_ali15x3,
 	.init_dma	= init_dma_ali15x3,
 	.port_ops	= &ali_port_ops,
+	.dma_ops	= &sff_dma_ops,
 	.pio_mask	= ATA_PIO5,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index c6bcd30..69660a4 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -82,7 +82,7 @@ static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
+	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct ide_timing t, p;
 	int T, UT;
 	u8 udma_mask = hwif->ultra_mask;
@@ -92,7 +92,7 @@ static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->dev_flags & IDE_DFLAG_PRESENT) {
+	if (peer) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 0ec8fd1..79a2dfe 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -212,8 +212,8 @@ static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 static int auide_build_dmatable(ide_drive_t *drive)
 {
 	int i, iswrite, count = 0;
-	ide_hwif_t *hwif = HWIF(drive);
-	struct request *rq = HWGROUP(drive)->rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
 
@@ -286,7 +286,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	if (hwif->sg_nents) {
 		ide_destroy_dmatable(drive);
@@ -309,8 +309,8 @@ static void auide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 }
 
 static int auide_dma_setup(ide_drive_t *drive)
-{       	
-	struct request *rq = HWGROUP(drive)->rq;
+{
+	struct request *rq = drive->hwif->rq;
 
 	if (!auide_build_dmatable(drive)) {
 		ide_map_sg(drive, rq);
@@ -502,7 +502,6 @@ static const struct ide_tp_ops au1xxx_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index e430664..8890276 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -467,11 +467,10 @@ static void program_drive_counts(ide_drive_t *drive, unsigned int index)
 	 * so we merge the timings, using the slowest value for each timing.
 	 */
 	if (index > 1) {
-		ide_hwif_t *hwif = drive->hwif;
-		ide_drive_t *peer = &hwif->drives[!(drive->dn & 1)];
+		ide_drive_t *peer = ide_get_pair_dev(drive);
 		unsigned int mate = index ^ 1;
 
-		if (peer->dev_flags & IDE_DFLAG_PRESENT) {
+		if (peer) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index 3623bf0..2f9688d 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -115,7 +115,7 @@ static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_
  */
 static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
@@ -138,10 +138,12 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 	 * the slowest address setup timing ourselves.
 	 */
 	if (hwif->channel) {
-		ide_drive_t *drives = hwif->drives;
+		ide_drive_t *pair = ide_get_pair_dev(drive);
 
 		drive->drive_data = setup_count;
-		setup_count = max(drives[0].drive_data, drives[1].drive_data);
+
+		if (pair)
+			setup_count = max_t(u8, setup_count, pair->drive_data);
 	}
 
 	if (setup_count > 5)		/* shouldn't actually happen... */
@@ -180,7 +182,7 @@ static void cmd64x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
@@ -226,7 +228,7 @@ static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 static int cmd648_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	int err			= ide_dma_end(drive);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
@@ -242,7 +244,7 @@ static int cmd648_dma_end(ide_drive_t *drive)
 
 static int cmd64x_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
@@ -259,7 +261,7 @@ static int cmd64x_dma_end(ide_drive_t *drive)
 
 static int cmd648_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
@@ -282,7 +284,7 @@ static int cmd648_dma_test_irq(ide_drive_t *drive)
 
 static int cmd64x_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
@@ -313,7 +315,7 @@ static int cmd64x_dma_test_irq(ide_drive_t *drive)
 
 static int cmd646_1_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
@@ -383,6 +385,7 @@ static const struct ide_dma_ops cmd64x_dma_ops = {
 	.dma_test_irq		= cmd64x_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_dma_ops cmd646_rev1_dma_ops = {
@@ -394,6 +397,7 @@ static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_dma_ops cmd648_dma_ops = {
@@ -405,6 +409,7 @@ static const struct ide_dma_ops cmd648_dma_ops = {
 	.dma_test_irq		= cmd648_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index 5efb467..d003bec 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -59,7 +59,7 @@ static struct pio_clocks cs5520_pio_clocks[]={
 
 static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
 
diff --git a/drivers/ide/cy82c693.c b/drivers/ide/cy82c693.c
index d37baf8..74fc540 100644
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -203,7 +203,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 
 static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	pio_clocks_t pclk;
 	unsigned int addrCtrl;
diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index 39d500d..a5ba820 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -70,7 +70,6 @@ static const struct ide_tp_ops falconide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index b18e10d..3eb9b5c 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -626,7 +626,7 @@ static struct hpt_info *hpt3xx_get_info(struct device *dev)
 
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 mask 		= hwif->ultra_mask;
 
@@ -665,7 +665,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 
 static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	switch (info->chip_type) {
@@ -743,7 +743,7 @@ static void hpt3xx_quirkproc(ide_drive_t *drive)
 
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
@@ -788,7 +788,7 @@ static void hpt366_dma_lost_irq(ide_drive_t *drive)
 
 static void hpt370_clear_engine(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	pci_write_config_byte(dev, hwif->select_data, 0x37);
@@ -797,7 +797,7 @@ static void hpt370_clear_engine(ide_drive_t *drive)
 
 static void hpt370_irq_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_cmd;
@@ -822,7 +822,7 @@ static void hpt370_dma_start(ide_drive_t *drive)
 
 static int hpt370_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	if (dma_stat & 0x01) {
@@ -844,7 +844,7 @@ static void hpt370_dma_timeout(ide_drive_t *drive)
 /* returns 1 if DMA IRQ issued, 0 otherwise */
 static int hpt374_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_stat;
@@ -865,7 +865,7 @@ static int hpt374_dma_test_irq(ide_drive_t *drive)
 
 static int hpt374_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 mcr	= 0, mcr_addr	= hwif->select_data;
 	u8 bwsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
@@ -927,7 +927,7 @@ static void hpt3xxn_set_clock(ide_hwif_t *hwif, u8 mode)
 
 static void hpt3xxn_rw_disk(ide_drive_t *drive, struct request *rq)
 {
-	hpt3xxn_set_clock(HWIF(drive), rq_data_dir(rq) ? 0x23 : 0x21);
+	hpt3xxn_set_clock(drive->hwif, rq_data_dir(rq) ? 0x23 : 0x21);
 }
 
 /**
@@ -1349,8 +1349,6 @@ static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	hwif->dma_ops = &sff_dma_ops;
-
 	return 0;
 }
 
@@ -1426,6 +1424,7 @@ static const struct ide_dma_ops hpt37x_dma_ops = {
 	.dma_test_irq		= hpt374_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_dma_ops hpt370_dma_ops = {
@@ -1437,6 +1436,7 @@ static const struct ide_dma_ops hpt370_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= hpt370_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_dma_ops hpt36x_dma_ops = {
@@ -1448,6 +1448,7 @@ static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 81f70ca..97a35c6 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -166,7 +166,7 @@ static const expansioncard_ops_t icside_ops_arcin_v6 = {
  */
 static void icside_maskproc(ide_drive_t *drive, int mask)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
 	unsigned long flags;
@@ -284,7 +284,7 @@ static void icside_dma_host_set(ide_drive_t *drive, int on)
 
 static int icside_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
 	drive->waiting_for_dma = 0;
@@ -299,7 +299,7 @@ static int icside_dma_end(ide_drive_t *drive)
 
 static void icside_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
 	/* We can not enable DMA on both channels simultaneously. */
@@ -309,10 +309,10 @@ static void icside_dma_start(ide_drive_t *drive)
 
 static int icside_dma_setup(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int dma_mode;
 
 	if (rq_data_dir(rq))
@@ -362,7 +362,7 @@ static void icside_dma_exec_cmd(ide_drive_t *drive, u8 cmd)
 
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index fd4a364..2f9e941 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -218,7 +218,7 @@ static acpi_handle ide_acpi_hwif_get_handle(ide_hwif_t *hwif)
  */
 static acpi_handle ide_acpi_drive_get_handle(ide_drive_t *drive)
 {
-	ide_hwif_t	*hwif = HWIF(drive);
+	ide_hwif_t	*hwif = drive->hwif;
 	int		 port;
 	acpi_handle	 drive_handle;
 
@@ -263,7 +263,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	acpi_status			status;
 	struct acpi_buffer		output;
 	union acpi_object 		*out_obj;
-	ide_hwif_t			*hwif = HWIF(drive);
+	ide_hwif_t			*hwif = drive->hwif;
 	struct device			*dev = hwif->gendev.parent;
 	int				err = -ENODEV;
 	int				port;
@@ -641,7 +641,8 @@ void ide_acpi_push_timing(ide_hwif_t *hwif)
  */
 void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 {
-	int unit;
+	ide_drive_t *drive;
+	int i;
 
 	if (ide_noacpi || ide_noacpi_psx)
 		return;
@@ -655,9 +656,8 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 	/* channel first and then drives for power on and verse versa for power off */
 	if (on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
 
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (!drive->acpidata->obj_handle)
 			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
 
@@ -711,15 +711,13 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	 * for both drives, regardless whether they are connected
 	 * or not.
 	 */
-	hwif->drives[0].acpidata = &hwif->acpidata->master;
-	hwif->drives[1].acpidata = &hwif->acpidata->slave;
+	hwif->devices[0]->acpidata = &hwif->acpidata->master;
+	hwif->devices[1]->acpidata = &hwif->acpidata->slave;
 
 	/*
 	 * Send IDENTIFY for each drive
 	 */
-	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = &hwif->drives[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
@@ -744,9 +742,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = &hwif->drives[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e8688c0..e96c012 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(ide_retry_pc);
 
 int ide_cd_expiry(ide_drive_t *drive)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	unsigned long wait = 0;
 
 	debug_log("%s: rq->cmd[0]: 0x%x\n", __func__, rq->cmd[0]);
@@ -294,7 +294,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
 	unsigned int timeout, temp;
@@ -491,7 +491,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *uninitialized_var(pc);
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
 	int cmd_len;
@@ -549,7 +549,10 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	/* Set the interrupt routine */
-	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
+	ide_set_handler(drive,
+			(dev_is_idecd(drive) ? drive->irq_handler
+					     : ide_pc_intr),
+			timeout, expiry);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
@@ -580,7 +583,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
-		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
+		bcount = ide_cd_get_xferlen(hwif->rq);
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 1a7410f..cae6937 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -239,7 +239,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	int nsectors = rq->hard_cur_sectors;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
@@ -306,8 +306,7 @@ static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	struct request *rq = hwif->rq;
 	int stat, err, sense_key;
 
 	/* check for errors */
@@ -502,7 +501,7 @@ end_request:
 		blkdev_dequeue_request(rq);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
-		hwgroup->rq = NULL;
+		hwif->rq = NULL;
 
 		cdrom_queue_request_sense(drive, rq->sense, rq);
 	} else
@@ -511,106 +510,6 @@ end_request:
 	return 1;
 }
 
-static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *);
-static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
-
-/*
- * Set up the device registers for transferring a packet command on DEV,
- * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
- * which actually transfers the command to the drive.  If this is a
- * drq_interrupt device, this routine will arrange for HANDLER to be
- * called when the interrupt from the drive arrives.  Otherwise, HANDLER
- * will be called immediately after the drive is prepared for the transfer.
- */
-static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
-	int xferlen;
-
-	xferlen = ide_cd_get_xferlen(rq);
-
-	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
-
-	/* FIXME: for Virtual DMA we must check harder */
-	if (drive->dma)
-		drive->dma = !hwif->dma_ops->dma_setup(drive);
-
-	/* set up the controller registers */
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
-			   xferlen, drive->dma);
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/* waiting for CDB interrupt, not DMA yet. */
-		if (drive->dma)
-			drive->waiting_for_dma = 0;
-
-		/* packet command */
-		ide_execute_command(drive, ATA_CMD_PACKET,
-				    cdrom_transfer_packet_command,
-				    ATAPI_WAIT_PC, ide_cd_expiry);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-
-		return cdrom_transfer_packet_command(drive);
-	}
-}
-
-/*
- * Send a packet command to DRIVE described by CMD_BUF and CMD_LEN. The device
- * registers must have already been prepared by cdrom_start_packet_command.
- * HANDLER is the interrupt handler to call when the command completes or
- * there's data ready.
- */
-#define ATAPI_MIN_CDB_BYTES 12
-static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
-	int cmd_len;
-	ide_startstop_t startstop;
-
-	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/*
-		 * Here we should have been called after receiving an interrupt
-		 * from the device.  DRQ should how be set.
-		 */
-
-		/* check for errors */
-		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
-			return ide_stopped;
-
-		/* ok, next interrupt will be DMA interrupt */
-		if (drive->dma)
-			drive->waiting_for_dma = 1;
-	} else {
-		/* otherwise, we must wait for DRQ to get set */
-		if (ide_wait_stat(&startstop, drive, ATA_DRQ,
-				  ATA_BUSY, WAIT_READY))
-			return startstop;
-	}
-
-	/* arm the interrupt handler */
-	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, ide_cd_expiry);
-
-	/* ATAPI commands get padded out to 12 bytes minimum */
-	cmd_len = COMMAND_SIZE(rq->cmd[0]);
-	if (cmd_len < ATAPI_MIN_CDB_BYTES)
-		cmd_len = ATAPI_MIN_CDB_BYTES;
-
-	/* send the command to the device */
-	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
-	/* start the DMA if need be */
-	if (drive->dma)
-		hwif->dma_ops->dma_start(drive);
-
-	return ide_started;
-}
-
 /*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
@@ -854,8 +753,7 @@ static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	struct request *rq = hwif->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
@@ -1061,7 +959,7 @@ end_request:
 		if (blk_end_request(rq, 0, dlen))
 			BUG();
 
-		hwgroup->rq = NULL;
+		hwif->rq = NULL;
 	} else {
 		if (!uptodate)
 			rq->cmd_flags |= REQ_FAILED;
@@ -1183,7 +1081,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		return ide_stopped;
 	}
 
-	return cdrom_start_packet_command(drive);
+	return ide_issue_pc(drive);
 }
 
 /*
@@ -1916,7 +1814,7 @@ static void ide_cd_release(struct kref *kref)
 
 static int ide_cd_probe(ide_drive_t *);
 
-static ide_driver_t ide_cdrom_driver = {
+static struct ide_driver ide_cdrom_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-cdrom",
@@ -1927,7 +1825,6 @@ static ide_driver_t ide_cdrom_driver = {
 	.version		= IDECD_VERSION,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_cd_proc_entries,
 	.proc_devsets		= ide_cd_proc_devsets,
@@ -2082,6 +1979,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	}
 
 	drive->debug_mask = debug_mask;
+	drive->irq_handler = cdrom_newpc_intr;
 
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index bf676b2..ac40d6c 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -33,33 +33,33 @@
 
 /* Structure of a MSF cdrom address. */
 struct atapi_msf {
-	byte reserved;
-	byte minute;
-	byte second;
-	byte frame;
+	u8 reserved;
+	u8 minute;
+	u8 second;
+	u8 frame;
 };
 
 /* Space to hold the disk TOC. */
 #define MAX_TRACKS 99
 struct atapi_toc_header {
 	unsigned short toc_length;
-	byte first_track;
-	byte last_track;
+	u8 first_track;
+	u8 last_track;
 };
 
 struct atapi_toc_entry {
-	byte reserved1;
+	u8 reserved1;
 #if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 adr     : 4;
-	__u8 control : 4;
+	u8 adr     : 4;
+	u8 control : 4;
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 control : 4;
-	__u8 adr     : 4;
+	u8 control : 4;
+	u8 adr     : 4;
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
-	byte track;
-	byte reserved2;
+	u8 track;
+	u8 reserved2;
 	union {
 		unsigned lba;
 		struct atapi_msf msf;
@@ -77,10 +77,10 @@ struct atapi_toc {
 
 /* Extra per-device info for cdrom drives. */
 struct cdrom_info {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
 
 	/* Buffer for table of contents.  NULL if we haven't allocated
 	   a TOC buffer for this device yet. */
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index eb9fac4..4088a62 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -89,7 +89,7 @@ static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
 static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u16 nsectors		= (u16)rq->nr_sectors;
 	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
 	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
@@ -187,7 +187,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 				      sector_t block)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
 
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
index f6d2d44..123d393 100644
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -50,6 +50,27 @@ int config_drive_for_dma(ide_drive_t *drive)
 	return 0;
 }
 
+u8 ide_dma_sff_read_status(ide_hwif_t *hwif)
+{
+	unsigned long addr = hwif->dma_base + ATA_DMA_STATUS;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)addr);
+	else
+		return inb(addr);
+}
+EXPORT_SYMBOL_GPL(ide_dma_sff_read_status);
+
+static void ide_dma_sff_write_status(ide_hwif_t *hwif, u8 val)
+{
+	unsigned long addr = hwif->dma_base + ATA_DMA_STATUS;
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(val, (void __iomem *)addr);
+	else
+		outb(val, addr);
+}
+
 /**
  *	ide_dma_host_set	-	Enable/disable DMA on a host
  *	@drive: drive to control
@@ -62,18 +83,14 @@ void ide_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 unit = drive->dn & 1;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
 	else
 		dma_stat &= ~(1 << (5 + unit));
 
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(dma_stat,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
+	ide_dma_sff_write_status(hwif, dma_stat);
 }
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
 
@@ -175,7 +192,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 int ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
@@ -187,7 +204,7 @@ int ide_dma_setup(ide_drive_t *drive)
 	}
 
 	/* PRD table */
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
+	if (mmio)
 		writel(hwif->dmatable_dma,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
 	else
@@ -200,15 +217,10 @@ int ide_dma_setup(ide_drive_t *drive)
 		outb(reading, hwif->dma_base + ATA_DMA_CMD);
 
 	/* read DMA status for INTR & ERROR flags */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
 	/* clear INTR & ERROR flags */
-	if (mmio)
-		writeb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
-		     hwif->dma_base + ATA_DMA_STATUS);
+	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
 	drive->waiting_for_dma = 1;
 	return 0;
@@ -232,7 +244,7 @@ EXPORT_SYMBOL_GPL(ide_dma_setup);
 static int dma_timer_expiry(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
 	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
 		drive->name, __func__, dma_stat);
@@ -240,7 +252,7 @@ static int dma_timer_expiry(ide_drive_t *drive)
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
 
-	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
+	hwif->expiry = NULL;	/* one free ride for now */
 
 	if (dma_stat & ATA_DMA_ERR)	/* ERROR */
 		return -1;
@@ -289,13 +301,12 @@ EXPORT_SYMBOL_GPL(ide_dma_start);
 int ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat = 0, dma_cmd = 0, mask;
 
 	drive->waiting_for_dma = 0;
 
 	/* stop DMA */
-	if (mmio) {
+	if (hwif->host_flags & IDE_HFLAG_MMIO) {
 		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 		writeb(dma_cmd & ~ATA_DMA_START,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
@@ -305,15 +316,10 @@ int ide_dma_end(ide_drive_t *drive)
 	}
 
 	/* get DMA status */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
-	if (mmio)
-		/* clear the INTR & ERROR bits */
-		writeb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
-		     hwif->dma_base + ATA_DMA_STATUS);
+	/* clear INTR & ERROR bits */
+	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
@@ -331,7 +337,7 @@ EXPORT_SYMBOL_GPL(ide_dma_end);
 int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 
 	return (dma_stat & ATA_DMA_INTR) ? 1 : 0;
 }
@@ -346,5 +352,6 @@ const struct ide_dma_ops sff_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 EXPORT_SYMBOL_GPL(sff_dma_ops);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index fffd117..72ebab0 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -96,7 +96,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = hwif->hwgroup->rq;
+			struct request *rq = hwif->rq;
 
 			task_end_request(drive, rq, stat);
 			return ide_stopped;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 0a48e2d..3eab1c6 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -71,7 +71,7 @@
 static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	int error;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index b8078b3..7857b20 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -149,7 +149,7 @@ static int ide_gd_end_request(ide_drive_t *drive, int uptodate, int nrsecs)
 	return drive->disk_ops->end_request(drive, uptodate, nrsecs);
 }
 
-static ide_driver_t ide_gd_driver = {
+static struct ide_driver ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-gd",
@@ -162,7 +162,6 @@ static ide_driver_t ide_gd_driver = {
 	.version		= IDE_GD_VERSION,
 	.do_request		= ide_gd_do_request,
 	.end_request		= ide_gd_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
 	.proc_devsets		= ide_disk_proc_devsets,
diff --git a/drivers/ide/ide-gd.h b/drivers/ide/ide-gd.h
index 7d3d101..a86779f 100644
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -14,11 +14,11 @@
 #endif
 
 struct ide_disk_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
+	unsigned int		openers;	/* protected by BKL for now */
 
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
diff --git a/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
index e2cdd2e..9270d32 100644
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -159,7 +159,6 @@ static const struct ide_tp_ops h8300_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1c36a8e..cc16331 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -88,7 +88,7 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 		ret = 0;
 
 	if (ret == 0 && dequeue)
-		drive->hwif->hwgroup->rq = NULL;
+		drive->hwif->rq = NULL;
 
 	return ret;
 }
@@ -107,7 +107,7 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 {
 	unsigned int nr_bytes = nr_sectors << 9;
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
@@ -160,8 +160,8 @@ EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
  
 void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->rq;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = (ide_task_t *)rq->special;
@@ -186,7 +186,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 		return;
 	}
 
-	hwgroup->rq = NULL;
+	hwif->rq = NULL;
 
 	rq->errors = err;
 
@@ -199,9 +199,9 @@ EXPORT_SYMBOL(ide_end_drive_cmd);
 static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
 	if (rq->rq_disk) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 		drv->end_request(drive, 0, 0);
 	} else
 		ide_end_request(drive, 0, 0);
@@ -291,7 +291,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 	return ide_stopped;
 }
 
-ide_startstop_t
+static ide_startstop_t
 __ide_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
 	if (drive->media == ide_disk)
@@ -299,8 +299,6 @@ __ide_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 	return ide_atapi_error(drive, rq, stat, err);
 }
 
-EXPORT_SYMBOL_GPL(__ide_error);
-
 /**
  *	ide_error	-	handle an error on the IDE
  *	@drive: drive the error occurred on
@@ -321,7 +319,8 @@ ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
 
 	err = ide_dump_status(drive, msg, stat);
 
-	if ((rq = HWGROUP(drive)->rq) == NULL)
+	rq = drive->hwif->rq;
+	if (rq == NULL)
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
@@ -331,15 +330,8 @@ ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
 		return ide_stopped;
 	}
 
-	if (rq->rq_disk) {
-		ide_driver_t *drv;
-
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
-		return drv->error(drive, rq, stat, err);
-	} else
-		return __ide_error(drive, rq, stat, err);
+	return __ide_error(drive, rq, stat, err);
 }
-
 EXPORT_SYMBOL_GPL(ide_error);
 
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
@@ -462,7 +454,7 @@ EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	ide_task_t *task = rq->special;
 
 	if (task) {
@@ -586,7 +578,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 
 #ifdef DEBUG
 	printk("%s: start_request: current=0x%08lx\n",
-		HWIF(drive)->name, (unsigned long) rq);
+		drive->hwif->name, (unsigned long) rq);
 #endif
 
 	/* bail early if we've exceeded max_failures */
@@ -605,7 +597,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		return startstop;
 	}
 	if (!drive->special.all) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
 		/*
 		 * We reset the drive so we need to issue a SETFEATURES.
@@ -638,7 +630,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			 */
 			return ide_special_rq(drive, rq);
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 
 		return drv->do_request(drive, rq, rq->sector);
 	}
@@ -654,7 +646,7 @@ kill_rq:
  *	@timeout: time to stall for (jiffies)
  *
  *	ide_stall_queue() can be used by a drive to give excess bandwidth back
- *	to the hwgroup by sleeping for timeout jiffies.
+ *	to the port by sleeping for timeout jiffies.
  */
  
 void ide_stall_queue (ide_drive_t *drive, unsigned long timeout)
@@ -666,45 +658,53 @@ void ide_stall_queue (ide_drive_t *drive, unsigned long timeout)
 }
 EXPORT_SYMBOL(ide_stall_queue);
 
+static inline int ide_lock_port(ide_hwif_t *hwif)
+{
+	if (hwif->busy)
+		return 1;
+
+	hwif->busy = 1;
+
+	return 0;
+}
+
+static inline void ide_unlock_port(ide_hwif_t *hwif)
+{
+	hwif->busy = 0;
+}
+
+static inline int ide_lock_host(struct ide_host *host, ide_hwif_t *hwif)
+{
+	int rc = 0;
+
+	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
+		rc = test_and_set_bit_lock(IDE_HOST_BUSY, &host->host_busy);
+		if (rc == 0) {
+			/* for atari only */
+			ide_get_lock(ide_intr, hwif);
+		}
+	}
+	return rc;
+}
+
+static inline void ide_unlock_host(struct ide_host *host)
+{
+	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
+		/* for atari only */
+		ide_release_lock();
+		clear_bit_unlock(IDE_HOST_BUSY, &host->host_busy);
+	}
+}
+
 /*
- * Issue a new request to a drive from hwgroup
- *
- * A hwgroup is a serialized group of IDE interfaces.  Usually there is
- * exactly one hwif (interface) per hwgroup, but buggy controllers (eg. CMD640)
- * may have both interfaces in a single hwgroup to "serialize" access.
- * Or possibly multiple ISA interfaces can share a common IRQ by being grouped
- * together into one hwgroup for serialized access.
- *
- * Note also that several hwgroups can end up sharing a single IRQ,
- * possibly along with many other devices.  This is especially common in
- * PCI-based systems with off-board IDE controller cards.
- *
- * The IDE driver uses a per-hwgroup lock to protect the hwgroup->busy flag.
- *
- * The first thread into the driver for a particular hwgroup sets the
- * hwgroup->busy flag to indicate that this hwgroup is now active,
- * and then initiates processing of the top request from the request queue.
- *
- * Other threads attempting entry notice the busy setting, and will simply
- * queue their new requests and exit immediately.  Note that hwgroup->busy
- * remains set even when the driver is merely awaiting the next interrupt.
- * Thus, the meaning is "this hwgroup is busy processing a request".
- *
- * When processing of a request completes, the completing thread or IRQ-handler
- * will start the next request from the queue.  If no more work remains,
- * the driver will clear the hwgroup->busy flag and exit.
- *
- * The per-hwgroup spinlock is used to protect all access to the
- * hwgroup->busy flag, but is otherwise not needed for most processing in
- * the driver.  This makes the driver much more friendlier to shared IRQs
- * than previous designs, while remaining 100% (?) SMP safe and capable.
+ * Issue a new request to a device.
  */
 void do_ide_request(struct request_queue *q)
 {
 	ide_drive_t	*drive = q->queuedata;
 	ide_hwif_t	*hwif = drive->hwif;
-	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
-	struct request	*rq;
+	struct ide_host *host = hwif->host;
+	struct request	*rq = NULL;
 	ide_startstop_t	startstop;
 
 	/*
@@ -721,32 +721,40 @@ void do_ide_request(struct request_queue *q)
 		blk_remove_plug(q);
 
 	spin_unlock_irq(q->queue_lock);
-	spin_lock_irq(&hwgroup->lock);
 
-	if (!ide_lock_hwgroup(hwgroup)) {
+	if (ide_lock_host(host, hwif))
+		goto plug_device_2;
+
+	spin_lock_irq(&hwif->lock);
+
+	if (!ide_lock_port(hwif)) {
+		ide_hwif_t *prev_port;
 repeat:
-		hwgroup->rq = NULL;
+		prev_port = hwif->host->cur_port;
+		hwif->rq = NULL;
 
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
 			if (time_before(drive->sleep, jiffies)) {
-				ide_unlock_hwgroup(hwgroup);
+				ide_unlock_port(hwif);
 				goto plug_device;
 			}
 		}
 
-		if (hwif != hwgroup->hwif) {
+		if ((hwif->host->host_flags & IDE_HFLAG_SERIALIZE) &&
+		    hwif != prev_port) {
 			/*
-			 * set nIEN for previous hwif, drives in the
+			 * set nIEN for previous port, drives in the
 			 * quirk_list may not like intr setups/cleanups
 			 */
-			if (drive->quirk_list == 0)
-				hwif->tp_ops->set_irq(hwif, 0);
+			if (prev_port && prev_port->cur_dev->quirk_list == 0)
+				prev_port->tp_ops->set_irq(prev_port, 0);
+
+			hwif->host->cur_port = hwif;
 		}
-		hwgroup->hwif = hwif;
-		hwgroup->drive = drive;
+		hwif->cur_dev = drive;
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 		spin_lock_irq(q->queue_lock);
 		/*
 		 * we know that the queue isn't empty, but this can happen
@@ -754,10 +762,10 @@ repeat:
 		 */
 		rq = elv_next_request(drive->queue);
 		spin_unlock_irq(q->queue_lock);
-		spin_lock_irq(&hwgroup->lock);
+		spin_lock_irq(&hwif->lock);
 
 		if (!rq) {
-			ide_unlock_hwgroup(hwgroup);
+			ide_unlock_port(hwif);
 			goto out;
 		}
 
@@ -778,27 +786,31 @@ repeat:
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
-			ide_unlock_hwgroup(hwgroup);
+			ide_unlock_port(hwif);
 			goto plug_device;
 		}
 
-		hwgroup->rq = rq;
+		hwif->rq = rq;
 
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 		startstop = start_request(drive, rq);
-		spin_lock_irq(&hwgroup->lock);
+		spin_lock_irq(&hwif->lock);
 
 		if (startstop == ide_stopped)
 			goto repeat;
 	} else
 		goto plug_device;
 out:
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
+	if (rq == NULL)
+		ide_unlock_host(host);
 	spin_lock_irq(q->queue_lock);
 	return;
 
 plug_device:
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
+	ide_unlock_host(host);
+plug_device_2:
 	spin_lock_irq(q->queue_lock);
 
 	if (!elv_queue_empty(q))
@@ -806,13 +818,13 @@ plug_device:
 }
 
 /*
- * un-busy the hwgroup etc, and clear any pending DMA status. we want to
+ * un-busy the port etc, and clear any pending DMA status. we want to
  * retry the current request in pio mode instead of risking tossing it
  * all away
  */
 static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	ide_startstop_t ret = ide_stopped;
 
@@ -840,15 +852,14 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	ide_dma_off_quietly(drive);
 
 	/*
-	 * un-busy drive etc (hwgroup->busy is cleared on return) and
-	 * make sure request is sane
+	 * un-busy drive etc and make sure request is sane
 	 */
-	rq = HWGROUP(drive)->rq;
 
+	rq = hwif->rq;
 	if (!rq)
 		goto out;
 
-	HWGROUP(drive)->rq = NULL;
+	hwif->rq = NULL;
 
 	rq->errors = 0;
 
@@ -876,7 +887,7 @@ static void ide_plug_device(ide_drive_t *drive)
 
 /**
  *	ide_timer_expiry	-	handle lack of an IDE interrupt
- *	@data: timer callback magic (hwgroup)
+ *	@data: timer callback magic (hwif)
  *
  *	An IDE command has timed out before the expected drive return
  *	occurred. At this point we attempt to clean up the current
@@ -890,18 +901,18 @@ static void ide_plug_device(ide_drive_t *drive)
  
 void ide_timer_expiry (unsigned long data)
 {
-	ide_hwgroup_t	*hwgroup = (ide_hwgroup_t *) data;
+	ide_hwif_t	*hwif = (ide_hwif_t *)data;
 	ide_drive_t	*uninitialized_var(drive);
 	ide_handler_t	*handler;
-	ide_expiry_t	*expiry;
 	unsigned long	flags;
 	unsigned long	wait = -1;
 	int		plug_device = 0;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 
-	if (((handler = hwgroup->handler) == NULL) ||
-	    (hwgroup->req_gen != hwgroup->req_gen_timer)) {
+	handler = hwif->handler;
+
+	if (handler == NULL || hwif->req_gen != hwif->req_gen_timer) {
 		/*
 		 * Either a marginal timeout occurred
 		 * (got the interrupt just as timer expired),
@@ -909,72 +920,68 @@ void ide_timer_expiry (unsigned long data)
 		 * Either way, we don't really want to complain about anything.
 		 */
 	} else {
-		drive = hwgroup->drive;
-		if (!drive) {
-			printk(KERN_ERR "ide_timer_expiry: hwgroup->drive was NULL\n");
-			hwgroup->handler = NULL;
-		} else {
-			ide_hwif_t *hwif;
-			ide_startstop_t startstop = ide_stopped;
-
-			if ((expiry = hwgroup->expiry) != NULL) {
-				/* continue */
-				if ((wait = expiry(drive)) > 0) {
-					/* reset timer */
-					hwgroup->timer.expires  = jiffies + wait;
-					hwgroup->req_gen_timer = hwgroup->req_gen;
-					add_timer(&hwgroup->timer);
-					spin_unlock_irqrestore(&hwgroup->lock, flags);
-					return;
-				}
-			}
-			hwgroup->handler = NULL;
-			/*
-			 * We need to simulate a real interrupt when invoking
-			 * the handler() function, which means we need to
-			 * globally mask the specific IRQ:
-			 */
-			spin_unlock(&hwgroup->lock);
-			hwif  = HWIF(drive);
-			/* disable_irq_nosync ?? */
-			disable_irq(hwif->irq);
-			/* local CPU only,
-			 * as if we were handling an interrupt */
-			local_irq_disable();
-			if (hwgroup->polling) {
-				startstop = handler(drive);
-			} else if (drive_is_ready(drive)) {
-				if (drive->waiting_for_dma)
-					hwif->dma_ops->dma_lost_irq(drive);
-				(void)ide_ack_intr(hwif);
-				printk(KERN_WARNING "%s: lost interrupt\n", drive->name);
-				startstop = handler(drive);
-			} else {
-				if (drive->waiting_for_dma) {
-					startstop = ide_dma_timeout_retry(drive, wait);
-				} else
-					startstop =
-					ide_error(drive, "irq timeout",
-						  hwif->tp_ops->read_status(hwif));
-			}
-			spin_lock_irq(&hwgroup->lock);
-			enable_irq(hwif->irq);
-			if (startstop == ide_stopped) {
-				ide_unlock_hwgroup(hwgroup);
-				plug_device = 1;
+		ide_expiry_t *expiry = hwif->expiry;
+		ide_startstop_t startstop = ide_stopped;
+
+		drive = hwif->cur_dev;
+
+		if (expiry) {
+			wait = expiry(drive);
+			if (wait > 0) { /* continue */
+				/* reset timer */
+				hwif->timer.expires = jiffies + wait;
+				hwif->req_gen_timer = hwif->req_gen;
+				add_timer(&hwif->timer);
+				spin_unlock_irqrestore(&hwif->lock, flags);
+				return;
 			}
 		}
+		hwif->handler = NULL;
+		/*
+		 * We need to simulate a real interrupt when invoking
+		 * the handler() function, which means we need to
+		 * globally mask the specific IRQ:
+		 */
+		spin_unlock(&hwif->lock);
+		/* disable_irq_nosync ?? */
+		disable_irq(hwif->irq);
+		/* local CPU only, as if we were handling an interrupt */
+		local_irq_disable();
+		if (hwif->polling) {
+			startstop = handler(drive);
+		} else if (drive_is_ready(drive)) {
+			if (drive->waiting_for_dma)
+				hwif->dma_ops->dma_lost_irq(drive);
+			(void)ide_ack_intr(hwif);
+			printk(KERN_WARNING "%s: lost interrupt\n",
+				drive->name);
+			startstop = handler(drive);
+		} else {
+			if (drive->waiting_for_dma)
+				startstop = ide_dma_timeout_retry(drive, wait);
+			else
+				startstop = ide_error(drive, "irq timeout",
+					hwif->tp_ops->read_status(hwif));
+		}
+		spin_lock_irq(&hwif->lock);
+		enable_irq(hwif->irq);
+		if (startstop == ide_stopped) {
+			ide_unlock_port(hwif);
+			plug_device = 1;
+		}
 	}
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 
-	if (plug_device)
+	if (plug_device) {
+		ide_unlock_host(hwif->host);
 		ide_plug_device(drive);
+	}
 }
 
 /**
  *	unexpected_intr		-	handle an unexpected IDE interrupt
  *	@irq: interrupt line
- *	@hwgroup: hwgroup being processed
+ *	@hwif: port being processed
  *
  *	There's nothing really useful we can do with an unexpected interrupt,
  *	other than reading the status register (to clear it), and logging it.
@@ -998,52 +1005,38 @@ void ide_timer_expiry (unsigned long data)
  *	before completing the issuance of any new drive command, so we will not
  *	be accidentally invoked as a result of any valid command completion
  *	interrupt.
- *
- *	Note that we must walk the entire hwgroup here. We know which hwif
- *	is doing the current command, but we don't know which hwif burped
- *	mysteriously.
  */
- 
-static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
-{
-	u8 stat;
-	ide_hwif_t *hwif = hwgroup->hwif;
 
-	/*
-	 * handle the unexpected interrupt
-	 */
-	do {
-		if (hwif->irq == irq) {
-			stat = hwif->tp_ops->read_status(hwif);
-
-			if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
-				/* Try to not flood the console with msgs */
-				static unsigned long last_msgtime, count;
-				++count;
-				if (time_after(jiffies, last_msgtime + HZ)) {
-					last_msgtime = jiffies;
-					printk(KERN_ERR "%s%s: unexpected interrupt, "
-						"status=0x%02x, count=%ld\n",
-						hwif->name,
-						(hwif->next==hwgroup->hwif) ? "" : "(?)", stat, count);
-				}
-			}
+static void unexpected_intr(int irq, ide_hwif_t *hwif)
+{
+	u8 stat = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
+		/* Try to not flood the console with msgs */
+		static unsigned long last_msgtime, count;
+		++count;
+
+		if (time_after(jiffies, last_msgtime + HZ)) {
+			last_msgtime = jiffies;
+			printk(KERN_ERR "%s: unexpected interrupt, "
+				"status=0x%02x, count=%ld\n",
+				hwif->name, stat, count);
 		}
-	} while ((hwif = hwif->next) != hwgroup->hwif);
+	}
 }
 
 /**
  *	ide_intr	-	default IDE interrupt handler
  *	@irq: interrupt number
- *	@dev_id: hwif group
+ *	@dev_id: hwif
  *	@regs: unused weirdness from the kernel irq layer
  *
  *	This is the default IRQ handler for the IDE layer. You should
  *	not need to override it. If you do be aware it is subtle in
  *	places
  *
- *	hwgroup->hwif is the interface in the group currently performing
- *	a command. hwgroup->drive is the drive and hwgroup->handler is
+ *	hwif is the interface in the group currently performing
+ *	a command. hwif->cur_dev is the drive and hwif->handler is
  *	the IRQ handler to call. As we issue a command the handlers
  *	step through multiple states, reassigning the handler to the
  *	next step in the process. Unlike a smart SCSI controller IDE
@@ -1054,26 +1047,32 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
  *
  *	The handler eventually returns ide_stopped to indicate the
  *	request completed. At this point we issue the next request
- *	on the hwgroup and the process begins again.
+ *	on the port and the process begins again.
  */
- 
+
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
-	unsigned long flags;
-	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
-	ide_hwif_t *hwif = hwgroup->hwif;
+	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
 	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
+	unsigned long flags;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
+		if (hwif != hwif->host->cur_port)
+			goto out_early;
+	}
+
+	spin_lock_irqsave(&hwif->lock, flags);
 
 	if (!ide_ack_intr(hwif))
 		goto out;
 
-	if ((handler = hwgroup->handler) == NULL || hwgroup->polling) {
+	handler = hwif->handler;
+
+	if (handler == NULL || hwif->polling) {
 		/*
 		 * Not expecting an interrupt from this drive.
 		 * That means this could be:
@@ -1097,7 +1096,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 			 * Probably not a shared PCI interrupt,
 			 * so we can safely try to do something about it:
 			 */
-			unexpected_intr(irq, hwgroup);
+			unexpected_intr(irq, hwif);
 #ifdef CONFIG_BLK_DEV_IDEPCI
 		} else {
 			/*
@@ -1110,16 +1109,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		goto out;
 	}
 
-	drive = hwgroup->drive;
-	if (!drive) {
-		/*
-		 * This should NEVER happen, and there isn't much
-		 * we could do about it here.
-		 *
-		 * [Note - this can occur if the drive is hot unplugged]
-		 */
-		goto out_handled;
-	}
+	drive = hwif->cur_dev;
 
 	if (!drive_is_ready(drive))
 		/*
@@ -1131,10 +1121,10 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 		 */
 		goto out;
 
-	hwgroup->handler = NULL;
-	hwgroup->req_gen++;
-	del_timer(&hwgroup->timer);
-	spin_unlock(&hwgroup->lock);
+	hwif->handler = NULL;
+	hwif->req_gen++;
+	del_timer(&hwif->timer);
+	spin_unlock(&hwif->lock);
 
 	if (hwif->port_ops && hwif->port_ops->clear_irq)
 		hwif->port_ops->clear_irq(drive);
@@ -1145,7 +1135,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	/*
 	 * Note that handler() may have set things up for another
 	 * interrupt to occur soon, but it cannot happen until
@@ -1154,20 +1144,18 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
 	if (startstop == ide_stopped) {
-		if (hwgroup->handler == NULL) {	/* paranoia */
-			ide_unlock_hwgroup(hwgroup);
-			plug_device = 1;
-		} else
-			printk(KERN_ERR "%s: %s: huh? expected NULL handler "
-					"on exit\n", __func__, drive->name);
+		BUG_ON(hwif->handler);
+		ide_unlock_port(hwif);
+		plug_device = 1;
 	}
-out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
-
-	if (plug_device)
+	spin_unlock_irqrestore(&hwif->lock, flags);
+out_early:
+	if (plug_device) {
+		ide_unlock_host(hwif->host);
 		ide_plug_device(drive);
+	}
 
 	return irq_ret;
 }
@@ -1189,15 +1177,13 @@ out:
 
 void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	struct request_queue *q = drive->queue;
 	unsigned long flags;
 
-	hwgroup->rq = NULL;
+	drive->hwif->rq = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
-	blk_start_queueing(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(ide_do_drive_cmd);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index ad8bd65..e728cfe 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -105,15 +105,6 @@ u8 ide_read_altstatus(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_read_altstatus);
 
-u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		return inb(hwif->dma_base + ATA_DMA_STATUS);
-}
-EXPORT_SYMBOL_GPL(ide_read_sff_dma_status);
-
 void ide_set_irq(ide_hwif_t *hwif, int on)
 {
 	u8 ctl = ATA_DEVCTL_OBS;
@@ -388,7 +379,6 @@ const struct ide_tp_ops default_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
@@ -451,7 +441,7 @@ EXPORT_SYMBOL(ide_fixstring);
  */
 int drive_is_ready (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u8 stat			= 0;
 
 	if (drive->waiting_for_dma)
@@ -503,7 +493,8 @@ static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long ti
 	stat = tp_ops->read_status(hwif);
 
 	if (stat & ATA_BUSY) {
-		local_irq_set(flags);
+		local_irq_save(flags);
+		local_irq_enable_in_hardirq();
 		timeout += jiffies;
 		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
 			if (time_after(jiffies, timeout)) {
@@ -822,25 +813,25 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 		      unsigned int timeout, ide_expiry_t *expiry)
 {
-	ide_hwgroup_t *hwgroup = HWGROUP(drive);
-
-	BUG_ON(hwgroup->handler);
-	hwgroup->handler	= handler;
-	hwgroup->expiry		= expiry;
-	hwgroup->timer.expires	= jiffies + timeout;
-	hwgroup->req_gen_timer	= hwgroup->req_gen;
-	add_timer(&hwgroup->timer);
+	ide_hwif_t *hwif = drive->hwif;
+
+	BUG_ON(hwif->handler);
+	hwif->handler		= handler;
+	hwif->expiry		= expiry;
+	hwif->timer.expires	= jiffies + timeout;
+	hwif->req_gen_timer	= hwif->req_gen;
+	add_timer(&hwif->timer);
 }
 
 void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 		      unsigned int timeout, ide_expiry_t *expiry)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 
 EXPORT_SYMBOL(ide_set_handler);
@@ -863,10 +854,9 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 			 unsigned timeout, ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
@@ -876,26 +866,25 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 	 * FIXME: we could skip this delay with care on non shared devices
 	 */
 	ndelay(400);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL(ide_execute_command);
 
 void ide_execute_pkt_cmd(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
 	ndelay(400);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
 static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 
 	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
 		ide_end_request(drive, err ? err : 1, 0);
@@ -913,7 +902,6 @@ static ide_startstop_t do_reset1 (ide_drive_t *, int);
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	u8 stat;
 
 	SELECT_DRIVE(drive);
@@ -923,20 +911,20 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk("%s: ATAPI reset complete\n", drive->name);
 	else {
-		if (time_before(jiffies, hwgroup->poll_timeout)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
 		}
 		/* end of polling */
-		hwgroup->polling = 0;
+		hwif->polling = 0;
 		printk("%s: ATAPI reset timed-out, status=0x%02x\n",
 				drive->name, stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
 	/* done polling */
-	hwgroup->polling = 0;
+	hwif->polling = 0;
 	ide_complete_drive_reset(drive, 0);
 	return ide_stopped;
 }
@@ -968,8 +956,7 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
  */
 static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 {
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
 	int err = 0;
@@ -986,7 +973,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 	tmp = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
-		if (time_before(jiffies, hwgroup->poll_timeout)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
@@ -1007,7 +994,7 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		}
 	}
 out:
-	hwgroup->polling = 0;	/* done polling */
+	hwif->polling = 0;	/* done polling */
 	ide_complete_drive_reset(drive, err);
 	return ide_stopped;
 }
@@ -1081,18 +1068,18 @@ static void pre_reset(ide_drive_t *drive)
 static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_port_ops *port_ops;
+	ide_drive_t *tdrive;
 	unsigned long flags, timeout;
-	unsigned int unit;
+	int i;
 	DEFINE_WAIT(wait);
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 
 	/* We must not reset with running handlers */
-	BUG_ON(hwgroup->handler != NULL);
+	BUG_ON(hwif->handler != NULL);
 
 	/* For an ATAPI device, first try an ATAPI SRST. */
 	if (drive->media != ide_disk && !do_not_try_atapi) {
@@ -1101,10 +1088,10 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		udelay (20);
 		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
-		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
-		hwgroup->polling = 1;
+		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+		hwif->polling = 1;
 		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		return ide_started;
 	}
 
@@ -1114,9 +1101,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
-		for (unit = 0; unit < MAX_DRIVES; unit++) {
-			ide_drive_t *tdrive = &hwif->drives[unit];
-
+		ide_port_for_each_dev(i, tdrive, hwif) {
 			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
 			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
 			    time_after(tdrive->sleep, timeout))
@@ -1127,9 +1112,9 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		if (time_before_eq(timeout, now))
 			break;
 
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		timeout = schedule_timeout_uninterruptible(timeout - now);
-		spin_lock_irqsave(&hwgroup->lock, flags);
+		spin_lock_irqsave(&hwif->lock, flags);
 	} while (timeout);
 	finish_wait(&ide_park_wq, &wait);
 
@@ -1137,11 +1122,11 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * First, reset any device state data we were maintaining
 	 * for any of the drives on this interface.
 	 */
-	for (unit = 0; unit < MAX_DRIVES; ++unit)
-		pre_reset(&hwif->drives[unit]);
+	ide_port_for_each_dev(i, tdrive, hwif)
+		pre_reset(tdrive);
 
 	if (io_ports->ctl_addr == 0) {
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
@@ -1164,8 +1149,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	tp_ops->set_irq(hwif, drive->quirk_list == 2);
 	/* more than enough time */
 	udelay(10);
-	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
-	hwgroup->polling = 1;
+	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+	hwif->polling = 1;
 	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 
 	/*
@@ -1177,7 +1162,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	if (port_ops && port_ops->resetproc)
 		port_ops->resetproc(drive);
 
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 	return ide_started;
 }
 
@@ -1221,6 +1206,3 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 	}
 	return -EBUSY;
 }
-
-EXPORT_SYMBOL_GPL(ide_wait_not_busy);
-
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 9f6e33d..09526a0 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -273,7 +273,7 @@ int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 
 static void ide_dump_opcode(ide_drive_t *drive)
 {
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 	ide_task_t *task = NULL;
 
 	if (!rq)
@@ -346,10 +346,13 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 	printk(KERN_CONT "}");
 	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
 	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
+		struct request *rq = drive->hwif->rq;
+
 		ide_dump_sector(drive);
-		if (HWGROUP(drive) && HWGROUP(drive)->rq)
+
+		if (rq)
 			printk(KERN_CONT ", sector=%llu",
-			       (unsigned long long)HWGROUP(drive)->rq->sector);
+			       (unsigned long long)rq->sector);
 	}
 	printk(KERN_CONT "\n");
 }
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 678454a..c875a95 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -7,22 +7,22 @@ DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
 
 static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	struct request_queue *q = drive->queue;
 	struct request *rq;
 	int rc;
 
 	timeout += jiffies;
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	if (drive->dev_flags & IDE_DFLAG_PARKED) {
 		int reset_timer = time_before(timeout, drive->sleep);
 		int start_queue = 0;
 
 		drive->sleep = timeout;
 		wake_up_all(&ide_park_wq);
-		if (reset_timer && del_timer(&hwgroup->timer))
+		if (reset_timer && del_timer(&hwif->timer))
 			start_queue = 1;
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 
 		if (start_queue) {
 			spin_lock_irq(q->queue_lock);
@@ -31,7 +31,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 		}
 		return;
 	}
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd[0] = REQ_PARK_HEADS;
@@ -64,21 +64,21 @@ ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long now;
 	unsigned int msecs;
 
 	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
 		return -EOPNOTSUPP;
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	now = jiffies;
 	if (drive->dev_flags & IDE_DFLAG_PARKED &&
 	    time_after(drive->sleep, now))
 		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	return snprintf(buf, 20, "%u\n", msecs);
 }
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 8282c60..4b3bf6a 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -5,7 +5,7 @@
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
 	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
@@ -39,7 +39,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 int generic_ide_resume(struct device *dev)
 {
 	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
@@ -67,7 +67,7 @@ int generic_ide_resume(struct device *dev)
 	blk_put_request(rq);
 
 	if (err == 0 && dev->driver) {
-		ide_driver_t *drv = to_ide_driver(dev->driver);
+		struct ide_driver *drv = to_ide_driver(dev->driver);
 
 		if (drv->resume)
 			drv->resume(drive);
@@ -194,7 +194,7 @@ void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	drive->hwif->hwgroup->rq = NULL;
+	drive->hwif->rq = NULL;
 
 	if (blk_end_request(rq, 0, 0))
 		BUG();
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index c5adb7b..0ccbb44 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -189,7 +189,7 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 
 static void do_identify(ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long flags;
@@ -266,7 +266,7 @@ err_misc:
 
 static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int use_altstatus = 0, rc;
@@ -341,7 +341,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
  
 static int try_to_identify (ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int retval;
 	int autoprobe = 0;
@@ -438,7 +438,7 @@ static u8 ide_read_device(ide_drive_t *drive)
 
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
 	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
@@ -463,7 +463,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	if (ide_read_device(drive) != drive->select && present == 0) {
 		if (drive->dn & 1) {
 			/* exit with drive0 selected */
-			SELECT_DRIVE(&hwif->drives[0]);
+			SELECT_DRIVE(hwif->devices[0]);
 			/* allow ATA_BUSY to assert & clear */
 			msleep(50);
 		}
@@ -509,7 +509,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	}
 	if (drive->dn & 1) {
 		/* exit with drive0 selected */
-		SELECT_DRIVE(&hwif->drives[0]);
+		SELECT_DRIVE(hwif->devices[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
 		(void)tp_ops->read_status(hwif);
@@ -522,7 +522,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
  */
 static void enable_nest (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
@@ -697,7 +697,8 @@ out:
 
 static int ide_port_wait_ready(ide_hwif_t *hwif)
 {
-	int unit, rc;
+	ide_drive_t *drive;
+	int i, rc;
 
 	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -714,9 +715,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 		return rc;
 
 	/* Now make sure both master & slave are ready */
-	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = &hwif->drives[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		/* Ignore disks that we will not probe for later. */
 		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
 		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
@@ -732,8 +731,8 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 	}
 out:
 	/* Exit function with master reselected (let's be sane) */
-	if (unit)
-		SELECT_DRIVE(&hwif->drives[0]);
+	if (i)
+		SELECT_DRIVE(hwif->devices[0]);
 
 	return rc;
 }
@@ -749,7 +748,7 @@ out:
 
 void ide_undecoded_slave(ide_drive_t *dev1)
 {
-	ide_drive_t *dev0 = &dev1->hwif->drives[0];
+	ide_drive_t *dev0 = dev1->hwif->devices[0];
 
 	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return;
@@ -778,14 +777,15 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 
 static int ide_probe_port(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	unsigned long flags;
 	unsigned int irqd;
-	int unit, rc = -ENODEV;
+	int i, rc = -ENODEV;
 
 	BUG_ON(hwif->present);
 
-	if ((hwif->drives[0].dev_flags & IDE_DFLAG_NOPROBE) &&
-	    (hwif->drives[1].dev_flags & IDE_DFLAG_NOPROBE))
+	if ((hwif->devices[0]->dev_flags & IDE_DFLAG_NOPROBE) &&
+	    (hwif->devices[1]->dev_flags & IDE_DFLAG_NOPROBE))
 		return -EACCES;
 
 	/*
@@ -796,7 +796,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	local_irq_set(flags);
+	local_irq_save(flags);
+	local_irq_enable_in_hardirq();
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
@@ -805,9 +806,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	 * Second drive should only exist if first drive was found,
 	 * but a lot of cdrom drives are configured as single slaves.
 	 */
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		(void) probe_for_drive(drive);
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
@@ -828,20 +827,17 @@ static int ide_probe_port(ide_hwif_t *hwif)
 static void ide_port_tune_devices(ide_hwif_t *hwif)
 {
 	const struct ide_port_ops *port_ops = hwif->port_ops;
-	int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = &hwif->drives[unit];
+	ide_drive_t *drive;
+	int i;
 
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			if (port_ops && port_ops->quirkproc)
 				port_ops->quirkproc(drive);
 		}
 	}
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			ide_set_max_pio(drive);
 
@@ -852,11 +848,8 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 		}
 	}
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
-
-		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
-		    drive->id[ATA_ID_DWORD_IO])
+	ide_port_for_each_dev(i, drive, hwif) {
+		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
 			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		else
 			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
@@ -869,7 +862,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 static int ide_init_queue(ide_drive_t *drive)
 {
 	struct request_queue *q;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	int max_sectors = 256;
 	int max_sg_entries = PRD_ENTRIES;
 
@@ -918,36 +911,19 @@ static int ide_init_queue(ide_drive_t *drive)
 	return 0;
 }
 
-static void ide_add_drive_to_hwgroup(ide_drive_t *drive)
-{
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-
-	spin_lock_irq(&hwgroup->lock);
-	if (!hwgroup->drive) {
-		/* first drive for hwgroup. */
-		drive->next = drive;
-		hwgroup->drive = drive;
-		hwgroup->hwif = HWIF(hwgroup->drive);
-	} else {
-		drive->next = hwgroup->drive->next;
-		hwgroup->drive->next = drive;
-	}
-	spin_unlock_irq(&hwgroup->lock);
-}
+static DEFINE_MUTEX(ide_cfg_mtx);
 
 /*
  * For any present drive:
  * - allocate the block device queue
- * - link drive into the hwgroup
  */
 static int ide_port_setup_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
@@ -961,139 +937,39 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 		}
 
 		j++;
-
-		ide_add_drive_to_hwgroup(drive);
 	}
 	mutex_unlock(&ide_cfg_mtx);
 
 	return j;
 }
 
-static ide_hwif_t *ide_ports[MAX_HWIFS];
-
-void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
-{
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-
-	ide_ports[hwif->index] = NULL;
-
-	spin_lock_irq(&hwgroup->lock);
-	/*
-	 * Remove us from the hwgroup, and free
-	 * the hwgroup if we were the only member
-	 */
-	if (hwif->next == hwif) {
-		BUG_ON(hwgroup->hwif != hwif);
-		kfree(hwgroup);
-	} else {
-		/* There is another interface in hwgroup.
-		 * Unlink us, and set hwgroup->drive and ->hwif to
-		 * something sane.
-		 */
-		ide_hwif_t *g = hwgroup->hwif;
-
-		while (g->next != hwif)
-			g = g->next;
-		g->next = hwif->next;
-		if (hwgroup->hwif == hwif) {
-			/* Chose a random hwif for hwgroup->hwif.
-			 * It's guaranteed that there are no drives
-			 * left in the hwgroup.
-			 */
-			BUG_ON(hwgroup->drive != NULL);
-			hwgroup->hwif = g;
-		}
-		BUG_ON(hwgroup->hwif == hwif);
-	}
-	spin_unlock_irq(&hwgroup->lock);
-}
-
 /*
- * This routine sets up the irq for an ide interface, and creates a new
- * hwgroup for the irq/hwif if none was previously assigned.
- *
- * Much of the code is for correctly detecting/handling irq sharing
- * and irq serialization situations.  This is somewhat complex because
- * it handles static as well as dynamic (PCMCIA) IDE interfaces.
+ * This routine sets up the IRQ for an IDE interface.
  */
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned int index;
-	ide_hwgroup_t *hwgroup;
-	ide_hwif_t *match = NULL;
+	int sa = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	hwif->hwgroup = NULL;
+	spin_lock_init(&hwif->lock);
 
-	for (index = 0; index < MAX_HWIFS; index++) {
-		ide_hwif_t *h = ide_ports[index];
+	init_timer(&hwif->timer);
+	hwif->timer.function = &ide_timer_expiry;
+	hwif->timer.data = (unsigned long)hwif;
 
-		if (h && h->hwgroup) {  /* scan only initialized ports */
-			if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
-				if (hwif->host == h->host)
-					match = h;
-			}
-		}
-	}
-
-	/*
-	 * If we are still without a hwgroup, then form a new one
-	 */
-	if (match) {
-		hwgroup = match->hwgroup;
-		hwif->hwgroup = hwgroup;
-		/*
-		 * Link us into the hwgroup.
-		 * This must be done early, do ensure that unexpected_intr
-		 * can find the hwif and prevent irq storms.
-		 * No drives are attached to the new hwif, choose_drive
-		 * can't do anything stupid (yet).
-		 * Add ourself as the 2nd entry to the hwgroup->hwif
-		 * linked list, the first entry is the hwif that owns
-		 * hwgroup->handler - do not change that.
-		 */
-		spin_lock_irq(&hwgroup->lock);
-		hwif->next = hwgroup->hwif->next;
-		hwgroup->hwif->next = hwif;
-		BUG_ON(hwif->next == hwif);
-		spin_unlock_irq(&hwgroup->lock);
-	} else {
-		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
-				       hwif_to_node(hwif));
-		if (hwgroup == NULL)
-			goto out_up;
-
-		spin_lock_init(&hwgroup->lock);
-
-		hwif->hwgroup = hwgroup;
-		hwgroup->hwif = hwif->next = hwif;
-
-		init_timer(&hwgroup->timer);
-		hwgroup->timer.function = &ide_timer_expiry;
-		hwgroup->timer.data = (unsigned long) hwgroup;
-	}
-
-	ide_ports[hwif->index] = hwif;
-
-	/*
-	 * Allocate the irq, if not already obtained for another hwif
-	 */
-	if (!match || match->irq != hwif->irq) {
-		int sa = 0;
 #if defined(__mc68000__)
-		sa = IRQF_SHARED;
+	sa = IRQF_SHARED;
 #endif /* __mc68000__ */
 
-		if (hwif->chipset == ide_pci)
-			sa = IRQF_SHARED;
+	if (hwif->chipset == ide_pci)
+		sa = IRQF_SHARED;
 
-		if (io_ports->ctl_addr)
-			hwif->tp_ops->set_irq(hwif, 1);
+	if (io_ports->ctl_addr)
+		hwif->tp_ops->set_irq(hwif, 1);
 
-		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
-	       		goto out_unlink;
-	}
+	if (request_irq(hwif->irq, &ide_intr, sa, hwif->name, hwif))
+		goto out_up;
 
 	if (!hwif->rqsize) {
 		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
@@ -1111,14 +987,12 @@ static int init_irq (ide_hwif_t *hwif)
 	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
-	if (match)
-		printk(KERN_CONT " (serialized with %s)", match->name);
+	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
+		printk(KERN_CONT " (serialized)");
 	printk(KERN_CONT "\n");
 
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
-out_unlink:
-	ide_remove_port_from_hwgroup(hwif);
 out_up:
 	mutex_unlock(&ide_cfg_mtx);
 	return 1;
@@ -1134,7 +1008,7 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 {
 	ide_hwif_t *hwif = data;
 	int unit = *part >> PARTN_BITS;
-	ide_drive_t *drive = &hwif->drives[unit];
+	ide_drive_t *drive = hwif->devices[unit];
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return NULL;
@@ -1196,47 +1070,23 @@ void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_init_disk);
 
-static void ide_remove_drive_from_hwgroup(ide_drive_t *drive)
-{
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-
-	if (drive == drive->next) {
-		/* special case: last drive from hwgroup. */
-		BUG_ON(hwgroup->drive != drive);
-		hwgroup->drive = NULL;
-	} else {
-		ide_drive_t *walk;
-
-		walk = hwgroup->drive;
-		while (walk->next != drive)
-			walk = walk->next;
-		walk->next = drive->next;
-		if (hwgroup->drive == drive) {
-			hwgroup->drive = drive->next;
-			hwgroup->hwif = hwgroup->drive->hwif;
-		}
-	}
-	BUG_ON(hwgroup->drive == drive);
-}
-
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 
 	ide_proc_unregister_device(drive);
 
-	spin_lock_irq(&hwgroup->lock);
-	ide_remove_drive_from_hwgroup(drive);
+	spin_lock_irq(&hwif->lock);
 	kfree(drive->id);
 	drive->id = NULL;
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	/* Messed up locking ... */
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 	blk_cleanup_queue(drive->queue);
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	drive->queue = NULL;
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	complete(&drive->gendev_rel_comp);
 }
@@ -1302,10 +1152,10 @@ out:
 
 static void hwif_register_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	unsigned int i;
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
+	ide_port_for_each_dev(i, drive, hwif) {
 		struct device *dev = &drive->gendev;
 		int ret;
 
@@ -1328,11 +1178,10 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 static void ide_port_init_devices(ide_hwif_t *hwif)
 {
 	const struct ide_port_ops *port_ops = hwif->port_ops;
+	ide_drive_t *drive;
 	int i;
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		drive->dn = i + hwif->channel * 2;
 
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
@@ -1380,6 +1229,8 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0) {
 		int rc;
 
+		hwif->dma_ops = d->dma_ops;
+
 		if (d->init_dma)
 			rc = d->init_dma(hwif, d);
 		else
@@ -1387,12 +1238,13 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 
 		if (rc < 0) {
 			printk(KERN_INFO "%s: DMA disabled\n", hwif->name);
+
+			hwif->dma_ops = NULL;
 			hwif->dma_base = 0;
 			hwif->swdma_mask = 0;
 			hwif->mwdma_mask = 0;
 			hwif->ultra_mask = 0;
-		} else if (d->dma_ops)
-			hwif->dma_ops = d->dma_ops;
+		}
 	}
 
 	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
@@ -1417,6 +1269,66 @@ static void ide_port_cable_detect(ide_hwif_t *hwif)
 	}
 }
 
+static const u8 ide_hwif_to_major[] =
+	{ IDE0_MAJOR, IDE1_MAJOR, IDE2_MAJOR, IDE3_MAJOR, IDE4_MAJOR,
+	  IDE5_MAJOR, IDE6_MAJOR, IDE7_MAJOR, IDE8_MAJOR, IDE9_MAJOR };
+
+static void ide_port_init_devices_data(ide_hwif_t *hwif)
+{
+	ide_drive_t *drive;
+	int i;
+
+	ide_port_for_each_dev(i, drive, hwif) {
+		u8 j = (hwif->index * MAX_DRIVES) + i;
+
+		memset(drive, 0, sizeof(*drive));
+
+		drive->media			= ide_disk;
+		drive->select			= (i << 4) | ATA_DEVICE_OBS;
+		drive->hwif			= hwif;
+		drive->ready_stat		= ATA_DRDY;
+		drive->bad_wstat		= BAD_W_STAT;
+		drive->special.b.recalibrate	= 1;
+		drive->special.b.set_geometry	= 1;
+		drive->name[0]			= 'h';
+		drive->name[1]			= 'd';
+		drive->name[2]			= 'a' + j;
+		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
+
+		INIT_LIST_HEAD(&drive->list);
+		init_completion(&drive->gendev_rel_comp);
+	}
+}
+
+static void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
+{
+	/* fill in any non-zero initial values */
+	hwif->index	= index;
+	hwif->major	= ide_hwif_to_major[index];
+
+	hwif->name[0]	= 'i';
+	hwif->name[1]	= 'd';
+	hwif->name[2]	= 'e';
+	hwif->name[3]	= '0' + index;
+
+	init_completion(&hwif->gendev_rel_comp);
+
+	hwif->tp_ops = &default_tp_ops;
+
+	ide_port_init_devices_data(hwif);
+}
+
+static void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
+{
+	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
+	hwif->irq = hw->irq;
+	hwif->chipset = hw->chipset;
+	hwif->dev = hw->dev;
+	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
+	hwif->ack_intr = hw->ack_intr;
+	hwif->config_data = hw->config;
+}
+
 static unsigned int ide_indexes;
 
 /**
@@ -1466,12 +1378,43 @@ static void ide_free_port_slot(int idx)
 	mutex_unlock(&ide_cfg_mtx);
 }
 
+static void ide_port_free_devices(ide_hwif_t *hwif)
+{
+	ide_drive_t *drive;
+	int i;
+
+	ide_port_for_each_dev(i, drive, hwif)
+		kfree(drive);
+}
+
+static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive;
+
+		drive = kzalloc_node(sizeof(*drive), GFP_KERNEL, node);
+		if (drive == NULL)
+			goto out_nomem;
+
+		hwif->devices[i] = drive;
+	}
+	return 0;
+
+out_nomem:
+	ide_port_free_devices(hwif);
+	return -ENOMEM;
+}
+
 struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 {
 	struct ide_host *host;
+	struct device *dev = hws[0] ? hws[0]->dev : NULL;
+	int node = dev ? dev_to_node(dev) : -1;
 	int i;
 
-	host = kzalloc(sizeof(*host), GFP_KERNEL);
+	host = kzalloc_node(sizeof(*host), GFP_KERNEL, node);
 	if (host == NULL)
 		return NULL;
 
@@ -1482,10 +1425,15 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 		if (hws[i] == NULL)
 			continue;
 
-		hwif = kzalloc(sizeof(*hwif), GFP_KERNEL);
+		hwif = kzalloc_node(sizeof(*hwif), GFP_KERNEL, node);
 		if (hwif == NULL)
 			continue;
 
+		if (ide_port_alloc_devices(hwif, node) < 0) {
+			kfree(hwif);
+			continue;
+		}
+
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
 			printk(KERN_ERR "%s: no free slot for interface\n",
@@ -1507,8 +1455,7 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 		return NULL;
 	}
 
-	if (hws[0])
-		host->dev[0] = hws[0]->dev;
+	host->dev[0] = dev;
 
 	if (d) {
 		host->init_chipset = d->init_chipset;
@@ -1525,9 +1472,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL) {
 			mate = NULL;
 			continue;
@@ -1553,9 +1498,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		ide_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1570,9 +1513,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			ide_port_tune_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1597,9 +1538,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			ide_acpi_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1607,9 +1546,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			hwif_register_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1647,17 +1584,85 @@ int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
 }
 EXPORT_SYMBOL_GPL(ide_host_add);
 
+static void __ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	ide_drive_t *drive;
+	int i;
+
+	ide_port_for_each_dev(i, drive, hwif) {
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+			device_unregister(&drive->gendev);
+			wait_for_completion(&drive->gendev_rel_comp);
+		}
+	}
+}
+
+void ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	mutex_lock(&ide_cfg_mtx);
+	__ide_port_unregister_devices(hwif);
+	hwif->present = 0;
+	ide_port_init_devices_data(hwif);
+	mutex_unlock(&ide_cfg_mtx);
+}
+EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
+
+/**
+ *	ide_unregister		-	free an IDE interface
+ *	@hwif: IDE interface
+ *
+ *	Perform the final unregister of an IDE interface.
+ *
+ *	Locking:
+ *	The caller must not hold the IDE locks.
+ *
+ *	It is up to the caller to be sure there is no pending I/O here,
+ *	and that the interface will not be reopened (present/vanishing
+ *	locking isn't yet done BTW).
+ */
+
+static void ide_unregister(ide_hwif_t *hwif)
+{
+	BUG_ON(in_interrupt());
+	BUG_ON(irqs_disabled());
+
+	mutex_lock(&ide_cfg_mtx);
+
+	if (hwif->present) {
+		__ide_port_unregister_devices(hwif);
+		hwif->present = 0;
+	}
+
+	ide_proc_unregister_port(hwif);
+
+	free_irq(hwif->irq, hwif);
+
+	device_unregister(hwif->portdev);
+	device_unregister(&hwif->gendev);
+	wait_for_completion(&hwif->gendev_rel_comp);
+
+	/*
+	 * Remove us from the kernel's knowledge
+	 */
+	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
+	kfree(hwif->sg_table);
+	unregister_blkdev(hwif->major, hwif->name);
+
+	ide_release_dma_engine(hwif);
+
+	mutex_unlock(&ide_cfg_mtx);
+}
+
 void ide_host_free(struct ide_host *host)
 {
 	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
+		ide_port_free_devices(hwif);
 		ide_free_port_slot(hwif->index);
 		kfree(hwif);
 	}
@@ -1668,11 +1673,12 @@ EXPORT_SYMBOL_GPL(ide_host_free);
 
 void ide_host_remove(struct ide_host *host)
 {
+	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		if (host->ports[i])
-			ide_unregister(host->ports[i]);
+	ide_host_for_each_port(i, hwif, host) {
+		if (hwif)
+			ide_unregister(hwif);
 	}
 
 	ide_host_free(host);
@@ -1691,8 +1697,8 @@ void ide_port_scan(ide_hwif_t *hwif)
 	hwif->present = 1;
 
 	ide_port_tune_devices(hwif);
-	ide_acpi_port_init_devices(hwif);
 	ide_port_setup_devices(hwif);
+	ide_acpi_port_init_devices(hwif);
 	hwif_register_devices(hwif);
 	ide_proc_port_register_devices(hwif);
 }
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index a14e293..1d8978b 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -439,13 +439,13 @@ static int proc_ide_read_dmodel
 static int proc_ide_read_driver
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	ide_drive_t	*drive = (ide_drive_t *) data;
-	struct device	*dev = &drive->gendev;
-	ide_driver_t	*ide_drv;
-	int		len;
+	ide_drive_t		*drive = (ide_drive_t *)data;
+	struct device		*dev = &drive->gendev;
+	struct ide_driver	*ide_drv;
+	int			len;
 
 	if (dev->driver) {
-		ide_drv = container_of(dev->driver, ide_driver_t, gen_driver);
+		ide_drv = to_ide_driver(dev->driver);
 		len = sprintf(page, "%s version %s\n",
 				dev->driver->name, ide_drv->version);
 	} else
@@ -555,7 +555,7 @@ static void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t
 	}
 }
 
-void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
+void ide_proc_register_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
 	mutex_lock(&ide_setting_mtx);
 	drive->settings = driver->proc_devsets(drive);
@@ -577,7 +577,7 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	Takes ide_setting_mtx.
  */
 
-void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
+void ide_proc_unregister_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
 	ide_remove_proc_entries(drive->proc, driver->proc_entries(drive));
 
@@ -593,14 +593,13 @@ EXPORT_SYMBOL(ide_proc_unregister_driver);
 
 void ide_proc_port_register_devices(ide_hwif_t *hwif)
 {
-	int	d;
 	struct proc_dir_entry *ent;
 	struct proc_dir_entry *parent = hwif->proc;
+	ide_drive_t *drive;
 	char name[64];
+	int i;
 
-	for (d = 0; d < MAX_DRIVES; d++) {
-		ide_drive_t *drive = &hwif->drives[d];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
 			continue;
 
@@ -653,7 +652,7 @@ void ide_proc_unregister_port(ide_hwif_t *hwif)
 
 static int proc_print_driver(struct device_driver *drv, void *data)
 {
-	ide_driver_t *ide_drv = container_of(drv, ide_driver_t, gen_driver);
+	struct ide_driver *ide_drv = to_ide_driver(drv);
 	struct seq_file *s = data;
 
 	seq_printf(s, "%s version %s\n", drv->name, ide_drv->version);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5d2aa22..d7ecd3c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -166,10 +166,10 @@ struct idetape_bh {
  * to an interrupt or a timer event is stored in the struct defined below.
  */
 typedef struct ide_tape_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
+	ide_drive_t		*drive;
+	struct ide_driver	*driver;
+	struct gendisk		*disk;
+	struct kref		kref;
 
 	/*
 	 *	failed_pc points to the last failed packet command, or contains
@@ -479,7 +479,7 @@ static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	int error;
@@ -531,7 +531,7 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		struct request *rq = drive->hwif->hwgroup->rq;
+		struct request *rq = drive->hwif->rq;
 		int blocks = pc->xferred / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
@@ -576,7 +576,7 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 
 /*
  * Postpone the current request so that ide.c will be able to service requests
- * from another device on the same hwgroup while we are polling for DSC.
+ * from another device on the same port while we are polling for DSC.
  */
 static void idetape_postpone_request(ide_drive_t *drive)
 {
@@ -584,7 +584,8 @@ static void idetape_postpone_request(ide_drive_t *drive)
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	tape->postponed_rq = HWGROUP(drive)->rq;
+	tape->postponed_rq = drive->hwif->rq;
+
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
@@ -2312,7 +2313,7 @@ static const struct ide_proc_devset *ide_tape_proc_devsets(ide_drive_t *drive)
 
 static int ide_tape_probe(ide_drive_t *);
 
-static ide_driver_t idetape_driver = {
+static struct ide_driver idetape_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
 		.name		= "ide-tape",
@@ -2323,7 +2324,6 @@ static ide_driver_t idetape_driver = {
 	.version		= IDETAPE_VERSION,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_tape_proc_entries,
 	.proc_devsets		= ide_tape_proc_devsets,
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index bf4fb9d..16138bc 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -58,7 +58,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *);
 
 ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
@@ -309,9 +309,9 @@ static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 		}
 
 		if (sectors > 0) {
-			ide_driver_t *drv;
+			struct ide_driver *drv;
 
-			drv = *(ide_driver_t **)rq->rq_disk->private_data;
+			drv = *(struct ide_driver **)rq->rq_disk->private_data;
 			drv->end_request(drive, 1, sectors);
 		}
 	}
@@ -328,9 +328,9 @@ void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 	}
 
 	if (rq->rq_disk) {
-		ide_driver_t *drv;
+		struct ide_driver *drv;
 
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;;
+		drv = *(struct ide_driver **)rq->rq_disk->private_data;;
 		drv->end_request(drive, 1, rq->nr_sectors);
 	} else
 		ide_end_request(drive, 1, rq->nr_sectors);
@@ -361,7 +361,7 @@ static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
@@ -395,7 +395,7 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 static ide_startstop_t task_out_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 46a2d4c..258805d 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -60,179 +60,8 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 
-
-/* default maximum number of failures */
-#define IDE_DEFAULT_MAX_FAILURES 	1
-
 struct class *ide_port_class;
 
-static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
-					IDE2_MAJOR, IDE3_MAJOR,
-					IDE4_MAJOR, IDE5_MAJOR,
-					IDE6_MAJOR, IDE7_MAJOR,
-					IDE8_MAJOR, IDE9_MAJOR };
-
-DEFINE_MUTEX(ide_cfg_mtx);
-
-static void ide_port_init_devices_data(ide_hwif_t *);
-
-/*
- * Do not even *think* about calling this!
- */
-void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
-{
-	/* bulk initialize hwif & drive info with zeros */
-	memset(hwif, 0, sizeof(ide_hwif_t));
-
-	/* fill in any non-zero initial values */
-	hwif->index	= index;
-	hwif->major	= ide_hwif_to_major[index];
-
-	hwif->name[0]	= 'i';
-	hwif->name[1]	= 'd';
-	hwif->name[2]	= 'e';
-	hwif->name[3]	= '0' + index;
-
-	init_completion(&hwif->gendev_rel_comp);
-
-	hwif->tp_ops = &default_tp_ops;
-
-	ide_port_init_devices_data(hwif);
-}
-
-static void ide_port_init_devices_data(ide_hwif_t *hwif)
-{
-	int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
-		u8 j = (hwif->index * MAX_DRIVES) + unit;
-
-		memset(drive, 0, sizeof(*drive));
-
-		drive->media			= ide_disk;
-		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
-		drive->hwif			= hwif;
-		drive->ready_stat		= ATA_DRDY;
-		drive->bad_wstat		= BAD_W_STAT;
-		drive->special.b.recalibrate	= 1;
-		drive->special.b.set_geometry	= 1;
-		drive->name[0]			= 'h';
-		drive->name[1]			= 'd';
-		drive->name[2]			= 'a' + j;
-		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
-
-		INIT_LIST_HEAD(&drive->list);
-		init_completion(&drive->gendev_rel_comp);
-	}
-}
-
-static void __ide_port_unregister_devices(ide_hwif_t *hwif)
-{
-	int i;
-
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
-
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			device_unregister(&drive->gendev);
-			wait_for_completion(&drive->gendev_rel_comp);
-		}
-	}
-}
-
-void ide_port_unregister_devices(ide_hwif_t *hwif)
-{
-	mutex_lock(&ide_cfg_mtx);
-	__ide_port_unregister_devices(hwif);
-	hwif->present = 0;
-	ide_port_init_devices_data(hwif);
-	mutex_unlock(&ide_cfg_mtx);
-}
-EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
-
-/**
- *	ide_unregister		-	free an IDE interface
- *	@hwif: IDE interface
- *
- *	Perform the final unregister of an IDE interface. At the moment
- *	we don't refcount interfaces so this will also get split up.
- *
- *	Locking:
- *	The caller must not hold the IDE locks
- *	The drive present/vanishing is not yet properly locked
- *	Take care with the callbacks. These have been split to avoid
- *	deadlocking the IDE layer. The shutdown callback is called
- *	before we take the lock and free resources. It is up to the
- *	caller to be sure there is no pending I/O here, and that
- *	the interface will not be reopened (present/vanishing locking
- *	isn't yet done BTW). After we commit to the final kill we
- *	call the cleanup callback with the ide locks held.
- *
- *	Unregister restores the hwif structures to the default state.
- *	This is raving bonkers.
- */
-
-void ide_unregister(ide_hwif_t *hwif)
-{
-	ide_hwif_t *g;
-	ide_hwgroup_t *hwgroup;
-	int irq_count = 0;
-
-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());
-
-	mutex_lock(&ide_cfg_mtx);
-
-	if (hwif->present) {
-		__ide_port_unregister_devices(hwif);
-		hwif->present = 0;
-	}
-
-	ide_proc_unregister_port(hwif);
-
-	hwgroup = hwif->hwgroup;
-	/*
-	 * free the irq if we were the only hwif using it
-	 */
-	g = hwgroup->hwif;
-	do {
-		if (g->irq == hwif->irq)
-			++irq_count;
-		g = g->next;
-	} while (g != hwgroup->hwif);
-	if (irq_count == 1)
-		free_irq(hwif->irq, hwgroup);
-
-	ide_remove_port_from_hwgroup(hwif);
-
-	device_unregister(hwif->portdev);
-	device_unregister(&hwif->gendev);
-	wait_for_completion(&hwif->gendev_rel_comp);
-
-	/*
-	 * Remove us from the kernel's knowledge
-	 */
-	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
-	kfree(hwif->sg_table);
-	unregister_blkdev(hwif->major, hwif->name);
-
-	ide_release_dma_engine(hwif);
-
-	mutex_unlock(&ide_cfg_mtx);
-}
-
-void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
-{
-	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
-	hwif->irq = hw->irq;
-	hwif->chipset = hw->chipset;
-	hwif->dev = hw->dev;
-	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
-	hwif->ack_intr = hw->ack_intr;
-	hwif->config_data = hw->config;
-}
-
 /*
  *	Locks for IDE setting functionality
  */
@@ -330,7 +159,6 @@ static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
 static int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (arg < 0 || arg > 255)
@@ -345,9 +173,9 @@ static int set_pio_mode(ide_drive_t *drive, int arg)
 			unsigned long flags;
 
 			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
-			spin_lock_irqsave(&hwgroup->lock, flags);
+			spin_lock_irqsave(&hwif->lock, flags);
 			port_ops->set_pio_mode(drive, arg);
-			spin_unlock_irqrestore(&hwgroup->lock, flags);
+			spin_unlock_irqrestore(&hwif->lock, flags);
 		} else
 			port_ops->set_pio_mode(drive, arg);
 	} else {
@@ -453,7 +281,7 @@ static int ide_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int generic_ide_probe(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	return drv->probe ? drv->probe(drive) : -ENODEV;
 }
@@ -461,7 +289,7 @@ static int generic_ide_probe(struct device *dev)
 static int generic_ide_remove(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	if (drv->remove)
 		drv->remove(drive);
@@ -472,7 +300,7 @@ static int generic_ide_remove(struct device *dev)
 static void generic_ide_shutdown(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
+	struct ide_driver *drv = to_ide_driver(dev->driver);
 
 	if (dev->driver && drv->shutdown)
 		drv->shutdown(drive);
@@ -660,6 +488,7 @@ MODULE_PARM_DESC(ignore_cable, "ignore cable detection");
 
 void ide_port_apply_params(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i;
 
 	if (ide_ignore_cable & (1 << hwif->index)) {
@@ -668,8 +497,8 @@ void ide_port_apply_params(ide_hwif_t *hwif)
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
 
-	for (i = 0; i < MAX_DRIVES; i++)
-		ide_dev_apply_params(&hwif->drives[i], i);
+	ide_port_for_each_dev(i, drive, hwif)
+		ide_dev_apply_params(drive, i);
 }
 
 /*
diff --git a/drivers/ide/it8172.c b/drivers/ide/it8172.c
new file mode 100644
index 0000000..e021078
--- /dev/null
+++ b/drivers/ide/it8172.c
@@ -0,0 +1,166 @@
+/*
+ *
+ * BRIEF MODULE DESCRIPTION
+ *      IT8172 IDE controller support
+ *
+ * Copyright (C) 2000 MontaVista Software Inc.
+ * Copyright (C) 2008 Shane McDonald
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#define DRV_NAME "IT8172"
+
+static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	ide_hwif_t *hwif	= drive->hwif;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	u16 drive_enables;
+	u32 drive_timing;
+
+	/*
+	 * The highest value of DIOR/DIOW pulse width and recovery time
+	 * that can be set in the IT8172 is 8 PCI clock cycles.  As a result,
+	 * it cannot be configured for PIO mode 0.  This table sets these
+	 * parameters to the maximum supported by the IT8172.
+	 */
+	static const u8 timings[] = { 0x3f, 0x3c, 0x1b, 0x12, 0x0a };
+
+	pci_read_config_word(dev, 0x40, &drive_enables);
+	pci_read_config_dword(dev, 0x44, &drive_timing);
+
+	/*
+	 * Enable port 0x44. The IT8172 spec is confused; it calls
+	 * this register the "Slave IDE Timing Register", but in fact,
+	 * it controls timing for both master and slave drives.
+	 */
+	drive_enables |= 0x4000;
+
+	drive_enables &= drive->dn ? 0xc006 : 0xc060;
+	if (drive->media == ide_disk)
+		/* enable prefetch */
+		drive_enables |= 0x0004 << (drive->dn * 4);
+	if (ata_id_has_iordy(drive->id))
+		/* enable IORDY sample-point */
+		drive_enables |= 0x0002 << (drive->dn * 4);
+
+	drive_timing &= drive->dn ? 0x00003f00 : 0x000fc000;
+	drive_timing |= timings[pio] << (drive->dn * 6 + 8);
+
+	pci_write_config_word(dev, 0x40, drive_enables);
+	pci_write_config_dword(dev, 0x44, drive_timing);
+}
+
+static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
+{
+	ide_hwif_t *hwif	= drive->hwif;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	int a_speed		= 3 << (drive->dn * 4);
+	int u_flag		= 1 << drive->dn;
+	int u_speed		= 0;
+	u8 reg48, reg4a;
+
+	pci_read_config_byte(dev, 0x48, &reg48);
+	pci_read_config_byte(dev, 0x4a, &reg4a);
+
+	if (speed >= XFER_UDMA_0) {
+		u8 udma = speed - XFER_UDMA_0;
+		u_speed = udma << (drive->dn * 4);
+
+		pci_write_config_byte(dev, 0x48, reg48 | u_flag);
+		reg4a &= ~a_speed;
+		pci_write_config_byte(dev, 0x4a, reg4a | u_speed);
+	} else {
+		const u8 mwdma_to_pio[] = { 0, 3, 4 };
+		u8 pio;
+
+		pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
+		pci_write_config_byte(dev, 0x4a, reg4a & ~a_speed);
+
+		pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
+
+		it8172_set_pio_mode(drive, pio);
+	}
+}
+
+
+static const struct ide_port_ops it8172_port_ops = {
+	.set_pio_mode	= it8172_set_pio_mode,
+	.set_dma_mode	= it8172_set_dma_mode,
+};
+
+static const struct ide_port_info it8172_port_info __devinitdata = {
+	.name		= DRV_NAME,
+	.port_ops	= &it8172_port_ops,
+	.enablebits	= { {0x41, 0x80, 0x80}, {0x00, 0x00, 0x00} },
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4 & ~ATA_PIO0,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA2,
+};
+
+static int __devinit it8172_init_one(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
+		return -ENODEV; /* IT8172 is more than an IDE controller */
+	return ide_pci_init_one(dev, &it8172_port_info, NULL);
+}
+
+static struct pci_device_id it8172_pci_tbl[] = {
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8172), 0 },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, it8172_pci_tbl);
+
+static struct pci_driver it8172_pci_driver = {
+	.name		= "IT8172_IDE",
+	.id_table	= it8172_pci_tbl,
+	.probe		= it8172_init_one,
+	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+};
+
+static int __init it8172_ide_init(void)
+{
+	return ide_pci_register_driver(&it8172_pci_driver);
+}
+
+static void __exit it8172_ide_exit(void)
+{
+	pci_unregister_driver(&it8172_pci_driver);
+}
+
+module_init(it8172_ide_init);
+module_exit(it8172_ide_exit);
+
+MODULE_AUTHOR("Steve Longerbeam");
+MODULE_DESCRIPTION("PCI driver module for ITE 8172 IDE");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/it8213.c b/drivers/ide/it8213.c
index 7c2feeb..d7969b6 100644
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -25,7 +25,7 @@
 
 static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= 0x40;
@@ -82,7 +82,7 @@ static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index ef00408..0be27ac 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -167,12 +167,10 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair;
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int clock, altclock, sel = 0;
 	u8 unit = drive->dn & 1, v;
 
-	pair = &hwif->drives[1 - unit];
-
 	if(itdev->want[0][0] > itdev->want[1][0]) {
 		clock = itdev->want[0][1];
 		altclock = itdev->want[1][1];
@@ -239,15 +237,13 @@ static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair;
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	u8 unit = drive->dn & 1, set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
 	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
-	pair = &hwif->drives[1 - unit];
-
 	/*
 	 * Compute the best PIO mode we can for a given device. We must
 	 * pick a speed that does not cause problems with the other device
@@ -279,7 +275,7 @@ static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
  *	the shared MWDMA/PIO timing register.
  */
 
-static void it821x_tune_mwdma (ide_drive_t *drive, byte mode_wanted)
+static void it821x_tune_mwdma(ide_drive_t *drive, u8 mode_wanted)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -316,7 +312,7 @@ static void it821x_tune_mwdma (ide_drive_t *drive, byte mode_wanted)
  *	controller when doing UDMA modes in pass through.
  */
 
-static void it821x_tune_udma (ide_drive_t *drive, byte mode_wanted)
+static void it821x_tune_udma(ide_drive_t *drive, u8 mode_wanted)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -516,6 +512,7 @@ static struct ide_dma_ops it821x_pass_through_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 /**
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 1378906..83643ed 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -56,7 +56,7 @@ static u8 superio_read_status(ide_hwif_t *hwif)
 	return superio_ide_inb(hwif->io_ports.status_addr);
 }
 
-static u8 superio_read_sff_dma_status(ide_hwif_t *hwif)
+static u8 superio_dma_sff_read_status(ide_hwif_t *hwif)
 {
 	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
@@ -109,7 +109,6 @@ static const struct ide_tp_ops superio_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= superio_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= superio_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
@@ -132,18 +131,20 @@ static void __devinit superio_init_iops(struct hwif_s *hwif)
 	tmp = superio_ide_inb(dma_stat);
 	outb(tmp | 0x66, dma_stat);
 }
+#else
+#define superio_dma_sff_read_status ide_dma_sff_read_status
 #endif
 
 static unsigned int ns87415_count = 0, ns87415_control[MAX_HWIFS] = { 0 };
 
 /*
  * This routine either enables/disables (according to IDE_DFLAG_PRESENT)
- * the IRQ associated with the port (HWIF(drive)),
+ * the IRQ associated with the port,
  * and selects either PIO or DMA handshaking for the next I/O operation.
  */
 static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned int bit, other, new, *old = (unsigned int *) hwif->select_data;
 	unsigned long flags;
@@ -197,11 +198,11 @@ static void ns87415_selectproc (ide_drive_t *drive)
 
 static int ns87415_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t      *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
@@ -308,6 +309,7 @@ static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index 122ed3c..a7ac490 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -324,8 +324,6 @@ static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
 
 	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
 
-	hwif->dma_ops = &sff_dma_ops;
-
 	return 0;
 }
 
@@ -338,6 +336,7 @@ static const struct ide_port_ops palm_bk3710_ports_ops = {
 static struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
+	.dma_ops		= &sff_dma_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index 211ae46..f21290c 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -143,7 +143,7 @@ static struct udma_timing {
 
 static void pdcnew_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
 
@@ -219,7 +219,7 @@ static void pdcnew_reset(ide_drive_t *drive)
 	 * Deleted this because it is redundant from the caller.
 	 */
 	printk(KERN_WARNING "pdc202xx_new: %s channel reset.\n",
-		HWIF(drive)->channel ? "Secondary" : "Primary");
+		drive->hwif->channel ? "Secondary" : "Primary");
 }
 
 /**
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 624e62e..9719332 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -39,7 +39,7 @@ static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 
@@ -169,8 +169,8 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
 	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		struct request *rq	= HWGROUP(drive)->rq;
-		ide_hwif_t *hwif	= HWIF(drive);
+		ide_hwif_t *hwif	= drive->hwif;
+		struct request *rq	= hwif->rq;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u32 word_count	= 0;
@@ -189,7 +189,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
 	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		ide_hwif_t *hwif	= HWIF(drive);
+		ide_hwif_t *hwif	= drive->hwif;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u8 clock		= 0;
@@ -205,7 +205,7 @@ static int pdc202xx_dma_end(ide_drive_t *drive)
 
 static int pdc202xx_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long high_16	= hwif->extra_base - 16;
 	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 sc1d			= inb(high_16 + 0x001d);
@@ -243,7 +243,7 @@ static void pdc202xx_reset_host (ide_hwif_t *hwif)
 
 static void pdc202xx_reset (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	ide_hwif_t *mate	= hwif->mate;
 
 	pdc202xx_reset_host(hwif);
@@ -337,6 +337,7 @@ static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_dma_ops pdc2026x_dma_ops = {
@@ -348,6 +349,7 @@ static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 #define DECLARE_PDC2026X_DEV(udma, sectors) \
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index 61d2d92..f1e2e4e 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -67,7 +67,7 @@ static int no_piix_dma;
 
 static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
@@ -136,7 +136,7 @@ static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
@@ -224,7 +224,7 @@ static unsigned int init_chipset_ich(struct pci_dev *dev)
  */
 static void ich_clear_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat;
 
 	/*
@@ -260,6 +260,8 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
+	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
+	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
 	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 7c481bb..74625e8 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -955,7 +955,6 @@ static const struct ide_tp_ops pmac_tp_ops = {
 	.exec_command		= pmac_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= pmac_set_irq,
 
@@ -1513,10 +1512,10 @@ use_pio_instead:
 static int
 pmac_ide_dma_setup(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 
 	if (!pmac_ide_build_dmatable(drive, rq)) {
@@ -1637,7 +1636,7 @@ pmac_ide_dma_test_irq (ide_drive_t *drive)
 			break;
 		if (++timeout > 100) {
 			printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			timeout flushing channel\n", HWIF(drive)->index);
+			timeout flushing channel\n", hwif->index);
 			break;
 		}
 	}	
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index 4af4a8c..9f9c0b3 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -99,7 +99,6 @@ static const struct ide_tp_ops q40ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index bc27c7a..5b2e3af 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -202,7 +202,8 @@ static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
 	}
 
-	qd_set_timing(drive, qd6500_compute_timing(HWIF(drive), active_time, recovery_time));
+	qd_set_timing(drive, qd6500_compute_timing(drive->hwif,
+				active_time, recovery_time));
 }
 
 static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -245,11 +246,11 @@ static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,pio);
 	}
 
-	if (!HWIF(drive)->channel && drive->media != ide_disk) {
+	if (!hwif->channel && drive->media != ide_disk) {
 		outb(0x5f, QD_CONTROL_PORT);
 		printk(KERN_WARNING "%s: ATAPI: disabled read-ahead FIFO "
 			"and post-write buffer on %s.\n",
-			drive->name, HWIF(drive)->name);
+			drive->name, hwif->name);
 	}
 
 	qd_set_timing(drive, qd6580_compute_timing(active_time, recovery_time));
diff --git a/drivers/ide/qd65xx.h b/drivers/ide/qd65xx.h
index c83dea8..6636f96 100644
--- a/drivers/ide/qd65xx.h
+++ b/drivers/ide/qd65xx.h
@@ -31,8 +31,8 @@
 
 #define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
 
-#define QD_TIMING(drive)	(byte)(((drive)->drive_data) & 0x00ff)
-#define QD_TIMREG(drive)	(byte)((((drive)->drive_data) & 0xff00) >> 8)
+#define QD_TIMING(drive)	(u8)(((drive)->drive_data) & 0x00ff)
+#define QD_TIMREG(drive)	(u8)((((drive)->drive_data) & 0xff00) >> 8)
 
 #define QD6500_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0c : 0x08))
 #define QD6580_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index ec7f766..dbdd298 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -125,7 +125,7 @@ out:
 
 static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
-	ide_hwif_t		*hwif = HWIF(drive);
+	ide_hwif_t		*hwif = drive->hwif;
 	struct pci_dev		*dev = to_pci_dev(hwif->dev);
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
@@ -170,9 +170,9 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
  */
 static int sc1200_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long dma_base = hwif->dma_base;
-	byte dma_stat;
+	u8 dma_stat;
 
 	dma_stat = inb(dma_base+2);		/* get DMA status */
 
@@ -199,7 +199,7 @@ static int sc1200_dma_end(ide_drive_t *drive)
 
 static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t	*hwif = HWIF(drive);
+	ide_hwif_t	*hwif = drive->hwif;
 	int		mode = -1;
 
 	/*
@@ -292,6 +292,7 @@ static const struct ide_dma_ops sc1200_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info sc1200_chipset __devinitdata = {
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 0f48f9d..8d2314b 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -143,7 +143,7 @@ static u8 scc_read_altstatus(ide_hwif_t *hwif)
 	return (u8)in_be32((void *)hwif->io_ports.ctl_addr);
 }
 
-static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
+static u8 scc_dma_sff_read_status(ide_hwif_t *hwif)
 {
 	return (u8)in_be32((void *)(hwif->dma_base + 4));
 }
@@ -217,7 +217,7 @@ scc_ide_outsl(unsigned long port, void *addr, u32 count)
 
 static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -249,7 +249,7 @@ static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -259,7 +259,7 @@ static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	unsigned long scrcst_port = ctl_base + 0x014;
 	unsigned long udenvt_port = ctl_base + 0x018;
 	unsigned long tdvhsel_port   = ctl_base + 0x020;
-	int is_slave = (&hwif->drives[1] == drive);
+	int is_slave = drive->dn & 1;
 	int offset, idx;
 	unsigned long reg;
 	unsigned long jcactsel;
@@ -292,7 +292,7 @@ static void scc_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 unit = drive->dn & 1;
-	u8 dma_stat = scc_ide_inb(hwif->dma_base + 4);
+	u8 dma_stat = scc_dma_sff_read_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
@@ -316,7 +316,7 @@ static void scc_dma_host_set(ide_drive_t *drive, int on)
 static int scc_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	unsigned int reading;
 	u8 dma_stat;
 
@@ -338,7 +338,7 @@ static int scc_dma_setup(ide_drive_t *drive)
 	out_be32((void __iomem *)hwif->dma_base, reading);
 
 	/* read DMA status for INTR & ERROR flags */
-	dma_stat = in_be32((void __iomem *)(hwif->dma_base + 4));
+	dma_stat = scc_dma_sff_read_status(hwif);
 
 	/* clear INTR & ERROR flags */
 	out_be32((void __iomem *)(hwif->dma_base + 4), dma_stat | 6);
@@ -367,7 +367,7 @@ static int __scc_dma_end(ide_drive_t *drive)
 	/* stop DMA */
 	scc_ide_outb(dma_cmd & ~1, hwif->dma_base);
 	/* get DMA status */
-	dma_stat = scc_ide_inb(hwif->dma_base + 4);
+	dma_stat = scc_dma_sff_read_status(hwif);
 	/* clear the INTR & ERROR bits */
 	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
 	/* purge DMA mappings */
@@ -387,7 +387,7 @@ static int __scc_dma_end(ide_drive_t *drive)
 
 static int scc_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *dma_base = (void __iomem *)hwif->dma_base;
 	unsigned long intsts_port = hwif->dma_base + 0x014;
 	u32 reg;
@@ -405,17 +405,18 @@ static int scc_dma_end(ide_drive_t *drive)
 			       drive->name);
 			data_loss = 1;
 			if (retry++) {
-				struct request *rq = HWGROUP(drive)->rq;
-				int unit;
+				struct request *rq = hwif->rq;
+				ide_drive_t *drive;
+				int i;
+
 				/* ERROR_RESET and drive->crc_count are needed
 				 * to reduce DMA transfer mode in retry process.
 				 */
 				if (rq)
 					rq->errors |= ERROR_RESET;
-				for (unit = 0; unit < MAX_DRIVES; unit++) {
-					ide_drive_t *drive = &hwif->drives[unit];
+
+				ide_port_for_each_dev(i, drive, hwif)
 					drive->crc_count++;
-				}
 			}
 		}
 	}
@@ -496,7 +497,7 @@ static int scc_dma_end(ide_drive_t *drive)
 /* returns 1 if dma irq issued, 0 otherwise */
 static int scc_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
@@ -852,7 +853,6 @@ static const struct ide_tp_ops scc_tp_ops = {
 	.exec_command		= scc_exec_command,
 	.read_status		= scc_read_status,
 	.read_altstatus		= scc_read_altstatus,
-	.read_sff_dma_status	= scc_read_sff_dma_status,
 
 	.set_irq		= scc_set_irq,
 
@@ -879,6 +879,7 @@ static const struct ide_dma_ops scc_dma_ops = {
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
 #define DECLARE_SCC_DEV(name_str)			\
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index 437bc91..382102b 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -151,7 +151,7 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
 	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 1;
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 9f1f916..e85d1ed 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -130,7 +130,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 * we tune the drive then try to grab DMA ownership if we want to be
 	 * the DMA end.  This has to be become dynamic to handle hot-plug.
 	 */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
 		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
 			d->name, pci_name(dev));
@@ -377,6 +377,9 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 		hwif->dma_base = base;
 
+		if (hwif->dma_ops == NULL)
+			hwif->dma_ops = &sff_dma_ops;
+
 		if (ide_pci_check_simplex(hwif, d) < 0)
 			return -1;
 
@@ -393,8 +396,6 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
-
-		hwif->dma_ops = &sff_dma_ops;
 	}
 
 	return 0;
@@ -471,7 +472,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 	 */
 
 	for (port = 0; port < channels; ++port) {
-		const ide_pci_enablebit_t *e = &(d->enablebits[port]);
+		const struct ide_pci_enablebit *e = &d->enablebits[port];
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
@@ -519,8 +520,7 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 	if (ret < 0)
 		goto out;
 
-	/* Is it an "IDE storage" device in non-PCI mode? */
-	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE && (dev->class & 5) != 5) {
+	if (ide_pci_is_in_compatibility_mode(dev)) {
 		if (noisy)
 			printk(KERN_INFO "%s %s: not 100%% native mode: will "
 				"probe irqs later\n", d->name, pci_name(dev));
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index a687a7d..fdb9d70 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -123,7 +123,7 @@ static int
 sgiioc4_clearirq(ide_drive_t * drive)
 {
 	u32 intr_reg;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long other_ir = io_ports->irq_addr + (IOC4_INTR_REG << 2);
 
@@ -181,7 +181,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 
 static void sgiioc4_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long ioc4_dma_addr = hwif->dma_base + IOC4_DMA_CTRL * 4;
 	unsigned int reg = readl((void __iomem *)ioc4_dma_addr);
 	unsigned int temp_reg = reg | IOC4_S_DMA_START;
@@ -209,7 +209,7 @@ sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u64 dma_base)
 static int sgiioc4_dma_end(ide_drive_t *drive)
 {
 	u32 ioc4_dma, bc_dev, bc_mem, num, valid = 0, cnt = 0;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long dma_base = hwif->dma_base;
 	int dma_stat = 0;
 	unsigned long *ending_dma = ide_get_hwifdata(hwif);
@@ -271,7 +271,7 @@ static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
 /* returns 1 if dma irq issued, 0 otherwise */
 static int sgiioc4_dma_test_irq(ide_drive_t *drive)
 {
-	return sgiioc4_checkirq(HWIF(drive));
+	return sgiioc4_checkirq(drive->hwif);
 }
 
 static void sgiioc4_dma_host_set(ide_drive_t *drive, int on)
@@ -367,7 +367,7 @@ static void
 sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 {
 	u32 ioc4_dma;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long dma_base = hwif->dma_base;
 	unsigned long ioc4_dma_addr = dma_base + IOC4_DMA_CTRL * 4;
 	u32 dma_addr, ending_dma_addr;
@@ -427,7 +427,7 @@ sgiioc4_configure_for_dma(int dma_direction, ide_drive_t * drive)
 static unsigned int
 sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
 	unsigned int count = 0, i = 1;
 	struct scatterlist *sg;
@@ -492,7 +492,7 @@ use_pio_instead:
 
 static int sgiioc4_dma_setup(ide_drive_t *drive)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	unsigned int count = 0;
 	int ddir;
 
@@ -523,7 +523,6 @@ static const struct ide_tp_ops sgiioc4_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= sgiioc4_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index 7d622d2..cb2b352 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -114,7 +114,7 @@ static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
 
 static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 unit			= drive->dn & 1;
 
@@ -243,7 +243,7 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	static const u16 tf_speed[]   = { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
 	static const u16 data_speed[] = { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	u32 speedt		= 0;
@@ -300,7 +300,7 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	static const u8 ultra5[] = { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
 	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u16 ultra = 0, multi	= 0;
@@ -340,7 +340,7 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 /* returns 1 if dma irq issued, 0 otherwise */
 static int siimage_io_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 dma_altstat		= 0;
 	unsigned long addr	= siimage_selreg(hwif, 1);
@@ -367,7 +367,7 @@ static int siimage_io_dma_test_irq(ide_drive_t *drive)
 
 static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
 	void __iomem *sata_error_addr
 		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
@@ -717,6 +717,7 @@ static const struct ide_dma_ops sil_dma_ops = {
 	.dma_test_irq		= siimage_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 #define DECLARE_SII_DEV(p_ops)				\
diff --git a/drivers/ide/sis5513.c b/drivers/ide/sis5513.c
index ad32e18..9ec1a4a 100644
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -274,7 +274,7 @@ static void sis_program_timings(ide_drive_t *drive, const u8 mode)
 
 static void config_drive_art_rwp(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 reg4bh		= 0;
 	u8 rw_prefetch		= 0;
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index 84dc336..48cc748 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -140,7 +140,7 @@ static inline void sl82c105_reset_host(struct pci_dev *dev)
  */
 static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
 	u8 dma_cmd;
@@ -177,7 +177,7 @@ static void sl82c105_dma_lost_irq(ide_drive_t *drive)
  */
 static void sl82c105_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
@@ -299,6 +299,7 @@ static const struct ide_dma_ops sl82c105_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
 	.dma_timeout		= sl82c105_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
diff --git a/drivers/ide/slc90e66.c b/drivers/ide/slc90e66.c
index 0f759e4..40b4b94 100644
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -20,7 +20,7 @@ static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
@@ -73,7 +73,7 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index 93e2cce..84109f5 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -15,7 +15,7 @@
 
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
 	u16 mode, scr		= inw(scr_port);
 
@@ -62,13 +62,12 @@ static void tc86c001_set_pio_mode(ide_drive_t *drive, const u8 pio)
  */
 static int tc86c001_timer_expiry(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
 	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	/* Restore a higher level driver's expiry handler first. */
-	hwgroup->expiry	= expiry;
+	hwif->expiry = expiry;
 
 	if ((dma_stat & 5) == 1) {	/* DMA active and no interrupt */
 		unsigned long sc_base	= hwif->config_data;
@@ -110,11 +109,10 @@ static int tc86c001_timer_expiry(ide_drive_t *drive)
 
 static void tc86c001_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long sc_base	= hwif->config_data;
 	unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-	unsigned long nsectors	= hwgroup->rq->nr_sectors;
+	unsigned long nsectors	= hwif->rq->nr_sectors;
 
 	/*
 	 * We have to manually load the sector count and size into
@@ -125,8 +123,8 @@ static void tc86c001_dma_start(ide_drive_t *drive)
 	outw(SECTOR_SIZE / 2, twcr_port); /* Transfer Word Count 1/2 */
 
 	/* Install our timeout expiry hook, saving the current handler... */
-	ide_set_hwifdata(hwif, hwgroup->expiry);
-	hwgroup->expiry = &tc86c001_timer_expiry;
+	ide_set_hwifdata(hwif, hwif->expiry);
+	hwif->expiry = &tc86c001_timer_expiry;
 
 	ide_dma_start(drive);
 }
@@ -190,6 +188,7 @@ static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
diff --git a/drivers/ide/triflex.c b/drivers/ide/triflex.c
index b6ff403..8773c3b 100644
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -36,7 +36,7 @@
 
 static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u32 triflex_timings = 0;
 	u16 timing = 0;
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index 2a5ea90..b6a1285 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -144,7 +144,7 @@
 
 static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u16 reg = 0;
 	unsigned long flags;
 
@@ -184,7 +184,7 @@ static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
 static int trm290_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int count, rw;
 
 	if (rq_data_dir(rq)) {
@@ -222,15 +222,15 @@ static int trm290_dma_end(ide_drive_t *drive)
 	drive->waiting_for_dma = 0;
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
-	status = inw(HWIF(drive)->dma_base + 2);
+	status = inw(drive->hwif->dma_base + 2);
+
 	return status != 0x00ff;
 }
 
 static int trm290_dma_test_irq(ide_drive_t *drive)
 {
-	u16 status;
+	u16 status = inw(drive->hwif->dma_base + 2);
 
-	status = inw(HWIF(drive)->dma_base + 2);
 	return status == 0x00ff;
 }
 
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 4a8c5a2..882f6f0 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -293,7 +293,7 @@ static int tx4939ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	u8 reading;
 	int nent;
 
@@ -397,6 +397,17 @@ static int tx4939ide_dma_test_irq(ide_drive_t *drive)
 	return found;
 }
 
+#ifdef __BIG_ENDIAN
+static u8 tx4939ide_dma_sff_read_status(ide_hwif_t *hwif)
+{
+	void __iomem *base = TX4939IDE_BASE(hwif);
+
+	return tx4939ide_readb(base, TX4939IDE_DMA_Stat);
+}
+#else
+#define tx4939ide_dma_sff_read_status ide_dma_sff_read_status
+#endif
+
 static void tx4939ide_init_hwif(ide_hwif_t *hwif)
 {
 	void __iomem *base = TX4939IDE_BASE(hwif);
@@ -443,13 +454,6 @@ static void tx4939ide_tf_load_fixup(ide_drive_t *drive, ide_task_t *task)
 
 #ifdef __BIG_ENDIAN
 
-static u8 tx4939ide_read_sff_dma_status(ide_hwif_t *hwif)
-{
-	void __iomem *base = TX4939IDE_BASE(hwif);
-
-	return tx4939ide_readb(base, TX4939IDE_DMA_Stat);
-}
-
 /* custom iops (independent from SWAP_IO_SPACE) */
 static u8 tx4939ide_inb(unsigned long port)
 {
@@ -585,7 +589,6 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= tx4939ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
@@ -609,7 +612,6 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
 	.read_altstatus		= ide_read_altstatus,
-	.read_sff_dma_status	= ide_read_sff_dma_status,
 
 	.set_irq		= ide_set_irq,
 
@@ -638,6 +640,7 @@ static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_test_irq		= tx4939ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info tx4939ide_port_info __initdata = {
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index e29978c..0608d41 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -106,22 +106,21 @@ static void umc_set_speeds(u8 speeds[])
 
 static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *mate_hwgroup = hwif->mate ? hwif->mate->hwgroup : NULL;
+	ide_hwif_t *hwif = drive->hwif, *mate = hwif->mate;
 	unsigned long uninitialized_var(flags);
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
-	if (mate_hwgroup)
-		spin_lock_irqsave(&mate_hwgroup->lock, flags);
-	if (mate_hwgroup && mate_hwgroup->handler) {
+	if (mate)
+		spin_lock_irqsave(&mate->lock, flags);
+	if (mate && mate->handler) {
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
 		umc_set_speeds(current_speeds);
 	}
-	if (mate_hwgroup)
-		spin_unlock_irqrestore(&mate_hwgroup->lock, flags);
+	if (mate)
+		spin_unlock_irqrestore(&mate->lock, flags);
 }
 
 static const struct ide_port_ops umc8672_port_ops = {
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 2a812d3..fecc0e0 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -178,7 +178,7 @@ static void via_set_drive(ide_drive_t *drive, const u8 speed)
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
 
-	via_set_speed(HWIF(drive), drive->dn, &t);
+	via_set_speed(hwif, drive->dn, &t);
 }
 
 /**
diff --git a/include/linux/ide.h b/include/linux/ide.h
index db5ef8a..3644f63 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -32,18 +32,14 @@
 # define SUPPORT_VLB_SYNC 1
 #endif
 
-typedef unsigned char	byte;	/* used everywhere */
-
 /*
  * Probably not wise to fiddle with these
  */
+#define IDE_DEFAULT_MAX_FAILURES	1
 #define ERROR_MAX	8	/* Max read/write errors per sector */
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
-#define HWIF(drive)		((ide_hwif_t *)((drive)->hwif))
-#define HWGROUP(drive)		((ide_hwgroup_t *)(HWIF(drive)->hwgroup))
-
 /*
  * Definitions for accessing IDE controller registers
  */
@@ -185,9 +181,6 @@ typedef struct hw_regs_s {
 	unsigned long	config;
 } hw_regs_t;
 
-void ide_init_port_data(struct hwif_s *, unsigned int);
-void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
@@ -433,18 +426,14 @@ struct ide_atapi_pc {
 	struct idetape_bh *bh;
 	char *b_data;
 
-	/* idescsi only for now */
 	struct scatterlist *sg;
 	unsigned int sg_cnt;
 
-	struct scsi_cmnd *scsi_cmd;
-	void (*done) (struct scsi_cmnd *);
-
 	unsigned long timeout;
 };
 
 struct ide_devset;
-struct ide_driver_s;
+struct ide_driver;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 struct ide_acpi_drive_link;
@@ -588,7 +577,6 @@ struct ide_drive_s {
 	struct request_queue	*queue;	/* request queue */
 
 	struct request		*rq;	/* current request */
-	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
 	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
@@ -662,6 +650,8 @@ struct ide_drive_s {
 	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
 			      unsigned int, int);
 
+	ide_startstop_t (*irq_handler)(struct ide_drive_s *);
+
 	unsigned long atapi_flags;
 
 	struct ide_atapi_pc request_sense_pc;
@@ -684,7 +674,6 @@ struct ide_tp_ops {
 	void	(*exec_command)(struct hwif_s *, u8);
 	u8	(*read_status)(struct hwif_s *);
 	u8	(*read_altstatus)(struct hwif_s *);
-	u8	(*read_sff_dma_status)(struct hwif_s *);
 
 	void	(*set_irq)(struct hwif_s *, int);
 
@@ -745,14 +734,17 @@ struct ide_dma_ops {
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
 	void	(*dma_timeout)(struct ide_drive_s *);
+	/*
+	 * The following method is optional and only required to be
+	 * implemented for the SFF-8038i compatible controllers.
+	 */
+	u8	(*dma_sff_read_status)(struct hwif_s *);
 };
 
 struct ide_host;
 
 typedef struct hwif_s {
-	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
-	struct hwgroup_s *hwgroup;	/* actually (ide_hwgroup_t *) */
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 
 	struct ide_host *host;
@@ -763,7 +755,7 @@ typedef struct hwif_s {
 
 	unsigned long	sata_scr[SATA_NR_PORTS];
 
-	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
+	ide_drive_t	*devices[MAX_DRIVES + 1];
 
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
@@ -829,7 +821,7 @@ typedef struct hwif_s {
 	unsigned	extra_ports;	/* number of extra dma ports */
 
 	unsigned	present    : 1;	/* this interface exists */
-	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
+	unsigned	busy	   : 1; /* serializes devices on a port */
 
 	struct device		gendev;
 	struct device		*portdev;
@@ -841,19 +833,49 @@ typedef struct hwif_s {
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_hwif_link *acpidata;
 #endif
+
+	/* IRQ handler, if active */
+	ide_startstop_t	(*handler)(ide_drive_t *);
+
+	/* BOOL: polling active & poll_timeout field valid */
+	unsigned int polling : 1;
+
+	/* current drive */
+	ide_drive_t *cur_dev;
+
+	/* current request */
+	struct request *rq;
+
+	/* failsafe timer */
+	struct timer_list timer;
+	/* timeout value during long polls */
+	unsigned long poll_timeout;
+	/* queried upon timeouts */
+	int (*expiry)(ide_drive_t *);
+
+	int req_gen;
+	int req_gen_timer;
+
+	spinlock_t lock;
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
 #define MAX_HOST_PORTS 4
 
 struct ide_host {
-	ide_hwif_t	*ports[MAX_HOST_PORTS];
+	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
 	unsigned int	(*init_chipset)(struct pci_dev *);
 	unsigned long	host_flags;
 	void		*host_priv;
+	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
+
+	/* used for hosts requiring serialization */
+	volatile long	host_busy;
 };
 
+#define IDE_HOST_BUSY 0
+
 /*
  *  internal ide interrupt handler type
  */
@@ -863,38 +885,6 @@ typedef int (ide_expiry_t)(ide_drive_t *);
 /* used by ide-cd, ide-floppy, etc. */
 typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
 
-typedef struct hwgroup_s {
-		/* irq handler, if active */
-	ide_startstop_t	(*handler)(ide_drive_t *);
-
-		/* BOOL: protects all fields below */
-	volatile int busy;
-		/* BOOL: polling active & poll_timeout field valid */
-	unsigned int polling	: 1;
-
-		/* current drive */
-	ide_drive_t *drive;
-		/* ptr to current hwif in linked-list */
-	ide_hwif_t *hwif;
-
-		/* current request */
-	struct request *rq;
-
-		/* failsafe timer */
-	struct timer_list timer;
-		/* timeout value during long polls */
-	unsigned long poll_timeout;
-		/* queried upon timeouts */
-	int (*expiry)(ide_drive_t *);
-
-	int req_gen;
-	int req_gen_timer;
-
-	spinlock_t lock;
-} ide_hwgroup_t;
-
-typedef struct ide_driver_s ide_driver_t;
-
 extern struct mutex ide_setting_mtx;
 
 /*
@@ -1020,8 +1010,8 @@ void ide_proc_register_port(ide_hwif_t *);
 void ide_proc_port_register_devices(ide_hwif_t *);
 void ide_proc_unregister_device(ide_drive_t *);
 void ide_proc_unregister_port(ide_hwif_t *);
-void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
-void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
+void ide_proc_register_driver(ide_drive_t *, struct ide_driver *);
+void ide_proc_unregister_driver(ide_drive_t *, struct ide_driver *);
 
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
@@ -1048,8 +1038,10 @@ static inline void ide_proc_register_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_port_register_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_unregister_device(ide_drive_t *drive) { ; }
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
-static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
-static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
+static inline void ide_proc_register_driver(ide_drive_t *drive,
+					    struct ide_driver *driver) { ; }
+static inline void ide_proc_unregister_driver(ide_drive_t *drive,
+					      struct ide_driver *driver) { ; }
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
@@ -1118,11 +1110,10 @@ void ide_check_pm_state(ide_drive_t *, struct request *);
  * The gendriver.owner field should be set to the module owner of this driver.
  * The gendriver.name field should be set to the name of this driver
  */
-struct ide_driver_s {
+struct ide_driver {
 	const char			*version;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
-	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
@@ -1134,7 +1125,7 @@ struct ide_driver_s {
 #endif
 };
 
-#define to_ide_driver(drv) container_of(drv, ide_driver_t, gen_driver)
+#define to_ide_driver(drv) container_of(drv, struct ide_driver, gen_driver)
 
 int ide_device_get(ide_drive_t *);
 void ide_device_put(ide_drive_t *);
@@ -1166,9 +1157,7 @@ void ide_execute_pkt_cmd(ide_drive_t *);
 
 void ide_pad_transfer(ide_drive_t *, int, int);
 
-ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
-
-ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
+ide_startstop_t ide_error(ide_drive_t *, const char *, u8);
 
 void ide_fix_driveid(u16 *);
 
@@ -1192,7 +1181,6 @@ void ide_tf_dump(const char *, struct ide_taskfile *);
 void ide_exec_command(ide_hwif_t *, u8);
 u8 ide_read_status(ide_hwif_t *);
 u8 ide_read_altstatus(ide_hwif_t *);
-u8 ide_read_sff_dma_status(ide_hwif_t *);
 
 void ide_set_irq(ide_hwif_t *, int);
 
@@ -1272,26 +1260,6 @@ extern void ide_stall_queue(ide_drive_t *drive, unsigned long timeout);
 
 extern void ide_timer_expiry(unsigned long);
 extern irqreturn_t ide_intr(int irq, void *dev_id);
-
-static inline int ide_lock_hwgroup(ide_hwgroup_t *hwgroup)
-{
-	if (hwgroup->busy)
-		return 1;
-
-	hwgroup->busy = 1;
-	/* for atari only */
-	ide_get_lock(ide_intr, hwgroup);
-
-	return 0;
-}
-
-static inline void ide_unlock_hwgroup(ide_hwgroup_t *hwgroup)
-{
-	/* for atari only */
-	ide_release_lock();
-	hwgroup->busy = 0;
-}
-
 extern void do_ide_request(struct request_queue *);
 
 void ide_init_disk(struct gendisk *, ide_drive_t *);
@@ -1327,11 +1295,11 @@ static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
 }
 #endif
 
-typedef struct ide_pci_enablebit_s {
+struct ide_pci_enablebit {
 	u8	reg;	/* byte pci reg holding the enable-bit */
 	u8	mask;	/* mask to isolate the enable-bit */
 	u8	val;	/* value of masked reg when "enabled" */
-} ide_pci_enablebit_t;
+};
 
 enum {
 	/* Uses ISA control ports not PCI ones. */
@@ -1420,7 +1388,8 @@ struct ide_port_info {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	ide_pci_enablebit_t	enablebits[2];
+	struct ide_pci_enablebit	enablebits[2];
+
 	hwif_chipset_t		chipset;
 
 	u16			max_sectors;	/* if < than the default one */
@@ -1492,6 +1461,7 @@ void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
 int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
+u8 ide_dma_sff_read_status(ide_hwif_t *);
 extern const struct ide_dma_ops sff_dma_ops;
 #else
 static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
@@ -1529,9 +1499,6 @@ static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_remove_port_from_hwgroup(ide_hwif_t *);
-void ide_unregister(ide_hwif_t *);
-
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
@@ -1616,23 +1583,6 @@ static inline void ide_set_max_pio(ide_drive_t *drive)
 	ide_set_pio(drive, 255);
 }
 
-extern spinlock_t ide_lock;
-extern struct mutex ide_cfg_mtx;
-/*
- * Structure locking:
- *
- * ide_cfg_mtx and hwgroup->lock together protect changes to
- * ide_hwif_t->next
- * ide_drive_t->next
- *
- * ide_hwgroup_t->busy: hwgroup->lock
- * ide_hwgroup_t->hwif: hwgroup->lock
- * ide_hwif_t->{hwgroup,mate}: constant, no locking
- * ide_drive_t->hwif: constant, no locking
- */
-
-#define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
-
 char *ide_media_string(ide_drive_t *);
 
 extern struct device_attribute ide_dev_attrs[];
@@ -1651,8 +1601,15 @@ static inline int hwif_to_node(ide_hwif_t *hwif)
 
 static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 {
-	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
+	ide_drive_t *peer = drive->hwif->devices[(drive->dn ^ 1) & 1];
 
 	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
+
+#define ide_port_for_each_dev(i, dev, port) \
+	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++)
+
+#define ide_host_for_each_port(i, port, host) \
+	for ((i) = 0; ((port) = (host)->ports[i]) || (i) < MAX_HOST_PORTS; (i)++)
+
 #endif /* _IDE_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 218c73b..d543365 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1658,6 +1658,7 @@
 #define PCI_VENDOR_ID_ROCKWELL		0x127A
 
 #define PCI_VENDOR_ID_ITE		0x1283
+#define PCI_DEVICE_ID_ITE_8172		0x8172
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8213		0x8213
