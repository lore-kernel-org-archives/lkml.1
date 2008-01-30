Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYA3Io6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYA3Io6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbYA3Inm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:43:42 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:45929 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYA3Inf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:43:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47621651"
From: Bryan Wu <bryan.wu@analog.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Robin Getz <robin.getz@analog.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/4] [libata] Blackfin pata-bf54x driver: Add debug information
Date: Wed, 30 Jan 2008 16:43:26 +0800
Message-Id: <1201682608-22827-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
References: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/ata/pata_bf54x.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index ca62bb7..d86970a 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -299,7 +299,7 @@ static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	*/
 	n6 = num_clocks_min(t6min, fsclk);
 	if (mode >= 0 && mode <= 4 && n6 >= 1) {
-		pr_debug("set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
+		dev_dbg(adev->ap->dev, "set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
 		/* calculate the timing values for register transfers. */
 		while (mode > 0 && pio_fsclk[mode] > fsclk)
 			mode--;
@@ -376,7 +376,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_UDMA_0;
 	if (mode >= 0 && mode <= 5) {
-		pr_debug("set udmamode: mode=%d\n", mode);
+		dev_dbg(adev->ap->dev, "set udmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is t6 and tc,
 		 * the DIOW - data hold. If one SCLK pulse is longer
 		 * than this minimum value then register
@@ -433,7 +433,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_MW_DMA_0;
 	if (mode >= 0 && mode <= 2) {
-		pr_debug("set mdmamode: mode=%d\n", mode);
+		dev_dbg(adev->ap->dev, "set mdmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is tf, the DMACK to
 		 * read data released. If one SCLK pulse is longer than
 		 * this maximum value then the MDMA mode
@@ -697,7 +697,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 			write_atapi_register(base, ATA_REG_LBAL, tf->hob_lbal);
 			write_atapi_register(base, ATA_REG_LBAM, tf->hob_lbam);
 			write_atapi_register(base, ATA_REG_LBAH, tf->hob_lbah);
-			pr_debug("hob: feat 0x%X nsect 0x%X, lba 0x%X "
+			dev_dbg(ap->dev, "hob: feat 0x%X nsect 0x%X, lba 0x%X "
 				 "0x%X 0x%X\n",
 				tf->hob_feature,
 				tf->hob_nsect,
@@ -711,7 +711,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		write_atapi_register(base, ATA_REG_LBAL, tf->lbal);
 		write_atapi_register(base, ATA_REG_LBAM, tf->lbam);
 		write_atapi_register(base, ATA_REG_LBAH, tf->lbah);
-		pr_debug("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+		dev_dbg(ap->dev, "feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
 			tf->feature,
 			tf->nsect,
 			tf->lbal,
@@ -721,7 +721,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 
 	if (tf->flags & ATA_TFLAG_DEVICE) {
 		write_atapi_register(base, ATA_REG_DEVICE, tf->device);
-		pr_debug("device 0x%X\n", tf->device);
+		dev_dbg(ap->dev, "device 0x%X\n", tf->device);
 	}
 
 	ata_wait_idle(ap);
@@ -782,7 +782,7 @@ static void bfin_exec_command(struct ata_port *ap,
 			      const struct ata_taskfile *tf)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	pr_debug("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	dev_dbg(ap->dev, "ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 
 	write_atapi_register(base, ATA_REG_CMD, tf->command);
 	ata_pause(ap);
@@ -834,7 +834,7 @@ static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma setup\n");
+	dev_dbg(qc->ap->dev, "in atapi dma setup\n");
 	/* Program the ATA_CTRL register with dir */
 	if (qc->tf.flags & ATA_TFLAG_WRITE) {
 		/* fill the ATAPI DMA controller */
@@ -870,7 +870,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma start\n");
+	dev_dbg(qc->ap->dev, "in atapi dma start\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return;
 
@@ -888,7 +888,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 				sg_dma_address(sg) + sg_dma_len(sg));
 		}
 		enable_dma(CH_ATAPI_TX);
-		pr_debug("enable udma write\n");
+		dev_dbg(qc->ap->dev, "enable udma write\n");
 
 		/* Send ATA DMA write command */
 		bfin_exec_command(ap, &qc->tf);
@@ -898,7 +898,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 			| XFER_DIR));
 	} else {
 		enable_dma(CH_ATAPI_RX);
-		pr_debug("enable udma read\n");
+		dev_dbg(qc->ap->dev, "enable udma read\n");
 
 		/* Send ATA DMA read command */
 		bfin_exec_command(ap, &qc->tf);
@@ -936,7 +936,7 @@ static void bfin_bmdma_stop(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma stop\n");
+	dev_dbg(qc->ap->dev, "in atapi dma stop\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return;
 
@@ -1157,6 +1157,8 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 		host_stat |= ATA_DMA_ERR;
 	}
 
+	dev_dbg(ap->dev, "ATAPI: host_stat=0x%x\n", host_stat);
+
 	return host_stat;
 }
 
@@ -1213,8 +1215,7 @@ static void bfin_irq_clear(struct ata_port *ap)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
-	pr_debug("in atapi irq clear\n");
-
+	dev_dbg(ap->dev, "in atapi irq clear\n");
 	ATAPI_SET_INT_STATUS(base, ATAPI_GET_INT_STATUS(base)|ATAPI_DEV_INT
 		| MULTI_DONE_INT | UDMAIN_DONE_INT | UDMAOUT_DONE_INT
 		| MULTI_TERM_INT | UDMAIN_TERM_INT | UDMAOUT_TERM_INT);
@@ -1232,7 +1233,7 @@ static unsigned char bfin_irq_on(struct ata_port *ap)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	u8 tmp;
 
-	pr_debug("in atapi irq on\n");
+	dev_dbg(ap->dev, "in atapi irq on\n");
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
@@ -1255,7 +1256,7 @@ static void bfin_bmdma_freeze(struct ata_port *ap)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
-	pr_debug("in atapi dma freeze\n");
+	dev_dbg(ap->dev, "in atapi dma freeze\n");
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
@@ -1328,7 +1329,7 @@ static void bfin_error_handler(struct ata_port *ap)
 
 static void bfin_port_stop(struct ata_port *ap)
 {
-	pr_debug("in atapi port stop\n");
+	dev_dbg(ap->dev, "in atapi port stop\n");
 	if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
 		free_dma(CH_ATAPI_RX);
 		free_dma(CH_ATAPI_TX);
@@ -1337,7 +1338,7 @@ static void bfin_port_stop(struct ata_port *ap)
 
 static int bfin_port_start(struct ata_port *ap)
 {
-	pr_debug("in atapi port start\n");
+	dev_dbg(ap->dev, "in atapi port start\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return 0;
 
-- 
1.5.3.4
