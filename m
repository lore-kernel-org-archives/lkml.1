Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXJUQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXJUQx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXJUQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:53:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5021 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXJUQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:53:38 -0400
X-IronPort-AV: i="4.21,307,1188792000"; 
   d="scan'208"; a="42153444:sNHT315118440"
Subject: [GIT-PULL Part #2] Blackfin arch fixing and updates for 2.6.24
	merge windows
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Mon, 22 Oct 2007 00:53:06 +0800
Message-Id: <1192985586.6234.11.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 21 Oct 2007 16:53:30.0371 (UTC) FILETIME=[E886FD30:01C81402]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This set of commits are for Blackfin architecture updates part #2 for 2.6.24 merge window,
only thing related with Blackfin arch. 

 - Blackfin arch BF52x processor initial support
 - General purpose timers API
 - Critical bug fixing and code cleanup

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |   61 +-
 arch/blackfin/Makefile                            |   23 +-
 arch/blackfin/boot/Makefile                       |    3 +
 arch/blackfin/boot/install.sh                     |   57 +
 arch/blackfin/configs/BF527-EZKIT_defconfig       | 1241 +++++++++++++++++++++
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    9 +-
 arch/blackfin/kernel/Makefile                     |    1 +
 arch/blackfin/kernel/bfin_dma_5xx.c               |   26 +
 arch/blackfin/kernel/bfin_gpio.c                  |   35 +-
 arch/blackfin/kernel/gptimers.c                   |  250 +++++
 arch/blackfin/kernel/reboot.c                     |    2 +-
 arch/blackfin/kernel/setup.c                      |  116 ++-
 arch/blackfin/kernel/traps.c                      |    2 +
 arch/blackfin/lib/Makefile                        |    2 +-
 arch/blackfin/lib/udivdi3.S                       |  375 +++++++
 arch/blackfin/mach-bf527/Kconfig                  |  251 +++++
 arch/blackfin/mach-bf527/Makefile                 |    9 +
 arch/blackfin/mach-bf527/boards/Makefile          |    7 +
 arch/blackfin/mach-bf527/boards/eth_mac.c         |   50 +
 arch/blackfin/mach-bf527/boards/ezkit.c           |  737 ++++++++++++
 arch/blackfin/mach-bf527/cpu.c                    |  161 +++
 arch/blackfin/mach-bf527/dma.c                    |  115 ++
 arch/blackfin/mach-bf527/head.S                   |  456 ++++++++
 arch/blackfin/mach-bf527/ints-priority.c          |  100 ++
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf533/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |    4 +-
 arch/blackfin/mach-bf548/dma.c                    |    1 +
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf561/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf561/boards/tepla.c           |    2 +-
 arch/blackfin/mach-common/ints-priority-dc.c      |    8 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |   55 +-
 drivers/serial/Kconfig                            |    2 +-
 include/asm-blackfin/bf5xx_timers.h               |  209 ----
 include/asm-blackfin/bfin-global.h                |    4 +-
 include/asm-blackfin/dma.h                        |    7 +-
 include/asm-blackfin/gpio.h                       |    3 +-
 include/asm-blackfin/gptimers.h                   |  210 ++++
 include/asm-blackfin/mach-bf527/anomaly.h         |    8 +
 include/asm-blackfin/mach-bf527/bf527.h           |  127 +++
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |  152 +++
 include/asm-blackfin/mach-bf527/blackfin.h        |   78 ++
 include/asm-blackfin/mach-bf527/cdefBF52x_base.h  |   19 +-
 include/asm-blackfin/mach-bf527/defBF527.h        |    4 +-
 include/asm-blackfin/mach-bf527/defBF52x_base.h   |    9 +-
 include/asm-blackfin/mach-bf527/dma.h             |   60 +
 include/asm-blackfin/mach-bf527/irq.h             |  263 +++++
 include/asm-blackfin/mach-bf527/mem_init.h        |  337 ++++++
 include/asm-blackfin/mach-bf527/mem_map.h         |   98 ++
 include/asm-blackfin/mach-bf527/portmux.h         |  205 ++++
 include/asm-blackfin/mach-bf548/defBF549.h        |    2 +-
 include/asm-blackfin/mach-bf548/defBF54x_base.h   |    6 +-
 include/asm-blackfin/mach-bf548/dma.h             |    2 +-
 61 files changed, 5669 insertions(+), 317 deletions(-)
 create mode 100644 arch/blackfin/boot/install.sh
 create mode 100644 arch/blackfin/configs/BF527-EZKIT_defconfig
 create mode 100644 arch/blackfin/kernel/gptimers.c
 create mode 100644 arch/blackfin/lib/udivdi3.S
 create mode 100644 arch/blackfin/mach-bf527/Kconfig
 create mode 100644 arch/blackfin/mach-bf527/Makefile
 create mode 100644 arch/blackfin/mach-bf527/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf527/boards/eth_mac.c
 create mode 100644 arch/blackfin/mach-bf527/boards/ezkit.c
 create mode 100644 arch/blackfin/mach-bf527/cpu.c
 create mode 100644 arch/blackfin/mach-bf527/dma.c
 create mode 100644 arch/blackfin/mach-bf527/head.S
 create mode 100644 arch/blackfin/mach-bf527/ints-priority.c
 delete mode 100644 include/asm-blackfin/bf5xx_timers.h
 create mode 100644 include/asm-blackfin/gptimers.h
 create mode 100644 include/asm-blackfin/mach-bf527/bf527.h
 create mode 100644 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
 create mode 100644 include/asm-blackfin/mach-bf527/blackfin.h
 create mode 100644 include/asm-blackfin/mach-bf527/dma.h
 create mode 100644 include/asm-blackfin/mach-bf527/irq.h
 create mode 100644 include/asm-blackfin/mach-bf527/mem_init.h
 create mode 100644 include/asm-blackfin/mach-bf527/mem_map.h
 create mode 100644 include/asm-blackfin/mach-bf527/portmux.h

Bernd Schmidt (1):
      Blackfin arch: Fixing Bug: balance calls to get_task_mm with corresponding mmput calls

Bryan Wu (3):
      Blackfin arch: Fix bug: missing CHIPID register field definition of BF54x
      Blackfin arch: dma add some API and cleanup bf54x DMA definition
      Blackfin arch: update boards files

Michael Hennerich (2):
      Blackfin arch: add new processor ADSP-BF52x arch/mach support
      Blackfin arch: Optimization - no need to make additional math here

Mike Frysinger (9):
      Blackfin arch BF548 defconfig: enable watchdog by default
      Blackfin arch: force irq_flags into the .data section
      Blackfin serial driver Kconfig: depend on DMA not being enabled rather than a specific DMA size
      Blackfin arch: use "char bfin_board_name[]" rather than "char *bfin_board_name" per discussion on lkml as the former uses less storage
      Blackfin arch: -mno-fdpic works
      Blackfin arch: add assembly function for doing 64bit unsigned division
      Blackfin arch: add functions for converting between sclks and usecs
      Blackfin arch: add a cheesy install target
      Blackfin arch: cleanup and promote the general purpose timers api to a core blackfin component

Robin Getz (1):
      Blackfin arch: Fix up /proc/cpuinfo so it is like everyone else

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index ad28dc7..7888551 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -71,7 +71,7 @@ config GENERIC_CALIBRATE_DELAY
 
 config IRQCHIP_DEMUX_GPIO
 	bool
-	depends on (BF53x || BF561 || BF54x)
+	depends on (BF52x || BF53x || BF561 || BF54x)
 	default y
 
 source "init/Kconfig"
@@ -85,6 +85,21 @@ choice
 	prompt "CPU"
 	default BF533
 
+config BF522
+	bool "BF522"
+	help
+	  BF522 Processor Support.
+
+config BF525
+	bool "BF525"
+	help
+	  BF525 Processor Support.
+
+config BF527
+	bool "BF527"
+	help
+	  BF527 Processor Support.
+
 config BF531
 	bool "BF531"
 	help
@@ -144,13 +159,18 @@ endchoice
 
 choice
 	prompt "Silicon Rev"
+	default BF_REV_0_1 if BF527
 	default BF_REV_0_2 if BF537
 	default BF_REV_0_3 if BF533
 	default BF_REV_0_0 if BF549
 
 config BF_REV_0_0
 	bool "0.0"
-	depends on (BF549)
+	depends on (BF549 || BF527)
+
+config BF_REV_0_1
+	bool "0.2"
+	depends on (BF549 || BF527)
 
 config BF_REV_0_2
 	bool "0.2"
@@ -176,6 +196,11 @@ config BF_REV_NONE
 
 endchoice
 
+config BF52x
+	bool
+	depends on (BF522 || BF525 || BF527)
+	default y
+
 config BF53x
 	bool
 	depends on (BF531 || BF532 || BF533 || BF534 || BF536 || BF537)
@@ -204,6 +229,12 @@ choice
 	  configuration to ensure that all the other settings are
 	  correct.
 
+config BFIN527_EZKIT
+	bool "BF527-EZKIT"
+	depends on (BF522 || BF525 || BF527)
+	help
+	  BF533-EZKIT-LITE board Support.
+
 config BFIN533_EZKIT
 	bool "BF533-EZKIT"
 	depends on (BF533 || BF532 || BF531)
@@ -299,11 +330,17 @@ config MEM_MT48LC8M32B2B5_7
 	depends on (BFIN561_BLUETECHNIX_CM)
 	default y
 
+config MEM_MT48LC32M16A2TG_75
+	bool
+	depends on (BFIN527_EZKIT)
+	default y
+
 config BFIN_SHARED_FLASH_ENET
 	bool
 	depends on (BFIN533_STAMP)
 	default y
 
+source "arch/blackfin/mach-bf527/Kconfig"
 source "arch/blackfin/mach-bf533/Kconfig"
 source "arch/blackfin/mach-bf561/Kconfig"
 source "arch/blackfin/mach-bf537/Kconfig"
@@ -329,7 +366,7 @@ config CLKIN_HZ
 	int "Crystal Frequency in Hz"
 	default "11059200" if BFIN533_STAMP
 	default "27000000" if BFIN533_EZKIT
-	default "25000000" if BFIN537_STAMP
+	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT)
 	default "30000000" if BFIN561_EZKIT
 	default "24576000" if PNAV10
 	help
@@ -362,7 +399,7 @@ config VCO_MULT
 	range 1 64
 	default "22" if BFIN533_EZKIT
 	default "45" if BFIN533_STAMP
-	default "20" if BFIN537_STAMP
+	default "20" if (BFIN537_STAMP || BFIN527_EZKIT)
 	default "22" if BFIN533_BLUETECHNIX_CM
 	default "20" if BFIN537_BLUETECHNIX_CM
 	default "20" if BFIN561_BLUETECHNIX_CM
@@ -398,7 +435,7 @@ config SCLK_DIV
 	range 1 15
 	default 5 if BFIN533_EZKIT
 	default 5 if BFIN533_STAMP
-	default 4 if BFIN537_STAMP
+	default 4 if (BFIN537_STAMP || BFIN527_EZKIT)
 	default 5 if BFIN533_BLUETECHNIX_CM
 	default 4 if BFIN537_BLUETECHNIX_CM
 	default 4 if BFIN561_BLUETECHNIX_CM
@@ -450,6 +487,7 @@ comment "Memory Setup"
 config MEM_SIZE
 	int "SDRAM Memory Size in MBytes"
 	default  32 if BFIN533_EZKIT
+	default  64 if BFIN527_EZKIT
 	default  64 if BFIN537_STAMP
 	default  64 if BFIN561_EZKIT
 	default 128 if BFIN533_STAMP
@@ -459,6 +497,7 @@ config MEM_ADD_WIDTH
 	int "SDRAM Memory Address Width"
 	default  9 if BFIN533_EZKIT
 	default  9 if BFIN561_EZKIT
+	default 10 if BFIN527_EZKIT
 	default 10 if BFIN537_STAMP
 	default 11 if BFIN533_STAMP
 	default 10 if PNAV10
@@ -749,9 +788,19 @@ config LARGE_ALLOCS
 	  a lot of RAM, and you need to able to allocate very large
 	  contiguous chunks. If unsure, say N.
 
+config BFIN_GPTIMERS
+	tristate "Enable Blackfin General Purpose Timers API"
+	default n
+	help
+	  Enable support for the General Purpose Timers API.  If you
+	  are unsure, say N.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called gptimers.ko.
+
 config BFIN_DMA_5XX
 	bool "Enable DMA Support"
-	depends on (BF533 || BF532 || BF531 || BF537 || BF536 || BF534 || BF561 || BF54x)
+	depends on (BF52x || BF53x || BF561 || BF54x)
 	default y
 	help
 	  DMA driver for BF5xx.
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 3689337..3c87291 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -12,12 +12,17 @@ LDFLAGS_vmlinux  := -X
 OBJCOPYFLAGS     := -O binary -R .note -R .comment -S
 GZFLAGS          := -9
 
+CFLAGS           += $(call cc-option,-mno-fdpic)
+AFLAGS           += $(call cc-option,-mno-fdpic)
 CFLAGS_MODULE    += -mlong-calls
 KALLSYMS         += --symbol-prefix=_
 
 KBUILD_DEFCONFIG := BF537-STAMP_defconfig
 
 # setup the machine name and the machine dependent settings
+machine-$(CONFIG_BF522) := bf527
+machine-$(CONFIG_BF525) := bf527
+machine-$(CONFIG_BF527) := bf527
 machine-$(CONFIG_BF531) := bf533
 machine-$(CONFIG_BF532) := bf533
 machine-$(CONFIG_BF533) := bf533
@@ -32,6 +37,9 @@ machine-$(CONFIG_BF561) := bf561
 MACHINE := $(machine-y)
 export MACHINE
 
+cpu-$(CONFIG_BF522) := bf522
+cpu-$(CONFIG_BF525) := bf525
+cpu-$(CONFIG_BF527) := bf527
 cpu-$(CONFIG_BF531) := bf531
 cpu-$(CONFIG_BF532) := bf532
 cpu-$(CONFIG_BF533) := bf533
@@ -97,12 +105,23 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 
-all: vmImage
 boot := arch/$(ARCH)/boot
 BOOT_TARGETS = vmImage
-.PHONY: $(BOOT_TARGETS)
+PHONY += $(BOOT_TARGETS) install
+KBUILD_IMAGE := $(boot)/vmImage
+
+all: vmImage
+
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+install:
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+
 define archhelp
   echo  '* vmImage         - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage)'
+  echo  '  install         - Install kernel using'
+  echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
+  echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
+  echo  '                     install to $$(INSTALL_PATH)'
 endef
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index 8cd3356..522f3c1 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -26,3 +26,6 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 $(obj)/vmImage: $(obj)/vmlinux.gz
 	$(call if_changed,uimage)
 	@echo 'Kernel: $@ is ready'
+
+install:
+	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
diff --git a/arch/blackfin/boot/install.sh b/arch/blackfin/boot/install.sh
new file mode 100644
index 0000000..9560a6b
--- /dev/null
+++ b/arch/blackfin/boot/install.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+#
+# arch/blackfin/boot/install.sh
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995 by Linus Torvalds
+#
+# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
+# Adapted from code in arch/i386/boot/install.sh by Mike Frysinger
+#
+# "make install" script for Blackfin architecture
+#
+# Arguments:
+#   $1 - kernel version
+#   $2 - kernel image file
+#   $3 - kernel map file
+#   $4 - default install path (blank if root directory)
+#
+
+verify () {
+	if [ ! -f "$1" ]; then
+		echo ""                                                   1>&2
+		echo " *** Missing file: $1"                              1>&2
+		echo ' *** You need to run "make" before "make install".' 1>&2
+		echo ""                                                   1>&2
+		exit 1
+ 	fi
+}
+
+# Make sure the files actually exist
+verify "$2"
+verify "$3"
+
+# User may have a custom install script
+
+if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
+if which ${CROSS_COMPILE}installkernel >/dev/null 2>&1; then
+	exec ${CROSS_COMPILE}installkernel "$@"
+fi
+
+# Default install - same as make zlilo
+
+back_it_up() {
+	local file=$1
+	[ -f ${file} ] || return 0
+	local stamp=$(stat -c %Y ${file} 2>/dev/null)
+	mv ${file} ${file}.${stamp:-old}
+}
+
+back_it_up $4/uImage
+back_it_up $4/System.map
+
+cat $2 > $4/uImage
+cp $3 $4/System.map
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
new file mode 100644
index 0000000..df974e7
--- /dev/null
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -0,0 +1,1241 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.22.9
+#
+# CONFIG_MMU is not set
+# CONFIG_FPU is not set
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
+CONFIG_BFIN=y
+CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+# CONFIG_GENERIC_TIME is not set
+CONFIG_GENERIC_GPIO=y
+CONFIG_FORCE_MAX_ZONEORDER=14
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_IRQCHIP_DEMUX_GPIO=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# Code maturity level options
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+
+#
+# General setup
+#
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
+# CONFIG_AUDIT is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
+# CONFIG_NP2 is not set
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+
+#
+# Loadable module support
+#
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_DEADLINE is not set
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="anticipatory"
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
+
+#
+# Blackfin Processor Options
+#
+
+#
+# Processor and Board Settings
+#
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+CONFIG_BF527=y
+# CONFIG_BF531 is not set
+# CONFIG_BF532 is not set
+# CONFIG_BF533 is not set
+# CONFIG_BF534 is not set
+# CONFIG_BF536 is not set
+# CONFIG_BF537 is not set
+# CONFIG_BF542 is not set
+# CONFIG_BF544 is not set
+# CONFIG_BF548 is not set
+# CONFIG_BF549 is not set
+# CONFIG_BF561 is not set
+CONFIG_BF_REV_0_0=y
+# CONFIG_BF_REV_0_1 is not set
+# CONFIG_BF_REV_0_2 is not set
+# CONFIG_BF_REV_0_3 is not set
+# CONFIG_BF_REV_0_4 is not set
+# CONFIG_BF_REV_0_5 is not set
+# CONFIG_BF_REV_ANY is not set
+# CONFIG_BF_REV_NONE is not set
+CONFIG_BF52x=y
+CONFIG_BFIN_SINGLE_CORE=y
+CONFIG_BFIN527_EZKIT=y
+# CONFIG_BFIN533_EZKIT is not set
+# CONFIG_BFIN533_STAMP is not set
+# CONFIG_BFIN537_STAMP is not set
+# CONFIG_BFIN533_BLUETECHNIX_CM is not set
+# CONFIG_BFIN537_BLUETECHNIX_CM is not set
+# CONFIG_BFIN548_EZKIT is not set
+# CONFIG_BFIN561_BLUETECHNIX_CM is not set
+# CONFIG_BFIN561_EZKIT is not set
+# CONFIG_BFIN561_TEPLA is not set
+# CONFIG_PNAV10 is not set
+# CONFIG_GENERIC_BOARD is not set
+CONFIG_MEM_MT48LC32M16A2TG_75=y
+
+#
+# BF527 Specific Configuration
+#
+
+#
+# Alternative Multiplexing Scheme
+#
+# CONFIG_BF527_SPORT0_PORTF is not set
+CONFIG_BF527_SPORT0_PORTG=y
+CONFIG_BF527_SPORT0_TSCLK_PG10=y
+# CONFIG_BF527_SPORT0_TSCLK_PG14 is not set
+# CONFIG_BF527_UART1_PORTF is not set
+CONFIG_BF527_UART1_PORTG=y
+# CONFIG_BF527_NAND_D_PORTF is not set
+CONFIG_BF527_NAND_D_PORTH=y
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_IRQ_PLL_WAKEUP=7
+CONFIG_IRQ_DMA0_ERROR=7
+CONFIG_IRQ_DMAR0_BLK=7
+CONFIG_IRQ_DMAR1_BLK=7
+CONFIG_IRQ_DMAR0_OVR=7
+CONFIG_IRQ_DMAR1_OVR=7
+CONFIG_IRQ_PPI_ERROR=7
+CONFIG_IRQ_MAC_ERROR=7
+CONFIG_IRQ_SPORT0_ERROR=7
+CONFIG_IRQ_SPORT1_ERROR=7
+CONFIG_IRQ_UART0_ERROR=7
+CONFIG_IRQ_UART1_ERROR=7
+CONFIG_IRQ_RTC=8
+CONFIG_IRQ_PPI=8
+CONFIG_IRQ_SPORT0_RX=9
+CONFIG_IRQ_SPORT0_TX=9
+CONFIG_IRQ_SPORT1_RX=9
+CONFIG_IRQ_SPORT1_TX=9
+CONFIG_IRQ_TWI=10
+CONFIG_IRQ_SPI=10
+CONFIG_IRQ_UART0_RX=10
+CONFIG_IRQ_UART0_TX=10
+CONFIG_IRQ_UART1_RX=10
+CONFIG_IRQ_UART1_TX=10
+CONFIG_IRQ_OPTSEC=11
+CONFIG_IRQ_CNT=11
+CONFIG_IRQ_MAC_RX=11
+CONFIG_IRQ_PORTH_INTA=11
+CONFIG_IRQ_MAC_TX=11
+CONFIG_IRQ_PORTH_INTB=11
+CONFIG_IRQ_TMR0=12
+CONFIG_IRQ_TMR1=12
+CONFIG_IRQ_TMR2=12
+CONFIG_IRQ_TMR3=12
+CONFIG_IRQ_TMR4=12
+CONFIG_IRQ_TMR5=12
+CONFIG_IRQ_TMR6=12
+CONFIG_IRQ_TMR7=12
+CONFIG_IRQ_PORTG_INTA=12
+CONFIG_IRQ_PORTG_INTB=12
+CONFIG_IRQ_MEM_DMA0=13
+CONFIG_IRQ_MEM_DMA1=13
+CONFIG_IRQ_WATCH=13
+CONFIG_IRQ_PORTF_INTA=13
+CONFIG_IRQ_PORTF_INTB=13
+CONFIG_IRQ_SPI_ERROR=7
+CONFIG_IRQ_NFC_ERROR=7
+CONFIG_IRQ_HDMA_ERROR=7
+CONFIG_IRQ_HDMA=7
+CONFIG_IRQ_USB_EINT=10
+CONFIG_IRQ_USB_INT0=11
+CONFIG_IRQ_USB_INT1=11
+CONFIG_IRQ_USB_INT2=11
+CONFIG_IRQ_USB_DMA=11
+
+#
+# Board customizations
+#
+# CONFIG_CMDLINE_BOOL is not set
+
+#
+# Clock/PLL Setup
+#
+CONFIG_CLKIN_HZ=25000000
+# CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_VCO_HZ=600000000
+CONFIG_MIN_VCO_HZ=50000000
+CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MIN_SCLK_HZ=27000000
+
+#
+# Kernel Timer/Scheduler
+#
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+
+#
+# Memory Setup
+#
+CONFIG_MEM_SIZE=64
+CONFIG_MEM_ADD_WIDTH=10
+CONFIG_BOOT_LOAD=0x1000
+CONFIG_BFIN_SCRATCH_REG_RETN=y
+# CONFIG_BFIN_SCRATCH_REG_RETE is not set
+# CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
+
+#
+# Blackfin Kernel Optimizations
+#
+
+#
+# Memory Optimizations
+#
+CONFIG_I_ENTRY_L1=y
+CONFIG_EXCPT_IRQ_SYSC_L1=y
+CONFIG_DO_IRQ_L1=y
+CONFIG_CORE_TIMER_IRQ_L1=y
+CONFIG_IDLE_L1=y
+# CONFIG_SCHEDULE_L1 is not set
+CONFIG_ARITHMETIC_OPS_L1=y
+CONFIG_ACCESS_OK_L1=y
+# CONFIG_MEMSET_L1 is not set
+# CONFIG_MEMCPY_L1 is not set
+# CONFIG_SYS_BFIN_SPINLOCK_L1 is not set
+# CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
+# CONFIG_SYSCALL_TAB_L1 is not set
+# CONFIG_CPLB_SWITCH_TAB_L1 is not set
+CONFIG_RAMKERNEL=y
+# CONFIG_ROMKERNEL is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_LARGE_ALLOCS=y
+CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_2M is not set
+CONFIG_DMA_UNCACHED_1M=y
+# CONFIG_DMA_UNCACHED_NONE is not set
+
+#
+# Cache Support
+#
+CONFIG_BFIN_ICACHE=y
+CONFIG_BFIN_DCACHE=y
+# CONFIG_BFIN_DCACHE_BANKA is not set
+# CONFIG_BFIN_ICACHE_LOCK is not set
+# CONFIG_BFIN_WB is not set
+CONFIG_BFIN_WT=y
+CONFIG_L1_MAX_PIECE=16
+
+#
+# Asynchonous Memory Configuration
+#
+
+#
+# EBIU_AMBCTL Global Control
+#
+CONFIG_C_AMCKEN=y
+CONFIG_C_CDPRIO=y
+# CONFIG_C_AMBEN is not set
+# CONFIG_C_AMBEN_B0 is not set
+# CONFIG_C_AMBEN_B0_B1 is not set
+# CONFIG_C_AMBEN_B0_B1_B2 is not set
+CONFIG_C_AMBEN_ALL=y
+
+#
+# EBIU_AMBCTL Control
+#
+CONFIG_BANK_0=0x7BB0
+CONFIG_BANK_1=0x5554
+CONFIG_BANK_2=0x7BB0
+CONFIG_BANK_3=0xFFC0
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+
+#
+# PCCARD (PCMCIA/CardBus) support
+#
+# CONFIG_PCCARD is not set
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF_FDPIC=y
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+# CONFIG_BINFMT_SHARED_FLAT is not set
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+# CONFIG_IP_PNP_DHCP is not set
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETLABEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+# CONFIG_MTD_CFI is not set
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=m
+# CONFIG_MTD_CFI_ADV_OPTIONS is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+# CONFIG_MTD_CFI_AMDSTD is not set
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_MW320D=m
+CONFIG_MTD_RAM=y
+CONFIG_MTD_ROM=m
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+CONFIG_MTD_BF5xx=m
+CONFIG_BFIN_FLASH_SIZE=0x400000
+CONFIG_EBIU_FLASH_BASE=0x20000000
+# CONFIG_MTD_UCLINUX is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+CONFIG_MTD_NAND=m
+# CONFIG_MTD_NAND_VERIFY_WRITE is not set
+# CONFIG_MTD_NAND_ECC_SMC is not set
+# CONFIG_MTD_NAND_MUSEUM_IDS is not set
+CONFIG_MTD_NAND_BFIN=m
+CONFIG_BFIN_NAND_BASE=0x20212000
+CONFIG_BFIN_NAND_CLE=2
+CONFIG_BFIN_NAND_ALE=1
+CONFIG_BFIN_NAND_READY=3
+CONFIG_MTD_NAND_IDS=m
+# CONFIG_MTD_NAND_DISKONCHIP is not set
+# CONFIG_MTD_NAND_NANDSIM is not set
+# CONFIG_MTD_NAND_PLATFORM is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+
+#
+# Parallel port support
+#
+# CONFIG_PARPORT is not set
+
+#
+# Plug and Play support
+#
+# CONFIG_PNPACPI is not set
+
+#
+# Block devices
+#
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# Misc devices
+#
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+
+#
+# Multi-device support (RAID and LVM)
+#
+# CONFIG_MD is not set
+
+#
+# Network device support
+#
+CONFIG_NETDEVICES=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_FIXED_PHY is not set
+
+#
+# Ethernet (10 or 100Mbit)
+#
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_SMC91X is not set
+CONFIG_BFIN_MAC=y
+CONFIG_BFIN_MAC_USE_L1=y
+CONFIG_BFIN_TX_DESC_NUM=10
+CONFIG_BFIN_RX_DESC_NUM=20
+CONFIG_BFIN_MAC_RMII=y
+# CONFIG_SMSC911X is not set
+# CONFIG_DM9000 is not set
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+
+#
+# ISDN subsystem
+#
+# CONFIG_ISDN is not set
+
+#
+# Telephony Support
+#
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+# CONFIG_INPUT_EVDEV is not set
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+CONFIG_INPUT_MISC=y
+# CONFIG_INPUT_ATI_REMOTE is not set
+# CONFIG_INPUT_ATI_REMOTE2 is not set
+# CONFIG_INPUT_KEYSPAN_REMOTE is not set
+# CONFIG_INPUT_POWERMATE is not set
+# CONFIG_INPUT_YEALINK is not set
+# CONFIG_INPUT_UINPUT is not set
+# CONFIG_BF53X_PFBUTTONS is not set
+# CONFIG_TWI_KEYPAD is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_AD9960 is not set
+# CONFIG_SPI_ADC_BF533 is not set
+# CONFIG_BF5xx_PFLAGS is not set
+# CONFIG_BF5xx_PPIFCD is not set
+# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BF5xx_PPI is not set
+# CONFIG_BFIN_SPORT is not set
+# CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_TWI_LCD is not set
+# CONFIG_AD5304 is not set
+# CONFIG_BF5xx_TEA5764 is not set
+# CONFIG_BF5xx_FBDMA is not set
+# CONFIG_VT is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_BFIN=y
+CONFIG_SERIAL_BFIN_CONSOLE=y
+# CONFIG_SERIAL_BFIN_DMA is not set
+CONFIG_SERIAL_BFIN_PIO=y
+# CONFIG_SERIAL_BFIN_UART0 is not set
+CONFIG_SERIAL_BFIN_UART1=y
+# CONFIG_BFIN_UART1_CTSRTS is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_BFIN_SPORT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+
+#
+# CAN, the car bus and industrial fieldbus
+#
+# CONFIG_CAN4LINUX is not set
+
+#
+# IPMI
+#
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+CONFIG_HW_RANDOM=y
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+
+#
+# TPM devices
+#
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=m
+
+#
+# I2C Algorithms
+#
+# CONFIG_I2C_ALGOBIT is not set
+# CONFIG_I2C_ALGOPCF is not set
+# CONFIG_I2C_ALGOPCA is not set
+
+#
+# I2C Hardware Bus support
+#
+# CONFIG_I2C_BLACKFIN_GPIO is not set
+CONFIG_I2C_BLACKFIN_TWI=m
+CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
+# CONFIG_I2C_GPIO is not set
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_STUB is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_SENSORS_DS1337 is not set
+# CONFIG_SENSORS_DS1374 is not set
+# CONFIG_SENSORS_AD5252 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_SENSORS_PCF8575 is not set
+# CONFIG_SENSORS_PCA9543 is not set
+# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+
+#
+# SPI support
+#
+CONFIG_SPI=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_AT25 is not set
+# CONFIG_SPI_SPIDEV is not set
+
+#
+# Dallas's 1-wire bus
+#
+# CONFIG_W1 is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_FSCHER is not set
+# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_VGASTATE is not set
+# CONFIG_FB is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+
+#
+# HID Devices
+#
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+
+#
+# USB support
+#
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+# CONFIG_USB is not set
+
+#
+# Enable Host or Gadget support to see Inventra options
+#
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
+# USB Gadget Support
+#
+# CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
+# InfiniBand support
+#
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+
+#
+# SPI RTC drivers
+#
+# CONFIG_RTC_DRV_RS5C348 is not set
+# CONFIG_RTC_DRV_MAX6902 is not set
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_BFIN=y
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
+
+#
+# PBX support
+#
+# CONFIG_PBX is not set
+
+#
+# File systems
+#
+# CONFIG_EXT2_FS is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_DNOTIFY is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+CONFIG_YAFFS_FS=m
+CONFIG_YAFFS_YAFFS1=y
+# CONFIG_YAFFS_DOES_ECC is not set
+CONFIG_YAFFS_YAFFS2=y
+CONFIG_YAFFS_AUTO_YAFFS2=y
+# CONFIG_YAFFS_DISABLE_LAZY_LOAD is not set
+CONFIG_YAFFS_CHECKPOINT_RESERVED_BLOCKS=10
+# CONFIG_YAFFS_DISABLE_WIDE_TNODES is not set
+# CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED is not set
+CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
+CONFIG_JFFS2_FS=m
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Network File Systems
+#
+CONFIG_NFS_FS=m
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=m
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=m
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+CONFIG_SMB_FS=m
+# CONFIG_SMB_NLS_DEFAULT is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+
+#
+# Native Language Support
+#
+CONFIG_NLS=m
+CONFIG_NLS_DEFAULT="iso8859-1"
+# CONFIG_NLS_CODEPAGE_437 is not set
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_UTF8 is not set
+
+#
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
+# Profiling support
+#
+# CONFIG_PROFILING is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
+CONFIG_DEBUG_BFIN_HWTRACE_ON=y
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_TWO is not set
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION=0
+# CONFIG_DEBUG_BFIN_HWTRACE_EXPAND is not set
+# CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
+CONFIG_EARLY_PRINTK=y
+CONFIG_CPLB_INFO=y
+CONFIG_ACCESS_CHECK=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+CONFIG_SECURITY=y
+# CONFIG_SECURITY_NETWORK is not set
+CONFIG_SECURITY_CAPABILITIES=y
+
+#
+# Cryptographic options
+#
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=m
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index e80f3d5..d856988 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -809,7 +809,14 @@ CONFIG_UNIX98_PTYS=y
 # IPMI
 #
 # CONFIG_IPMI_HANDLER is not set
-# CONFIG_WATCHDOG is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 8aeb606..8a4cfb2 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -9,6 +9,7 @@ obj-y := \
 	sys_bfin.o time.o traps.o irqchip.o dma-mapping.o flat.o \
 	fixed_code.o cplbinit.o cacheinit.o reboot.o bfin_gpio.o
 
+obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
 obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_BFIN_DMA_5XX)           += bfin_dma_5xx.o
 obj-$(CONFIG_DUAL_CORE_TEST_MODULE)  += dualcore_test.o
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index e19164f..503eef4 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -420,6 +420,32 @@ unsigned short get_dma_curr_ycount(unsigned int channel)
 }
 EXPORT_SYMBOL(get_dma_curr_ycount);
 
+unsigned long get_dma_next_desc_ptr(unsigned int channel)
+{
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	      && channel < MAX_BLACKFIN_DMA_CHANNEL));
+
+	return dma_ch[channel].regs->next_desc_ptr;
+}
+EXPORT_SYMBOL(get_dma_next_desc_ptr);
+
+unsigned long get_dma_curr_desc_ptr(unsigned int channel)
+{
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	      && channel < MAX_BLACKFIN_DMA_CHANNEL));
+
+	return dma_ch[channel].regs->curr_desc_ptr;
+}
+
+unsigned long get_dma_curr_addr(unsigned int channel)
+{
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	      && channel < MAX_BLACKFIN_DMA_CHANNEL));
+
+	return dma_ch[channel].regs->curr_addr_ptr;
+}
+EXPORT_SYMBOL(get_dma_curr_addr);
+
 static void *__dma_memcpy(void *dest, const void *src, size_t size)
 {
 	int direction;	/* 1 - address decrease, 0 - address increase */
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 3fe0cd4..ce85d4b 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -124,7 +124,7 @@ static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 };
 #endif
 
-#ifdef BF537_FAMILY
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
 static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 	(struct gpio_port_t *) PORTFIO,
 	(struct gpio_port_t *) PORTGIO,
@@ -139,6 +139,21 @@ static unsigned short *port_fer[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 
 #endif
 
+#ifdef BF527_FAMILY
+static unsigned short *port_mux[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
+	(unsigned short *) PORTF_MUX,
+	(unsigned short *) PORTG_MUX,
+	(unsigned short *) PORTH_MUX,
+};
+
+static const
+u8 pmux_offset[][16] =
+	{{ 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 6, 8, 8, 10, 10 }, /* PORTF */
+	 { 0, 0, 0, 0, 0, 2, 2, 4, 4, 6, 8, 10, 10, 10, 12, 12 }, /* PORTG */
+	 { 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 4, 4, 4, 4, 4, 4 }, /* PORTH */
+	};
+#endif
+
 #ifdef BF561_FAMILY
 static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 	(struct gpio_port_t *) FIO0_FLAG_D,
@@ -186,6 +201,10 @@ static unsigned int sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] = {IRQ_PROG_INTB
 static unsigned int sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] = {IRQ_PROG_INTB, IRQ_PORTG_INTB, IRQ_MAC_TX};
 #endif
 
+#ifdef BF527_FAMILY
+static unsigned int sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] = {IRQ_PORTF_INTB, IRQ_PORTG_INTB, IRQ_PORTH_INTB};
+#endif
+
 #ifdef BF561_FAMILY
 static unsigned int sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] = {IRQ_PROG0_INTB, IRQ_PROG1_INTB, IRQ_PROG2_INTB};
 #endif
@@ -238,7 +257,7 @@ static int cmp_label(unsigned short ident, const char *label)
 		return -EINVAL;
 }
 
-#ifdef BF537_FAMILY
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
 	if (!check_gpio(gpio)) {
@@ -354,6 +373,18 @@ inline u16 get_portmux(unsigned short portno)
 
 	return (pmux >> (2 * gpio_sub_n(portno)) & 0x3);
 }
+#elif defined(BF527_FAMILY)
+inline void portmux_setup(unsigned short portno, unsigned short function)
+{
+	u16 pmux, ident = P_IDENT(portno);
+	u8 offset = pmux_offset[gpio_bank(ident)][gpio_sub_n(ident)];
+
+	pmux = *port_mux[gpio_bank(ident)];
+	pmux &= ~(3 << offset);
+	pmux |= (function & 3) << offset;
+	*port_mux[gpio_bank(ident)] = pmux;
+	SSYNC();
+}
 #else
 # define portmux_setup(...)  do { } while (0)
 #endif
diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
new file mode 100644
index 0000000..cb7ba9b
--- /dev/null
+++ b/arch/blackfin/kernel/gptimers.c
@@ -0,0 +1,250 @@
+/*
+ * bfin_gptimers.c - derived from bf53x_timers.c
+ *  Driver for General Purpose Timer functions on the Blackfin processor
+ *
+ *  Copyright (C) 2005 John DeHority
+ *  Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <asm/io.h>
+#include <asm/blackfin.h>
+#include <asm/gptimers.h>
+
+#ifdef DEBUG
+# define tassert(expr)
+#else
+# define tassert(expr) \
+	if (!(expr)) \
+		printk(KERN_DEBUG "%s:%s:%i: Assertion failed: " #expr "\n", \
+			__FILE__, __func__, __LINE__);
+#endif
+
+#define BFIN_TIMER_NUM_GROUP  (BFIN_TIMER_OCTET(MAX_BLACKFIN_GPTIMERS - 1) + 1)
+
+typedef struct {
+	uint16_t config;
+	uint16_t __pad;
+	uint32_t counter;
+	uint32_t period;
+	uint32_t width;
+} GPTIMER_timer_regs;
+
+typedef struct {
+	uint16_t enable;
+	uint16_t __pad0;
+	uint16_t disable;
+	uint16_t __pad1;
+	uint32_t status;
+} GPTIMER_group_regs;
+
+static volatile GPTIMER_timer_regs *const timer_regs[MAX_BLACKFIN_GPTIMERS] =
+{
+	(GPTIMER_timer_regs *)TIMER0_CONFIG,
+	(GPTIMER_timer_regs *)TIMER1_CONFIG,
+	(GPTIMER_timer_regs *)TIMER2_CONFIG,
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+	(GPTIMER_timer_regs *)TIMER3_CONFIG,
+	(GPTIMER_timer_regs *)TIMER4_CONFIG,
+	(GPTIMER_timer_regs *)TIMER5_CONFIG,
+	(GPTIMER_timer_regs *)TIMER6_CONFIG,
+	(GPTIMER_timer_regs *)TIMER7_CONFIG,
+#endif
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+	(GPTIMER_timer_regs *)TIMER8_CONFIG,
+	(GPTIMER_timer_regs *)TIMER9_CONFIG,
+	(GPTIMER_timer_regs *)TIMER10_CONFIG,
+	(GPTIMER_timer_regs *)TIMER11_CONFIG,
+#endif
+};
+
+static volatile GPTIMER_group_regs *const group_regs[BFIN_TIMER_NUM_GROUP] =
+{
+	(GPTIMER_group_regs *)TIMER0_GROUP_REG,
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+	(GPTIMER_group_regs *)TIMER8_GROUP_REG,
+#endif
+};
+
+static uint32_t const dis_mask[MAX_BLACKFIN_GPTIMERS] =
+{
+	TIMER_STATUS_TRUN0,
+	TIMER_STATUS_TRUN1,
+	TIMER_STATUS_TRUN2,
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+	TIMER_STATUS_TRUN3,
+	TIMER_STATUS_TRUN4,
+	TIMER_STATUS_TRUN5,
+	TIMER_STATUS_TRUN6,
+	TIMER_STATUS_TRUN7,
+#endif
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+	TIMER_STATUS_TRUN8,
+	TIMER_STATUS_TRUN9,
+	TIMER_STATUS_TRUN10,
+	TIMER_STATUS_TRUN11,
+#endif
+};
+
+static uint32_t const irq_mask[MAX_BLACKFIN_GPTIMERS] =
+{
+	TIMER_STATUS_TIMIL0,
+	TIMER_STATUS_TIMIL1,
+	TIMER_STATUS_TIMIL2,
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+	TIMER_STATUS_TIMIL3,
+	TIMER_STATUS_TIMIL4,
+	TIMER_STATUS_TIMIL5,
+	TIMER_STATUS_TIMIL6,
+	TIMER_STATUS_TIMIL7,
+#endif
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+	TIMER_STATUS_TIMIL8,
+	TIMER_STATUS_TIMIL9,
+	TIMER_STATUS_TIMIL10,
+	TIMER_STATUS_TIMIL11,
+#endif
+};
+
+void set_gptimer_pwidth(int timer_id, uint32_t value)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	timer_regs[timer_id]->width = value;
+	SSYNC();
+}
+EXPORT_SYMBOL(set_gptimer_pwidth);
+
+uint32_t get_gptimer_pwidth(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return timer_regs[timer_id]->width;
+}
+EXPORT_SYMBOL(get_gptimer_pwidth);
+
+void set_gptimer_period(int timer_id, uint32_t period)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	timer_regs[timer_id]->period = period;
+	SSYNC();
+}
+EXPORT_SYMBOL(set_gptimer_period);
+
+uint32_t get_gptimer_period(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return timer_regs[timer_id]->period;
+}
+EXPORT_SYMBOL(get_gptimer_period);
+
+uint32_t get_gptimer_count(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return timer_regs[timer_id]->counter;
+}
+EXPORT_SYMBOL(get_gptimer_count);
+
+uint32_t get_gptimer_status(int group)
+{
+	tassert(group < BFIN_TIMER_NUM_GROUP);
+	return group_regs[group]->status;
+}
+EXPORT_SYMBOL(get_gptimer_status);
+
+void set_gptimer_status(int group, uint32_t value)
+{
+	tassert(group < BFIN_TIMER_NUM_GROUP);
+	group_regs[group]->status = value;
+	SSYNC();
+}
+EXPORT_SYMBOL(set_gptimer_status);
+
+uint16_t get_gptimer_intr(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & irq_mask[timer_id]) ? 1 : 0;
+}
+EXPORT_SYMBOL(get_gptimer_intr);
+
+void clear_gptimer_intr(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = irq_mask[timer_id];
+}
+EXPORT_SYMBOL(clear_gptimer_intr);
+
+void set_gptimer_config(int timer_id, uint16_t config)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	timer_regs[timer_id]->config = config;
+	SSYNC();
+}
+EXPORT_SYMBOL(set_gptimer_config);
+
+uint16_t get_gptimer_config(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return timer_regs[timer_id]->config;
+}
+EXPORT_SYMBOL(get_gptimer_config);
+
+void enable_gptimers(uint16_t mask)
+{
+	int i;
+	tassert((mask & ~BLACKFIN_GPTIMER_IDMASK) == 0);
+	for (i = 0; i < BFIN_TIMER_NUM_GROUP; ++i) {
+		group_regs[i]->enable = mask & 0xFF;
+		mask >>= 8;
+	}
+	SSYNC();
+}
+EXPORT_SYMBOL(enable_gptimers);
+
+void disable_gptimers(uint16_t mask)
+{
+	int i;
+	uint16_t m = mask;
+	tassert((mask & ~BLACKFIN_GPTIMER_IDMASK) == 0);
+	for (i = 0; i < BFIN_TIMER_NUM_GROUP; ++i) {
+		group_regs[i]->disable = m & 0xFF;
+		m >>= 8;
+	}
+	for (i = 0; i < MAX_BLACKFIN_GPTIMERS; ++i)
+		if (mask & (1 << i))
+			group_regs[BFIN_TIMER_OCTET(i)]->status |= dis_mask[i];
+	SSYNC();
+}
+EXPORT_SYMBOL(disable_gptimers);
+
+void set_gptimer_pulse_hi(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	timer_regs[timer_id]->config |= TIMER_PULSE_HI;
+	SSYNC();
+}
+EXPORT_SYMBOL(set_gptimer_pulse_hi);
+
+void clear_gptimer_pulse_hi(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	timer_regs[timer_id]->config &= ~TIMER_PULSE_HI;
+	SSYNC();
+}
+EXPORT_SYMBOL(clear_gptimer_pulse_hi);
+
+uint16_t get_enabled_gptimers(void)
+{
+	int i;
+	uint16_t result = 0;
+	for (i = 0; i < BFIN_TIMER_NUM_GROUP; ++i)
+		result |= (group_regs[i]->enable << (i << 3));
+	return result;
+}
+EXPORT_SYMBOL(get_enabled_gptimers);
+
+MODULE_AUTHOR("Axel Weiss (awe@aglaia-gmbh.de)");
+MODULE_DESCRIPTION("Blackfin General Purpose Timers API");
+MODULE_LICENSE("GPL");
diff --git a/arch/blackfin/kernel/reboot.c b/arch/blackfin/kernel/reboot.c
index 356078e..ae28aac 100644
--- a/arch/blackfin/kernel/reboot.c
+++ b/arch/blackfin/kernel/reboot.c
@@ -11,7 +11,7 @@
 #include <asm/reboot.h>
 #include <asm/system.h>
 
-#if defined(BF537_FAMILY) || defined(BF533_FAMILY)
+#if defined(BF537_FAMILY) || defined(BF533_FAMILY) || defined(BF527_FAMILY)
 #define SYSCR_VAL 	0x0
 #elif defined(BF561_FAMILY)
 #define SYSCR_VAL 	0x20
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 8dcd76e..0e74644 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -459,7 +459,7 @@ static u_long get_vco(void)
 	return vco;
 }
 
-/*Get the Core clock*/
+/* Get the Core clock */
 u_long get_cclk(void)
 {
 	u_long csel, ssel;
@@ -493,12 +493,24 @@ u_long get_sclk(void)
 }
 EXPORT_SYMBOL(get_sclk);
 
+unsigned long sclk_to_usecs(unsigned long sclk)
+{
+	return (USEC_PER_SEC * (u64)sclk) / get_sclk();
+}
+EXPORT_SYMBOL(sclk_to_usecs);
+
+unsigned long usecs_to_sclk(unsigned long usecs)
+{
+	return get_sclk() / (USEC_PER_SEC * (u64)usecs);
+}
+EXPORT_SYMBOL(usecs_to_sclk);
+
 /*
  *	Get CPU information for use by the procfs.
  */
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-	char *cpu, *mmu, *fpu, *name;
+	char *cpu, *mmu, *fpu, *vendor, *cache;
 	uint32_t revid;
 
 	u_long cclk = 0, sclk = 0;
@@ -508,70 +520,83 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	mmu = "none";
 	fpu = "none";
 	revid = bfin_revid();
-	name = bfin_board_name;
 
 	cclk = get_cclk();
 	sclk = get_sclk();
 
-	seq_printf(m, "CPU:\t\tADSP-%s Rev. 0.%d\n"
-		   "MMU:\t\t%s\n"
-		   "FPU:\t\t%s\n"
-		   "Core Clock:\t%9lu Hz\n"
-		   "System Clock:\t%9lu Hz\n"
-		   "BogoMips:\t%lu.%02lu\n"
-		   "Calibration:\t%lu loops\n",
-		   cpu, revid, mmu, fpu,
-		   cclk,
-		   sclk,
-		   (loops_per_jiffy * HZ) / 500000,
-		   ((loops_per_jiffy * HZ) / 5000) % 100,
-		   (loops_per_jiffy * HZ));
-	seq_printf(m, "Board Name:\t%s\n", name);
-	seq_printf(m, "Board Memory:\t%ld MB\n", physical_mem_end >> 20);
-	seq_printf(m, "Kernel Memory:\t%ld MB\n", (unsigned long)_ramend >> 20);
-	if (bfin_read_IMEM_CONTROL() & (ENICPLB | IMC))
-		seq_printf(m, "I-CACHE:\tON\n");
-	else
-		seq_printf(m, "I-CACHE:\tOFF\n");
-	if ((bfin_read_DMEM_CONTROL()) & (ENDCPLB | DMC_ENABLE))
-		seq_printf(m, "D-CACHE:\tON"
-#if defined CONFIG_BFIN_WB
-			   " (write-back)"
-#elif defined CONFIG_BFIN_WT
-			   " (write-through)"
-#endif
-			   "\n");
-	else
-		seq_printf(m, "D-CACHE:\tOFF\n");
-
+	switch (bfin_read_CHIPID() & CHIPID_MANUFACTURE) {
+	case 0xca:
+		vendor = "Analog Devices";
+		break;
+	default:
+		vendor = "unknown";
+		break;
+	}
 
+	seq_printf(m, "processor\t: %d\n"
+		"vendor_id\t: %s\n"
+		"cpu family\t: 0x%x\n"
+		"model name\t: ADSP-%s %lu(MHz CCLK) %lu(MHz SCLK)\n"
+		"stepping\t: %d\n",
+		0,
+		vendor,
+		(bfin_read_CHIPID() & CHIPID_FAMILY),
+		cpu, cclk/1000000, sclk/1000000,
+		revid);
+
+	seq_printf(m, "cpu MHz\t\t: %lu.%03lu/%lu.%03lu\n",
+		cclk/1000000, cclk%1000000,
+		sclk/1000000, sclk%1000000);
+	seq_printf(m, "bogomips\t: %lu.%02lu\n"
+		"Calibration\t: %lu loops\n",
+		(loops_per_jiffy * HZ) / 500000,
+		((loops_per_jiffy * HZ) / 5000) % 100,
+		(loops_per_jiffy * HZ));
+
+	/* Check Cache configutation */
 	switch (bfin_read_DMEM_CONTROL() & (1 << DMC0_P | 1 << DMC1_P)) {
 	case ACACHE_BSRAM:
-		seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tSRAM\n");
+		cache = "dbank-A/B\t: cache/sram";
 		dcache_size = 16;
 		dsup_banks = 1;
 		break;
 	case ACACHE_BCACHE:
-		seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tCACHE\n");
+		cache = "dbank-A/B\t: cache/cache";
 		dcache_size = 32;
 		dsup_banks = 2;
 		break;
 	case ASRAM_BSRAM:
-		seq_printf(m, "DBANK-A:\tSRAM\n" "DBANK-B:\tSRAM\n");
+		cache = "dbank-A/B\t: sram/sram";
 		dcache_size = 0;
 		dsup_banks = 0;
 		break;
 	default:
+		cache = "unknown";
+		dcache_size = 0;
+		dsup_banks = 0;
 		break;
 	}
 
+	/* Is it turned on? */
+	if (!((bfin_read_DMEM_CONTROL()) & (ENDCPLB | DMC_ENABLE)))
+		dcache_size = 0;
 
-	seq_printf(m, "I-CACHE Size:\t%dKB\n", BFIN_ICACHESIZE / 1024);
-	seq_printf(m, "D-CACHE Size:\t%dKB\n", dcache_size);
-	seq_printf(m, "I-CACHE Setup:\t%d Sub-banks/%d Ways, %d Lines/Way\n",
+	seq_printf(m, "cache size\t: %d KB(L1 icache) "
+		"%d KB(L1 dcache-%s) %d KB(L2 cache)\n",
+		BFIN_ICACHESIZE / 1024, dcache_size,
+#if defined CONFIG_BFIN_WB
+		"wb"
+#elif defined CONFIG_BFIN_WT
+		"wt"
+#endif
+		, 0);
+
+	seq_printf(m, "%s\n", cache);
+
+	seq_printf(m, "icache setup\t: %d Sub-banks/%d Ways, %d Lines/Way\n",
 		   BFIN_ISUBBANKS, BFIN_IWAYS, BFIN_ILINES);
 	seq_printf(m,
-		   "D-CACHE Setup:\t%d Super-banks/%d Sub-banks/%d Ways, %d Lines/Way\n",
+		   "dcache setup\t: %d Super-banks/%d Sub-banks/%d Ways, %d Lines/Way\n",
 		   dsup_banks, BFIN_DSUBBANKS, BFIN_DWAYS,
 		   BFIN_DLINES);
 #ifdef CONFIG_BFIN_ICACHE_LOCK
@@ -625,6 +650,15 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "No Ways are locked\n");
 	}
 #endif
+
+	seq_printf(m, "board name\t: %s\n", bfin_board_name);
+	seq_printf(m, "board memory\t: %ld kB (0x%p -> 0x%p)\n",
+		 physical_mem_end >> 10, (void *)0, (void *)physical_mem_end);
+	seq_printf(m, "kernel memory\t: %d kB (0x%p -> 0x%p)\n",
+		((int)memory_end - (int)_stext) >> 10,
+		_stext,
+		(void *)memory_end);
+
 	return 0;
 }
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8823e9a..afd044e 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -118,12 +118,14 @@ static int printk_address(unsigned long address)
 					offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
 
 				write_unlock_irq(&tasklist_lock);
+				mmput(mm);
 				return printk("<0x%p> [ %s + 0x%lx ]",
 				              (void *)address, name, offset);
 			}
 
 			vml = vml->next;
 		}
+		mmput(mm);
 	}
 	write_unlock_irq(&tasklist_lock);
 
diff --git a/arch/blackfin/lib/Makefile b/arch/blackfin/lib/Makefile
index 635288f..bfdad52 100644
--- a/arch/blackfin/lib/Makefile
+++ b/arch/blackfin/lib/Makefile
@@ -4,7 +4,7 @@
 
 lib-y := \
 	ashldi3.o ashrdi3.o lshrdi3.o \
-	muldi3.o divsi3.o udivsi3.o modsi3.o umodsi3.o \
+	muldi3.o divsi3.o udivsi3.o udivdi3.o modsi3.o umodsi3.o \
 	checksum.o memcpy.o memset.o memcmp.o memchr.o memmove.o \
 	strcmp.o strcpy.o strncmp.o strncpy.o \
 	umulsi3_highpart.o smulsi3_highpart.o \
diff --git a/arch/blackfin/lib/udivdi3.S b/arch/blackfin/lib/udivdi3.S
new file mode 100644
index 0000000..ad1ebee
--- /dev/null
+++ b/arch/blackfin/lib/udivdi3.S
@@ -0,0 +1,375 @@
+/*
+ * udivdi3.S - unsigned long long division
+ *
+ * Copyright 2003-2007 Analog Devices Inc.
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPLv2 or later.
+ */
+
+#include <linux/linkage.h>
+
+#define CARRY AC0
+
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
+
+ENTRY(___udivdi3)
+   R3 = [SP + 12];
+   [--SP] = (R7:4, P5:3);
+
+   /* Attempt to use divide primitive first; these will handle
+   **  most cases, and they're quick - avoids stalls incurred by
+   ** testing for identities.
+   */
+
+   R4 = R2 | R3;
+   CC = R4 == 0;
+   IF CC JUMP .LDIV_BY_ZERO;
+
+   R4.H = 0x8000;
+   R4 >>>= 16;                  // R4 now 0xFFFF8000
+   R5 = R0 | R2;                // If either dividend or
+   R4 = R5 & R4;                // divisor have bits in
+   CC = R4;                     // top half or low half's sign
+   IF CC JUMP .LIDENTS;          // bit, skip builtins.
+   R4 = R1 | R3;                // Also check top halves
+   CC = R4;
+   IF CC JUMP .LIDENTS;
+
+   /* Can use the builtins. */
+
+   AQ = CC;                     // Clear AQ (CC==0)
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   DIVQ(R0, R2);
+   R0 = R0.L (Z);
+   R1 = 0;
+   (R7:4, P5:3) = [SP++];
+   RTS;
+
+.LIDENTS:
+   /* Test for common identities. Value to be returned is
+   ** placed in R6,R7.
+   */
+                                // Check for 0/y, return 0
+   R4 = R0 | R1;
+   CC = R4 == 0;
+   IF CC JUMP .LRETURN_R0;
+
+                                // Check for x/x, return 1
+   R6 = R0 - R2;                // If x == y, then both R6 and R7 will be zero
+   R7 = R1 - R3;
+   R4 = R6 | R7;                // making R4 zero.
+   R6 += 1;                     // which would now make R6:R7==1.
+   CC = R4 == 0;
+   IF CC JUMP .LRETURN_IDENT;
+
+                                // Check for x/1, return x
+   R6 = R0;
+   R7 = R1;
+   CC = R3 == 0;
+   IF !CC JUMP .Lnexttest;
+   CC = R2 == 1;
+   IF CC JUMP .LRETURN_IDENT;
+
+.Lnexttest:
+   R4.L = ONES R2;              // check for div by power of two which
+   R5.L = ONES R3;              // can be done using a shift
+   R6 = PACK (R5.L, R4.L);
+   CC = R6 == 1;
+   IF CC JUMP .Lpower_of_two_upper_zero;
+   R6 = PACK (R4.L, R5.L);
+   CC = R6 == 1;
+   IF CC JUMP .Lpower_of_two_lower_zero;
+
+                                // Check for x < y, return 0
+   R6 = 0;
+   R7 = R6;
+   CC = R1 < R3 (IU);
+   IF CC JUMP .LRETURN_IDENT;
+   CC = R1 == R3;
+   IF !CC JUMP .Lno_idents;
+   CC = R0 < R2 (IU);
+   IF CC JUMP .LRETURN_IDENT;
+
+.Lno_idents:                    // Idents don't match. Go for the full operation
+
+
+   // If X, or X and Y have high bit set, it'll affect the
+   // results, so shift right one to stop this. Note: we've already
+   // checked that X >= Y, so Y's msb won't be set unless X's
+   // is.
+
+   R4 = 0;
+   CC = R1 < 0;
+   IF !CC JUMP .Lx_msb_clear;
+   CC = !CC;                   // 1 -> 0;
+   R1 = ROT R1 BY -1;          // Shift X >> 1
+   R0 = ROT R0 BY -1;          // lsb -> CC
+   BITSET(R4,31);              // to record only x msb was set
+   CC = R3 < 0;
+   IF !CC JUMP .Ly_msb_clear;
+   CC = !CC;
+   R3 = ROT R3 BY -1;          // Shift Y >> 1
+   R2 = ROT R2 BY -1;
+   BITCLR(R4,31);              // clear bit to record only x msb was set
+
+.Ly_msb_clear:
+.Lx_msb_clear:
+   // Bit 31 in R4 indicates X msb set, but Y msb wasn't, and no bits
+   // were lost, so we should shift result left by one.
+
+   [--SP] = R4;                // save for later
+
+   // In the loop that follows, each iteration we add
+   // either Y' or -Y' to the Remainder. We compute the
+   // negated Y', and store, for convenience. Y' goes
+   // into P0:P1, while -Y' goes into P2:P3.
+
+   P0 = R2;
+   P1 = R3;
+   R2 = -R2;
+   CC = CARRY;
+   CC = !CC;
+   R4 = CC;
+   R3 = -R3;
+   R3 = R3 - R4;
+
+   R6 = 0;                     // remainder = 0
+   R7 = R6;
+
+   [--SP] = R2; P2 = SP;
+   [--SP] = R3; P3 = SP;
+   [--SP] = R6; P5 = SP;       // AQ = 0
+   [--SP] = P1;
+
+   /* In the loop that follows, we use the following
+   ** register assignments:
+   ** R0,R1 X, workspace
+   ** R2,R3 Y, workspace
+   ** R4,R5 partial Div
+   ** R6,R7 partial remainder
+   ** P5 AQ
+   ** The remainder and div form a 128-bit number, with
+   ** the remainder in the high 64-bits.
+   */
+   R4 = R0;                    // Div = X'
+   R5 = R1;
+   R3 = 0;
+
+   P4 = 64;                    // Iterate once per bit
+   LSETUP(.LULST,.LULEND) LC0 = P4;
+.LULST:
+        /* Shift Div and remainder up by one. The bit shifted
+        ** out of the top of the quotient is shifted into the bottom
+        ** of the remainder.
+        */
+        CC = R3;
+        R4 = ROT R4 BY 1;
+        R5 = ROT R5 BY 1 ||        // low q to high q
+             R2 = [P5];            // load saved AQ
+        R6 = ROT R6 BY 1 ||        // high q to low r
+             R0 = [P2];            // load -Y'
+        R7 = ROT R7 BY 1 ||        // low r to high r
+             R1 = [P3];
+
+                                   // Assume add -Y'
+        CC = R2 < 0;               // But if AQ is set...
+        IF CC R0 = P0;             // then add Y' instead
+        IF CC R1 = P1;
+
+        R6 = R6 + R0;              // Rem += (Y' or -Y')
+        CC = CARRY;
+        R0 = CC;
+        R7 = R7 + R1;
+        R7 = R7 + R0 (NS) ||
+             R1 = [SP];
+                                   // Set the next AQ bit
+        R1 = R7 ^ R1;              // from Remainder and Y'
+        R1 = R1 >> 31 ||           // Negate AQ's value, and
+             [P5] = R1;            // save next AQ
+        BITTGL(R1, 0);             // add neg AQ  to the Div
+.LULEND: R4 = R4 + R1;
+
+   R6 = [SP + 16];
+
+   R0 = R4;
+   R1 = R5;
+   CC = BITTST(R6,30);         // Just set CC=0
+   R4 = ROT R0 BY 1;           // but if we had to shift X,
+   R5 = ROT R1 BY 1;           // and didn't shift any bits out,
+   CC = BITTST(R6,31);         // then the result will be half as
+   IF CC R0 = R4;              // much as required, so shift left
+   IF CC R1 = R5;              // one space.
+
+   SP += 20;
+   (R7:4, P5:3) = [SP++];
+   RTS;
+
+.Lpower_of_two:
+   /* Y has a single bit set, which means it's a power of two.
+   ** That means we can perform the division just by shifting
+   ** X to the right the appropriate number of bits
+   */
+
+   /* signbits returns the number of sign bits, minus one.
+   ** 1=>30, 2=>29, ..., 0x40000000=>0. Which means we need
+   ** to shift right n-signbits spaces. It also means 0x80000000
+   ** is a special case, because that *also* gives a signbits of 0
+   */
+.Lpower_of_two_lower_zero:
+   R7 = 0;
+   R6 = R1 >> 31;
+   CC = R3 < 0;
+   IF CC JUMP .LRETURN_IDENT;
+
+   R2.L = SIGNBITS R3;
+   R2 = R2.L (Z);
+   R2 += -62;
+   (R7:4, P5:3) = [SP++];
+   JUMP ___lshftli;
+
+.Lpower_of_two_upper_zero:
+   CC = R2 < 0;
+   IF CC JUMP .Lmaxint_shift;
+
+   R2.L = SIGNBITS R2;
+   R2 = R2.L (Z);
+   R2 += -30;
+   (R7:4, P5:3) = [SP++];
+   JUMP ___lshftli;
+
+.Lmaxint_shift:
+   R2 = -31;
+   (R7:4, P5:3) = [SP++];
+   JUMP ___lshftli;
+
+.LRETURN_IDENT:
+   R0 = R6;
+   R1 = R7;
+.LRETURN_R0:
+   (R7:4, P5:3) = [SP++];
+   RTS;
+.LDIV_BY_ZERO:
+   R0 = ~R2;
+   R1 = R0;
+   (R7:4, P5:3) = [SP++];
+   RTS;
+
+ENDPROC(___udivdi3)
+
+
+ENTRY(___lshftli)
+	CC = R2 == 0;
+	IF CC JUMP .Lfinished;	// nothing to do
+	CC = R2 < 0;
+	IF CC JUMP .Lrshift;
+	R3 = 64;
+	CC = R2 < R3;
+	IF !CC JUMP .Lretzero;
+
+	// We're shifting left, and it's less than 64 bits, so
+	// a valid result will be returned.
+
+	R3 >>= 1;	// R3 now 32
+	CC = R2 < R3;
+
+	IF !CC JUMP .Lzerohalf;
+
+	// We're shifting left, between 1 and 31 bits, which means
+	// some of the low half will be shifted into the high half.
+	// Work out how much.
+
+	R3 = R3 - R2;
+
+	// Save that much data from the bottom half.
+
+	P1 = R7;
+	R7 = R0;
+	R7 >>= R3;
+
+	// Adjust both parts of the parameter.
+
+	R0 <<= R2;
+	R1 <<= R2;
+
+	// And include the bits moved across.
+
+	R1 = R1 | R7;
+	R7 = P1;
+	RTS;
+
+.Lzerohalf:
+	// We're shifting left, between 32 and 63 bits, so the
+	// bottom half will become zero, and the top half will
+	// lose some bits. How many?
+
+	R2 = R2 - R3;	// N - 32
+	R1 = LSHIFT R0 BY R2.L;
+	R0 = R0 - R0;
+	RTS;
+
+.Lretzero:
+	R0 = R0 - R0;
+	R1 = R0;
+.Lfinished:
+	RTS;
+
+.Lrshift:
+	// We're shifting right, but by how much?
+	R2 = -R2;
+	R3 = 64;
+	CC = R2 < R3;
+	IF !CC JUMP .Lretzero;
+
+	// Shifting right less than 64 bits, so some result bits will
+	// be retained.
+
+	R3 >>= 1;	// R3 now 32
+	CC = R2 < R3;
+	IF !CC JUMP .Lsignhalf;
+
+	// Shifting right between 1 and 31 bits, so need to copy
+	// data across words.
+
+	P1 = R7;
+	R3 = R3 - R2;
+	R7 = R1;
+	R7 <<= R3;
+	R1 >>= R2;
+	R0 >>= R2;
+	R0 = R7 | R0;
+	R7 = P1;
+	RTS;
+
+.Lsignhalf:
+	// Shifting right between 32 and 63 bits, so the top half
+	// will become all zero-bits, and the bottom half is some
+	// of the top half. But how much?
+
+	R2 = R2 - R3;
+	R0 = R1;
+	R0 >>= R2;
+	R1 = 0;
+	RTS;
+
+ENDPROC(___lshftli)
diff --git a/arch/blackfin/mach-bf527/Kconfig b/arch/blackfin/mach-bf527/Kconfig
new file mode 100644
index 0000000..50321f7
--- /dev/null
+++ b/arch/blackfin/mach-bf527/Kconfig
@@ -0,0 +1,251 @@
+if (BF52x)
+
+menu "BF527 Specific Configuration"
+
+comment "Alternative Multiplexing Scheme"
+
+choice
+	prompt "SPORT0"
+	default BF527_SPORT0_PORTG
+	help
+	  Select PORT used for SPORT0. See Hardware Reference Manual
+
+config BF527_SPORT0_PORTF
+	bool "PORT F"
+	help
+	  PORT F
+
+config BF527_SPORT0_PORTG
+	bool "PORT G"
+	help
+	  PORT G
+endchoice
+
+choice
+	prompt "SPORT0 TSCLK Location"
+	depends on BF527_SPORT0_PORTG
+	default BF527_SPORT0_TSCLK_PG10
+	help
+	  Select PIN used for SPORT0_TSCLK. See Hardware Reference Manual
+
+config BF527_SPORT0_TSCLK_PG10
+	bool "PORT PG10"
+	help
+	  PORT PG10
+
+config BF527_SPORT0_TSCLK_PG14
+	bool "PORT PG14"
+	help
+	  PORT PG14
+endchoice
+
+choice
+	prompt "UART1"
+	default BF527_UART1_PORTG
+	help
+	  Select PORT used for UART1. See Hardware Reference Manual
+
+config BF527_UART1_PORTF
+	bool "PORT F"
+	help
+	  PORT F
+
+config BF527_UART1_PORTG
+	bool "PORT G"
+	help
+	  PORT G
+endchoice
+
+choice
+	prompt "NAND (NFC) Data"
+	default BF527_NAND_D_PORTH
+	help
+	  Select PORT used for NAND Data Bus. See Hardware Reference Manual
+
+config BF527_NAND_D_PORTF
+	bool "PORT F"
+	help
+	  PORT F
+
+config BF527_NAND_D_PORTH
+	bool "PORT H"
+	help
+	  PORT H
+endchoice
+
+comment "Interrupt Priority Assignment"
+menu "Priority"
+
+config IRQ_PLL_WAKEUP
+	int "IRQ_PLL_WAKEUP"
+	default 7
+config IRQ_DMA0_ERROR
+	int "IRQ_DMA0_ERROR"
+	default 7
+config IRQ_DMAR0_BLK
+	int "IRQ_DMAR0_BLK"
+	default 7
+config IRQ_DMAR1_BLK
+	int "IRQ_DMAR1_BLK"
+	default 7
+config IRQ_DMAR0_OVR
+	int "IRQ_DMAR0_OVR"
+	default 7
+config IRQ_DMAR1_OVR
+	int "IRQ_DMAR1_OVR"
+	default 7
+config IRQ_PPI_ERROR
+	int "IRQ_PPI_ERROR"
+	default 7
+config IRQ_MAC_ERROR
+	int "IRQ_MAC_ERROR"
+	default 7
+config IRQ_SPORT0_ERROR
+	int "IRQ_SPORT0_ERROR"
+	default 7
+config IRQ_SPORT1_ERROR
+	int "IRQ_SPORT1_ERROR"
+	default 7
+config IRQ_UART0_ERROR
+	int "IRQ_UART0_ERROR"
+	default 7
+config IRQ_UART1_ERROR
+	int "IRQ_UART1_ERROR"
+	default 7
+config IRQ_RTC
+	int "IRQ_RTC"
+	default 8
+config IRQ_PPI
+	int "IRQ_PPI"
+	default 8
+config IRQ_SPORT0_RX
+	int "IRQ_SPORT0_RX"
+	default 9
+config IRQ_SPORT0_TX
+	int "IRQ_SPORT0_TX"
+	default 9
+config IRQ_SPORT1_RX
+	int "IRQ_SPORT1_RX"
+	default 9
+config IRQ_SPORT1_TX
+	int "IRQ_SPORT1_TX"
+	default 9
+config IRQ_TWI
+	int "IRQ_TWI"
+	default 10
+config IRQ_SPI
+	int "IRQ_SPI"
+	default 10
+config IRQ_UART0_RX
+	int "IRQ_UART0_RX"
+	default 10
+config IRQ_UART0_TX
+	int "IRQ_UART0_TX"
+	default 10
+config IRQ_UART1_RX
+	int "IRQ_UART1_RX"
+	default 10
+config IRQ_UART1_TX
+	int "IRQ_UART1_TX"
+	default 10
+config IRQ_OPTSEC
+	int "IRQ_OPTSEC"
+	default 11
+config IRQ_CNT
+	int "IRQ_CNT"
+	default 11
+config IRQ_MAC_RX
+	int "IRQ_MAC_RX"
+	default 11
+config IRQ_PORTH_INTA
+	int "IRQ_PORTH_INTA"
+	default 11
+config IRQ_MAC_TX
+	int "IRQ_MAC_TX/NFC"
+	default 11
+config IRQ_PORTH_INTB
+	int "IRQ_PORTH_INTB"
+	default 11
+config IRQ_TMR0
+	int "IRQ_TMR0"
+	default 12
+config IRQ_TMR1
+	int "IRQ_TMR1"
+	default 12
+config IRQ_TMR2
+	int "IRQ_TMR2"
+	default 12
+config IRQ_TMR3
+	int "IRQ_TMR3"
+	default 12
+config IRQ_TMR4
+	int "IRQ_TMR4"
+	default 12
+config IRQ_TMR5
+	int "IRQ_TMR5"
+	default 12
+config IRQ_TMR6
+	int "IRQ_TMR6"
+	default 12
+config IRQ_TMR7
+	int "IRQ_TMR7"
+	default 12
+config IRQ_PORTG_INTA
+	int "IRQ_PORTG_INTA"
+	default 12
+config IRQ_PORTG_INTB
+	int "IRQ_PORTG_INTB"
+	default 12
+config IRQ_MEM_DMA0
+	int "IRQ_MEM_DMA0"
+	default 13
+config IRQ_MEM_DMA1
+	int "IRQ_MEM_DMA1"
+	default 13
+config IRQ_WATCH
+	int "IRQ_WATCH"
+	default 13
+config IRQ_PORTF_INTA
+	int "IRQ_PORTF_INTA"
+	default 13
+config IRQ_PORTF_INTB
+	int "IRQ_PORTF_INTB"
+	default 13
+config IRQ_SPI_ERROR
+	int "IRQ_SPI_ERROR"
+	default 7
+config IRQ_NFC_ERROR
+	int "IRQ_NFC_ERROR"
+	default 7
+config IRQ_HDMA_ERROR
+	int "IRQ_HDMA_ERROR"
+	default 7
+config IRQ_HDMA
+	int "IRQ_HDMA"
+	default 7
+config IRQ_USB_EINT
+	int "IRQ_USB_EINT"
+	default 10
+config IRQ_USB_INT0
+	int "IRQ_USB_INT0"
+	default 10
+config IRQ_USB_INT1
+	int "IRQ_USB_INT1"
+	default 10
+config IRQ_USB_INT2
+	int "IRQ_USB_INT2"
+	default 10
+config IRQ_USB_DMA
+	int "IRQ_USB_DMA"
+	default 10
+
+	help
+	  Enter the priority numbers between 7-13 ONLY.  Others are Reserved.
+	  This applies to all the above.  It is not recommended to assign the
+	  highest priority number 7 to UART or any other device.
+
+endmenu
+
+endmenu
+
+endif
diff --git a/arch/blackfin/mach-bf527/Makefile b/arch/blackfin/mach-bf527/Makefile
new file mode 100644
index 0000000..9f99f5d
--- /dev/null
+++ b/arch/blackfin/mach-bf527/Makefile
@@ -0,0 +1,9 @@
+#
+# arch/blackfin/mach-bf527/Makefile
+#
+
+extra-y := head.o
+
+obj-y := ints-priority.o dma.o
+
+obj-$(CONFIG_CPU_FREQ)   += cpu.o
diff --git a/arch/blackfin/mach-bf527/boards/Makefile b/arch/blackfin/mach-bf527/boards/Makefile
new file mode 100644
index 0000000..912ac8e
--- /dev/null
+++ b/arch/blackfin/mach-bf527/boards/Makefile
@@ -0,0 +1,7 @@
+#
+# arch/blackfin/mach-bf532/boards/Makefile
+#
+
+obj-y					+= eth_mac.o
+obj-$(CONFIG_BFIN527_EZKIT)		+= ezkit.o
+
diff --git a/arch/blackfin/mach-bf527/boards/eth_mac.c b/arch/blackfin/mach-bf527/boards/eth_mac.c
new file mode 100644
index 0000000..a725cc8
--- /dev/null
+++ b/arch/blackfin/mach-bf527/boards/eth_mac.c
@@ -0,0 +1,50 @@
+/*
+ *  arch/blackfin/mach-bf537/board/eth_mac.c
+ *
+ *  Copyright (C) 2007 Analog Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <asm/blackfin.h>
+
+#if	defined(CONFIG_GENERIC_BOARD) || defined(CONFIG_BFIN537_STAMP)
+
+/*
+ * Currently the MAC address is saved in Flash by U-Boot
+ */
+#define FLASH_MAC	0x203f0000
+
+void get_bf537_ether_addr(char *addr)
+{
+	unsigned int flash_mac = (unsigned int) FLASH_MAC;
+	*(u32 *)(&(addr[0])) = bfin_read32(flash_mac);
+	flash_mac += 4;
+	*(u16 *)(&(addr[4])) = bfin_read16(flash_mac);
+}
+
+#else
+
+/*
+ * Provide MAC address function for other specific board setting
+ */
+void get_bf537_ether_addr(char *addr)
+{
+	printk(KERN_WARNING "%s: No valid Ethernet MAC address found\n", __FILE__);
+}
+
+#endif
+
+EXPORT_SYMBOL(get_bf537_ether_addr);
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
new file mode 100644
index 0000000..3e884f3
--- /dev/null
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -0,0 +1,737 @@
+/*
+ * File:         arch/blackfin/mach-bf527/boards/ezkit.c
+ * Based on:     arch/blackfin/mach-bf537/boards/stamp.c
+ * Author:       Aidan Williams <aidan@nicta.com.au>
+ *
+ * Created:
+ * Description:
+ *
+ * Modified:
+ *               Copyright 2005 National ICT Australia (NICTA)
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+#include <linux/usb_isp1362.h>
+#endif
+#include <linux/pata_platform.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/usb_sl811.h>
+#include <asm/dma.h>
+#include <asm/bfin5xx_spi.h>
+#include <asm/reboot.h>
+#include <linux/spi/ad7877.h>
+
+/*
+ * Name the Board for the /proc/cpuinfo
+ */
+const char bfin_board_name[] = "ADDS-BF527-EZKIT";
+
+/*
+ *  Driver needs to know address, irq and flag pin.
+ */
+
+#define ISP1761_BASE       0x203C0000
+#define ISP1761_IRQ        IRQ_PF7
+
+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = ISP1761_BASE + 0x00000000,
+		.end    = ISP1761_BASE + 0x000fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = ISP1761_IRQ,
+		.end    = ISP1761_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+
+arch_initcall(bfin_isp1761_init);
+#endif
+
+#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
+static struct resource bfin_pcmcia_cf_resources[] = {
+	{
+		.start = 0x20310000, /* IO PORT */
+		.end = 0x20312000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20311000, /* Attribute Memory */
+		.end = 0x20311FFF,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF4,
+		.end = IRQ_PF4,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	}, {
+		.start = 6, /* Card Detect PF6 */
+		.end = 6,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_pcmcia_cf_device = {
+	.name = "bfin_cf_pcmcia",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_pcmcia_cf_resources),
+	.resource = bfin_pcmcia_cf_resources,
+};
+#endif
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+static struct platform_device rtc_device = {
+	.name = "rtc-bfin",
+	.id   = -1,
+};
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+static struct resource smc91x_resources[] = {
+	{
+		.name = "smc91x-regs",
+		.start = 0x20300300,
+		.end = 0x20300300 + 16,
+		.flags = IORESOURCE_MEM,
+	}, {
+
+		.start = IRQ_PF7,
+		.end = IRQ_PF7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
+#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+static struct resource dm9000_resources[] = {
+	[0] = {
+		.start	= 0x203FB800,
+		.end	= 0x203FB800 + 8,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PF9,
+		.end	= IRQ_PF9,
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
+	},
+};
+
+static struct platform_device dm9000_device = {
+	.name		= "dm9000",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm9000_resources),
+	.resource	= dm9000_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
+static struct resource sl811_hcd_resources[] = {
+	{
+		.start = 0x20340000,
+		.end = 0x20340000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20340004,
+		.end = 0x20340004,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = CONFIG_USB_SL811_BFIN_IRQ,
+		.end = CONFIG_USB_SL811_BFIN_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
+void sl811_port_power(struct device *dev, int is_on)
+{
+	gpio_request(CONFIG_USB_SL811_BFIN_GPIO_VBUS, "usb:SL811_VBUS");
+	gpio_direction_output(CONFIG_USB_SL811_BFIN_GPIO_VBUS);
+
+	if (is_on)
+		gpio_set_value(CONFIG_USB_SL811_BFIN_GPIO_VBUS, 1);
+	else
+		gpio_set_value(CONFIG_USB_SL811_BFIN_GPIO_VBUS, 0);
+}
+#endif
+
+static struct sl811_platform_data sl811_priv = {
+	.potpg = 10,
+	.power = 250,       /* == 500mA */
+#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
+	.port_power = &sl811_port_power,
+#endif
+};
+
+static struct platform_device sl811_hcd_device = {
+	.name = "sl811-hcd",
+	.id = 0,
+	.dev = {
+		.platform_data = &sl811_priv,
+	},
+	.num_resources = ARRAY_SIZE(sl811_hcd_resources),
+	.resource = sl811_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+static struct resource isp1362_hcd_resources[] = {
+	{
+		.start = 0x20360000,
+		.end = 0x20360000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20360004,
+		.end = 0x20360004,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
+		.end = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct isp1362_platform_data isp1362_priv = {
+	.sel15Kres = 1,
+	.clknotstop = 0,
+	.oc_enable = 0,
+	.int_act_high = 0,
+	.int_edge_triggered = 0,
+	.remote_wakeup_connected = 0,
+	.no_power_switching = 1,
+	.power_switching_mode = 0,
+};
+
+static struct platform_device isp1362_hcd_device = {
+	.name = "isp1362-hcd",
+	.id = 0,
+	.dev = {
+		.platform_data = &isp1362_priv,
+	},
+	.num_resources = ARRAY_SIZE(isp1362_hcd_resources),
+	.resource = isp1362_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+static struct platform_device bfin_mac_device = {
+	.name = "bfin_mac",
+};
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x20300000,
+		.end = 0x20300000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF7,
+		.end = IRQ_PF7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00020000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "kernel",
+		.size = 0xe0000,
+		.offset = 0x20000
+	}, {
+		.name = "file system",
+		.size = 0x700000,
+		.offset = 0x00100000,
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p64",
+};
+
+/* SPI flash chip (m25p64) */
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) \
+	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+/* SPI ADC chip */
+static struct bfin5xx_spi_chip spi_adc_chip_info = {
+	.enable_dma = 1,         /* use dma transfer with this chip*/
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) \
+	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_PBX)
+static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
+	.ctl_reg	= 0x4, /* send zero */
+	.enable_dma	= 0,
+	.bits_per_word	= 8,
+	.cs_change_per_word = 1,
+};
+#endif
+
+#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
+static struct bfin5xx_spi_chip ad5304_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static const struct ad7877_platform_data bfin_ad7877_ts_info = {
+	.model			= 7877,
+	.vref_delay_usecs	= 50,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.pressure_max		= 1000,
+	.pressure_min		= 0,
+	.stopacq_polarity 	= 1,
+	.first_conversion_delay = 3,
+	.acquisition_time 	= 1,
+	.averaging 		= 1,
+	.pen_down_acc_interval 	= 1,
+};
+#endif
+
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) \
+	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+	{
+		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. */
+		.platform_data = NULL, /* No spi_driver specific config */
+		.controller_data = &spi_adc_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) \
+	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+	{
+		.modalias = "ad1836-spi",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
+		.controller_data = &ad1836_spi_chip_info,
+	},
+#endif
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+	{
+		.modalias = "ad9960-spi",
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 1,
+		.controller_data = &ad9960_spi_chip_info,
+	},
+#endif
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 0,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_PBX)
+	{
+		.modalias = "fxs-spi",
+		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 8 - CONFIG_J11_JUMPER,
+		.controller_data = &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "fxo-spi",
+		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 8 - CONFIG_J19_JUMPER,
+		.controller_data = &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
+	{
+		.modalias = "ad5304_spi",
+		.max_speed_hz = 1250000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 2,
+		.platform_data = NULL,
+		.controller_data = &ad5304_chip_info,
+		.mode = SPI_MODE_2,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+	{
+		.modalias		= "ad7877",
+		.platform_data		= &bfin_ad7877_ts_info,
+		.irq			= IRQ_PF6,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num	= 1,
+		.chip_select  = 1,
+		.controller_data = &spi_ad7877_chip_info,
+	},
+#endif
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bfin_spi0_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+		},
+	[1] = {
+		.start = CH_SPI,
+		.end   = CH_SPI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_spi0_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_spi0_info, /* Passed to driver */
+	},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
+static struct platform_device bfin_fb_device = {
+	.name = "bf537-lq035",
+};
+#endif
+
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+static struct platform_device bfin_fb_adv7393_device = {
+	.name = "bfin-adv7393",
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+static struct resource bfin_uart_resources[] = {
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	{
+		.start = 0xFFC02000,
+		.end = 0xFFC020FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+};
+
+static struct platform_device bfin_uart_device = {
+	.name = "bfin-uart",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(bfin_uart_resources),
+	.resource = bfin_uart_resources,
+};
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = TWI0_REGBASE,
+		.end   = TWI0_REGBASE,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI,
+		.end   = IRQ_TWI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+static struct platform_device bfin_sport0_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 0,
+};
+
+static struct platform_device bfin_sport1_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 1,
+};
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+#define PATA_INT	55
+
+static struct pata_platform_info bfin_pata_platform_data = {
+	.ioport_shift = 1,
+	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+};
+
+static struct resource bfin_pata_resources[] = {
+	{
+		.start = 0x20314020,
+		.end = 0x2031403F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0x2031401C,
+		.end = 0x2031401F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = PATA_INT,
+		.end = PATA_INT,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_pata_device = {
+	.name = "pata_platform",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_pata_resources),
+	.resource = bfin_pata_resources,
+	.dev = {
+		.platform_data = &bfin_pata_platform_data,
+	}
+};
+#endif
+
+static struct platform_device *stamp_devices[] __initdata = {
+#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
+	&bfin_pcmcia_cf_device,
+#endif
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+	&rtc_device,
+#endif
+
+#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
+	&sl811_hcd_device,
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+	&isp1362_hcd_device,
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	&smc91x_device,
+#endif
+
+#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+	&dm9000_device,
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+	&bfin_mac_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bfin_spi0_device,
+#endif
+
+#if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
+	&bfin_fb_device,
+#endif
+
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	&bfin_fb_adv7393_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+	&bfin_uart_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+	&bfin_sport0_uart_device,
+	&bfin_sport1_uart_device,
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	&bfin_pata_device,
+#endif
+};
+
+static int __init stamp_init(void)
+{
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bfin_spi_board_info,
+				ARRAY_SIZE(bfin_spi_board_info));
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+#endif
+	return 0;
+}
+
+arch_initcall(stamp_init);
+
+void native_machine_restart(char *cmd)
+{
+	/* workaround reboot hang when booting from SPI */
+	if ((bfin_read_SYSCR() & 0x7) == 0x3)
+		bfin_gpio_reset_spi0_ssel1();
+}
diff --git a/arch/blackfin/mach-bf527/cpu.c b/arch/blackfin/mach-bf527/cpu.c
new file mode 100644
index 0000000..1975402
--- /dev/null
+++ b/arch/blackfin/mach-bf527/cpu.c
@@ -0,0 +1,161 @@
+/*
+ * File:         arch/blackfin/mach-bf527/cpu.c
+ * Based on:	arch/blackfin/mach-bf537/cpu.c
+ * Author:       michael.kang@analog.com
+ *
+ * Created:
+ * Description:  clock scaling for the bf527
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <asm/dpmc.h>
+#include <linux/fs.h>
+#include <asm/bfin-global.h>
+
+/* CONFIG_CLKIN_HZ=11059200 */
+#define VCO5 (CONFIG_CLKIN_HZ*45)	/*497664000 */
+#define VCO4 (CONFIG_CLKIN_HZ*36)	/*398131200 */
+#define VCO3 (CONFIG_CLKIN_HZ*27)	/*298598400 */
+#define VCO2 (CONFIG_CLKIN_HZ*18)	/*199065600 */
+#define VCO1 (CONFIG_CLKIN_HZ*9)	/*99532800 */
+#define VCO(x) VCO##x
+
+#define MFREQ(x) {VCO(x), VCO(x)/4}, {VCO(x), VCO(x)/2}, {VCO(x), VCO(x)}
+/* frequency */
+static struct cpufreq_frequency_table bf527_freq_table[] = {
+	MFREQ(1),
+	MFREQ(3),
+	{VCO4, VCO4 / 2}, {VCO4, VCO4},
+	MFREQ(5),
+	{0, CPUFREQ_TABLE_END},
+};
+
+/*
+ * dpmc_fops->ioctl()
+ * static int dpmc_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+ */
+static int bf527_getfreq(unsigned int cpu)
+{
+	unsigned long cclk_mhz;
+
+	/* The driver only support single cpu */
+	if (cpu == 0)
+		dpmc_fops.ioctl(NULL, NULL, IOCTL_GET_CORECLOCK, &cclk_mhz);
+	else
+		cclk_mhz = -1;
+
+	return cclk_mhz;
+}
+
+static int bf527_target(struct cpufreq_policy *policy,
+			unsigned int target_freq, unsigned int relation)
+{
+	unsigned long cclk_mhz;
+	unsigned long vco_mhz;
+	unsigned long flags;
+	unsigned int index;
+	struct cpufreq_freqs freqs;
+
+	if (cpufreq_frequency_table_target
+	    (policy, bf527_freq_table, target_freq, relation, &index))
+		return -EINVAL;
+
+	cclk_mhz = bf527_freq_table[index].frequency;
+	vco_mhz = bf527_freq_table[index].index;
+
+	dpmc_fops.ioctl(NULL, NULL, IOCTL_CHANGE_FREQUENCY, &vco_mhz);
+	freqs.old = bf527_getfreq(0);
+	freqs.new = cclk_mhz;
+	freqs.cpu = 0;
+
+	pr_debug
+	    ("cclk begin change to cclk %d,vco=%d,index=%d,target=%d,oldfreq=%d\n",
+	     cclk_mhz, vco_mhz, index, target_freq, freqs.old);
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+	local_irq_save(flags);
+	dpmc_fops.ioctl(NULL, NULL, IOCTL_SET_CCLK, &cclk_mhz);
+	local_irq_restore(flags);
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	vco_mhz = get_vco();
+	cclk_mhz = get_cclk();
+	return 0;
+}
+
+/* make sure that only the "userspace" governor is run -- anything else wouldn't make sense on
+ * this platform, anyway.
+ */
+static int bf527_verify_speed(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, &bf527_freq_table);
+}
+
+static int __init __bf527_cpu_init(struct cpufreq_policy *policy)
+{
+	if (policy->cpu != 0)
+		return -EINVAL;
+
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+
+	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	/*Now ,only support one cpu */
+	policy->cur = bf527_getfreq(0);
+	cpufreq_frequency_table_get_attr(bf527_freq_table, policy->cpu);
+	return cpufreq_frequency_table_cpuinfo(policy, bf527_freq_table);
+}
+
+static struct freq_attr *bf527_freq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver bf527_driver = {
+	.verify = bf527_verify_speed,
+	.target = bf527_target,
+	.get = bf527_getfreq,
+	.init = __bf527_cpu_init,
+	.name = "bf527",
+	.owner = THIS_MODULE,
+	.attr = bf527_freq_attr,
+};
+
+static int __init bf527_cpu_init(void)
+{
+	return cpufreq_register_driver(&bf527_driver);
+}
+
+static void __exit bf527_cpu_exit(void)
+{
+	cpufreq_unregister_driver(&bf527_driver);
+}
+
+MODULE_AUTHOR("Mickael Kang");
+MODULE_DESCRIPTION("cpufreq driver for bf527 CPU");
+MODULE_LICENSE("GPL");
+
+module_init(bf527_cpu_init);
+module_exit(bf527_cpu_exit);
diff --git a/arch/blackfin/mach-bf527/dma.c b/arch/blackfin/mach-bf527/dma.c
new file mode 100644
index 0000000..522de24
--- /dev/null
+++ b/arch/blackfin/mach-bf527/dma.c
@@ -0,0 +1,115 @@
+/*
+ * File:         arch/blackfin/mach-bf527/dma.c
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for Blackfin
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <asm/blackfin.h>
+#include <asm/dma.h>
+
+struct dma_register *base_addr[MAX_BLACKFIN_DMA_CHANNEL] = {
+	(struct dma_register *) DMA0_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_NEXT_DESC_PTR,
+	(struct dma_register *) DMA3_NEXT_DESC_PTR,
+	(struct dma_register *) DMA4_NEXT_DESC_PTR,
+	(struct dma_register *) DMA5_NEXT_DESC_PTR,
+	(struct dma_register *) DMA6_NEXT_DESC_PTR,
+	(struct dma_register *) DMA7_NEXT_DESC_PTR,
+	(struct dma_register *) DMA8_NEXT_DESC_PTR,
+	(struct dma_register *) DMA9_NEXT_DESC_PTR,
+	(struct dma_register *) DMA10_NEXT_DESC_PTR,
+	(struct dma_register *) DMA11_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_D0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_S0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_D1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_S1_NEXT_DESC_PTR,
+};
+
+int channel2irq(unsigned int channel)
+{
+	int ret_irq = -1;
+
+	switch (channel) {
+	case CH_PPI:
+		ret_irq = IRQ_PPI;
+		break;
+
+	case CH_EMAC_RX:
+		ret_irq = IRQ_MAC_RX;
+		break;
+
+	case CH_EMAC_TX:
+		ret_irq = IRQ_MAC_TX;
+		break;
+
+	case CH_UART1_RX:
+		ret_irq = IRQ_UART1_RX;
+		break;
+
+	case CH_UART1_TX:
+		ret_irq = IRQ_UART1_TX;
+		break;
+
+	case CH_SPORT0_RX:
+		ret_irq = IRQ_SPORT0_RX;
+		break;
+
+	case CH_SPORT0_TX:
+		ret_irq = IRQ_SPORT0_TX;
+		break;
+
+	case CH_SPORT1_RX:
+		ret_irq = IRQ_SPORT1_RX;
+		break;
+
+	case CH_SPORT1_TX:
+		ret_irq = IRQ_SPORT1_TX;
+		break;
+
+	case CH_SPI:
+		ret_irq = IRQ_SPI;
+		break;
+
+	case CH_UART0_RX:
+		ret_irq = IRQ_UART0_RX;
+		break;
+
+	case CH_UART0_TX:
+		ret_irq = IRQ_UART0_TX;
+		break;
+
+	case CH_MEM_STREAM0_SRC:
+	case CH_MEM_STREAM0_DEST:
+		ret_irq = IRQ_MEM_DMA0;
+		break;
+
+	case CH_MEM_STREAM1_SRC:
+	case CH_MEM_STREAM1_DEST:
+		ret_irq = IRQ_MEM_DMA1;
+		break;
+	}
+	return ret_irq;
+}
diff --git a/arch/blackfin/mach-bf527/head.S b/arch/blackfin/mach-bf527/head.S
new file mode 100644
index 0000000..cdb00a0
--- /dev/null
+++ b/arch/blackfin/mach-bf527/head.S
@@ -0,0 +1,456 @@
+/*
+ * File:         arch/blackfin/mach-bf527/head.S
+ * Based on:     arch/blackfin/mach-bf533/head.S
+ * Author:       Jeff Dionne <jeff@uclinux.org> COPYRIGHT 1998 D. Jeff Dionne
+ *
+ * Created:      1998
+ * Description:  Startup code for Blackfin BF537
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/blackfin.h>
+#include <asm/trace.h>
+
+#if CONFIG_BFIN_KERNEL_CLOCK
+#include <asm/mach-common/clocks.h>
+#include <asm/mach/mem_init.h>
+#endif
+
+.global __rambase
+.global __ramstart
+.global __ramend
+.extern ___bss_stop
+.extern ___bss_start
+.extern _bf53x_relocate_l1_mem
+
+#define INITIAL_STACK	0xFFB01000
+
+__INIT
+
+ENTRY(__start)
+	/* R0: argument of command line string, passed from uboot, save it */
+	R7 = R0;
+	/* Enable Cycle Counter and Nesting Of Interrupts */
+#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
+	R0 = SYSCFG_SNEN;
+#else
+	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
+#endif
+	SYSCFG = R0;
+	R0 = 0;
+
+	/* Clear Out All the data and pointer Registers */
+	R1 = R0;
+	R2 = R0;
+	R3 = R0;
+	R4 = R0;
+	R5 = R0;
+	R6 = R0;
+
+	P0 = R0;
+	P1 = R0;
+	P2 = R0;
+	P3 = R0;
+	P4 = R0;
+	P5 = R0;
+
+	LC0 = r0;
+	LC1 = r0;
+	L0 = r0;
+	L1 = r0;
+	L2 = r0;
+	L3 = r0;
+
+	/* Clear Out All the DAG Registers */
+	B0 = r0;
+	B1 = r0;
+	B2 = r0;
+	B3 = r0;
+
+	I0 = r0;
+	I1 = r0;
+	I2 = r0;
+	I3 = r0;
+
+	M0 = r0;
+	M1 = r0;
+	M2 = r0;
+	M3 = r0;
+
+	trace_buffer_init(p0,r0);
+	P0 = R1;
+	R0 = R1;
+
+	/* Turn off the icache */
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENICPLB;
+	R0 = R0 & R1;
+
+	/* Anomaly 05000125 */
+#if ANOMALY_05000125
+	CLI R2;
+	SSYNC;
+#endif
+	[p0] = R0;
+	SSYNC;
+#if ANOMALY_05000125
+	STI R2;
+#endif
+
+	/* Turn off the dcache */
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENDCPLB;
+	R0 = R0 & R1;
+
+	/* Anomaly 05000125 */
+#if ANOMALY_05000125
+	CLI R2;
+	SSYNC;
+#endif
+	[p0] = R0;
+	SSYNC;
+#if ANOMALY_05000125
+	STI R2;
+#endif
+
+
+#if defined(CONFIG_BF527)
+	p0.h = hi(EMAC_SYSTAT);
+	p0.l = lo(EMAC_SYSTAT);
+	R0.h = 0xFFFF; /* Clear EMAC Interrupt Status bits */
+	R0.l = 0xFFFF;
+	[P0] = R0;
+	SSYNC;
+#endif
+
+	/* Initialise UART - when booting from u-boot, the UART is not disabled
+	 * so if we dont initalize here, our serial console gets hosed */
+	p0.h = hi(UART1_LCR);
+	p0.l = lo(UART1_LCR);
+	r0 = 0x0(Z);
+	w[p0] = r0.L;	/* To enable DLL writes */
+	ssync;
+
+	p0.h = hi(UART1_DLL);
+	p0.l = lo(UART1_DLL);
+	r0 = 0x0(Z);
+	w[p0] = r0.L;
+	ssync;
+
+	p0.h = hi(UART1_DLH);
+	p0.l = lo(UART1_DLH);
+	r0 = 0x00(Z);
+	w[p0] = r0.L;
+	ssync;
+
+	p0.h = hi(UART1_GCTL);
+	p0.l = lo(UART1_GCTL);
+	r0 = 0x0(Z);
+	w[p0] = r0.L;	/* To enable UART clock */
+	ssync;
+
+	/* Initialize stack pointer */
+	sp.l = lo(INITIAL_STACK);
+	sp.h = hi(INITIAL_STACK);
+	fp = sp;
+	usp = sp;
+
+#ifdef CONFIG_EARLY_PRINTK
+	SP += -12;
+	call _init_early_exception_vectors;
+	SP += 12;
+#endif
+
+	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
+	call _bf53x_relocate_l1_mem;
+#if CONFIG_BFIN_KERNEL_CLOCK
+	call _start_dma_code;
+#endif
+
+	/* Code for initializing Async memory banks */
+
+	p2.h = hi(EBIU_AMBCTL1);
+	p2.l = lo(EBIU_AMBCTL1);
+	r0.h = hi(AMBCTL1VAL);
+	r0.l = lo(AMBCTL1VAL);
+	[p2] = r0;
+	ssync;
+
+	p2.h = hi(EBIU_AMBCTL0);
+	p2.l = lo(EBIU_AMBCTL0);
+	r0.h = hi(AMBCTL0VAL);
+	r0.l = lo(AMBCTL0VAL);
+	[p2] = r0;
+	ssync;
+
+	p2.h = hi(EBIU_AMGCTL);
+	p2.l = lo(EBIU_AMGCTL);
+	r0 = AMGCTLVAL;
+	w[p2] = r0;
+	ssync;
+
+	/* This section keeps the processor in supervisor mode
+	 * during kernel boot.  Switches to user mode at end of boot.
+	 * See page 3-9 of Hardware Reference manual for documentation.
+	 */
+
+	/* EVT15 = _real_start */
+
+	p0.l = lo(EVT15);
+	p0.h = hi(EVT15);
+	p1.l = _real_start;
+	p1.h = _real_start;
+	[p0] = p1;
+	csync;
+
+	p0.l = lo(IMASK);
+	p0.h = hi(IMASK);
+	p1.l = IMASK_IVG15;
+	p1.h = 0x0;
+	[p0] = p1;
+	csync;
+
+	raise 15;
+	p0.l = .LWAIT_HERE;
+	p0.h = .LWAIT_HERE;
+	reti = p0;
+#if ANOMALY_05000281
+	nop; nop; nop;
+#endif
+	rti;
+
+.LWAIT_HERE:
+	jump .LWAIT_HERE;
+ENDPROC(__start)
+
+ENTRY(_real_start)
+	[ -- sp ] = reti;
+	p0.l = lo(WDOG_CTL);
+	p0.h = hi(WDOG_CTL);
+	r0 = 0xAD6(z);
+	w[p0] = r0;	/* watchdog off for now */
+	ssync;
+
+	/* Code update for BSS size == 0
+	 * Zero out the bss region.
+	 */
+
+	p1.l = ___bss_start;
+	p1.h = ___bss_start;
+	p2.l = ___bss_stop;
+	p2.h = ___bss_stop;
+	r0 = 0;
+	p2 -= p1;
+	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
+.L_clear_bss:
+	B[p1++] = r0;
+
+	/* In case there is a NULL pointer reference
+	 * Zero out region before stext
+	 */
+
+	p1.l = 0x0;
+	p1.h = 0x0;
+	r0.l = __stext;
+	r0.h = __stext;
+	r0 = r0 >> 1;
+	p2 = r0;
+	r0 = 0;
+	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
+.L_clear_zero:
+	W[p1++] = r0;
+
+	/* pass the uboot arguments to the global value command line */
+	R0 = R7;
+	call _cmdline_init;
+
+	p1.l = __rambase;
+	p1.h = __rambase;
+	r0.l = __sdata;
+	r0.h = __sdata;
+	[p1] = r0;
+
+	p1.l = __ramstart;
+	p1.h = __ramstart;
+	p3.l = ___bss_stop;
+	p3.h = ___bss_stop;
+
+	r1 = p3;
+	[p1] = r1;
+
+	/*
+	 * load the current thread pointer and stack
+	 */
+	r1.l = _init_thread_union;
+	r1.h = _init_thread_union;
+
+	r2.l = 0x2000;
+	r2.h = 0x0000;
+	r1 = r1 + r2;
+	sp = r1;
+	usp = sp;
+	fp = sp;
+	jump.l _start_kernel;
+ENDPROC(_real_start)
+
+__FINIT
+
+.section .l1.text
+#if CONFIG_BFIN_KERNEL_CLOCK
+ENTRY(_start_dma_code)
+
+	/* Enable PHY CLK buffer output */
+	p0.h = hi(VR_CTL);
+	p0.l = lo(VR_CTL);
+	r0.l = w[p0];
+	bitset(r0, 14);
+	w[p0] = r0.l;
+	ssync;
+
+	p0.h = hi(SIC_IWR0);
+	p0.l = lo(SIC_IWR0);
+	r0.l = 0x1;
+	r0.h = 0x0;
+	[p0] = r0;
+	SSYNC;
+
+	/*
+	 *  Set PLL_CTL
+	 *   - [14:09] = MSEL[5:0] : CLKIN / VCO multiplication factors
+	 *   - [8]     = BYPASS    : BYPASS the PLL, run CLKIN into CCLK/SCLK
+	 *   - [7]     = output delay (add 200ps of delay to mem signals)
+	 *   - [6]     = input delay (add 200ps of input delay to mem signals)
+	 *   - [5]     = PDWN      : 1=All Clocks off
+	 *   - [3]     = STOPCK    : 1=Core Clock off
+	 *   - [1]     = PLL_OFF   : 1=Disable Power to PLL
+	 *   - [0]     = DF        : 1=Pass CLKIN/2 to PLL / 0=Pass CLKIN to PLL
+	 *   all other bits set to zero
+	 */
+
+	p0.h = hi(PLL_LOCKCNT);
+	p0.l = lo(PLL_LOCKCNT);
+	r0 = 0x300(Z);
+	w[p0] = r0.l;
+	ssync;
+
+	P2.H = hi(EBIU_SDGCTL);
+	P2.L = lo(EBIU_SDGCTL);
+	R0 = [P2];
+	BITSET (R0, 24);
+	[P2] = R0;
+	SSYNC;
+
+	r0 = CONFIG_VCO_MULT & 63;       /* Load the VCO multiplier         */
+	r0 = r0 << 9;                    /* Shift it over,                  */
+	r1 = CLKIN_HALF;                 /* Do we need to divide CLKIN by 2?*/
+	r0 = r1 | r0;
+	r1 = PLL_BYPASS;                 /* Bypass the PLL?                 */
+	r1 = r1 << 8;                    /* Shift it over                   */
+	r0 = r1 | r0;                    /* add them all together           */
+
+	p0.h = hi(PLL_CTL);
+	p0.l = lo(PLL_CTL);              /* Load the address                */
+	cli r2;                          /* Disable interrupts              */
+	ssync;
+	w[p0] = r0.l;                    /* Set the value                   */
+	idle;                            /* Wait for the PLL to stablize    */
+	sti r2;                          /* Enable interrupts               */
+
+.Lcheck_again:
+	p0.h = hi(PLL_STAT);
+	p0.l = lo(PLL_STAT);
+	R0 = W[P0](Z);
+	CC = BITTST(R0,5);
+	if ! CC jump .Lcheck_again;
+
+	/* Configure SCLK & CCLK Dividers */
+	r0 = (CONFIG_CCLK_ACT_DIV | CONFIG_SCLK_DIV);
+	p0.h = hi(PLL_DIV);
+	p0.l = lo(PLL_DIV);
+	w[p0] = r0.l;
+	ssync;
+
+	p0.l = lo(EBIU_SDRRC);
+	p0.h = hi(EBIU_SDRRC);
+	r0 = mem_SDRRC;
+	w[p0] = r0.l;
+	ssync;
+
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
+	r0 = mem_SDBCTL;
+	w[p0] = r0.l;
+	ssync;
+
+	P2.H = hi(EBIU_SDGCTL);
+	P2.L = lo(EBIU_SDGCTL);
+	R0 = [P2];
+	BITCLR (R0, 24);
+	p0.h = hi(EBIU_SDSTAT);
+	p0.l = lo(EBIU_SDSTAT);
+	r2.l = w[p0];
+	cc = bittst(r2,3);
+	if !cc jump .Lskip;
+	NOP;
+	BITSET (R0, 23);
+.Lskip:
+	[P2] = R0;
+	SSYNC;
+
+	R0.L = lo(mem_SDGCTL);
+	R0.H = hi(mem_SDGCTL);
+	R1 = [p2];
+	R1 = R1 | R0;
+	[P2] = R1;
+	SSYNC;
+
+	p0.h = hi(SIC_IWR0);
+	p0.l = lo(SIC_IWR0);
+	r0.l = lo(IWR_ENABLE_ALL);
+	r0.h = hi(IWR_ENABLE_ALL);
+	[p0] = r0;
+	SSYNC;
+
+	RTS;
+ENDPROC(_start_dma_code)
+#endif /* CONFIG_BFIN_KERNEL_CLOCK */
+
+.data
+
+/*
+ * Set up the usable of RAM stuff. Size of RAM is determined then
+ * an initial stack set up at the end.
+ */
+
+.align 4
+__rambase:
+.long   0
+__ramstart:
+.long   0
+__ramend:
+.long   0
diff --git a/arch/blackfin/mach-bf527/ints-priority.c b/arch/blackfin/mach-bf527/ints-priority.c
new file mode 100644
index 0000000..1fa3897
--- /dev/null
+++ b/arch/blackfin/mach-bf527/ints-priority.c
@@ -0,0 +1,100 @@
+/*
+ * File:         arch/blackfin/mach-bf537/ints-priority.c
+ * Based on:     arch/blackfin/mach-bf533/ints-priority.c
+ * Author:       Michael Hennerich (michael.hennerich@analog.com)
+ *
+ * Created:
+ * Description:  Set up the interrupt priorities
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <asm/blackfin.h>
+
+void program_IAR(void)
+{
+	/* Program the IAR0 Register with the configured priority */
+	bfin_write_SIC_IAR0(((CONFIG_IRQ_PLL_WAKEUP - 7) << IRQ_PLL_WAKEUP_POS) |
+			((CONFIG_IRQ_DMA0_ERROR - 7) << IRQ_DMA0_ERROR_POS) |
+			((CONFIG_IRQ_DMAR0_BLK - 7) << IRQ_DMAR0_BLK_POS) |
+			((CONFIG_IRQ_DMAR1_BLK - 7) << IRQ_DMAR1_BLK_POS) |
+			((CONFIG_IRQ_DMAR0_OVR - 7) << IRQ_DMAR0_OVR_POS) |
+			((CONFIG_IRQ_DMAR1_OVR - 7) << IRQ_DMAR1_OVR_POS) |
+			((CONFIG_IRQ_PPI_ERROR - 7) << IRQ_PPI_ERROR_POS) |
+			((CONFIG_IRQ_MAC_ERROR - 7) << IRQ_MAC_ERROR_POS));
+
+
+	bfin_write_SIC_IAR1(((CONFIG_IRQ_SPORT0_ERROR - 7) << IRQ_SPORT0_ERROR_POS) |
+			((CONFIG_IRQ_SPORT1_ERROR - 7) << IRQ_SPORT1_ERROR_POS) |
+			((CONFIG_IRQ_UART0_ERROR - 7) << IRQ_UART0_ERROR_POS) |
+			((CONFIG_IRQ_UART1_ERROR - 7) << IRQ_UART1_ERROR_POS) |
+			((CONFIG_IRQ_RTC - 7) << IRQ_RTC_POS) |
+			((CONFIG_IRQ_PPI - 7) << IRQ_PPI_POS));
+
+	bfin_write_SIC_IAR2(((CONFIG_IRQ_SPORT0_RX - 7) << IRQ_SPORT0_RX_POS) |
+			((CONFIG_IRQ_SPORT0_TX - 7) << IRQ_SPORT0_TX_POS) |
+			((CONFIG_IRQ_SPORT1_RX - 7) << IRQ_SPORT1_RX_POS) |
+			((CONFIG_IRQ_SPORT1_TX - 7) << IRQ_SPORT1_TX_POS) |
+			((CONFIG_IRQ_TWI - 7) << IRQ_TWI_POS) |
+			((CONFIG_IRQ_SPI - 7) << IRQ_SPI_POS) |
+			((CONFIG_IRQ_UART0_RX - 7) << IRQ_UART0_RX_POS) |
+			((CONFIG_IRQ_UART0_TX - 7) << IRQ_UART0_TX_POS));
+
+	bfin_write_SIC_IAR3(((CONFIG_IRQ_UART1_RX - 7) << IRQ_UART1_RX_POS) |
+			((CONFIG_IRQ_UART1_TX - 7) << IRQ_UART1_TX_POS) |
+			((CONFIG_IRQ_OPTSEC - 7) << IRQ_OPTSEC_POS) |
+			((CONFIG_IRQ_CNT - 7) << IRQ_CNT_POS) |
+			((CONFIG_IRQ_MAC_RX - 7) << IRQ_MAC_RX_POS) |
+			((CONFIG_IRQ_PORTH_INTA - 7) << IRQ_PORTH_INTA_POS) |
+			((CONFIG_IRQ_MAC_TX - 7) << IRQ_MAC_TX_POS) |
+			((CONFIG_IRQ_PORTH_INTB - 7) << IRQ_PORTH_INTB_POS));
+
+	bfin_write_SIC_IAR4(((CONFIG_IRQ_TMR0 - 7) << IRQ_TMR0_POS) |
+			((CONFIG_IRQ_TMR1 - 7) << IRQ_TMR1_POS) |
+			((CONFIG_IRQ_TMR2 - 7) << IRQ_TMR2_POS) |
+			((CONFIG_IRQ_TMR3 - 7) << IRQ_TMR3_POS) |
+			((CONFIG_IRQ_TMR4 - 7) << IRQ_TMR4_POS) |
+			((CONFIG_IRQ_TMR5 - 7) << IRQ_TMR5_POS) |
+			((CONFIG_IRQ_TMR6 - 7) << IRQ_TMR6_POS) |
+			((CONFIG_IRQ_TMR7 - 7) << IRQ_TMR7_POS));
+
+	bfin_write_SIC_IAR5(((CONFIG_IRQ_PORTG_INTA - 7) << IRQ_PORTG_INTA_POS) |
+			((CONFIG_IRQ_PORTG_INTB - 7) << IRQ_PORTG_INTB_POS) |
+			((CONFIG_IRQ_MEM_DMA0 - 7) << IRQ_MEM_DMA0_POS) |
+			((CONFIG_IRQ_MEM_DMA1 - 7) << IRQ_MEM_DMA1_POS) |
+			((CONFIG_IRQ_WATCH - 7) << IRQ_WATCH_POS) |
+			((CONFIG_IRQ_PORTF_INTA - 7) << IRQ_PORTF_INTA_POS) |
+			((CONFIG_IRQ_PORTF_INTB - 7) << IRQ_PORTF_INTB_POS) |
+			((CONFIG_IRQ_SPI_ERROR - 7) << IRQ_SPI_ERROR_POS));
+
+	bfin_write_SIC_IAR6(((CONFIG_IRQ_NFC_ERROR - 7) << IRQ_NFC_ERROR_POS) |
+			((CONFIG_IRQ_HDMA_ERROR - 7) << IRQ_HDMA_ERROR_POS) |
+			((CONFIG_IRQ_HDMA - 7) << IRQ_HDMA_POS) |
+			((CONFIG_IRQ_USB_EINT - 7) << IRQ_USB_EINT_POS) |
+			((CONFIG_IRQ_USB_INT0 - 7) << IRQ_USB_INT0_POS) |
+			((CONFIG_IRQ_USB_INT1 - 7) << IRQ_USB_INT1_POS) |
+			((CONFIG_IRQ_USB_INT2 - 7) << IRQ_USB_INT2_POS) |
+			((CONFIG_IRQ_USB_DMA - 7) << IRQ_USB_DMA_POS));
+
+	SSYNC();
+}
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index a57b52d..1c5a86a 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -42,7 +42,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "Bluetechnix CM BF533";
+const char bfin_board_name[] = "Bluetechnix CM BF533";
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* all SPI peripherals info goes here */
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 5c1e35d..34b6392 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -43,7 +43,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "ADDS-BF533-EZKIT";
+const char bfin_board_name[] = "ADDS-BF533-EZKIT";
 
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
diff --git a/arch/blackfin/mach-bf533/boards/generic_board.c b/arch/blackfin/mach-bf533/boards/generic_board.c
index 9bc1f0d..310b777 100644
--- a/arch/blackfin/mach-bf533/boards/generic_board.c
+++ b/arch/blackfin/mach-bf533/boards/generic_board.c
@@ -35,7 +35,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "UNKNOWN BOARD";
+const char bfin_board_name[] = "UNKNOWN BOARD";
 
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 8975e06..f84be4e 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -46,7 +46,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "ADDS-BF533-STAMP";
+const char bfin_board_name[] = "ADDS-BF533-STAMP";
 
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 44dea05..52e2320 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -43,7 +43,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "Bluetechnix CM BF537";
+const char bfin_board_name[] = "Bluetechnix CM BF537";
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* all SPI peripherals info goes here */
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 6668c8e..255da7a 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -49,7 +49,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "GENERIC Board";
+const char bfin_board_name[] = "GENERIC Board";
 
 /*
  *  Driver needs to know address, irq and flag pin.
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index f83a254..87b8089 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -47,7 +47,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "PNAV-1.0";
+const char bfin_board_name[] = "PNAV-1.0";
 
 /*
  *  Driver needs to know address, irq and flag pin.
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index f42ba3a..cc41f6c 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -49,7 +49,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "ADDS-BF537-STAMP";
+const char bfin_board_name[] = "ADDS-BF537-STAMP";
 
 /*
  *  Driver needs to know address, irq and flag pin.
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 046e6d8..6b6490e 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -49,7 +49,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "ADSP-BF548-EZKIT";
+const char bfin_board_name[] = "ADSP-BF548-EZKIT";
 
 /*
  *  Driver needs to know address, irq and flag pin.
@@ -560,7 +560,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bf54x_spi_master0,
-/*	&bf54x_spi_master1,*/
+	&bf54x_spi_master1,
 #endif
 
 #if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
diff --git a/arch/blackfin/mach-bf548/dma.c b/arch/blackfin/mach-bf548/dma.c
index a818411..957bf13 100644
--- a/arch/blackfin/mach-bf548/dma.c
+++ b/arch/blackfin/mach-bf548/dma.c
@@ -64,6 +64,7 @@
 	(struct dma_register *) MDMA_D3_NEXT_DESC_PTR,
 	(struct dma_register *) MDMA_S3_NEXT_DESC_PTR,
 };
+EXPORT_SYMBOL(base_addr);
 
 int channel2irq(unsigned int channel)
 {
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index cd827a1..97aeb43 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -42,7 +42,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "Bluetechnix CM BF561";
+const char bfin_board_name[] = "Bluetechnix CM BF561";
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* all SPI peripherals info goes here */
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 57e14ed..059d516 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -39,7 +39,7 @@
 /*
  * Name the Board for the /proc/cpuinfo
  */
-char *bfin_board_name = "ADDS-BF561-EZKIT";
+const char bfin_board_name[] = "ADDS-BF561-EZKIT";
 
 #define ISP1761_BASE       0x2C0F0000
 #define ISP1761_IRQ        IRQ_PF10
diff --git a/arch/blackfin/mach-bf561/boards/generic_board.c b/arch/blackfin/mach-bf561/boards/generic_board.c
index 4dfea5d..46816be 100644
--- a/arch/blackfin/mach-bf561/boards/generic_board.c
+++ b/arch/blackfin/mach-bf561/boards/generic_board.c
@@ -32,7 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 
-char *bfin_board_name = "UNKNOWN BOARD";
+const char bfin_board_name[] = "UNKNOWN BOARD";
 
 /*
  *  Driver needs to know address, irq and flag pin.
diff --git a/arch/blackfin/mach-bf561/boards/tepla.c b/arch/blackfin/mach-bf561/boards/tepla.c
index c442eb2..4a17c6d 100644
--- a/arch/blackfin/mach-bf561/boards/tepla.c
+++ b/arch/blackfin/mach-bf561/boards/tepla.c
@@ -16,7 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 
-char *bfin_board_name = "Tepla-BF561";
+const char bfin_board_name[] = "Tepla-BF561";
 
 /*
  *  Driver needs to know address, irq and flag pin.
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 2db3546..c2f05fa 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -52,7 +52,13 @@
  * -
  */
 
-unsigned long irq_flags = 0;
+/* Initialize this to an actual value to force it into the .data
+ * section so that we know it is properly initialized at entry into
+ * the kernel but before bss is initialized to zero (which is where
+ * it would live otherwise).  The 0x1f magic represents the IRQs we
+ * cannot actually mask out in hardware.
+ */
+unsigned long irq_flags = 0x1f;
 
 /* The number of spurious interrupts */
 atomic_t num_spurious;
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index d3b7672..2d2b635 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -58,7 +58,13 @@
  * -
  */
 
-unsigned long irq_flags = 0;
+/* Initialize this to an actual value to force it into the .data
+ * section so that we know it is properly initialized at entry into
+ * the kernel but before bss is initialized to zero (which is where
+ * it would live otherwise).  The 0x1f magic represents the IRQs we
+ * cannot actually mask out in hardware.
+ */
+unsigned long irq_flags = 0x1f;
 
 /* The number of spurious interrupts */
 atomic_t num_spurious;
@@ -92,10 +98,15 @@ static void __init search_IAR(void)
 
 		for (irqn = 0; irqn < NR_PERI_INTS; irqn++) {
 			int iar_shift = (irqn & 7) * 4;
-			if (ivg ==
+				if (ivg ==
 			    (0xf &
+#ifndef CONFIG_BF52x
 			     bfin_read32((unsigned long *)SIC_IAR0 +
 					 (irqn >> 3)) >> iar_shift)) {
+#else
+			     bfin_read32((unsigned long *)SIC_IAR0 +
+					 ((irqn%32) >> 3) + ((irqn / 32) * 16)) >> iar_shift)) {
+#endif
 				ivg_table[irq_pos].irqno = IVG7 + irqn;
 				ivg_table[irq_pos].isrflag = 1 << (irqn % 32);
 				ivg7_13[ivg].istop++;
@@ -140,7 +151,7 @@ static void bfin_core_unmask_irq(unsigned int irq)
 
 static void bfin_internal_mask_irq(unsigned int irq)
 {
-#ifndef CONFIG_BF54x
+#ifdef CONFIG_BF53x
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() &
 			     ~(1 << (irq - (IRQ_CORETMR + 1))));
 #else
@@ -155,7 +166,7 @@ static void bfin_internal_mask_irq(unsigned int irq)
 
 static void bfin_internal_unmask_irq(unsigned int irq)
 {
-#ifndef CONFIG_BF54x
+#ifdef CONFIG_BF53x
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() |
 			     (1 << (irq - (IRQ_CORETMR + 1))));
 #else
@@ -750,13 +761,15 @@ int __init init_arch_irq(void)
 	int irq;
 	unsigned long ilat = 0;
 	/*  Disable all the peripheral intrs  - page 4-29 HW Ref manual */
-#ifdef CONFIG_BF54x
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)
 	bfin_write_SIC_IMASK0(SIC_UNMASK_ALL);
 	bfin_write_SIC_IMASK1(SIC_UNMASK_ALL);
-	bfin_write_SIC_IMASK2(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
 	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
+#ifdef CONFIG_BF54x
+	bfin_write_SIC_IMASK2(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
+#endif
 #else
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
@@ -787,7 +800,7 @@ int __init init_arch_irq(void)
 
 			switch (irq) {
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
-#ifndef CONFIG_BF54x
+#if defined(CONFIG_BF53x)
 			case IRQ_PROG_INTA:
 				set_irq_chained_handler(irq,
 							bfin_demux_gpio_irq);
@@ -798,7 +811,7 @@ int __init init_arch_irq(void)
 							bfin_demux_gpio_irq);
 				break;
 #endif
-#else
+#elif defined(CONFIG_BF54x)
 			case IRQ_PINT0:
 				set_irq_chained_handler(irq,
 							bfin_demux_gpio_irq);
@@ -815,7 +828,20 @@ int __init init_arch_irq(void)
 				set_irq_chained_handler(irq,
 							bfin_demux_gpio_irq);
 				break;
-#endif				/*CONFIG_BF54x */
+#elif defined(CONFIG_BF52x)
+			case IRQ_PORTF_INTA:
+				set_irq_chained_handler(irq,
+							bfin_demux_gpio_irq);
+				break;
+			case IRQ_PORTG_INTA:
+				set_irq_chained_handler(irq,
+							bfin_demux_gpio_irq);
+				break;
+			case IRQ_PORTH_INTA:
+				set_irq_chained_handler(irq,
+							bfin_demux_gpio_irq);
+				break;
+#endif
 #endif
 			default:
 				set_irq_handler(irq, handle_simple_irq);
@@ -880,14 +906,15 @@ void do_irq(int vec, struct pt_regs *fp)
 	} else {
 		struct ivgx *ivg = ivg7_13[vec - IVG7].ifirst;
 		struct ivgx *ivg_stop = ivg7_13[vec - IVG7].istop;
-#ifdef CONFIG_BF54x
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)
 		unsigned long sic_status[3];
 
 		SSYNC();
-		sic_status[0] = bfin_read_SIC_ISR(0) & bfin_read_SIC_IMASK(0);
-		sic_status[1] = bfin_read_SIC_ISR(1) & bfin_read_SIC_IMASK(1);
-		sic_status[2] = bfin_read_SIC_ISR(2) & bfin_read_SIC_IMASK(2);
-
+		sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
+		sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
+#ifdef CONFIG_BF54x
+		sic_status[2] = bfin_read_SIC_ISR2() & bfin_read_SIC_IMASK2();
+#endif
 		for (;; ivg++) {
 			if (ivg >= ivg_stop) {
 				atomic_inc(&num_spurious);
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 87665d7..ed438bc 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -624,7 +624,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on DMA_UNCACHED_1M && !KGDB_UART
+	depends on !DMA_UNCACHED_NONE && !KGDB_UART
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
diff --git a/include/asm-blackfin/bf5xx_timers.h b/include/asm-blackfin/bf5xx_timers.h
deleted file mode 100644
index 86c7703..0000000
--- a/include/asm-blackfin/bf5xx_timers.h
+++ /dev/null
@@ -1,209 +0,0 @@
-/*
- * include/asm/bf5xx_timers.h
- *
- * This file contains the major Data structures and constants
- * used for General Purpose Timer Implementation in BF5xx
- *
- * Copyright (C) 2005 John DeHority
- * Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
- *
- */
-
-#ifndef _BLACKFIN_TIMERS_H_
-#define _BLACKFIN_TIMERS_H_
-
-#undef MAX_BLACKFIN_GPTIMERS
-/*
- * BF537: 8 timers:
- */
-#if defined(CONFIG_BF537)
-#  define MAX_BLACKFIN_GPTIMERS 8
-#  define TIMER0_GROUP_REG     TIMER_ENABLE
-#endif
-/*
- * BF561: 12 timers:
- */
-#if defined(CONFIG_BF561)
-#  define MAX_BLACKFIN_GPTIMERS 12
-#  define TIMER0_GROUP_REG     TMRS8_ENABLE
-#  define TIMER8_GROUP_REG     TMRS4_ENABLE
-#endif
-/*
- * All others: 3 timers:
- */
-#if !defined(MAX_BLACKFIN_GPTIMERS)
-#  define MAX_BLACKFIN_GPTIMERS 3
-#  define TIMER0_GROUP_REG     TIMER_ENABLE
-#endif
-
-#define BLACKFIN_GPTIMER_IDMASK ((1UL << MAX_BLACKFIN_GPTIMERS) - 1)
-#define BFIN_TIMER_OCTET(x) ((x) >> 3)
-
-/* used in masks for timer_enable() and timer_disable() */
-#define TIMER0bit  0x0001  /*  0001b */
-#define TIMER1bit  0x0002  /*  0010b */
-#define TIMER2bit  0x0004  /*  0100b */
-
-#if (MAX_BLACKFIN_GPTIMERS > 3)
-#  define TIMER3bit  0x0008
-#  define TIMER4bit  0x0010
-#  define TIMER5bit  0x0020
-#  define TIMER6bit  0x0040
-#  define TIMER7bit  0x0080
-#endif
-
-#if (MAX_BLACKFIN_GPTIMERS > 8)
-#  define TIMER8bit  0x0100
-#  define TIMER9bit  0x0200
-#  define TIMER10bit 0x0400
-#  define TIMER11bit 0x0800
-#endif
-
-#define TIMER0_id   0
-#define TIMER1_id   1
-#define TIMER2_id   2
-
-#if (MAX_BLACKFIN_GPTIMERS > 3)
-#  define TIMER3_id   3
-#  define TIMER4_id   4
-#  define TIMER5_id   5
-#  define TIMER6_id   6
-#  define TIMER7_id   7
-#endif
-
-#if (MAX_BLACKFIN_GPTIMERS > 8)
-#  define TIMER8_id   8
-#  define TIMER9_id   9
-#  define TIMER10_id 10
-#  define TIMER11_id 11
-#endif
-
-/* associated timers for ppi framesync: */
-
-#if defined(CONFIG_BF561)
-#  define FS0_1_TIMER_ID   TIMER8_id
-#  define FS0_2_TIMER_ID   TIMER9_id
-#  define FS1_1_TIMER_ID   TIMER10_id
-#  define FS1_2_TIMER_ID   TIMER11_id
-#  define FS0_1_TIMER_BIT  TIMER8bit
-#  define FS0_2_TIMER_BIT  TIMER9bit
-#  define FS1_1_TIMER_BIT  TIMER10bit
-#  define FS1_2_TIMER_BIT  TIMER11bit
-#  undef FS1_TIMER_ID
-#  undef FS2_TIMER_ID
-#  undef FS1_TIMER_BIT
-#  undef FS2_TIMER_BIT
-#else
-#  define FS1_TIMER_ID  TIMER0_id
-#  define FS2_TIMER_ID  TIMER1_id
-#  define FS1_TIMER_BIT TIMER0bit
-#  define FS2_TIMER_BIT TIMER1bit
-#endif
-
-/*
-** Timer Configuration Register Bits
-*/
-#define TIMER_ERR           0xC000
-#define TIMER_ERR_OVFL      0x4000
-#define TIMER_ERR_PROG_PER  0x8000
-#define TIMER_ERR_PROG_PW   0xC000
-#define TIMER_EMU_RUN       0x0200
-#define	TIMER_TOGGLE_HI     0x0100
-#define	TIMER_CLK_SEL       0x0080
-#define TIMER_OUT_DIS       0x0040
-#define TIMER_TIN_SEL       0x0020
-#define TIMER_IRQ_ENA       0x0010
-#define TIMER_PERIOD_CNT    0x0008
-#define TIMER_PULSE_HI      0x0004
-#define TIMER_MODE          0x0003
-#define TIMER_MODE_PWM      0x0001
-#define TIMER_MODE_WDTH     0x0002
-#define TIMER_MODE_EXT_CLK  0x0003
-
-/*
-** Timer Status Register Bits
-*/
-#define TIMER_STATUS_TIMIL0 0x0001
-#define TIMER_STATUS_TIMIL1 0x0002
-#define TIMER_STATUS_TIMIL2 0x0004
-#if (MAX_BLACKFIN_GPTIMERS > 3)
-#  define TIMER_STATUS_TIMIL3 0x00000008
-#  define TIMER_STATUS_TIMIL4 0x00010000
-#  define TIMER_STATUS_TIMIL5 0x00020000
-#  define TIMER_STATUS_TIMIL6 0x00040000
-#  define TIMER_STATUS_TIMIL7 0x00080000
-#  if (MAX_BLACKFIN_GPTIMERS > 8)
-#    define TIMER_STATUS_TIMIL8  0x0001
-#    define TIMER_STATUS_TIMIL9  0x0002
-#    define TIMER_STATUS_TIMIL10 0x0004
-#    define TIMER_STATUS_TIMIL11 0x0008
-#  endif
-#  define TIMER_STATUS_INTR   0x000F000F
-#else
-#  define TIMER_STATUS_INTR   0x0007	/* any timer interrupt */
-#endif
-
-#define TIMER_STATUS_TOVF0  0x0010	/* timer 0 overflow error */
-#define TIMER_STATUS_TOVF1  0x0020
-#define TIMER_STATUS_TOVF2  0x0040
-#if (MAX_BLACKFIN_GPTIMERS > 3)
-#  define TIMER_STATUS_TOVF3  0x00000080
-#  define TIMER_STATUS_TOVF4  0x00100000
-#  define TIMER_STATUS_TOVF5  0x00200000
-#  define TIMER_STATUS_TOVF6  0x00400000
-#  define TIMER_STATUS_TOVF7  0x00800000
-#  if (MAX_BLACKFIN_GPTIMERS > 8)
-#    define TIMER_STATUS_TOVF8   0x0010
-#    define TIMER_STATUS_TOVF9   0x0020
-#    define TIMER_STATUS_TOVF10  0x0040
-#    define TIMER_STATUS_TOVF11  0x0080
-#  endif
-#  define TIMER_STATUS_OFLOW  0x00F000F0
-#else
-#  define TIMER_STATUS_OFLOW  0x0070	/* any timer overflow */
-#endif
-
-/*
-** Timer Slave Enable Status : write 1 to clear
-*/
-#define TIMER_STATUS_TRUN0  0x1000
-#define TIMER_STATUS_TRUN1  0x2000
-#define TIMER_STATUS_TRUN2  0x4000
-#if (MAX_BLACKFIN_GPTIMERS > 3)
-#  define TIMER_STATUS_TRUN3  0x00008000
-#  define TIMER_STATUS_TRUN4  0x10000000
-#  define TIMER_STATUS_TRUN5  0x20000000
-#  define TIMER_STATUS_TRUN6  0x40000000
-#  define TIMER_STATUS_TRUN7  0x80000000
-#  define TIMER_STATUS_TRUN   0xF000F000
-#  if (MAX_BLACKFIN_GPTIMERS > 8)
-#    define TIMER_STATUS_TRUN8  0x1000
-#    define TIMER_STATUS_TRUN9  0x2000
-#    define TIMER_STATUS_TRUN10 0x4000
-#    define TIMER_STATUS_TRUN11 0x8000
-#  endif
-#else
-#  define TIMER_STATUS_TRUN   0x7000
-#endif
-
-/*******************************************************************************
-*	GP_TIMER API's
-*******************************************************************************/
-
-void  set_gptimer_pwidth    (int timer_id, int width);
-int   get_gptimer_pwidth    (int timer_id);
-void  set_gptimer_period    (int timer_id, int period);
-int   get_gptimer_period    (int timer_id);
-int   get_gptimer_count     (int timer_id);
-short get_gptimer_intr      (int timer_id);
-void  set_gptimer_config    (int timer_id, short config);
-short get_gptimer_config    (int timer_id);
-void  set_gptimer_pulse_hi  (int timer_id);
-void  clear_gptimer_pulse_hi(int timer_id);
-void  enable_gptimers       (short mask);
-void  disable_gptimers      (short mask);
-short get_enabled_timers    (void);
-int   get_gptimer_status    (int octet);
-void  set_gptimer_status    (int octet, int value);
-
-#endif
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index a970781..14cb8d3 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -47,6 +47,8 @@
 
 extern unsigned long get_cclk(void);
 extern unsigned long get_sclk(void);
+extern unsigned long sclk_to_usecs(unsigned long sclk);
+extern unsigned long usecs_to_sclk(unsigned long usecs);
 
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 extern void dump_bfin_regs(struct pt_regs *fp, void *retaddr);
@@ -105,7 +107,7 @@ extern void led_disp_num(int);
 extern void led_toggle_num(int);
 extern void init_leds(void);
 
-extern char *bfin_board_name __attribute__ ((weak));
+extern const char bfin_board_name[];
 extern unsigned long wall_jiffies;
 extern unsigned long ipdt_table[];
 extern unsigned long dpdt_table[];
diff --git a/include/asm-blackfin/dma.h b/include/asm-blackfin/dma.h
index b42a531..b469505 100644
--- a/include/asm-blackfin/dma.h
+++ b/include/asm-blackfin/dma.h
@@ -109,9 +109,7 @@ struct dma_register {
 
 	unsigned long curr_desc_ptr;	/* DMA Current Descriptor Pointer
 					   register */
-	unsigned short curr_addr_ptr_lo;	/* DMA Current Address Pointer
-						   register */
-	unsigned short curr_addr_ptr_hi;	/* DMA Current Address Pointer
+	unsigned long curr_addr_ptr;	/* DMA Current Address Pointer
 						   register */
 	unsigned short irq_status;	/* DMA irq status register */
 	unsigned short dummy6;
@@ -166,6 +164,9 @@ void set_dma_curr_addr(unsigned int channel, unsigned long addr);
 unsigned short get_dma_curr_irqstat(unsigned int channel);
 unsigned short get_dma_curr_xcount(unsigned int channel);
 unsigned short get_dma_curr_ycount(unsigned int channel);
+unsigned long get_dma_next_desc_ptr(unsigned int channel);
+unsigned long get_dma_curr_desc_ptr(unsigned int channel);
+unsigned long get_dma_curr_addr(unsigned int channel);
 
 /* set large DMA mode descriptor */
 void set_dma_sg(unsigned int channel, struct dmasg *sg, int nr_sg);
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index dd203cd..33ce98e 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -29,6 +29,7 @@
 
 /*
 *  Number     BF537/6/4    BF561    BF533/2/1
+*             BF527/5/2
 *
 *  GPIO_0       PF0         PF0        PF0
 *  GPIO_1       PF1         PF1        PF1
@@ -164,7 +165,7 @@
 
 #endif
 
-#ifdef BF537_FAMILY
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
 #define MAX_BLACKFIN_GPIOS 48
 
 #define	GPIO_PF0	0
diff --git a/include/asm-blackfin/gptimers.h b/include/asm-blackfin/gptimers.h
new file mode 100644
index 0000000..c97ab03
--- /dev/null
+++ b/include/asm-blackfin/gptimers.h
@@ -0,0 +1,210 @@
+/*
+ * include/asm/bf5xx_timers.h
+ *
+ * This file contains the major Data structures and constants
+ * used for General Purpose Timer Implementation in BF5xx
+ *
+ * Copyright (C) 2005 John DeHority
+ * Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
+ *
+ */
+
+#ifndef _BLACKFIN_TIMERS_H_
+#define _BLACKFIN_TIMERS_H_
+
+#include <linux/types.h>
+#include <asm/blackfin.h>
+
+/*
+ * BF537/BF527: 8 timers:
+ */
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
+# define MAX_BLACKFIN_GPTIMERS 8
+# define TIMER0_GROUP_REG      TIMER_ENABLE
+#endif
+/*
+ * BF561: 12 timers:
+ */
+#if defined(CONFIG_BF561)
+# define MAX_BLACKFIN_GPTIMERS 12
+# define TIMER0_GROUP_REG      TMRS8_ENABLE
+# define TIMER8_GROUP_REG      TMRS4_ENABLE
+#endif
+/*
+ * All others: 3 timers:
+ */
+#if !defined(MAX_BLACKFIN_GPTIMERS)
+# define MAX_BLACKFIN_GPTIMERS 3
+# define TIMER0_GROUP_REG      TIMER_ENABLE
+#endif
+
+#define BLACKFIN_GPTIMER_IDMASK ((1UL << MAX_BLACKFIN_GPTIMERS) - 1)
+#define BFIN_TIMER_OCTET(x) ((x) >> 3)
+
+/* used in masks for timer_enable() and timer_disable() */
+#define TIMER0bit  0x0001  /*  0001b */
+#define TIMER1bit  0x0002  /*  0010b */
+#define TIMER2bit  0x0004  /*  0100b */
+
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+# define TIMER3bit  0x0008
+# define TIMER4bit  0x0010
+# define TIMER5bit  0x0020
+# define TIMER6bit  0x0040
+# define TIMER7bit  0x0080
+#endif
+
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+# define TIMER8bit  0x0100
+# define TIMER9bit  0x0200
+# define TIMER10bit 0x0400
+# define TIMER11bit 0x0800
+#endif
+
+#define TIMER0_id   0
+#define TIMER1_id   1
+#define TIMER2_id   2
+
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+# define TIMER3_id   3
+# define TIMER4_id   4
+# define TIMER5_id   5
+# define TIMER6_id   6
+# define TIMER7_id   7
+#endif
+
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+# define TIMER8_id   8
+# define TIMER9_id   9
+# define TIMER10_id 10
+# define TIMER11_id 11
+#endif
+
+/* associated timers for ppi framesync: */
+
+#if defined(CONFIG_BF561)
+# define FS0_1_TIMER_ID   TIMER8_id
+# define FS0_2_TIMER_ID   TIMER9_id
+# define FS1_1_TIMER_ID   TIMER10_id
+# define FS1_2_TIMER_ID   TIMER11_id
+# define FS0_1_TIMER_BIT  TIMER8bit
+# define FS0_2_TIMER_BIT  TIMER9bit
+# define FS1_1_TIMER_BIT  TIMER10bit
+# define FS1_2_TIMER_BIT  TIMER11bit
+# undef FS1_TIMER_ID
+# undef FS2_TIMER_ID
+# undef FS1_TIMER_BIT
+# undef FS2_TIMER_BIT
+#else
+# define FS1_TIMER_ID  TIMER0_id
+# define FS2_TIMER_ID  TIMER1_id
+# define FS1_TIMER_BIT TIMER0bit
+# define FS2_TIMER_BIT TIMER1bit
+#endif
+
+/*
+ * Timer Configuration Register Bits
+ */
+#define TIMER_ERR           0xC000
+#define TIMER_ERR_OVFL      0x4000
+#define TIMER_ERR_PROG_PER  0x8000
+#define TIMER_ERR_PROG_PW   0xC000
+#define TIMER_EMU_RUN       0x0200
+#define	TIMER_TOGGLE_HI     0x0100
+#define	TIMER_CLK_SEL       0x0080
+#define TIMER_OUT_DIS       0x0040
+#define TIMER_TIN_SEL       0x0020
+#define TIMER_IRQ_ENA       0x0010
+#define TIMER_PERIOD_CNT    0x0008
+#define TIMER_PULSE_HI      0x0004
+#define TIMER_MODE          0x0003
+#define TIMER_MODE_PWM      0x0001
+#define TIMER_MODE_WDTH     0x0002
+#define TIMER_MODE_EXT_CLK  0x0003
+
+/*
+ * Timer Status Register Bits
+ */
+#define TIMER_STATUS_TIMIL0 0x0001
+#define TIMER_STATUS_TIMIL1 0x0002
+#define TIMER_STATUS_TIMIL2 0x0004
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+# define TIMER_STATUS_TIMIL3 0x00000008
+# define TIMER_STATUS_TIMIL4 0x00010000
+# define TIMER_STATUS_TIMIL5 0x00020000
+# define TIMER_STATUS_TIMIL6 0x00040000
+# define TIMER_STATUS_TIMIL7 0x00080000
+# if (MAX_BLACKFIN_GPTIMERS > 8)
+#  define TIMER_STATUS_TIMIL8  0x0001
+#  define TIMER_STATUS_TIMIL9  0x0002
+#  define TIMER_STATUS_TIMIL10 0x0004
+#  define TIMER_STATUS_TIMIL11 0x0008
+# endif
+# define TIMER_STATUS_INTR   0x000F000F
+#else
+# define TIMER_STATUS_INTR   0x0007	/* any timer interrupt */
+#endif
+
+#define TIMER_STATUS_TOVF0  0x0010	/* timer 0 overflow error */
+#define TIMER_STATUS_TOVF1  0x0020
+#define TIMER_STATUS_TOVF2  0x0040
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+# define TIMER_STATUS_TOVF3  0x00000080
+# define TIMER_STATUS_TOVF4  0x00100000
+# define TIMER_STATUS_TOVF5  0x00200000
+# define TIMER_STATUS_TOVF6  0x00400000
+# define TIMER_STATUS_TOVF7  0x00800000
+# if (MAX_BLACKFIN_GPTIMERS > 8)
+#  define TIMER_STATUS_TOVF8   0x0010
+#  define TIMER_STATUS_TOVF9   0x0020
+#  define TIMER_STATUS_TOVF10  0x0040
+#  define TIMER_STATUS_TOVF11  0x0080
+# endif
+# define TIMER_STATUS_OFLOW  0x00F000F0
+#else
+# define TIMER_STATUS_OFLOW  0x0070	/* any timer overflow */
+#endif
+
+/*
+ * Timer Slave Enable Status : write 1 to clear
+ */
+#define TIMER_STATUS_TRUN0  0x1000
+#define TIMER_STATUS_TRUN1  0x2000
+#define TIMER_STATUS_TRUN2  0x4000
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+# define TIMER_STATUS_TRUN3  0x00008000
+# define TIMER_STATUS_TRUN4  0x10000000
+# define TIMER_STATUS_TRUN5  0x20000000
+# define TIMER_STATUS_TRUN6  0x40000000
+# define TIMER_STATUS_TRUN7  0x80000000
+# define TIMER_STATUS_TRUN   0xF000F000
+# if (MAX_BLACKFIN_GPTIMERS > 8)
+#  define TIMER_STATUS_TRUN8  0x1000
+#  define TIMER_STATUS_TRUN9  0x2000
+#  define TIMER_STATUS_TRUN10 0x4000
+#  define TIMER_STATUS_TRUN11 0x8000
+# endif
+#else
+# define TIMER_STATUS_TRUN   0x7000
+#endif
+
+/* The actual gptimer API */
+
+void     set_gptimer_pwidth    (int timer_id, uint32_t width);
+uint32_t get_gptimer_pwidth    (int timer_id);
+void     set_gptimer_period    (int timer_id, uint32_t period);
+uint32_t get_gptimer_period    (int timer_id);
+uint32_t get_gptimer_count     (int timer_id);
+uint16_t get_gptimer_intr      (int timer_id);
+void     clear_gptimer_intr    (int timer_id);
+void     set_gptimer_config    (int timer_id, uint16_t config);
+uint16_t get_gptimer_config    (int timer_id);
+void     set_gptimer_pulse_hi  (int timer_id);
+void     clear_gptimer_pulse_hi(int timer_id);
+void     enable_gptimers       (uint16_t mask);
+void     disable_gptimers      (uint16_t mask);
+uint16_t get_enabled_gptimers  (void);
+uint32_t get_gptimer_status    (int group);
+void     set_gptimer_status    (int group, uint32_t value);
+
+#endif
diff --git a/include/asm-blackfin/mach-bf527/anomaly.h b/include/asm-blackfin/mach-bf527/anomaly.h
index 991db98..a891204 100644
--- a/include/asm-blackfin/mach-bf527/anomaly.h
+++ b/include/asm-blackfin/mach-bf527/anomaly.h
@@ -38,4 +38,12 @@
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000323 (0)
+#define ANOMALY_05000244 (0)
+#define ANOMALY_05000198 (0)
+#define ANOMALY_05000125 (0)
+#define ANOMALY_05000158 (0)
+#define ANOMALY_05000273 (0)
+#define ANOMALY_05000263 (0)
+#define ANOMALY_05000311 (0)
+#define ANOMALY_05000230 (0)
 #endif
diff --git a/include/asm-blackfin/mach-bf527/bf527.h b/include/asm-blackfin/mach-bf527/bf527.h
new file mode 100644
index 0000000..056eb4b
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/bf527.h
@@ -0,0 +1,127 @@
+/*
+ * File:         include/asm-blackfin/mach-bf527/bf527.h
+ * Based on:	include/asm-blackfin/mach-bf537/bf537.h
+ * Author:	Michael Hennerich (michael.hennerich@analog.com)
+ *
+ * Created:
+ * Description:  SYSTEM MMR REGISTER AND MEMORY MAP FOR ADSP-BF527
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __MACH_BF527_H__
+#define __MACH_BF527_H__
+
+#define SUPPORTED_REVID 2
+
+#define OFFSET_(x) ((x) & 0x0000FFFF)
+
+/*some misc defines*/
+#define IMASK_IVG15		0x8000
+#define IMASK_IVG14		0x4000
+#define IMASK_IVG13		0x2000
+#define IMASK_IVG12		0x1000
+
+#define IMASK_IVG11		0x0800
+#define IMASK_IVG10		0x0400
+#define IMASK_IVG9		0x0200
+#define IMASK_IVG8		0x0100
+
+#define IMASK_IVG7		0x0080
+#define IMASK_IVGTMR	0x0040
+#define IMASK_IVGHW		0x0020
+
+/***************************/
+
+#define BFIN_DSUBBANKS	4
+#define BFIN_DWAYS		2
+#define BFIN_DLINES		64
+#define BFIN_ISUBBANKS	4
+#define BFIN_IWAYS		4
+#define BFIN_ILINES		32
+
+#define WAY0_L			0x1
+#define WAY1_L			0x2
+#define WAY01_L			0x3
+#define WAY2_L			0x4
+#define WAY02_L			0x5
+#define	WAY12_L			0x6
+#define	WAY012_L		0x7
+
+#define	WAY3_L			0x8
+#define	WAY03_L			0x9
+#define	WAY13_L			0xA
+#define	WAY013_L		0xB
+
+#define	WAY32_L			0xC
+#define	WAY320_L		0xD
+#define	WAY321_L		0xE
+#define	WAYALL_L		0xF
+
+#define DMC_ENABLE (2<<2)	/*yes, 2, not 1 */
+
+/********************************* EBIU Settings ************************************/
+#define AMBCTL0VAL	((CONFIG_BANK_1 << 16) | CONFIG_BANK_0)
+#define AMBCTL1VAL	((CONFIG_BANK_3 << 16) | CONFIG_BANK_2)
+
+#ifdef CONFIG_C_AMBEN_ALL
+#define V_AMBEN AMBEN_ALL
+#endif
+#ifdef CONFIG_C_AMBEN
+#define V_AMBEN 0x0
+#endif
+#ifdef CONFIG_C_AMBEN_B0
+#define V_AMBEN AMBEN_B0
+#endif
+#ifdef CONFIG_C_AMBEN_B0_B1
+#define V_AMBEN AMBEN_B0_B1
+#endif
+#ifdef CONFIG_C_AMBEN_B0_B1_B2
+#define V_AMBEN AMBEN_B0_B1_B2
+#endif
+#ifdef CONFIG_C_AMCKEN
+#define V_AMCKEN AMCKEN
+#else
+#define V_AMCKEN 0x0
+#endif
+#ifdef CONFIG_C_CDPRIO
+#define V_CDPRIO 0x100
+#else
+#define V_CDPRIO 0x0
+#endif
+
+#define AMGCTLVAL	(V_AMBEN | V_AMCKEN | V_CDPRIO)
+
+#ifdef CONFIG_BF527
+#define CPU "BF527"
+#endif
+#ifdef CONFIG_BF525
+#define CPU "BF525"
+#endif
+#ifdef CONFIG_BF522
+#define CPU "BF522"
+#endif
+#ifndef CPU
+#define	CPU "UNKNOWN"
+#define CPUID 0x0
+#endif
+
+#endif				/* __MACH_BF527_H__  */
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
new file mode 100644
index 0000000..0b867e6
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -0,0 +1,152 @@
+#include <linux/serial.h>
+#include <asm/dma.h>
+#include <asm/portmux.h>
+
+#define NR_PORTS		2
+
+#define OFFSET_THR              0x00	/* Transmit Holding register            */
+#define OFFSET_RBR              0x00	/* Receive Buffer register              */
+#define OFFSET_DLL              0x00	/* Divisor Latch (Low-Byte)             */
+#define OFFSET_IER              0x04	/* Interrupt Enable Register            */
+#define OFFSET_DLH              0x04	/* Divisor Latch (High-Byte)            */
+#define OFFSET_IIR              0x08	/* Interrupt Identification Register    */
+#define OFFSET_LCR              0x0C	/* Line Control Register                */
+#define OFFSET_MCR              0x10	/* Modem Control Register               */
+#define OFFSET_LSR              0x14	/* Line Status Register                 */
+#define OFFSET_MSR              0x18	/* Modem Status Register                */
+#define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
+#define OFFSET_GCTL             0x24	/* Global Control Register              */
+
+#define UART_GET_CHAR(uart)     bfin_read16(((uart)->port.membase + OFFSET_RBR))
+#define UART_GET_DLL(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLL))
+#define UART_GET_IER(uart)      bfin_read16(((uart)->port.membase + OFFSET_IER))
+#define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
+#define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
+#define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
+#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
+#define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
+
+#define UART_PUT_CHAR(uart, v)   bfin_write16(((uart)->port.membase + OFFSET_THR), v)
+#define UART_PUT_DLL(uart, v)    bfin_write16(((uart)->port.membase + OFFSET_DLL), v)
+#define UART_PUT_IER(uart, v)    bfin_write16(((uart)->port.membase + OFFSET_IER), v)
+#define UART_PUT_DLH(uart, v)    bfin_write16(((uart)->port.membase + OFFSET_DLH), v)
+#define UART_PUT_LCR(uart, v)    bfin_write16(((uart)->port.membase + OFFSET_LCR), v)
+#define UART_PUT_GCTL(uart, v)   bfin_write16(((uart)->port.membase + OFFSET_GCTL), v)
+
+#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
+# define CONFIG_SERIAL_BFIN_CTSRTS
+
+# ifndef CONFIG_UART0_CTS_PIN
+#  define CONFIG_UART0_CTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART0_RTS_PIN
+#  define CONFIG_UART0_RTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART1_CTS_PIN
+#  define CONFIG_UART1_CTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART1_RTS_PIN
+#  define CONFIG_UART1_RTS_PIN -1
+# endif
+#endif
+/*
+ * The pin configuration is different from schematic
+ */
+struct bfin_serial_port {
+	struct uart_port port;
+	unsigned int old_status;
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	int tx_done;
+	int tx_count;
+	struct circ_buf rx_dma_buf;
+	struct timer_list rx_dma_timer;
+	int rx_dma_nrows;
+	unsigned int tx_dma_channel;
+	unsigned int rx_dma_channel;
+	struct work_struct tx_dma_workqueue;
+#else
+	struct work_struct cts_workqueue;
+#endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	int cts_pin;
+	int rts_pin;
+#endif
+};
+
+struct bfin_serial_port bfin_serial_ports[NR_PORTS];
+struct bfin_serial_res {
+	unsigned long uart_base_addr;
+	int uart_irq;
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	unsigned int uart_tx_dma_channel;
+	unsigned int uart_rx_dma_channel;
+#endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	int uart_cts_pin;
+	int uart_rts_pin;
+#endif
+};
+
+struct bfin_serial_res bfin_serial_resource[] = {
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	{
+	 0xFFC00400,
+	 IRQ_UART0_RX,
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	 CH_UART0_TX,
+	 CH_UART0_RX,
+#endif
+#ifdef CONFIG_BFIN_UART0_CTSRTS
+	 CONFIG_UART0_CTS_PIN,
+	 CONFIG_UART0_RTS_PIN,
+#endif
+	 },
+#endif
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	{
+	 0xFFC02000,
+	 IRQ_UART1_RX,
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	 CH_UART1_TX,
+	 CH_UART1_RX,
+#endif
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	 CONFIG_UART1_CTS_PIN,
+	 CONFIG_UART1_RTS_PIN,
+#endif
+	 },
+#endif
+};
+
+int nr_ports = ARRAY_SIZE(bfin_serial_resource);
+
+#define DRIVER_NAME "bfin-uart"
+
+static void bfin_serial_hw_init(struct bfin_serial_port *uart)
+{
+
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0) {
+		gpio_request(uart->cts_pin, DRIVER_NAME);
+		gpio_direction_input(uart->cts_pin);
+	}
+
+	if (uart->rts_pin >= 0) {
+		gpio_request(uart->rts_pin, DRIVER_NAME);
+		gpio_direction_output(uart->rts_pin);
+	}
+#endif
+}
diff --git a/include/asm-blackfin/mach-bf527/blackfin.h b/include/asm-blackfin/mach-bf527/blackfin.h
new file mode 100644
index 0000000..1bd07e3
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/blackfin.h
@@ -0,0 +1,78 @@
+/*
+ * File:         include/asm-blackfin/mach-bf527/blackfin.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:
+ *
+ * Modified:
+ *
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _MACH_BLACKFIN_H_
+#define _MACH_BLACKFIN_H_
+
+#define BF527_FAMILY
+
+#include "bf527.h"
+#include "mem_map.h"
+#include "defBF522.h"
+#include "anomaly.h"
+
+#if defined(CONFIG_BF527)
+#include "defBF527.h"
+#endif
+
+#if defined(CONFIG_BF525)
+#include "defBF525.h"
+#endif
+
+#if !defined(__ASSEMBLY__)
+#include "cdefBF522.h"
+
+#if defined(CONFIG_BF527)
+#include "cdefBF527.h"
+#endif
+
+#if defined(CONFIG_BF525)
+#include "cdefBF525.h"
+#endif
+#endif
+
+/* UART_IIR Register */
+#define STATUS(x)	((x << 1) & 0x06)
+#define STATUS_P1	0x02
+#define STATUS_P0	0x01
+
+/* DPMC*/
+#define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
+#define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
+#define STOPCK_OFF STOPCK
+
+/* PLL_DIV Masks													*/
+#define CCLK_DIV1 CSEL_DIV1	/*          CCLK = VCO / 1                                  */
+#define CCLK_DIV2 CSEL_DIV2	/*          CCLK = VCO / 2                                  */
+#define CCLK_DIV4 CSEL_DIV4	/*          CCLK = VCO / 4                                  */
+#define CCLK_DIV8 CSEL_DIV8	/*          CCLK = VCO / 8                                  */
+
+#endif
diff --git a/include/asm-blackfin/mach-bf527/cdefBF52x_base.h b/include/asm-blackfin/mach-bf527/cdefBF52x_base.h
index 5f801a0..3f4de5d 100644
--- a/include/asm-blackfin/mach-bf527/cdefBF52x_base.h
+++ b/include/asm-blackfin/mach-bf527/cdefBF52x_base.h
@@ -45,8 +45,8 @@
 #define bfin_write_PLL_STAT(val)		bfin_write16(PLL_STAT, val)
 #define bfin_read_PLL_LOCKCNT()			bfin_read16(PLL_LOCKCNT)
 #define bfin_write_PLL_LOCKCNT(val)		bfin_write16(PLL_LOCKCNT, val)
-#define bfin_read_CHIPID()			bfin_read16(CHIPID)
-#define bfin_write_CHIPID(val)			bfin_write16(CHIPID, val)
+#define bfin_read_CHIPID()			bfin_read32(CHIPID)
+#define bfin_write_CHIPID(val)			bfin_write32(CHIPID, val)
 
 
 /* System Interrupt Controller (0xFFC00100 - 0xFFC001FF)							*/
@@ -59,9 +59,8 @@
 #define bfin_write_SIC_RVECT(val)		bfin_write32(SIC_RVECT, val)
 #define bfin_read_SIC_IMASK0()			bfin_read32(SIC_IMASK0)
 #define bfin_write_SIC_IMASK0(val)		bfin_write32(SIC_IMASK0, val)
-/* legacy register name (below) provided for backwards code compatibility */
-#define bfin_read_SIC_IMASK()			bfin_read32(SIC_IMASK)
-#define bfin_write_SIC_IMASK(val)		bfin_write32(SIC_IMASK, val)
+#define bfin_read_SIC_IMASK(x)			bfin_read32(SIC_IMASK0 + (x << 6))
+#define bfin_write_SIC_IMASK(x, val)		bfin_write32((SIC_IMASK0 + (x << 6)), val)
 
 #define bfin_read_SIC_IAR0()			bfin_read32(SIC_IAR0)
 #define bfin_write_SIC_IAR0(val)		bfin_write32(SIC_IAR0, val)
@@ -74,15 +73,13 @@
 
 #define bfin_read_SIC_ISR0()			bfin_read32(SIC_ISR0)
 #define bfin_write_SIC_ISR0(val)		bfin_write32(SIC_ISR0, val)
-/* legacy register name (below) provided for backwards code compatibility */
-#define bfin_read_SIC_ISR()			bfin_read32(SIC_ISR)
-#define bfin_write_SIC_ISR(val)			bfin_write32(SIC_ISR, val)
+#define bfin_read_SIC_ISR(x)			bfin_read32(SIC_ISR0 + (x << 6))
+#define bfin_write_SIC_ISR(x, val)		bfin_write32((SIC_ISR0 + (x << 6)), val)
 
 #define bfin_read_SIC_IWR0()			bfin_read32(SIC_IWR0)
 #define bfin_write_SIC_IWR0(val)		bfin_write32(SIC_IWR0, val)
-/* legacy register name (below) provided for backwards code compatibility */
-#define bfin_read_SIC_IWR()			bfin_read32(SIC_IWR)
-#define bfin_write_SIC_IWR(val)			bfin_write32(SIC_IWR, val)
+#define bfin_read_SIC_IWR(x)			bfin_read32(SIC_IWR0 + (x << 6))
+#define bfin_write_SIC_IWR(x, val)		bfin_write32((SIC_IWR0 + (x << 6)), val)
 
 /* SIC Additions to ADSP-BF52x (0xFFC0014C - 0xFFC00162) */
 
diff --git a/include/asm-blackfin/mach-bf527/defBF527.h b/include/asm-blackfin/mach-bf527/defBF527.h
index 2be3293..82134f5 100644
--- a/include/asm-blackfin/mach-bf527/defBF527.h
+++ b/include/asm-blackfin/mach-bf527/defBF527.h
@@ -32,12 +32,12 @@
 #define _DEF_BF527_H
 
 /* Include all Core registers and bit definitions */
-#include <def_LPBlackfin.h>
+#include <asm/mach-common/def_LPBlackfin.h>
 
 /* SYSTEM & MMR ADDRESS DEFINITIONS FOR ADSP-BF527 */
 
 /* Include defBF52x_base.h for the set of #defines that are common to all ADSP-BF52x processors */
-#include <defBF52x_base.h>
+#include "defBF52x_base.h"
 
 /* The following are the #defines needed by ADSP-BF527 that are not in the common header */
 /* 10/100 Ethernet Controller	(0xFFC03000 - 0xFFC031FF) */
diff --git a/include/asm-blackfin/mach-bf527/defBF52x_base.h b/include/asm-blackfin/mach-bf527/defBF52x_base.h
index b1ff67d..d6c24c5 100644
--- a/include/asm-blackfin/mach-bf527/defBF52x_base.h
+++ b/include/asm-blackfin/mach-bf527/defBF52x_base.h
@@ -52,13 +52,13 @@
 #define SYSCR				0xFFC00104	/* System Configuration Register			*/
 #define SIC_RVECT			0xFFC00108	/* Interrupt Reset Vector Address Register	*/
 
-#define SIC_IMASK			0xFFC0010C	/* Interrupt Mask Register					*/
+#define SIC_IMASK0			0xFFC0010C	/* Interrupt Mask Register					*/
 #define SIC_IAR0			0xFFC00110	/* Interrupt Assignment Register 0			*/
 #define SIC_IAR1			0xFFC00114	/* Interrupt Assignment Register 1			*/
 #define SIC_IAR2			0xFFC00118	/* Interrupt Assignment Register 2			*/
 #define SIC_IAR3			0xFFC0011C	/* Interrupt Assignment Register 3			*/
-#define SIC_ISR				0xFFC00120	/* Interrupt Status Register				*/
-#define SIC_IWR				0xFFC00124	/* Interrupt Wakeup Register				*/
+#define SIC_ISR0				0xFFC00120	/* Interrupt Status Register				*/
+#define SIC_IWR0				0xFFC00124	/* Interrupt Wakeup Register				*/
 
 /* SIC Additions to ADSP-BF52x (0xFFC0014C - 0xFFC00162) */
 #define SIC_IMASK1                      0xFFC0014C     /* Interrupt Mask register of SIC2 */
@@ -691,6 +691,8 @@
 
 /* *************  SYSTEM INTERRUPT CONTROLLER MASKS *************************************/
 /* Peripheral Masks For SIC_ISR, SIC_IWR, SIC_IMASK										*/
+
+#if 0
 #define IRQ_PLL_WAKEUP	0x00000001	/* PLL Wakeup Interrupt			 					*/
 
 #define IRQ_ERROR1      0x00000002  /* Error Interrupt (DMA, DMARx Block, DMARx Overflow) */
@@ -732,6 +734,7 @@
 #define IRQ_DMA15		0x40000000	/* DMA Channels 15 (MDMA0 Destination) TX Interrupt */
 #define IRQ_WDOG		0x80000000	/* Software Watchdog Timer Interrupt 				*/
 #define IRQ_PFB_PORTG	0x10000000	/* PF Port G (PF31:16) Interrupt B 					*/
+#endif
 
 /* SIC_IAR0 Macros															*/
 #define P0_IVG(x)		(((x)&0xF)-7)			/* Peripheral #0 assigned IVG #x 	*/
diff --git a/include/asm-blackfin/mach-bf527/dma.h b/include/asm-blackfin/mach-bf527/dma.h
new file mode 100644
index 0000000..a41627a
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/dma.h
@@ -0,0 +1,60 @@
+/*
+ * file:        include/asm-blackfin/mach-bf527/dma.h
+ * based on:	include/asm-blackfin/mach-bf537/dma.h
+ * author:	Michael Hennerich (michael.hennerich@analog.com)
+ *
+ * created:
+ * description:
+ *	system DMA map
+ * rev:
+ *
+ * modified:
+ *
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _MACH_DMA_H_
+#define _MACH_DMA_H_
+
+#define MAX_BLACKFIN_DMA_CHANNEL 16
+
+#define CH_PPI 			0	/* PPI receive/transmit or NFC */
+#define CH_NFC			0	/* PPI receive/transmit or NFC */
+#define CH_EMAC_RX 		1	/* Ethernet MAC receive or HOSTDP */
+#define CH_EMAC_HOSTDP 		1	/* Ethernet MAC receive or HOSTDP */
+#define CH_EMAC_TX 		2	/* Ethernet MAC transmit or NFC */
+#define CH_SPORT0_RX 		3	/* SPORT0 receive */
+#define CH_SPORT0_TX 		4	/* SPORT0 transmit */
+#define CH_SPORT1_RX 		5	/* SPORT1 receive */
+#define CH_SPORT1_TX 		6	/* SPORT1 transmit */
+#define CH_SPI 			7	/* SPI transmit/receive */
+#define CH_UART0_RX 		8	/* UART0 receive */
+#define CH_UART0_TX 		9	/* UART0 transmit */
+#define CH_UART1_RX 		10	/* UART1 receive */
+#define CH_UART1_TX 		11	/* UART1 transmit */
+
+#define CH_MEM_STREAM0_DEST	12	/* TX */
+#define CH_MEM_STREAM0_SRC  	13	/* RX */
+#define CH_MEM_STREAM1_DEST	14	/* TX */
+#define CH_MEM_STREAM1_SRC 	15	/* RX */
+
+extern int channel2irq(unsigned int channel);
+extern struct dma_register *base_addr[];
+
+#endif
diff --git a/include/asm-blackfin/mach-bf527/irq.h b/include/asm-blackfin/mach-bf527/irq.h
new file mode 100644
index 0000000..304f5bc
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/irq.h
@@ -0,0 +1,263 @@
+/*
+ * file:	include/asm-blackfin/mach-bf527/irq.h
+ * based on:	include/asm-blackfin/mach-bf537/irq.h
+ * author:	Michael Hennerich (michael.hennerich@analog.com)
+ *
+ * created:
+ * description:
+ *	system mmr register map
+ * rev:
+ *
+ * modified:
+ *
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _BF527_IRQ_H_
+#define _BF527_IRQ_H_
+
+/*
+ * Interrupt source definitions
+	Event Source    Core Event Name
+	Core        Emulation               **
+	Events         (highest priority)  EMU         0
+	Reset                   RST         1
+	NMI                     NMI         2
+	Exception               EVX         3
+	Reserved                --          4
+	Hardware Error          IVHW        5
+	Core Timer              IVTMR       6 *
+
+	.....
+
+	 Software Interrupt 1    IVG14       31
+	 Software Interrupt 2    --
+	 (lowest priority)  IVG15       32 *
+*/
+
+#define NR_PERI_INTS    (2 * 32)
+
+/* The ABSTRACT IRQ definitions */
+/** the first seven of the following are fixed, the rest you change if you need to **/
+#define IRQ_EMU			0	/* Emulation */
+#define IRQ_RST			1	/* reset */
+#define IRQ_NMI			2	/* Non Maskable */
+#define IRQ_EVX			3	/* Exception */
+#define IRQ_UNUSED		4	/* - unused interrupt */
+#define IRQ_HWERR		5	/* Hardware Error */
+#define IRQ_CORETMR		6	/* Core timer */
+
+#define BFIN_IRQ(x)		((x) + 7)
+
+#define IRQ_PLL_WAKEUP		BFIN_IRQ(0)	/* PLL Wakeup Interrupt */
+#define IRQ_DMA0_ERROR		BFIN_IRQ(1)	/* DMA Error 0 (generic) */
+#define IRQ_DMAR0_BLK		BFIN_IRQ(2)	/* DMAR0 Block Interrupt */
+#define IRQ_DMAR1_BLK		BFIN_IRQ(3)	/* DMAR1 Block Interrupt */
+#define IRQ_DMAR0_OVR		BFIN_IRQ(4)	/* DMAR0 Overflow Error */
+#define IRQ_DMAR1_OVR		BFIN_IRQ(5)	/* DMAR1 Overflow Error */
+#define IRQ_PPI_ERROR		BFIN_IRQ(6)	/* PPI Error */
+#define IRQ_MAC_ERROR		BFIN_IRQ(7)	/* MAC Status */
+#define IRQ_SPORT0_ERROR	BFIN_IRQ(8)	/* SPORT0 Status */
+#define IRQ_SPORT1_ERROR	BFIN_IRQ(9)	/* SPORT1 Status */
+#define IRQ_UART0_ERROR		BFIN_IRQ(12)	/* UART0 Status */
+#define IRQ_UART1_ERROR		BFIN_IRQ(13)	/* UART1 Status */
+#define IRQ_RTC			BFIN_IRQ(14)	/* RTC */
+#define IRQ_PPI      		BFIN_IRQ(15)	/* DMA Channel 0 (PPI/NAND) */
+#define IRQ_SPORT0_RX		BFIN_IRQ(16)	/* DMA 3 Channel (SPORT0 RX) */
+#define IRQ_SPORT0_TX		BFIN_IRQ(17)	/* DMA 4 Channel (SPORT0 TX) */
+#define IRQ_SPORT1_RX		BFIN_IRQ(18)	/* DMA 5 Channel (SPORT1 RX) */
+#define IRQ_SPORT1_TX		BFIN_IRQ(19)	/* DMA 6 Channel (SPORT1 TX) */
+#define IRQ_TWI      		BFIN_IRQ(20)	/* TWI */
+#define IRQ_SPI      		BFIN_IRQ(21)	/* DMA 7 Channel (SPI) */
+#define IRQ_UART0_RX 		BFIN_IRQ(22)	/* DMA8 Channel (UART0 RX) */
+#define IRQ_UART0_TX 		BFIN_IRQ(23)	/* DMA9 Channel (UART0 TX) */
+#define IRQ_UART1_RX 		BFIN_IRQ(24)	/* DMA10 Channel (UART1 RX) */
+#define IRQ_UART1_TX 		BFIN_IRQ(25)	/* DMA11 Channel (UART1 TX) */
+#define IRQ_OPTSEC   		BFIN_IRQ(26)	/* OTPSEC Interrupt */
+#define IRQ_CNT   		BFIN_IRQ(27)	/* GP Counter */
+#define IRQ_MAC_RX   		BFIN_IRQ(28)	/* DMA1 Channel (MAC RX/HDMA) */
+#define IRQ_PORTH_INTA   	BFIN_IRQ(29)	/* Port H Interrupt A */
+#define IRQ_MAC_TX		BFIN_IRQ(30)	/* DMA2 Channel (MAC TX/NAND) */
+#define IRQ_NFC			BFIN_IRQ(30)	/* DMA2 Channel (MAC TX/NAND) */
+#define IRQ_PORTH_INTB		BFIN_IRQ(31)	/* Port H Interrupt B */
+#define IRQ_TMR0		BFIN_IRQ(32)	/* Timer 0 */
+#define IRQ_TMR1		BFIN_IRQ(33)	/* Timer 1 */
+#define IRQ_TMR2		BFIN_IRQ(34)	/* Timer 2 */
+#define IRQ_TMR3		BFIN_IRQ(35)	/* Timer 3 */
+#define IRQ_TMR4		BFIN_IRQ(36)	/* Timer 4 */
+#define IRQ_TMR5		BFIN_IRQ(37)	/* Timer 5 */
+#define IRQ_TMR6		BFIN_IRQ(38)	/* Timer 6 */
+#define IRQ_TMR7		BFIN_IRQ(39)	/* Timer 7 */
+#define IRQ_PORTG_INTA		BFIN_IRQ(40)	/* Port G Interrupt A */
+#define IRQ_PORTG_INTB		BFIN_IRQ(41)	/* Port G Interrupt B */
+#define IRQ_MEM_DMA0		BFIN_IRQ(42)	/* MDMA Stream 0 */
+#define IRQ_MEM_DMA1		BFIN_IRQ(43)	/* MDMA Stream 1 */
+#define IRQ_WATCH		BFIN_IRQ(44)	/* Software Watchdog Timer */
+#define IRQ_PORTF_INTA		BFIN_IRQ(45)	/* Port F Interrupt A */
+#define IRQ_PORTF_INTB		BFIN_IRQ(46)	/* Port F Interrupt B */
+#define IRQ_SPI_ERROR		BFIN_IRQ(47)	/* SPI Status */
+#define IRQ_NFC_ERROR		BFIN_IRQ(48)	/* NAND Error */
+#define IRQ_HDMA_ERROR		BFIN_IRQ(49)	/* HDMA Error */
+#define IRQ_HDMA		BFIN_IRQ(50)	/* HDMA (TFI) */
+#define IRQ_USB_EINT		BFIN_IRQ(51)	/* USB_EINT Interrupt */
+#define IRQ_USB_INT0		BFIN_IRQ(52)	/* USB_INT0 Interrupt */
+#define IRQ_USB_INT1		BFIN_IRQ(53)	/* USB_INT1 Interrupt */
+#define IRQ_USB_INT2		BFIN_IRQ(54)	/* USB_INT2 Interrupt */
+#define IRQ_USB_DMA		BFIN_IRQ(55)	/* USB_DMAINT Interrupt */
+
+#define SYS_IRQS        	BFIN_IRQ(63)	/* 70 */
+
+#define IRQ_PF0         71
+#define IRQ_PF1         72
+#define IRQ_PF2         73
+#define IRQ_PF3         74
+#define IRQ_PF4         75
+#define IRQ_PF5         76
+#define IRQ_PF6         77
+#define IRQ_PF7         78
+#define IRQ_PF8         79
+#define IRQ_PF9         80
+#define IRQ_PF10        81
+#define IRQ_PF11        82
+#define IRQ_PF12        83
+#define IRQ_PF13        84
+#define IRQ_PF14        85
+#define IRQ_PF15        86
+
+#define IRQ_PG0         87
+#define IRQ_PG1         88
+#define IRQ_PG2         89
+#define IRQ_PG3         90
+#define IRQ_PG4         91
+#define IRQ_PG5         92
+#define IRQ_PG6         93
+#define IRQ_PG7         94
+#define IRQ_PG8         95
+#define IRQ_PG9         96
+#define IRQ_PG10        97
+#define IRQ_PG11        98
+#define IRQ_PG12        99
+#define IRQ_PG13        100
+#define IRQ_PG14        101
+#define IRQ_PG15        102
+
+#define IRQ_PH0         103
+#define IRQ_PH1         104
+#define IRQ_PH2         105
+#define IRQ_PH3         106
+#define IRQ_PH4         107
+#define IRQ_PH5         108
+#define IRQ_PH6         109
+#define IRQ_PH7         110
+#define IRQ_PH8         111
+#define IRQ_PH9         112
+#define IRQ_PH10        113
+#define IRQ_PH11        114
+#define IRQ_PH12        115
+#define IRQ_PH13        116
+#define IRQ_PH14        117
+#define IRQ_PH15        118
+
+#define GPIO_IRQ_BASE	IRQ_PF0
+
+#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
+#define NR_IRQS     (IRQ_PH15+1)
+#else
+#define NR_IRQS     (SYS_IRQS+1)
+#endif
+
+#define IVG7            7
+#define IVG8            8
+#define IVG9            9
+#define IVG10           10
+#define IVG11           11
+#define IVG12           12
+#define IVG13           13
+#define IVG14           14
+#define IVG15           15
+
+/* IAR0 BIT FIELDS */
+#define IRQ_PLL_WAKEUP_POS	0
+#define IRQ_DMA0_ERROR_POS	4
+#define IRQ_DMAR0_BLK_POS 	8
+#define IRQ_DMAR1_BLK_POS 	12
+#define IRQ_DMAR0_OVR_POS 	16
+#define IRQ_DMAR1_OVR_POS 	20
+#define IRQ_PPI_ERROR_POS 	24
+#define IRQ_MAC_ERROR_POS 	28
+
+/* IAR1 BIT FIELDS */
+#define IRQ_SPORT0_ERROR_POS	0
+#define IRQ_SPORT1_ERROR_POS	4
+#define IRQ_UART0_ERROR_POS 	16
+#define IRQ_UART1_ERROR_POS 	20
+#define IRQ_RTC_POS         	24
+#define IRQ_PPI_POS         	28
+
+/* IAR2 BIT FIELDS */
+#define IRQ_SPORT0_RX_POS	0
+#define IRQ_SPORT0_TX_POS	4
+#define IRQ_SPORT1_RX_POS	8
+#define IRQ_SPORT1_TX_POS	12
+#define IRQ_TWI_POS      	16
+#define IRQ_SPI_POS      	20
+#define IRQ_UART0_RX_POS 	24
+#define IRQ_UART0_TX_POS 	28
+
+/* IAR3 BIT FIELDS */
+#define IRQ_UART1_RX_POS  	0
+#define IRQ_UART1_TX_POS  	4
+#define IRQ_OPTSEC_POS    	8
+#define IRQ_CNT_POS       	12
+#define IRQ_MAC_RX_POS    	16
+#define IRQ_PORTH_INTA_POS	20
+#define IRQ_MAC_TX_POS    	24
+#define IRQ_PORTH_INTB_POS	28
+
+/* IAR4 BIT FIELDS */
+#define IRQ_TMR0_POS		0
+#define IRQ_TMR1_POS		4
+#define IRQ_TMR2_POS		8
+#define IRQ_TMR3_POS		12
+#define IRQ_TMR4_POS		16
+#define IRQ_TMR5_POS		20
+#define IRQ_TMR6_POS		24
+#define IRQ_TMR7_POS		28
+
+/* IAR5 BIT FIELDS */
+#define IRQ_PORTG_INTA_POS	0
+#define IRQ_PORTG_INTB_POS	4
+#define IRQ_MEM_DMA0_POS  	8
+#define IRQ_MEM_DMA1_POS  	12
+#define IRQ_WATCH_POS     	16
+#define IRQ_PORTF_INTA_POS	20
+#define IRQ_PORTF_INTB_POS	24
+#define IRQ_SPI_ERROR_POS 	28
+
+/* IAR6 BIT FIELDS */
+#define IRQ_NFC_ERROR_POS  	0
+#define IRQ_HDMA_ERROR_POS 	4
+#define IRQ_HDMA_POS       	8
+#define IRQ_USB_EINT_POS   	12
+#define IRQ_USB_INT0_POS   	16
+#define IRQ_USB_INT1_POS   	20
+#define IRQ_USB_INT2_POS   	24
+#define IRQ_USB_DMA_POS    	28
+
+#endif				/* _BF527_IRQ_H_ */
diff --git a/include/asm-blackfin/mach-bf527/mem_init.h b/include/asm-blackfin/mach-bf527/mem_init.h
new file mode 100644
index 0000000..008ca66
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/mem_init.h
@@ -0,0 +1,337 @@
+/*
+ * File:         include/asm-blackfin/mach-bf527/mem_init.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#if (CONFIG_MEM_MT48LC16M16A2TG_75 || CONFIG_MEM_MT48LC64M4A2FB_7E || CONFIG_MEM_MT48LC16M8A2TG_75 || CONFIG_MEM_GENERIC_BOARD || CONFIG_MEM_MT48LC32M8A2_75 || CONFIG_MEM_MT48LC32M16A2TG_75)
+#if (CONFIG_SCLK_HZ > 119402985)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_7
+#define SDRAM_tRAS_num  7
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 104477612) && (CONFIG_SCLK_HZ <= 119402985)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_6
+#define SDRAM_tRAS_num  6
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 89552239) && (CONFIG_SCLK_HZ <= 104477612)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_5
+#define SDRAM_tRAS_num  5
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 74626866) && (CONFIG_SCLK_HZ <= 89552239)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_4
+#define SDRAM_tRAS_num  4
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 66666667) && (CONFIG_SCLK_HZ <= 74626866)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_3
+#define SDRAM_tRAS_num  3
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 59701493) && (CONFIG_SCLK_HZ <= 66666667)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_4
+#define SDRAM_tRAS_num  3
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 44776119) && (CONFIG_SCLK_HZ <= 59701493)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_3
+#define SDRAM_tRAS_num  3
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 29850746) && (CONFIG_SCLK_HZ <= 44776119)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_2
+#define SDRAM_tRAS_num  2
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ <= 29850746)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_1
+#define SDRAM_tRAS_num  1
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#endif
+
+#if (CONFIG_MEM_MT48LC16M16A2TG_75)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_MT48LC16M8A2TG_75)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   4096	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_MT48LC32M8A2_75)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_MT48LC64M4A2FB_7E)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_GENERIC_BOARD)
+  /*SDRAM INFORMATION: Modify this for your board */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_MT48LC32M16A2TG_75)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_3
+#endif
+
+#if (CONFIG_MEM_SIZE == 128)
+#define SDRAM_SIZE      EBSZ_128
+#endif
+#if (CONFIG_MEM_SIZE == 64)
+#define SDRAM_SIZE      EBSZ_64
+#endif
+#if (CONFIG_MEM_SIZE == 32)
+#define SDRAM_SIZE      EBSZ_32
+#endif
+#if (CONFIG_MEM_SIZE == 16)
+#define SDRAM_SIZE      EBSZ_16
+#endif
+#if (CONFIG_MEM_ADD_WIDTH == 11)
+#define SDRAM_WIDTH     EBCAW_11
+#endif
+#if (CONFIG_MEM_ADD_WIDTH == 10)
+#define SDRAM_WIDTH     EBCAW_10
+#endif
+#if (CONFIG_MEM_ADD_WIDTH == 9)
+#define SDRAM_WIDTH     EBCAW_9
+#endif
+#if (CONFIG_MEM_ADD_WIDTH == 8)
+#define SDRAM_WIDTH     EBCAW_8
+#endif
+
+#define mem_SDBCTL      (SDRAM_WIDTH | SDRAM_SIZE | EBE)
+
+/* Equation from section 17 (p17-46) of BF533 HRM */
+#define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref) / SDRAM_NRA) - (SDRAM_tRAS_num + SDRAM_tRP_num)
+
+/* Enable SCLK Out */
+#define mem_SDGCTL        (SCTLE | SDRAM_CL | SDRAM_tRAS | SDRAM_tRP | SDRAM_tRCD | SDRAM_tWR | PSS)
+
+#if defined CONFIG_CLKIN_HALF
+#define CLKIN_HALF       1
+#else
+#define CLKIN_HALF       0
+#endif
+
+#if defined CONFIG_PLL_BYPASS
+#define PLL_BYPASS      1
+#else
+#define PLL_BYPASS       0
+#endif
+
+/***************************************Currently Not Being Used *********************************/
+#define flash_EBIU_AMBCTL_WAT  ((CONFIG_FLASH_SPEED_BWAT * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_RAT  ((CONFIG_FLASH_SPEED_BRAT * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_HT   ((CONFIG_FLASH_SPEED_BHT  * 4) / (4000000000 / CONFIG_SCLK_HZ))
+#define flash_EBIU_AMBCTL_ST   ((CONFIG_FLASH_SPEED_BST  * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_TT   ((CONFIG_FLASH_SPEED_BTT  * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+
+#if (flash_EBIU_AMBCTL_TT > 3)
+#define flash_EBIU_AMBCTL0_TT   B0TT_4
+#endif
+#if (flash_EBIU_AMBCTL_TT == 3)
+#define flash_EBIU_AMBCTL0_TT   B0TT_3
+#endif
+#if (flash_EBIU_AMBCTL_TT == 2)
+#define flash_EBIU_AMBCTL0_TT   B0TT_2
+#endif
+#if (flash_EBIU_AMBCTL_TT < 2)
+#define flash_EBIU_AMBCTL0_TT   B0TT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_ST > 3)
+#define flash_EBIU_AMBCTL0_ST   B0ST_4
+#endif
+#if (flash_EBIU_AMBCTL_ST == 3)
+#define flash_EBIU_AMBCTL0_ST   B0ST_3
+#endif
+#if (flash_EBIU_AMBCTL_ST == 2)
+#define flash_EBIU_AMBCTL0_ST   B0ST_2
+#endif
+#if (flash_EBIU_AMBCTL_ST < 2)
+#define flash_EBIU_AMBCTL0_ST   B0ST_1
+#endif
+
+#if (flash_EBIU_AMBCTL_HT > 2)
+#define flash_EBIU_AMBCTL0_HT   B0HT_3
+#endif
+#if (flash_EBIU_AMBCTL_HT == 2)
+#define flash_EBIU_AMBCTL0_HT   B0HT_2
+#endif
+#if (flash_EBIU_AMBCTL_HT == 1)
+#define flash_EBIU_AMBCTL0_HT   B0HT_1
+#endif
+#if (flash_EBIU_AMBCTL_HT == 0 && CONFIG_FLASH_SPEED_BHT == 0)
+#define flash_EBIU_AMBCTL0_HT   B0HT_0
+#endif
+#if (flash_EBIU_AMBCTL_HT == 0 && CONFIG_FLASH_SPEED_BHT != 0)
+#define flash_EBIU_AMBCTL0_HT   B0HT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_WAT > 14)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_15
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 14)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_14
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 13)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_13
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 12)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_12
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 11)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_11
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 10)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_10
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 9)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_9
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 8)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_8
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 7)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_7
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 6)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_6
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 5)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_5
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 4)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_4
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 3)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_3
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 2)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_2
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 1)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_RAT > 14)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_15
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 14)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_14
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 13)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_13
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 12)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_12
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 11)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_11
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 10)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_10
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 9)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_9
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 8)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_8
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 7)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_7
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 6)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_6
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 5)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_5
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 4)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_4
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 3)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_3
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 2)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_2
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 1)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_1
+#endif
+
+#define flash_EBIU_AMBCTL0  \
+	(flash_EBIU_AMBCTL0_WAT | flash_EBIU_AMBCTL0_RAT | flash_EBIU_AMBCTL0_HT | \
+	 flash_EBIU_AMBCTL0_ST | flash_EBIU_AMBCTL0_TT | CONFIG_FLASH_SPEED_RDYEN)
diff --git a/include/asm-blackfin/mach-bf527/mem_map.h b/include/asm-blackfin/mach-bf527/mem_map.h
new file mode 100644
index 0000000..c5aa201
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/mem_map.h
@@ -0,0 +1,98 @@
+/*
+ * file:         include/asm-blackfin/mach-bf527/mem_map.h
+ * based on:	include/asm-blackfin/mach-bf537/mem_map.h
+ * author:	Michael Hennerich (michael.hennerich@analog.com)
+ *
+ * created:
+ * description:
+ *	Memory MAP Common header file for blackfin BF527/5/2 of processors.
+ * rev:
+ *
+ * modified:
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _MEM_MAP_527_H_
+#define _MEM_MAP_527_H_
+
+#define COREMMR_BASE           0xFFE00000	/* Core MMRs */
+#define SYSMMR_BASE            0xFFC00000	/* System MMRs */
+
+/* Async Memory Banks */
+#define ASYNC_BANK3_BASE	0x20300000	/* Async Bank 3 */
+#define ASYNC_BANK3_SIZE	0x00100000	/* 1M */
+#define ASYNC_BANK2_BASE	0x20200000	/* Async Bank 2 */
+#define ASYNC_BANK2_SIZE	0x00100000	/* 1M */
+#define ASYNC_BANK1_BASE	0x20100000	/* Async Bank 1 */
+#define ASYNC_BANK1_SIZE	0x00100000	/* 1M */
+#define ASYNC_BANK0_BASE	0x20000000	/* Async Bank 0 */
+#define ASYNC_BANK0_SIZE	0x00100000	/* 1M */
+
+/* Boot ROM Memory */
+
+#define BOOT_ROM_START		0xEF000000
+
+/* Level 1 Memory */
+
+/* Memory Map for ADSP-BF527 ADSP-BF525 ADSP-BF522 processors */
+
+#ifdef CONFIG_BFIN_ICACHE
+#define BFIN_ICACHESIZE	(16*1024)
+#else
+#define BFIN_ICACHESIZE	(0*1024)
+#endif
+
+#define L1_CODE_START       0xFFA00000
+#define L1_DATA_A_START     0xFF800000
+#define L1_DATA_B_START     0xFF900000
+
+#define L1_CODE_LENGTH      0xC000
+
+#ifdef CONFIG_BFIN_DCACHE
+
+#ifdef CONFIG_BFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BFIN_DCACHESIZE	(16*1024)
+#define BFIN_DSUPBANKS	1
+#else
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BFIN_DCACHESIZE	(32*1024)
+#define BFIN_DSUPBANKS	2
+#endif
+
+#else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
+#define L1_DATA_B_LENGTH      0x8000
+#define BFIN_DCACHESIZE	(0*1024)
+#define BFIN_DSUPBANKS	0
+#endif				/*CONFIG_BFIN_DCACHE */
+
+/* Scratch Pad Memory */
+
+#if defined(CONFIG_BF527) || defined(CONFIG_BF536) || defined(CONFIG_BF534)
+#define L1_SCRATCH_START	0xFFB00000
+#define L1_SCRATCH_LENGTH	0x1000
+#endif
+
+#endif				/* _MEM_MAP_527_H_ */
diff --git a/include/asm-blackfin/mach-bf527/portmux.h b/include/asm-blackfin/mach-bf527/portmux.h
new file mode 100644
index 0000000..dcf001a
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/portmux.h
@@ -0,0 +1,205 @@
+#ifndef _MACH_PORTMUX_H_
+#define _MACH_PORTMUX_H_
+
+#define P_PPI0_D0	(P_DEFINED | P_IDENT(GPIO_PF0) | P_FUNCT(0))
+#define P_PPI0_D1	(P_DEFINED | P_IDENT(GPIO_PF1) | P_FUNCT(0))
+#define P_PPI0_D2	(P_DEFINED | P_IDENT(GPIO_PF2) | P_FUNCT(0))
+#define P_PPI0_D3	(P_DEFINED | P_IDENT(GPIO_PF3) | P_FUNCT(0))
+#define P_PPI0_D4	(P_DEFINED | P_IDENT(GPIO_PF4) | P_FUNCT(0))
+#define P_PPI0_D5	(P_DEFINED | P_IDENT(GPIO_PF5) | P_FUNCT(0))
+#define P_PPI0_D6	(P_DEFINED | P_IDENT(GPIO_PF6) | P_FUNCT(0))
+#define P_PPI0_D7	(P_DEFINED | P_IDENT(GPIO_PF7) | P_FUNCT(0))
+#define P_PPI0_D8	(P_DEFINED | P_IDENT(GPIO_PF8) | P_FUNCT(0))
+#define P_PPI0_D9	(P_DEFINED | P_IDENT(GPIO_PF9) | P_FUNCT(0))
+#define P_PPI0_D10	(P_DEFINED | P_IDENT(GPIO_PF10) | P_FUNCT(0))
+#define P_PPI0_D11	(P_DEFINED | P_IDENT(GPIO_PF11) | P_FUNCT(0))
+#define P_PPI0_D12	(P_DEFINED | P_IDENT(GPIO_PF12) | P_FUNCT(0))
+#define P_PPI0_D13	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(0))
+#define P_PPI0_D14	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(0))
+#define P_PPI0_D15	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(0))
+
+#if defined(CONFIG_BF527_SPORT0_PORTF)
+#define P_SPORT0_DRPRI	(P_DEFINED | P_IDENT(GPIO_PF0) | P_FUNCT(1))
+#define P_SPORT0_RFS	(P_DEFINED | P_IDENT(GPIO_PF1) | P_FUNCT(1))
+#define P_SPORT0_RSCLK	(P_DEFINED | P_IDENT(GPIO_PF2) | P_FUNCT(1))
+#define P_SPORT0_DTPRI	(P_DEFINED | P_IDENT(GPIO_PF3) | P_FUNCT(1))
+#define P_SPORT0_TFS	(P_DEFINED | P_IDENT(GPIO_PF4) | P_FUNCT(1))
+#define P_SPORT0_TSCLK	(P_DEFINED | P_IDENT(GPIO_PF5) | P_FUNCT(1))
+#define P_SPORT0_DTSEC	(P_DEFINED | P_IDENT(GPIO_PF6) | P_FUNCT(1))
+#define P_SPORT0_DRSEC	(P_DEFINED | P_IDENT(GPIO_PF7) | P_FUNCT(1))
+#elif defined(CONFIG_BF527_SPORT0_PORTG)
+#define P_SPORT0_DTPRI	(P_DEFINED | P_IDENT(GPIO_PG6) | P_FUNCT(0))
+#define P_SPORT0_DRSEC	(P_DEFINED | P_IDENT(GPIO_PG3) | P_FUNCT(1))
+#define P_SPORT0_DTSEC	(P_DEFINED | P_IDENT(GPIO_PG4) | P_FUNCT(1))
+#define P_SPORT0_DRPRI	(P_DEFINED | P_IDENT(GPIO_PG7) | P_FUNCT(1))
+#define P_SPORT0_RFS	(P_DEFINED | P_IDENT(GPIO_PG8) | P_FUNCT(1))
+#define P_SPORT0_RSCLK	(P_DEFINED | P_IDENT(GPIO_PG9) | P_FUNCT(1))
+#if defined(CONFIG_BF527_SPORT0_TSCLK_PG10)
+#define P_SPORT0_TSCLK	(P_DEFINED | P_IDENT(GPIO_PG10) | P_FUNCT(1))
+#elif defined(CONFIG_BF527_SPORT0_TSCLK_PG14)
+#define P_SPORT0_TSCLK	(P_DEFINED | P_IDENT(GPIO_PG14) | P_FUNCT(0))
+#endif
+#define P_SPORT0_TFS	(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(0))
+#endif
+
+#define P_SPORT1_DRPRI	(P_DEFINED | P_IDENT(GPIO_PF8) | P_FUNCT(1))
+#define P_SPORT1_RSCLK	(P_DEFINED | P_IDENT(GPIO_PF9) | P_FUNCT(1))
+#define P_SPORT1_RFS	(P_DEFINED | P_IDENT(GPIO_PF10) | P_FUNCT(1))
+#define P_SPORT1_TFS	(P_DEFINED | P_IDENT(GPIO_PF11) | P_FUNCT(1))
+#define P_SPORT1_DTPRI	(P_DEFINED | P_IDENT(GPIO_PF12) | P_FUNCT(1))
+#define P_SPORT1_TSCLK	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(1))
+#define P_SPORT1_DTSEC	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(1))
+#define P_SPORT1_DRSEC	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(1))
+
+#define P_SPI0_SSEL6	(P_DEFINED | P_IDENT(GPIO_PF9) | P_FUNCT(2))
+#define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(GPIO_PF10) | P_FUNCT(2))
+
+#define P_SPI0_SSEL2	(P_DEFINED | P_IDENT(GPIO_PF12) | P_FUNCT(2))
+#define P_SPI0_SSEL3	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(2))
+
+#if defined(CONFIG_BF527_UART1_PORTF)
+#define P_UART1_TX	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(2))
+#define P_UART1_RX	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(2))
+#elif defined(CONFIG_BF527_UART1_PORTG)
+#define P_UART1_TX	(P_DEFINED | P_IDENT(GPIO_PG12) | P_FUNCT(1))
+#define P_UART1_RX	(P_DEFINED | P_IDENT(GPIO_PG13) | P_FUNCT(1))
+#endif
+
+#define P_HWAIT		(P_DONTCARE)
+
+#define P_SPI0_SS	(P_DEFINED | P_IDENT(GPIO_PG1) | P_FUNCT(0))
+#define P_SPI0_SSEL1	(P_DEFINED | P_IDENT(GPIO_PG1) | P_FUNCT(2))
+#define P_SPI0_SCK	(P_DEFINED | P_IDENT(GPIO_PG2) | P_FUNCT(2))
+#define P_SPI0_MISO	(P_DEFINED | P_IDENT(GPIO_PG3) | P_FUNCT(2))
+#define P_SPI0_MOSI	(P_DEFINED | P_IDENT(GPIO_PG4) | P_FUNCT(2))
+#define P_TMR1		(P_DEFINED | P_IDENT(GPIO_PG5) | P_FUNCT(0))
+#define P_PPI0_FS2	(P_DEFINED | P_IDENT(GPIO_PG5) | P_FUNCT(0))
+#define P_TMR3		(P_DEFINED | P_IDENT(GPIO_PG7) | P_FUNCT(0))
+#define P_TMR4		(P_DEFINED | P_IDENT(GPIO_PG8) | P_FUNCT(0))
+#define P_TMR5		(P_DEFINED | P_IDENT(GPIO_PG9) | P_FUNCT(0))
+#define P_TMR6		(P_DEFINED | P_IDENT(GPIO_PG10) | P_FUNCT(0))
+/* #define P_TMR7		(P_DEFINED | P_IDENT(GPIO_PG11) | P_FUNCT(0)) */
+#define P_DMAR1		(P_DEFINED | P_IDENT(GPIO_PG12) | P_FUNCT(0))
+#define P_DMAR0		(P_DEFINED | P_IDENT(GPIO_PG13) | P_FUNCT(0))
+#define P_TMR2		(P_DEFINED | P_IDENT(GPIO_PG6) | P_FUNCT(1))
+#define P_TMR7		(P_DEFINED | P_IDENT(GPIO_PG11) | P_FUNCT(1))
+#define P_MDC		(P_DEFINED | P_IDENT(GPIO_PG14) | P_FUNCT(1))
+#define P_RMII0_MDINT	(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(1))
+#define P_MII0_PHYINT	(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(1))
+
+#define P_PPI0_FS3	(P_DEFINED | P_IDENT(GPIO_PG6) | P_FUNCT(2))
+#define P_UART0_TX	(P_DEFINED | P_IDENT(GPIO_PG7) | P_FUNCT(2))
+#define P_UART0_RX	(P_DEFINED | P_IDENT(GPIO_PG8) | P_FUNCT(2))
+
+#define P_HOST_WR	(P_DEFINED | P_IDENT(GPIO_PG11) | P_FUNCT(2))
+#define P_HOST_ACK	(P_DEFINED | P_IDENT(GPIO_PG12) | P_FUNCT(2))
+#define P_HOST_ADDR	(P_DEFINED | P_IDENT(GPIO_PG13) | P_FUNCT(2))
+#define P_HOST_RD	(P_DEFINED | P_IDENT(GPIO_PG14) | P_FUNCT(2))
+#define P_HOST_CE	(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(2))
+
+#if defined(CONFIG_BF527_NAND_D_PORTF)
+#define P_NAND_D0	(P_DEFINED | P_IDENT(GPIO_PF0) | P_FUNCT(2))
+#define P_NAND_D1	(P_DEFINED | P_IDENT(GPIO_PF1) | P_FUNCT(2))
+#define P_NAND_D2	(P_DEFINED | P_IDENT(GPIO_PF2) | P_FUNCT(2))
+#define P_NAND_D3	(P_DEFINED | P_IDENT(GPIO_PF3) | P_FUNCT(2))
+#define P_NAND_D4	(P_DEFINED | P_IDENT(GPIO_PF4) | P_FUNCT(2))
+#define P_NAND_D5	(P_DEFINED | P_IDENT(GPIO_PF5) | P_FUNCT(2))
+#define P_NAND_D6	(P_DEFINED | P_IDENT(GPIO_PF6) | P_FUNCT(2))
+#define P_NAND_D7	(P_DEFINED | P_IDENT(GPIO_PF7) | P_FUNCT(2))
+#elif defined(CONFIG_BF527_NAND_D_PORTH)
+#define P_NAND_D0	(P_DEFINED | P_IDENT(GPIO_PH0) | P_FUNCT(0))
+#define P_NAND_D1	(P_DEFINED | P_IDENT(GPIO_PH1) | P_FUNCT(0))
+#define P_NAND_D2	(P_DEFINED | P_IDENT(GPIO_PH2) | P_FUNCT(0))
+#define P_NAND_D3	(P_DEFINED | P_IDENT(GPIO_PH3) | P_FUNCT(0))
+#define P_NAND_D4	(P_DEFINED | P_IDENT(GPIO_PH4) | P_FUNCT(0))
+#define P_NAND_D5	(P_DEFINED | P_IDENT(GPIO_PH5) | P_FUNCT(0))
+#define P_NAND_D6	(P_DEFINED | P_IDENT(GPIO_PH6) | P_FUNCT(0))
+#define P_NAND_D7	(P_DEFINED | P_IDENT(GPIO_PH7) | P_FUNCT(0))
+#endif
+
+#define P_SPI0_SSEL4	(P_DEFINED | P_IDENT(GPIO_PH8) | P_FUNCT(0))
+#define P_SPI0_SSEL5	(P_DEFINED | P_IDENT(GPIO_PH9) | P_FUNCT(0))
+#define P_NAND_CE	(P_DEFINED | P_IDENT(GPIO_PH10) | P_FUNCT(0))
+#define P_NAND_WE	(P_DEFINED | P_IDENT(GPIO_PH11) | P_FUNCT(0))
+#define P_NAND_RE	(P_DEFINED | P_IDENT(GPIO_PH12) | P_FUNCT(0))
+#define P_NAND_RB	(P_DEFINED | P_IDENT(GPIO_PH13) | P_FUNCT(0))
+#define P_NAND_CLE	(P_DEFINED | P_IDENT(GPIO_PH14) | P_FUNCT(0))
+#define P_NAND_ALE	(P_DEFINED | P_IDENT(GPIO_PH15) | P_FUNCT(0))
+
+#define P_HOST_D0	(P_DEFINED | P_IDENT(GPIO_PH0) | P_FUNCT(2))
+#define P_HOST_D1	(P_DEFINED | P_IDENT(GPIO_PH1) | P_FUNCT(2))
+#define P_HOST_D2	(P_DEFINED | P_IDENT(GPIO_PH2) | P_FUNCT(2))
+#define P_HOST_D3	(P_DEFINED | P_IDENT(GPIO_PH3) | P_FUNCT(2))
+#define P_HOST_D4	(P_DEFINED | P_IDENT(GPIO_PH4) | P_FUNCT(2))
+#define P_HOST_D5	(P_DEFINED | P_IDENT(GPIO_PH5) | P_FUNCT(2))
+#define P_HOST_D6	(P_DEFINED | P_IDENT(GPIO_PH6) | P_FUNCT(2))
+#define P_HOST_D7	(P_DEFINED | P_IDENT(GPIO_PH7) | P_FUNCT(2))
+#define P_HOST_D8	(P_DEFINED | P_IDENT(GPIO_PH8) | P_FUNCT(2))
+#define P_HOST_D9	(P_DEFINED | P_IDENT(GPIO_PH9) | P_FUNCT(2))
+#define P_HOST_D10	(P_DEFINED | P_IDENT(GPIO_PH10) | P_FUNCT(2))
+#define P_HOST_D11	(P_DEFINED | P_IDENT(GPIO_PH11) | P_FUNCT(2))
+#define P_HOST_D12	(P_DEFINED | P_IDENT(GPIO_PH12) | P_FUNCT(2))
+#define P_HOST_D13	(P_DEFINED | P_IDENT(GPIO_PH13) | P_FUNCT(2))
+#define P_HOST_D14	(P_DEFINED | P_IDENT(GPIO_PH14) | P_FUNCT(2))
+#define P_HOST_D15	(P_DEFINED | P_IDENT(GPIO_PH15) | P_FUNCT(2))
+
+#define P_MII0_ETxD0	(P_DEFINED | P_IDENT(GPIO_PH5) | P_FUNCT(1))
+#define P_MII0_ETxD1	(P_DEFINED | P_IDENT(GPIO_PH7) | P_FUNCT(1))
+#define P_MII0_ETxD2	(P_DEFINED | P_IDENT(GPIO_PH9) | P_FUNCT(1))
+#define P_MII0_ETxD3	(P_DEFINED | P_IDENT(GPIO_PH11) | P_FUNCT(1))
+#define P_MII0_ETxEN	(P_DEFINED | P_IDENT(GPIO_PH3) | P_FUNCT(1))
+#define P_MII0_TxCLK	(P_DEFINED | P_IDENT(GPIO_PH4) | P_FUNCT(1))
+#define P_MII0_COL	(P_DEFINED | P_IDENT(GPIO_PH15) | P_FUNCT(1))
+#define P_MII0_ERxD0	(P_DEFINED | P_IDENT(GPIO_PH6) | P_FUNCT(1))
+#define P_MII0_ERxD1	(P_DEFINED | P_IDENT(GPIO_PH8) | P_FUNCT(1))
+#define P_MII0_ERxD2	(P_DEFINED | P_IDENT(GPIO_PH10) | P_FUNCT(1))
+#define P_MII0_ERxD3	(P_DEFINED | P_IDENT(GPIO_PH12) | P_FUNCT(1))
+#define P_MII0_ERxDV	(P_DEFINED | P_IDENT(GPIO_PH14) | P_FUNCT(1))
+#define P_MII0_ERxCLK	(P_DEFINED | P_IDENT(GPIO_PH13) | P_FUNCT(1))
+#define P_MII0_ERxER	(P_DEFINED | P_IDENT(GPIO_PH1) | P_FUNCT(1))
+#define P_MII0_CRS	(P_DEFINED | P_IDENT(GPIO_PH0) | P_FUNCT(1))
+#define P_RMII0_REF_CLK	(P_DEFINED | P_IDENT(GPIO_PH4) | P_FUNCT(1))
+#define P_RMII0_CRS_DV	(P_DEFINED | P_IDENT(GPIO_PH0) | P_FUNCT(1))
+#define P_MDIO		(P_DEFINED | P_IDENT(GPIO_PH2) | P_FUNCT(1))
+
+#define P_TWI0_SCL	(P_DONTCARE)
+#define P_TWI0_SDA	(P_DONTCARE)
+#define P_PPI0_FS1	(P_DONTCARE)
+#define P_TMR0		(P_DONTCARE)
+#define P_TMRCLK	(P_DONTCARE)
+#define P_PPI0_CLK	(P_DONTCARE)
+
+#define P_MII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxD2, \
+	P_MII0_ETxD3, \
+	P_MII0_ETxEN, \
+	P_MII0_TxCLK, \
+	P_MII0_PHYINT, \
+	P_MII0_COL, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxD2, \
+	P_MII0_ERxD3, \
+	P_MII0_ERxDV, \
+	P_MII0_ERxCLK, \
+	P_MII0_ERxER, \
+	P_MII0_CRS, \
+	P_MDC, \
+	P_MDIO, 0}
+
+#define P_RMII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxEN, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxER, \
+	P_RMII0_REF_CLK, \
+	P_RMII0_MDINT, \
+	P_RMII0_CRS_DV, \
+	P_MDC, \
+	P_MDIO, 0}
+
+#endif				/* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-bf548/defBF549.h b/include/asm-blackfin/mach-bf548/defBF549.h
index 50b3fe5..4e46d65 100644
--- a/include/asm-blackfin/mach-bf548/defBF549.h
+++ b/include/asm-blackfin/mach-bf548/defBF549.h
@@ -1178,7 +1178,7 @@
 
 /* Bit masks for HOST_STATUS */
 
-#define                     READY  0x1        /* DMA Ready */
+#define                 DMA_READY  0x1        /* DMA Ready */
 #define                  FIFOFULL  0x2        /* FIFO Full */
 #define                 FIFOEMPTY  0x4        /* FIFO Empty */
 #define              DMA_COMPLETE  0x8        /* DMA Complete */
diff --git a/include/asm-blackfin/mach-bf548/defBF54x_base.h b/include/asm-blackfin/mach-bf548/defBF54x_base.h
index e2632db..1d365c8 100644
--- a/include/asm-blackfin/mach-bf548/defBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/defBF54x_base.h
@@ -47,6 +47,10 @@
 /* Debug/MP/Emulation Registers (0xFFC00014 - 0xFFC00014) */
 
 #define                           CHIPID  0xffc00014
+/* CHIPID Masks */
+#define                   CHIPID_VERSION  0xF0000000
+#define                    CHIPID_FAMILY  0x0FFFF000
+#define               CHIPID_MANUFACTURE  0x00000FFE
 
 /* System Reset and Interrupt Controller (0xFFC00100 - 0xFFC00104) */
 
@@ -3299,7 +3303,7 @@
 
 #define                       MFD  0xf000     /* Multi channel Frame Delay */
 #define                      FSDR  0x80       /* Frame Sync to Data Relationship */
-#define                     MCMEM  0x10       /* Multi channel Frame Mode Enable */
+#define                  MCMEN  0x10       /* Multi channel Frame Mode Enable */
 #define                   MCDRXPE  0x8        /* Multi channel DMA Receive Packing */
 #define                   MCDTXPE  0x4        /* Multi channel DMA Transmit Packing */
 #define                     MCCRM  0x3        /* 2X Clock Recovery Mode */
diff --git a/include/asm-blackfin/mach-bf548/dma.h b/include/asm-blackfin/mach-bf548/dma.h
index 14cb10c..4d97d3a 100644
--- a/include/asm-blackfin/mach-bf548/dma.h
+++ b/include/asm-blackfin/mach-bf548/dma.h
@@ -70,5 +70,5 @@
 #define MAX_BLACKFIN_DMA_CHANNEL 32
 
 extern int channel2irq(unsigned int channel);
-extern struct dma_register *base_addr[];
+extern struct dma_register *base_addr[MAX_BLACKFIN_DMA_CHANNEL];
 #endif
