Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYFTK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYFTK6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFTK6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:58:06 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57743 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbYFTK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:58:05 -0400
Subject: MMC: card test driver should not be builtin with other card support
Message-Id: <20080620105802.173598466@fluff.org.uk>
User-Agent: quilt/0.46-1
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/sdmmc-builtin-card-drivers-exclusive.patch
Date: Fri, 20 Jun 2008 11:58:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmc test driver and mmc block driver will attempt to bind
to any card present in the system, which means only one of these
drivers will end up with the card. If either one of these is selected
as builtin, ensure the other does not get built.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/Kconfig
===================================================================
--- linux-2.6.26-rc6-sdmmc3.orig/drivers/mmc/card/Kconfig	2008-06-20 11:53:08.000000000 +0100
+++ linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/Kconfig	2008-06-20 11:53:29.000000000 +0100
@@ -6,7 +6,7 @@ comment "MMC/SD Card Drivers"
 
 config MMC_BLOCK
 	tristate "MMC block device driver"
-	depends on BLOCK
+	depends on BLOCK && MMC_TEST != y
 	default y
 	help
 	  Say Y here to enable the MMC block device driver support.
@@ -42,6 +42,7 @@ config SDIO_UART
 config MMC_TEST
 	tristate "MMC host test driver"
 	default n
+	depends on MMC_BLOCK != y
 	help
 	  Development driver that performs a series of reads and writes
 	  to a memory card in order to expose certain well known bugs

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
