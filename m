Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXFNKCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXFNKCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXFNKBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:01:39 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63401 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXFNKBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:01:38 -0400
Message-Id: <20070614100135.887605502@fluff.org.uk>
References: <20070614100109.192172553@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 11:01:11 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Vincent Sanders <vince@simtec.co.uk>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/6] SM501: initialise SDRAM clock before bus clocks
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
