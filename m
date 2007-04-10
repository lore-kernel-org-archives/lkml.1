Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXDJTXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXDJTXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXDJTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:23:30 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49676 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbXDJTX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:23:29 -0400
Date: Tue, 10 Apr 2007 21:22:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Len Brown <len.brown@intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 01/30] Use menuconfig objects - ACPI
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102119430.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/acpi/Kconfig
+++ linux-2.6.21-rc5/drivers/acpi/Kconfig
@@ -2,16 +2,12 @@
 # ACPI Configuration
 #
 
-menu "ACPI (Advanced Configuration and Power Interface) Support"
+menuconfig ACPI
+	bool "ACPI Support (Advanced Configuration and Power Interface) Support"
 	depends on !X86_NUMAQ
 	depends on !X86_VISWS
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
-	depends on PM
-
-config ACPI
-	bool "ACPI Support"
-	depends on IA64 || X86
 	depends on PCI
 	depends on PM
 	select PNP
@@ -49,7 +45,6 @@ if ACPI
 config ACPI_SLEEP
 	bool "Sleep States"
 	depends on X86 && (!SMP || SUSPEND_SMP)
-	depends on PM
 	default y
 	---help---
 	  This option adds support for ACPI suspend states. 
@@ -82,7 +77,6 @@ config ACPI_SLEEP_PROC_SLEEP
 
 config ACPI_PROCFS
 	bool "Procfs interface (deprecated)"
-	depends on ACPI
 	default y
 	---help---
 	  Procfs interface for ACPI is made optional for back-compatible.
@@ -367,7 +361,6 @@ config ACPI_CONTAINER
 
 config ACPI_HOTPLUG_MEMORY
 	tristate "Memory Hotplug"
-	depends on ACPI
 	depends on MEMORY_HOTPLUG
 	default n
 	help
@@ -397,5 +390,3 @@ config ACPI_SBS
 	  to today's ACPI "Control Method" battery.
 
 endif	# ACPI
-
-endmenu
#<EOF>
