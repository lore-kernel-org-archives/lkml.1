Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYIWRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYIWRcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYIWRcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:32:10 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:35279 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbYIWRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:32:09 -0400
Message-ID: <48D927B3.5000207@euromail.se>
Date: Tue, 23 Sep 2008 19:30:27 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: akpm@osdl.org, Nicolas Boichat <nicolas@boichat.ch>,
       lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for Macbook Pro 3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.94
X-Scan-Result: No virus found in message 1KiBjB-0004gg-4Y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KiBjB-0004gg-4Y 34f3dbce073e91599d043c3581ff4e63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature sensor support for Macbook Pro 3.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 631d31c..321dc82 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -110,6 +110,9 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 8: Macbook Pro 4,1 (Penryn) */
 	{ "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P", "Th0H",
 	  "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
+/* Set 9: Macbook Pro 3,1 (Santa Rosa) */
+	{ "TALP", "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P",
+	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1269,6 +1272,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
 /* MacBook Pro 4: accelerometer, backlight and temperature set 8 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
+/* MacBook Pro 3: accelerometer, backlight and temperature set 9 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1278,6 +1283,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		(void*)&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
+		&applesmc_dmi_data[9]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
-- 
1.5.6.3

