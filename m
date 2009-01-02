Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZABKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZABKmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZABKli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:38 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:34087 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZABKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: [PATCH] m68k: Atari SCC support for ST
Date: Fri,  2 Jan 2009 11:41:13 +0100
Message-Id: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for Atari ST, and fix 2 obvious typos in the ST support code.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
---
 drivers/char/atari_scc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/atari_scc.c b/drivers/char/atari_scc.c
index 800193c..e407aa8 100644
--- a/drivers/char/atari_scc.c
+++ b/drivers/char/atari_scc.c
@@ -51,6 +51,7 @@
 
 #define CONFIG_TT_SCC     1
 #define CONFIG_FALCON_SCC 1
+#define CONFIG_ST_SCC     1
 
 #define CHANNEL_A	0
 #define CHANNEL_B	1
@@ -475,7 +476,7 @@ static int atari_st_scc_init(void)
 	request_irq(IRQ_SCCA_STAT, scc_stat_int, IRQ_TYPE_PRIO,
 		    "SCC-A status", port);
 	request_irq(IRQ_SCCA_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-A RX", port);
-	request_irq(SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
+	request_irq(IRQ_SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
 		    "SCC-A special cond", port);
 	{
 		SCC_ACCESS_INIT(port);
@@ -493,7 +494,7 @@ static int atari_st_scc_init(void)
 		/* disable interrupts for this channel */
 		SCCwrite(INT_AND_DMA_REG, 0);
 		/* Set the interrupt vector */
-		SCCwrite(INT_VECTOR_REG, BVME_IRQ_SCC_BASE);
+		SCCwrite(INT_VECTOR_REG, 0x60);
 		/* Interrupt parameters: vector includes status, status low */
 		SCCwrite(MASTER_INT_CTRL, MIC_VEC_INCL_STAT);
 		SCCmod(MASTER_INT_CTRL, 0xff, MIC_MASTER_INT_ENAB);
-- 
1.5.6.5

