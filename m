Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbXFNLJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbXFNLJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXFNLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:09:13 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63746 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXFNLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:09:12 -0400
Message-Id: <20070614110910.426654398@fluff.org.uk>
References: <20070614110853.539162819@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:08:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/2] WATCHDOG: s3c2410_wdt announce initialisation
Content-Disposition: inline; filename=simtec-drivers-watchdog-announce.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Announce the watchdog once the initialisation is
complete. This aides debugging problems where the
watchdog driver has been loaded and shows the
current state for the user.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt2/drivers/char/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.21-quilt2.orig/drivers/char/watchdog/s3c2410_wdt.c	2007-05-10 13:43:52.000000000 +0100
+++ linux-2.6.21-quilt2/drivers/char/watchdog/s3c2410_wdt.c	2007-05-11 11:55:46.000000000 +0100
@@ -348,6 +348,7 @@ static irqreturn_t s3c2410wdt_irq(int ir
 static int s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	unsigned int wtcon;
 	int started = 0;
 	int ret;
 	int size;
@@ -433,6 +434,16 @@ static int s3c2410wdt_probe(struct platf
 		s3c2410wdt_stop();
 	}
 
+	/* print out a statement of readiness */
+
+	wtcon = readl(wdt_base + S3C2410_WTCON);
+
+	dev_info(&pdev->dev,
+		 "watchdog %sactive, reset %sabled, irq %sabled\n", 
+		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
+		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
+		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
+
 	return 0;
 
  err_clk:

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
