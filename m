Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbXFMNjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbXFMNjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbXFMNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:38:06 -0400
Received: from gsimpson.gotadsl.co.uk ([84.12.90.178]:50868 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758328AbXFMNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:38:05 -0400
Message-Id: <20070613131159.284417987@localhost>
References: <20070613130953.983863758@localhost>
Date: Wed, 13 Jun 2007 14:09:55 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [patch 2/6] SM501 MFD driver updates
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-clock-order.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SM501: initialise SDRAM clock before bus clocks

This init sequence of setting the SDRAM clock before the
bus clock is recommend by Silicon Motion to stop problems
with writes not sticking into registers.

Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt8/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.21-quilt8.orig/drivers/mfd/sm501.c	2007-06-07 12:12:38.000000000 +0100
+++ linux-2.6.21-quilt8/drivers/mfd/sm501.c	2007-06-07 12:13:03.000000000 +0100
@@ -833,15 +833,15 @@ static void sm501_init_regs(struct sm501
 	sm501_init_reg(sm, SM501_GPIO31_0_CONTROL, &init->gpio_low);
 	sm501_init_reg(sm, SM501_GPIO63_32_CONTROL, &init->gpio_high);
 
-	if (init->mclk) {
-		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
-		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
-	}
-
 	if (init->m1xclk) {
 		dev_info(sm->dev, "setting M1XCLK to %ld\n", init->m1xclk);
 		sm501_set_clock(sm->dev, SM501_CLOCK_M1XCLK, init->m1xclk);
 	}
+
+	if (init->mclk) {
+		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
+		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
+	}
 }
 
 static unsigned int sm501_mem_local[] = {

--
