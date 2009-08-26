Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZHZGKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZHZGKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZHZGKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:10:49 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:65420 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZHZGKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aXNUY5+GRXLwida5ulGI5ZP4eQYo8H7HrSCtIi1YpZS4IQ4+5ga2Y3O/gOuut5J4S1
         wMyqY8P2h3xVRLvFS8C8en0ZHheDQwIwUYvQMxxBJldkkgbk12Ds1jWiJO7OlNHued6z
         Mwn+6CzUddiJ0o/ubkOWIgCyWtpD2E2vfcHGA=
Subject: Subject: [PATCH 01/33] score: Kconfig and Kconfig.debug for score
From: "Chen Liqin (Gmail)" <liqin.gnu@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:00:48 +0800
Message-Id: <1251266448.16454.12.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 924106b6793e600b810434cfefce75c147ccfe90 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:55 +0800
Subject: [PATCH 01/33] score: Kconfig and Kconfig.debug for score


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig       |  141 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/score/Kconfig.debug |   36 ++++++++++++
 2 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/Kconfig
 create mode 100644 arch/score/Kconfig.debug

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
new file mode 100644
index 0000000..55d413e
--- /dev/null
+++ b/arch/score/Kconfig
@@ -0,0 +1,141 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+
+mainmenu "Linux/SCORE Kernel Configuration"
+
+menu "Machine selection"
+
+choice
+	prompt "System type"
+	default MACH_SPCT6600
+
+config ARCH_SCORE7
+	bool "SCORE7 processor"
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select CPU_SCORE7
+	select GENERIC_HAS_IOMAP
+
+config MACH_SPCT6600
+	bool "SPCT6600 series based machines"
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select CPU_SCORE7
+	select GENERIC_HAS_IOMAP
+
+config SCORE_SIM
+	bool "Score simulator"
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select CPU_SCORE7
+	select GENERIC_HAS_IOMAP
+endchoice
+
+endmenu
+
+config CPU_SCORE7
+	bool
+
+config GENERIC_IOMAP
+	def_bool y
+
+config NO_DMA
+	bool
+	default y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config SCHED_NO_NO_OMIT_FRAME_POINTER
+	def_bool y
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
+config GENERIC_SYSCALL_TABLE
+	def_bool y
+
+config SCORE_L1_CACHE_SHIFT
+	int
+	default "4"
+
+menu "Kernel type"
+
+config 32BIT
+	def_bool y
+
+config GENERIC_HARDIRQS
+	def_bool y
+
+config ARCH_FLATMEM_ENABLE
+	def_bool y
+
+config ARCH_POPULATES_NODE_MAP
+	def_bool y
+
+source "mm/Kconfig"
+
+config MEMORY_START
+	hex
+	default	0xa0000000
+
+source "kernel/time/Kconfig"
+source "kernel/Kconfig.hz"
+source "kernel/Kconfig.preempt"
+
+endmenu
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config LOCKDEP_SUPPORT
+	def_bool y
+
+config STACKTRACE_SUPPORT
+	def_bool y
+
+source "init/Kconfig"
+
+config PROBE_INITRD_HEADER
+	bool "Probe initrd header created by addinitrd"
+	depends on BLK_DEV_INITRD
+	help
+	  Probe initrd header at the last page of kernel image.
+	  Say Y here if you are using arch/score/boot/addinitrd.c to
+	  add initrd or initramfs image to the kernel image.
+	  Otherwise, say N.
+
+config MMU
+	def_bool y
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
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
diff --git a/arch/score/Kconfig.debug b/arch/score/Kconfig.debug
new file mode 100644
index 0000000..c2863be
--- /dev/null
+++ b/arch/score/Kconfig.debug
@@ -0,0 +1,36 @@
+menu "Kernel hacking"
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+source "lib/Kconfig.debug"
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	help
+	  On some platforms, there is currently no way for the boot loader to
+	  pass arguments to the kernel. For these platforms, you can supply
+	  some command-line options at build time by entering them here.  In
+	  other cases you can specify kernel args so that you don't have
+	  to set them up in board prom initialization routines.
+
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
+config RUNTIME_DEBUG
+	bool "Enable run-time debugging"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, some debugging macros will do run-time checking.
+	  If you say N here, those macros will mostly turn to no-ops.  See
+	  include/asm-score/debug.h for debuging macros.
+	  If unsure, say N.
+
+endmenu
-- 
1.6.2



