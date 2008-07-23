Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYGWMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYGWMCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYGWMCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:02:43 -0400
Received: from [81.174.68.18] ([81.174.68.18]:28755 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbYGWMCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:02:42 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 08:02:42 EDT
Subject: [PATCH] Support for Intel iMac in applesmc
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: mactel-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Unbit
Date: Wed, 23 Jul 2008 13:55:35 +0200
Message-Id: <1216814135.5834.9.camel@sirius>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, this patch (2.6.26 vanilla) add supports for fans and
temperature sensors on intel iMac.

Tested on iMac 24" 2.8ghz (iMac8,1), it supports the following sensors:

cpu A
ambient
gpu
gpu diode
gpu heatsink
hd bay 1
memory controller
optical drive
power

Signed-off-by: Roberto De Ioris <roberto@unbit.it>
---
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index aacc0c4..bc616c3 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -98,6 +98,8 @@ static const char* temperature_sensors_sets[][36] = {
          "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P",
"TM0S",
          "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S",
"TM9P",
          "TM9S", "TN0H", "TS0C", NULL },
+/* Set 5: iMac */
+       { "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P",
"TO0P", "Tp0C", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1223,6 +1225,8 @@ static __initdata struct dmi_match_data
applesmc_dmi_data[] = {
        { .accelerometer = 0, .light = 0, .temperature_set = 3 },
 /* MacPro: temperature set 4 */
        { .accelerometer = 0, .light = 0, .temperature_set = 4 },
+/* iMac: temperature set 5 */
+       { .accelerometer = 0, .light = 0, .temperature_set = 5 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1248,6 +1252,10 @@ static __initdata struct dmi_system_id
applesmc_whitelist[] = {
          DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
          DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
                (void*)&applesmc_dmi_data[4]},
+       { applesmc_dmi_match, "Apple iMac", {
+         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+         DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
+               (void*)&applesmc_dmi_data[5]},
        { .ident = NULL }
 };


