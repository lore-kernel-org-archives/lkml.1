Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJMUJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJMUJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYJMUFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:53 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:53323 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYJMUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:40 -0400
Message-Id: <20081013195915.659336491@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:52 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 06/18] m68k: Disable Amiga serial console support if modular
Content-Disposition: inline; filename=amiga-amiserial-no-serial-console-if-modular.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

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
Any better alternative fix?

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

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

