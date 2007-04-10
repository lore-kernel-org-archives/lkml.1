Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXDJVOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXDJVOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXDJVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:14:40 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:47047 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbXDJVOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:14:39 -0400
Date: Tue, 10 Apr 2007 23:13:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Markus Lidel <markus.lidel@shadowconnect.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 11/30] Use menuconfig objects - I2O
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102313090.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/message/i2o/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/message/i2o/Kconfig
+++ linux-2.6.21-rc5/drivers/message/i2o/Kconfig
@@ -1,8 +1,6 @@
 
-menu "I2O device support"
-
-config I2O
-	tristate "I2O support"
+menuconfig I2O
+	tristate "I2O device support"
 	depends on PCI
 	---help---
 	  The Intelligent Input/Output (I2O) architecture allows hardware
@@ -24,9 +22,10 @@ config I2O
 
 	  If unsure, say N.
 
+if I2O
+
 config I2O_LCT_NOTIFY_ON_CHANGES
 	bool "Enable LCT notification"
-	depends on I2O
 	default y
 	---help---
 	  Only say N here if you have a I2O controller from SUN. The SUN
@@ -38,7 +37,6 @@ config I2O_LCT_NOTIFY_ON_CHANGES
 
 config I2O_EXT_ADAPTEC
 	bool "Enable Adaptec extensions"
-	depends on I2O
 	default y
 	---help---
 	  Say Y for support of raidutils for Adaptec I2O controllers. You also
@@ -56,7 +54,6 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on I2O
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
@@ -77,7 +74,6 @@ config I2O_CONFIG_OLD_IOCTL
 
 config I2O_BUS
 	tristate "I2O Bus Adapter OSM"
-	depends on I2O
 	---help---
 	  Include support for the I2O Bus Adapter OSM. The Bus Adapter OSM
 	  provides access to the busses on the I2O controller. The main purpose
@@ -88,7 +84,7 @@ config I2O_BUS
 
 config I2O_BLOCK
 	tristate "I2O Block OSM"
-	depends on I2O && BLOCK
+	depends on BLOCK
 	---help---
 	  Include support for the I2O Block OSM. The Block OSM presents disk
 	  and other structured block devices to the operating system. If you
@@ -101,7 +97,7 @@ config I2O_BLOCK
 
 config I2O_SCSI
 	tristate "I2O SCSI OSM"
-	depends on I2O && SCSI
+	depends on SCSI
 	---help---
 	  Allows direct SCSI access to SCSI devices on a SCSI or FibreChannel
 	  I2O controller. You can use both the SCSI and Block OSM together if
@@ -113,7 +109,6 @@ config I2O_SCSI
 
 config I2O_PROC
 	tristate "I2O /proc support"
-	depends on I2O
 	---help---
 	  If you say Y here and to "/proc file system support", you will be
 	  able to read I2O related information from the virtual directory
@@ -122,5 +117,4 @@ config I2O_PROC
 	  To compile this support as a module, choose M here: the
 	  module will be called i2o_proc.
 
-endmenu
-
+endif # I2O
#<EOF>
