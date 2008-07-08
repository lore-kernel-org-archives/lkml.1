Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbYGHMqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbYGHMqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbYGHMpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:45:14 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27544 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759221AbYGHMpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:45:11 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 01/58] microblaze_v5: Kconfig patches
Date: Tue,  8 Jul 2008 13:59:01 +0200
Message-Id: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig                       |  127 +++++++++++++++++++++++++
 arch/microblaze/Kconfig.debug                 |   39 ++++++++
 arch/microblaze/platform/Kconfig.platform     |   77 +++++++++++++++
 arch/microblaze/platform/generic/Kconfig.auto |   62 ++++++++++++
 4 files changed, 305 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/Kconfig
 create mode 100644 arch/microblaze/Kconfig.debug
 create mode 100644 arch/microblaze/platform/Kconfig.platform
 create mode 100644 arch/microblaze/platform/generic/Kconfig.auto

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
new file mode 100644
index 0000000..9774f71
--- /dev/null
+++ b/arch/microblaze/Kconfig
@@ -0,0 +1,127 @@
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+
+mainmenu "Linux/Microblaze Kernel Configuration"
+
+config MICROBLAZE
+	def_bool y
+	select HAVE_LMB
+
+config MMU
+	def_bool n
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
+config PCI
+	def_bool n
+
+config NO_DMA
+	def_bool y
+
+config GENERIC_CSUM
+	def_bool y
+
+source "init/Kconfig"
+
+source "arch/microblaze/platform/Kconfig.platform"
+
+menu "Processor type and features"
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.hz"
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
index 0000000..611ef00
--- /dev/null
+++ b/arch/microblaze/Kconfig.debug
@@ -0,0 +1,39 @@
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
+
+config EARLY_PRINTK_UARTLITE_ADDRESS
+	hex "Physical address where UART Lite for early printk is mapped"
+	depends on EARLY_PRINTK
+	default "0x00000000"
+	help
+	  Please enter physical address where your uart lite is mapped.
+
+config HEART_BEAT
+	bool "Heart beat function for kernel"
+	default n
+	help
+	  This option turns on/off heart beat kernel functionality on selected
+	  GPIO address.
+
+config HEART_BEAT_ADDRESS
+	hex "Physical address for heart beat LED"
+	depends on HEART_BEAT
+	default "0x00000000"
+	help
+	  Please enter physical address GPIO LED.
+
+config DEBUG_BOOTMEM
+	depends on DEBUG_KERNEL
+	bool "Debug BOOTMEM initialization"
+
+endmenu
diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
new file mode 100644
index 0000000..2789f92
--- /dev/null
+++ b/arch/microblaze/platform/Kconfig.platform
@@ -0,0 +1,77 @@
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
+	depends on EXPERIMENTAL
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
index 0000000..8f33468
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
+# CAUTION: This file is automatically generated by libgen.
+# Version: Xilinx EDK 9.2.02 EDK_Jm_SP2.3
+# Generate by U-BOOT v4.00.c
+#
+
+# Definitions for MICROBLAZE0
+comment "Definitions for MICROBLAZE0"
+      depends on ALLOW_EDIT_AUTO
+
+config KERNEL_BASE_ADDR
+	hex "Physical address where Linux Kernel is"
+	default "0x20000000"
+	help
+	  BASE Address for kernel
+
+config XILINX_MICROBLAZE0_FAMILY
+       string "Targetted FPGA family" if ALLOW_EDIT_AUTO
+       default spartan3e
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
+config XILINX_MICROBLAZE0_USE_HW_MULT
+       int "USE_HW_MULT range (0:1)" if ALLOW_EDIT_AUTO
+       default 2
+
+config XILINX_MICROBLAZE0_USE_FPU
+       int "USE_FPU range (0:1)" if ALLOW_EDIT_AUTO
+       default 2
+
+config XILINX_MICROBLAZE0_HW_VER
+       string "Core version number" if ALLOW_EDIT_AUTO
+       default 7.00.b
-- 
1.5.4.GIT

