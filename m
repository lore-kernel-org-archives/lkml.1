Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbXJMMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbXJMMgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbXJMMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:35:35 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:54107 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbXJMMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:35:30 -0400
Message-Id: <20071013123414.160200918@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:30 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Stefano Brivio <st3@riseup.net>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [patch 7/8] b43 wireless needs <linux/io.h>
Content-Disposition: inline; filename=b43-needs-linux-io.h.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

b43 wireless needs <linux/io.h>

linux/drivers/net/wireless/b43/pio.h: In function 'b43_pio_write':
linux/drivers/net/wireless/b43/pio.h:89: error: implicit declaration of function 'mmiowb'

linux/drivers/net/wireless/b43/phy.c: In function 'b43_phy_write':
linux/drivers/net/wireless/b43/phy.c:301: error: implicit declaration of function 'mmiowb'

linuxdrivers/net/wireless/b43/sysfs.c: In function 'b43_attr_interfmode_store':
linuxdrivers/net/wireless/b43/sysfs.c:147: error: implicit declaration of function 'mmiowb'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/b43/phy.c   |    1 +
 drivers/net/wireless/b43/pio.h   |    1 +
 drivers/net/wireless/b43/sysfs.c |    5 +++--
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -26,6 +26,7 @@
 */
 
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/types.h>
 
 #include "b43.h"
--- a/drivers/net/wireless/b43/pio.h
+++ b/drivers/net/wireless/b43/pio.h
@@ -4,6 +4,7 @@
 #include "b43.h"
 
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/list.h>
 #include <linux/skbuff.h>
 
--- a/drivers/net/wireless/b43/sysfs.c
+++ b/drivers/net/wireless/b43/sysfs.c
@@ -23,13 +23,14 @@
 
 */
 
+#include <linux/capability.h>
+#include <linux/io.h>
+
 #include "b43.h"
 #include "sysfs.h"
 #include "main.h"
 #include "phy.h"
 
-#include <linux/capability.h>
-
 #define GENERIC_FILESIZE	64
 
 static int get_integer(const char *buf, size_t count)

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

