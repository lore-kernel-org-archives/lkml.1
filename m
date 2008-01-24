Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbYAZQLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbYAZQLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbYAZP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:58:12 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755518AbYAZP6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:58:09 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org
Subject: [PATCH 01/52] [microblaze] Kconfig patches
Date: Thu, 24 Jan 2008 16:05:18 +0100
Message-Id: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig                       |  160 +++++++++++++++++++++++++
 arch/microblaze/Kconfig.debug                 |   22 ++++
 arch/microblaze/platform/Kconfig.platform     |   46 +++++++
 arch/microblaze/platform/generic/Kconfig.auto |   45 +++++++
 4 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/Kconfig
 create mode 100644 arch/microblaze/Kconfig.debug
 create mode 100644 arch/microblaze/platform/Kconfig.platform
 create mode 100644 arch/microblaze/platform/generic/Kconfig.auto

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
new file mode 100644
index 0000000..6dbc069
--- /dev/null
+++ b/arch/microblaze/Kconfig
@@ -0,0 +1,160 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/config-language.txt.
+
+mainmenu "Linux/Microblaze Kernel Configuration"
+
+config MICROBLAZE
+	bool
+	default y
+
+config MMU
+	bool
+	default n
+
+config SWAP
+	bool
+	default n
+
+config RWSEM_GENERIC_SPINLOCK
+	bool
+	default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
+config GENERIC_FIND_NEXT_BIT
+	bool
+	default y
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+config GENERIC_CALIBRATE_DELAY
+	bool
+	default y
+
+config PCI
+	bool
+	default n
+
+config UID16
+	bool
+	default y
+
+config DEFCONFIG_LIST
+	string
+	default "arch/$ARCH/defconfig"
+
+source "init/Kconfig"
+
+source "arch/microblaze/platform/Kconfig.platform"
+
+menu "Processor type and features"
+config PREEMPT
+	bool "Preemptible Kernel"
+	help
+	  This option reduces the latency of the kernel when reacting to
+	  real-time or interactive events by allowing a low priority process to
+	  be preempted even if it is in kernel mode executing a system call.
+	  This allows applications to run more reliably even when the system is
+	  under load.
+
+	  Say Y here if you are building a kernel for a desktop, embedded
+	  or real-time system.  Say N if you are unsure.
+
+config PREEMPT_TIMES
+	bool "Collect preemption latency times"
+	depends on PREEMPT
+	help
+	  Allow collection for preemption latency times.
+
+config XILINX_UNCACHED_SHADOW
+    bool "Are you using uncached shadow for RAM ?"
+    depends on MICROBLAZE
+    default y
+    help
+      This is needed to be able to allocate uncachable memory regions.
+      The feature requires the design to define the RAM memory controller window
+      to be twice as large as the actual physical memory.
+
+config LARGE_ALLOCS
+       bool "Allow allocating large blocks (> 1MB) of memory"
+       help
+            Allow the slab memory allocator to keep chains for very large
+            memory sizes - upto 32MB. You may need this if your system has
+            a lot of RAM, and you need to able to allocate very large
+            contiguous chunks. If unsure, say N.
+
+comment "Boot options"
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	help
+	  On some architectures there is currently no way for the boot loader
+	  to pass arguments to the kernel. For these architectures, you should
+	  supply some command-line options at build time by entering them 
+	  here. 
+
+config CMDLINE_FORCE
+	bool "Force default kernel command string"
+	help
+	  Set this to have arguments from the default kernel command string 
+	  override those passed by the boot loader
+
+config OF
+	bool
+	default y
+	help
+	  Set this to turn on OF
+
+config OF_DEVICE
+	bool
+	default y
+	help
+	  Set this to turn on OF
+
+endmenu
+
+config APM_EMULATION
+	bool
+
+source "mm/Kconfig"
+
+menu "Exectuable file formats"
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
+source "arch/microblaze/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
new file mode 100644
index 0000000..1ccdd84
--- /dev/null
+++ b/arch/microblaze/Kconfig.debug
@@ -0,0 +1,22 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config EARLY_PRINTK
+	bool "EARLY_PRINTK"
+	default y
+
+config EARLY_PRINTK_UARTLITE_ADDRESS
+	hex "Physical address where UART Lite for early printk is mapped"
+	depends on EARLY_PRINTK
+	default "0x40600000"
+	help
+	  Please enter physcal address where your uart lite is mapped
+
+config DEBUG_BOOTMEM
+	depends on DEBUG_KERNEL
+	bool "Debug BOOTMEM initialization"
+
+endmenu
+
+
diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
new file mode 100644
index 0000000..7b8eecb
--- /dev/null
+++ b/arch/microblaze/platform/Kconfig.platform
@@ -0,0 +1,46 @@
+#
+# platform selection Kconfig menu for MicroBlaze targets
+#
+menu "Platform options"
+choice
+	prompt "Platform"
+	default PLATFORM_MICROBLAZE_AUTO
+	help
+	  Choose which hardware board/platform you are targeting
+
+config PLATFORM_GENERIC
+	bool "Generic" 
+	help 
+	  Choose this option for the Generic platform 
+
+endchoice
+
+# This is stil a bit broken - disabling for now JW 20070504
+config ALLOW_EDIT_AUTO
+	bool "Permit Display/edit of Kconfig.auto platform settings"
+	default n
+	help
+	  Allows the editing of auto-generated platform settings from 
+	  the Kconfig.auto file.  Obviously this does not change the 
+	  underlying hardware, so be very careful if you go editing 
+	  these settings.
+	
+	  Also, if you enable this, and edit various Kconfig.auto 
+	  settings, YOUR CHANGES WILL BE LOST if you then disable it 
+	  again. You have been warned!
+	
+	  If unsure, say no
+
+# Ok, the platform is chosen.  Source the kconfig.auto to get all of the 
+# system settings.
+# If user selected CONFIG_EDIT_AUTO, these will be rendered in gory detail
+# and be able to be edited
+comment "Automatic platform settings from Kconfig.auto"
+	depends on ALLOW_EDIT_AUTO
+
+if PLATFORM_GENERIC=y
+    source "arch/microblaze/platform/generic/Kconfig.auto"
+endif
+
+endmenu
+
diff --git a/arch/microblaze/platform/generic/Kconfig.auto b/arch/microblaze/platform/generic/Kconfig.auto
new file mode 100644
index 0000000..751369b
--- /dev/null
+++ b/arch/microblaze/platform/generic/Kconfig.auto
@@ -0,0 +1,45 @@
+#
+# Platform Kconfig menu for Microblaze generic board
+#
+
+config KERNEL_BASE_ADDR
+	hex "Physical address where Linux Kernel is"
+	default "0x44000000"
+	help
+	  BASE Address for kernel
+
+config XILINX_ERAM_SIZE
+       hex "Size address of XILINX_RAM" if ALLOW_EDIT_AUTO && XILINX_UNCACHED_SHADOW
+       default 0x02000000
+
+comment "Definitions for MICROBLAZE0"
+      depends on ALLOW_EDIT_AUTO
+
+config XILINX_MICROBLAZE0_FAMILY
+       string "Targetted FPGA family" if ALLOW_EDIT_AUTO
+       default spartan3e
+
+config XILINX_MICROBLAZE0_HW_VER
+       string "Core version number" if ALLOW_EDIT_AUTO
+       default 5.00.c
+
+config XILINX_MICROBLAZE0_USE_MSR_INSTR
+       int "USE_MSR_INSTR" if ALLOW_EDIT_AUTO
+       default 1
+
+config XILINX_MICROBLAZE0_USE_BARREL
+       int "USE_BARREL range (0:1)" if ALLOW_EDIT_AUTO
+       default 1
+
+config XILINX_MICROBLAZE0_USE_DIV
+       int "USE_DIV range (0:1)" if ALLOW_EDIT_AUTO
+       default 1
+
+config XILINX_MICROBLAZE0_USE_HW_MUL
+       int "USE_HW_MUL range (0:1)" if ALLOW_EDIT_AUTO
+       default 1
+
+config XILINX_MICROBLAZE0_USE_FPU
+       int "USE_FPU range (0:1)" if ALLOW_EDIT_AUTO
+       default 0
+
-- 
1.5.4.rc4.14.g6fc74

