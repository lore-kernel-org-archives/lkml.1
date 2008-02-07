Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbYBGVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbYBGVnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbYBGVm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:42:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41174 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbYBGVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:42:52 -0500
Date: Thu, 7 Feb 2008 22:42:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>, linux-ide@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC] Introduce HAVE_IDE to support flexible IDE per arch configuration
Message-ID: <20080207214256.GA22572@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch introduce HAVE_IDE to support flexible per
arch or even per. sub-arch configuration of IDE support.
This patch is needed to allow arm to use the generic
drivers/Kconfig file.

Introducing HAVE_IDE so each arch explicit select HAVE_IDE
if supported allowed us to get rid of HAS_IOMEM which
is anyway overloaded.
And doing it this way is a much better way to document which
architectures that supports IDE.
Furthermore the decision if IDE is supported or not is
distributed.
Consider seeing this all over:

-if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
-       || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
-       || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
-       || ARCH_IXP23XX
 source "drivers/ide/Kconfig"
-endif

Only s390 and um does not support IDE from my quick
investigation, if there are others let me know.
[Added linux-arch to catch all arch maintainers].

Comments?

	Sam

>From 085cc6a6b7781961ce0f5df9876e4b0a40ee2eb8 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 7 Feb 2008 22:27:10 +0100
Subject: [PATCH] ide: introduce HAVE_IDE

To allow flexible configuration of IDE introduce HAVE_IDE.
All archs except arm, um and s390 unconditionally select it.
For arm the actual configuration determine if IDE is supported.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/alpha/Kconfig     |    1 +
 arch/arm/Kconfig       |   19 ++++++++++++++-----
 arch/avr32/Kconfig     |    1 +
 arch/blackfin/Kconfig  |    1 +
 arch/cris/Kconfig      |    1 +
 arch/frv/Kconfig       |    1 +
 arch/h8300/Kconfig     |    1 +
 arch/ia64/Kconfig      |    1 +
 arch/m32r/Kconfig      |    1 +
 arch/m68k/Kconfig      |    1 +
 arch/m68knommu/Kconfig |    1 +
 arch/mips/Kconfig      |    1 +
 arch/parisc/Kconfig    |    1 +
 arch/powerpc/Kconfig   |    1 +
 arch/ppc/Kconfig       |    1 +
 arch/sh/Kconfig        |    1 +
 arch/sparc/Kconfig     |    1 +
 arch/sparc64/Kconfig   |    1 +
 arch/v850/Kconfig      |    1 +
 arch/x86/Kconfig       |    1 +
 arch/xtensa/Kconfig    |    1 +
 drivers/ide/Kconfig    |    6 +++++-
 drivers/pcmcia/Kconfig |    1 +
 23 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 01b10ab..e0ebbf8 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e19e774..c087359 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -219,6 +219,7 @@ config ARCH_CLPS7500
 	select TIMER_ACORN
 	select ISA
 	select NO_IOPORT
+	select HAVE_IDE
 	help
 	  Support for the Cirrus Logic PS7500FE system-on-a-chip.
 
@@ -231,6 +232,7 @@ config ARCH_CO285
 	bool "Co-EBSA285"
 	select FOOTBRIDGE
 	select FOOTBRIDGE_ADDIN
+	select HAVE_IDE
 	help
 	  Support for Intel's EBSA285 companion chip.
 
@@ -255,6 +257,7 @@ config ARCH_EP93XX
 config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select FOOTBRIDGE
+	select HAVE_IDE
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -293,6 +296,7 @@ config ARCH_IOP32X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
+	select HAVE_IDE
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -302,12 +306,14 @@ config ARCH_IOP33X
 	depends on MMU
 	select PLAT_IOP
 	select PCI
+	select HAVE_IDE
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
 config ARCH_IXP23XX
  	bool "IXP23XX-based"
 	depends on MMU
+	select HAVE_IDE
  	select PCI
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
@@ -325,12 +331,14 @@ config ARCH_IXP4XX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_IDE
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
 
 config ARCH_L7200
 	bool "LinkUp-L7200"
 	select FIQ
+	select HAVE_IDE
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -385,6 +393,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
+	select HAVE_IDE
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -400,6 +409,7 @@ config ARCH_RPC
 	select ARCH_MAY_HAVE_PC_FDC
 	select ISA_DMA_API
 	select NO_IOPORT
+	select HAVE_IDE
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -411,12 +421,14 @@ config ARCH_SA1100
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
 	select GENERIC_TIME
+	select HAVE_IDE
 	help
 	  Support for StrongARM 11x0 based boards.
 
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
+	select HAVE_IDE
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -424,6 +436,7 @@ config ARCH_S3C2410
 
 config ARCH_SHARK
 	bool "Shark"
+	select HAVE_IDE
 	select ISA
 	select ISA_DMA
 	select PCI
@@ -433,6 +446,7 @@ config ARCH_SHARK
 
 config ARCH_LH7A40X
 	bool "Sharp LH7A40X"
+	select HAVE_IDE
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -1090,12 +1104,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/misc/Kconfig"
 
-if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
-	|| ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
-	|| ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
-	|| ARCH_IXP23XX
 source "drivers/ide/Kconfig"
-endif
 
 source "drivers/scsi/Kconfig"
 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 28e0caf..c75d708 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index ba21e33..20f4e37 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 config ZONE_DMA
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 27b082a..7d451cd 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -54,6 +54,7 @@ config NO_IOPORT
 config CRIS
 	bool
 	default y
+	select HAVE_IDE
 
 source "init/Kconfig"
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 96f7d70..10d5aeb 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -5,6 +5,7 @@
 config FRV
 	bool
 	default y
+	select HAVE_IDE
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index dc61222..5631c6b 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -8,6 +8,7 @@ mainmenu "uClinux/h8300 (w/o MMU) Kernel Configuration"
 config H8300
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index b0de113..2d4fcd0 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 795180b..672817e 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuration"
 config M32R
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 config SBUS
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index ffabd01..d182ade 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -5,6 +5,7 @@
 config M68K
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 6abbbb8..cb5bb88 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -8,6 +8,7 @@ mainmenu "uClinux/68k (w/o MMU) Kernel Configuration"
 config M68K
 	bool
 	default y
+	select HAVE_IDE
 
 config MMU
 	bool
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ec78a57..ade230d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 028d8a0..f541d7d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configuration"
 
 config PARISC
 	def_bool y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8dcac0b..1235a2e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,6 +87,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index 531156f..abc877f 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -42,6 +42,7 @@ config GENERIC_CALIBRATE_DELAY
 config PPC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1c3a908..8542b00 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configuration"
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 99f8971..5ae42d8 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -62,6 +62,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 
 # Identify this as a Sparc32 build
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index a8c6366..cc344d4 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -14,6 +14,7 @@ config SPARC
 config SPARC64
 	bool
 	default y
+	select HAVE_IDE
 	help
 	  SPARC is a family of RISC microprocessors designed and marketed by
 	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index ace479a..5986ee5 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -75,6 +75,7 @@ config MCA
 config V850
 	bool
 	default y
+	select HAVE_IDE
 
 menu "Processor type and features"
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c95482b..e3e7ef6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -18,6 +18,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 5d5546c..98c5ebd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -14,6 +14,7 @@ config ZONE_DMA
 config XTENSA
 	bool
 	default y
+	select HAVE_IDE
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index ab8fb25..043c34a 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -4,10 +4,14 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
+# Select HAVE_IDE if IDE is supported
+config HAVE_IDE
+	def_bool n
+
 menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on HAVE_IDE
 	depends on BLOCK
-	depends on HAS_IOMEM
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 519b4ff..8b22281 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,6 +38,7 @@ config PCMCIA_DEBUG
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
+	select HAVE_IDE
 	default y
 	---help---
 	   This option enables support for 16-bit PCMCIA cards. Most older
-- 
1.5.4.rc3.14.g44397

