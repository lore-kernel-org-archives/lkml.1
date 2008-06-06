Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbYFFP5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbYFFP5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbYFFPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:32 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51791 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756948AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155526.681793235@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:28 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 11/15] MMC: Fix the retcode in the S3C24XX MMC/SD driver
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-retcode-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error codes

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:35.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:28.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/mmc/core.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
@@ -28,6 +29,12 @@
 
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
