Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbXKQLMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbXKQLMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXKQLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:12:46 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58647 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753410AbXKQLMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:12:36 -0500
Date: Sat, 17 Nov 2007 12:12:14 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill CONFIG_EXPERIMENTAL
Message-ID: <20071117111214.GA4250@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the EXPERIMENTAL option and all dependencies on 
EXPERIMENTAL because they are pointless.

Complete rationale:
- Many people and all distributions are currently forced to enable
  CONFIG_EXPERIMENTAL since the options for many device drivers depend
  on this option.
  I have yet to see someone not being able to install his favorite
  distribution on his computer only because the distribution did choose
  to disable all SATA drivers with dependencies on EXPERIMENTAL in their
  kernels...
- History has shown that often the dependency on EXPERIMENTAL is not
  removed when the code has proven usable.
  As an example, is our NFSv4 support really still in an
  "alpha-test phase" [1], or is it already ready for being used?
  I don't know the answer in this specific case, but I wouldn't answer
  "still in an alpha-test phase" only based on the fact that the NFSv4
  options still depend on EXPERIMENTAL.
- It might have been differently 10 years ago, but today everything that
  is available in a released kernel should also be in a usable state.

[1] quoted from the CONFIG_EXPERIMENTAL help text

Some subsystem maintainers might want to add (and maintain!) subsystem 
specific options FOOBAR_EXPERIMENTAL limited to their subsystem instead.

This patch does not touch "EXPERIMENTAL" strings in prompts - there was 
anyway no strong relation in any direction between prompts claiming an 
option was experimental and actual dependencies on EXPERIMENTAL...

For avoiding clashes with other patches, this patch temporarily makes 
CONFIG_EXPERIMENTAL available as always enabled option.

---

 Documentation/DocBook/kernel-hacking.tmpl |    7 --
 Documentation/lguest/lguest.txt           |    4 -
 arch/alpha/Kconfig                        |    1 
 arch/arm/Kconfig                          |   10 +--
 arch/frv/Kconfig                          |    1 
 arch/ia64/Kconfig                         |    6 +-
 arch/m68k/Kconfig                         |    7 +-
 arch/m68knommu/Kconfig.debug              |    2 
 arch/mips/Kconfig                         |   27 ++-------
 arch/mips/jazz/Kconfig                    |    4 -
 arch/mips/sgi-ip27/Kconfig                |    1 
 arch/mips/tx4938/Kconfig                  |    2 
 arch/parisc/Kconfig                       |    4 -
 arch/powerpc/Kconfig                      |    8 +-
 arch/powerpc/platforms/cell/Kconfig       |    2 
 arch/powerpc/platforms/ps3/Kconfig        |    4 -
 arch/ppc/Kconfig                          |    1 
 arch/sh/Kconfig                           |    8 +-
 arch/sh/mm/Kconfig                        |    4 -
 arch/sh64/Kconfig                         |    1 
 arch/sparc64/Kconfig                      |    2 
 arch/um/Kconfig                           |    5 -
 arch/um/Kconfig.i386                      |    1 
 arch/um/Kconfig.net                       |    2 
 arch/x86/Kconfig                          |   15 ++---
 arch/x86/kernel/cpu/cpufreq/Kconfig       |    6 +-
 block/Kconfig                             |    1 
 crypto/Kconfig                            |    4 -
 drivers/acpi/Kconfig                      |    3 -
 drivers/ata/Kconfig                       |   48 ++++++++---------
 drivers/block/Kconfig                     |    6 +-
 drivers/block/paride/Kconfig              |    2 
 drivers/bluetooth/Kconfig                 |    2 
 drivers/char/Kconfig                      |    8 +-
 drivers/char/tpm/Kconfig                  |    1 
 drivers/edac/Kconfig                      |    1 
 drivers/firewire/Kconfig                  |    4 -
 drivers/hid/usbhid/Kconfig                |    4 -
 drivers/hwmon/Kconfig                     |   59 +++++++++------------
 drivers/i2c/busses/Kconfig                |   20 +++----
 drivers/i2c/chips/Kconfig                 |    9 ---
 drivers/ide/Kconfig                       |    9 +--
 drivers/ieee1394/Kconfig                  |    4 -
 drivers/infiniband/ulp/ipoib/Kconfig      |    2 
 drivers/input/misc/Kconfig                |    2 
 drivers/isdn/capi/Kconfig                 |    1 
 drivers/isdn/hisax/Kconfig                |    7 +-
 drivers/kvm/Kconfig                       |    2 
 drivers/lguest/Kconfig                    |    2 
 drivers/md/Kconfig                        |   24 ++++----
 drivers/media/Kconfig                     |    2 
 drivers/media/dvb/dvb-usb/Kconfig         |    2 
 drivers/media/video/Kconfig               |   28 +++++-----
 drivers/media/video/cx25840/Kconfig       |    2 
 drivers/media/video/cx88/Kconfig          |    2 
 drivers/media/video/ivtv/Kconfig          |    4 -
 drivers/media/video/pvrusb2/Kconfig       |    8 +-
 drivers/media/video/usbvideo/Kconfig      |    2 
 drivers/misc/Kconfig                      |    8 +-
 drivers/mmc/host/Kconfig                  |    8 +-
 drivers/mtd/chips/Kconfig                 |    2 
 drivers/mtd/devices/Kconfig               |    4 -
 drivers/mtd/nand/Kconfig                  |    1 
 drivers/net/Kconfig                       |   61 ++++++++++------------
 drivers/net/irda/Kconfig                  |   32 +++++------
 drivers/net/tulip/Kconfig                 |    4 -
 drivers/net/usb/Kconfig                   |   10 +--
 drivers/net/wireless/Kconfig              |   14 ++---
 drivers/net/wireless/b43/Kconfig          |    2 
 drivers/net/wireless/bcm43xx/Kconfig      |    2 
 drivers/net/wireless/iwlwifi/Kconfig      |    7 +-
 drivers/net/wireless/rt2x00/Kconfig       |    2 
 drivers/net/wireless/zd1211rw/Kconfig     |    2 
 drivers/parport/Kconfig                   |    8 +-
 drivers/pci/hotplug/Kconfig               |    2 
 drivers/pcmcia/Kconfig                    |    2 
 drivers/pnp/pnpbios/Kconfig               |    2 
 drivers/sbus/char/Kconfig                 |    7 +-
 drivers/scsi/Kconfig                      |   10 +--
 drivers/scsi/arm/Kconfig                  |    6 +-
 drivers/spi/Kconfig                       |   24 ++++----
 drivers/ssb/Kconfig                       |    8 +-
 drivers/usb/core/Kconfig                  |    8 +-
 drivers/usb/gadget/Kconfig                |   10 +--
 drivers/usb/host/Kconfig                  |    8 +-
 drivers/usb/image/Kconfig                 |    2 
 drivers/usb/misc/Kconfig                  |   10 +--
 drivers/usb/serial/Kconfig                |   24 ++++----
 drivers/usb/storage/Kconfig               |   14 ++---
 drivers/video/Kconfig                     |   14 ++---
 drivers/video/geode/Kconfig               |    6 +-
 drivers/w1/masters/Kconfig                |    2 
 fs/Kconfig                                |   45 +++++++---------
 fs/dlm/Kconfig                            |    2 
 fs/gfs2/Kconfig                           |    1 
 init/Kconfig                              |   38 +------------
 kernel/power/Kconfig                      |    2 
 mm/Kconfig                                |    3 -
 net/9p/Kconfig                            |    4 -
 net/Kconfig                               |    4 -
 net/atm/Kconfig                           |    1 
 net/dccp/Kconfig                          |    2 
 net/dccp/ccids/Kconfig                    |    4 -
 net/decnet/Kconfig                        |    2 
 net/decnet/netfilter/Kconfig              |    2 
 net/econet/Kconfig                        |    2 
 net/ieee80211/softmac/Kconfig             |    2 
 net/ipv4/Kconfig                          |   10 ---
 net/ipv4/netfilter/Kconfig                |    4 -
 net/ipv6/Kconfig                          |   10 +--
 net/ipv6/netfilter/Kconfig                |    8 +-
 net/lapb/Kconfig                          |    1 
 net/mac80211/Kconfig                      |    1 
 net/netfilter/Kconfig                     |   18 +++---
 net/rxrpc/Kconfig                         |    2 
 net/sctp/Kconfig                          |    2 
 net/tipc/Kconfig                          |    2 
 net/wanrouter/Kconfig                     |    1 
 net/x25/Kconfig                           |    1 
 net/xfrm/Kconfig                          |    6 +-
 security/Kconfig                          |    2 
 sound/oss/Kconfig                         |    2 
 sound/pci/Kconfig                         |    6 +-
 123 files changed, 396 insertions(+), 530 deletions(-)

4051ed421a3eec72e1f2460e52c8be607282d02b 
diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index 4c63e58..d1fc128 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1185,13 +1185,6 @@ static struct block_device_operations opt_fops = {
     </para>
 
     <para>
-     You may well want to make your CONFIG option only visible if
-     <symbol>CONFIG_EXPERIMENTAL</symbol> is enabled: this serves as a
-     warning to users.  There many other fancy things you can do: see
-     the various <filename>Kconfig</filename> files for ideas.
-    </para>
-
-    <para>
      In your description of the option, make sure you address both the
      expert user and the user who knows nothing about your feature.  Mention
      incompatibilities and issues here.  <emphasis> Definitely
diff --git a/Documentation/lguest/lguest.txt b/Documentation/lguest/lguest.txt
index 7885ab2..97790d5 100644
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -28,10 +28,6 @@ Running Lguest:
 
   You will need to configure your kernel with the following options:
 
-  "General setup":
-     "Prompt for development and/or incomplete code/drivers" = Y
-        (CONFIG_EXPERIMENTAL=y)
-
   "Processor type and features":
      "Paravirtualized guest support" = Y
         "Lguest guest support" = Y
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4c002ba..6d8af6e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -558,7 +558,6 @@ config NR_CPUS
 
 config ARCH_DISCONTIGMEM_ENABLE
 	bool "Discontiguous Memory Support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7e9fea..27c8725 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -570,7 +570,7 @@ source "kernel/time/Kconfig"
 
 config SMP
 	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && REALVIEW_MPCORE
+	depends on REALVIEW_MPCORE
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
@@ -597,7 +597,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
@@ -614,7 +614,6 @@ config LOCAL_TIMERS
 
 config PREEMPT
 	bool "Preemptible Kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This option reduces the latency of the kernel when reacting to
 	  real-time or interactive events by allowing a low priority process to
@@ -670,7 +669,7 @@ config AEABI
 
 config OABI_COMPAT
 	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL
+	depends on AEABI
 	default y
 	help
 	  This option preserves the old syscall interface along with the
@@ -847,7 +846,6 @@ config XIP_PHYS_ADDR
 
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -931,7 +929,7 @@ config FPE_NWFPE_XP
 
 config FPE_FASTFPE
 	bool "FastFPE math emulation (EXPERIMENTAL)"
-	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3 && EXPERIMENTAL
+	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3
 	---help---
 	  Say Y here to include the FAST floating point emulator in the kernel.
 	  This is an experimental much faster emulator which now also has full
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 43153e7..34adff4 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -348,7 +348,6 @@ source "drivers/pcmcia/Kconfig"
 
 #config MATH_EMULATION
 #	bool "Math emulation support (EXPERIMENTAL)"
-#	depends on EXPERIMENTAL
 #	help
 #	  At some point in the future, this will cause floating-point math
 #	  instructions to be emulated by the kernel on machines that lack a
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index bef4772..8b7755a 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -294,7 +294,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && EXPERIMENTAL
+	depends on SMP
 	select HOTPLUG
 	default n
 	---help---
@@ -484,7 +484,7 @@ source "drivers/sn/Kconfig"
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -501,7 +501,7 @@ config KEXEC
 
 config CRASH_DUMP
 	  bool "kernel crash dumps (EXPERIMENTAL)"
-	  depends on EXPERIMENTAL && IA64_MCA_RECOVERY && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	  depends on IA64_MCA_RECOVERY && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
 	  help
 	    Generate crash dump after being started by kexec.
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 01dee84..c23069d 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -301,7 +301,6 @@ config MMU_SUN3
 
 config M68KFPU_EMU
 	bool "Math emulation support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
@@ -414,7 +413,7 @@ config ZORRO
 
 config AMIGA_PCMCIA
 	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
+	depends on AMIGA
 	help
 	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
 	  600. If you intend to use pcmcia cards say Y; otherwise say N.
@@ -519,7 +518,7 @@ config ATARI_MIDI
 
 config ATARI_DSP56K
 	tristate "Atari DSP56k support (EXPERIMENTAL)"
-	depends on ATARI && EXPERIMENTAL
+	depends on ATARI
 	help
 	  If you want to be able to use the DSP56001 in Falcons, say Y. This
 	  driver is still experimental, and if you don't know what it is, or
@@ -617,7 +616,7 @@ config HPDCA
 
 config HPAPCI
 	tristate "HP APCI serial support"
-	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
+	depends on HP300 && SERIAL_8250
 	help
 	  If you want to use the internal "APCI" serial ports on an HP400
 	  machine, say Y here.
diff --git a/arch/m68knommu/Kconfig.debug b/arch/m68knommu/Kconfig.debug
index 9ff47bd..db33123 100644
--- a/arch/m68knommu/Kconfig.debug
+++ b/arch/m68knommu/Kconfig.debug
@@ -35,7 +35,7 @@ config NO_KERNEL_MSG
 
 config BDM_DISABLE
 	bool "Disable BDM signals"
-	depends on (EXPERIMENTAL && COLDFIRE)
+	depends on COLDFIRE
 	help
 	  Disable the ColdFire CPU's BDM signals.
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2c7d6c2..ec26278 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -77,7 +77,7 @@ config MIPS_COBALT
 	select SYS_HAS_CPU_NEVADA
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 
@@ -91,7 +91,7 @@ config MACH_DECSTATION
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_128HZ
 	select SYS_SUPPORTS_256HZ
@@ -125,7 +125,7 @@ config MACH_JAZZ
 	select PCSPEAKER
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_100HZ
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	help
@@ -198,7 +198,7 @@ config MIPS_ATLAS
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
-	select SYS_SUPPORTS_MULTITHREADING if EXPERIMENTAL
+	select SYS_SUPPORTS_MULTITHREADING
 	select SYS_SUPPORTS_SMARTMIPS
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	help
@@ -249,7 +249,7 @@ config MIPS_SEAD
 	select SYS_HAS_CPU_MIPS32_R2
 	select SYS_HAS_CPU_MIPS64_R1
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_SMARTMIPS
@@ -308,7 +308,6 @@ config PNX8550_STB810
 
 config PMC_MSP
 	bool "PMC-Sierra MSP chipsets"
-	depends on EXPERIMENTAL
 	select DMA_NONCOHERENT
 	select SWAP_IO_SPACE
 	select NO_EXCEPT_FILL
@@ -443,7 +442,6 @@ config SGI_IP32
 
 config SIBYTE_CRHINE
 	bool "Sibyte BCM91120C-CRhine"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -454,7 +452,6 @@ config SIBYTE_CRHINE
 
 config SIBYTE_CARMEL
 	bool "Sibyte BCM91120x-Carmel"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -465,7 +462,6 @@ config SIBYTE_CARMEL
 
 config SIBYTE_CRHONE
 	bool "Sibyte BCM91125C-CRhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125
@@ -477,7 +473,6 @@ config SIBYTE_CRHONE
 
 config SIBYTE_RHONE
 	bool "Sibyte BCM91125E-Rhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125H
@@ -501,7 +496,6 @@ config SIBYTE_SWARM
 
 config SIBYTE_LITTLESUR
 	bool "Sibyte BCM91250C2-LittleSur"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -514,7 +508,6 @@ config SIBYTE_LITTLESUR
 
 config SIBYTE_SENTOSA
 	bool "Sibyte BCM91250E-Sentosa"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -526,7 +519,6 @@ config SIBYTE_SENTOSA
 
 config SIBYTE_PTSWARM
 	bool "Sibyte BCM91250PT-PTSWARM"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -572,7 +564,7 @@ config SNI_RM
 	select R5000_CPU_SCACHE
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_SUPPORTS_LITTLE_ENDIAN
@@ -1118,7 +1110,6 @@ config CPU_R5432
 
 config CPU_R6000
 	bool "R6000"
-	depends on EXPERIMENTAL
 	select CPU_HAS_LLSC
 	depends on SYS_HAS_CPU_R6000
 	select CPU_SUPPORTS_32BIT_KERNEL
@@ -1137,7 +1128,6 @@ config CPU_NEVADA
 
 config CPU_R8000
 	bool "R8000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R8000
 	select CPU_HAS_LLSC
 	select CPU_HAS_PREFETCH
@@ -1332,7 +1322,7 @@ config PAGE_SIZE_4KB
 
 config PAGE_SIZE_8KB
 	bool "8kB"
-	depends on EXPERIMENTAL && CPU_R8000
+	depends on CPU_R8000
 	help
 	  Using 8kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available
@@ -1351,7 +1341,7 @@ config PAGE_SIZE_16KB
 
 config PAGE_SIZE_64KB
 	bool "64kB"
-	depends on EXPERIMENTAL && !CPU_R3000 && !CPU_TX39XX
+	depends on !CPU_R3000 && !CPU_TX39XX
 	help
 	  Using 64kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available on
@@ -1828,7 +1818,6 @@ config MIPS_INSANE_LARGE
 
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/mips/jazz/Kconfig b/arch/mips/jazz/Kconfig
index 1f372b0..7e39bf8 100644
--- a/arch/mips/jazz/Kconfig
+++ b/arch/mips/jazz/Kconfig
@@ -1,6 +1,6 @@
 config ACER_PICA_61
 	bool "Support for Acer PICA 1 chipset (EXPERIMENTAL)"
-	depends on MACH_JAZZ && EXPERIMENTAL
+	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
@@ -13,7 +13,7 @@ config MIPS_MAGNUM_4000
 	bool "Support for MIPS Magnum 4000"
 	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
-	select SYS_SUPPORTS_BIG_ENDIAN if EXPERIMENTAL
+	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
 	  This is a machine with a R4000 100 MHz CPU. To compile a Linux
diff --git a/arch/mips/sgi-ip27/Kconfig b/arch/mips/sgi-ip27/Kconfig
index 5e960ae..1e275d9 100644
--- a/arch/mips/sgi-ip27/Kconfig
+++ b/arch/mips/sgi-ip27/Kconfig
@@ -19,7 +19,6 @@ config SGI_SN_M_MODE
 
 config SGI_SN_N_MODE
 	bool "IP27 N-Mode"
-	depends on EXPERIMENTAL
 	help
 	  The nodes of Origin, Onyx, Fuel and Tezro systems can be configured
 	  in either N-Modes which allows for more nodes or M-Mode which allows
diff --git a/arch/mips/tx4938/Kconfig b/arch/mips/tx4938/Kconfig
index d90e9cd..2a712ae 100644
--- a/arch/mips/tx4938/Kconfig
+++ b/arch/mips/tx4938/Kconfig
@@ -15,7 +15,7 @@ config TOSHIBA_RBTX4938_MPLEX_ATA
 endchoice
 
 config TX4938_NAND_BOOT
-	depends on EXPERIMENTAL && TOSHIBA_RBTX4938_MPLEX_NAND
+	depends on TOSHIBA_RBTX4938_MPLEX_NAND
 	bool "NAND Boot Support (EXPERIMENTAL)"
 	help
 	  This is only for Toshiba RBTX4938 reference board, which has NAND IPL.
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b8ef178..0d782c0 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -179,11 +179,11 @@ config PARISC_PAGE_SIZE_4KB
 
 config PARISC_PAGE_SIZE_16KB
 	bool "16KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	depends on PA8X00
 
 config PARISC_PAGE_SIZE_64KB
 	bool "64KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	depends on PA8X00
 
 endchoice
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 18f397c..3bfd84b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -142,7 +142,7 @@ config DEFAULT_UIMAGE
 
 config PPC64_SWSUSP
 	bool
-	depends on PPC64 && (BROKEN || (PPC_PMAC64 && EXPERIMENTAL))
+	depends on PPC64 && (BROKEN || PPC_PMAC64)
 	default y
 
 config PPC_DCR_NATIVE
@@ -224,7 +224,7 @@ config IOMMU_VMERGE
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
+	depends on SMP && HOTPLUG && (PPC_PSERIES || PPC_PMAC)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
@@ -236,7 +236,7 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_PRPMC2800 || PPC_MULTIPLATFORM) && EXPERIMENTAL
+	depends on PPC_PRPMC2800 || PPC_MULTIPLATFORM
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -253,7 +253,7 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "Build a kdump crash kernel (EXPERIMENTAL)"
-	depends on PPC_MULTIPLATFORM && PPC64 && EXPERIMENTAL
+	depends on PPC_MULTIPLATFORM && PPC64
 	help
 	  Build a kernel suitable for use as a kdump capture kernel.
 	  The kernel will be linked at a different address than normal, and
diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index e1e2f6a..fde4ab3 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -79,7 +79,7 @@ config CBE_CPUFREQ
 
 config CBE_CPUFREQ_PMI
 	tristate "CBE frequency scaling using PMI interface"
-	depends on CBE_CPUFREQ && PPC_PMI && EXPERIMENTAL
+	depends on CBE_CPUFREQ && PPC_PMI
 	default n
 	help
 	  Select this, if you want to use the PMI interface
diff --git a/arch/powerpc/platforms/ps3/Kconfig b/arch/powerpc/platforms/ps3/Kconfig
index 67144d1..df1a089 100644
--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -48,7 +48,7 @@ config PS3_HTAB_SIZE
 	  system will have optimal runtime performance.
 
 config PS3_DYNAMIC_DMA
-	depends on PPC_PS3 && EXPERIMENTAL
+	depends on PPC_PS3
 	bool "PS3 Platform dynamic DMA page table management"
 	default n
 	help
@@ -62,7 +62,7 @@ config PS3_DYNAMIC_DMA
 	  say N.
 
 config PS3_USE_LPAR_ADDR
-	depends on PPC_PS3 && EXPERIMENTAL
+	depends on PPC_PS3
 	bool "PS3 use lpar address space"
 	default y
 	help
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index 6473fa7..32c027e 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -244,7 +244,6 @@ config MATH_EMULATION
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 496d635..875381c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -128,7 +128,7 @@ config SH_FPU
 
 config SH_FPU_EMU
 	bool "FPU emulation support"
-	depends on !SH_FPU && EXPERIMENTAL
+	depends on !SH_FPU
 	default n
 	help
 	  Selecting this option will enable support for software FPU emulation.
@@ -164,7 +164,7 @@ config SH_STORE_QUEUES
 
 config SPECULATIVE_EXECUTION
 	bool "Speculative subroutine return"
-	depends on CPU_SUBTYPE_SH7780 && EXPERIMENTAL
+	depends on CPU_SUBTYPE_SH7780
 	help
 	  This enables support for a speculative instruction fetch for
 	  subroutine return. There are various pitfalls associated with
@@ -500,7 +500,6 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -517,7 +516,6 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
@@ -744,7 +742,7 @@ source "fs/Kconfig.binfmt"
 endmenu
 
 menu "Power management options (EXPERIMENTAL)"
-depends on EXPERIMENTAL && SYS_SUPPORTS_PM
+depends on SYS_SUPPORTS_PM
 
 source kernel/power/Kconfig
 
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index 1265f20..a167164 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -247,7 +247,7 @@ config 32BIT
 
 config X2TLB
 	bool "Enable extended TLB mode"
-	depends on (CPU_SHX2 || CPU_SHX3) && MMU && EXPERIMENTAL
+	depends on (CPU_SHX2 || CPU_SHX3) && MMU
 	help
 	  Selecting this option will enable the extended mode of the SH-X2
 	  TLB. For legacy SH-X behaviour and interoperability, say N. For
@@ -269,7 +269,7 @@ config VSYSCALL
 
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
-	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	depends on MMU && SYS_SUPPORTS_NUMA
 	default n
 	help
 	  Some SH systems have many various memories scattered around
diff --git a/arch/sh64/Kconfig b/arch/sh64/Kconfig
index 6884d5a..c9847fa 100644
--- a/arch/sh64/Kconfig
+++ b/arch/sh64/Kconfig
@@ -224,7 +224,6 @@ config SH_DMA
 
 config PREEMPT
 	bool "Preemptible Kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 
 source "mm/Kconfig"
 
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 10b212a..f2f6f6d 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -408,7 +408,7 @@ config SUNOS_EMUL
 
 config SOLARIS_EMUL
 	tristate "Solaris binary emulation (EXPERIMENTAL)"
-	depends on SPARC32_COMPAT && NET && EXPERIMENTAL
+	depends on SPARC32_COMPAT && NET
 	help
 	  This is experimental code which will enable you to run (many)
 	  Solaris binaries on your SPARC Linux machine.
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dd1689b..875c89b 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -137,7 +137,6 @@ config HOSTFS
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
@@ -190,7 +189,7 @@ config SMP
 	bool "Symmetric multi-processing support (EXPERIMENTAL)"
 	default n
 	#SMP_BROKEN is for x86_64.
-	depends on EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
+	depends on !SMP_BROKEN || (BROKEN && SMP_BROKEN)
 	help
 	  This option enables UML SMP support.
 	  It is NOT related to having a real SMP box. Not directly, at least.
@@ -230,7 +229,7 @@ config NEST_LEVEL
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
-	depends on !64BIT && EXPERIMENTAL
+	depends on !64BIT
 	default n
 	help
 	  This was used to allow UML to run with big amounts of memory.
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index e0ac74e..4a50f91 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -56,7 +56,6 @@ config TOP_ADDR
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)"
 	default n
-	depends on EXPERIMENTAL
 	help
 	Three-level pagetables will let UML have more than 4G of physical
 	memory.  All the memory that can't be mapped directly will be treated
diff --git a/arch/um/Kconfig.net b/arch/um/Kconfig.net
index 66e5002..b810bb5 100644
--- a/arch/um/Kconfig.net
+++ b/arch/um/Kconfig.net
@@ -157,7 +157,7 @@ config UML_NET_MCAST
 
 config UML_NET_PCAP
 	bool "pcap transport"
-	depends on UML_NET && EXPERIMENTAL
+	depends on UML_NET
 	help
 	The pcap transport makes a pcap packet stream on the host look
 	like an ethernet device inside UML.  This is useful for making
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2c357f0..d18b97a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -424,7 +424,7 @@ config GART_IOMMU
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
-	depends on X86_64 && PCI && EXPERIMENTAL
+	depends on X86_64 && PCI
 	help
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -753,7 +753,6 @@ config HIGHMEM64G
 endchoice
 
 choice
-	depends on EXPERIMENTAL
 	prompt "Memory split" if EMBEDDED
 	default VMSPLIT_3G
 	depends on X86_32
@@ -816,7 +815,7 @@ config X86_PAE
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI))
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
@@ -902,7 +901,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on NUMA || (EXPERIMENTAL && (X86_PC || X86_64))
+	depends on NUMA || X86_PC || X86_64
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
@@ -1037,7 +1036,7 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on X86_64 && EXPERIMENTAL
+	depends on X86_64
 	help
          This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of critical functions, a canary
@@ -1079,7 +1078,6 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
 	  Generate crash dump after being started by kexec.
@@ -1137,7 +1135,6 @@ config PHYSICAL_START
 
 config RELOCATABLE
 	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This builds a kernel image that retains relocation information
 	  so it can be loaded someplace besides the default 1MB.
@@ -1179,7 +1176,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
@@ -1443,7 +1440,7 @@ config PCI_MMCONFIG
 
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-	depends on X86_64 && PCI_MSI && ACPI && EXPERIMENTAL
+	depends on X86_64 && PCI_MSI && ACPI
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index 151eda0..1d60172 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -169,7 +169,7 @@ config X86_SPEEDSTEP_ICH
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
@@ -201,7 +201,7 @@ config X86_P4_CLOCKMOD
 
 config X86_CPUFREQ_NFORCE2
 	tristate "nVidia nForce2 FSB changing"
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
 	  platforms.
@@ -237,7 +237,7 @@ config X86_LONGHAUL
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (EXPERIMENTAL)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.
 
diff --git a/block/Kconfig b/block/Kconfig
index 9bda7bc..f7f7f04 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -51,7 +51,6 @@ config LSF
 
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	Saying Y here will enable generic SG (SCSI generic) v4 support
 	for any block device.
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 083d2e1..6b2844f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -57,7 +57,6 @@ config CRYPTO_HMAC
 
 config CRYPTO_XCBC
 	tristate "XCBC support"
-	depends on EXPERIMENTAL
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -138,7 +137,6 @@ config CRYPTO_TGR192
 
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  Efficient table driven implementation of multiplications in the
 	  field GF(2^128).  This is needed by some cypher modes. This
@@ -173,7 +171,6 @@ config CRYPTO_PCBC
 
 config CRYPTO_LRW
 	tristate "LRW support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
@@ -186,7 +183,6 @@ config CRYPTO_LRW
 
 config CRYPTO_XTS
 	tristate "XTS support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 087a702..34393cb 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -140,13 +140,11 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	tristate "Dock"
-	depends on EXPERIMENTAL
 	help
 	  This driver adds support for ACPI controlled docking stations
 
 config ACPI_BAY
 	tristate "Removable Drive Bay (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled removable drive
@@ -322,7 +320,6 @@ config X86_PM_TIMER
 
 config ACPI_CONTAINER
 	tristate "ACPI0004,PNP0A05 and PNP0A06 Container Driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
 	 ---help---
 	  This allows _physical_ insertion and removal of CPUs and memory.
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ba63619..91445bb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -69,7 +69,7 @@ config ATA_PIIX
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
@@ -110,7 +110,7 @@ config SATA_PROMISE
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -169,7 +169,7 @@ config SATA_VITESSE
 
 config SATA_INIC162X
 	tristate "Initio 162x SATA support (HIGHLY EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
@@ -193,7 +193,7 @@ config SATA_FSL
 
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -219,7 +219,7 @@ config PATA_ARTOP
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on AVR32 && PLATFORM_AT32AP
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -237,7 +237,7 @@ config PATA_ATIIXP
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -265,7 +265,7 @@ config PATA_CS5520
 
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -274,7 +274,7 @@ config PATA_CS5530
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -283,7 +283,7 @@ config PATA_CS5535
 
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -292,7 +292,7 @@ config PATA_CS5536
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -328,7 +328,7 @@ config PATA_HPT366
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -337,7 +337,7 @@ config PATA_HPT37X
 
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -363,7 +363,7 @@ config PATA_HPT3X3_DMA
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
-	depends on EXPERIMENTAL && ISAPNP
+	depends on ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -382,7 +382,7 @@ config PATA_IT821X
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -400,7 +400,7 @@ config PATA_JMICRON
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
@@ -461,7 +461,7 @@ config PATA_NETCELL
 
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the National Semiconductor
 	  NS87410 PCI-IDE controller.
@@ -470,7 +470,7 @@ config PATA_NS87410
 
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the National Semiconductor
 	  NS87415 PCI-IDE controller.
@@ -479,7 +479,7 @@ config PATA_NS87415
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -488,7 +488,7 @@ config PATA_OPTI
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -507,7 +507,7 @@ config PATA_PCMCIA
 
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -522,7 +522,7 @@ config PATA_QDI
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -540,7 +540,7 @@ config PATA_RZ1000
 
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -574,7 +574,7 @@ config PATA_SIL680
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for SiS PATA controllers
 
@@ -600,7 +600,7 @@ config PATA_WINBOND
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4d0119e..03ac333 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -156,7 +156,7 @@ config BLK_DEV_DAC960
 
 config BLK_DEV_UMEM
 	tristate "Micro Memory MM5415 Battery Backed RAM support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
@@ -388,7 +388,7 @@ config CDROM_PKTCDVD_BUFFERS
 
 config CDROM_PKTCDVD_WCACHE
 	bool "Enable write caching (EXPERIMENTAL)"
-	depends on CDROM_PKTCDVD && EXPERIMENTAL
+	depends on CDROM_PKTCDVD
 	help
 	  If enabled, write caching will be set for the CD-R/W device. For now
 	  this option is dangerous unless the CD-RW media is known good, as we
@@ -427,7 +427,7 @@ config XEN_BLKDEV_FRONTEND
 
 config VIRTIO_BLK
 	tristate "Virtio block driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	depends on VIRTIO
 	---help---
 	  This is the virtual block driver for lguest.  Say Y or M.
 
diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
index 28cf308..909b2d4 100644
--- a/drivers/block/paride/Kconfig
+++ b/drivers/block/paride/Kconfig
@@ -206,7 +206,7 @@ config PARIDE_EPAT
 
 config PARIDE_EPATC8
 	bool "Support c7/c8 chips (EXPERIMENTAL)"
-	depends on PARIDE_EPAT && EXPERIMENTAL
+	depends on PARIDE_EPAT
 	help
 	  This option enables support for the newer Shuttle EP1284 (aka c7 and
 	  c8) chip. You need this if you are using any recent Imation SuperDisk
diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 075598e..dc0e0de 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -24,7 +24,7 @@ config BT_HCIUSB_SCO
 
 config BT_HCIBTUSB
 	tristate "HCI USB driver (alternate version)"
-	depends on USB && EXPERIMENTAL && BT_HCIUSB=n
+	depends on USB && BT_HCIUSB=n
 	help
 	  Bluetooth HCI USB driver.
 	  This driver is required if you want to use Bluetooth devices with
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index bf18d75..fbc0396 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -146,7 +146,7 @@ config CYCLADES
 
 config CYZ_INTR
 	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && CYCLADES
+	depends on CYCLADES
 	help
 	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
 	  modes: polling and interrupt. In polling mode, the driver will check
@@ -375,7 +375,7 @@ config ISTALLION
 
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
+	depends on ZORRO && BROKEN_ON_SMP
 	---help---
 	  This option supports the 2232 7-port serial card shipped with the
 	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
@@ -882,7 +882,7 @@ config APPLICOM
 
 config SONYPI
 	tristate "Sony Vaio Programmable I/O Control Device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && X86 && PCI && INPUT && !64BIT
+	depends on X86 && PCI && INPUT && !64BIT
 	---help---
 	  This driver enables access to the Sony Programmable I/O Control
 	  Device which can be found in many (all ?) Sony Vaio laptops.
@@ -1043,7 +1043,7 @@ source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
 	tristate "Telecom clock driver for ATCA SBC"
-	depends on EXPERIMENTAL && X86
+	depends on X86
 	default n
 	help
 	  The telecom clock device is specific to the MPCBL0010 and MPCBL0050
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 8f3f762..1d0d75f 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -5,7 +5,6 @@
 menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	---help---
 	  If you have a TPM security chip in your system, which
 	  implements the Trusted Computing Group's specification,
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 98b6b4f..1e176ea 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -7,7 +7,6 @@
 menuconfig EDAC
 	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	depends on X86 || PPC
 	help
 	  EDAC is designed to report errors in the core system.
diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index fe9e768..9a8576b 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,11 +1,7 @@
 # -*- shell-script -*-
 
-comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
-	depends on EXPERIMENTAL=n
-
 config FIREWIRE
 	tristate "IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL"
-	depends on EXPERIMENTAL
 	select CRC_ITU_T
 	help
 	  This is the "Juju" FireWire stack, a new alternative implementation
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index c557d70..c9ec2bf 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -36,7 +36,7 @@ config USB_HIDINPUT_POWERBOOK
 
 config HID_FF
 	bool "Force feedback support (EXPERIMENTAL)"
-	depends on USB_HID && EXPERIMENTAL
+	depends on USB_HID
 	help
 	  Say Y here is you want force feedback support for a few HID devices.
 	  See below for a list of supported devices.
@@ -80,7 +80,7 @@ config PANTHERLORD_FF
 
 config THRUSTMASTER_FF
 	bool "ThrustMaster devices support (EXPERIMENTAL)"
-	depends on HID_FF && EXPERIMENTAL
+	depends on HID_FF
 	select INPUT_FF_MEMLESS if USB_HID
 	help
 	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index a0445be..dff8c49 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -30,7 +30,7 @@ config HWMON_VID
 
 config SENSORS_ABITUGURU
 	tristate "Abit uGuru (rev 1 & 2)"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  If you say yes here you get support for the sensor part of the first
 	  and second revision of the Abit uGuru chip. The voltage and frequency
@@ -45,7 +45,7 @@ config SENSORS_ABITUGURU
 
 config SENSORS_ABITUGURU3
 	tristate "Abit uGuru (rev 3)"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  If you say yes here you get support for the sensor part of the
 	  third revision of the Abit uGuru chip. Only reading the sensors
@@ -59,7 +59,7 @@ config SENSORS_ABITUGURU3
 
 config SENSORS_AD7418
 	tristate "Analog Devices AD7416, AD7417 and AD7418"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  AD7416, AD7417 and AD7418 temperature monitoring chips.
@@ -92,7 +92,7 @@ config SENSORS_ADM1025
 
 config SENSORS_ADM1026
 	tristate "Analog Devices ADM1026 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Analog Devices ADM1026
@@ -103,7 +103,7 @@ config SENSORS_ADM1026
 
 config SENSORS_ADM1029
 	tristate "Analog Devices ADM1029"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM1029
 	  sensor chip.
@@ -114,7 +114,7 @@ config SENSORS_ADM1029
 
 config SENSORS_ADM1031
 	tristate "Analog Devices ADM1031 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM1031
 	  and ADM1030 sensor chips.
@@ -124,7 +124,7 @@ config SENSORS_ADM1031
 
 config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
@@ -135,7 +135,7 @@ config SENSORS_ADM9240
 
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
@@ -145,7 +145,7 @@ config SENSORS_ADT7470
 
 config SENSORS_K8TEMP
 	tristate "AMD Athlon64/FX or Opteron temperature sensor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI
 	help
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported is whole AMD K8
@@ -157,7 +157,7 @@ config SENSORS_K8TEMP
 
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
-	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
+	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C)
 	select INPUT_POLLDEV
 	help
 	  Support for the motion sensor included in PowerBooks. Includes
@@ -183,7 +183,7 @@ config SENSORS_AMS_I2C
 
 config SENSORS_ASB100
 	tristate "Asus ASB100 Bach"
-	depends on X86 && I2C && EXPERIMENTAL
+	depends on X86 && I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the ASB100 Bach sensor
@@ -194,7 +194,7 @@ config SENSORS_ASB100
 
 config SENSORS_ATXP1
 	tristate "Attansic ATXP1 VID controller"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Attansic ATXP1 VID
@@ -218,7 +218,7 @@ config SENSORS_DS1621
 
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes here you get support for FB-DIMM AMB temperature
 	  monitoring chips on systems with the Intel 5000 series chipset.
@@ -228,7 +228,6 @@ config SENSORS_I5K_AMB
 
 config SENSORS_F71805F
 	tristate "Fintek F71805F/FG, F71806F/FG and F71872F/FG"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for hardware monitoring
 	  features of the Fintek F71805F/FG, F71806F/FG and F71872F/FG
@@ -239,7 +238,6 @@ config SENSORS_F71805F
 
 config SENSORS_F71882FG
 	tristate "Fintek F71882FG and F71883FG"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for hardware monitoring
 	  features of the Fintek F71882FG and F71883FG Super-I/O chips.
@@ -249,7 +247,7 @@ config SENSORS_F71882FG
 
 config SENSORS_F75375S
 	tristate "Fintek F75375S/SP and F75373";
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for hardware monitoring
 	  features of the Fintek F75375S/SP and F75373
@@ -279,7 +277,7 @@ config SENSORS_FSCPOS
 
 config SENSORS_FSCHMD
 	tristate "FSC Poseidon, Scylla, Hermes, Heimdall and Heracles"
-	depends on X86 && I2C && EXPERIMENTAL
+	depends on X86 && I2C
 	help
 	  If you say yes here you get support for various Fujitsu Siemens
 	  Computers sensor chips.
@@ -314,7 +312,7 @@ config SENSORS_GL520SM
 
 config SENSORS_CORETEMP
 	tristate "Intel Core (2) Duo/Solo temperature sensor"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Supported all are all known variants
@@ -357,7 +355,7 @@ config SENSORS_LM63
 
 config SENSORS_LM70
 	tristate "National Semiconductor LM70"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LM70 digital temperature sensor chip.
@@ -403,7 +401,7 @@ config SENSORS_LM78
 
 config SENSORS_LM80
 	tristate "National Semiconductor LM80"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor
 	  LM80 sensor chips.
@@ -423,7 +421,7 @@ config SENSORS_LM83
 
 config SENSORS_LM85
 	tristate "National Semiconductor LM85 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for National Semiconductor LM85
@@ -489,7 +487,7 @@ config SENSORS_MAX1619
 
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
@@ -512,7 +510,6 @@ config SENSORS_PC87360
 
 config SENSORS_PC87427
 	tristate "National Semiconductor PC87427"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get access to the hardware monitoring
 	  functions of the National Semiconductor PC87427 Super-I/O chip.
@@ -535,7 +532,7 @@ config SENSORS_SIS5595
 
 config SENSORS_DME1737
 	tristate "SMSC DME1737, SCH311x and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the hardware monitoring
@@ -563,7 +560,7 @@ config SENSORS_SMSC47M1
 
 config SENSORS_SMSC47M192
 	tristate "SMSC LPC47M192 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the temperature and
@@ -580,7 +577,6 @@ config SENSORS_SMSC47M192
 
 config SENSORS_SMSC47B397
 	tristate "SMSC LPC47B397-NC"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the SMSC LPC47B397-NC
 	  sensor chip.
@@ -590,7 +586,7 @@ config SENSORS_SMSC47B397
 
 config SENSORS_THMC50
 	tristate "Texas Instruments THMC50 / Analog Devices ADM1022"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Texas Instruments THMC50
 	  sensor chips and clones: the Analog Devices ADM1022.
@@ -610,7 +606,6 @@ config SENSORS_VIA686A
 
 config SENSORS_VT1211
 	tristate "VIA VT1211"
-	depends on EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here then you get support for hardware monitoring
@@ -644,7 +639,7 @@ config SENSORS_W83781D
 
 config SENSORS_W83791D
 	tristate "Winbond W83791D"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83791D chip.
@@ -654,7 +649,7 @@ config SENSORS_W83791D
 
 config SENSORS_W83792D
 	tristate "Winbond W83792D"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Winbond W83792D chip.
 
@@ -663,7 +658,7 @@ config SENSORS_W83792D
 
 config SENSORS_W83793
 	tristate "Winbond W83793"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83793
@@ -674,7 +669,7 @@ config SENSORS_W83793
 
 config SENSORS_W83L785TS
 	tristate "Winbond W83L785TS-S"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Winbond W83L785TS-S
 	  sensor chip, which is used on the Asus A7N8X, among other
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c466c6c..6fe1cfa 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -18,7 +18,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -52,7 +52,7 @@ config I2C_AMD756
 
 config I2C_AMD756_S4882
 	tristate "SMBus multiplexing on the Tyan S4882"
-	depends on I2C_AMD756 && EXPERIMENTAL
+	depends on I2C_AMD756
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4882 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -75,7 +75,7 @@ config I2C_AMD8111
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
+	depends on ARCH_AT91 && BROKEN
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
@@ -148,7 +148,7 @@ config I2C_GPIO
 
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
-	depends on PCI && PPC_CHRP && EXPERIMENTAL
+	depends on PCI && PPC_CHRP
 	select I2C_ALGOBIT
 	help
 	  This supports the use of the I2C interface in the Apple Hydra Mac
@@ -200,7 +200,7 @@ config I2C_I810
 
 config I2C_PXA
 	tristate "Intel PXA2XX I2C adapter (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ARCH_PXA
+	depends on ARCH_PXA
 	help
 	  If you have devices in the PXA I2C bus, say yes to this option.
 	  This driver can also be built as a module.  If so, the module
@@ -323,7 +323,6 @@ config I2C_NFORCE2
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -419,7 +418,7 @@ config I2C_S3C2410
 
 config I2C_SAVAGE4
 	tristate "S3 Savage 4"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the 
@@ -529,7 +528,6 @@ config I2C_SIS96X
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
 	select SERIO
 	select SERIO_SERPORT
 	default n
@@ -545,7 +543,7 @@ config I2C_TAOS_EVM
 
 config I2C_STUB
 	tristate "I2C/SMBus Test Stub"
-	depends on EXPERIMENTAL && m
+	depends on m
 	default 'n'
 	help
 	  This module may be useful to developers of SMBus client drivers,
@@ -590,7 +588,7 @@ config I2C_ACORN
 
 config I2C_VIA
 	tristate "VIA 82C586B"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -648,7 +646,7 @@ config I2C_PCA_ISA
 
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
-	depends on MV64X60 && EXPERIMENTAL
+	depends on MV64X60
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Marvell 64xxx line of host bridges.
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 2e1c24f..2cc6208 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -6,7 +6,6 @@ menu "Miscellaneous I2C Chip support"
 
 config SENSORS_DS1337
 	tristate "Dallas DS1337 and DS1339 Real Time Clock (DEPRECATED)"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1337 and DS1339 real-time clock chips.
@@ -19,7 +18,6 @@ config SENSORS_DS1337
 
 config SENSORS_DS1374
 	tristate "Dallas DS1374 Real Time Clock (DEPRECATED)"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1374 real-time clock chips.
@@ -32,7 +30,6 @@ config SENSORS_DS1374
 
 config DS1682
 	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1682 Total Elapsed Time Recorder.
@@ -42,7 +39,6 @@ config DS1682
 
 config SENSORS_EEPROM
 	tristate "EEPROM reader"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get read-only access to the EEPROM data
 	  available on modern memory DIMMs and Sony Vaio laptops.  Such
@@ -53,7 +49,6 @@ config SENSORS_EEPROM
 
 config SENSORS_PCF8574
 	tristate "Philips PCF8574 and PCF8574A"
-	depends on EXPERIMENTAL
 	default n
 	help
 	  If you say yes here you get support for Philips PCF8574 and 
@@ -67,7 +62,6 @@ config SENSORS_PCF8574
 
 config SENSORS_PCA9539
 	tristate "Philips PCA9539 16-bit I/O port"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Philips PCA9539
 	  16-bit I/O port.
@@ -77,7 +71,6 @@ config SENSORS_PCA9539
 
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
-	depends on EXPERIMENTAL
 	default n
 	help
 	  If you say yes here you get support for Philips PCF8591 chips.
@@ -130,7 +123,6 @@ config SENSORS_M41T00
 
 config SENSORS_MAX6875
 	tristate "Maxim MAX6875 Power supply supervisor"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Maxim MAX6875
 	  EEPROM-programmable, quad power-supply sequencer/supervisor.
@@ -145,7 +137,6 @@ config SENSORS_MAX6875
 
 config SENSORS_TSL2550
 	tristate "Taos TSL2550 ambient light sensor"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Taos TSL2550
 	  ambient light sensor.
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e445fe6..091a1ec 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -208,7 +208,6 @@ config BLK_DEV_IDECD
 
 config BLK_DEV_IDETAPE
 	tristate "Include IDE/ATAPI TAPE support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  If you have an IDE tape drive using the ATAPI protocol, say Y.
 	  ATAPI is a newer protocol used by IDE tape and CD-ROM drives,
@@ -422,7 +421,6 @@ config BLK_DEV_GENERIC
 
 config BLK_DEV_OPTI621
 	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
@@ -528,7 +526,6 @@ config BLK_DEV_CY82C693
 
 config BLK_DEV_CS5520
 	tristate "Cyrix CS5510/20 MediaGX chipset support (VERY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for PIO tuning and virtual DMA on the Cyrix MediaGX
@@ -569,7 +566,7 @@ config BLK_DEV_HPT34X
 
 config HPT34X_AUTODMA
 	bool "HPT34X AUTODMA support (EXPERIMENTAL)"
-	depends on BLK_DEV_HPT34X && EXPERIMENTAL
+	depends on BLK_DEV_HPT34X
 	help
 	  This is a dangerous thing to attempt currently! Please read the
 	  comments at the top of <file:drivers/ide/pci/hpt34x.c>.  If you say Y
@@ -901,7 +898,7 @@ config BLK_DEV_GAYLE
 
 config BLK_DEV_IDEDOUBLER
 	bool "Amiga IDE Doubler support (EXPERIMENTAL)"
-	depends on BLK_DEV_GAYLE && EXPERIMENTAL
+	depends on BLK_DEV_GAYLE
 	---help---
 	  This driver provides support for the so-called `IDE doublers' (made
 	  by various manufacturers, e.g. Eyetech) that can be connected to the
@@ -917,7 +914,7 @@ config BLK_DEV_IDEDOUBLER
 
 config BLK_DEV_BUDDHA
 	bool "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
+	depends on ZORRO
 	select IDE_GENERIC
 	help
 	  This is the IDE driver for the IDE interfaces on the Buddha, 
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index 545663e..99712b1 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -97,7 +97,7 @@ config IEEE1394_SBP2
 
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
-	depends on IEEE1394_SBP2 && VIRT_TO_BUS && EXPERIMENTAL
+	depends on IEEE1394_SBP2 && VIRT_TO_BUS
 	help
 	  This builds sbp2 for use with non-OHCI host adapters which do not
 	  support physical DMA or for when ohci1394 is run with phys_dma=0.
@@ -115,7 +115,7 @@ config IEEE1394_ETH1394_ROM_ENTRY
 
 config IEEE1394_ETH1394
 	tristate "IP over 1394"
-	depends on IEEE1394 && EXPERIMENTAL && INET
+	depends on IEEE1394 && INET
 	select IEEE1394_ETH1394_ROM_ENTRY
 	help
 	  This driver implements a functional majority of RFC 2734: IPv4 over
diff --git a/drivers/infiniband/ulp/ipoib/Kconfig b/drivers/infiniband/ulp/ipoib/Kconfig
index 1f76bad..e1b1988 100644
--- a/drivers/infiniband/ulp/ipoib/Kconfig
+++ b/drivers/infiniband/ulp/ipoib/Kconfig
@@ -10,7 +10,7 @@ config INFINIBAND_IPOIB
 
 config INFINIBAND_IPOIB_CM
 	bool "IP-over-InfiniBand Connected Mode support"
-	depends on INFINIBAND_IPOIB && EXPERIMENTAL
+	depends on INFINIBAND_IPOIB
 	default n
 	---help---
 	  This option enables experimental support for IPoIB connected mode.
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 8f5c7b9..8d2838a 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -120,7 +120,6 @@ config INPUT_ATI_REMOTE2
 
 config INPUT_KEYSPAN_REMOTE
 	tristate "Keyspan DMR USB remote control (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -152,7 +151,6 @@ config INPUT_POWERMATE
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index e1afd60..0bd7cbc 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -21,7 +21,6 @@ config CAPI_TRACE
 
 config ISDN_CAPI_MIDDLEWARE
 	bool "CAPI2.0 Middleware support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 7832d8b..ca4793a 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -390,7 +390,7 @@ comment "HiSax sub driver modules"
 
 config HISAX_ST5481
 	tristate "ST5481 USB ISDN modem (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	select CRC_CCITT
 	select BITREVERSE
 	help
@@ -399,19 +399,18 @@ config HISAX_ST5481
 
 config HISAX_HFCUSB
 	tristate "HFC USB based ISDN modems (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  This enables the driver for HFC USB based ISDN modems.
 
 config HISAX_HFC4S8S
 	tristate "HFC-4S/8S based ISDN cards (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This enables the driver for HFC-4S/8S based ISDN cards.
 
 config HISAX_FRITZ_PCIPNP
 	tristate "AVM Fritz!Card PCI/PCIv2/PnP support (EXPERIMENTAL)"
-	depends on PCI && PCI_LEGACY && EXPERIMENTAL
+	depends on PCI && PCI_LEGACY
 	help
 	  This enables the driver for the AVM Fritz!Card PCI,
 	  Fritz!Card PCI v2 and Fritz!Card PnP.
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6569206..6ccd7fe 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -16,7 +16,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 7eb9ecf..1d38368 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_32 && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9b6fbf0..5a2404f 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -87,7 +87,7 @@ config MD_RAID1
 
 config MD_RAID10
 	tristate "RAID-10 (mirrored striping) mode (EXPERIMENTAL)"
-	depends on BLK_DEV_MD && EXPERIMENTAL
+	depends on BLK_DEV_MD
 	---help---
 	  RAID-10 provides a combination of striping (RAID-0) and
 	  mirroring (RAID-1) with easier configuration and more flexible
@@ -204,7 +204,7 @@ config BLK_DEV_DM
 
 config DM_DEBUG
 	boolean "Device mapper debugging support"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	---help---
 	  Enable this for messages that may help debug device-mapper problems.
 
@@ -212,7 +212,7 @@ config DM_DEBUG
 
 config DM_CRYPT
 	tristate "Crypt target support"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_CBC
 	---help---
@@ -231,51 +231,51 @@ config DM_CRYPT
 
 config DM_SNAPSHOT
        tristate "Snapshot target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        ---help---
          Allow volume managers to take writable snapshots of a device.
 
 config DM_MIRROR
        tristate "Mirror target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        ---help---
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
 config DM_ZERO
 	tristate "Zero target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	---help---
 	  A target that discards writes, and returns all zeroes for
 	  reads.  Useful in some recovery situations.
 
 config DM_MULTIPATH
 	tristate "Multipath target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	---help---
 	  Allow volume managers to support multipath hardware.
 
 config DM_MULTIPATH_EMC
 	tristate "EMC CX/AX multipath support (EXPERIMENTAL)"
-	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	depends on DM_MULTIPATH && BLK_DEV_DM
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
 config DM_MULTIPATH_RDAC
 	tristate "LSI/Engenio RDAC multipath support (EXPERIMENTAL)"
-	depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
+	depends on DM_MULTIPATH && BLK_DEV_DM && SCSI
 	---help---
 	  Multipath support for LSI/Engenio RDAC.
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
 config DM_DELAY
 	tristate "I/O delaying target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	---help---
 	A target that delays reads and/or writes and can send
 	them to different devices.  Useful for testing.
@@ -284,7 +284,7 @@ config DM_DELAY
 
 config DM_UEVENT
 	bool "DM uevents (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	depends on BLK_DEV_DM
 	---help---
 	Generate udev events for DM events.
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 1604f04..7548109 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -105,7 +105,7 @@ config TUNER_TDA8290
 
 config TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index d73934d..0863110 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -225,7 +225,7 @@ config DVB_USB_OPERA1
 
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
-	depends on DVB_USB && EXPERIMENTAL
+	depends on DVB_USB
 	select DVB_TUNER_MT2060 if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_QT1010 if !DVB_FE_CUSTOMISE
 	help
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c9f14bf..4094e45 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -111,7 +111,7 @@ config VIDEO_MSP3400
 
 config VIDEO_CS53L32A
 	tristate "Cirrus Logic CS53L32A audio ADC"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Cirrus Logic CS53L32A low voltage
 	  stereo A/D converter.
@@ -121,7 +121,7 @@ config VIDEO_CS53L32A
 
 config VIDEO_TLV320AIC23B
 	tristate "Texas Instruments TLV320AIC23B audio codec"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Texas Instruments TLV320AIC23B audio codec.
 
@@ -130,7 +130,7 @@ config VIDEO_TLV320AIC23B
 
 config VIDEO_WM8775
 	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Wolfson Microelectronics WM8775 high
 	  performance stereo A/D Converter with a 4 channel input mixer.
@@ -140,7 +140,7 @@ config VIDEO_WM8775
 
 config VIDEO_WM8739
 	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Wolfson Microelectronics WM8739
 	  stereo A/D Converter.
@@ -150,7 +150,7 @@ config VIDEO_WM8739
 
 config VIDEO_VP27SMPX
 	tristate "Panasonic VP27s internal MPX"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the internal MPX of the Panasonic VP27s tuner.
 
@@ -244,7 +244,7 @@ config VIDEO_SAA7114
 
 config VIDEO_SAA711X
 	tristate "Philips SAA7113/4/5 video decoders"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Philips SAA7113/4/5 video decoders.
 
@@ -286,7 +286,7 @@ comment "MPEG video encoders"
 
 config VIDEO_CX2341X
 	tristate "Conexant CX2341x MPEG encoders"
-	depends on VIDEO_V4L2 && EXPERIMENTAL
+	depends on VIDEO_V4L2
 	---help---
 	  Support for the Conexant CX23416 MPEG encoders
 	  and CX23415 MPEG encoder/decoders.
@@ -300,7 +300,7 @@ comment "Video encoders"
 
 config VIDEO_SAA7127
 	tristate "Philips SAA7127/9 digital video encoders"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Philips SAA7127/9 digital video encoders.
 
@@ -338,7 +338,7 @@ comment "Video improvement chips"
 
 config VIDEO_UPD64031A
 	tristate "NEC Electronics uPD64031A Ghost Reduction"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the NEC Electronics uPD64031A Ghost Reduction
 	  video chip. It is most often found in NTSC TV cards made for
@@ -350,7 +350,7 @@ config VIDEO_UPD64031A
 
 config VIDEO_UPD64083
 	tristate "NEC Electronics uPD64083 3-Dimensional Y/C separation"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the NEC Electronics uPD64083 3-Dimensional Y/C
 	  separation video chip. It is used to improve the quality of
@@ -419,7 +419,7 @@ config VIDEO_BWQCAM
 
 config VIDEO_CQCAM
 	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L1
+	depends on PARPORT && VIDEO_V4L1
 	help
 	  This is the video4linux driver for the colour version of the
 	  Connectix QuickCam.  If you have one of these cameras, say Y here,
@@ -507,7 +507,7 @@ config TUNER_3036
 
 config VIDEO_VINO
 	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
-	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
+	depends on I2C && SGI_IP22 && VIDEO_V4L2
 	select I2C_ALGO_SGI
 	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
 	help
@@ -516,7 +516,7 @@ config VIDEO_VINO
 
 config VIDEO_STRADIS
 	tristate "Stradis 4:2:2 MPEG-2 video driver  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && VIRT_TO_BUS
+	depends on PCI && VIDEO_V4L1 && VIRT_TO_BUS
 	help
 	  Say Y here to enable support for the Stradis 4:2:2 MPEG-2 video
 	  driver for PCI.  There is a product page at
@@ -589,7 +589,7 @@ config VIDEO_ZORAN_LML33R10
 
 config VIDEO_ZORAN_AVS6EYES
 	tristate "AverMedia 6 Eyes support (EXPERIMENTAL)"
-	depends on VIDEO_ZORAN && EXPERIMENTAL && VIDEO_V4L1
+	depends on VIDEO_ZORAN && VIDEO_V4L1
 	select VIDEO_BT856 if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_KS0127 if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_ZORAN_ZR36060
diff --git a/drivers/media/video/cx25840/Kconfig b/drivers/media/video/cx25840/Kconfig
index 7cf29a0..8381f09 100644
--- a/drivers/media/video/cx25840/Kconfig
+++ b/drivers/media/video/cx25840/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX25840
 	tristate "Conexant CX2584x audio/video decoders"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	select FW_LOADER
 	---help---
 	  Support for the Conexant CX2584x audio/video decoders.
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index ceb31d4..cd86939 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -17,7 +17,7 @@ config VIDEO_CX88
 
 config VIDEO_CX88_ALSA
 	tristate "Conexant 2388x DMA audio support"
-	depends on VIDEO_CX88 && SND && EXPERIMENTAL
+	depends on VIDEO_CX88 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index 854cc9c..4d796d4 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
-	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_TUNER
@@ -29,7 +29,7 @@ config VIDEO_IVTV
 
 config VIDEO_FB_IVTV
 	tristate "Conexant cx23415 framebuffer support"
-	depends on VIDEO_IVTV && FB && EXPERIMENTAL
+	depends on VIDEO_IVTV && FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/media/video/pvrusb2/Kconfig b/drivers/media/video/pvrusb2/Kconfig
index d0c2cd7..a5e6ca9 100644
--- a/drivers/media/video/pvrusb2/Kconfig
+++ b/drivers/media/video/pvrusb2/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
@@ -14,7 +14,7 @@ config VIDEO_PVRUSB2
 
 config VIDEO_PVRUSB2_29XXX
 	bool "Hauppauge WinTV-PVR USB2 support for 29xxx model series"
-	depends on VIDEO_PVRUSB2 && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2
 	select VIDEO_SAA711X
 	select VIDEO_MSP3400
 	---help---
@@ -28,7 +28,7 @@ config VIDEO_PVRUSB2_29XXX
 
 config VIDEO_PVRUSB2_24XXX
 	bool "Hauppauge WinTV-PVR USB2 support for 24xxx model series"
-	depends on VIDEO_PVRUSB2 && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2
 	select VIDEO_CX25840
 	select VIDEO_WM8775
 	---help---
@@ -44,7 +44,7 @@ config VIDEO_PVRUSB2_24XXX
 config VIDEO_PVRUSB2_SYSFS
 	bool "pvrusb2 sysfs support (EXPERIMENTAL)"
 	default y
-	depends on VIDEO_PVRUSB2 && SYSFS && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2 && SYSFS
 	---help---
 	  This option enables the operation of a sysfs based
 	  interface for query and control of the pvrusb2 driver.
diff --git a/drivers/media/video/usbvideo/Kconfig b/drivers/media/video/usbvideo/Kconfig
index e4cb99c..28c45ea 100644
--- a/drivers/media/video/usbvideo/Kconfig
+++ b/drivers/media/video/usbvideo/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_USBVIDEO
 
 config USB_VICAM
 	tristate "USB 3com HomeConnect (aka vicam) support (EXPERIMENTAL)"
-	depends on VIDEO_V4L1 && EXPERIMENTAL
+	depends on VIDEO_V4L1
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you have 3com homeconnect camera (vicam).
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b5e67c0..a496313 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -15,7 +15,7 @@ if MISC_DEVICES
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
-	depends on X86 && PCI && INPUT && EXPERIMENTAL
+	depends on X86 && PCI && INPUT
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
@@ -65,7 +65,7 @@ config SGI_IOC4
 
 config TIFM_CORE
 	tristate "TI Flash Media interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	depends on PCI
 	help
 	  If you want support for Texas Instruments(R) Flash Media adapters
 	  you should select this option and then also choose an appropriate
@@ -81,7 +81,7 @@ config TIFM_CORE
 
 config TIFM_7XX1
 	tristate "TI Flash Media PCI74xx/PCI76xx host adapter support (EXPERIMENTAL)"
-	depends on PCI && TIFM_CORE && EXPERIMENTAL
+	depends on PCI && TIFM_CORE
 	default TIFM_CORE
 	help
 	  This option enables support for Texas Instruments(R) PCI74xx and
@@ -96,7 +96,7 @@ config ASUS_LAPTOP
         tristate "Asus Laptop Extras (EXPERIMENTAL)"
         depends on X86
         depends on ACPI
-	depends on EXPERIMENTAL && !ACPI_ASUS
+	depends on !ACPI_ASUS
 	depends on LEDS_CLASS
 	depends on BACKLIGHT_CLASS_DEVICE
         ---help---
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 5fef678..be28f6a 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -26,7 +26,7 @@ config MMC_PXA
 
 config MMC_SDHCI
 	tristate "Secure Digital Host Controller Interface support  (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This select the generic Secure Digital Host Controller Interface.
 	  It is used by manufacturers such as Texas Instruments(R), Ricoh(R)
@@ -37,7 +37,7 @@ config MMC_SDHCI
 
 config MMC_RICOH_MMC
 	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL && MMC_SDHCI
+	depends on PCI && MMC_SDHCI
 	help
 	  This selects the disabler for the Ricoh MMC Controller. This
 	  proprietary controller is unnecessary because the SDHCI driver
@@ -103,7 +103,7 @@ config MMC_IMX
 
 config MMC_TIFM_SD
 	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	depends on PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
@@ -119,7 +119,7 @@ config MMC_TIFM_SD
 
 config MMC_SPI
 	tristate "MMC/SD over SPI (EXPERIMENTAL)"
-	depends on MMC && SPI_MASTER && !HIGHMEM && EXPERIMENTAL
+	depends on MMC && SPI_MASTER && !HIGHMEM
 	select CRC7
 	select CRC_ITU_T
 	help
diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index 479d32b..f531f22 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -232,7 +232,7 @@ config MTD_ABSENT
 
 config MTD_XIP
 	bool "XIP aware MTD support"
-	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && EXPERIMENTAL && ARCH_MTD_XIP
+	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && ARCH_MTD_XIP
 	default y if XIP_KERNEL
 	help
 	  This allows MTD support to work with flash memory which is also
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 811d56f..5e20697 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -54,7 +54,7 @@ config MTD_MS02NV
 
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to AT45xxx DataFlash chips, using SPI.
 	  Sometimes DataFlash chips are packaged inside MMC-format
@@ -62,7 +62,7 @@ config MTD_DATAFLASH
 
 config MTD_M25P80
 	tristate "Support most SPI Flash chips (AT26DF, M25P, W25X, ...)"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to most modern SPI flash chips, used for
 	  program and data storage.   Series supported include Atmel AT26DF,
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 246d451..32eb6a9 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -170,7 +170,6 @@ config MTD_NAND_S3C2410_CLKSTOP
 
 config MTD_NAND_DISKONCHIP
 	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC16
 	help
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index e8d69b0..3e447b5 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -85,7 +85,6 @@ config BONDING
 
 config MACVLAN
 	tristate "MAC-VLAN support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	  This allows one to create virtual interfaces that map packets to
 	  or from specific MAC addresses to a particular interface.
@@ -168,7 +167,7 @@ config NET_SB1000
 
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select MII
 	---help---
 	  This driver supports IP1000 gigabit Ethernet cards.
@@ -550,7 +549,7 @@ config HAPPYMEAL
 
 config SUNBMAC
 	tristate "Sun BigMAC 10/100baseT support (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	depends on SBUS
 	select CRC32
 	help
 	  This driver supports the "be" interface available as an Sbus option.
@@ -646,7 +645,7 @@ config ELPLUS
 
 config EL16
 	tristate "3c507 \"EtherLink 16\" support (EXPERIMENTAL)"
-	depends on NET_VENDOR_3COM && ISA && EXPERIMENTAL
+	depends on NET_VENDOR_3COM && ISA
 	help
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
@@ -864,7 +863,7 @@ config BFIN_RX_DESC_NUM
 
 config BFIN_MAC_RMII
 	bool "RMII PHY Interface (EXPERIMENTAL)"
-	depends on BFIN_MAC && EXPERIMENTAL
+	depends on BFIN_MAC
 	default n
 	help
 	  Use Reduced PHY MII Interface
@@ -953,7 +952,7 @@ config NET_VENDOR_RACAL
 
 config NI5010
 	tristate "NI5010 support (EXPERIMENTAL)"
-	depends on NET_VENDOR_RACAL && ISA && EXPERIMENTAL && BROKEN_ON_SMP
+	depends on NET_VENDOR_RACAL && ISA && BROKEN_ON_SMP
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
@@ -989,7 +988,7 @@ source "drivers/net/tulip/Kconfig"
 
 config AT1700
 	tristate "AT1700/1720 support (EXPERIMENTAL)"
-	depends on (ISA || MCA_LEGACY) && EXPERIMENTAL
+	depends on ISA || MCA_LEGACY
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -1158,7 +1157,7 @@ config NE2000
 
 config ZNET
 	tristate "Zenith Z-Note support (EXPERIMENTAL)"
-	depends on NET_ISA && EXPERIMENTAL && ISA_DMA_API
+	depends on NET_ISA && ISA_DMA_API
 	help
 	  The Zenith Z-Note notebook computer has a built-in network
 	  (Ethernet) card, and this is the Linux driver for it. Note that the
@@ -1168,7 +1167,7 @@ config ZNET
 
 config SEEQ8005
 	tristate "SEEQ8005 support (EXPERIMENTAL)"
-	depends on NET_ISA && EXPERIMENTAL
+	depends on NET_ISA
 	help
 	  This is a driver for the SEEQ 8005 network (Ethernet) card.  If this
 	  is for you, read the Ethernet-HOWTO, available from
@@ -1301,7 +1300,7 @@ config ADAPTEC_STARFIRE
 
 config ADAPTEC_STARFIRE_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
-	depends on ADAPTEC_STARFIRE && EXPERIMENTAL
+	depends on ADAPTEC_STARFIRE
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -1315,7 +1314,7 @@ config ADAPTEC_STARFIRE_NAPI
 
 config AC3200
 	tristate "Ansel Communications EISA 3200 support (EXPERIMENTAL)"
-	depends on NET_PCI && (ISA || EISA) && EXPERIMENTAL
+	depends on NET_PCI && (ISA || EISA)
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -1381,7 +1380,7 @@ config FORCEDETH
 
 config FORCEDETH_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
-	depends on FORCEDETH && EXPERIMENTAL
+	depends on FORCEDETH
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -1452,7 +1451,7 @@ config E100
 
 config LNE390
 	tristate "Mylex EISA LNE390A/B support (EXPERIMENTAL)"
-	depends on NET_PCI && EISA && EXPERIMENTAL
+	depends on NET_PCI && EISA
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -1504,7 +1503,7 @@ config NE2K_PCI
 
 config NE3210
 	tristate "Novell/Eagle/Microdyne NE3210 EISA support (EXPERIMENTAL)"
-	depends on NET_PCI && EISA && EXPERIMENTAL
+	depends on NET_PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -1517,7 +1516,7 @@ config NE3210
 
 config ES3210
 	tristate "Racal-Interlan EISA ES3210 support (EXPERIMENTAL)"
-	depends on NET_PCI && EISA && EXPERIMENTAL
+	depends on NET_PCI && EISA
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -1529,7 +1528,7 @@ config ES3210
 
 config 8139CP
 	tristate "RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support (EXPERIMENTAL)"
-	depends on NET_PCI && PCI && EXPERIMENTAL
+	depends on NET_PCI && PCI
 	select CRC32
 	select MII
 	help
@@ -1705,7 +1704,7 @@ config LAN_SAA9730
 
 config SC92031
 	tristate "Silan SC92031 PCI Fast Ethernet Adapter driver (EXPERIMENTAL)"
-	depends on NET_PCI && PCI && EXPERIMENTAL
+	depends on NET_PCI && PCI
 	select CRC32
 	---help---
 	  This is a driver for the Fast Ethernet PCI network cards based on
@@ -1717,7 +1716,7 @@ config SC92031
 
 config CPMAC
 	tristate "TI AR7 CPMAC Ethernet support (EXPERIMENTAL)"
-	depends on NET_ETHERNET && EXPERIMENTAL && AR7
+	depends on NET_ETHERNET && AR7
 	select PHYLIB
 	select FIXED_PHY
 	select FIXED_MII_100_FDX
@@ -2027,7 +2026,7 @@ config HAMACHI
 
 config YELLOWFIN
 	tristate "Packet Engines Yellowfin Gigabit-NIC support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select CRC32
 	---help---
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
@@ -2051,7 +2050,7 @@ config R8169
 
 config R8169_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
-	depends on R8169 && EXPERIMENTAL
+	depends on R8169
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -2362,7 +2361,7 @@ config QLA3XXX
 
 config ATL1
 	tristate "Attansic L1 Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select CRC32
 	select MII
 	help
@@ -2498,7 +2497,7 @@ config IXGB
 
 config IXGB_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
-	depends on IXGB && EXPERIMENTAL
+	depends on IXGB
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -2520,7 +2519,7 @@ config S2IO
 
 config S2IO_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
-	depends on S2IO && EXPERIMENTAL
+	depends on S2IO
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -2709,7 +2708,7 @@ config SKFP
 
 config HIPPI
 	bool "HIPPI driver support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET && PCI
+	depends on INET && PCI
 	help
 	  HIgh Performance Parallel Interface (HIPPI) is a 800Mbit/sec and
 	  1600Mbit/sec dual-simplex switched or point-to-point network. HIPPI
@@ -2806,7 +2805,7 @@ config PPP
 
 config PPP_MULTILINK
 	bool "PPP multilink support (EXPERIMENTAL)"
-	depends on PPP && EXPERIMENTAL
+	depends on PPP
 	help
 	  PPP multilink is a protocol (defined in RFC 1990) which allows you
 	  to combine several (logical or physical) lines into one logical PPP
@@ -2890,7 +2889,7 @@ config PPP_BSDCOMP
 
 config PPP_MPPE
        tristate "PPP MPPE compression (encryption) (EXPERIMENTAL)"
-       depends on PPP && EXPERIMENTAL
+       depends on PPP
        select CRYPTO
        select CRYPTO_SHA1
        select CRYPTO_ARC4
@@ -2904,7 +2903,7 @@ config PPP_MPPE
 
 config PPPOE
 	tristate "PPP over Ethernet (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP
+	depends on PPP
 	help
 	  Support for PPP over Ethernet.
 
@@ -2925,7 +2924,7 @@ config PPPOATM
 
 config PPPOL2TP
 	tristate "PPP over L2TP (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP && INET
+	depends on PPP && INET
 	help
 	  Support for PPP-over-L2TP socket family. L2TP is a protocol
 	  used by ISPs and enterprises to tunnel PPP traffic over UDP
@@ -3023,7 +3022,6 @@ config NET_FC
 
 config SHAPER
 	tristate "Traffic Shaper (OBSOLETE)"
-	depends on EXPERIMENTAL
 	---help---
 	  The traffic shaper is a virtual network device that allows you to
 	  limit the rate of outgoing data flow over some other network device.
@@ -3040,14 +3038,13 @@ config SHAPER
 
 config NETCONSOLE
 	tristate "Network console logging support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets (EXPERIMENTAL)"
-	depends on NETCONSOLE && SYSFS && EXPERIMENTAL
+	depends on NETCONSOLE && SYSFS
 	select CONFIGFS_FS
 	help
 	  This option enables the ability to dynamically reconfigure target
@@ -3068,7 +3065,7 @@ config NET_POLL_CONTROLLER
 
 config VIRTIO_NET
 	tristate "Virtio network driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	depends on VIRTIO
 	---help---
 	  This is the virtual network driver for lguest.  Say Y or M.
 
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 6580695..b857a18 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -85,7 +85,7 @@ config LITELINK_DONGLE
 
 config MA600_DONGLE
 	tristate "Mobile Action MA600 dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Mobile Action MA600
 	  dongle.  To compile it as a module, choose M here. The MA600 dongle
@@ -98,7 +98,7 @@ config MA600_DONGLE
 
 config GIRBIL_DONGLE
 	tristate "Greenwich GIrBIL dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Greenwich GIrBIL
 	  dongle.  If you want to compile it as a module, choose M here.
@@ -109,7 +109,7 @@ config GIRBIL_DONGLE
 
 config MCP2120_DONGLE
 	tristate "Microchip MCP2120"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Microchip MCP2120
 	  dongle.  If you want to compile it as a module, choose M here.
@@ -123,7 +123,7 @@ config MCP2120_DONGLE
 
 config OLD_BELKIN_DONGLE
 	tristate "Old Belkin dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Adaptec Airport 1000
 	  and 2000 dongles.  If you want to compile it as a module, choose
@@ -132,7 +132,7 @@ config OLD_BELKIN_DONGLE
 
 config ACT200L_DONGLE
 	tristate "ACTiSYS IR-200L dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the ACTiSYS IR-200L
 	  dongle. If you want to compile it as a module, choose M here.
@@ -143,7 +143,7 @@ config ACT200L_DONGLE
 
 config KINGSUN_DONGLE
 	tristate "KingSun/DonShine DS-620 IrDA-USB dongle"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun/DonShine
 	  DS-620 IrDA-USB bridge device driver.
@@ -157,14 +157,14 @@ config KINGSUN_DONGLE
 
 config EP7211_DONGLE
 	tristate "EP7211 I/R support"
-	depends on IRTTY_SIR && ARCH_EP7211 && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && ARCH_EP7211 && IRDA
 	help
 	  Say Y here if you want to build support for the Cirrus logic
 	  EP7211 chipset's infrared module.
 
 config KSDAZZLE_DONGLE
 	tristate "KingSun Dazzle IrDA-USB dongle (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun Dazzle
 	  IrDA-USB bridge device driver.
@@ -178,7 +178,7 @@ config KSDAZZLE_DONGLE
 
 config KS959_DONGLE
 	tristate "KingSun KS-959 IrDA-USB dongle (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun KS-959
 	  IrDA-USB bridge device driver.
@@ -302,7 +302,7 @@ config OLD_BELKIN_DONGLE_OLD
 
 config ACT200L_DONGLE_OLD
 	tristate "ACTiSYS IR-200L dongle (EXPERIMENTAL)"
-	depends on DONGLE_OLD && EXPERIMENTAL && IRDA
+	depends on DONGLE_OLD && IRDA
 	help
 	  Say Y here if you want to build support for the ACTiSYS IR-200L
 	  dongle.  To compile it as a module, choose M here.  The ACTiSYS
@@ -313,7 +313,7 @@ config ACT200L_DONGLE_OLD
 
 config MA600_DONGLE_OLD
 	tristate "Mobile Action MA600 dongle (EXPERIMENTAL)"
-	depends on DONGLE_OLD && EXPERIMENTAL && IRDA
+	depends on DONGLE_OLD && IRDA
 	---help---
 	  Say Y here if you want to build support for the Mobile Action MA600
 	  dongle.  To compile it as a module, choose M here. The MA600 dongle
@@ -351,7 +351,7 @@ config USB_IRDA
 
 config SIGMATEL_FIR
 	tristate "SigmaTel STIr4200 bridge (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	select CRC32
 	---help---
 	  Say Y here if you want to build support for the SigmaTel STIr4200
@@ -404,7 +404,7 @@ config AU1000_FIR
 
 config SMC_IRCC_FIR
 	tristate "SMSC IrCC (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IRDA && ISA_DMA_API
+	depends on IRDA && ISA_DMA_API
 	help
 	  Say Y here if you want to build support for the SMC Infrared
 	  Communications Controller.  It is used in a wide variety of
@@ -414,7 +414,7 @@ config SMC_IRCC_FIR
 
 config ALI_FIR
 	tristate "ALi M5123 FIR (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IRDA && ISA_DMA_API
+	depends on IRDA && ISA_DMA_API
 	help
 	  Say Y here if you want to build support for the ALi M5123 FIR
 	  Controller.  The ALi M5123 FIR Controller is embedded in ALi M1543C,
@@ -426,7 +426,7 @@ config ALI_FIR
 
 config VLSI_FIR
 	tristate "VLSI 82C147 SIR/MIR/FIR (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IRDA && PCI
+	depends on IRDA && PCI
 	help
 	  Say Y here if you want to build support for the VLSI 82C147
 	  PCI-IrDA Controller. This controller is used by the HP OmniBook 800
@@ -469,7 +469,7 @@ config PXA_FICP
 
 config MCS_FIR
 	tristate "MosChip MCS7780 IrDA-USB dongle"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the MosChip
 	  MCS7780 IrDA-USB bridge device driver.
diff --git a/drivers/net/tulip/Kconfig b/drivers/net/tulip/Kconfig
index 20ac150..b329a4b 100644
--- a/drivers/net/tulip/Kconfig
+++ b/drivers/net/tulip/Kconfig
@@ -12,7 +12,7 @@ if NET_TULIP
 
 config DE2104X
 	tristate "Early DECchip Tulip (dc2104x) PCI support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select CRC32
 	---help---
 	  This driver is developed for the SMC EtherPower series Ethernet
@@ -46,7 +46,7 @@ config TULIP
 
 config TULIP_MWI
 	bool "New bus configuration (EXPERIMENTAL)"
-	depends on TULIP && EXPERIMENTAL
+	depends on TULIP
 	help
 	  This configures your Tulip card specifically for the card and
 	  system cache line size type you are using.
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index a12c9c4..488c3aa 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -9,7 +9,6 @@ menu "USB Network Adapters"
 
 config USB_CATC
 	tristate "USB CATC NetMate-based Ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select CRC32
 	---help---
 	  Say Y if you want to use one of the following 10Mbps USB Ethernet
@@ -83,7 +82,6 @@ config USB_PEGASUS
 
 config USB_RTL8150
 	tristate "USB RTL8150 based ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select MII
 	help
 	  Say Y here if you have RTL8150 based usb-ethernet adapter.
@@ -209,9 +207,7 @@ config USB_NET_NET1080
 
 config USB_NET_PLUSB
 	tristate "Prolific PL-2301/2302 based cables"
-	# if the handshake/init/reset problems, from original 'plusb',
-	# are ever resolved ... then remove "experimental"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
@@ -226,7 +222,7 @@ config USB_NET_MCS7830
 
 config USB_NET_RNDIS_HOST
 	tristate "Host for RNDIS and ActiveSync devices (EXPERIMENTAL)"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	select USB_NET_CDCETHER
 	help
 	  This option enables hosting "Remote NDIS" USB networking links,
@@ -304,7 +300,7 @@ config USB_EPSON2888
 
 config USB_KC2190
 	boolean "KT Technology KC2190 based cables (InstaNet)"
-	depends on USB_NET_CDC_SUBSET && EXPERIMENTAL
+	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 2b733c5..a03c535 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -246,7 +246,7 @@ config IPW2200_PROMISCUOUS
 
 config IPW2200_QOS
         bool "Enable QoS support"
-        depends on IPW2200 && EXPERIMENTAL
+        depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
@@ -277,7 +277,7 @@ config LIBERTAS_USB
 
 config LIBERTAS_CS
 	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA && EXPERIMENTAL
+	depends on LIBERTAS && PCMCIA
 	select FW_LOADER
 	---help---
 	  A driver for Marvell Libertas 8385 CompactFlash devices.
@@ -472,7 +472,7 @@ config AIRO_CS
 
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+      depends on PCMCIA && WLAN_80211
       select WIRELESS_EXT
        ---help---
          A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
@@ -481,7 +481,7 @@ config PCMCIA_WL3501
 
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus' 
-	depends on PCI && EXPERIMENTAL && WLAN_80211
+	depends on PCI && WLAN_80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
@@ -546,7 +546,7 @@ config USB_ZD1201
 
 config RTL8187
 	tristate "Realtek 8187 USB support"
-	depends on MAC80211 && USB && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && USB && WLAN_80211
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8187 based cards.
@@ -558,7 +558,7 @@ config RTL8187
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && WLAN_80211
 	select CRC32
 	select EEPROM_93CX6
 	---help---
@@ -585,7 +585,7 @@ config ADM8211
 
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && FW_LOADER
 
 config P54_USB
 	tristate "Prism54 USB support"
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index fdbc351..4817788 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -43,7 +43,7 @@ config B43_PCICORE_AUTOSELECT
 
 config B43_PCMCIA
 	bool "Broadcom 43xx PCMCIA device support (EXPERIMENTAL)"
-	depends on B43 && SSB_PCMCIAHOST_POSSIBLE && EXPERIMENTAL
+	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
 	select SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.
diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index ce397e4..c2b3cad 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,6 +1,6 @@
 config BCM43XX
 	tristate "Broadcom BCM43xx wireless support"
-	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 8d52a26..e8b1576 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,6 +1,6 @@
 config IWLWIFI
 	bool "Intel Wireless WiFi Link Drivers"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && MAC80211 && WLAN_80211
 	select FW_LOADER
 	default n
 	---help---
@@ -64,7 +64,6 @@ config IWLWIFI_QOS
 
 config IWLWIFI_HT
 	bool "Enable 802.11n HT features in iwlwifi drivers"
-	depends on EXPERIMENTAL
 	depends on IWLWIFI && MAC80211_HT
 	default n
 	---help---
@@ -73,7 +72,7 @@ config IWLWIFI_HT
 
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
-	depends on m && IWLWIFI && EXPERIMENTAL
+	depends on m && IWLWIFI
 	default m
 	---help---
 	  Select to build the driver supporting the:
@@ -101,7 +100,7 @@ config IWL4965
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
-	depends on m && IWLWIFI && EXPERIMENTAL
+	depends on m && IWLWIFI
 	default m
 	---help---
 	  Select to build the driver supporting the:
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index da05b1f..c94f8b8 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,6 +1,6 @@
 config RT2X00
 	tristate "Ralink driver support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211
 	---help---
 	  This will enable the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index d1ab24a..fabb8ad 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -1,6 +1,6 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+	depends on USB && IEEE80211_SOFTMAC && WLAN_80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index d449b15..fb71218 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -57,7 +57,7 @@ config PARPORT_SERIAL
 
 config PARPORT_PC_FIFO
 	bool "Use FIFO/DMA if available (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	depends on PARPORT_PC
 	help
 	  Many parallel port chipsets provide hardware that can speed up
 	  printing. Say Y here if you want to take advantage of that.
@@ -70,7 +70,7 @@ config PARPORT_PC_FIFO
 
 config PARPORT_PC_SUPERIO
 	bool "SuperIO chipset support (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	depends on PARPORT_PC
 	help
 	  Saying Y here enables some probes for Super-IO chipsets in order to
 	  find out things like base addresses, IRQ lines and DMA channels.  It
@@ -85,7 +85,7 @@ config PARPORT_PC_PCMCIA
 
 config PARPORT_IP32
 	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && EXPERIMENTAL
+	depends on SGI_IP32
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -126,7 +126,7 @@ config PARPORT_GSC
 
 config PARPORT_SUNBPP
 	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	depends on SBUS
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index a64449d..9a011a7 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig HOTPLUG_PCI
 	tristate "Support for PCI Hotplug (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL && HOTPLUG
+	depends on PCI && HOTPLUG
 	---help---
 	  Say Y here if you have a motherboard with a PCI Hotplug controller.
 	  This allows you to add and remove PCI cards while the machine is
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 519b4ff..0060674 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -55,7 +55,7 @@ config PCMCIA
 
 config PCMCIA_LOAD_CIS
 	bool "Load CIS updates from userspace (EXPERIMENTAL)"
-	depends on PCMCIA && EXPERIMENTAL
+	depends on PCMCIA
 	select FW_LOADER
 	default y
 	help
diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
index b986d9f..5ba99f6 100644
--- a/drivers/pnp/pnpbios/Kconfig
+++ b/drivers/pnp/pnpbios/Kconfig
@@ -3,7 +3,7 @@
 #
 config PNPBIOS
 	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on ISA && X86 && EXPERIMENTAL
+	depends on ISA && X86
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 400c65b..c5ef9c2 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -32,7 +32,6 @@ config OBP_FLASH
 
 config SUN_BPP
 	tristate "Bidirectional parallel port support (OBSOLETE)"
-	depends on EXPERIMENTAL
 	help
 	  Say Y here to support Sun's obsolete variant of IEEE1284
 	  bidirectional parallel port protocol as /dev/bppX.  Can be built on
@@ -40,7 +39,7 @@ config SUN_BPP
 
 config SUN_VIDEOPIX
 	tristate "Videopix Frame Grabber (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && (BROKEN || !64BIT)
+	depends on BROKEN || !64BIT
 	help
 	  Say Y here to support the Videopix Frame Grabber from Sun
 	  Microsystems, commonly found on SPARCstations.  This card, which is
@@ -49,7 +48,7 @@ config SUN_VIDEOPIX
 
 config TADPOLE_TS102_UCTRL
 	tristate "Tadpole TS102 Microcontroller support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	depends on SPARC32
 	help
 	  Say Y here to directly support the TS102 Microcontroller interface
 	  on the Tadpole Sparcbook 3.  This device handles power-management
@@ -58,7 +57,7 @@ config TADPOLE_TS102_UCTRL
 
 config SUN_JSFLASH
 	tristate "JavaStation OS Flash SIMM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	depends on SPARC32
 	help
 	  If you say Y here, you will be able to boot from your JavaStation's
 	  Flash memory.
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a6676be..dc856ac 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -36,7 +36,7 @@ config SCSI_DMA
 
 config SCSI_TGT
 	tristate "SCSI target support"
-	depends on SCSI && EXPERIMENTAL
+	depends on SCSI
 	---help---
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
@@ -1403,7 +1403,7 @@ config SCSI_SYM53C416
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
-	depends on PCI && SCSI && EXPERIMENTAL
+	depends on PCI && SCSI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
 	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
@@ -1667,7 +1667,7 @@ config FASTLANE_SCSI
 
 config SCSI_A4000T
 	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && SCSI && EXPERIMENTAL
+	depends on AMIGA && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  If you have an Amiga 4000T and have SCSI devices connected to the
@@ -1678,7 +1678,7 @@ config SCSI_A4000T
 
 config SCSI_ZORRO7XX
 	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	depends on ZORRO && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  Support for various NCR53c710-based SCSI controllers on Zorro
@@ -1694,7 +1694,7 @@ config SCSI_ZORRO7XX
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	depends on ZORRO && SCSI
 	help
 	  If you have the BSC Oktagon SCSI disk controller for the Amiga, say
 	  Y to this question.  If you're in doubt about whether you have one,
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index 7236143..8860f84 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -64,11 +64,11 @@ config SCSI_POWERTECSCSI
 	  you have one of these, say Y. If unsure, say N.
 
 comment "The following drivers are not fully supported"
-	depends on ARCH_ACORN && EXPERIMENTAL
+	depends on ARCH_ACORN
 
 config SCSI_CUMANA_1
 	tristate "CumanaSCSI I support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Cumana SCSI I card. If you have an
@@ -76,7 +76,7 @@ config SCSI_CUMANA_1
 
 config SCSI_OAK1
 	tristate "Oak SCSI support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Oak SCSI card. If you have an Acorn
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a77ede5..c6d5c11 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -67,7 +67,7 @@ config SPI_BFIN
 
 config SPI_AU1550
 	tristate "Au1550/Au12x0 SPI Controller"
-	depends on SPI_MASTER && (SOC_AU1550 || SOC_AU1200) && EXPERIMENTAL
+	depends on SPI_MASTER && (SOC_AU1550 || SOC_AU1200)
 	select SPI_BITBANG
 	help
 	  If you say yes to this option, support will be included for the
@@ -78,7 +78,7 @@ config SPI_AU1550
 
 config SPI_BITBANG
 	tristate "Bitbanging SPI master"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  With a few GPIO pins, your system can bitbang the SPI protocol.
 	  Select this to get SPI support through I/O pins (GPIO, parallel
@@ -92,7 +92,7 @@ config SPI_BITBANG
 
 config SPI_BUTTERFLY
 	tristate "Parallel port adapter for AVR Butterfly (DEVELOPMENT)"
-	depends on SPI_MASTER && PARPORT && EXPERIMENTAL
+	depends on SPI_MASTER && PARPORT
 	select SPI_BITBANG
 	help
 	  This uses a custom parallel port cable to connect to an AVR
@@ -102,14 +102,14 @@ config SPI_BUTTERFLY
 
 config SPI_IMX
 	tristate "Freescale iMX SPI controller"
-	depends on SPI_MASTER && ARCH_IMX && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_IMX
 	help
 	  This enables using the Freescale iMX SPI controller in master
 	  mode.
 
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
-	depends on SPI_MASTER && PARPORT && EXPERIMENTAL
+	depends on SPI_MASTER && PARPORT
 	select SPI_BITBANG
 	help
 	  This driver supports the NS LM70 LLP Evaluation Board,
@@ -118,14 +118,14 @@ config SPI_LM70_LLP
 
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
-	depends on SPI_MASTER && PPC_MPC52xx && EXPERIMENTAL
+	depends on SPI_MASTER && PPC_MPC52xx
 	help
 	  This enables using the Freescale MPC52xx Programmable Serial
 	  Controller in master SPI mode.
 
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
-	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
+	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE)
 	select SPI_BITBANG
 	help
 	  This enables using the Freescale MPC83xx and QUICC Engine SPI
@@ -152,7 +152,7 @@ config SPI_OMAP24XX
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on SPI_MASTER && ARCH_PXA && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_PXA
 	help
 	  This enables using a PXA2xx SSP port as a SPI master controller.
 	  The driver can be configured to use any SSP port and additional
@@ -160,14 +160,14 @@ config SPI_PXA2XX
 
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
-	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_S3C2410
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
 
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
-	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_S3C2410
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs using
@@ -183,7 +183,7 @@ config SPI_TXX9
 
 config SPI_XILINX
 	tristate "Xilinx SPI controller"
-	depends on SPI_MASTER && XILINX_VIRTEX && EXPERIMENTAL
+	depends on SPI_MASTER && XILINX_VIRTEX
 	select SPI_BITBANG
 	help
 	  This exposes the SPI controller IP from the Xilinx EDK.
@@ -215,7 +215,7 @@ config SPI_AT25
 
 config SPI_SPIDEV
 	tristate "User mode SPI device driver support"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This supports user mode SPI protocol drivers.
 
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d976660..0570ee7 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -37,7 +37,7 @@ config SSB_PCIHOST
 
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
-	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
+	depends on SSB && (PCMCIA = y || PCMCIA = SSB)
 	default y
 
 config SSB_PCMCIAHOST
@@ -91,13 +91,13 @@ config SSB_DRIVER_PCICORE
 
 config SSB_PCICORE_HOSTMODE
 	bool "Hostmode support for SSB PCI core (EXPERIMENTAL)"
-	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && EXPERIMENTAL
+	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
 	help
 	  PCIcore hostmode operation (external PCI bus).
 
 config SSB_DRIVER_MIPS
 	bool "SSB Broadcom MIPS core driver (EXPERIMENTAL)"
-	depends on SSB && MIPS && EXPERIMENTAL
+	depends on SSB && MIPS
 	select SSB_SERIAL
 	help
 	  Driver for the Sonics Silicon Backplane attached
@@ -107,7 +107,7 @@ config SSB_DRIVER_MIPS
 
 config SSB_DRIVER_EXTIF
 	bool "SSB Broadcom EXTIF core driver (EXPERIMENTAL)"
-	depends on SSB_DRIVER_MIPS && EXPERIMENTAL
+	depends on SSB_DRIVER_MIPS
 	help
 	  Driver for the Sonics Silicon Backplane attached
 	  Broadcom EXTIF core.
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 97b09f2..c4477f8 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -62,7 +62,7 @@ config USB_DEVICE_CLASS
 
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  If you say Y here, the USB subsystem will use dynamic minor
 	  allocation for any device that uses the USB major number.
@@ -73,7 +73,7 @@ config USB_DYNAMIC_MINORS
 
 config USB_SUSPEND
 	bool "USB selective suspend/resume and wakeup (EXPERIMENTAL)"
-	depends on USB && PM && EXPERIMENTAL
+	depends on USB && PM
 	help
 	  If you say Y here, you can use driver calls or the sysfs
 	  "power/state" file to suspend or resume individual USB
@@ -88,7 +88,7 @@ config USB_SUSPEND
 
 config USB_PERSIST
 	bool "USB device persistence during system suspend (DANGEROUS)"
-	depends on USB && PM && EXPERIMENTAL
+	depends on USB && PM
 	default n
 	help
 
@@ -113,7 +113,7 @@ config USB_PERSIST
 
 config USB_OTG
 	bool
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	select USB_SUSPEND
 	default n
 
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index f81d08d..df9dc34 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -44,7 +44,7 @@ config USB_GADGET
 
 config USB_GADGET_DEBUG
 	boolean "Debugging messages"
-	depends on USB_GADGET && DEBUG_KERNEL && EXPERIMENTAL
+	depends on USB_GADGET && DEBUG_KERNEL
 	help
 	   Many controller and gadget drivers will print some debugging
 	   messages if you use this option to ask for those messages.
@@ -326,7 +326,7 @@ config USB_AT91
 
 config USB_GADGET_DUMMY_HCD
 	boolean "Dummy HCD (DEVELOPMENT)"
-	depends on (USB=y || (USB=m && USB_GADGET=m)) && EXPERIMENTAL
+	depends on USB=y || (USB=m && USB_GADGET=m)
 	select USB_GADGET_DUALSPEED
 	help
 	  This host controller driver emulates USB, looping all data transfer
@@ -393,7 +393,6 @@ choice
 
 config USB_ZERO
 	tristate "Gadget Zero (DEVELOPMENT)"
-	depends on EXPERIMENTAL
 	help
 	  Gadget Zero is a two-configuration device.  It either sinks and
 	  sources bulk data; or it loops back a configurable number of
@@ -458,7 +457,7 @@ config USB_ETH
 
 config USB_ETH_RNDIS
 	bool "RNDIS support (EXPERIMENTAL)"
-	depends on USB_ETH && EXPERIMENTAL
+	depends on USB_ETH
 	default y
 	help
 	   Microsoft Windows XP bundles the "Remote NDIS" (RNDIS) protocol,
@@ -476,7 +475,6 @@ config USB_ETH_RNDIS
 
 config USB_GADGETFS
 	tristate "Gadget Filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  This driver provides a filesystem based API that lets user mode
 	  programs implement a single-configuration USB device, including
@@ -526,7 +524,7 @@ config USB_G_SERIAL
 
 config USB_MIDI_GADGET
 	tristate "MIDI Gadget (EXPERIMENTAL)"
-	depends on SND && EXPERIMENTAL
+	depends on SND
 	select SND_RAWMIDI
 	help
 	  The MIDI Gadget acts as a USB Audio device, with one MIDI
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 177e78e..d618263 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -31,7 +31,7 @@ config USB_EHCI_HCD
 
 config USB_EHCI_SPLIT_ISO
 	bool "Full speed ISO transactions (EXPERIMENTAL)"
-	depends on USB_EHCI_HCD && EXPERIMENTAL
+	depends on USB_EHCI_HCD
 	default n
 	---help---
 	  This code is new and hasn't been used with many different
@@ -40,7 +40,7 @@ config USB_EHCI_SPLIT_ISO
 
 config USB_EHCI_ROOT_HUB_TT
 	bool "Root Hub Transaction Translators (EXPERIMENTAL)"
-	depends on USB_EHCI_HCD && EXPERIMENTAL
+	depends on USB_EHCI_HCD
 	---help---
 	  Some EHCI chips have vendor-specific extensions to integrate
 	  transaction translators, so that no OHCI or UHCI companion
@@ -52,7 +52,7 @@ config USB_EHCI_ROOT_HUB_TT
 
 config USB_EHCI_TT_NEWSCHED
 	bool "Improved Transaction Translator scheduling (EXPERIMENTAL)"
-	depends on USB_EHCI_HCD && EXPERIMENTAL
+	depends on USB_EHCI_HCD
 	---help---
 	  This changes the periodic scheduling code to fill more of the low
 	  and full speed bandwidth available from the Transaction Translator
@@ -156,7 +156,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core"
-	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
+	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD)
 	default n
 	---help---
 	  Support for the Sonics Silicon Backplane (SSB) attached
diff --git a/drivers/usb/image/Kconfig b/drivers/usb/image/Kconfig
index 7595dfb..b1d8463 100644
--- a/drivers/usb/image/Kconfig
+++ b/drivers/usb/image/Kconfig
@@ -6,7 +6,7 @@ comment "USB Imaging devices"
 
 config USB_MDC800
 	tristate "USB Mustek MDC800 Digital Camera support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	---help---
 	  Say Y here if you want to connect this type of still camera to
 	  your computer's USB port. This driver can be used with gphoto 0.4.3
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 9c7eb61..40a075a 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -34,7 +34,7 @@ config USB_EMI26
 
 config USB_ADUTUX
 	tristate "ADU devices from Ontrak Control Systems (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  Say Y if you want to use an ADU device from Ontrak Control
 	  Systems.
@@ -44,7 +44,7 @@ config USB_ADUTUX
 
 config USB_AUERSWALD
 	tristate "USB Auerswald ISDN support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  Say Y here if you want to connect an Auerswald USB ISDN Device
 	  to your computer's USB port.
@@ -54,7 +54,7 @@ config USB_AUERSWALD
 
 config USB_RIO500
 	tristate "USB Diamond Rio500 support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  Say Y here if you want to connect a USB Rio500 mp3 player to your
 	  computer's USB port. Please read <file:Documentation/usb/rio.txt>
@@ -65,7 +65,7 @@ config USB_RIO500
 
 config USB_LEGOTOWER
 	tristate "USB Lego Infrared Tower support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	help
 	  Say Y here if you want to connect a USB Lego Infrared Tower to your
 	  computer's USB port.
@@ -260,7 +260,7 @@ config USB_IOWARRIOR
 
 config USB_TEST
 	tristate "USB testing driver (DEVELOPMENT)"
-	depends on USB && USB_DEVICEFS && EXPERIMENTAL
+	depends on USB && USB_DEVICEFS
 	help
 	  This driver is for testing host controller software.  It is used
 	  with specialized device firmware for regression and stress testing,
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 4a86696..17d170d 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -22,7 +22,7 @@ config USB_SERIAL
 
 config USB_SERIAL_CONSOLE
 	bool "USB Serial Console device support (EXPERIMENTAL)"
-	depends on USB_SERIAL=y && EXPERIMENTAL
+	depends on USB_SERIAL=y
 	---help---
 	  If you say Y here, it will be possible to use a USB to serial
 	  converter port as the system console (the system console is the
@@ -55,7 +55,7 @@ config USB_SERIAL_GENERIC
 
 config USB_SERIAL_AIRCABLE
 	tristate "USB AIRcable Bluetooth Dongle Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	    Say Y here if you want to use USB AIRcable Bluetooth Dongle.
 
@@ -73,7 +73,7 @@ config USB_SERIAL_AIRPRIME
 
 config USB_SERIAL_ARK3116
 	tristate "USB ARK Micro 3116 USB Serial Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to use a ARK Micro 3116 USB to Serial
 	  device.
@@ -129,7 +129,7 @@ config USB_SERIAL_DIGI_ACCELEPORT
 
 config USB_SERIAL_CP2101
 	tristate "USB CP2101 UART Bridge Controller"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to use a CP2101/CP2102 based USB to RS232
 	  converter.
@@ -139,7 +139,7 @@ config USB_SERIAL_CP2101
 
 config USB_SERIAL_CYPRESS_M8
 	tristate "USB Cypress M8 USB Serial Driver"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to use a device that contains the Cypress
 	  USB to Serial microcontroller, such as the DeLorme Earthmate GPS.
@@ -166,7 +166,7 @@ config USB_SERIAL_EMPEG
 
 config USB_SERIAL_FTDI_SIO
 	tristate "USB FTDI Single Port Serial Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	---help---
 	  Say Y here if you want to use a FTDI SIO single port USB to serial
 	  converter device. The implementation I have is called the USC-1000.
@@ -213,7 +213,7 @@ config USB_SERIAL_IPAQ
 
 config USB_SERIAL_IR
 	tristate "USB IR Dongle Serial Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to enable simple serial support for USB IrDA
 	  devices.  This is useful if you do not want to use the full IrDA
@@ -274,7 +274,7 @@ config USB_SERIAL_GARMIN
 
 config USB_SERIAL_IPW
         tristate "USB IPWireless (3G UMTS TDD) Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to use a IPWireless USB modem such as
 	  the ones supplied by Axity3G/Sentech South Africa.
@@ -387,7 +387,7 @@ config USB_SERIAL_KEYSPAN_USA49WLC
 
 config USB_SERIAL_KLSI
 	tristate "USB KL5KUSB105 (Palmconnect) Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	---help---
 	  Say Y here if you want to use a KL5KUSB105 - based single port
 	  serial adapter. The most widely known -- and currently the only
@@ -495,7 +495,7 @@ config USB_SERIAL_HP4X
 
 config USB_SERIAL_SAFE
 	tristate "USB Safe Serial (Encapsulated) Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 
 config USB_SERIAL_SAFE_PADDED
 	bool "USB Secure Encapsulated Driver - Padded"
@@ -524,7 +524,7 @@ config USB_SERIAL_TI
 
 config USB_SERIAL_CYBERJACK
 	tristate "USB REINER SCT cyberJack pinpad/e-com chipcard reader (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	---help---
 	  Say Y here if you want to use a cyberJack pinpad/e-com USB chipcard
 	  reader. This is an interface to ISO 7816 compatible contact-based
@@ -567,7 +567,7 @@ config USB_SERIAL_OPTION
 
 config USB_SERIAL_OMNINET
 	tristate "USB ZyXEL omni.net LCD Plus Driver (EXPERIMENTAL)"
-	depends on USB_SERIAL && EXPERIMENTAL
+	depends on USB_SERIAL
 	help
 	  Say Y here if you want to use a ZyXEL omni.net LCD ISDN TA.
 
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 7e53333..15af8dd 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -33,7 +33,7 @@ config USB_STORAGE_DEBUG
 
 config USB_STORAGE_DATAFAB
 	bool "Datafab Compact Flash Reader support (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Support for certain Datafab CompactFlash readers.
 	  Datafab has a web page at <http://www.datafabusa.com/>.
@@ -70,7 +70,7 @@ config USB_STORAGE_DPCM
 
 config USB_STORAGE_USBAT
 	bool "USBAT/USBAT02-based storage support (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Say Y here to include additional code to support storage devices
 	  based on the SCM/Shuttle USBAT/USBAT02 processors.
@@ -91,7 +91,7 @@ config USB_STORAGE_USBAT
 
 config USB_STORAGE_SDDR09
 	bool "SanDisk SDDR-09 (and other SmartMedia) support (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Say Y here to include additional code to support the Sandisk SDDR-09
 	  SmartMedia reader in the USB Mass Storage driver.
@@ -99,21 +99,21 @@ config USB_STORAGE_SDDR09
 
 config USB_STORAGE_SDDR55
 	bool "SanDisk SDDR-55 SmartMedia support (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Say Y here to include additional code to support the Sandisk SDDR-55
 	  SmartMedia reader in the USB Mass Storage driver.
 
 config USB_STORAGE_JUMPSHOT
 	bool "Lexar Jumpshot Compact Flash Reader (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Say Y here to include additional code to support the Lexar Jumpshot
 	  USB CompactFlash reader.
 
 config USB_STORAGE_ALAUDA
 	bool "Olympus MAUSB-10/Fuji DPC-R1 support (EXPERIMENTAL)"
-	depends on USB_STORAGE && EXPERIMENTAL
+	depends on USB_STORAGE
 	help
 	  Say Y here to include additional code to support the Olympus MAUSB-10
 	  and Fujifilm DPC-R1 USB Card reader/writer devices.
@@ -123,7 +123,7 @@ config USB_STORAGE_ALAUDA
 
 config USB_STORAGE_ONETOUCH
 	bool "Support OneTouch Button on Maxtor Hard Drives (EXPERIMENTAL)"
-	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL && !PM
+	depends on USB_STORAGE && INPUT_EVDEV && !PM
 	help
 	  Say Y here to include additional code to support the Maxtor OneTouch
 	  USB hard drive's onetouch button.
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 7d86e9e..5e0849d 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -682,7 +682,7 @@ config FB_HGA
 
 config FB_HGA_ACCEL
 	bool "Hercules mono Acceleration functions (EXPERIMENTAL)"
-	depends on FB_HGA && EXPERIMENTAL
+	depends on FB_HGA
 	---help---
 	This will compile the Hercules mono graphics with
 	acceleration functions.
@@ -999,7 +999,7 @@ config FB_RIVA_BACKLIGHT
 
 config FB_I810
 	tristate "Intel 810/815 support (EXPERIMENTAL)"
-	depends on FB && EXPERIMENTAL && PCI && X86_32
+	depends on FB && PCI && X86_32
 	select AGP
 	select AGP_INTEL
 	select FB_MODE_HELPERS
@@ -1064,7 +1064,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G support (EXPERIMENTAL)"
-	depends on FB && EXPERIMENTAL && PCI && X86
+	depends on FB && PCI && X86
 	select AGP
 	select AGP_INTEL
 	select FB_MODE_HELPERS
@@ -1380,7 +1380,7 @@ config FB_S3
 
 config FB_SAVAGE
 	tristate "S3 Savage support"
-	depends on FB && PCI && EXPERIMENTAL
+	depends on FB && PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1488,7 +1488,7 @@ config FB_3DFX
 
 config FB_3DFX_ACCEL
 	bool "3Dfx Banshee/Voodoo3 Acceleration functions (EXPERIMENTAL)"
-	depends on FB_3DFX && EXPERIMENTAL
+	depends on FB_3DFX
 	---help---
 	This will compile the 3Dfx Banshee/Voodoo3 frame buffer device
 	with acceleration functions.
@@ -1574,7 +1574,7 @@ config FB_TRIDENT
 
 config FB_TRIDENT_ACCEL
 	bool "Trident Acceleration functions (EXPERIMENTAL)"
-	depends on FB_TRIDENT && EXPERIMENTAL
+	depends on FB_TRIDENT
 	---help---
 	This will compile the Trident frame buffer device with
 	acceleration functions.
@@ -1595,7 +1595,7 @@ config FB_ARK
 
 config FB_PM3
 	tristate "Permedia3 support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL
+	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index 7608429..d8bfd83 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -3,7 +3,7 @@
 #
 config FB_GEODE
 	bool "AMD Geode family framebuffer support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL && X86
+	depends on FB && PCI && X86
 	---help---
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
@@ -25,7 +25,7 @@ config FB_GEODE_LX
 
 config FB_GEODE_GX
 	tristate "AMD Geode GX framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -60,7 +60,7 @@ config FB_GEODE_GX_FBSIZE
 
 config FB_GEODE_GX1
 	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 8236d44..6d9f2b3 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -26,7 +26,7 @@ config W1_MASTER_DS2490
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Maxim DS2482
 	  I2C to 1-Wire bridge.
diff --git a/fs/Kconfig b/fs/Kconfig
index 429a002..0449050 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -138,7 +138,6 @@ config EXT3_FS_SECURITY
 
 config EXT4DEV_FS
 	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select JBD2
 	select CRC16
 	help
@@ -932,7 +931,7 @@ config PROC_KCORE
 
 config PROC_VMCORE
         bool "/proc/vmcore support (EXPERIMENTAL)"
-        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
+        depends on PROC_FS && CRASH_DUMP
 	default y
         help
         Exports the dump image of crashed kernel in ELF format.
@@ -1020,7 +1019,7 @@ config HUGETLB_PAGE
 
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
-	depends on SYSFS && EXPERIMENTAL
+	depends on SYSFS
 	help
 	  configfs is a ram-based filesystem that provides the converse
 	  of sysfs's functionality. Where sysfs is a filesystem-based
@@ -1036,7 +1035,7 @@ menu "Miscellaneous filesystems"
 
 config ADFS_FS
 	tristate "ADFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
@@ -1064,7 +1063,7 @@ config ADFS_FS_RW
 
 config AFFS_FS
 	tristate "Amiga FFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	help
 	  The Fast File System (FFS) is the common file system used on hard
 	  disks by Amiga(tm) systems since AmigaOS Version 1.3 (34.20).  Say Y
@@ -1086,7 +1085,7 @@ config AFFS_FS
 
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
+	depends on KEYS && CRYPTO && NET
 	help
 	  Encrypted filesystem that operates on the VFS layer.  See
 	  <file:Documentation/filesystems/ecryptfs.txt> to learn more about
@@ -1098,7 +1097,7 @@ config ECRYPT_FS
 
 config HFS_FS
 	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	select NLS
 	help
 	  If you say Y here, you will be able to mount Macintosh-formatted
@@ -1125,7 +1124,7 @@ config HFSPLUS_FS
 
 config BEFS_FS
 	tristate "BeOS file system (BeFS) support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	select NLS
 	help
 	  The BeOS File System (BeFS) is the native file system of Be, Inc's
@@ -1152,7 +1151,7 @@ config BEFS_DEBUG
 
 config BFS_FS
 	tristate "BFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	help
 	  Boot File System (BFS) is a file system used under SCO UnixWare to
 	  allow the bootloader access to the kernel image and other important
@@ -1174,7 +1173,7 @@ config BFS_FS
 
 config EFS_FS
 	tristate "EFS file system support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on BLOCK
 	help
 	  EFS is an older file system used for non-ISO9660 CD-ROMs and hard
 	  disk partitions by SGI's IRIX operating system (IRIX 6.0 and newer
@@ -1240,7 +1239,7 @@ config JFFS2_FS_WBUF_VERIFY
 
 config JFFS2_SUMMARY
 	bool "JFFS2 summary support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	depends on JFFS2_FS
 	default n
 	help
 	  This feature makes it possible to use summary information
@@ -1253,7 +1252,7 @@ config JFFS2_SUMMARY
 
 config JFFS2_FS_XATTR
 	bool "JFFS2 XATTR support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	depends on JFFS2_FS
 	default n
 	help
 	  Extended attributes are name:value pairs associated with inodes by
@@ -1450,7 +1449,7 @@ config QNX4FS_FS
 
 config QNX4FS_RW
 	bool "QNX4FS write support (DANGEROUS)"
-	depends on QNX4FS_FS && EXPERIMENTAL && BROKEN
+	depends on QNX4FS_FS && BROKEN
 	help
 	  Say Y if you want to test write support for QNX4 file systems.
 
@@ -1533,7 +1532,7 @@ config UFS_FS
 
 config UFS_FS_WRITE
 	bool "UFS file system write support (DANGEROUS)"
-	depends on UFS_FS && EXPERIMENTAL
+	depends on UFS_FS
 	help
 	  Say Y here if you want to try writing to UFS partitions. This is
 	  experimental, so you should back up your UFS partitions beforehand.
@@ -1623,7 +1622,7 @@ config NFS_V3_ACL
 
 config NFS_V4
 	bool "Provide NFSv4 client support (EXPERIMENTAL)"
-	depends on NFS_FS && EXPERIMENTAL
+	depends on NFS_FS
 	select RPCSEC_GSS_KRB5
 	help
 	  Say Y here if you want your NFS client to be able to speak the newer
@@ -1715,7 +1714,7 @@ config NFSD_V3_ACL
 
 config NFSD_V4
 	bool "Provide NFSv4 server support (EXPERIMENTAL)"
-	depends on NFSD && NFSD_V3 && EXPERIMENTAL
+	depends on NFSD && NFSD_V3
 	select RPCSEC_GSS_KRB5
 	help
 	  If you would like to include the NFSv4 server as well as the NFSv2
@@ -1774,7 +1773,7 @@ config SUNRPC_GSS
 
 config SUNRPC_XPRT_RDMA
 	tristate "RDMA transport for sunrpc (EXPERIMENTAL)"
-	depends on SUNRPC && INFINIBAND && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND
 	default m
 	help
 	  Adds a client RPC transport for supporting kernel NFS over RDMA
@@ -1782,7 +1781,7 @@ config SUNRPC_XPRT_RDMA
 
 config SUNRPC_BIND34
 	bool "Support for rpcbind versions 3 & 4 (EXPERIMENTAL)"
-	depends on SUNRPC && EXPERIMENTAL
+	depends on SUNRPC
 	help
 	  Provides kernel support for querying rpcbind servers via versions 3
 	  and 4 of the rpcbind protocol.  The kernel automatically falls back
@@ -1794,7 +1793,7 @@ config SUNRPC_BIND34
 
 config RPCSEC_GSS_KRB5
 	tristate "Secure RPC: Kerberos V mechanism (EXPERIMENTAL)"
-	depends on SUNRPC && EXPERIMENTAL
+	depends on SUNRPC
 	select SUNRPC_GSS
 	select CRYPTO
 	select CRYPTO_MD5
@@ -1812,7 +1811,7 @@ config RPCSEC_GSS_KRB5
 
 config RPCSEC_GSS_SPKM3
 	tristate "Secure RPC: SPKM3 mechanism (EXPERIMENTAL)"
-	depends on SUNRPC && EXPERIMENTAL
+	depends on SUNRPC
 	select SUNRPC_GSS
 	select CRYPTO
 	select CRYPTO_MD5
@@ -1993,7 +1992,7 @@ config CIFS_DEBUG2
 	   
 config CIFS_EXPERIMENTAL
 	  bool "CIFS Experimental Features (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL
+	  depends on CIFS
 	  help
 	    Enables cifs features under testing. These features are
 	    experimental and currently include DFS support and directory 
@@ -2076,7 +2075,7 @@ config CODA_FS_OLD_API
 
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	select AF_RXRPC
 	help
 	  If you say Y here, you will get an experimental Andrew File System
@@ -2098,7 +2097,7 @@ config AFS_DEBUG
 
 config 9P_FS
 	tristate "Plan 9 Resource Sharing Support (9P2000) (Experimental)"
-	depends on INET && NET_9P && EXPERIMENTAL
+	depends on INET && NET_9P
 	help
 	  If you say Y here, you will get experimental support for
 	  Plan 9 resource sharing via the 9P2000 protocol.
diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 2dbb422..76c686a 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,6 +1,6 @@
 menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on EXPERIMENTAL && INET
+	depends on INET
 	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
 	select IP_SCTP
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index de8e64c..ce212f1 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,5 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
-	depends on EXPERIMENTAL
 	select FS_POSIX_ACL
 	select CRC32
 	help
diff --git a/init/Kconfig b/init/Kconfig
index c5b354b..34162d7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -10,35 +10,8 @@ config DEFCONFIG_LIST
 menu "General setup"
 
 config EXPERIMENTAL
-	bool "Prompt for development and/or incomplete code/drivers"
-	---help---
-	  Some of the various things that Linux supports (such as network
-	  drivers, file systems, network protocols, etc.) can be in a state
-	  of development where the functionality, stability, or the level of
-	  testing is not yet high enough for general use. This is usually
-	  known as the "alpha-test" phase among developers. If a feature is
-	  currently in alpha-test, then the developers usually discourage
-	  uninformed widespread use of this feature by the general public to
-	  avoid "Why doesn't this work?" type mail messages. However, active
-	  testing and use of these systems is welcomed. Just be aware that it
-	  may not meet the normal level of reliability or it may fail to work
-	  in some special cases. Detailed bug reports from people familiar
-	  with the kernel internals are usually welcomed by the developers
-	  (before submitting bug reports, please read the documents
-	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
-	  <file:Documentation/BUG-HUNTING>, and
-	  <file:Documentation/oops-tracing.txt> in the kernel source).
-
-	  This option will also make obsoleted drivers available. These are
-	  drivers that have been replaced by something else, and/or are
-	  scheduled to be removed in a future kernel release.
-
-	  Unless you intend to help test and develop a feature or driver that
-	  falls into this category, or you have a situation that requires
-	  using these features, you should probably say N here, which will
-	  cause the configurator to present you with fewer choices. If
-	  you say Y here, you will be offered the choice of using features or
-	  drivers that are currently considered to be in the alpha-test phase.
+	bool
+	default y
 
 config BROKEN
 	bool
@@ -125,7 +98,7 @@ config SYSVIPC_SYSCTL
 
 config POSIX_MQUEUE
 	bool "POSIX Message Queues"
-	depends on NET && EXPERIMENTAL
+	depends on NET
 	---help---
 	  POSIX variant of message queues is a part of IPC. In POSIX message
 	  queues every message has a priority which decides about succession
@@ -209,7 +182,6 @@ config TASK_IO_ACCOUNTING
 config USER_NS
 	bool "User Namespaces (EXPERIMENTAL)"
 	default n
-	depends on EXPERIMENTAL
 	help
 	  Support user namespaces.  This allows containers, i.e.
 	  vservers, to use user namespaces to provide different
@@ -218,7 +190,6 @@ config USER_NS
 config PID_NS
 	bool "PID Namespaces (EXPERIMENTAL)"
 	default n
-	depends on EXPERIMENTAL
 	help
 	  Suport process id namespaces.  This allows having multiple
 	  process with the same pid as long as they are in different
@@ -415,7 +386,6 @@ endif
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size (Look out for broken compilers!)"
 	default y
-	depends on ARM || H8300 || SUPERH || EXPERIMENTAL
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to gcc
 	  resulting in a smaller kernel.
@@ -695,7 +665,7 @@ config MODULE_UNLOAD
 
 config MODULE_FORCE_UNLOAD
 	bool "Forced module unloading"
-	depends on MODULE_UNLOAD && EXPERIMENTAL
+	depends on MODULE_UNLOAD
 	help
 	  This option allows you to force a module to unload, even if the
 	  kernel believes it is unsafe: the kernel will remove the module
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 8e186c6..7d4b779 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -46,7 +46,7 @@ config PM_VERBOSE
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM_DEBUG && X86 && PM_SLEEP && EXPERIMENTAL
+	depends on PM_DEBUG && X86 && PM_SLEEP
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
diff --git a/mm/Kconfig b/mm/Kconfig
index c070ec0..a2024bc 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,6 +1,5 @@
 config SELECT_MEMORY_MODEL
 	def_bool y
-	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
 
 choice
 	prompt "Memory model"
@@ -171,7 +170,7 @@ config MIGRATION
 	  the page.
 
 config RESOURCES_64BIT
-	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT && EXPERIMENTAL)
+	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if !64BIT
 	default 64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index bafc50c..c65159f 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig NET_9P
-	depends on NET && EXPERIMENTAL
+	depends on NET
 	tristate "Plan 9 Resource Sharing Support (9P2000) (Experimental)"
 	help
 	  If you say Y here, you will get experimental support for
@@ -24,7 +24,7 @@ config NET_9P_FD
 	  so if you are going to use 9p, you'll likely want this.
 
 config NET_9P_VIRTIO
-	depends on NET_9P && EXPERIMENTAL && VIRTIO
+	depends on NET_9P && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
 	help
 	  This builds support for a transports between
diff --git a/net/Kconfig b/net/Kconfig
index ab4e6da..44c0557 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -30,7 +30,7 @@ menu "Networking options"
 config NET_NS
 	bool "Network namespace support"
 	default n
-	depends on EXPERIMENTAL && !SYSFS
+	depends on !SYSFS
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
@@ -200,7 +200,7 @@ config NET_PKTGEN
 
 config NET_TCPPROBE
 	tristate "TCP connection probing"
-	depends on INET && EXPERIMENTAL && PROC_FS && KPROBES
+	depends on INET && PROC_FS && KPROBES
 	---help---
 	This module allows for capturing the changes to TCP connection
 	state in response to incoming packets. It is used for debugging
diff --git a/net/atm/Kconfig b/net/atm/Kconfig
index 21ff276..84f0815 100644
--- a/net/atm/Kconfig
+++ b/net/atm/Kconfig
@@ -4,7 +4,6 @@
 
 config ATM
 	tristate "Asynchronous Transfer Mode (ATM) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	  ATM is a high-speed networking technology for Local Area Networks
 	  and Wide Area Networks.  It uses a fixed packet size and is
diff --git a/net/dccp/Kconfig b/net/dccp/Kconfig
index 0549e47..f1271c7 100644
--- a/net/dccp/Kconfig
+++ b/net/dccp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig IP_DCCP
 	tristate "The DCCP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	---help---
 	  Datagram Congestion Control Protocol (RFC 4340)
 
diff --git a/net/dccp/ccids/Kconfig b/net/dccp/ccids/Kconfig
index 80f4698..6f4ad4b 100644
--- a/net/dccp/ccids/Kconfig
+++ b/net/dccp/ccids/Kconfig
@@ -1,5 +1,5 @@
 menu "DCCP CCIDs Configuration (EXPERIMENTAL)"
-	depends on IP_DCCP && EXPERIMENTAL
+	depends on IP_DCCP
 
 config IP_DCCP_CCID2
 	tristate "CCID2 (TCP-Like) (EXPERIMENTAL)"
@@ -93,7 +93,7 @@ config IP_DCCP_CCID3_DEBUG
 config IP_DCCP_CCID3_RTO
 	  int "Use higher bound for nofeedback timer"
 	  default 100
-	  depends on IP_DCCP_CCID3 && EXPERIMENTAL
+	  depends on IP_DCCP_CCID3
 	  ---help---
 	    Use higher lower bound for nofeedback timer expiration.
 
diff --git a/net/decnet/Kconfig b/net/decnet/Kconfig
index 7914fd6..e7c57a4 100644
--- a/net/decnet/Kconfig
+++ b/net/decnet/Kconfig
@@ -26,7 +26,7 @@ config DECNET
 
 config DECNET_ROUTER
 	bool "DECnet: router support (EXPERIMENTAL)"
-	depends on DECNET && EXPERIMENTAL
+	depends on DECNET
 	select FIB_RULES
 	---help---
 	  Add support for turning your DECnet Endnode into a level 1 or 2
diff --git a/net/decnet/netfilter/Kconfig b/net/decnet/netfilter/Kconfig
index ecdb3f9..d64b9df 100644
--- a/net/decnet/netfilter/Kconfig
+++ b/net/decnet/netfilter/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "DECnet: Netfilter Configuration"
-	depends on DECNET && NETFILTER && EXPERIMENTAL
+	depends on DECNET && NETFILTER
 
 config DECNET_NF_GRABULATOR
 	tristate "Routing message grabulator (for userland routing daemon)"
diff --git a/net/econet/Kconfig b/net/econet/Kconfig
index 39a2d29..d66f9a5 100644
--- a/net/econet/Kconfig
+++ b/net/econet/Kconfig
@@ -4,7 +4,7 @@
 
 config ECONET
 	tristate "Acorn Econet/AUN protocols (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET
+	depends on INET
 	---help---
 	  Econet is a fairly old and slow networking protocol mainly used by
 	  Acorn computers to access file and print servers. It uses native
diff --git a/net/ieee80211/softmac/Kconfig b/net/ieee80211/softmac/Kconfig
index 2811651..1214389 100644
--- a/net/ieee80211/softmac/Kconfig
+++ b/net/ieee80211/softmac/Kconfig
@@ -1,6 +1,6 @@
 config IEEE80211_SOFTMAC
 	tristate "Software MAC add-on to the IEEE 802.11 networking stack"
-	depends on IEEE80211 && EXPERIMENTAL
+	depends on IEEE80211
 	select WIRELESS_EXT
 	select IEEE80211_CRYPT_WEP
 	---help---
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 9f9fd2c..db42305 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -261,7 +261,6 @@ config IP_PIMSM_V2
 
 config ARPD
 	bool "IP: ARP daemon support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	  Normally, the kernel maintains an internal cache which maps IP
 	  addresses to hardware addresses on the local network, so that
@@ -478,7 +477,6 @@ config TCP_CONG_HTCP
 
 config TCP_CONG_HSTCP
 	tristate "High Speed TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Sally Floyd's High Speed TCP (RFC 3649) congestion control.
@@ -489,7 +487,6 @@ config TCP_CONG_HSTCP
 
 config TCP_CONG_HYBLA
 	tristate "TCP-Hybla congestion control algorithm"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Hybla is a sender-side only change that eliminates penalization of
@@ -499,7 +496,6 @@ config TCP_CONG_HYBLA
 
 config TCP_CONG_VEGAS
 	tristate "TCP Vegas"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Vegas is a sender-side only change to TCP that anticipates
@@ -510,7 +506,6 @@ config TCP_CONG_VEGAS
 
 config TCP_CONG_SCALABLE
 	tristate "Scalable TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Scalable TCP is a sender-side only change to TCP which uses a
@@ -520,7 +515,6 @@ config TCP_CONG_SCALABLE
 
 config TCP_CONG_LP
 	tristate "TCP Low Priority"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Low Priority (TCP-LP), a distributed algorithm whose goal is
@@ -530,7 +524,6 @@ config TCP_CONG_LP
 
 config TCP_CONG_VENO
 	tristate "TCP Veno"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Veno is a sender-side only enhancement of TCP to obtain better
@@ -542,7 +535,6 @@ config TCP_CONG_VENO
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
-	depends on EXPERIMENTAL
 	select TCP_CONG_VEGAS
 	default n
 	---help---
@@ -557,7 +549,6 @@ config TCP_CONG_YEAH
 
 config TCP_CONG_ILLINOIS
 	tristate "TCP Illinois"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Illinois is a sender-side modification of TCP Reno for
@@ -614,7 +605,6 @@ config DEFAULT_TCP_CONG
 
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select CRYPTO
 	select CRYPTO_MD5
 	---help---
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9aca9c5..2686ade 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -240,7 +240,7 @@ config IP_NF_TARGET_SAME
 
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_NAT
+	depends on NF_NAT
 	---help---
 
 	  This module implements an Application Layer Gateway (ALG) for
@@ -351,7 +351,7 @@ config IP_NF_TARGET_TTL
 
 config IP_NF_TARGET_CLUSTERIP
 	tristate "CLUSTERIP target support (EXPERIMENTAL)"
-	depends on IP_NF_MANGLE && EXPERIMENTAL
+	depends on IP_NF_MANGLE
 	depends on NF_CONNTRACK_IPV4
 	select NF_CONNTRACK_MARK
 	help
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index eb0b808..f3865d3 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -51,7 +51,7 @@ config IPV6_ROUTER_PREF
 
 config IPV6_ROUTE_INFO
 	bool "IPv6: Route Information (RFC 4191) support (EXPERIMENTAL)"
-	depends on IPV6_ROUTER_PREF && EXPERIMENTAL
+	depends on IPV6_ROUTER_PREF
 	---help---
 	  This is experimental support of Route Information.
 
@@ -59,7 +59,7 @@ config IPV6_ROUTE_INFO
 
 config IPV6_OPTIMISTIC_DAD
 	bool "IPv6: Enable RFC 4429 Optimistic DAD (EXPERIMENTAL)"
-	depends on IPV6 && EXPERIMENTAL
+	depends on IPV6
 	---help---
 	  This is experimental support for optimistic Duplicate
 	  Address Detection.  It allows for autoconfigured addresses
@@ -110,7 +110,7 @@ config INET6_IPCOMP
 
 config IPV6_MIP6
 	tristate "IPv6: Mobility (EXPERIMENTAL)"
-	depends on IPV6 && EXPERIMENTAL
+	depends on IPV6
 	select XFRM
 	---help---
 	  Support for IPv6 Mobility described in RFC 3775.
@@ -158,7 +158,7 @@ config INET6_XFRM_MODE_BEET
 
 config INET6_XFRM_MODE_ROUTEOPTIMIZATION
 	tristate "IPv6: MIPv6 route optimization mode (EXPERIMENTAL)"
-	depends on IPV6 && EXPERIMENTAL
+	depends on IPV6
 	select XFRM
 	---help---
 	  Support for MIPv6 route optimization mode.
@@ -188,7 +188,7 @@ config IPV6_TUNNEL
 
 config IPV6_MULTIPLE_TABLES
 	bool "IPv6: Multiple Routing Tables"
-	depends on IPV6 && EXPERIMENTAL
+	depends on IPV6
 	select FIB_RULES
 	---help---
 	  Support multiple routing tables.
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 838b8dd..a70f7ea 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -3,11 +3,11 @@
 #
 
 menu "IPv6: Netfilter Configuration (EXPERIMENTAL)"
-	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
+	depends on INET && IPV6 && NETFILTER
 
 config NF_CONNTRACK_IPV6
 	tristate "IPv6 connection tracking support (EXPERIMENTAL)"
-	depends on INET && IPV6 && EXPERIMENTAL && NF_CONNTRACK
+	depends on INET && IPV6 && NF_CONNTRACK
 	---help---
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
@@ -21,7 +21,7 @@ config NF_CONNTRACK_IPV6
 
 config IP6_NF_QUEUE
 	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
-	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
+	depends on INET && IPV6 && NETFILTER
 	---help---
 
 	  This option adds a queue handler to the kernel for IPv6
@@ -42,7 +42,7 @@ config IP6_NF_QUEUE
 
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
-	depends on INET && IPV6 && EXPERIMENTAL
+	depends on INET && IPV6
 	select NETFILTER_XTABLES
 	help
 	  ip6tables is a general, extensible packet identification framework.
diff --git a/net/lapb/Kconfig b/net/lapb/Kconfig
index f0b5efb..ca75f0b 100644
--- a/net/lapb/Kconfig
+++ b/net/lapb/Kconfig
@@ -4,7 +4,6 @@
 
 config LAPB
 	tristate "LAPB Data Link Driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	  Link Access Procedure, Balanced (LAPB) is the data link layer (i.e.
 	  the lower) part of the X.25 protocol. It offers a reliable
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index ce176e6..45fded5 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,6 +1,5 @@
 config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
-	depends on EXPERIMENTAL
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21a9fcc..bf02b4e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -79,7 +79,7 @@ config NF_CONNTRACK_SECMARK
 
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code
@@ -93,7 +93,7 @@ config NF_CT_PROTO_GRE
 
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	default n
 	help
 	  With this option enabled, the layer 3 independent connection
@@ -104,7 +104,7 @@ config NF_CT_PROTO_SCTP
 
 config NF_CT_PROTO_UDPLITE
 	tristate 'UDP-Lite protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on UDP-Lite
@@ -143,7 +143,7 @@ config NF_CONNTRACK_FTP
 
 config NF_CONNTRACK_H323
 	tristate "H.323 protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK && (IPV6 || IPV6=n)
+	depends on NF_CONNTRACK && (IPV6 || IPV6=n)
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
 	  important VoIP protocols, it is widely used by voice hardware and
@@ -177,7 +177,7 @@ config NF_CONNTRACK_IRC
 
 config NF_CONNTRACK_NETBIOS_NS
 	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	help
 	  NetBIOS name service requests are sent as broadcast messages from an
 	  unprivileged port and responded to with unicast messages to the
@@ -215,7 +215,7 @@ config NF_CONNTRACK_PPTP
 
 config NF_CONNTRACK_SANE
 	tristate "SANE protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	help
 	  SANE is a protocol for remote access to scanners as implemented
 	  by the 'saned' daemon. Like FTP, it uses separate control and
@@ -228,7 +228,7 @@ config NF_CONNTRACK_SANE
 
 config NF_CONNTRACK_SIP
 	tristate "SIP protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 	help
 	  SIP is an application-layer control protocol that can establish,
 	  modify, and terminate multimedia sessions (conferences) such as
@@ -251,7 +251,7 @@ config NF_CONNTRACK_TFTP
 
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
+	depends on NF_CONNTRACK && NETFILTER_NETLINK
 	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
 	depends on NF_NAT=n || NF_NAT
 	help
@@ -613,7 +613,7 @@ config NETFILTER_XT_MATCH_REALM
 
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
-	depends on NETFILTER_XTABLES && EXPERIMENTAL
+	depends on NETFILTER_XTABLES
 	help
 	  With this option enabled, you will be able to use the 
 	  `sctp' match in order to match on SCTP source/destination ports
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index e662f1d..a1d1c6e 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -4,7 +4,7 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 8210f54..9652abc 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig IP_SCTP
 	tristate "The SCTP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	depends on IPV6 || IPV6=n
 	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
 	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
index 3b30d11..8050597 100644
--- a/net/tipc/Kconfig
+++ b/net/tipc/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig TIPC
 	tristate "The TIPC Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	---help---
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
diff --git a/net/wanrouter/Kconfig b/net/wanrouter/Kconfig
index 1debe1c..4a7a9d4 100644
--- a/net/wanrouter/Kconfig
+++ b/net/wanrouter/Kconfig
@@ -4,7 +4,6 @@
 
 config WAN_ROUTER
 	tristate "WAN router"
-	depends on EXPERIMENTAL
 	---help---
 	  Wide Area Networks (WANs), such as X.25, frame relay and leased
 	  lines, are used to interconnect Local Area Networks (LANs) over vast
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..bfc3a06 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -4,7 +4,6 @@
 
 config X25
 	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 577a4f8..6716d9c 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -16,7 +16,7 @@ config XFRM_USER
 
 config XFRM_SUB_POLICY
 	bool "Transformation sub policy support (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	depends on XFRM
 	---help---
 	  Support sub policy for developers. By using sub policy with main
 	  one, two policies can be applied to the same packet at once.
@@ -26,7 +26,7 @@ config XFRM_SUB_POLICY
 
 config XFRM_MIGRATE
 	bool "Transformation migrate database (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	depends on XFRM
 	---help---
 	  A feature to update locator(s) of a given IPsec security
 	  association dynamically.  This feature is required, for
@@ -47,7 +47,7 @@ config NET_KEY
 
 config NET_KEY_MIGRATE
 	bool "PF_KEY MIGRATE (EXPERIMENTAL)"
-	depends on NET_KEY && EXPERIMENTAL
+	depends on NET_KEY
 	select XFRM_MIGRATE
 	---help---
 	  Add a PF_KEY MIGRATE message to PF_KEYv2 socket family.
diff --git a/security/Kconfig b/security/Kconfig
index 8086e61..7110555 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -82,7 +82,7 @@ config SECURITY_CAPABILITIES
 
 config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities (EXPERIMENTAL)"
-	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
+	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index af37cd0..b9c767c 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -26,7 +26,7 @@ config SOUND_VWSND
 
 config SOUND_HAL2
 	tristate "SGI HAL2 sound (EXPERIMENTAL)"
-	depends on SOUND_PRIME && SGI_IP22 && EXPERIMENTAL
+	depends on SOUND_PRIME && SGI_IP22
 	help
 	  Say Y or M if you have an SGI Indy or Indigo2 system and want to be able to
 	  use its on-board A2 audio system.
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 356bf21..411ef33 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -124,7 +124,7 @@ config SND_AU8830
 
 config SND_AZT3328
 	tristate "Aztech AZF3328 / PCI168 (EXPERIMENTAL)"
-	depends on SND && EXPERIMENTAL
+	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -583,7 +583,7 @@ config SND_HDA_GENERIC
 
 config SND_HDA_POWER_SAVE
 	bool "Aggressive power-saving on HD-audio"
-	depends on SND_HDA_INTEL && EXPERIMENTAL
+	depends on SND_HDA_INTEL
 	help
 	  Say Y here to enable more aggressive power-saving mode on
 	  HD-audio driver.  The power-saving timeout can be configured
@@ -885,7 +885,7 @@ config SND_YMFPCI_FIRMWARE_IN_KERNEL
 
 config SND_AC97_POWER_SAVE
 	bool "AC97 Power-Saving Mode"
-	depends on SND_AC97_CODEC && EXPERIMENTAL
+	depends on SND_AC97_CODEC
 	default n
 	help
 	  Say Y here to enable the aggressive power-saving support of

