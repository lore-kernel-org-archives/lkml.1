Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYICHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYICHTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYICHSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:17 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:53497 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYICHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:12 -0400
Message-Id: <20080903071741.718541648@mail.of.borg>
References: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:45 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/8] m68k: Disable Amiga serial console support if modular
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
@@ -2077,12 +2077,13 @@ module_init(rs_init)
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
@@ -2136,6 +2137,7 @@ static int __init amiserial_console_init
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

