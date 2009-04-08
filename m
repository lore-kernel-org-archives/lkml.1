Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZDHH3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZDHH3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763190AbZDHH2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:28:41 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:37855 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763218AbZDHH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:28:38 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 7/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF72481B63.65F74131-ON48257592.0028CCE9-48257592.00290E2A@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:26:19 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:26:17,
	Serialize complete at 2009/04/08 ?? 03:26:17
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

Kconfig, Kconfig.debug and Makefile for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/Kconfig linux-2.6-git.new/arch/score/Kconfig
--- linux-2.6-git.ori/arch/score/Kconfig        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/Kconfig        2009-04-07 
21:04:59.000000000 +0800
@@ -0,0 +1,235 @@
+config SCORE
+       bool
+       default y
+       select EMBEDDED
+
+mainmenu "Linux/SCORE Kernel Configuration"
+
+menu "Machine selection"
+
+choice
+       prompt "System type"
+       default MACH_SPCT6600
+
+config ARCH_SCORE7
+       bool "SCORE7 processor"
+       select SYS_SUPPORTS_32BIT_KERNEL
+       select CPU_SCORE7
+       select GENERIC_HAS_IOMAP
+
+config MACH_SPCT6600
+       bool "SPCT6600 series based machines"
+       select SYS_SUPPORTS_32BIT_KERNEL
+       select CPU_SCORE7
+       select GENERIC_HAS_IOMAP
+
+config SCORE_SIM
+       bool "Score simulator"
+       select SYS_SUPPORTS_32BIT_KERNEL
+       select CPU_SCORE7
+       select GENERIC_HAS_IOMAP
+endchoice
+
+endmenu
+
+config CPU_SCORE7
+       bool
+
+config GENERIC_IOMAP
+       bool
+       default y
+
+config RWSEM_GENERIC_SPINLOCK
+       bool
+       default y
+
+config GENERIC_FIND_NEXT_BIT
+       bool
+       default y
+
+config GENERIC_HWEIGHT
+       bool
+       default y
+
+config GENERIC_CALIBRATE_DELAY
+       bool
+       default y
+
+config GENERIC_CLOCKEVENTS
+       bool
+       default y
+
+config GENERIC_TIME
+       bool
+       default y
+
+config SCHED_NO_NO_OMIT_FRAME_POINTER
+       bool
+       default y
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+       bool
+       default y
+
+config EARLY_PRINTK
+       bool "Early printk" if EMBEDDED
+       depends on SYS_HAS_EARLY_PRINTK
+       default y
+       help
+         This option enables special console drivers which allow the 
kernel
+         to print messages very early in the bootup process.
+
+         This is useful for kernel debugging when your machine crashes 
very
+         early before the console code is initialized. For normal 
operation,
+         it is not recommended because it looks ugly on some machines and
+         doesn't cooperate with an X server. You should normally say N 
here,
+         unless you want to debug such a crash.
+
+config SYS_HAS_EARLY_PRINTK
+       bool
+
+config SCORE_L1_CACHE_SHIFT
+       int
+       default "5"
+
+menu "Kernel type"
+
+config 32BIT
+       bool
+       default y
+
+config PAGE_SIZE_4KB
+       bool
+       default y
+
+config GENERIC_HARDIRQS
+       bool
+       default y
+
+config ARCH_FLATMEM_ENABLE
+       bool
+       default y
+
+config ARCH_POPULATES_NODE_MAP
+       bool
+       default y
+
+source "mm/Kconfig"
+
+config MEMORY_START
+       hex
+       default 0xa0000000
+
+source "kernel/time/Kconfig"
+
+config HZ
+       int
+       default 100
+
+source "kernel/Kconfig.preempt"
+
+config KEXEC
+       bool "Kexec system call (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         kexec is a system call that implements the ability to shutdown 
your
+         current kernel, and to start another kernel.  It is like a 
reboot
+         but it is independent of the system firmware.   And like a 
reboot
+         you can start any kernel with it, not just Linux.
+
+         The name comes from the similarity to the exec system call.
+
+         It is an ongoing process to be certain the hardware in a machine
+         is properly shutdown, so do not be surprised if this code does 
not
+         initially work for you.  It may help to enable device 
hotplugging
+         support.  As of this writing the exact hardware interface is
+         strongly in flux, so no good recommendation can be made.
+
+config SECCOMP
+       bool "Enable seccomp to safely compute untrusted bytecode"
+       depends on PROC_FS
+       default y
+       help
+         This kernel feature is useful for number crunching applications
+         that may need to compute untrusted bytecode during their
+         execution. By using pipes or other transports made available to
+         the process as file descriptors supporting the read/write
+         syscalls, it's possible to isolate those applications in
+         their own address space using seccomp. Once seccomp is
+         enabled via /proc/<pid>/seccomp, it cannot be disabled
+         and the task is only allowed to execute a few safe syscalls
+         defined by each seccomp mode.
+
+         If unsure, say Y. Only embedded should say N here.
+
+endmenu
+
+config RWSEM_GENERIC_SPINLOCK
+       bool
+       default y
+
+config LOCKDEP_SUPPORT
+       bool
+       default y
+
+config STACKTRACE_SUPPORT
+       bool
+       default y
+
+source "init/Kconfig"
+
+config PROBE_INITRD_HEADER
+       bool "Probe initrd header created by addinitrd"
+       depends on BLK_DEV_INITRD
+       help
+         Probe initrd header at the last page of kernel image.
+         Say Y here if you are using arch/score/boot/addinitrd.c to
+         add initrd or initramfs image to the kernel image.
+         Otherwise, say N.
+
+menu "Bus options (PCI, PCMCIA, EISA, ISA, TC)"
+
+config MMU
+       bool
+       default y
+
+source "drivers/pcmcia/Kconfig"
+
+source "drivers/pci/hotplug/Kconfig"
+
+endmenu
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
+
+config SYSVIPC_COMPAT
+       bool
+       depends on COMPAT && SYSVIPC
+       default y
+
+endmenu
+
+menu "Power management options"
+
+config ARCH_SUSPEND_POSSIBLE
+       def_bool y
+       depends on !SMP
+
+source "kernel/power/Kconfig"
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/score/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/Kconfig.debug 
linux-2.6-git.new/arch/score/Kconfig.debug
--- linux-2.6-git.ori/arch/score/Kconfig.debug  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/Kconfig.debug  2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,37 @@
+menu "Kernel hacking"
+
+config TRACE_IRQFLAGS_SUPPORT
+       bool
+       default y
+
+source "lib/Kconfig.debug"
+
+config CMDLINE
+       string "Default kernel command string"
+       default ""
+       help
+         On some platforms, there is currently no way for the boot loader 
to
+         pass arguments to the kernel. For these platforms, you can 
supply
+         some command-line options at build time by entering them here. 
In
+         other cases you can specify kernel args so that you don't have
+         to set them up in board prom initialization routines.
+
+config DEBUG_STACK_USAGE
+       bool "Enable stack utilization instrumentation"
+       depends on DEBUG_KERNEL
+       help
+         Enables the display of the minimum amount of free stack which 
each
+         task has ever had available in the sysrq-T and sysrq-P debug 
output.
+
+         This option will slow down process creation somewhat.
+
+config RUNTIME_DEBUG
+       bool "Enable run-time debugging"
+       depends on DEBUG_KERNEL
+       help
+         If you say Y here, some debugging macros will do run-time 
checking.
+         If you say N here, those macros will mostly turn to no-ops.  See
+         include/asm-score/debug.h for debuging macros.
+         If unsure, say N.
+
+endmenu
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/Makefile 
linux-2.6-git.new/arch/score/Makefile
--- linux-2.6-git.ori/arch/score/Makefile       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/Makefile       2009-04-07 
13:57:55.000000000 +0800
@@ -0,0 +1,54 @@
+#
+# arch/score/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General 
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+KBUILD_DEFCONFIG:= spct6600_defconfig
+CROSS_COMPILE  := score-linux-
+
+cflags-y       := -ffunction-sections -ffreestanding
+
+#
+# CPU-dependent compiler/assembler options for optimization.
+#
+cflags-y       += -g -O2 -G0 -pipe -mel -mnhwloop -D__linux__ 
-D__SCOREEL__
+
+#
+# Board-dependent options and extra files
+#
+
+KBUILD_AFLAGS  += $(cflags-y)
+KBUILD_CFLAGS  += $(cflags-y)
+MODFLAGS       += -mlong-calls
+LDFLAGS                += --oformat elf32-littlescore
+LDFLAGS_vmlinux        += -G0 -static -nostdlib
+
+CLEAN_FILES    += arch/score/kernel/vmlinux.lds
+
+#
+# Choosing incompatible machines durings configuration will result in
+# error messages during linking.  Select a default linkscript if
+# none has been choosen above.
+#
+
+head-y         := arch/score/kernel/head.o arch/score/kernel/init_task.o
+
+libs-y         += arch/score/lib/
+core-y         += arch/score/kernel/ arch/score/mm/
+
+boot           := arch/score/boot
+
+vmlinux.bin: vmlinux
+       $(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+archclean:
+       @$(MAKE) $(clean)=$(boot)
+
+define archhelp
+       echo '  vmlinux.bin          - Raw binary boot image'
+       echo
+       echo '  These will be default as apropriate for a configured 
platform.'
+endef
