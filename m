Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYB0KhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYB0KhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYB0KhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:37:04 -0500
Received: from mx1.minet.net ([157.159.40.25]:59406 "EHLO mx1.minet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYB0KhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:37:01 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Wed, 27 Feb 2008 11:36:41 +0100
Subject: [PATCH] [x86] rdc321x: Kconfig options fixes for rdc321x
MIME-Version: 1.0
X-Length: 5683
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271136.42763.florian.fainelli@telecomint.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the various Kconfig option selections
which are unavailable for the RDC321x sub architecture.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4a88cf7..31d0fc9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,11 +123,11 @@ config HAVE_SETUP_PER_CPU_AREA
 
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
-	depends on !SMP || !X86_VOYAGER
+	depends on !SMP || !(X86_VOYAGER || X86_RDC321X)
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
-	depends on !X86_VOYAGER
+	depends on !(X86_VOYAGER || X86_RDC321X)
 
 config ZONE_DMA32
 	bool
@@ -159,7 +159,7 @@ config GENERIC_PENDING_IRQ
 
 config X86_SMP
 	bool
-	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
+	depends on SMP && ((X86_32 && !(X86_VOYAGER || X86_RDC321X)) || X86_64)
 	default y
 
 config X86_32_SMP
@@ -173,12 +173,12 @@ config X86_64_SMP
 config X86_HT
 	bool
 	depends on SMP
-	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
+	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER || X86_RDC321X)) || (X86_64 && !MK8)
 	default y
 
 config X86_BIOS_REBOOT
 	bool
-	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_32 && !(X86_VISWS || X86_VOYAGER || X86_RDC321X)
 	default y
 
 config X86_TRAMPOLINE
@@ -365,7 +365,7 @@ config VMI
 	bool "VMI Guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !(X86_VISWS || X86_VOYAGER || X86_RDC321X)
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
@@ -376,7 +376,7 @@ source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !(X86_VISWS || X86_VOYAGER || X86_RDC321X)
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
@@ -554,11 +554,11 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH))
+	depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !(X86_VOYAGER || X86_RDC321X)) || X86_GENERICARCH))
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
+	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER || X86_RDC321X)) || X86_GENERICARCH))
 
 config X86_VISWS_APIC
 	def_bool y
@@ -566,7 +566,7 @@ config X86_VISWS_APIC
 
 config X86_MCE
 	bool "Machine Check Exception"
-	depends on !X86_VOYAGER
+	depends on !(X86_VOYAGER || X86_RDC321X)
 	---help---
 	  Machine Check Exception support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, component failure).
@@ -1196,7 +1196,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && EXPERIMENTAL && !(X86_VOYAGER || X86_RDC321X)
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
@@ -1228,7 +1228,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	depends on NUMA
 
 menu "Power management options"
-	depends on !X86_VOYAGER
+	depends on !(X86_VOYAGER || X86_RDC321X)
 
 config ARCH_HIBERNATION_HEADER
 	def_bool y
@@ -1382,7 +1382,7 @@ menu "Bus options (PCI etc.)"
 
 config PCI
 	bool "PCI support" if !X86_VISWS
-	depends on !X86_VOYAGER
+	depends on !(X86_VOYAGER || X86_RDC321X)
 	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
 	help
@@ -1487,7 +1487,7 @@ if X86_32
 
 config ISA
 	bool "ISA support"
-	depends on !(X86_VOYAGER || X86_VISWS)
+	depends on !(X86_VOYAGER || X86_VISWS || X86_RDC321X)
 	help
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
 	  name of a bus system, i.e. the way the CPU talks to the other stuff
@@ -1514,7 +1514,7 @@ config EISA
 source "drivers/eisa/Kconfig"
 
 config MCA
-	bool "MCA support" if !(X86_VISWS || X86_VOYAGER)
+	bool "MCA support" if !(X86_VISWS || X86_VOYAGER || X86_RDC321X)
 	default y if X86_VOYAGER
 	help
 	  MicroChannel Architecture is found in some IBM PS/2 machines and
@@ -1526,7 +1526,7 @@ source "drivers/mca/Kconfig"
 
 config SCx200
 	tristate "NatSemi SCx200 support"
-	depends on !X86_VOYAGER
+	depends on !(X86_VOYAGER || X86_RDC321X)
 	help
 	  This provides basic support for National Semiconductor's
 	  (now AMD's) Geode processors.  The driver probes for the
