Return-Path: <linux-kernel-owner+w=401wt.eu-S1030892AbXD3LXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbXD3LXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031014AbXD3LXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:23:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51340 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030892AbXD3LXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:23:20 -0400
Date: Mon, 30 Apr 2007 13:21:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Vladimir P. Lebedev" <vladimir.p.lebedev@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 03/36] Use menuconfig objects II - battery
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301320520.29151@yvahk01.tjqt.qr>
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
 drivers/battery/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/battery/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/battery/Kconfig
@@ -1,7 +1,5 @@
 
-menu "Battery devices"
-
-config BATTERY
+menuconfig BATTERY
 	tristate "Battery class support"
 	select EXTERNAL_POWER
 	help
@@ -9,16 +7,18 @@ config BATTERY
 	  monitoring by userspace via sysfs (if available) and/or APM
 	  kernel interface (if selected below).
 
+if BATTERY
+
 config APM_POWER
 	tristate "APM emulation for class batteries"
-	depends on BATTERY && APM_EMULATION
+	depends on APM_EMULATION
 	help
 	  Say Y here to enable support APM status emulation using
 	  battery class devices.
 
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
-	depends on BATTERY && W1
+	depends on W1
 	select W1_SLAVE_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
@@ -30,4 +30,4 @@ config BATTERY_PMU
 	  Say Y here to expose battery information on Apple machines
 	  through the generic battery class.
 
-endmenu
+endif # BATTERY
