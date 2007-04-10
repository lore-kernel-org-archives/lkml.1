Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXDJVoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXDJVoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXDJVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:44:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58120 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbXDJVns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:43:48 -0400
Date: Tue, 10 Apr 2007 23:43:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/30] Use menuconfig objects - W1
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102342480.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/w1/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/w1/Kconfig
+++ linux-2.6.21-rc5/drivers/w1/Kconfig
@@ -1,7 +1,5 @@
-menu "Dallas's 1-wire bus"
-
-config W1
-	tristate "Dallas's 1-wire support"
+menuconfig W1
+	tristate "Dallas's 1-wire bus support"
 	---help---
 	  Dallas' 1-wire bus is useful to connect slow 1-pin devices
 	  such as iButtons and thermal sensors.
@@ -11,8 +9,10 @@ config W1
 	  This W1 support can also be built as a module.  If so, the module
 	  will be called wire.ko.
 
+if W1
+
 config W1_CON
-	depends on CONNECTOR && W1
+	depends on CONNECTOR
 	bool "Userspace communication over connector"
 	default y
 	--- help ---
@@ -26,4 +26,4 @@ config W1_CON
 source drivers/w1/masters/Kconfig
 source drivers/w1/slaves/Kconfig
 
-endmenu
+endif # W1
Index: linux-2.6.21-rc5/drivers/w1/masters/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/w1/masters/Kconfig
+++ linux-2.6.21-rc5/drivers/w1/masters/Kconfig
@@ -3,11 +3,10 @@
 #
 
 menu "1-wire Bus Masters"
-	depends on W1
 
 config W1_MASTER_MATROX
 	tristate "Matrox G400 transport layer for 1-wire"
-	depends on W1 && PCI
+	depends on PCI
 	help
 	  Say Y here if you want to communicate with your 1-wire devices
 	  using Matrox's G400 GPIO pins.
@@ -17,7 +16,7 @@ config W1_MASTER_MATROX
 
 config W1_MASTER_DS2490
 	tristate "DS2490 USB <-> W1 transport layer for 1-wire"
-  	depends on W1 && USB
+  	depends on USB
   	help
 	  Say Y here if you want to have a driver for DS2490 based USB <-> W1 bridges,
 	  for example DS9490*.
@@ -27,7 +26,7 @@ config W1_MASTER_DS2490
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
-	depends on I2C && W1 && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Maxim DS2482
 	  I2C to 1-Wire bridge.
Index: linux-2.6.21-rc5/drivers/w1/slaves/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/w1/slaves/Kconfig
+++ linux-2.6.21-rc5/drivers/w1/slaves/Kconfig
@@ -3,25 +3,21 @@
 #
 
 menu "1-wire Slaves"
-	depends on W1
 
 config W1_SLAVE_THERM
 	tristate "Thermal family implementation"
-	depends on W1
 	help
 	  Say Y here if you want to connect 1-wire thermal sensors to your
 	  wire.
 
 config W1_SLAVE_SMEM
 	tristate "Simple 64bit memory family implementation"
-	depends on W1
 	help
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
 config W1_SLAVE_DS2433
 	tristate "4kb EEPROM family support (DS2433)"
-	depends on W1
 	help
 	  Say Y here if you want to use a 1-wire
 	  4kb EEPROM family device (DS2433).
#<EOF>
