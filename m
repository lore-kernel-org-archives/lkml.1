Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZDPHiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZDPHiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZDPHiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:38:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZDPHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:38:01 -0400
Date: Thu, 16 Apr 2009 08:36:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
Subject: Re: [RFC][PATCH 2/8] Convert arm to use arch_getoffset()
	infrastructure.
Message-ID: <20090416073639.GA7232@flint.arm.linux.org.uk>
References: <1239759163.6064.25.camel@localhost> <1239759251.6064.27.camel@localhost> <1239759393.6064.30.camel@localhost> <1239759551.6064.33.camel@localhost> <1239759668.6064.35.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239759668.6064.35.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You really need to also post this (and the generic part) to the
linux-arm-kernel mailing list; there's far too much here for one
person (me) to deal with.

On Tue, Apr 14, 2009 at 06:41:08PM -0700, john stultz wrote:
> This patch converts arm to use GENERIC_TIME via the arch_getoffset()
> infrastructure 
> 
> I do not have cross compilers for these architectures, and in some cases
> the architectures can be compiles both with and without clocksources. So
> I've taken my best swing at converting this, but I'm not confident I got
> it right. Any assistance from arch maintainers or testers would be
> great.
> 
> NOT FOR INCLUSION
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e02b893..61c88e1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -38,7 +38,7 @@ config GENERIC_GPIO
>  
>  config GENERIC_TIME
>  	bool
> -	default n
> +	default y
>  
>  config GENERIC_CLOCKEVENTS
>  	bool
> @@ -203,6 +203,7 @@ config ARCH_AAEC2000
>  	select CPU_ARM920T
>  	select ARM_AMBA
>  	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This enables support for systems based on the Agilent AAEC-2000
>  
> @@ -212,6 +213,7 @@ config ARCH_INTEGRATOR
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
>  	select ICST525
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for ARM's Integrator platform.
>  
> @@ -221,7 +223,6 @@ config ARCH_REALVIEW
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
>  	select ICST307
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	help
>  	  This enables support for ARM Ltd RealView boards.
> @@ -233,7 +234,6 @@ config ARCH_VERSATILE
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
>  	select ICST307
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	help
>  	  This enables support for ARM Ltd Versatile board.
> @@ -243,6 +243,7 @@ config ARCH_AT91
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This enables support for systems based on the Atmel AT91RM9200,
>  	  AT91SAM9 and AT91CAP9 processors.
> @@ -258,6 +259,7 @@ config ARCH_EBSA110
>  	select CPU_SA110
>  	select ISA
>  	select NO_IOPORT
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This is an evaluation board for the StrongARM processor available
>  	  from Digital. It has limited hardware on-board, including an
> @@ -273,6 +275,7 @@ config ARCH_EP93XX
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
>  	select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This enables support for the Cirrus EP93xx series of CPUs.
>  
> @@ -288,6 +291,7 @@ config ARCH_FOOTBRIDGE
>  	bool "FootBridge"
>  	select CPU_SA110
>  	select FOOTBRIDGE
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for systems based on the DC21285 companion chip
>  	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
> @@ -297,7 +301,6 @@ config ARCH_NETX
>  	select CPU_ARM926T
>  	select ARM_VIC
>  	select GENERIC_CLOCKEVENTS
> -	select GENERIC_TIME
>  	help
>  	  This enables support for systems based on the Hilscher NetX Soc
>  
> @@ -305,6 +308,7 @@ config ARCH_H720X
>  	bool "Hynix HMS720x-based"
>  	select CPU_ARM720T
>  	select ISA_DMA_API
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This enables support for systems based on the Hynix HMS720x
>  
> @@ -312,7 +316,6 @@ config ARCH_IMX
>  	bool "IMX"
>  	select CPU_ARM920T
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	help
>  	  Support for Motorola's i.MX family of processors (MX1, MXL).
> @@ -325,6 +328,7 @@ config ARCH_IOP13XX
>  	select PCI
>  	select ARCH_SUPPORTS_MSI
>  	select VMSPLIT_1G
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Intel's IOP13XX (XScale) family of processors.
>  
> @@ -336,6 +340,7 @@ config ARCH_IOP32X
>  	select PCI
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Intel's 80219 and IOP32X (XScale) family of
>  	  processors.
> @@ -348,6 +353,7 @@ config ARCH_IOP33X
>  	select PCI
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Intel's IOP33X (XScale) family of processors.
>  
> @@ -356,6 +362,7 @@ config ARCH_IXP23XX
>  	depends on MMU
>  	select CPU_XSC3
>   	select PCI
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Intel's IXP23xx (XScale) family of processors.
>  
> @@ -364,6 +371,7 @@ config ARCH_IXP2000
>  	depends on MMU
>  	select CPU_XSCALE
>  	select PCI
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Intel's IXP2400/2800 (XScale) family of processors.
>  
> @@ -372,7 +380,6 @@ config ARCH_IXP4XX
>  	depends on MMU
>  	select CPU_XSCALE
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select DMABOUNCE if PCI
>  	help
> @@ -382,6 +389,7 @@ config ARCH_L7200
>  	bool "LinkUp-L7200"
>  	select CPU_ARM720T
>  	select FIQ
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Say Y here if you intend to run this kernel on a LinkUp Systems
>  	  L7200 Software Development Board which uses an ARM720T processor.
> @@ -397,7 +405,6 @@ config ARCH_KIRKWOOD
>  	select CPU_FEROCEON
>  	select PCI
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select PLAT_ORION
>  	help
> @@ -409,6 +416,7 @@ config ARCH_KS8695
>  	select CPU_ARM922T
>  	select GENERIC_GPIO
>          select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
>  	  System-on-Chip devices.
> @@ -417,7 +425,6 @@ config ARCH_NS9XXX
>  	bool "NetSilicon NS9xxx"
>  	select CPU_ARM926T
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
>  	help
> @@ -429,7 +436,6 @@ config ARCH_NS9XXX
>  config ARCH_LOKI
>  	bool "Marvell Loki (88RC8480)"
>  	select CPU_FEROCEON
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select PLAT_ORION
>  	help
> @@ -440,7 +446,6 @@ config ARCH_MV78XX0
>  	select CPU_FEROCEON
>  	select PCI
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select PLAT_ORION
>  	help
> @@ -449,7 +454,6 @@ config ARCH_MV78XX0
>  
>  config ARCH_MXC
>  	bool "Freescale MXC/iMX-based"
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select ARCH_MTD_XIP
>  	select GENERIC_GPIO
> @@ -463,7 +467,6 @@ config ARCH_ORION5X
>  	select CPU_FEROCEON
>  	select PCI
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select PLAT_ORION
>  	help
> @@ -475,6 +478,7 @@ config ARCH_PNX4008
>  	bool "Philips Nexperia PNX4008 Mobile"
>  	select CPU_ARM926T
>  	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  This enables support for Philips PNX4008 mobile platform.
>  
> @@ -488,7 +492,6 @@ config ARCH_PXA
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select TICK_ONESHOT
>  	select PLAT_PXA
> @@ -502,7 +505,6 @@ config ARCH_MMP
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select TICK_ONESHOT
>  	select PLAT_PXA
> @@ -519,6 +521,7 @@ config ARCH_RPC
>  	select ISA_DMA_API
>  	select NO_IOPORT
>  	select ARCH_SPARSEMEM_ENABLE
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
>  	  CD-ROM interface, serial and parallel port, and the floppy drive.
> @@ -530,7 +533,6 @@ config ARCH_SA1100
>  	select ARCH_SPARSEMEM_ENABLE
>  	select ARCH_MTD_XIP
>  	select GENERIC_GPIO
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
>  	select TICK_ONESHOT
> @@ -542,6 +544,7 @@ config ARCH_S3C2410
>  	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
>  	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
> @@ -551,6 +554,7 @@ config ARCH_S3C64XX
>  	bool "Samsung S3C64XX"
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Samsung S3C64XX series based systems
>  
> @@ -561,6 +565,7 @@ config ARCH_SHARK
>  	select ISA_DMA
>  	select ZONE_DMA
>  	select PCI
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Support for the StrongARM based Digital DNARD machine, also known
>  	  as "Shark" (<http://www.shark-linux.de/shark.html>).
> @@ -570,6 +575,7 @@ config ARCH_LH7A40X
>  	select CPU_ARM922T
>  	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
>  	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  	  Say Y here for systems based on one of the Sharp LH7A40X
>  	  System on a Chip processors.  These CPUs include an ARM922T
> @@ -579,7 +585,6 @@ config ARCH_LH7A40X
>  config ARCH_DAVINCI
>  	bool "TI DaVinci"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
> @@ -593,7 +598,6 @@ config ARCH_OMAP
>  	select GENERIC_GPIO
>  	select HAVE_CLK
>  	select ARCH_REQUIRE_GPIOLIB
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	help
>  	  Support for TI's OMAP platform (OMAP1 and OMAP2).
> @@ -601,7 +605,6 @@ config ARCH_OMAP
>  config ARCH_MSM
>  	bool "Qualcomm MSM"
>  	select CPU_V6
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  	help
>  	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
> @@ -612,6 +615,7 @@ config ARCH_MSM
>  config ARCH_W90X900
>  	bool "Nuvoton W90X900 CPU"
>  	select CPU_ARM926T
> +	select ARCH_USES_GETTIMEOFFSET
>  	help
>  		Support for Nuvoton (Winbond logic dept.) ARM9 processor,You
>  		can login www.mcuos.com or www.nuvoton.com to know more.
> diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
> index b2cc1fc..20c1d84 100644
> --- a/arch/arm/include/asm/mach/time.h
> +++ b/arch/arm/include/asm/mach/time.h
> @@ -38,7 +38,7 @@ struct sys_timer {
>  	void			(*init)(void);
>  	void			(*suspend)(void);
>  	void			(*resume)(void);
> -#ifndef CONFIG_GENERIC_TIME
> +#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
>  	unsigned long		(*offset)(void);
>  #endif
>  };
> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> index 4cdc4a0..d9d8d6d 100644
> --- a/arch/arm/kernel/time.c
> +++ b/arch/arm/kernel/time.c
> @@ -81,7 +81,7 @@ EXPORT_SYMBOL(profile_pc);
>   */
>  int (*set_rtc)(void);
>  
> -#ifndef CONFIG_GENERIC_TIME
> +#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
>  static unsigned long dummy_gettimeoffset(void)
>  {
>  	return 0;
> @@ -236,63 +236,12 @@ static inline void do_leds(void)
>  #define	do_leds()
>  #endif
>  
> -#ifndef CONFIG_GENERIC_TIME
> -void do_gettimeofday(struct timeval *tv)
> +#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
> +u32 arch_gettimeoffset(void)
>  {
> -	unsigned long flags;
> -	unsigned long seq;
> -	unsigned long usec, sec;
> -
> -	do {
> -		seq = read_seqbegin_irqsave(&xtime_lock, flags);
> -		usec = system_timer->offset();
> -		sec = xtime.tv_sec;
> -		usec += xtime.tv_nsec / 1000;
> -	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
> -
> -	/* usec may have gone up a lot: be safe */
> -	while (usec >= 1000000) {
> -		usec -= 1000000;
> -		sec++;
> -	}
> -
> -	tv->tv_sec = sec;
> -	tv->tv_usec = usec;
> -}
> -
> -EXPORT_SYMBOL(do_gettimeofday);
> -
> -int do_settimeofday(struct timespec *tv)
> -{
> -	time_t wtm_sec, sec = tv->tv_sec;
> -	long wtm_nsec, nsec = tv->tv_nsec;
> -
> -	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
> -		return -EINVAL;
> -
> -	write_seqlock_irq(&xtime_lock);
> -	/*
> -	 * This is revolting. We need to set "xtime" correctly. However, the
> -	 * value in this location is the value at the most recent update of
> -	 * wall time.  Discover what correction gettimeofday() would have
> -	 * done, and then undo it!
> -	 */
> -	nsec -= system_timer->offset() * NSEC_PER_USEC;
> -
> -	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
> -	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
> -
> -	set_normalized_timespec(&xtime, sec, nsec);
> -	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
> -
> -	ntp_clear();
> -	write_sequnlock_irq(&xtime_lock);
> -	clock_was_set();
> -	return 0;
> +	return system_timer->offset() * 1000;
>  }
> -
> -EXPORT_SYMBOL(do_settimeofday);
> -#endif /* !CONFIG_GENERIC_TIME */
> +#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
>  
>  /**
>   * save_time_delta - Save the offset between system time and RTC time
> @@ -391,7 +340,7 @@ device_initcall(timer_init_sysfs);
>  
>  void __init time_init(void)
>  {
> -#ifndef CONFIG_GENERIC_TIME
> +#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
>  	if (system_timer->offset == NULL)
>  		system_timer->offset = dummy_gettimeoffset;
>  #endif
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 323b47f..e82979c 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -8,47 +8,41 @@ choice
>  config ARCH_AT91RM9200
>  	bool "AT91RM9200"
>  	select CPU_ARM920T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91SAM9260
>  	bool "AT91SAM9260 or AT91SAM9XE"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91SAM9261
>  	bool "AT91SAM9261"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91SAM9263
>  	bool "AT91SAM9263"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91SAM9RL
>  	bool "AT91SAM9RL"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91SAM9G20
>  	bool "AT91SAM9G20"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91CAP9
>  	bool "AT91CAP9"
>  	select CPU_ARM926T
> -	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
>  
>  config ARCH_AT91X40
>  	bool "AT91x40"
> +	select ARCH_USES_GETTIMEOFFSET
>  
>  endchoice
>  
> 
> 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
