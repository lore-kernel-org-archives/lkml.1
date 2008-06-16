Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbYFPOkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbYFPOkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYFPOff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:35 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50222 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754009AbYFPOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:15 -0400
Message-Id: <20080616143514.349827212@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:57 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 12/16] MMC: S3C24XX: Fix MMC return codes.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-retcode-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error codes

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-08 14:02:32.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-08 14:02:34.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/mmc/core.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
@@ -27,6 +28,12 @@
 
 #define DRIVER_NAME "s3c-mci"
 
+#define MMC_ERR_NONE	(0)
+#define MMC_ERR_DMA	EINVAL
+#define MMC_ERR_TIMEOUT ETIMEDOUT
+#define MMC_ERR_BADCRC	EILSEQ
+#define MMC_ERR_FIFO	EILSEQ
+
 enum dbg_channels {
 	dbg_err   = (1 << 0),
 	dbg_debug = (1 << 1),

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
