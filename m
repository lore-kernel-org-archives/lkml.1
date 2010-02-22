Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0BVEhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 23:37:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33666 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0BVEhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 23:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=BtknjO9Il+R5dvoJ6yRWF15RHHXYgjP04YeUG5U/ig5vRFiZi17wcJHUbRv03yRx2l
         WrMKs47r6PrHcM6IkExZ3Xzn151Tx+fVyYCeAfa7JjiDyAPEAN/MEm39IBj0DmSxferF
         RClZ+O6ZMWkXrBtKKHK3jf8Z6fVeDrq+69CdY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       sameo@linux.intel.com, linux-sh@vger.kernel.org
Date: Mon, 22 Feb 2010 13:37:09 +0900
Message-Id: <20100222043709.4675.49750.sendpatchset@t400s>
Subject: [PATCH] mfd: sh_mobile_sdhi MMC_CAP_MMC_HIGHSPEED support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add MMC_CAP_MMC_HIGHSPEED support to the sh_mobile_sdhi
driver. Also, remove type cast and FIXME comment.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Depends on the series:
 "[PATCH 00/05] tmio_mmc: SDHI hotplug and random fixes"

 drivers/mfd/sh_mobile_sdhi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 0001/drivers/mfd/sh_mobile_sdhi.c
+++ work/drivers/mfd/sh_mobile_sdhi.c	2010-02-22 11:51:12.000000000 +0900
@@ -21,7 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
-
+#include <linux/mmc/host.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
 #include <linux/mfd/sh_mobile_sdhi.h>
@@ -95,9 +95,9 @@ static int __init sh_mobile_sdhi_probe(s
 
 	clk_enable(priv->clk);
 
-	/* FIXME: silly const unsigned int hclk */
-	*(unsigned int *)&priv->mmc_data.hclk = clk_get_rate(priv->clk);
+	priv->mmc_data.hclk = clk_get_rate(priv->clk);
 	priv->mmc_data.set_pwr = sh_mobile_sdhi_set_pwr;
+	priv->mmc_data.capabilities = MMC_CAP_MMC_HIGHSPEED;
 
 	memcpy(&priv->cell_mmc, &sh_mobile_sdhi_cell, sizeof(priv->cell_mmc));
 	priv->cell_mmc.driver_data = &priv->mmc_data;
