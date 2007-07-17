Return-Path: <linux-kernel-owner+w=401wt.eu-S935638AbXGQSMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638AbXGQSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXGQSMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:12:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56254 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935532AbXGQSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:12:39 -0400
Message-ID: <469D0690.9020408@freemail.hu>
Date: Tue, 17 Jul 2007 20:12:32 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu; rv:1.7.12) Gecko/20050920
X-Accept-Language: hu, en, de
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 1/3] leds-clevo-mail: export i8042_command()
References: <469C976B.3030206@freemail.hu>
In-Reply-To: <469C976B.3030206@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Export the i8042_command() function which manages the mutual exclusion
with the help of the i8042_lock spinlock. This lets possible to use the
i8042 hardware safely from other part of the kernel, too.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.22.orig/drivers/input/serio/i8042.c linux-2.6.22/drivers/input/serio/i8042.c
--- linux-2.6.22.orig/drivers/input/serio/i8042.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/drivers/input/serio/i8042.c	2007-07-17 17:03:54.000000000 +0200
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
diff -uprN linux-2.6.22.orig/include/linux/i8042.h linux-2.6.22/include/linux/i8042.h
--- linux-2.6.22.orig/include/linux/i8042.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.22/include/linux/i8042.h	2007-07-17 10:52:13.000000000 +0200
@@ -0,0 +1,10 @@
+
+/* There is already a header file linux/drivers/input/serio/i8042.h, so
+ * using the _LINUX prefix here as this is the <linux/i8042.h> file.
+ */
+#ifndef _LINUX_I8042_H
+#define _LINUX_I8402_H
+
+int i8042_command(unsigned char *param, int command);
+
+#endif
