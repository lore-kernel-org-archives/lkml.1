Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYJPH3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYJPH3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJPH2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:28:55 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:37558 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJPH2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:28:54 -0400
Date: Thu, 16 Oct 2008 09:28:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
Message-ID: <Pine.LNX.4.64.0810160927340.25608@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With m68k allmodconfig, I get:

| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
| drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
| drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
| drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'

and

| drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
| drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
| drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
| drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
| drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Include <linux/io.h> to get access to the I/O API.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/rtc/rtc-ds1286.c |    1 +
 drivers/rtc/rtc-m48t35.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/ds1286.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -18,6 +18,7 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
