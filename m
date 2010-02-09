Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0BIVzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:55:39 -0500
Received: from mail.df.lth.se ([194.47.250.12]:53373 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751580Ab0BIVzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:55:38 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: let the COH901318 decide transfer direction
Date: Tue,  9 Feb 2010 22:55:33 +0100
Message-Id: <1265752533-24275-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not mandate transfer direction on the slave channels for the
COH 901 318 DMA engine, instead let it decide per transfer
depending on settings. Most channels are unidirectional but some
(especially for MMC/SD) are bidirectional and need this.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/core.c |   14 --------------
 drivers/dma/coh901318.c   |   13 +++++++++++--
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 6869052..c95ca6d 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -475,7 +475,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 1 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -528,7 +527,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 2 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -582,7 +580,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 3 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -635,7 +632,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 4 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -706,7 +702,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 1 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -746,7 +741,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 2 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -799,7 +793,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 3 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -852,7 +845,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 4 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -905,7 +897,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 5 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -964,7 +955,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr =  U300_MMCSD_BASE + 0x080,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -1039,7 +1029,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 1,
 		.dev_addr = U300_PCM_I2S0_BASE + 0x14,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -1092,7 +1081,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 1,
 		.dev_addr = U300_PCM_I2S0_BASE + 0x10,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -1145,7 +1133,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 1,
 		.dev_addr =  U300_PCM_I2S1_BASE + 0x14,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
@@ -1198,7 +1185,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 1,
 		.dev_addr = U300_PCM_I2S1_BASE + 0x10,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
-				COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index b5f2ee0..b4d1ba9 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -125,7 +125,7 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 		goto err_kmalloc;
 	tmp = dev_buf;
 
-	tmp += sprintf(tmp, "DMA -- enable dma channels\n");
+	tmp += sprintf(tmp, "DMA -- enabled dma channels\n");
 
 	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++)
 		if (started_channels & (1 << i))
@@ -926,6 +926,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_lli *data;
 	struct coh901318_desc *cohd;
+	const struct coh901318_params *params;
 	struct scatterlist *sg;
 	int len = 0;
 	int size;
@@ -933,6 +934,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	u32 ctrl_chained = cohc_chan_param(cohc)->ctrl_lli_chained;
 	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	u32 config;
 	unsigned long flg;
 
 	if (!sgl)
@@ -954,10 +956,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	cohd->sg_len = 0;
 	cohd->dir = direction;
 
+	params = cohc_chan_param(cohc);
+	config = params->config;
+
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
 			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY;
 		ctrl_chained |= tx_flags;
 		ctrl_last |= tx_flags;
 		ctrl |= tx_flags;
@@ -965,12 +971,15 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		u32 rx_flags = COH901318_CX_CTRL_PRDD_DEST |
 			COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY;
 		ctrl_chained |= rx_flags;
 		ctrl_last |= rx_flags;
 		ctrl |= rx_flags;
 	} else
 		goto err_direction;
 
+	coh901318_set_conf(cohc, config);
+
 	dma_async_tx_descriptor_init(&cohd->desc, chan);
 
 	cohd->desc.tx_submit = coh901318_tx_submit;
@@ -1261,7 +1270,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	if (err)
 		goto err_register_memcpy;
 
-	dev_dbg(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
+	dev_info(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
 		(u32) base->virtbase);
 
 	return err;
-- 
1.6.3.3

