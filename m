Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZCRUc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZCRUc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZCRUbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:43 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56201 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752459AbZCRUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 01/57] microblaze_v7: Kconfig patches
Date: Wed, 18 Mar 2009 21:30:28 +0100
Message-Id: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig                       |  136 +++++++++++++++++++++++++
 arch/microblaze/Kconfig.debug                 |   26 +++++
 arch/microblaze/platform/Kconfig.platform     |   85 +++++++++++++++
 arch/microblaze/platform/generic/Kconfig.auto |   62 +++++++++++
 4 files changed, 309 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/Kconfig
 create mode 100644 arch/microblaze/Kconfig.debug
 create mode 100644 arch/microblaze/platform/Kconfig.platform
 create mode 100644 arch/microblaze/platform/generic/Kconfig.auto

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
new file mode 100644
index 0000000..a2df3f8
--- /dev/null
+++ b/arch/microblaze/Kconfig
@@ -0,0 +1,136 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+
+mainmenu "Linux/Microblaze Kernel Configuration"
+
+config MICROBLAZE
+	def_bool y
+	select HAVE_LMB
+
+config SWAP
+	def_bool n
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config ARCH_HAS_ILOG2_U32
+	def_bool n
+
+config ARCH_HAS_ILOG2_U64
+	def_bool n
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_HARDIRQS
+	def_bool y
+
+config GENERIC_IRQ_PROBE
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_TIME_VSYSCALL
+	def_bool n
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config PCI
+	depends on !MMU
+	def_bool n
+
+config NO_DMA
+	depends on !MMU
+	def_bool n
+
+source "init/Kconfig"
+
+source "arch/microblaze/platform/Kconfig.platform"
+
+menu "Processor type and features"
+
+source kernel/time/Kconfig
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.hz"
+
+config MMU
+	def_bool n
+
+config NO_MMU
+	bool
+	depends on !MMU
+	default y
+
+comment "Boot options"
+
+config CMDLINE_BOOL
+	bool "Default bootloader kernel arguments"
+
+config CMDLINE
+	string "Default kernel command string"
+	depends on CMDLINE_BOOL
+	default "console=ttyUL0,115200"
+	help
+	  On some architectures there is currently no way for the boot loader
+	  to pass arguments to the kernel. For these architectures, you should
+	  supply some command-line options at build time by entering them
+	  here.
+
+config CMDLINE_FORCE
+	bool "Force default kernel command string"
+	depends on CMDLINE_BOOL
+	default n
+	help
+	  Set this to have arguments from the default kernel command string
+	  override those passed by the boot loader.
+
+config OF
+	def_bool y
+
+config OF_DEVICE
+	def_bool y
+
+config PROC_DEVICETREE
+	bool "Support for device tree in /proc"
+	depends on PROC_FS
+	help
+	  This option adds a device-tree directory under /proc which contains
+	  an image of the device tree that the kernel copies from Open
+	  Firmware or other boot firmware. If unsure, say Y here.
+
+endmenu
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
index 0000000..242cd35
--- /dev/null
+++ b/arch/microblaze/Kconfig.debug
@@ -0,0 +1,26 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config EARLY_PRINTK
+	bool "Early printk function for kernel"
+	default n
+	help
+	  This option turns on/off early printk messages to console.
+	  First Uartlite node is taken.
+
+config HEART_BEAT
+	bool "Heart beat function for kernel"
+	default n
+	help
+	  This option turns on/off heart beat kernel functionality.
+	  First GPIO node is taken.
+
+config DEBUG_BOOTMEM
+	depends on DEBUG_KERNEL
+	bool "Debug BOOTMEM initialization"
+
+endmenu
diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
new file mode 100644
index 0000000..8e9b475
--- /dev/null
+++ b/arch/microblaze/platform/Kconfig.platform
@@ -0,0 +1,85 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+# Platform selection Kconfig menu for MicroBlaze targets
+#
+
+menu "Platform options"
+choice
+	prompt "Platform"
+	default PLATFORM_MICROBLAZE_AUTO
+	help
+	  Choose which hardware board/platform you are targeting.
+
+config PLATFORM_GENERIC
+	bool "Generic"
+	help
+	  Choose this option for the Generic platform.
+
+endchoice
+
+config SELFMOD
+	bool "Use self modified code for intc/timer"
+	depends on EXPERIMENTAL && NO_MMU
+	default n
+	help
+	  This choice enables self-modified code for interrupt controller
+	  and timer.
+
+config SELFMOD_INTC
+	bool "Use self modified code for intc"
+	depends on SELFMOD
+	default y
+	help
+	  This choice enables self-modified code for interrupt controller.
+
+config SELFMOD_TIMER
+	bool "Use self modified code for timer"
+	depends on SELFMOD
+	default y
+	help
+	  This choice enables self-modified code for timer.
+
+config OPT_LIB_FUNCTION
+	bool "Optimalized lib function"
+	default y
+	help
+	  Allows turn on optimalized library function (memcpy and memmove).
+	  They are optimized by using word alignment. This will work
+	  fine if both source and destination are aligned on the same
+	  boundary. However, if they are aligned on different boundaries
+	  shifts will be necessary. This might result in bad performance
+	  on MicroBlaze systems without a barrel shifter.
+
+config OPT_LIB_ASM
+	bool "Optimalized lib function ASM"
+	depends on OPT_LIB_FUNCTION
+	default n
+	help
+	  Allows turn on optimalized library function (memcpy and memmove).
+	  Function are written in asm code.
+
+# This is still a bit broken - disabling for now JW 20070504
+config ALLOW_EDIT_AUTO
+	bool "Permit Display/edit of Kconfig.auto platform settings"
+	default n
+	help
+	  Allows the editing of auto-generated platform settings from
+	  the Kconfig.auto file. Obviously this does not change the
+	  underlying hardware, so be very careful if you go editing
+	  these settings.
+
+	  Also, if you enable this, and edit various Kconfig.auto
+	  settings, YOUR CHANGES WILL BE LOST if you then disable it
+	  again. You have been warned!
+
+	  If unsure, say no.
+
+comment "Automatic platform settings from Kconfig.auto"
+	depends on ALLOW_EDIT_AUTO
+
+if PLATFORM_GENERIC=y
+	source "arch/microblaze/platform/generic/Kconfig.auto"
+endif
+
+endmenu
diff --git a/arch/microblaze/platform/generic/Kconfig.auto b/arch/microblaze/platform/generic/Kconfig.auto
new file mode 100644
index 0000000..fbca22d
--- /dev/null
+++ b/arch/microblaze/platform/generic/Kconfig.auto
@@ -0,0 +1,62 @@
+#
+# (C) Copyright 2007 Michal Simek
+#
+# Michal SIMEK <monstr@monstr.eu>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation; either version 2 of
+# the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+# MA 02111-1307 USA
+#
+
+# Definitions for MICROBLAZE0
+comment "Definitions for MICROBLAZE0"
+	depends on ALLOW_EDIT_AUTO
+
+config KERNEL_BASE_ADDR
+	hex "Physical address where Linux Kernel is"
+	default "0x90000000"
+	help
+	  BASE Address for kernel
+
+config XILINX_MICROBLAZE0_FAMILY
+	string "Targetted FPGA family" if ALLOW_EDIT_AUTO
+	default "virtex5"
+
+config XILINX_MICROBLAZE0_USE_MSR_INSTR
+	int "USE_MSR_INSTR range (0:1)" if ALLOW_EDIT_AUTO
+	default 1
+
+config XILINX_MICROBLAZE0_USE_PCMP_INSTR
+	int "USE_PCMP_INSTR range (0:1)" if ALLOW_EDIT_AUTO
+	default 1
+
+config XILINX_MICROBLAZE0_USE_BARREL
+	int "USE_BARREL range (0:1)" if ALLOW_EDIT_AUTO
+	default 1
+
+config XILINX_MICROBLAZE0_USE_DIV
+	int "USE_DIV range (0:1)" if ALLOW_EDIT_AUTO
+	default 1
+
+config XILINX_MICROBLAZE0_USE_HW_MUL
+	int "USE_HW_MUL values (0=NONE, 1=MUL32, 2=MUL64)" if ALLOW_EDIT_AUTO
+	default 2
+
+config XILINX_MICROBLAZE0_USE_FPU
+	int "USE_FPU values (0=NONE, 1=BASIC, 2=EXTENDED)" if ALLOW_EDIT_AUTO
+	default 2
+
+config XILINX_MICROBLAZE0_HW_VER
+	string "Core version number" if ALLOW_EDIT_AUTO
+	default 7.10.d
-- 
1.5.5.1

