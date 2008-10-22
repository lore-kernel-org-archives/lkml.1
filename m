Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYJVQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYJVQRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYJVQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:17:16 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:41606 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbYJVQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:17:15 -0400
Message-ID: <48FF51C7.7020103@euromail.se>
Date: Wed, 22 Oct 2008 18:16:07 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: akpm@osdl.org, Nicolas Boichat <nicolas@boichat.ch>,
       lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwmon: applesmc: Add support for iMac 5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KsgNz-0007Ie-91.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KsgNz-0007Ie-91 ccc3045fd16d4714c6a30a732ef49619
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature sensor support for iMac 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Ricky Campbell <johnrcampbell@gmail.com>
---
 drivers/hwmon/applesmc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index bc011da..80d545d 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -116,6 +116,8 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 9: Macbook Pro 3,1 (Santa Rosa) */
 	{ "TALP", "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P",
 	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
+/* Set 10: iMac 5,1 */
+	{ "TA0P", "TC0D", "TC0P", "TG0D", "TH0P", "TO0P", "Tm0P", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1276,6 +1278,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 8 },
 /* MacBook Pro 3: accelerometer, backlight and temperature set 9 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
+/* iMac 5: light sensor only, temperature set 10 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1317,6 +1321,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
+		&applesmc_dmi_data[10]},
 	{ applesmc_dmi_match, "Apple iMac", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
-- 
1.5.6.3

