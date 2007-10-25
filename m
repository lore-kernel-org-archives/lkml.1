Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXJYUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXJYUEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbXJYUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:04:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51124 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbXJYUEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:04:11 -0400
Date: Thu, 25 Oct 2007 22:05:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86 directory
Message-ID: <20071025200546.GF14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6654a98eb8587f0538904c9bdb9aeaf9d577f182 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 25 Oct 2007 21:04:16 +0200
Subject: [PATCH] x86: move i386 and x86_64 Kconfig files to x86 directory

After a small change in kconfig Makefile we could
move all x86 Kconfig files to x86 directory.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/{i386 => x86}/Kconfig.cpu              |    0 
 arch/{i386 => x86}/Kconfig.debug            |    0 
 arch/{i386/Kconfig => x86/Kconfig.i386}     |    4 +-
 arch/{x86_64/Kconfig => x86/Kconfig.x86_64} |    2 +-
 arch/x86_64/Kconfig.debug                   |  119 ---------------------------
 scripts/kconfig/Makefile                    |    7 ++-
 6 files changed, 9 insertions(+), 123 deletions(-)
 rename arch/{i386 => x86}/Kconfig.cpu (100%)
 rename arch/{i386 => x86}/Kconfig.debug (100%)
 rename arch/{i386/Kconfig => x86/Kconfig.i386} (99%)
 rename arch/{x86_64/Kconfig => x86/Kconfig.x86_64} (99%)
 delete mode 100644 arch/x86_64/Kconfig.debug

diff --git a/arch/i386/Kconfig.cpu b/arch/x86/Kconfig.cpu
similarity index 100%
rename from arch/i386/Kconfig.cpu
rename to arch/x86/Kconfig.cpu
diff --git a/arch/i386/Kconfig.debug b/arch/x86/Kconfig.debug
similarity index 100%
rename from arch/i386/Kconfig.debug
rename to arch/x86/Kconfig.debug
diff --git a/arch/i386/Kconfig b/arch/x86/Kconfig.i386
similarity index 99%
rename from arch/i386/Kconfig
rename to arch/x86/Kconfig.i386
index b4437ce..7331efe 100644
--- a/arch/i386/Kconfig
+++ b/arch/x86/Kconfig.i386
@@ -287,7 +287,7 @@ config ES7000_CLUSTERED_APIC
 	default y
 	depends on SMP && X86_ES7000 && MPENTIUMIII
 
-source "arch/i386/Kconfig.cpu"
+source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
 	bool "HPET Timer Support"
@@ -1272,7 +1272,7 @@ source "fs/Kconfig"
 
 source "kernel/Kconfig.instrumentation"
 
-source "arch/i386/Kconfig.debug"
+source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
 
diff --git a/arch/x86_64/Kconfig b/arch/x86/Kconfig.x86_64
similarity index 99%
rename from arch/x86_64/Kconfig
rename to arch/x86/Kconfig.x86_64
index 1bc0268..04b8095 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86/Kconfig.x86_64
@@ -831,7 +831,7 @@ source fs/Kconfig
 
 source "kernel/Kconfig.instrumentation"
 
-source "arch/x86_64/Kconfig.debug"
+source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
 
diff --git a/arch/x86_64/Kconfig.debug b/arch/x86_64/Kconfig.debug
deleted file mode 100644
index 970b2de..0000000
--- a/arch/x86_64/Kconfig.debug
+++ /dev/null
@@ -1,119 +0,0 @@
-menu "Kernel hacking"
-
-config TRACE_IRQFLAGS_SUPPORT
-	def_bool y
-
-source "lib/Kconfig.debug"
-
-config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
-	default y
-	depends on X86_32
-	help
-	  Write kernel log output directly into the VGA buffer or to a serial
-	  port.
-
-	  This is useful for kernel debugging when your machine crashes very
-	  early before the console code is initialized. For normal operation
-	  it is not recommended because it looks ugly and doesn't cooperate
-	  with klogd/syslogd or the X server. You should normally N here,
-	  unless you want to debug such a crash.
-
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
-comment "Page alloc debug is incompatible with Software Suspend on i386"
-	depends on DEBUG_KERNEL && HIBERNATION
-	depends on X86_32
-
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
-	depends on X86_32
-	help
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
-
-config DEBUG_RODATA
-	bool "Write protect kernel read-only data structures"
-	depends on DEBUG_KERNEL
-	help
-	  Mark the kernel read-only data as write-protected in the pagetables,
-	  in order to catch accidental (and incorrect) writes to such const
-	  data. This option may have a slight performance impact because a
-	  portion of the kernel code won't be covered by a 2MB TLB anymore.
-	  If in doubt, say "N".
-
-config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
-	depends on X86_32
-	help
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
-
-config X86_FIND_SMP_CONFIG
-	def_bool y
-	depends on X86_LOCAL_APIC || X86_VOYAGER
-	depends on X86_32
-
-config X86_MPPARSE
-	def_bool y
-	depends on X86_LOCAL_APIC && !X86_VISWS
-	depends on X86_32
-
-config DOUBLEFAULT
-	default y
-	bool "Enable doublefault exception handler" if EMBEDDED
-	depends on X86_32
-	help
-	  This option allows trapping of rare doublefault exceptions that
-	  would otherwise cause a system to silently reboot. Disabling this
-	  option saves about 4k and might cause you much additional grey
-	  hair.
-
-config IOMMU_DEBUG
-	bool "Enable IOMMU debugging"
-	depends on IOMMU && DEBUG_KERNEL
-	depends on X86_64
-	help
-	  Force the IOMMU to on even when you have less than 4GB of
-	  memory and add debugging code. On overflow always panic. And
-	  allow to enable IOMMU leak tracing. Can be disabled at boot
-	  time with iommu=noforce. This will also enable scatter gather
-	  list merging.  Currently not recommended for production
-	  code. When you use it make sure you have a big enough
-	  IOMMU/AGP aperture.  Most of the options enabled by this can
-	  be set more finegrained using the iommu= command line
-	  options. See Documentation/x86_64/boot-options.txt for more
-	  details.
-
-config IOMMU_LEAK
-	bool "IOMMU leak tracing"
-	depends on DEBUG_KERNEL
-	depends on IOMMU_DEBUG
-	help
-	  Add a simple leak tracer to the IOMMU code. This is useful when you
-	  are debugging a buggy device driver that leaks IOMMU mappings.
-
-#config X86_REMOTE_DEBUG
-#	bool "kgdb debugging stub"
-
-endmenu
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3c9db07..5959412 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,7 +4,12 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-Kconfig := arch/$(ARCH)/Kconfig
+# If a arch/$(SRCARCH)/Kconfig.$(ARCH) file exist use it
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig.$(ARCH)),)
+        Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)
+else
+        Kconfig := arch/$(SRCARCH)/Kconfig
+endif
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
-- 
1.5.3.4.1157.g0e74-dirty

