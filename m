Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbYF3VqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbYF3VqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933469AbYF3VlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:15 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50409 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933464AbYF3VlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:10 -0400
Message-Id: <20080630214109.409324948@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:27 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 04/16] MMC: S3C24XX MMC/SD stop fix
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-stop-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Kleffel <tk@maintech.de>

Fix the request finalisation by ensuring the controller
is stopped.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Harald Welte <laforge@openmoko.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:13.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:15.000000000 +0100
@@ -677,7 +677,7 @@ static void finalize_request(struct s3cm
 
 	/* Cleanup controller */
 	writel(0, host->base + S3C2410_SDICMDARG);
-	writel(0, host->base + S3C2410_SDIDCON);
+	writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
 	writel(0, host->base + host->sdiimsk);
 
@@ -803,7 +803,7 @@ static int s3cmci_setup_data(struct s3cm
 		dbg(host, dbg_err,
 		    "mci_setup_data() transfer stillin progress.\n");
 
-		writel(0, host->base + S3C2410_SDIDCON);
+		writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 		s3cmci_reset(host);
 
 		if ((stoptries--) == 0) {

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
