Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYFPOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYFPOga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYFPOfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:19 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50200 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753898AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143512.811264653@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:50 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>,
       Harald Welte <laforge@openmoko.org>
Subject: [patch v2 05/16] MMC: S3C24XX MMC/SD stop fix
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-stop-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Kleffel <tk@maintech.de>

Fix the request finalisation by ensuring the controller
is stopped.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Harald Welte <laforge@openmoko.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 15:24:52.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:24:55.000000000 +0100
@@ -667,7 +667,7 @@ static void finalize_request(struct s3cm
 #endif
 	/* Cleanup controller */
 	writel(0, host->base + S3C2410_SDICMDARG);
-	writel(0, host->base + S3C2410_SDIDCON);
+	writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
 	writel(0, host->base + host->sdiimsk);
 
@@ -793,7 +793,7 @@ static int s3cmci_setup_data(struct s3cm
 		dbg(host, dbg_err,
 		    "mci_setup_data() transfer stillin progress.\n");
 
-		writel(0, host->base + S3C2410_SDIDCON);
+		writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 		s3cmci_reset(host);
 
 		if ((stoptries--) == 0) {

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
