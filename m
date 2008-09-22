Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYIVOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYIVOXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYIVOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:23:28 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:50578 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYIVOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:23:27 -0400
Message-ID: <48D7A9F9.50502@euromail.se>
Date: Mon, 22 Sep 2008 16:21:45 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: akpm@osdl.org, Nicolas Boichat <nicolas@boichat.ch>,
       lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for Macbook Pro 4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.94
X-Scan-Result: No virus found in message 1KhmJS-0004gI-3y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KhmJS-0004gI-3y 9195aa331755e1dfd5d69579ebad2028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature sensor support for the Macbook Pro 4.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b57bd82..631d31c 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -107,6 +107,9 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 7: Macbook Air */
 	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TC0P", "TCFP",
 	  "TTF0", "TW0P", "Th0H", "Tp0P", "TpFP", "Ts0P", "Ts0S", NULL },
+/* Set 8: Macbook Pro 4,1 (Penryn) */
+	{ "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P", "Th0H",
+	  "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1264,6 +1267,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 /* MacBook Air: accelerometer, backlight and temperature set 7 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
+/* MacBook Pro 4: accelerometer, backlight and temperature set 8 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1273,6 +1278,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		(void*)&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
+		&applesmc_dmi_data[8]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
-- 
1.5.6.3

