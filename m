Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXFRVEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXFRVEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761058AbXFRVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:03:45 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:52760 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475AbXFRVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:03:44 -0400
Message-Id: <20070618210341.856633386@fluff.org.uk>
References: <20070618205620.284044146@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 21:56:22 +0100
From: ben@fluff.org.uk
To: ben@fluff.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sm5xx-devel@lists.berlios.de
Cc: Vincent Sanders <vince@simtec.co.uk>, Ben Dooks <ben-linux@fluff.org>
Subject: [patch #2 2/6] SM501: initialise SDRAM clock before bus clocks
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-clock-order.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
