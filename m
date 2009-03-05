Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCEMeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCEMeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZCEMeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:34:10 -0500
Received: from havoc.gtf.org ([69.61.125.42]:57022 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbZCEMeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:34:08 -0500
Date: Thu, 5 Mar 2009 07:34:04 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090305123404.GA15826@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various fixes, nothing major, and some NVIDIA PCI ID maintenance in ahci.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   24 ++++++++++++------------
 drivers/ata/libata-core.c |   14 ++++++++------
 drivers/ata/libata-eh.c   |    7 +++++--
 drivers/ata/sata_nv.c     |    2 +-
 include/linux/libata.h    |    6 ++++--
 5 files changed, 30 insertions(+), 23 deletions(-)

Brandon Ehle (1):
      sata_nv: fix module parameter description

FUJITA Tomonori (1):
      libata: fix dma_unmap_sg misuse

Robert Hancock (1):
      libata: Don't trust current capacity values in identify words 57-58

Stuart Hayes (1):
      libata: change drive ready wait after hard reset to 5s

Tejun Heo (3):
      libata: align ap->sector_buf
      libata: don't use on-stack sense buffer
      libata: make sure port is thawed when skipping resets

peerchen (1):
      ahci: Add the Device IDs for MCP89 and remove IDs of MCP7B to/from ahci.c

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a603bbf..66e012c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -582,18 +582,18 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci },		/* MCP89 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9fbf059..060bcd6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1322,14 +1322,16 @@ static u64 ata_id_n_sectors(const u16 *id)
 {
 	if (ata_id_has_lba(id)) {
 		if (ata_id_has_lba48(id))
-			return ata_id_u64(id, 100);
+			return ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		else
-			return ata_id_u32(id, 60);
+			return ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 	} else {
 		if (ata_id_current_chs_valid(id))
-			return ata_id_u32(id, 57);
+			return id[ATA_ID_CUR_CYLS] * id[ATA_ID_CUR_HEADS] *
+			       id[ATA_ID_CUR_SECTORS];
 		else
-			return id[1] * id[3] * id[6];
+			return id[ATA_ID_CYLS] * id[ATA_ID_HEADS] *
+			       id[ATA_ID_SECTORS];
 	}
 }
 
@@ -4612,7 +4614,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
 	if (qc->n_elem)
-		dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
+		dma_unmap_sg(ap->dev, sg, qc->orig_n_elem, dir);
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->sg = NULL;
@@ -4727,7 +4729,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 		return -1;
 
 	DPRINTK("%d sg elements mapped\n", n_elem);
-
+	qc->orig_n_elem = qc->n_elem;
 	qc->n_elem = n_elem;
 	qc->flags |= ATA_QCFLAG_DMAMAP;
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ce2ef04..ea89091 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2423,11 +2423,14 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		}
 
 		/* prereset() might have cleared ATA_EH_RESET.  If so,
-		 * bang classes and return.
+		 * bang classes, thaw and return.
 		 */
 		if (reset && !(ehc->i.action & ATA_EH_RESET)) {
 			ata_for_each_dev(dev, link, ALL)
 				classes[dev->devno] = ATA_DEV_NONE;
+			if ((ap->pflags & ATA_PFLAG_FROZEN) &&
+			    ata_is_host_link(link))
+				ata_eh_thaw_port(ap);
 			rc = 0;
 			goto out;
 		}
@@ -2901,7 +2904,7 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 	int i;
 
 	for (i = 0; i < ATA_EH_UA_TRIES; i++) {
-		u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
+		u8 *sense_buffer = dev->link->ap->sector_buf;
 		u8 sense_key = 0;
 		unsigned int err_mask;
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 55a8eed..f65b537 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2523,7 +2523,7 @@ static void __exit nv_exit(void)
 module_init(nv_init);
 module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
-MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
+MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
 MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5d87bc0..dc18b87 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -275,7 +275,7 @@ enum {
 	 * advised to wait only for the following duration before
 	 * doing SRST.
 	 */
-	ATA_TMOUT_PMP_SRST_WAIT	= 1000,
+	ATA_TMOUT_PMP_SRST_WAIT	= 5000,
 
 	/* ATA bus states */
 	BUS_UNKNOWN		= 0,
@@ -530,6 +530,7 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
+	unsigned int		orig_n_elem;
 
 	int			dma_dir;
 
@@ -750,7 +751,8 @@ struct ata_port {
 	acpi_handle		acpi_handle;
 	struct ata_acpi_gtm	__acpi_init_gtm; /* use ata_acpi_init_gtm() */
 #endif
-	u8			sector_buf[ATA_SECT_SIZE]; /* owned by EH */
+	/* owned by EH */
+	u8			sector_buf[ATA_SECT_SIZE] ____cacheline_aligned;
 };
 
 /* The following initializer overrides a method to NULL whether one of
