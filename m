Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXK1RSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXK1RSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXK1RSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:18:12 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:51577 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXK1RSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EGhARVSs7eM/brtLTjzQRVun3GOq1zcLpRnFTd7BYCLtWymsEs8RrAKyKEePfEsAZ4YAE3aNvAVA+xYLDq/fobN5Lv9TMoYUlVowoEEpVPJ+TtVZ089u/6fgGJa21iG/S/xhzsR8fqNGRwI8WpOOtG/Vcdt13Jk8hZbwSGrg4Sw=
Date: Thu, 29 Nov 2007 00:17:59 +0700
From: Riki Oktarianto <rkoktarianto@gmail.com>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: linux-kernel@vger.kernel.org, mactel-linux-devel@lists.sourceforge.net
Subject: [PATCH] applesmc - sensors set for MacBook2, try 2
Message-ID: <20071128171759.GA15684@ceren>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensors set for MacBook2, from register dump on a mid-2007 MacBook2.

--

Signed-off-by: Riki Oktarianto <rkoktarianto@gmail.com>

--- linux-2.6.24-rc3.orig/drivers/hwmon/applesmc.c
+++ linux-2.6.24-rc3/drivers/hwmon/applesmc.c
@@ -84,12 +84,15 @@ static const char* temperature_sensors_s
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
-/* Set 1: Macbook set */
+/* Set 1: Macbook2 set */
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "TTF0", "Th0H",
+	  "Th0S", "Th1H", NULL },
+/* Set 2: Macbook set */
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
 	  "Th1H", "Ts0P", NULL },
-/* Set 2: Macmini set */
+/* Set 3: Macmini set */
 	{ "TC0D", "TC0P", NULL },
-/* Set 3: Mac Pro (2 x Quad-Core) */
+/* Set 4: Mac Pro (2 x Quad-Core) */
 	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
 	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "THTG", "TH0P",
 	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
@@ -1212,12 +1215,14 @@ static void applesmc_release_acceleromet
 static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 /* MacBook Pro: accelerometer, backlight and temperature set 0 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 0 },
-/* MacBook: accelerometer and temperature set 1 */
+/* MacBook2: accelerometer and temperature set 1 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 1 },
-/* MacMini: temperature set 2 */
-	{ .accelerometer = 0, .light = 0, .temperature_set = 2 },
-/* MacPro: temperature set 3 */
+/* MacBook: accelerometer and temperature set 2 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 2 },
+/* MacMini: temperature set 3 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 3 },
+/* MacPro: temperature set 4 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1229,16 +1234,20 @@ static __initdata struct dmi_system_id a
 		(void*)&applesmc_dmi_data[0]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
-	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
 		(void*)&applesmc_dmi_data[1]},
+	{ applesmc_dmi_match, "Apple MacBook", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+		(void*)&applesmc_dmi_data[2]},
 	{ applesmc_dmi_match, "Apple Macmini", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
-		(void*)&applesmc_dmi_data[2]},
+		(void*)&applesmc_dmi_data[3]},
 	{ applesmc_dmi_match, "Apple MacPro2", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
-		(void*)&applesmc_dmi_data[3]},
+		(void*)&applesmc_dmi_data[4]},
 	{ .ident = NULL }
 };
 
