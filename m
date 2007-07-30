Return-Path: <linux-kernel-owner+w=401wt.eu-S939747AbXG3URT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939747AbXG3URT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935609AbXG3URJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:17:09 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42155
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935785AbXG3URI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:17:08 -0400
Content-Disposition: inline
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ssb: Watchdog support
Date: Mon, 30 Jul 2007 22:16:31 +0200
User-Agent: KMail/1.9.6
Cc: Felix Fietkau <nbd@openwrt.org>, Aurelien Jarno <aurelien@aurel32.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707302216.31516.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below against 2.6.23-rc1-mm1 adds a new function to control
the watchdog. It originally comes from the OpenWrt patches.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

--- a/drivers/ssb/driver_chipcommon.c	2007-07-30 19:59:02.000000000 +0200
+++ b/drivers/ssb/driver_chipcommon.c	2007-07-30 20:55:54.000000000 +0200
@@ -344,6 +344,13 @@
 	}
 }
 
+/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
+void
+ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
+{
+	/* instant NMI */
+	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
+}
 
 #ifdef CONFIG_SSB_SERIAL
 int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
--- a/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-30 19:59:02.000000000 +0200
+++ b/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-30 20:55:54.000000000 +0200
@@ -380,6 +380,9 @@
 extern void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 				     enum ssb_clkmode mode);
 
+extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, 
+					  u32 ticks);
+
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 				  struct ssb_serial_port *ports);
