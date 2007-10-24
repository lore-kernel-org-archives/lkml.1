Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXJXWvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXJXWvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbXJXWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:50:50 -0400
Received: from xenotime.net ([66.160.160.81]:53734 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755272AbXJXWut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:50:49 -0400
Date: Wed, 24 Oct 2007 15:50:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-Id: <20071024155043.04ba31cd.rdunlap@xenotime.net>
In-Reply-To: <20071024213052.GA5469@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	<20071024080451.GA32690@infradead.org>
	<20071024110733.GA1374@uranus.ravnborg.org>
	<20071024121218.GA23548@elte.hu>
	<20071024213052.GA5469@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 23:30:52 +0200 Sam Ravnborg wrote:

> Hi Ingo.
> 
> This is first step in getting rid of the two directories.
> I had to do some very minor modifications in common files
> to let it work out - but nothing really hackish.
> 
> If you & Thomas + hpa are OK with the changes they can be
> pulled from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git
> 
> As this is mostly renames I have attached a git -M diff only.
> 
> The remaining stuff is Kconfig files.
> 
> Before looking into these I am hoping someone could
> step in and make the two Kconfig.debug
> files 100% equal - because then I can fix the kconfig
> stuff and finally kill the two directories.

Uh, maybe I jumped too far.  I merged the 2 x86 Kconfig.debug files
into arch/x86/Kconfig.debug....

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Merge i386/Kconfig.debug and x86_64/Kconfig.debug into x86/Kconfig.debug,
using "depends on X86_32" or X86_64 when needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/Kconfig.debug   |   88 ----------------------------------
 arch/x86/Kconfig.debug    |  119 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86_64/Kconfig.debug |   61 -----------------------
 3 files changed, 119 insertions(+), 149 deletions(-)

--- linux-2.6.24-rc1.orig/arch/i386/Kconfig.debug
+++ /dev/null
@@ -1,88 +0,0 @@
-menu "Kernel hacking"
-
-config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default y
-
-source "lib/Kconfig.debug"
-
-config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
-	default y
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
-
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
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
-	help
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
-
-config X86_FIND_SMP_CONFIG
-	bool
-	depends on X86_LOCAL_APIC || X86_VOYAGER
-	default y
-
-config X86_MPPARSE
-	bool
-	depends on X86_LOCAL_APIC && !X86_VISWS
-	default y
-
-config DOUBLEFAULT
-	default y
-	bool "Enable doublefault exception handler" if EMBEDDED
-	help
-          This option allows trapping of rare doublefault exceptions that
-          would otherwise cause a system to silently reboot. Disabling this
-          option saves about 4k and might cause you much additional grey
-          hair.
-
-endmenu
--- /dev/null
+++ linux-2.6.24-rc1/arch/x86/Kconfig.debug
@@ -0,0 +1,119 @@
+menu "Kernel hacking"
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+source "lib/Kconfig.debug"
+
+config EARLY_PRINTK
+	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	default y
+	depends on X86_32
+	help
+	  Write kernel log output directly into the VGA buffer or to a serial
+	  port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash.
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  This option will cause messages to be printed if free stack space
+	  drops below a certain limit.
+
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
+comment "Page alloc debug is incompatible with Software Suspend on i386"
+	depends on DEBUG_KERNEL && HIBERNATION
+	depends on X86_32
+
+config DEBUG_PAGEALLOC
+	bool "Debug page memory allocations"
+	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
+	depends on X86_32
+	help
+	  Unmap pages from the kernel linear mapping after free_pages().
+	  This results in a large slowdown, but helps to find certain types
+	  of memory corruptions.
+
+config DEBUG_RODATA
+	bool "Write protect kernel read-only data structures"
+	depends on DEBUG_KERNEL
+	help
+	  Mark the kernel read-only data as write-protected in the pagetables,
+	  in order to catch accidental (and incorrect) writes to such const
+	  data. This option may have a slight performance impact because a
+	  portion of the kernel code won't be covered by a 2MB TLB anymore.
+	  If in doubt, say "N".
+
+config 4KSTACKS
+	bool "Use 4Kb for kernel stacks instead of 8Kb"
+	depends on DEBUG_KERNEL
+	depends on X86_32
+	help
+	  If you say Y here the kernel will use a 4Kb stacksize for the
+	  kernel stack attached to each process/thread. This facilitates
+	  running more threads on a system and also reduces the pressure
+	  on the VM subsystem for higher order allocations. This option
+	  will also use IRQ stacks to compensate for the reduced stackspace.
+
+config X86_FIND_SMP_CONFIG
+	def_bool y
+	depends on X86_LOCAL_APIC || X86_VOYAGER
+	depends on X86_32
+
+config X86_MPPARSE
+	def_bool y
+	depends on X86_LOCAL_APIC && !X86_VISWS
+	depends on X86_32
+
+config DOUBLEFAULT
+	default y
+	bool "Enable doublefault exception handler" if EMBEDDED
+	depends on X86_32
+	help
+	  This option allows trapping of rare doublefault exceptions that
+	  would otherwise cause a system to silently reboot. Disabling this
+	  option saves about 4k and might cause you much additional grey
+	  hair.
+
+config IOMMU_DEBUG
+	bool "Enable IOMMU debugging"
+	depends on IOMMU && DEBUG_KERNEL
+	depends on X86_64
+	help
+	  Force the IOMMU to on even when you have less than 4GB of
+	  memory and add debugging code. On overflow always panic. And
+	  allow to enable IOMMU leak tracing. Can be disabled at boot
+	  time with iommu=noforce. This will also enable scatter gather
+	  list merging.  Currently not recommended for production
+	  code. When you use it make sure you have a big enough
+	  IOMMU/AGP aperture.  Most of the options enabled by this can
+	  be set more finegrained using the iommu= command line
+	  options. See Documentation/x86_64/boot-options.txt for more
+	  details.
+
+config IOMMU_LEAK
+	bool "IOMMU leak tracing"
+	depends on DEBUG_KERNEL
+	depends on IOMMU_DEBUG
+	help
+	  Add a simple leak tracer to the IOMMU code. This is useful when you
+	  are debugging a buggy device driver that leaks IOMMU mappings.
+
+#config X86_REMOTE_DEBUG
+#	bool "kgdb debugging stub"
+
+endmenu
--- linux-2.6.24-rc1.orig/arch/x86_64/Kconfig.debug
+++ /dev/null
@@ -1,61 +0,0 @@
-menu "Kernel hacking"
-
-config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default y
-
-source "lib/Kconfig.debug"
-
-config DEBUG_RODATA
-       bool "Write protect kernel read-only data structures"
-       depends on DEBUG_KERNEL
-       help
-	 Mark the kernel read-only data as write-protected in the pagetables,
-	 in order to catch accidental (and incorrect) writes to such const data.
-	 This option may have a slight performance impact because a portion
-	 of the kernel code won't be covered by a 2MB TLB anymore.
-	 If in doubt, say "N".
-
-config IOMMU_DEBUG
-       depends on IOMMU && DEBUG_KERNEL
-       bool "Enable IOMMU debugging"
-       help
-         Force the IOMMU to on even when you have less than 4GB of
-	 memory and add debugging code. On overflow always panic. And
-	 allow to enable IOMMU leak tracing. Can be disabled at boot
-	 time with iommu=noforce. This will also enable scatter gather
-	 list merging.  Currently not recommended for production
-	 code. When you use it make sure you have a big enough
-	 IOMMU/AGP aperture.  Most of the options enabled by this can
-	 be set more finegrained using the iommu= command line
-	 options. See Documentation/x86_64/boot-options.txt for more
-	 details.
-
-config IOMMU_LEAK
-       bool "IOMMU leak tracing"
-       depends on DEBUG_KERNEL
-       depends on IOMMU_DEBUG
-       help
-         Add a simple leak tracer to the IOMMU code. This is useful when you
-	 are debugging a buggy device driver that leaks IOMMU mappings.
-
-config DEBUG_STACKOVERFLOW
-        bool "Check for stack overflows"
-        depends on DEBUG_KERNEL
-        help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
-config DEBUG_STACK_USAGE
-        bool "Stack utilization instrumentation"
-        depends on DEBUG_KERNEL
-        help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
-#config X86_REMOTE_DEBUG
-#       bool "kgdb debugging stub"
-
-endmenu
