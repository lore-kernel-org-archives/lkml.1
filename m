Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZA2EHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZA2EHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZA2EH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:07:26 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35294 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZA2EHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:07:24 -0500
Subject: [RFC][PATCH 2/10] Convert arm to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233201995.6895.27.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:07:17 -0800
Message-Id: <1233202037.6895.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts arm to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dbfdf87..3c04f80 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,7 +38,7 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
-	default n
+	default y
 
 config GENERIC_CLOCKEVENTS
 	bool
@@ -203,6 +203,7 @@ config ARCH_AAEC2000
 	select CPU_ARM920T
 	select ARM_AMBA
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
@@ -212,6 +213,7 @@ config ARCH_INTEGRATOR
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST525
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for ARM's Integrator platform.
 
@@ -221,7 +223,6 @@ config ARCH_REALVIEW
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables support for ARM Ltd RealView boards.
@@ -233,7 +234,6 @@ config ARCH_VERSATILE
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables support for ARM Ltd Versatile board.
@@ -242,6 +242,7 @@ config ARCH_AT91
 	bool "Atmel AT91"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -257,6 +258,7 @@ config ARCH_EBSA110
 	select CPU_SA110
 	select ISA
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -272,6 +274,7 @@ config ARCH_EP93XX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -279,6 +282,7 @@ config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select CPU_SA110
 	select FOOTBRIDGE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -288,7 +292,6 @@ config ARCH_NETX
 	select CPU_ARM926T
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
@@ -296,6 +299,7 @@ config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select CPU_ARM720T
 	select ISA_DMA_API
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Hynix HMS720x
 
@@ -303,7 +307,6 @@ config ARCH_IMX
 	bool "IMX"
 	select CPU_ARM920T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Motorola's i.MX family of processors (MX1, MXL).
@@ -316,6 +319,7 @@ config ARCH_IOP13XX
 	select PCI
 	select ARCH_SUPPORTS_MSI
 	select VMSPLIT_1G
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
@@ -327,6 +331,7 @@ config ARCH_IOP32X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -339,6 +344,7 @@ config ARCH_IOP33X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
@@ -347,6 +353,7 @@ config ARCH_IXP23XX
 	depends on MMU
 	select CPU_XSC3
  	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
 
@@ -355,6 +362,7 @@ config ARCH_IXP2000
 	depends on MMU
 	select CPU_XSCALE
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP2400/2800 (XScale) family of processors.
 
@@ -363,7 +371,6 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CPU_XSCALE
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -373,6 +380,7 @@ config ARCH_L7200
 	bool "LinkUp-L7200"
 	select CPU_ARM720T
 	select FIQ
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -388,7 +396,6 @@ config ARCH_KIRKWOOD
 	select CPU_FEROCEON
 	select PCI
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -400,6 +407,7 @@ config ARCH_KS8695
 	select CPU_ARM922T
 	select GENERIC_GPIO
         select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
 	  System-on-Chip devices.
@@ -408,7 +416,6 @@ config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select CPU_ARM926T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -420,7 +427,6 @@ config ARCH_NS9XXX
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
 	select CPU_FEROCEON
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -431,7 +437,6 @@ config ARCH_MV78XX0
 	select CPU_FEROCEON
 	select PCI
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -440,7 +445,6 @@ config ARCH_MV78XX0
 
 config ARCH_MXC
 	bool "Freescale MXC/iMX-based"
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
@@ -454,7 +458,6 @@ config ARCH_ORION5X
 	select CPU_FEROCEON
 	select PCI
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -466,6 +469,7 @@ config ARCH_PNX4008
 	bool "Philips Nexperia PNX4008 Mobile"
 	select CPU_ARM926T
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -477,7 +481,6 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
@@ -493,6 +496,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -504,7 +508,6 @@ config ARCH_SA1100
 	select ARCH_SPARSEMEM_ENABLE
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -516,6 +519,7 @@ config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -525,6 +529,7 @@ config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C64XX series based systems
 
@@ -535,6 +540,7 @@ config ARCH_SHARK
 	select ISA_DMA
 	select ZONE_DMA
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -544,6 +550,7 @@ config ARCH_LH7A40X
 	select CPU_ARM922T
 	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
 	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -553,7 +560,6 @@ config ARCH_LH7A40X
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -567,7 +573,6 @@ config ARCH_OMAP
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
@@ -575,7 +580,6 @@ config ARCH_OMAP
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select CPU_V6
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -586,6 +590,7 @@ config ARCH_MSM
 config ARCH_W90X900
 	bool "Nuvoton W90X900 CPU"
 	select CPU_ARM926T
+	select ARCH_USES_GETTIMEOFFSET
 	help
 		Support for Nuvoton (Winbond logic dept.) ARM9 processor,You
 		can login www.mcuos.com or www.nuvoton.com to know more.
@@ -1338,3 +1343,6 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+
+
diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index b2cc1fc..20c1d84 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -38,7 +38,7 @@ struct sys_timer {
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long		(*offset)(void);
 #endif
 };
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index c68b44a..49cdcc7 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(profile_pc);
  */
 int (*set_rtc)(void);
 
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 static unsigned long dummy_gettimeoffset(void)
 {
 	return 0;
@@ -227,63 +227,12 @@ static inline void do_leds(void)
 #define	do_leds()
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = system_timer->offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	/* usec may have gone up a lot: be safe */
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * done, and then undo it!
-	 */
-	nsec -= system_timer->offset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return system_timer->offset() * 1000;
 }
-
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 /**
  * save_time_delta - Save the offset between system time and RTC time
@@ -382,7 +331,7 @@ device_initcall(timer_init_sysfs);
 
 void __init time_init(void)
 {
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	if (system_timer->offset == NULL)
 		system_timer->offset = dummy_gettimeoffset;
 #endif
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 323b47f..e82979c 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -8,47 +8,41 @@ choice
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select CPU_ARM920T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91X40
 	bool "AT91x40"
+	select ARCH_USES_GETTIMEOFFSET
 
 endchoice
 


