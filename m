Return-Path: <linux-kernel-owner+w=401wt.eu-S936078AbXJSSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078AbXJSSy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765695AbXJSSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:54:49 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:50700 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764577AbXJSSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:54:48 -0400
Message-ID: <4718FCE6.204@freemail.hu>
Date: Fri, 19 Oct 2007 20:52:22 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: [PATCH 1/3] leds-clevo-mail: export i8042_command()
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Export the i8042_command() function which manages the mutual exclusion
with the help of the i8042_lock spinlock. This lets possible to use the
i8042 hardware safely from other part of the kernel, too.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.23.orig/drivers/input/serio/i8042.c linux-2.6.23/drivers/input/serio/i8042.c
--- linux-2.6.23.orig/drivers/input/serio/i8042.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/input/serio/i8042.c	2007-10-18 06:52:12.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/rcupdate.h>
 #include <linux/platform_device.h>
+#include <linux/i8042.h>

 #include <asm/io.h>

@@ -208,7 +209,7 @@ static int __i8042_command(unsigned char
 	return 0;
 }

-static int i8042_command(unsigned char *param, int command)
+int i8042_command(unsigned char *param, int command)
 {
 	unsigned long flags;
 	int retval;
@@ -219,6 +220,7 @@ static int i8042_command(unsigned char *

 	return retval;
 }
+EXPORT_SYMBOL(i8042_command);

 /*
  * i8042_kbd_write() sends a byte out through the keyboard interface.
diff -uprN linux-2.6.23.orig/include/linux/i8042.h linux-2.6.23/include/linux/i8042.h
--- linux-2.6.23.orig/include/linux/i8042.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.23/include/linux/i8042.h	2007-10-18 06:53:29.000000000 +0200
@@ -0,0 +1,9 @@
+/* There is already a header file linux/drivers/input/serio/i8042.h, so
+ * using the _LINUX prefix here as this is the <linux/i8042.h> file.
+ */
+#ifndef _LINUX_I8042_H
+#define _LINUX_I8402_H
+
+int i8042_command(unsigned char *param, int command);
+
+#endif
