Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDJVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDJVmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXDJVmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:42:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:57512 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXDJVmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:42:14 -0400
Date: Tue, 10 Apr 2007 23:40:36 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net,
       Scott Murray <scottm@somanetworks.com>
Subject: [PATCH 26/30] Use menuconfig objects - pcihotplug
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102339100.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/pci/hotplug/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pci/hotplug/Kconfig
+++ linux-2.6.21-rc5/drivers/pci/hotplug/Kconfig
@@ -2,9 +2,7 @@
 # PCI Hotplug support
 #
 
-menu "PCI Hotplug Support"
-
-config HOTPLUG_PCI
+menuconfig HOTPLUG_PCI
 	tristate "Support for PCI Hotplug (EXPERIMENTAL)"
 	depends on PCI && EXPERIMENTAL && HOTPLUG
 	---help---
@@ -17,9 +15,10 @@ config HOTPLUG_PCI
 
 	  When in doubt, say N.
 
+if HOTPLUG_PCI
+
 config HOTPLUG_PCI_FAKE
 	tristate "Fake PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you want to use the fake PCI hotplug driver. It can
 	  be used to simulate PCI hotplug events if even if your system is
@@ -42,7 +41,7 @@ config HOTPLUG_PCI_FAKE
 
 config HOTPLUG_PCI_COMPAQ
 	tristate "Compaq PCI Hotplug driver"
-	depends on HOTPLUG_PCI && X86 && PCI_BIOS
+	depends on X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a Compaq PCI Hotplug
 	  controller.
@@ -64,7 +63,7 @@ config HOTPLUG_PCI_COMPAQ_NVRAM
 
 config HOTPLUG_PCI_IBM
 	tristate "IBM PCI Hotplug driver"
-	depends on HOTPLUG_PCI && X86_IO_APIC && X86 && PCI_BIOS
+	depends on X86_IO_APIC && X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a IBM PCI Hotplug
 	  controller.
@@ -76,7 +75,6 @@ config HOTPLUG_PCI_IBM
 
 config HOTPLUG_PCI_ACPI
 	tristate "ACPI PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
 	help
 	  Say Y here if you have a system that supports PCI Hotplug using
@@ -101,7 +99,6 @@ config HOTPLUG_PCI_ACPI_IBM
 
 config HOTPLUG_PCI_CPCI
 	bool "CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you have a CompactPCI system card with CompactPCI
 	  hotswap support per the PICMG 2.1 specification.
@@ -110,7 +107,7 @@ config HOTPLUG_PCI_CPCI
 
 config HOTPLUG_PCI_CPCI_ZT5550
 	tristate "Ziatech ZT5550 CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI && HOTPLUG_PCI_CPCI && X86
+	depends on HOTPLUG_PCI_CPCI && X86
 	help
 	  Say Y here if you have an Performance Technologies (formerly Intel,
           formerly just Ziatech) Ziatech ZT5550 CompactPCI system card.
@@ -122,7 +119,7 @@ config HOTPLUG_PCI_CPCI_ZT5550
 
 config HOTPLUG_PCI_CPCI_GENERIC
 	tristate "Generic port I/O CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI && HOTPLUG_PCI_CPCI && X86
+	depends on HOTPLUG_PCI_CPCI && X86
 	help
 	  Say Y here if you have a CompactPCI system card that exposes the #ENUM
 	  hotswap signal as a bit in a system register that can be read through
@@ -135,7 +132,6 @@ config HOTPLUG_PCI_CPCI_GENERIC
 
 config HOTPLUG_PCI_SHPC
 	tristate "SHPC PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you have a motherboard with a SHPC PCI Hotplug
 	  controller.
@@ -147,7 +143,7 @@ config HOTPLUG_PCI_SHPC
 
 config HOTPLUG_PCI_RPA
 	tristate "RPA PCI Hotplug driver"
-	depends on HOTPLUG_PCI && PPC_PSERIES && PPC64 && !HOTPLUG_PCI_FAKE
+	depends on PPC_PSERIES && PPC64 && !HOTPLUG_PCI_FAKE
 	help
 	  Say Y here if you have a RPA system that supports PCI Hotplug.
 
@@ -170,12 +166,11 @@ config HOTPLUG_PCI_RPA_DLPAR
 
 config HOTPLUG_PCI_SGI
 	tristate "SGI PCI Hotplug Support"
-	depends on HOTPLUG_PCI && (IA64_SGI_SN2 || IA64_GENERIC)
+	depends on IA64_SGI_SN2 || IA64_GENERIC
 	help
 	  Say Y here if you want to use the SGI Altix Hotplug
 	  Driver for PCI devices.
 
 	  When in doubt, say N.
 
-endmenu
-
+endif # HOTPLUG_PCI
#<EOF>
