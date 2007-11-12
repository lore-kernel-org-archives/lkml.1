Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbXKLVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbXKLVC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXKLU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:59:12 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39818 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbXKLU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move all simple arch settings to Kconfig
Date: Mon, 12 Nov 2007 22:00:30 +0100
Message-Id: <1194901236-22820-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-6-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
 <1194901236-22820-4-git-send-email-sam@ravnborg.org>
 <1194901236-22820-5-git-send-email-sam@ravnborg.org>
 <1194901236-22820-6-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the arch settings were equal so combine them
in the first part of Kconfig.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig        |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig.i386   |  119 -----------------------------------------
 arch/x86/Kconfig.x86_64 |  115 ---------------------------------------
 3 files changed, 136 insertions(+), 234 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9fbb049..d47b5a2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,6 +1,86 @@
 # x86 configuration
 
 ### Arch settings
+config X86
+	bool
+	default y
+
+config 64BIT
+	def_bool X86_64
+
+config GENERIC_TIME
+	bool
+	default y
+
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
+config CLOCKSOURCE_WATCHDOG
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+	depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
+
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
+config STACKTRACE_SUPPORT
+	bool
+	default y
+
+config SEMAPHORE_SLEEPERS
+	bool
+	default y
+
+config MMU
+	bool
+	default y
+
+config ZONE_DMA
+	bool
+	default y
+
+config QUICKLIST
+	bool
+	default X86_32
+
+config SBUS
+	bool
+
+config GENERIC_ISA_DMA
+	bool
+	default y
+
+config GENERIC_IOMAP
+	bool
+	default y
+
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+	default y
+
+config DMI
+	bool
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
 
@@ -16,6 +96,62 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config GENERIC_TIME_VSYSCALL
+	bool
+	default X86_64
+
+
+
+
+
+config ZONE_DMA32
+	bool
+	default X86_64
+
+config ARCH_POPULATES_NODE_MAP
+	def_bool y
+
+config AUDIT_ARCH
+	bool
+	default X86_64
+
+# Use the generic interrupt handling code in kernel/irq/:
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+config GENERIC_PENDING_IRQ
+	bool
+	depends on GENERIC_HARDIRQS && SMP
+	default y
+
+config X86_SMP
+	bool
+	depends on X86_32 && SMP && !X86_VOYAGER
+	default y
+
+config X86_HT
+	bool
+	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
+	default y
+
+config X86_BIOS_REBOOT
+	bool
+	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
+	default y
+
+config X86_TRAMPOLINE
+	bool
+	depends on X86_SMP || (X86_VOYAGER && SMP)
+	default y
+
+config KTIME_SCALAR
+	def_bool X86_32
+
 
 menu "Power management options"
 	depends on !X86_VOYAGER
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 3be7672..b8b462a 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -14,83 +14,6 @@ config X86_32
 	  486, 586, Pentiums, and various instruction-set-compatible chips by
 	  AMD, Cyrix, and others.
 
-config GENERIC_TIME
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	default y
-	depends on X86_LOCAL_APIC
-
-config LOCKDEP_SUPPORT
-	bool
-	default y
-
-config STACKTRACE_SUPPORT
-	bool
-	default y
-
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
-config X86
-	bool
-	default y
-
-config MMU
-	bool
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-config QUICKLIST
-	bool
-	default y
-
-config SBUS
-	bool
-
-config GENERIC_ISA_DMA
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config GENERIC_BUG
-	bool
-	default y
-	depends on BUG
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	default y
-
-config DMI
-	bool
-	default y
-
 source "init/Kconfig"
 
 menu "Processor type and features"
@@ -837,9 +760,6 @@ config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on X86_32 && ARCH_SPARSEMEM_ENABLE
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
@@ -1148,43 +1068,4 @@ config OUT_OF_LINE_PFN_TO_PAGE
 	def_bool X86_64
 	depends on DISCONTIGMEM
 
-#
-# Use the generic interrupt handling code in kernel/irq/:
-#
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-config GENERIC_PENDING_IRQ
-	bool
-	depends on GENERIC_HARDIRQS && SMP
-	default y
-
-config X86_SMP
-	bool
-	depends on X86_32 && SMP && !X86_VOYAGER
-	default y
-
-config X86_HT
-	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
-	default y
-
-config X86_BIOS_REBOOT
-	bool
-	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
-	default y
-
-config X86_TRAMPOLINE
-	bool
-	depends on X86_SMP || (X86_VOYAGER && SMP)
-	default y
-
-config KTIME_SCALAR
-	def_bool X86_32
-
 source "arch/x86/Kconfig"
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 36bb856..e441062 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -17,100 +17,6 @@ config X86_64
 	  classical 32-bit x86 architecture. For details see
 	  <http://www.x86-64.org/>.
 
-config 64BIT
-	def_bool X86_64
-
-config X86
-	bool
-	default y
-
-config GENERIC_TIME
-	bool
-	default y
-
-config GENERIC_TIME_VSYSCALL
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	default y
-
-config ZONE_DMA32
-	bool
-	default y
-
-config LOCKDEP_SUPPORT
-	bool
-	default y
-
-config STACKTRACE_SUPPORT
-	bool
-	default y
-
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
-config MMU
-	bool
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-config ISA
-	bool
-
-config SBUS
-	bool
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config GENERIC_ISA_DMA
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	default y
-
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
-config DMI
-	bool
-	default y
-
-config AUDIT_ARCH
-	bool
-	default y
-
-config GENERIC_BUG
-	bool
-	default y
-	depends on BUG
-
-
 source "init/Kconfig"
 
 
@@ -179,11 +85,6 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-config X86_HT
-	bool
-	depends on SMP && !MK8
-	default y
-
 config MATH_EMULATION
 	bool
 
@@ -606,20 +507,4 @@ config K8_NB
 
 endmenu
 
-#
-# Use the generic interrupt handling code in kernel/irq/:
-#
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-config GENERIC_PENDING_IRQ
-	bool
-	depends on GENERIC_HARDIRQS && SMP
-	default y
-
 source "arch/x86/Kconfig"
-- 
1.5.3.4.1157.g0e74-dirty

