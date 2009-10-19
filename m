Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZJSIUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZJSIUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZJSIUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:20:04 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.43]:60084 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZJSIUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:20:03 -0400
Date: Mon, 19 Oct 2009 10:21:16 +0200
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
Subject: [Patch] acerhdf: Return temperature in milidegree
Message-Id: <20091019102116.222ff9c3.peter@piie.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Df-Sender: peter@piie.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Boris,

what do you think about this patch?

regards,
--peter

--

Return temperature in milidegree instead of degree, as userspace
applications expect the temperature in milidegree.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>

---
 drivers/platform/x86/acerhdf.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index b713c6e..a588f96 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.17"
+#define DRV_VER "0.5.18"
 
 /*
  * According to the Atom N270 datasheet,
@@ -61,7 +61,7 @@
  * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
  * assume 89°C is critical temperature.
  */
-#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_TEMP_CRIT 89000
 #define ACERHDF_FAN_OFF 0
 #define ACERHDF_FAN_AUTO 1
 
@@ -69,7 +69,7 @@
  * No matter what value the user puts into the fanon variable, turn on the fan
  * at 80 degree Celsius to prevent hardware damage
  */
-#define ACERHDF_MAX_FANON 80
+#define ACERHDF_MAX_FANON 80000
 
 /*
  * Maximum interval between two temperature checks is 15 seconds, as the die
@@ -85,8 +85,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 63;
-static unsigned int fanoff = 58;
+static unsigned int fanon = 63000;
+static unsigned int fanoff = 58000;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
@@ -171,7 +171,7 @@ static int acerhdf_get_temp(int *temp)
 	if (ec_read(bios_cfg->tempreg, &read_temp))
 		return -EINVAL;
 
-	*temp = read_temp;
+	*temp = read_temp * 1000;
 
 	return 0;
 }
-- 
1.6.4.4
