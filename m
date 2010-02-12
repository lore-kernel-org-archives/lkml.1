Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0BLUwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:52:36 -0500
Received: from mail.df.lth.se ([194.47.250.12]:50107 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437Ab0BLUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:52:35 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/2] [U300] Fix the DMA configuration
Date: Fri, 12 Feb 2010 21:52:22 +0100
Message-Id: <1266007942-29399-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a few bugs in the DMA configuration for the COH 901 318
DMA engine used in U300. It also removes the directional parameter
for each channel: separate DMA engine patches (submitted to the
DMA engine maintainer) switches that mechanism over to using
dynamic configuration of this, to handle bidirectional DMA
channels.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-u300/core.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 6869052..01b5031 100644
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
@@ -974,8 +964,8 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 				COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
-				COH901318_CX_CTRL_TCP_DISABLE |
-				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
 				COH901318_CX_CTRL_HSP_ENABLE |
 				COH901318_CX_CTRL_HSS_DISABLE |
 				COH901318_CX_CTRL_DDMA_LEGACY,
@@ -986,7 +976,7 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
 				COH901318_CX_CTRL_TCP_ENABLE |
-				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
 				COH901318_CX_CTRL_HSP_ENABLE |
 				COH901318_CX_CTRL_HSS_DISABLE |
 				COH901318_CX_CTRL_DDMA_LEGACY,
@@ -996,7 +986,7 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 				COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
-				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TCP_DISABLE |
 				COH901318_CX_CTRL_TC_IRQ_ENABLE |
 				COH901318_CX_CTRL_HSP_ENABLE |
 				COH901318_CX_CTRL_HSS_DISABLE |
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
-- 
1.6.3.3

