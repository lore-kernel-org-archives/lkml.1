Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZKIRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZKIRxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZKIRxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:53:35 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:51398 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZKIRxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:53:34 -0500
Date: Mon, 9 Nov 2009 18:53:35 +0100
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: [PATCH 2/2] acerhdf: Added new BIOS versions
Message-Id: <20091109185335.26836808.peter@piie.net>
In-Reply-To: <20091109185105.6028c057.peter@piie.net>
References: <20091109185105.6028c057.peter@piie.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added new BIOS versions for following netbooks: Acer 1410, Gateway LT31,
Packard Bell DOA150. As the Gateway LT31 machines have different
register values for setting and checking the off-state, the "cmd_off"
variable has been splitted up to "cmd_off" and "chk_off".

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/platform/x86/acerhdf.c |   63 +++++++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index ab64522..d8b4229 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.18"
+#define DRV_VER "0.5.20"
 
 /*
  * According to the Atom N270 datasheet,
@@ -112,12 +112,14 @@ module_param_string(force_product, force_product, 16, 0);
 MODULE_PARM_DESC(force_product, "Force BIOS product and omit BIOS check");
 
 /*
- * cmd_off: to switch the fan completely off / to check if the fan is off
+ * cmd_off: to switch the fan completely off
+ * chk_off: to check if the fan is off
  *	cmd_auto: to set the BIOS in control of the fan. The BIOS regulates then
  *		the fan speed depending on the temperature
  */
 struct fancmd {
 	u8 cmd_off;
+	u8 chk_off;
 	u8 cmd_auto;
 };
 
@@ -134,32 +136,41 @@ struct bios_settings_t {
 /* Register addresses and values for different BIOS versions */
 static const struct bios_settings_t bios_tbl[] = {
 	/* AOA110 */
-	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	/* AOA150 */
-	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	/* Acer 1410 */
+	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* special BIOS / other */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Gateway         ", "LT31            ", "v1.3103 ", 0x55, 0x58,
+		{0x10, 0x0f, 0x00} },
+	{"Gateway         ", "LT31            ", "v1.3201 ", 0x55, 0x58,
+		{0x10, 0x0f, 0x00} },
+	{"Gateway         ", "LT31            ", "v1.3302 ", 0x55, 0x58,
+		{0x10, 0x0f, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	/* pewpew-terminator */
-	{"", "", "", 0, 0, {0, 0} }
+	{"", "", "", 0, 0, {0, 0, 0} }
 };
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
@@ -183,7 +194,7 @@ static int acerhdf_get_fanstate(int *state)
 	if (ec_read(bios_cfg->fanreg, &fan))
 		return -EINVAL;
 
-	if (fan != bios_cfg->cmd.cmd_off)
+	if (fan != bios_cfg->cmd.chk_off)
 		*state = ACERHDF_FAN_AUTO;
 	else
 		*state = ACERHDF_FAN_OFF;
-- 
1.6.5.2

