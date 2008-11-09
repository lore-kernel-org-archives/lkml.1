Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYKIPvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYKIPvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 10:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbYKIPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 10:51:26 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:46741 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbYKIPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 10:51:25 -0500
Message-ID: <491706C3.6080105@euromail.se>
Date: Sun, 09 Nov 2008 16:50:27 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for iMac 6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KzCYw-0000cz-5K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KzCYw-0000cz-5K c8e367cb653d3ad4335aacfe9100b940
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature sensor support for iMac 6.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Caleb Hyde <caleb.hyde@gmail.com>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 488e45c..10977b3 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -128,6 +128,9 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 13: iMac 8,1 */
 	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
 	  "TL0P", "TO0P", "TW0P", "Tm0P", "Tp0P", NULL },
+/* Set 14: iMac 6,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
+	  "TO0P", "Tp0P", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1296,6 +1299,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
 /* iMac 8: light sensor only, temperature set 13 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
+/* iMac 6: light sensor only, temperature set 14 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1353,6 +1358,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
 		&applesmc_dmi_data[13]},
+	{ applesmc_dmi_match, "Apple iMac 6", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac6") },
+		&applesmc_dmi_data[14]},
 	{ applesmc_dmi_match, "Apple iMac 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
-- 
1.5.6.3

