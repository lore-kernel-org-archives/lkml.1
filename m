Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYG2PIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYG2PIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYG2PH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:07:59 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:42319 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752483AbYG2PH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:07:59 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 11:07:58 EDT
Message-ID: <488F323E.6040403@boichat.ch>
Date: Tue, 29 Jul 2008 23:07:42 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 2.0.0.14 (X11/20080625)
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: roberto@unbit.it, mactel-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "guilherme m. schroeder" <guilherme.m.schroeder@gmail.com>
Subject: [PATCH 2/2] applesmc: add support for Macbook v3.
References: <1216814135.5834.9.camel@sirius> <488F30F7.4030804@boichat.ch>
In-Reply-To: <488F30F7.4030804@boichat.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3623145900843400352
X-Ovh-Remote: 220.255.224.226 (bb220-255-224-226.singnet.com.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches adds support for Macbook v3 (sensors and accelerometer).

From: guilherme m. schroeder <guilherme.m.schroeder@gmail.com>
Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
---
 drivers/hwmon/applesmc.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 52d842b..b06b8e0 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -101,6 +101,9 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 5: iMac */
 	{ "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P", "TO0P",
 	  "Tp0C", NULL },
+/* Set 6: Macbook3 set */
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TTF0", "TW0P", "Th0H",
+	  "Th0S", "Th1H", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1228,6 +1231,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 /* iMac: temperature set 5 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
+/* MacBook3: accelerometer and temperature set 6 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1237,10 +1242,14 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
 		(void*)&applesmc_dmi_data[0]},
-	{ applesmc_dmi_match, "Apple MacBook", {
+	{ applesmc_dmi_match, "Apple MacBook (v2)", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
 		(void*)&applesmc_dmi_data[1]},
+	{ applesmc_dmi_match, "Apple MacBook (v3)", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
+		(void*)&applesmc_dmi_data[6]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },


