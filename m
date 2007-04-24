Return-Path: <linux-kernel-owner+w=401wt.eu-S1423018AbXDXUqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbXDXUqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423089AbXDXUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:46:45 -0400
Received: from smtp.nokia.com ([131.228.20.170]:65282 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423018AbXDXUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:46:44 -0400
Message-ID: <462E6AEA.30404@indt.org.br>
Date: Tue, 24 Apr 2007 16:39:06 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       "Anderson F. Briglia" <anderson.briglia@indt.org.br>
Subject: [PATCH 2/3] MMC: OMAP: Fix omap to use MMC_POWER_ON
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030306000602020905050308"
X-OriginalArrivalTime: 24 Apr 2007 20:45:23.0123 (UTC) FILETIME=[7AD17830:01C786B1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030306000602020905050308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------030306000602020905050308
Content-Type: text/plain;
 name="002-MMC-OMAP-Fix-omap-to-use-MMC_POWER_ON.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="002-MMC-OMAP-Fix-omap-to-use-MMC_POWER_ON.diff"

As discussed earlier on LKML:

http://lkml.org/lkml/2006/5/4/44

Signed-off-by: Tony Lindgren <tony@atomide.com>

Index: linux-2.6.20/drivers/mmc/omap.c
===================================================================
--- linux-2.6.20.orig/drivers/mmc/omap.c	2007-04-24 15:22:12.000000000 -0400
+++ linux-2.6.20/drivers/mmc/omap.c	2007-04-24 15:22:15.000000000 -0400
@@ -970,8 +970,10 @@ static void mmc_omap_set_ios(struct mmc_
 		mmc_omap_power(host, 0);
 		break;
 	case MMC_POWER_UP:
-	case MMC_POWER_ON:
+		/* Cannot touch dsor yet, just power up MMC */
 		mmc_omap_power(host, 1);
+		return;
+	case MMC_POWER_ON:
 		dsor |= 1 << 11;
 		break;
 	}
@@ -987,7 +989,7 @@ static void mmc_omap_set_ios(struct mmc_
 	 * Writing to the CON register twice seems to do the trick. */
 	for (i = 0; i < 2; i++)
 		OMAP_MMC_WRITE(host, CON, dsor);
-	if (ios->power_mode == MMC_POWER_UP) {
+	if (ios->power_mode == MMC_POWER_ON) {
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
 		OMAP_MMC_WRITE(host, STAT, 0xffff);

--------------030306000602020905050308--
