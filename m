Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbXFJDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbXFJDcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 23:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbXFJDcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 23:32:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33344 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758603AbXFJDcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 23:32:00 -0400
Date: Sat, 9 Jun 2007 23:31:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070610033159.GA29752@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As mentioned, will push Tejun's updated probe patch when received.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   24 ++++++++++++++++
 drivers/ata/libata-core.c |   29 +++++++++++++-------
 drivers/ata/libata-scsi.c |   67 +++++++++++++++++++++++++++++----------------
 drivers/ata/libata-sff.c  |   37 +++++++++++++++++++-----
 drivers/ata/pata_isapnp.c |    1 -
 include/linux/ata.h       |    3 +-
 include/linux/libata.h    |    1 +
 7 files changed, 118 insertions(+), 44 deletions(-)

Alan Cox (2):
      libata-core/sff: Fix multiple assumptions about DMA
      libata: Correct abuse of language

Albert Lee (6):
      libata: print device model and firmware revision for ATAPI devices
      libata passthru: update protocol numbers
      libata passthru: support PIO multi commands
      libata passthru: map UDMA protocols
      libata passthru: always enforce correct DEV bit
      libata passthru: update cached device paramters

Olof Johansson (1):
      libata: fix probe time irq printouts

Peer Chen (1):
      ahci: Add MCP73/MCP77 support to AHCI driver

Tejun Heo (2):
      libata: disable NCQ for HITACHI HTS541680J9SA00/SB21C7EP
      libata: fix hw_sata_spd_limit initialization

Yoichi Yuasa (1):
      remove unused variable in pata_isapnp

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7baeaff..545f330 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -426,6 +426,30 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4733f00..4b3c45e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1727,7 +1727,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 
 	/* sanity check */
 	rc = -EINVAL;
-	reason = "device reports illegal type";
+	reason = "device reports invalid type";
 
 	if (class == ATA_DEV_ATA) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
@@ -1900,6 +1900,13 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ata_msg_probe(ap))
 		ata_dump_id(id);
 
+	/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
+	ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
+			sizeof(fwrevbuf));
+
+	ata_id_c_string(dev->id, modelbuf, ATA_ID_PROD,
+			sizeof(modelbuf));
+
 	/* ATA-specific feature tests */
 	if (dev->class == ATA_DEV_ATA) {
 		if (ata_id_is_cfa(id)) {
@@ -1914,13 +1921,6 @@ int ata_dev_configure(struct ata_device *dev)
 
 		dev->n_sectors = ata_id_n_sectors(id);
 
-		/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
-		ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
-				sizeof(fwrevbuf));
-
-		ata_id_c_string(dev->id, modelbuf, ATA_ID_PROD,
-				sizeof(modelbuf));
-
 		if (dev->id[59] & 0x100)
 			dev->multi_count = dev->id[59] & 0xff;
 
@@ -2009,7 +2009,9 @@ int ata_dev_configure(struct ata_device *dev)
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO, "ATAPI, max %s%s\n",
+			ata_dev_printk(dev, KERN_INFO,
+				       "ATAPI: %s, %s, max %s%s\n",
+				       modelbuf, fwrevbuf,
 				       ata_mode_string(xfer_mask),
 				       cdb_intr_string);
 	}
@@ -3791,6 +3793,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
+	/* Drives which do spurious command completion */
+	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
@@ -6313,7 +6317,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		/* init sata_spd_limit to the current value */
 		if (sata_scr_read(ap, SCR_CONTROL, &scontrol) == 0) {
 			int spd = (scontrol >> 4) & 0xf;
-			ap->hw_sata_spd_limit &= (1 << spd) - 1;
+			if (spd)
+				ap->hw_sata_spd_limit &= (1 << spd) - 1;
 		}
 		ap->sata_spd_limit = ap->hw_sata_spd_limit;
 
@@ -6433,6 +6438,9 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		devm_free_irq(host->dev, irq, host);
 
+	/* Used to print device info at probe */
+	host->irq = irq;
+
 	return rc;
 }
 
@@ -6818,6 +6826,7 @@ EXPORT_SYMBOL_GPL(ata_check_status);
 EXPORT_SYMBOL_GPL(ata_altstatus);
 EXPORT_SYMBOL_GPL(ata_exec_command);
 EXPORT_SYMBOL_GPL(ata_port_start);
+EXPORT_SYMBOL_GPL(ata_sff_port_start);
 EXPORT_SYMBOL_GPL(ata_interrupt);
 EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_data_xfer);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b3900cf..c228df2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1363,12 +1363,22 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	 * schedule EH_REVALIDATE operation to update the IDENTIFY DEVICE
 	 * cache
 	 */
-	if (ap->ops->error_handler &&
-	    !need_sense && (qc->tf.command == ATA_CMD_SET_FEATURES) &&
-	    ((qc->tf.feature == SETFEATURES_WC_ON) ||
-	     (qc->tf.feature == SETFEATURES_WC_OFF))) {
-		ap->eh_info.action |= ATA_EH_REVALIDATE;
-		ata_port_schedule_eh(ap);
+	if (ap->ops->error_handler && !need_sense) {
+		switch (qc->tf.command) {
+		case ATA_CMD_SET_FEATURES:
+			if ((qc->tf.feature == SETFEATURES_WC_ON) ||
+			    (qc->tf.feature == SETFEATURES_WC_OFF)) {
+				ap->eh_info.action |= ATA_EH_REVALIDATE;
+				ata_port_schedule_eh(ap);
+			}
+			break;
+
+		case ATA_CMD_INIT_DEV_PARAMS: /* CHS translation changed */
+		case ATA_CMD_SET_MULTI: /* multi_count changed */
+			ap->eh_info.action |= ATA_EH_REVALIDATE;
+			ata_port_schedule_eh(ap);
+			break;
+		}
 	}
 
 	/* For ATA pass thru (SAT) commands, generate a sense block if
@@ -2506,22 +2516,21 @@ ata_scsi_map_proto(u8 byte1)
 			return ATA_PROT_NODATA;
 
 		case 6:		/* DMA */
+		case 10:	/* UDMA Data-in */
+		case 11:	/* UDMA Data-Out */
 			return ATA_PROT_DMA;
 
 		case 4:		/* PIO Data-in */
 		case 5:		/* PIO Data-out */
 			return ATA_PROT_PIO;
 
-		case 10:	/* Device Reset */
 		case 0:		/* Hard Reset */
 		case 1:		/* SRST */
-		case 2:		/* Bus Idle */
-		case 7:		/* Packet */
-		case 8:		/* DMA Queued */
-		case 9:		/* Device Diagnostic */
-		case 11:	/* UDMA Data-in */
-		case 12:	/* UDMA Data-Out */
-		case 13:	/* FPDMA */
+		case 8:		/* Device Diagnostic */
+		case 9:		/* Device Reset */
+		case 7:		/* DMA Queued */
+		case 12:	/* FPDMA */
+		case 15:	/* Return Response Info */
 		default:	/* Reserved */
 			break;
 	}
@@ -2552,10 +2561,6 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	if (tf->protocol == ATA_PROT_DMA && dev->dma_mode == 0)
 		goto invalid_fld;
 
-	if (cdb[1] & 0xe0)
-		/* PIO multi not supported yet */
-		goto invalid_fld;
-
 	/*
 	 * 12 and 16 byte CDBs use different offsets to
 	 * provide the various register values.
@@ -2600,12 +2605,26 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		tf->device = cdb[8];
 		tf->command = cdb[9];
 	}
-	/*
-	 * If slave is possible, enforce correct master/slave bit
-	*/
-	if (qc->ap->flags & ATA_FLAG_SLAVE_POSS)
-		tf->device = qc->dev->devno ?
-			tf->device | ATA_DEV1 : tf->device & ~ATA_DEV1;
+
+	/* enforce correct master/slave bit */
+	tf->device = dev->devno ?
+		tf->device | ATA_DEV1 : tf->device & ~ATA_DEV1;
+
+	/* sanity check for pio multi commands */
+	if ((cdb[1] & 0xe0) && !is_multi_taskfile(tf))
+		goto invalid_fld;
+
+	if (is_multi_taskfile(tf)) {
+		unsigned int multi_count = 1 << (cdb[1] >> 5);
+
+		/* compare the passed through multi_count
+		 * with the cached multi_count of libata
+		 */
+		if (multi_count != dev->multi_count)
+			ata_dev_printk(dev, KERN_WARNING,
+				       "invalid multi_count %u ignored\n",
+				       multi_count);
+	}	
 
 	/* READ/WRITE LONG use a non-standard sect_size */
 	qc->sect_size = ATA_SECT_SIZE;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e35d134..ce84805 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -80,25 +80,25 @@ u8 ata_dummy_irq_on (struct ata_port *ap) 	{ return 0; }
 u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq)
 {
 	unsigned int bits = chk_drq ? ATA_BUSY | ATA_DRQ : ATA_BUSY;
-	u8 host_stat, post_stat, status;
+	u8 host_stat = 0, post_stat = 0, status;
 
 	status = ata_busy_wait(ap, bits, 1000);
 	if (status & bits)
 		if (ata_msg_err(ap))
 			printk(KERN_ERR "abnormal status 0x%X\n", status);
 
-	/* get controller status; clear intr, err bits */
-	host_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-	iowrite8(host_stat | ATA_DMA_INTR | ATA_DMA_ERR,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-
-	post_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	if (ap->ioaddr.bmdma_addr) {
+		/* get controller status; clear intr, err bits */
+		host_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+		iowrite8(host_stat | ATA_DMA_INTR | ATA_DMA_ERR,
+			 ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
+		post_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	}
 	if (ata_msg_intr(ap))
 		printk(KERN_INFO "%s: irq ack: host_stat 0x%X, new host_stat 0x%X, drv_stat 0x%X\n",
 			__FUNCTION__,
 			host_stat, post_stat, status);
-
 	return status;
 }
 
@@ -516,6 +516,27 @@ void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
 		ata_bmdma_stop(qc);
 }
 
+/**
+ *	ata_sff_port_start - Set port up for dma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates space for PRD table if the device
+ *	is DMA capable SFF.
+ *
+ *	May be used as the port_start() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+int ata_sff_port_start(struct ata_port *ap)
+{
+	if (ap->ioaddr.bmdma_addr)
+		return ata_port_start(ap);
+	return 0;
+}
+
 #ifdef CONFIG_PCI
 
 static int ata_resources_present(struct pci_dev *pdev, int port)
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 1f647b6..5525518 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -77,7 +77,6 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 	struct ata_host *host;
 	struct ata_port *ap;
 	void __iomem *cmd_addr, *ctl_addr;
-	int rc;
 
 	if (pnp_port_valid(idev, 0) == 0)
 		return -ENODEV;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index edb31bf..703febb 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -151,6 +151,7 @@ enum {
 	ATA_CMD_WRITE_MULTI_EXT	= 0x39,
 	ATA_CMD_WRITE_MULTI_FUA_EXT = 0xCE,
 	ATA_CMD_SET_FEATURES	= 0xEF,
+	ATA_CMD_SET_MULTI	= 0xC6,
 	ATA_CMD_PACKET		= 0xA0,
 	ATA_CMD_VERIFY		= 0x40,
 	ATA_CMD_VERIFY_EXT	= 0x42,
@@ -249,7 +250,7 @@ enum ata_tf_protocols {
 	/* ATA taskfile protocols */
 	ATA_PROT_UNKNOWN,	/* unknown/invalid */
 	ATA_PROT_NODATA,	/* no data */
-	ATA_PROT_PIO,		/* PIO single sector */
+	ATA_PROT_PIO,		/* PIO data xfer */
 	ATA_PROT_DMA,		/* DMA */
 	ATA_PROT_NCQ,		/* NCQ */
 	ATA_PROT_ATAPI,		/* packet command, PIO data xfer*/
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a6a3113..745c4f9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -753,6 +753,7 @@ extern u8 ata_check_status(struct ata_port *ap);
 extern u8 ata_altstatus(struct ata_port *ap);
 extern void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf);
 extern int ata_port_start (struct ata_port *ap);
+extern int ata_sff_port_start (struct ata_port *ap);
 extern irqreturn_t ata_interrupt (int irq, void *dev_instance);
 extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
 			  unsigned int buflen, int write_data);
