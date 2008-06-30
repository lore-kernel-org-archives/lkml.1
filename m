Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYF3P2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYF3P2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYF3P1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:49 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60306 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750842AbYF3P1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:48 -0400
Message-Id: <20080630152747.755524270@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:25:52 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 05/17] MMC: S3C24XX MMC/SD stop fix
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
