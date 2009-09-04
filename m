Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZIDKy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZIDKy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZIDKyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:54:55 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39927 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbZIDKyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=uEISY4d/Mp0QE3tXMP8WeEmH4RV+3s0+mWeoeX+a1nRtnRxslJWFfcgrd18U/xzeCV
         5ZpRT+MbCIgeRkOsYmfy7mfvw7aGCseKp/8Ty4qImSRXzFhJoDYFbn/Uth4W5Snep/Na
         wrdZADHU6Nrb/rAeJzzUPIccfe4ec+Tsd3TP0=
From: Magnus Damm <magnus.damm@gmail.com>
To: ian@mnementh.co.uk
Cc: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org, damm@opensource.se, lethal@linux-sh.org,
       drzeus@drzeus.cx, philipp.zabel@gmail.com,
       Magnus Damm <magnus.damm@gmail.com>, g.liakhovetski@gmx.de
Date: Fri, 04 Sep 2009 19:50:20 +0900
Message-Id: <20090904105020.13527.97757.sendpatchset@rx1.opensource.se>
Subject: [PATCH] mmc: SuperH Mobile changes for tmio_mmc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the tmio_mmc driver to enable SuperH Mobile hardware.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Please apply on top of the following patch by Ian Molton:
 "Example idea for how to solve the clock/cnf problem"

 drivers/mmc/host/Kconfig    |    2 +-
 drivers/mmc/host/tmio_mmc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- 0001/drivers/mmc/host/Kconfig
+++ work/drivers/mmc/host/Kconfig	2009-08-20 23:48:11.000000000 +0900
@@ -273,7 +273,7 @@ config MMC_SDRICOH_CS
 
 config MMC_TMIO
 	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
-	depends on MFD_TMIO || MFD_ASIC3
+	depends on MFD_TMIO || MFD_ASIC3 || SUPERH
 	help
 	  This provides support for the SD/MMC cell found in TC6393XB,
 	  T7L66XB and also HTC ASIC3
--- 0006/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-08-20 23:48:11.000000000 +0900
@@ -516,7 +516,7 @@ static int __devinit tmio_mmc_probe(stru
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
 
-	if (dev->num_resources != 3)
+	if (dev->num_resources != 2)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
