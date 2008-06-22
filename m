Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYFVOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYFVOT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYFVOTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:19:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39231 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYFVOTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:19:40 -0400
To: mchehab@infradead.org
Subject: [PATCH] WRITE_RPS1() converts to le32 itself
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQPr-0001yg-II@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:19:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... but two ancient drivers had not noticed.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/ttpci/av7110.c       |   40 ++++++++++++++--------------
 drivers/media/dvb/ttpci/budget-patch.c |   44 ++++++++++++++++----------------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index f05d43d..9f96293 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2403,18 +2403,18 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 		saa7146_write(dev, MC1, MASK_29);
 		/* RPS1 timeout disable */
 		saa7146_write(dev, RPS_TOV1, 0);
-		WRITE_RPS1(cpu_to_le32(CMD_PAUSE | EVT_VBI_B));
-		WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-		WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-		WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTLO<<24));
+		WRITE_RPS1(CMD_PAUSE | EVT_VBI_B);
+		WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+		WRITE_RPS1(GPIO3_MSK);
+		WRITE_RPS1(SAA7146_GPIO_OUTLO<<24);
 #if RPS_IRQ
 		/* issue RPS1 interrupt to increment counter */
-		WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+		WRITE_RPS1(CMD_INTERRUPT);
 #endif
-		WRITE_RPS1(cpu_to_le32(CMD_STOP));
+		WRITE_RPS1(CMD_STOP);
 		/* Jump to begin of RPS program as safety measure               (p37) */
-		WRITE_RPS1(cpu_to_le32(CMD_JUMP));
-		WRITE_RPS1(cpu_to_le32(dev->d_rps1.dma_handle));
+		WRITE_RPS1(CMD_JUMP);
+		WRITE_RPS1(dev->d_rps1.dma_handle);
 
 #if RPS_IRQ
 		/* set event counter 1 source as RPS1 interrupt (0x03)          (rE4 p53)
@@ -2527,28 +2527,28 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 		count = 0;
 
 		/* Wait Source Line Counter Threshold                           (p36) */
-		WRITE_RPS1(cpu_to_le32(CMD_PAUSE | EVT_HS));
+		WRITE_RPS1(CMD_PAUSE | EVT_HS);
 		/* Set GPIO3=1                                                  (p42) */
-		WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-		WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-		WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTHI<<24));
+		WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+		WRITE_RPS1(GPIO3_MSK);
+		WRITE_RPS1(SAA7146_GPIO_OUTHI<<24);
 #if RPS_IRQ
 		/* issue RPS1 interrupt */
-		WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+		WRITE_RPS1(CMD_INTERRUPT);
 #endif
 		/* Wait reset Source Line Counter Threshold                     (p36) */
-		WRITE_RPS1(cpu_to_le32(CMD_PAUSE | RPS_INV | EVT_HS));
+		WRITE_RPS1(CMD_PAUSE | RPS_INV | EVT_HS);
 		/* Set GPIO3=0                                                  (p42) */
-		WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-		WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-		WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTLO<<24));
+		WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+		WRITE_RPS1(GPIO3_MSK);
+		WRITE_RPS1(SAA7146_GPIO_OUTLO<<24);
 #if RPS_IRQ
 		/* issue RPS1 interrupt */
-		WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+		WRITE_RPS1(CMD_INTERRUPT);
 #endif
 		/* Jump to begin of RPS program                                 (p37) */
-		WRITE_RPS1(cpu_to_le32(CMD_JUMP));
-		WRITE_RPS1(cpu_to_le32(dev->d_rps1.dma_handle));
+		WRITE_RPS1(CMD_JUMP);
+		WRITE_RPS1(dev->d_rps1.dma_handle);
 
 		/* Fix VSYNC level */
 		saa7146_setgpio(dev, 3, SAA7146_GPIO_OUTLO);
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 9a15539..39bd0a2 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -431,22 +431,22 @@ static int budget_patch_attach (struct saa7146_dev* dev, struct saa7146_pci_exte
 	// in budget patch GPIO3 is connected to VSYNC_B
 	count = 0;
 #if 0
-	WRITE_RPS1(cpu_to_le32(CMD_UPLOAD |
-	  MASK_10 | MASK_09 | MASK_08 | MASK_06 | MASK_05 | MASK_04 | MASK_03 | MASK_02 ));
+	WRITE_RPS1(CMD_UPLOAD |
+	  MASK_10 | MASK_09 | MASK_08 | MASK_06 | MASK_05 | MASK_04 | MASK_03 | MASK_02 );
 #endif
-	WRITE_RPS1(cpu_to_le32(CMD_PAUSE | EVT_VBI_B));
-	WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-	WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-	WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTLO<<24));
+	WRITE_RPS1(CMD_PAUSE | EVT_VBI_B);
+	WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+	WRITE_RPS1(GPIO3_MSK);
+	WRITE_RPS1(SAA7146_GPIO_OUTLO<<24);
 #if RPS_IRQ
 	// issue RPS1 interrupt to increment counter
-	WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+	WRITE_RPS1(CMD_INTERRUPT);
 	// at least a NOP is neede between two interrupts
-	WRITE_RPS1(cpu_to_le32(CMD_NOP));
+	WRITE_RPS1(CMD_NOP);
 	// interrupt again
-	WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+	WRITE_RPS1(CMD_INTERRUPT);
 #endif
-	WRITE_RPS1(cpu_to_le32(CMD_STOP));
+	WRITE_RPS1(CMD_STOP);
 
 #if RPS_IRQ
 	// set event counter 1 source as RPS1 interrupt (0x03)          (rE4 p53)
@@ -558,28 +558,28 @@ static int budget_patch_attach (struct saa7146_dev* dev, struct saa7146_pci_exte
 
 
 	// Wait Source Line Counter Threshold                           (p36)
-	WRITE_RPS1(cpu_to_le32(CMD_PAUSE | EVT_HS));
+	WRITE_RPS1(CMD_PAUSE | EVT_HS);
 	// Set GPIO3=1                                                  (p42)
-	WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-	WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-	WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTHI<<24));
+	WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+	WRITE_RPS1(GPIO3_MSK);
+	WRITE_RPS1(SAA7146_GPIO_OUTHI<<24);
 #if RPS_IRQ
 	// issue RPS1 interrupt
-	WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+	WRITE_RPS1(CMD_INTERRUPT);
 #endif
 	// Wait reset Source Line Counter Threshold                     (p36)
-	WRITE_RPS1(cpu_to_le32(CMD_PAUSE | RPS_INV | EVT_HS));
+	WRITE_RPS1(CMD_PAUSE | RPS_INV | EVT_HS);
 	// Set GPIO3=0                                                  (p42)
-	WRITE_RPS1(cpu_to_le32(CMD_WR_REG_MASK | (GPIO_CTRL>>2)));
-	WRITE_RPS1(cpu_to_le32(GPIO3_MSK));
-	WRITE_RPS1(cpu_to_le32(SAA7146_GPIO_OUTLO<<24));
+	WRITE_RPS1(CMD_WR_REG_MASK | (GPIO_CTRL>>2));
+	WRITE_RPS1(GPIO3_MSK);
+	WRITE_RPS1(SAA7146_GPIO_OUTLO<<24);
 #if RPS_IRQ
 	// issue RPS1 interrupt
-	WRITE_RPS1(cpu_to_le32(CMD_INTERRUPT));
+	WRITE_RPS1(CMD_INTERRUPT);
 #endif
 	// Jump to begin of RPS program                                 (p37)
-	WRITE_RPS1(cpu_to_le32(CMD_JUMP));
-	WRITE_RPS1(cpu_to_le32(dev->d_rps1.dma_handle));
+	WRITE_RPS1(CMD_JUMP);
+	WRITE_RPS1(dev->d_rps1.dma_handle);
 
 	// Fix VSYNC level
 	saa7146_setgpio(dev, 3, SAA7146_GPIO_OUTLO);
-- 
1.5.3.GIT


