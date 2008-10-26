Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYJZSvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYJZSvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYJZSvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:51:36 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:54306 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYJZSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:51:36 -0400
Date: Sun, 26 Oct 2008 19:51:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH/RESEND] m68k: Disable Amiga serial console support if modular
Message-ID: <Pine.LNX.4.64.0810261950350.15317@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_AMIGA_BUILTIN_SERIAL=m, I get the following warnings:

| drivers/char/amiserial.c: At top level:
| drivers/char/amiserial.c:2138: warning: data definition has no type or storage class
| drivers/char/amiserial.c:2138: warning: type defaults to 'int' in declaration of 'console_initcall'
| drivers/char/amiserial.c:2138: warning: parameter names (without types) in function declaration
| drivers/char/amiserial.c:2134: warning: 'amiserial_console_init' defined but not used

Apparently console_initcall() is not defined in the modular case.

Disable serial console support if the driver is modular.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/amiserial.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -2071,12 +2071,13 @@ module_init(rs_init)
 module_exit(rs_exit)
 
 
+#if defined(CONFIG_SERIAL_CONSOLE) && !defined(MODULE)
+
 /*
  * ------------------------------------------------------------
  * Serial console driver
  * ------------------------------------------------------------
  */
-#ifdef CONFIG_SERIAL_CONSOLE
 
 static void amiga_serial_putc(char c)
 {
@@ -2130,6 +2131,7 @@ static int __init amiserial_console_init
 	return 0;
 }
 console_initcall(amiserial_console_init);
-#endif
+
+#endif /* CONFIG_SERIAL_CONSOLE && !MODULE */
 
 MODULE_LICENSE("GPL");

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
