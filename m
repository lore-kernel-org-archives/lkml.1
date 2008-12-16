Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYLPTcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYLPTcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYLPTcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:10 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:48276 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbYLPTcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gy4yL2O2fL/U/hkvm+7Qf2/TzZ1Ugws3ixhkYuO4xxXzE8BZUbs7srOYnA5EA9HuOj
         PZpjWHUXCUSVLKmEh4wTNGmkDeEVCPA1kVJ5Uqwl44GCIHlUAMdn99i56m6Ku1Ci1u3Z
         ZltdhkUz0fljcpPHR3XvKLI3Q/dZrWouLlIss=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:31:50 +0100
Message-Id: <20081216193150.3959.46912.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide: remove HWIF() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove HWIF() macro

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c      |    4 ++--
 drivers/ide/alim15x3.c     |    4 ++--
 drivers/ide/au1xxx-ide.c   |    4 ++--
 drivers/ide/cmd64x.c       |   14 +++++++-------
 drivers/ide/cs5520.c       |    2 +-
 drivers/ide/cy82c693.c     |    2 +-
 drivers/ide/hpt366.c       |   18 +++++++++---------
 drivers/ide/icside.c       |   10 +++++-----
 drivers/ide/ide-acpi.c     |    4 ++--
 drivers/ide/ide-disk.c     |    4 ++--
 drivers/ide/ide-io.c       |    8 ++++----
 drivers/ide/ide-iops.c     |    4 ++--
 drivers/ide/ide-pm.c       |    4 ++--
 drivers/ide/ide-probe.c    |   12 ++++++------
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/it8213.c       |    4 ++--
 drivers/ide/ns87415.c      |    6 +++---
 drivers/ide/pdc202xx_new.c |    4 ++--
 drivers/ide/pdc202xx_old.c |   10 +++++-----
 drivers/ide/piix.c         |    6 +++---
 drivers/ide/pmac.c         |    4 ++--
 drivers/ide/qd65xx.c       |    7 ++++---
 drivers/ide/sc1200.c       |    6 +++---
 drivers/ide/scc_pata.c     |    8 ++++----
 drivers/ide/serverworks.c  |    2 +-
 drivers/ide/sgiioc4.c      |   12 ++++++------
 drivers/ide/siimage.c      |   10 +++++-----
 drivers/ide/sis5513.c      |    2 +-
 drivers/ide/sl82c105.c     |    4 ++--
 drivers/ide/slc90e66.c     |    4 ++--
 drivers/ide/tc86c001.c     |    6 +++---
 drivers/ide/triflex.c      |    2 +-
 drivers/ide/trm290.c       |    8 ++++----
 drivers/ide/via82cxxx.c    |    2 +-
 include/linux/ide.h        |    2 --
 35 files changed, 102 insertions(+), 103 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -83,7 +83,7 @@ static u8 pci_bus_clock_list_ultra (u8 s
 
 static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
@@ -111,7 +111,7 @@ static void aec6210_set_mode(ide_drive_t
 
 static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
Index: b/drivers/ide/alim15x3.c
===================================================================
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
@@ -150,7 +150,7 @@ static u8 ali_udma_filter(ide_drive_t *d
 
 static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 speed1		= speed;
 	u8 unit			= drive->dn & 1;
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -212,7 +212,7 @@ static void auide_set_dma_mode(ide_drive
 static int auide_build_dmatable(ide_drive_t *drive)
 {
 	int i, iswrite, count = 0;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
@@ -286,7 +286,7 @@ static int auide_build_dmatable(ide_driv
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	if (hwif->sg_nents) {
 		ide_destroy_dmatable(drive);
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -115,7 +115,7 @@ static void program_cycle_times (ide_dri
  */
 static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
@@ -180,7 +180,7 @@ static void cmd64x_set_pio_mode(ide_driv
 
 static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
@@ -226,7 +226,7 @@ static void cmd64x_set_dma_mode(ide_driv
 
 static int cmd648_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	int err			= ide_dma_end(drive);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
@@ -242,7 +242,7 @@ static int cmd648_dma_end(ide_drive_t *d
 
 static int cmd64x_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
@@ -259,7 +259,7 @@ static int cmd64x_dma_end(ide_drive_t *d
 
 static int cmd648_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
@@ -282,7 +282,7 @@ static int cmd648_dma_test_irq(ide_drive
 
 static int cmd64x_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
@@ -313,7 +313,7 @@ static int cmd64x_dma_test_irq(ide_drive
 
 static int cmd646_1_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -59,7 +59,7 @@ static struct pio_clocks cs5520_pio_cloc
 
 static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
 
Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -203,7 +203,7 @@ static void cy82c693_set_dma_mode(ide_dr
 
 static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	pio_clocks_t pclk;
 	unsigned int addrCtrl;
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -626,7 +626,7 @@ static struct hpt_info *hpt3xx_get_info(
 
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 mask 		= hwif->ultra_mask;
 
@@ -665,7 +665,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t
 
 static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	switch (info->chip_type) {
@@ -743,7 +743,7 @@ static void hpt3xx_quirkproc(ide_drive_t
 
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
@@ -788,7 +788,7 @@ static void hpt366_dma_lost_irq(ide_driv
 
 static void hpt370_clear_engine(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	pci_write_config_byte(dev, hwif->select_data, 0x37);
@@ -797,7 +797,7 @@ static void hpt370_clear_engine(ide_driv
 
 static void hpt370_irq_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_cmd;
@@ -822,7 +822,7 @@ static void hpt370_dma_start(ide_drive_t
 
 static int hpt370_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	if (dma_stat & 0x01) {
@@ -844,7 +844,7 @@ static void hpt370_dma_timeout(ide_drive
 /* returns 1 if DMA IRQ issued, 0 otherwise */
 static int hpt374_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_stat;
@@ -865,7 +865,7 @@ static int hpt374_dma_test_irq(ide_drive
 
 static int hpt374_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 mcr	= 0, mcr_addr	= hwif->select_data;
 	u8 bwsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
@@ -927,7 +927,7 @@ static void hpt3xxn_set_clock(ide_hwif_t
 
 static void hpt3xxn_rw_disk(ide_drive_t *drive, struct request *rq)
 {
-	hpt3xxn_set_clock(HWIF(drive), rq_data_dir(rq) ? 0x23 : 0x21);
+	hpt3xxn_set_clock(drive->hwif, rq_data_dir(rq) ? 0x23 : 0x21);
 }
 
 /**
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -166,7 +166,7 @@ static const expansioncard_ops_t icside_
  */
 static void icside_maskproc(ide_drive_t *drive, int mask)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
 	unsigned long flags;
@@ -284,7 +284,7 @@ static void icside_dma_host_set(ide_driv
 
 static int icside_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
 	drive->waiting_for_dma = 0;
@@ -299,7 +299,7 @@ static int icside_dma_end(ide_drive_t *d
 
 static void icside_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
 	/* We can not enable DMA on both channels simultaneously. */
@@ -309,7 +309,7 @@ static void icside_dma_start(ide_drive_t
 
 static int icside_dma_setup(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
 	struct request *rq = hwif->rq;
@@ -362,7 +362,7 @@ static void icside_dma_exec_cmd(ide_driv
 
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
 
Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -218,7 +218,7 @@ static acpi_handle ide_acpi_hwif_get_han
  */
 static acpi_handle ide_acpi_drive_get_handle(ide_drive_t *drive)
 {
-	ide_hwif_t	*hwif = HWIF(drive);
+	ide_hwif_t	*hwif = drive->hwif;
 	int		 port;
 	acpi_handle	 drive_handle;
 
@@ -263,7 +263,7 @@ static int do_drive_get_GTF(ide_drive_t 
 	acpi_status			status;
 	struct acpi_buffer		output;
 	union acpi_object 		*out_obj;
-	ide_hwif_t			*hwif = HWIF(drive);
+	ide_hwif_t			*hwif = drive->hwif;
 	struct device			*dev = hwif->gendev.parent;
 	int				err = -ENODEV;
 	int				port;
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -89,7 +89,7 @@ static void ide_tf_set_cmd(ide_drive_t *
 static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u16 nsectors		= (u16)rq->nr_sectors;
 	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
 	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
@@ -187,7 +187,7 @@ static ide_startstop_t __ide_do_rw_disk(
 static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 				      sector_t block)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -463,7 +463,7 @@ EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	ide_task_t *task = rq->special;
 
 	if (task) {
@@ -587,7 +587,7 @@ static ide_startstop_t start_request (id
 
 #ifdef DEBUG
 	printk("%s: start_request: current=0x%08lx\n",
-		HWIF(drive)->name, (unsigned long) rq);
+		drive->hwif->name, (unsigned long) rq);
 #endif
 
 	/* bail early if we've exceeded max_failures */
@@ -813,7 +813,7 @@ plug_device_2:
  */
 static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	ide_startstop_t ret = ide_stopped;
 
@@ -935,7 +935,7 @@ void ide_timer_expiry (unsigned long dat
 			 * globally mask the specific IRQ:
 			 */
 			spin_unlock(&hwif->lock);
-			hwif  = HWIF(drive);
+			hwif = drive->hwif;
 			/* disable_irq_nosync ?? */
 			disable_irq(hwif->irq);
 			/* local CPU only,
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -451,7 +451,7 @@ EXPORT_SYMBOL(ide_fixstring);
  */
 int drive_is_ready (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	u8 stat			= 0;
 
 	if (drive->waiting_for_dma)
@@ -965,7 +965,7 @@ static void ide_reset_report_error(ide_h
  */
 static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
 	int err = 0;
Index: b/drivers/ide/ide-pm.c
===================================================================
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
@@ -39,7 +39,7 @@ int generic_ide_suspend(struct device *d
 int generic_ide_resume(struct device *dev)
 {
 	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -189,7 +189,7 @@ static void ide_classify_atapi_dev(ide_d
 
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
@@ -341,7 +341,7 @@ static int actual_try_to_identify (ide_d
  
 static int try_to_identify (ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int retval;
 	int autoprobe = 0;
@@ -438,7 +438,7 @@ static u8 ide_read_device(ide_drive_t *d
 
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
 	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
@@ -522,7 +522,7 @@ static int do_probe (ide_drive_t *drive,
  */
 static void enable_nest (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
@@ -869,7 +869,7 @@ static void ide_port_tune_devices(ide_hw
 static int ide_init_queue(ide_drive_t *drive)
 {
 	struct request_queue *q;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	int max_sectors = 256;
 	int max_sg_entries = PRD_ENTRIES;
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -58,7 +58,7 @@ static ide_startstop_t task_in_intr(ide_
 
 ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
Index: b/drivers/ide/it8213.c
===================================================================
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
@@ -82,7 +82,7 @@ static void it8213_set_pio_mode(ide_driv
 
 static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -138,12 +138,12 @@ static unsigned int ns87415_count = 0, n
 
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
@@ -197,7 +197,7 @@ static void ns87415_selectproc (ide_driv
 
 static int ns87415_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t      *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -143,7 +143,7 @@ static struct udma_timing {
 
 static void pdcnew_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
 
@@ -219,7 +219,7 @@ static void pdcnew_reset(ide_drive_t *dr
 	 * Deleted this because it is redundant from the caller.
 	 */
 	printk(KERN_WARNING "pdc202xx_new: %s channel reset.\n",
-		HWIF(drive)->channel ? "Secondary" : "Primary");
+		drive->hwif->channel ? "Secondary" : "Primary");
 }
 
 /**
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -39,7 +39,7 @@ static void pdc_old_disable_66MHz_clock(
 
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 
@@ -169,7 +169,7 @@ static void pdc202xx_dma_start(ide_drive
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
 	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		ide_hwif_t *hwif	= HWIF(drive);
+		ide_hwif_t *hwif	= drive->hwif;
 		struct request *rq	= hwif->rq;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
@@ -189,7 +189,7 @@ static void pdc202xx_dma_start(ide_drive
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
 	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		ide_hwif_t *hwif	= HWIF(drive);
+		ide_hwif_t *hwif	= drive->hwif;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u8 clock		= 0;
@@ -205,7 +205,7 @@ static int pdc202xx_dma_end(ide_drive_t 
 
 static int pdc202xx_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long high_16	= hwif->extra_base - 16;
 	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 sc1d			= inb(high_16 + 0x001d);
@@ -243,7 +243,7 @@ static void pdc202xx_reset_host (ide_hwi
 
 static void pdc202xx_reset (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	ide_hwif_t *mate	= hwif->mate;
 
 	pdc202xx_reset_host(hwif);
Index: b/drivers/ide/piix.c
===================================================================
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
@@ -136,7 +136,7 @@ static void piix_set_pio_mode(ide_drive_
 
 static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
@@ -224,7 +224,7 @@ static unsigned int init_chipset_ich(str
  */
 static void ich_clear_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat;
 
 	/*
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1513,7 +1513,7 @@ use_pio_instead:
 static int
 pmac_ide_dma_setup(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = hwif->rq;
@@ -1637,7 +1637,7 @@ pmac_ide_dma_test_irq (ide_drive_t *driv
 			break;
 		if (++timeout > 100) {
 			printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			timeout flushing channel\n", HWIF(drive)->index);
+			timeout flushing channel\n", hwif->index);
 			break;
 		}
 	}	
Index: b/drivers/ide/qd65xx.c
===================================================================
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -202,7 +202,8 @@ static void qd6500_set_pio_mode(ide_driv
 		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
 	}
 
-	qd_set_timing(drive, qd6500_compute_timing(HWIF(drive), active_time, recovery_time));
+	qd_set_timing(drive, qd6500_compute_timing(drive->hwif,
+				active_time, recovery_time));
 }
 
 static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -245,11 +246,11 @@ static void qd6580_set_pio_mode(ide_driv
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
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -124,7 +124,7 @@ out:
 
 static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
-	ide_hwif_t		*hwif = HWIF(drive);
+	ide_hwif_t		*hwif = drive->hwif;
 	struct pci_dev		*dev = to_pci_dev(hwif->dev);
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
@@ -169,7 +169,7 @@ static void sc1200_set_dma_mode(ide_driv
  */
 static int sc1200_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long dma_base = hwif->dma_base;
 	byte dma_stat;
 
@@ -198,7 +198,7 @@ static int sc1200_dma_end(ide_drive_t *d
 
 static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t	*hwif = HWIF(drive);
+	ide_hwif_t	*hwif = drive->hwif;
 	int		mode = -1;
 
 	/*
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -217,7 +217,7 @@ scc_ide_outsl(unsigned long port, void *
 
 static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -249,7 +249,7 @@ static void scc_set_pio_mode(ide_drive_t
 
 static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -387,7 +387,7 @@ static int __scc_dma_end(ide_drive_t *dr
 
 static int scc_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *dma_base = (void __iomem *)hwif->dma_base;
 	unsigned long intsts_port = hwif->dma_base + 0x014;
 	u32 reg;
@@ -496,7 +496,7 @@ static int scc_dma_end(ide_drive_t *driv
 /* returns 1 if dma irq issued, 0 otherwise */
 static int scc_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -151,7 +151,7 @@ static void svwks_set_dma_mode(ide_drive
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
 	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 1;
 
Index: b/drivers/ide/sgiioc4.c
===================================================================
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
@@ -209,7 +209,7 @@ sgiioc4_ide_dma_stop(ide_hwif_t *hwif, u
 static int sgiioc4_dma_end(ide_drive_t *drive)
 {
 	u32 ioc4_dma, bc_dev, bc_mem, num, valid = 0, cnt = 0;
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long dma_base = hwif->dma_base;
 	int dma_stat = 0;
 	unsigned long *ending_dma = ide_get_hwifdata(hwif);
@@ -271,7 +271,7 @@ static void sgiioc4_set_dma_mode(ide_dri
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
@@ -427,7 +427,7 @@ sgiioc4_configure_for_dma(int dma_direct
 static unsigned int
 sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
 	unsigned int count = 0, i = 1;
 	struct scatterlist *sg;
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -114,7 +114,7 @@ static unsigned long siimage_selreg(ide_
 
 static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 unit			= drive->dn & 1;
 
@@ -243,7 +243,7 @@ static void sil_set_pio_mode(ide_drive_t
 	static const u16 tf_speed[]   = { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
 	static const u16 data_speed[] = { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	u32 speedt		= 0;
@@ -300,7 +300,7 @@ static void sil_set_dma_mode(ide_drive_t
 	static const u8 ultra5[] = { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
 	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
 
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u16 ultra = 0, multi	= 0;
@@ -340,7 +340,7 @@ static void sil_set_dma_mode(ide_drive_t
 /* returns 1 if dma irq issued, 0 otherwise */
 static int siimage_io_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 dma_altstat		= 0;
 	unsigned long addr	= siimage_selreg(hwif, 1);
@@ -367,7 +367,7 @@ static int siimage_io_dma_test_irq(ide_d
 
 static int siimage_mmio_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
 	void __iomem *sata_error_addr
 		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -274,7 +274,7 @@ static void sis_program_timings(ide_driv
 
 static void config_drive_art_rwp(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 reg4bh		= 0;
 	u8 rw_prefetch		= 0;
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -140,7 +140,7 @@ static inline void sl82c105_reset_host(s
  */
 static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
 	u8 dma_cmd;
@@ -177,7 +177,7 @@ static void sl82c105_dma_lost_irq(ide_dr
  */
 static void sl82c105_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
Index: b/drivers/ide/slc90e66.c
===================================================================
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
@@ -73,7 +73,7 @@ static void slc90e66_set_pio_mode(ide_dr
 
 static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -15,7 +15,7 @@
 
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
 	u16 mode, scr		= inw(scr_port);
 
@@ -62,7 +62,7 @@ static void tc86c001_set_pio_mode(ide_dr
  */
 static int tc86c001_timer_expiry(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
 	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
@@ -109,7 +109,7 @@ static int tc86c001_timer_expiry(ide_dri
 
 static void tc86c001_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long sc_base	= hwif->config_data;
 	unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
 	unsigned long nsectors	= hwif->rq->nr_sectors;
Index: b/drivers/ide/triflex.c
===================================================================
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
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -144,7 +144,7 @@
 
 static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	u16 reg = 0;
 	unsigned long flags;
 
@@ -222,15 +222,15 @@ static int trm290_dma_end(ide_drive_t *d
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
 
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -178,7 +178,7 @@ static void via_set_drive(ide_drive_t *d
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
 
-	via_set_speed(HWIF(drive), drive->dn, &t);
+	via_set_speed(hwif, drive->dn, &t);
 }
 
 /**
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -41,8 +41,6 @@ typedef unsigned char	byte;	/* used ever
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
-#define HWIF(drive)		((ide_hwif_t *)((drive)->hwif))
-
 /*
  * Definitions for accessing IDE controller registers
  */
