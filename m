Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYFVVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYFVVhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYFVVh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:37:27 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57829 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755679AbYFVVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:37:26 -0400
Message-Id: <20080622213721.325704700@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:36:49 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, wim@iguana.be,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/3] WATCHDOG: Fix NULL usage in s3c2410_wdt driver.
Content-Disposition: inline; filename=simtec/simtec-drivers-s3c2410-wdt-fixnull.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix comparison of a pointer to 0, instead of using
NULL for a invalid pointer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.26-rc5-quilt1.orig/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:08:39.000000000 +0100
+++ linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:09:54.000000000 +0100
@@ -377,7 +377,7 @@ static int s3c2410wdt_probe(struct platf
 	}
 
 	wdt_base = ioremap(res->start, size);
-	if (wdt_base == 0) {
+	if (wdt_base == NULL) {
 		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
 		goto err_req;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
