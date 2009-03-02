Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZCBQ6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZCBQ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZCBQ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:43 -0500
Received: from mx1.emlix.com ([193.175.82.87]:43103 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581AbZCBQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:42 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:43:00 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/7] xtensa: beat Kconfig into shape
Content-Disposition: inline; filename=xtensa-beat-kconfig-into-shape.patch
Message-Id: <E1LeBSV-0003Yy-V9@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of making support code depend on variants or platforms, the
latter should select what they need explicitely.

Otherwise this starts looking weird when support code depends on
!XTENSA_PLATFORM_FOO && !XTENSA_PLATFORM_BAR etc.

This also includes some minor fixlets like converting bool and default
to def_bool and fixing indentation and whitespace errors.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/Kconfig |  168 ++++++++++++++++++++++++----------------------------
 1 file changed, 79 insertions(+), 89 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -4,16 +4,13 @@
 mainmenu "Linux/Xtensa Kernel Configuration"
 
 config FRAME_POINTER
-	bool
-	default n
+	def_bool n
 
 config ZONE_DMA
-	bool
-	default y
+	def_bool y
 
 config XTENSA
-	bool
-	default y
+	def_bool y
 	select HAVE_IDE
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
@@ -24,28 +21,22 @@ config XTENSA
 	  a home page at <http://xtensa.sourceforge.net/>.
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HARDIRQS
-	bool
-	default y
+	def_bool y
 
 config ARCH_HAS_ILOG2_U32
-	bool
-	default n
+	def_bool n
 
 config ARCH_HAS_ILOG2_U64
-	bool
-	default n
+	def_bool n
 
 config NO_IOPORT
 	def_bool y
@@ -57,6 +48,9 @@ config HZ
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
+config MMU
+	def_bool n
+
 menu "Processor type and features"
 
 choice
@@ -65,38 +59,36 @@ choice
 
 config XTENSA_VARIANT_FSF
 	bool "fsf - default (not generic) configuration"
+	select MMU
 
 config XTENSA_VARIANT_DC232B
 	bool "dc232b - Diamond 232L Standard Core Rev.B (LE)"
+	select MMU
 	help
-	This variant refers to Tensilica's Diamond 232L Standard core Rev.B (LE).
+	  This variant refers to Tensilica's Diamond 232L Standard core Rev.B (LE).
 endchoice
 
-config MMU
-	bool
-	default y
-
 config XTENSA_UNALIGNED_USER
 	bool "Unaligned memory access in use space"
-	---help---
-	   The Xtensa architecture currently does not handle unaligned
-	   memory accesses in hardware but through an exception handler.
-	   Per default, unaligned memory accesses are disabled in user space.
+	help
+	  The Xtensa architecture currently does not handle unaligned
+	  memory accesses in hardware but through an exception handler.
+	  Per default, unaligned memory accesses are disabled in user space.
 
-	   Say Y here to enable unaligned memory access in user space.
+	  Say Y here to enable unaligned memory access in user space.
 
 config PREEMPT
 	bool "Preemptible Kernel"
-	---help---
-           This option reduces the latency of the kernel when reacting to
-           real-time or interactive events by allowing a low priority process to
-           be preempted even if it is in kernel mode executing a system call.
-           Unfortunately the kernel code has some race conditions if both
-           CONFIG_SMP and CONFIG_PREEMPT are enabled, so this option is
-           currently disabled if you are building an SMP kernel.
+	help
+          This option reduces the latency of the kernel when reacting to
+          real-time or interactive events by allowing a low priority process to
+          be preempted even if it is in kernel mode executing a system call.
+          Unfortunately the kernel code has some race conditions if both
+          CONFIG_SMP and CONFIG_PREEMPT are enabled, so this option is
+          currently disabled if you are building an SMP kernel.
 
-           Say Y here if you are building a kernel for a desktop, embedded
-           or real-time system.  Say N if you are unsure.
+          Say Y here if you are building a kernel for a desktop, embedded
+          or real-time system.  Say N if you are unsure.
 
 config MATH_EMULATION
 	bool "Math emulation"
@@ -108,6 +100,32 @@ config HIGHMEM
 
 endmenu
 
+config XTENSA_CALIBRATE_CCOUNT
+	def_bool n
+	help
+	  On some platforms (XT2000, for example), the CPU clock rate can
+	  vary.  The frequency can be determined, however, by measuring
+	  against a well known, fixed frequency, such as an UART oscillator.
+
+config SERIAL_CONSOLE
+	def_bool n
+
+config XTENSA_ISS_NETWORK
+	def_bool n
+
+menu "Bus options"
+
+config PCI
+	bool "PCI support"
+	default y
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+source "drivers/pci/Kconfig"
+
 menu "Platform options"
 
 choice
@@ -116,11 +134,16 @@ choice
 
 config XTENSA_PLATFORM_ISS
 	bool "ISS"
+	select XTENSA_CALIBRATE_CCOUNT
+	select SERIAL_CONSOLE
+	select XTENSA_ISS_NETWORK
 	help
 	  ISS is an acronym for Tensilica's Instruction Set Simulator.
 
 config XTENSA_PLATFORM_XT2000
 	bool "XT2000"
+	select XTENSA_CALIBRATE_CCOUNT
+	select PCI
 	help
 	  XT2000 is the name of Tensilica's feature-rich emulation platform.
 	  This hardware is capable of running a full Linux distribution.
@@ -128,21 +151,14 @@ config XTENSA_PLATFORM_XT2000
 endchoice
 
 
-config XTENSA_CALIBRATE_CCOUNT
-	bool "Auto calibration of the CPU clock rate"
-	---help---
-	  On some platforms (XT2000, for example), the CPU clock rate can
-	  vary.  The frequency can be determined, however, by measuring
-	  against a well known, fixed frequency, such as an UART oscillator.
-
 config XTENSA_CPU_CLOCK
 	int "CPU clock rate [MHz]"
 	depends on !XTENSA_CALIBRATE_CCOUNT
-	default "16"
+	default 16
 
 config GENERIC_CALIBRATE_DELAY
 	bool "Auto calibration of the BogoMIPS value"
-	---help---
+	help
 	  The BogoMIPS value can easily be derived from the CPU frequency.
 
 config CMDLINE_BOOL
@@ -159,52 +175,27 @@ config CMDLINE
 	  time by entering them here. As a minimum, you should specify the
 	  memory size and the root device (e.g., mem=64M root=/dev/nfs).
 
-config SERIAL_CONSOLE
-	bool
-	depends on XTENSA_PLATFORM_ISS
-	default y
-
-config XTENSA_ISS_NETWORK
-	bool
-	depends on XTENSA_PLATFORM_ISS
-	default y
-
 source "mm/Kconfig"
 
 endmenu
 
-menu "Bus options"
-
-config PCI
-	bool "PCI support" if !XTENSA_PLATFORM_ISS
-	depends on !XTENSA_PLATFORM_ISS
-	default y
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
-source "drivers/pci/Kconfig"
-
 config HOTPLUG
-
 	bool "Support for hot-pluggable devices"
-	---help---
-	Say Y here if you want to plug devices into your computer while
-	the system is running, and be able to use them quickly.  In many
-	cases, the devices can likewise be unplugged at any time too.
-
-	One well known example of this is PCMCIA- or PC-cards, credit-card
-	size devices such as network cards, modems or hard drives which are
-	plugged into slots found on all modern laptop computers.  Another
-	example, used on modern desktops as well as laptops, is USB.
-
-	Enable HOTPLUG and build a modular kernel.  Get agent software
-	(from <http://linux-hotplug.sourceforge.net/>) and install it.
-	Then your kernel will automatically call out to a user mode "policy
-	agent" (/sbin/hotplug) to load modules and set up software needed
-	to use devices as you hotplug them.
+	help
+	  Say Y here if you want to plug devices into your computer while
+	  the system is running, and be able to use them quickly.  In many
+	  cases, the devices can likewise be unplugged at any time too.
+
+	  One well known example of this is PCMCIA- or PC-cards, credit-card
+	  size devices such as network cards, modems or hard drives which are
+	  plugged into slots found on all modern laptop computers.  Another
+	  example, used on modern desktops as well as laptops, is USB.
+
+	  Enable HOTPLUG and build a modular kernel.  Get agent software
+	  (from <http://linux-hotplug.sourceforge.net/>) and install it.
+	  Then your kernel will automatically call out to a user mode "policy
+	  agent" (/sbin/hotplug) to load modules and set up software needed
+	  to use devices as you hotplug them.
 
 source "drivers/pcmcia/Kconfig"
 
@@ -216,9 +207,8 @@ menu "Executable file formats"
 
 # only elf supported
 config KCORE_ELF
-        bool
+	def_bool y
         depends on PROC_FS
-        default y
         help
           If you enabled support for /proc file system then the file
           /proc/kcore will contain the kernel core image in ELF format. This
@@ -243,7 +233,7 @@ source "fs/Kconfig"
 menu "Xtensa initrd options"
 	depends on BLK_DEV_INITRD
 
-	config EMBEDDED_RAMDISK
+config EMBEDDED_RAMDISK
 	bool "Embed root filesystem ramdisk into the kernel"
 
 config EMBEDDED_RAMDISK_IMAGE

-- 

