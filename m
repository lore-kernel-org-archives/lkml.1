Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbYD0DKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbYD0DKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYD0DKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:10:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50778 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYD0DKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:10:39 -0400
Date: Sun, 27 Apr 2008 05:10:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [3/3] Re: Colored Kernel Output for 2.6.25
In-Reply-To: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0804270510010.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 872d296f6521ecdcbddd3ffe74d7565abfa8c3fa
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Apr 27 03:55:17 2008 +0200

    Colored kernel message output (3/3)
    
    Ref-From: Miguel Botón
    
    I modified your lastest patch a little bit so now you can set the
    message color for each log level in the kernel config.
    
    References: http://lkml.org/lkml/2007/10/6/105
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
---
 drivers/char/Kconfig |   86 +++++++++++++++++++++++++++++++++++------
 drivers/char/vt.c    |   16 ++++----
 2 files changed, 81 insertions(+), 21 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3f5877e..600c75a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -58,28 +58,20 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
-config VT_CKO
+menuconfig VT_CKO
 	bool "Colored kernel message output"
 	depends on VT_CONSOLE
 	---help---
 	This option enables kernel messages to be emitted in
 	colors other than the default.
+	You can also change the colors at run-time, or set them at boot-time
+	using the "vt.printk_color" option.
+
 	This option enlarges your kernel by approximately 1/2 KB.
 
 	If unsure, say N.
 
-config VT_PRINTK_COLOR
-	hex "Colored kernel message output"
-	range 0x00 0xFF
-	depends on VT_CKO
-	default 0x07
-	---help---
-	This option defines with which color kernel messages will be
-	printed to the console. This applies to all log levels.
-	You can change the colors at run-time, or set them at boot-time
-	using the "vt.printk_color" option.
-
-	The value you need to enter here is the value is composed
+	The value you need to enter is the value is composed
 	(OR-ed) of a foreground and a background color.
 
 	Foreground:
@@ -103,6 +95,74 @@ config VT_PRINTK_COLOR
 
 	For example, 0x1F would yield white on red.
 
+if VT_CKO
+
+config VT_PRINTK_EMERG_COLOR
+	hex 'Color for "emergency" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel emergency messages
+	will be printed to the console.
+
+config VT_PRINTK_ALERT_COLOR
+	hex 'Color for "alert" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel alert messages
+	will be printed to the console.
+
+config VT_PRINTK_CRIT_COLOR
+	hex 'Color for "critical" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color critical kernel messages
+	will be printed to the console.
+
+config VT_PRINTK_ERROR_COLOR
+	hex 'Color for "error" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel error messages
+	will be printed to the console.
+
+config VT_PRINTK_WARNING_COLOR
+	hex 'Color for "warning" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel warning messages
+	will be printed to the console.
+
+config VT_PRINTK_NOTICE_COLOR
+	hex 'Color for "notice" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel notices
+	will be printed to the console.
+
+config VT_PRINTK_INFO_COLOR
+	hex 'Color for "info" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color informational kernel messages
+	will be printed to the console.
+
+config VT_PRINTK_DEBUG_COLOR
+	hex 'Color for "debug" level'
+	range 0x00 0xFF
+	default 0x07
+	---help---
+	This option defines in which color kernel debugging messages
+	will be printed to the console.
+
+endif # VT_CKO
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 75ca0cf..a3f2ff3 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2395,14 +2395,14 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CKO
 static unsigned int printk_color[8] __read_mostly = {
-	CONFIG_VT_PRINTK_COLOR, /* KERN_EMERG */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_ALERT */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_CRIT */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_ERR */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_WARNING */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_NOTICE */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_INFO */
-	CONFIG_VT_PRINTK_COLOR, /* KERN_DEBUG */
+	CONFIG_VT_PRINTK_EMERG_COLOR,
+	CONFIG_VT_PRINTK_ALERT_COLOR,
+	CONFIG_VT_PRINTK_CRIT_COLOR,
+	CONFIG_VT_PRINTK_ERROR_COLOR,
+	CONFIG_VT_PRINTK_WARNING_COLOR,
+	CONFIG_VT_PRINTK_NOTICE_COLOR,
+	CONFIG_VT_PRINTK_INFO_COLOR,
+	CONFIG_VT_PRINTK_DEBUG_COLOR,
 };
 module_param_array(printk_color, uint, NULL, S_IRUGO | S_IWUSR);
 
