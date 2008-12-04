Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYLDHiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYLDHiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYLDHhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:37:51 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45258 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbYLDHhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:37:50 -0500
Message-ID: <49378885.90401@euromail.se>
Date: Thu, 04 Dec 2008 08:36:37 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for MacBook Air 2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L88mO-0002fL-9A.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1L88mO-0002fL-9A ac240bc4289a17244c5019f4c643689c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add temperature sensor support for MacBook Air 2.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 086c2a5..dca47a5 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -131,6 +131,10 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 14: iMac 6,1 */
 	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
 	  "TO0P", "Tp0P", NULL },
+/* Set 15: MacBook Air 2,1 */
+	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TN0D", "TTF0",
+	  "TV0P", "TVFP", "TW0P", "Th0P", "Tp0P", "Tp1P", "TpFP", "Ts0P",
+	  "Ts0S", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1301,11 +1305,17 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
 /* iMac 6: light sensor only, temperature set 14 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
+/* MacBook Air 2,1: accelerometer, backlight and temperature set 15 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air 2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2") },
+		&applesmc_dmi_data[15]},
 	{ applesmc_dmi_match, "Apple MacBook Air", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
