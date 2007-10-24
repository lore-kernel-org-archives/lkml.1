Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXJXXvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXJXXvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXJXXso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58708 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126AbXJXXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:36 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH] [libata] fix 'if(' and similar areas that lack whitespace
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Message-Id: <20071024234834.76D681F81AC@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:34 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/pata_acpi.c         |    4 +-
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pdc2027x.c     |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    4 +-
 drivers/ata/pata_via.c          |    2 +-
 drivers/ata/pata_winbond.c      |    2 +-
 drivers/ata/sata_nv.c           |   46 +++++++++++++++++++-------------------
 drivers/ata/sata_sx4.c          |    4 +-
 8 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 0f6f7bc..e4542ab 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -181,7 +181,7 @@ static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
 
-	if(!(acpi->gtm.flags & 0x10))
+	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
@@ -202,7 +202,7 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
 
-	if(!(acpi->gtm.flags & 0x10))
+	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 6b07b5b..f9b485a 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -449,7 +449,7 @@ static int optiplus_with_udma(struct pci_dev *pdev)
 
 	/* Find function 1 */
 	dev1 = pci_get_device(0x1045, 0xC701, NULL);
-	if(dev1 == NULL)
+	if (dev1 == NULL)
 		return 0;
 
 	/* Rev must be >= 0x10 */
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 3d3f155..2622577 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -348,7 +348,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
 			  ATA_ID_PROD_LEN + 1);
 	/* If the master is a maxtor in UDMA6 then the slave should not use UDMA 6 */
-	if(strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
+	if (strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
 		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
 
 	return ata_pci_default_filter(adev, mask);
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 65d9516..bc7c2d5 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -351,9 +351,9 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		struct pci_dev *bridge = dev->bus->self;
 		/* Don't grab anything behind a Promise I2O RAID */
 		if (bridge && bridge->vendor == PCI_VENDOR_ID_INTEL) {
-			if( bridge->device == PCI_DEVICE_ID_INTEL_I960)
+			if (bridge->device == PCI_DEVICE_ID_INTEL_I960)
 				return -ENODEV;
-			if( bridge->device == PCI_DEVICE_ID_INTEL_I960RM)
+			if (bridge->device == PCI_DEVICE_ID_INTEL_I960RM)
 				return -ENODEV;
 		}
 	}
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ea7a9a6..a4175fb 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -176,7 +176,7 @@ static int via_cable_detect(struct ata_port *ap) {
 	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
 		return ATA_CBL_PATA40;
 	/* UDMA 66 chips have only drive side logic */
-	else if((config->flags & VIA_UDMA) < VIA_UDMA_100)
+	else if ((config->flags & VIA_UDMA) < VIA_UDMA_100)
 		return ATA_CBL_PATA_UNK;
 	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 549cbbe..311cdb3 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -279,7 +279,7 @@ static __init int winbond_init(void)
 
 			if (request_region(port, 2, "pata_winbond")) {
 				ret = winbond_init_one(port);
-				if(ret <= 0)
+				if (ret <= 0)
 					release_region(port, 2);
 				else ct+= ret;
 			}
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2e0279f..9210bb2 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1012,7 +1012,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				u32 check_commands;
 				int pos, error = 0;
 
-				if(ata_tag_valid(ap->link.active_tag))
+				if (ata_tag_valid(ap->link.active_tag))
 					check_commands = 1 << ap->link.active_tag;
 				else
 					check_commands = ap->link.sactive;
@@ -1028,7 +1028,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 		}
 	}
 
-	if(notifier_clears[0] || notifier_clears[1]) {
+	if (notifier_clears[0] || notifier_clears[1]) {
 		/* Note: Both notifier clear registers must be written
 		   if either is set, even if one is zero, according to NVIDIA. */
 		struct nv_adma_port_priv *pp = host->ports[0]->private_data;
@@ -1119,7 +1119,7 @@ static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
-	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
 		ata_bmdma_post_internal_cmd(qc);
 }
 
@@ -1194,10 +1194,10 @@ static int nv_adma_port_start(struct ata_port *ap)
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1255,10 +1255,10 @@ static int nv_adma_port_resume(struct ata_port *ap)
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1359,12 +1359,12 @@ static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
 	   or interrupt-driven no-data commands, where a result taskfile
 	   is not required. */
-	if((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
 	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
 	   (qc->flags & ATA_QCFLAG_RESULT_TF))
 		return 1;
 
-	if((qc->flags & ATA_QCFLAG_DMAMAP) ||
+	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||
 	   (qc->tf.protocol == ATA_PROT_NODATA))
 		return 0;
 
@@ -1401,7 +1401,7 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 
 	nv_adma_tf_to_cpb(&qc->tf, cpb->tf);
 
-	if(qc->flags & ATA_QCFLAG_DMAMAP) {
+	if (qc->flags & ATA_QCFLAG_DMAMAP) {
 		nv_adma_fill_sg(qc, cpb);
 		ctl_flags |= NV_CPB_CTL_APRD_VALID;
 	} else
@@ -1435,7 +1435,7 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
 
-	if(curr_ncq != pp->last_issue_ncq) {
+	if (curr_ncq != pp->last_issue_ncq) {
 	   	/* Seems to need some delay before switching between NCQ and non-NCQ
 		   commands, else we get command timeouts and such. */
 		udelay(20);
@@ -1641,12 +1641,12 @@ static void nv_error_handler(struct ata_port *ap)
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
+	if (!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
 		void __iomem *mmio = pp->ctl_block;
 		int i;
 		u16 tmp;
 
-		if(ata_tag_valid(ap->link.active_tag) || ap->link.sactive) {
+		if (ata_tag_valid(ap->link.active_tag) || ap->link.sactive) {
 			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
 			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
 			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
@@ -1660,9 +1660,9 @@ static void nv_adma_error_handler(struct ata_port *ap)
 				notifier, notifier_error, gen_ctl, status,
 				cpb_count, next_cpb_idx);
 
-			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+			for (i = 0; i < NV_ADMA_MAX_CPBS; i++) {
 				struct nv_adma_cpb *cpb = &pp->cpb[i];
-				if( (ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
+				if ((ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
 				    ap->link.sactive & (1 << i) )
 					ata_port_printk(ap, KERN_ERR,
 						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
@@ -1674,7 +1674,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		nv_adma_register_mode(ap);
 
 		/* Mark all of the CPBs as invalid to prevent them from being executed */
-		for( i=0;i<NV_ADMA_MAX_CPBS;i++)
+		for (i = 0; i < NV_ADMA_MAX_CPBS; i++)
 			pp->cpb[i].ctl_flags &= ~NV_CPB_CTL_CPB_VALID;
 
 		/* clear CPB fetch count */
@@ -1683,10 +1683,10 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		/* Reset channel */
 		tmp = readw(mmio + NV_ADMA_CTL);
 		writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 		udelay(1);
 		writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	}
 
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
@@ -2440,32 +2440,32 @@ static int nv_pci_device_resume(struct pci_dev *pdev)
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
-	if(rc)
+	if (rc)
 		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		if(hpriv->type >= CK804) {
+		if (hpriv->type >= CK804) {
 			u8 regval;
 
 			pci_read_config_byte(pdev, NV_MCP_SATA_CFG_20, &regval);
 			regval |= NV_MCP_SATA_CFG_20_SATA_SPACE_EN;
 			pci_write_config_byte(pdev, NV_MCP_SATA_CFG_20, regval);
 		}
-		if(hpriv->type == ADMA) {
+		if (hpriv->type == ADMA) {
 			u32 tmp32;
 			struct nv_adma_port_priv *pp;
 			/* enable/disable ADMA on the ports appropriately */
 			pci_read_config_dword(pdev, NV_MCP_SATA_CFG_20, &tmp32);
 
 			pp = host->ports[0]->private_data;
-			if(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
 				tmp32 &= ~(NV_MCP_SATA_CFG_20_PORT0_EN |
 				 	   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
 			else
 				tmp32 |=  (NV_MCP_SATA_CFG_20_PORT0_EN |
 				 	   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
 			pp = host->ports[1]->private_data;
-			if(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
 				tmp32 &= ~(NV_MCP_SATA_CFG_20_PORT1_EN |
 				 	   NV_MCP_SATA_CFG_20_PORT1_PWB_EN);
 			else
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index b6026bc..16b3b8a 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1091,7 +1091,7 @@ static int pdc20621_detect_dimm(struct ata_host *host)
 		return 0;
 
 	if (pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS, 9, &data)) {
-		if(data <= 0x75)
+		if (data <= 0x75)
 			return 133;
    	} else
 		return 0;
@@ -1254,7 +1254,7 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	   If SX4 is on PCI-X bus, after 3 seconds, the timer counter
 	   register should be >= (0xffffffff - 3x10^8).
 	*/
-	if(tcount >= PCI_X_TCOUNT) {
+	if (tcount >= PCI_X_TCOUNT) {
 		ticks = (time_period - tcount);
 		VPRINTK("Num counters 0x%x (%d)\n", ticks, ticks);
 
-- 
1.5.2.4

