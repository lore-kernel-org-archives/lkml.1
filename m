Return-Path: <linux-kernel-owner+w=401wt.eu-S1161326AbXD3LhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161326AbXD3LhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXD3LhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:37:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42291 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161218AbXD3LhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:37:22 -0400
Date: Mon, 30 Apr 2007 13:36:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/36] Use menuconfig objects II - LED
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301335580.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/leds/Kconfig |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/leds/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/leds/Kconfig
@@ -1,7 +1,5 @@
 
-menu "LED devices"
-
-config NEW_LEDS
+menuconfig NEW_LEDS
 	bool "LED Support"
 	help
 	  Say Y to enable Linux LED support.  This allows control of supported
@@ -10,9 +8,10 @@ config NEW_LEDS
 	  This is not related to standard keyboard LEDs which are controlled
 	  via the input system.
 
+if NEW_LEDS
+
 config LEDS_CLASS
 	tristate "LED Class Support"
-	depends on NEW_LEDS
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
@@ -106,7 +105,6 @@ comment "LED Triggers"
 
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
-	depends on NEW_LEDS
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
@@ -135,5 +133,4 @@ config LEDS_TRIGGER_HEARTBEAT
 	  load average.
 	  If unsure, say Y.
 
-endmenu
-
+endif # NEW_LEDS
