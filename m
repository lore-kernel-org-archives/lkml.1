Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYIQWYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYIQWYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbYIQWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:24:38 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60676 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbYIQWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:24:37 -0400
Message-ID: <48D183A3.9080900@euromail.se>
Date: Thu, 18 Sep 2008 00:24:35 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] hwmon: applesmc: Add support for Macbook Air
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1Kg5Rs-00055g-3Q.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Kg5Rs-00055g-3Q f41cb792f0e2b7383d3f44827be70c60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer, backlight and temperature sensor support
for the Macbook Air.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index de696b6..b57bd82 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -104,6 +104,9 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 6: Macbook3 set */
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TTF0", "TW0P", "Th0H",
 	  "Th0S", "Th1H", NULL },
+/* Set 7: Macbook Air */
+	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TC0P", "TCFP",
+	  "TTF0", "TW0P", "Th0H", "Tp0P", "TpFP", "Ts0P", "Ts0S", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1259,11 +1262,17 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
 /* MacBook3: accelerometer and temperature set 6 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
+/* MacBook Air: accelerometer, backlight and temperature set 7 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
+		(void*)&applesmc_dmi_data[7]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
-- 
1.5.4.3

