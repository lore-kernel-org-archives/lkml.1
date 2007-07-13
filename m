Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXGMWUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXGMWUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXGMWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:20:38 -0400
Received: from mailfe06.tele2.it ([212.247.154.173]:50232 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751782AbXGMWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:20:38 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 18:20:37 EDT
X-Cloudmark-Score: 0.000000 []
Message-ID: <4697ECA1.4070200@inwind.it>
Date: Fri, 13 Jul 2007 23:20:33 +0200
From: federico ferri <xaero@inwind.it>
User-Agent: Thunderbird 2.0.0.0 (X11/20070603)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] change SysRq keycode for systems without SysRq key
Content-Type: multipart/mixed;
 boundary="------------040605050708090405080100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040605050708090405080100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

this patch adds an entry in Kconfig after 'config MAGIC_SYSRQ' which
asks for a different keycode (replacing also KEY_SYSRQ with
CONFIG_MAGIC_SYSRQ_KEYCODE in char/keyboard.c)

it was tested on some USB keyboards (Microsoft and Apple USB keyboards,
and it works)

I sumbitted this patch two years ago, but it was ignored.

I think this patch is very important, even to a non-developer (SysRq-k
is very helpful when testing unstable software/drivers)

-- 
federico ferri

--------------040605050708090405080100
Content-Type: text/x-patch;
 name="ff-magic_sysrq_keycode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ff-magic_sysrq_keycode.patch"

diff -uprN linux.orig/drivers/char/keyboard.c linux/drivers/char/keyboard.c
--- linux.orig/drivers/char/keyboard.c	2005-07-09 21:47:50.000000000 +0200
+++ linux/drivers/char/keyboard.c	2005-07-10 14:42:34.000000000 +0200
@@ -1081,7 +1087,7 @@ static void kbd_keycode(unsigned int key
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
-	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
+	if (keycode == CONFIG_MAGIC_SYSRQ_KEYCODE && (sysrq_down || (down == 1 && sysrq_alt))) {
 		sysrq_down = down;
 		return;
 	}
diff -uprN linux.orig/lib/Kconfig.debug linux/lib/Kconfig.debug
--- linux.orig/lib/Kconfig.debug	2005-07-09 21:47:22.000000000 +0200
+++ linux/lib/Kconfig.debug	2005-07-09 21:50:44.000000000 +0200
@@ -28,6 +28,16 @@ config MAGIC_SYSRQ
 	  send a BREAK and then within 5 seconds a command keypress. The
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
+	  
+config MAGIC_SYSRQ_KEYCODE
+	int
+	prompt "Change SysRq key-code" if MAGIC_SYSRQ
+	default 99
+	depends on MAGIC_SYSRQ
+	help
+	  If your keyboard doesn't have a SysRq key (also labeled PrintScr),
+	  you can specify another keycode which should act as SysRq.
+	  Default is 99 (KEY_SYSRQ).
+	  You can find this number using programs like evtest, or (maybe)
+	  showkey.
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL

--------------040605050708090405080100--
