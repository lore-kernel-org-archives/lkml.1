Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbYBGUfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbYBGUfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYBGUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:35:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42366 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYBGUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:35:19 -0500
Date: Thu, 7 Feb 2008 20:29:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207202940.GI28435@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz> <20080207160557.GB28435@flint.arm.linux.org.uk> <20080207202329.GA21949@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207202329.GA21949@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 09:23:29PM +0100, Sam Ravnborg wrote:
> +# if PCMCIA is selected then we need IDE
> +config ARM_PCMCIA
> +	depends on PCMCIA

Shouldn't this be:

	def_bool PCMCIA

?

> +	select HAVE_IDE

Also, should this be something ARM specific - if you have PCMCIA you could
have a CF card plugged in, so...  There's nothing ARM specific about that.

> +
> +# select MTD except in a few corner configuration cases
> +config ARM_MTD
> +	depends on ALIGNMENT_TRAP || !CPU_CP15_MMU

Ditto.

> +	select HAVE_MTD
> +
>  config GENERIC_GPIO
>  	bool
>  	default n
> @@ -219,6 +229,7 @@ config ARCH_CLPS7500
>  	select TIMER_ACORN
>  	select ISA
>  	select NO_IOPORT
> +	select HAVE_IDE
>  	help
>  	  Support for the Cirrus Logic PS7500FE system-on-a-chip.
>  
> @@ -231,6 +242,7 @@ config ARCH_CO285
>  	bool "Co-EBSA285"
>  	select FOOTBRIDGE
>  	select FOOTBRIDGE_ADDIN
> +	select HAVE_IDE
>  	help
>  	  Support for Intel's EBSA285 companion chip.
>  
> @@ -255,6 +267,7 @@ config ARCH_EP93XX
>  config ARCH_FOOTBRIDGE
>  	bool "FootBridge"
>  	select FOOTBRIDGE
> +	select HAVE_IDE
>  	help
>  	  Support for systems based on the DC21285 companion chip
>  	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
> @@ -293,6 +306,7 @@ config ARCH_IOP32X
>  	depends on MMU
>  	select PLAT_IOP
>  	select PCI
> +	select HAVE_IDE
>  	help
>  	  Support for Intel's 80219 and IOP32X (XScale) family of
>  	  processors.
> @@ -302,12 +316,14 @@ config ARCH_IOP33X
>  	depends on MMU
>  	select PLAT_IOP
>  	select PCI
> +	select HAVE_IDE
>  	help
>  	  Support for Intel's IOP33X (XScale) family of processors.
>  
>  config ARCH_IXP23XX
>   	bool "IXP23XX-based"
>  	depends on MMU
> +	select HAVE_IDE
>   	select PCI
>  	help
>  	  Support for Intel's IXP23xx (XScale) family of processors.
> @@ -325,12 +341,14 @@ config ARCH_IXP4XX
>  	select GENERIC_GPIO
>  	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
> +	select HAVE_IDE
>  	help
>  	  Support for Intel's IXP4XX (XScale) family of processors.
>  
>  config ARCH_L7200
>  	bool "LinkUp-L7200"
>  	select FIQ
> +	select HAVE_IDE
>  	help
>  	  Say Y here if you intend to run this kernel on a LinkUp Systems
>  	  L7200 Software Development Board which uses an ARM720T processor.
> @@ -385,6 +403,7 @@ config ARCH_PXA
>  	depends on MMU
>  	select ARCH_MTD_XIP
>  	select GENERIC_GPIO
> +	select HAVE_IDE
>  	select HAVE_GPIO_LIB
>  	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
> @@ -400,6 +419,7 @@ config ARCH_RPC
>  	select ARCH_MAY_HAVE_PC_FDC
>  	select ISA_DMA_API
>  	select NO_IOPORT
> +	select HAVE_IDE
>  	help
>  	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
>  	  CD-ROM interface, serial and parallel port, and the floppy drive.
> @@ -411,12 +431,14 @@ config ARCH_SA1100
>  	select ARCH_MTD_XIP
>  	select GENERIC_GPIO
>  	select GENERIC_TIME
> +	select HAVE_IDE
>  	help
>  	  Support for StrongARM 11x0 based boards.
>  
>  config ARCH_S3C2410
>  	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
>  	select GENERIC_GPIO
> +	select HAVE_IDE
>  	help
>  	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
>  	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
> @@ -424,6 +446,7 @@ config ARCH_S3C2410
>  
>  config ARCH_SHARK
>  	bool "Shark"
> +	select HAVE_IDE
>  	select ISA
>  	select ISA_DMA
>  	select PCI
> @@ -433,6 +456,7 @@ config ARCH_SHARK
>  
>  config ARCH_LH7A40X
>  	bool "Sharp LH7A40X"
> +	select HAVE_IDE
>  	help
>  	  Say Y here for systems based on one of the Sharp LH7A40X
>  	  System on a Chip processors.  These CPUs include an ARM922T
> @@ -1076,9 +1100,7 @@ source "drivers/base/Kconfig"
>  
>  source "drivers/connector/Kconfig"
>  
> -if ALIGNMENT_TRAP || !CPU_CP15_MMU
>  source "drivers/mtd/Kconfig"
> -endif
>  
>  source "drivers/parport/Kconfig"
>  
> @@ -1090,12 +1112,7 @@ source "drivers/block/Kconfig"
>  
>  source "drivers/misc/Kconfig"
>  
> -if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
> -	|| ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
> -	|| ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
> -	|| ARCH_IXP23XX
>  source "drivers/ide/Kconfig"
> -endif
>  
>  source "drivers/scsi/Kconfig"
>  
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index 28e0caf..1be1893 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -10,6 +10,8 @@ config AVR32
>  	# With EMBEDDED=n, we get lots of stuff automatically selected
>  	# that we usually don't need on AVR32.
>  	select EMBEDDED
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	help
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index ba21e33..2c989e3 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -24,6 +24,8 @@ config RWSEM_XCHGADD_ALGORITHM
>  config BLACKFIN
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  
>  config ZONE_DMA
> diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
> index 27b082a..13c40a1 100644
> --- a/arch/cris/Kconfig
> +++ b/arch/cris/Kconfig
> @@ -54,6 +54,8 @@ config NO_IOPORT
>  config CRIS
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  source "init/Kconfig"
>  
> diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
> index 96f7d70..08f4332 100644
> --- a/arch/frv/Kconfig
> +++ b/arch/frv/Kconfig
> @@ -5,6 +5,8 @@
>  config FRV
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  config ZONE_DMA
>  	bool
> diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> index dc61222..5f12412 100644
> --- a/arch/h8300/Kconfig
> +++ b/arch/h8300/Kconfig
> @@ -8,6 +8,8 @@ mainmenu "uClinux/h8300 (w/o MMU) Kernel Configuration"
>  config H8300
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  config MMU
>  	bool
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index b0de113..765c17a 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -15,6 +15,8 @@ config IA64
>  	select ACPI if (!IA64_HP_SIM)
>  	select PM if (!IA64_HP_SIM)
>  	select ARCH_SUPPORTS_MSI
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	default y
> diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
> index 795180b..4615ead 100644
> --- a/arch/m32r/Kconfig
> +++ b/arch/m32r/Kconfig
> @@ -8,6 +8,8 @@ mainmenu "Linux/M32R Kernel Configuration"
>  config M32R
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  
>  config SBUS
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index ffabd01..182c798 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -5,6 +5,8 @@
>  config M68K
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  config MMU
>  	bool
> diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
> index 6abbbb8..8008f4d 100644
> --- a/arch/m68knommu/Kconfig
> +++ b/arch/m68knommu/Kconfig
> @@ -8,6 +8,8 @@ mainmenu "uClinux/68k (w/o MMU) Kernel Configuration"
>  config M68K
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  config MMU
>  	bool
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ec78a57..13d36c8 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -1,6 +1,8 @@
>  config MIPS
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	# Horrible source of confusion.  Die, die, die ...
>  	select EMBEDDED
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index 028d8a0..8511f43 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -7,6 +7,8 @@ mainmenu "Linux/PA-RISC Kernel Configuration"
>  
>  config PARISC
>  	def_bool y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	help
>  	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 8dcac0b..8038ab7 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -87,6 +87,8 @@ config ARCH_NO_VIRT_TO_BUS
>  config PPC
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  
> diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
> index 531156f..11ea57e 100644
> --- a/arch/ppc/Kconfig
> +++ b/arch/ppc/Kconfig
> @@ -42,6 +42,8 @@ config GENERIC_CALIBRATE_DELAY
>  config PPC
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 1c3a908..29890ac 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -8,6 +8,8 @@ mainmenu "Linux/SuperH Kernel Configuration"
>  config SUPERH
>  	def_bool y
>  	select EMBEDDED
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	help
>  	  The SuperH is a RISC processor targeted for use in embedded systems
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 99f8971..e51bbdd 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -62,6 +62,8 @@ config NR_CPUS
>  config SPARC
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  
>  # Identify this as a Sparc32 build
> diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
> index a8c6366..9d60b26 100644
> --- a/arch/sparc64/Kconfig
> +++ b/arch/sparc64/Kconfig
> @@ -14,6 +14,8 @@ config SPARC
>  config SPARC64
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	help
>  	  SPARC is a family of RISC microprocessors designed and marketed by
>  	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
> diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
> index ace479a..9317fd1 100644
> --- a/arch/v850/Kconfig
> +++ b/arch/v850/Kconfig
> @@ -75,6 +75,8 @@ config MCA
>  config V850
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  
>  menu "Processor type and features"
>  
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c95482b..cc20002 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -18,6 +18,8 @@ config X86_64
>  ### Arch settings
>  config X86
>  	def_bool y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index 5d5546c..e438ab2 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -14,6 +14,8 @@ config ZONE_DMA
>  config XTENSA
>  	bool
>  	default y
> +	select HAVE_IDE
> +	select HAVE_MTD
>  	help
>  	  Xtensa processors are 32-bit RISC machines designed by Tensilica
>  	  primarily for embedded systems.  These processors are both
> diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
> index ab8fb25..043c34a 100644
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -4,10 +4,14 @@
>  # Andre Hedrick <andre@linux-ide.org>
>  #
>  
> +# Select HAVE_IDE if IDE is supported
> +config HAVE_IDE
> +	def_bool n
> +
>  menuconfig IDE
>  	tristate "ATA/ATAPI/MFM/RLL support"
> +	depends on HAVE_IDE
>  	depends on BLOCK
> -	depends on HAS_IOMEM
>  	---help---
>  	  If you say Y here, your kernel will be able to manage low cost mass
>  	  storage units such as ATA/(E)IDE and ATAPI units. The most common
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index e850334..9365d8b 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -1,8 +1,11 @@
>  # $Id: Kconfig,v 1.11 2005/11/07 11:14:19 gleixner Exp $
>  
> +# select if MTD is supported
> +config HAVE_MTD
> +	def_bool n
> +
>  menuconfig MTD
>  	tristate "Memory Technology Device (MTD) support"
> -	depends on HAS_IOMEM
>  	help
>  	  Memory Technology Devices are flash, RAM and similar chips, often
>  	  used for solid state file systems on embedded devices. This option
