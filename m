Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYFFP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYFFP4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbYFFPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:29 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51778 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756555AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155525.314254500@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:21 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 04/15] MMC: S3C24XX MMC/SD stop fix From: Thomas Kleffel <tk@maintech.de>
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-stop-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the request finalisation by ensuring the controller
is stopped.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Harald Welte <laforge@openmoko.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:45:59.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:01.000000000 +0100
@@ -662,7 +662,7 @@ static void finalize_request(struct s3cm
 #endif
 	//Cleanup controller
 	writel(0, host->base + S3C2410_SDICMDARG);
-	writel(0, host->base + S3C2410_SDIDCON);
+	writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
 	writel(0, host->base + host->sdiimsk);
 
@@ -789,7 +789,7 @@ static int s3cmci_setup_data(struct s3cm
 		dbg(host, dbg_err,
 			"mci_setup_data() transfer stillin progress.\n");
 
-		writel(0, host->base + S3C2410_SDIDCON);
+		writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 		s3cmci_reset(host);
 
 		if (0 == (stoptries--)) {

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
