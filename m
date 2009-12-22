Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZLVVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZLVVJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZLVVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:09:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58523 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZLVVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:09:33 -0500
Message-ID: <4B312761.7080001@oracle.com>
Date: Tue, 22 Dec 2009 12:09:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@collabora.co.uk>
Subject: [PATCH] MFGPT: move clocksource menu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B313562.0127:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move the CS5535 MFGPT hrtimer kconfig option to be with the
other MFGPT options.  This makes it easier to find and also
removes it from the main "Device Drivers" menu, where it should
not have been.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/Kconfig             |    2 --
 drivers/clocksource/Kconfig |    9 ---------
 drivers/misc/Kconfig        |    9 +++++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

--- lnx-2633-rc1.orig/drivers/clocksource/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-config CS5535_CLOCK_EVENT_SRC
-	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
-	help
-	  This driver provides a clock event source based on the MFGPT
-	  timer(s) in the CS5535 and CS5536 companion chips.
-	  MFGPTs have a better resolution and max interval than the
-	  generic PIT, and are suitable for use as high-res timers.
-
--- lnx-2633-rc1.orig/drivers/misc/Kconfig
+++ lnx-2633-rc1/drivers/misc/Kconfig
@@ -212,6 +212,15 @@ config CS5535_MFGPT_DEFAULT_IRQ
 	  want to use a different IRQ by default.  This is here for
 	  architectures to set as necessary.
 
+config CS5535_CLOCK_EVENT_SRC
+	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
+	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	help
+	  This driver provides a clock event source based on the MFGPT
+	  timer(s) in the CS5535 and CS5536 companion chips.
+	  MFGPTs have a better resolution and max interval than the
+	  generic PIT, and are suitable for use as high-res timers.
+
 config HP_ILO
 	tristate "Channel interface driver for HP iLO/iLO2 processor"
 	depends on PCI
--- lnx-2633-rc1.orig/drivers/Kconfig
+++ lnx-2633-rc1/drivers/Kconfig
@@ -96,8 +96,6 @@ source "drivers/edac/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
-source "drivers/clocksource/Kconfig"
-
 source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
