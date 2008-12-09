Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYLIDvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYLIDvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLIDvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:51:16 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60395 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYLIDvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:51:13 -0500
Subject: [RFC][PATCH 2/3] Convert !GENERIC_TIME arches to use
	arch_getoffset() infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1228794627.6918.59.camel@localhost.localdomain>
References: <1228794561.6918.57.camel@localhost.localdomain>
	 <1228794627.6918.59.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:51:07 -0800
Message-Id: <1228794667.6918.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the following arches to use the arch_getoffset()
infrastructure, finally bringing them into the GENERIC_TIME fold:

arm
blackfin
cris
m32r
m68k
sh
sparc
xtensa

I have split out patches for each arch, but I'm sending out the
megapatch to keep the RFC patchlist short.

I do not have cross compilers for these architectures, and in some cases
(like arm, and sh) the architectures can be compiles both with and
without clocksources. So I've taken my best swing at converting this,
but I'm not confident I got it right. Any assistance from arch
maintainers or testers would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9722f8b..ed4c53b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,6 +38,10 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
+	default y
+
+config USES_CLOCKSOURCES
+	bool
 	default n
 
 config GENERIC_CLOCKEVENTS
@@ -219,7 +223,7 @@ config ARCH_REALVIEW
 	select ARM_AMBA
 	select HAVE_CLK
 	select ICST307
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables support for ARM Ltd RealView boards.
@@ -230,7 +234,7 @@ config ARCH_VERSATILE
 	select ARM_VIC
 	select HAVE_CLK
 	select ICST307
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables support for ARM Ltd Versatile board.
@@ -299,7 +303,7 @@ config ARCH_H720X
 config ARCH_IMX
 	bool "IMX"
 	select GENERIC_GPIO
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Motorola's i.MX family of processors (MX1, MXL).
@@ -353,7 +357,7 @@ config ARCH_IXP4XX
 	bool "IXP4xx-based"
 	depends on MMU
 	select GENERIC_GPIO
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -375,7 +379,7 @@ config ARCH_L7200
 config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
 	select PCI
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -392,7 +396,7 @@ config ARCH_KS8695
 config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select GENERIC_GPIO
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -403,7 +407,7 @@ config ARCH_NS9XXX
 
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -412,7 +416,7 @@ config ARCH_LOKI
 config ARCH_MV78XX0
 	bool "Marvell MV78xx0"
 	select PCI
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -421,7 +425,7 @@ config ARCH_MV78XX0
 
 config ARCH_MXC
 	bool "Freescale MXC/iMX-based"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
@@ -434,7 +438,7 @@ config ARCH_ORION5X
 	depends on MMU
 	select PCI
 	select GENERIC_GPIO
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -455,7 +459,7 @@ config ARCH_PXA
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
@@ -481,7 +485,7 @@ config ARCH_SA1100
 	select ARCH_SPARSEMEM_ENABLE
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -520,7 +524,7 @@ config ARCH_LH7A40X
 
 config ARCH_DAVINCI
 	bool "TI DaVinci"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -534,14 +538,14 @@ config ARCH_OMAP
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
 config ARCH_MSM
 	bool "Qualcomm MSM"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -1287,3 +1291,8 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+	depends on !USES_CLOCKSOURCES
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
index 5aafb2e..3b3815b 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -7,37 +7,37 @@ choice
 
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
-	select GENERIC_TIME
+	select USES_CLOCKSOURCES
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91X40
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 29e71ed..38e8996 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -458,8 +458,7 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
@@ -479,6 +478,10 @@ config CYCLES_CLOCKSOURCE
 	  still be able to read it (such as for performance monitoring), but
 	  writing the registers will most likely crash the kernel.
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !CYCLES_CLOCKSOURCE
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index eb23523..6298628 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -42,7 +42,6 @@
 #define	TICK_SIZE (tick_nsec / 1000)
 
 static void time_sched_init(irq_handler_t timer_routine);
-static unsigned long gettimeoffset(void);
 
 static struct irqaction bfin_timer_irq = {
 	.name = "BFIN Timer Tick",
@@ -79,27 +78,6 @@ time_sched_init(irq_handler_t timer_routine)
 	setup_irq(IRQ_CORETMR, &bfin_timer_irq);
 }
 
-/*
- * Should return useconds since last timer tick
- */
-static unsigned long gettimeoffset(void)
-{
-	unsigned long offset;
-	unsigned long clocks_per_jiffy;
-
-	clocks_per_jiffy = bfin_read_TPERIOD();
-	offset =
-	    (clocks_per_jiffy -
-	     bfin_read_TCOUNT()) / (((clocks_per_jiffy + 1) * HZ) /
-				    USEC_PER_SEC);
-
-	/* Check if we just wrapped the counters and maybe missed a tick */
-	if ((bfin_read_ILAT() & (1 << IRQ_CORETMR))
-	    && (offset < (100000 / HZ / 2)))
-		offset += (USEC_PER_SEC / HZ);
-
-	return offset;
-}
 
 static inline int set_rtc_mmss(unsigned long nowtime)
 {
@@ -176,64 +154,29 @@ void __init time_init(void)
 	time_sched_init(timer_interrupt);
 }
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = gettimeoffset();
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / NSEC_PER_USEC);
-	}
-	while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= USEC_PER_SEC) {
-		usec -= USEC_PER_SEC;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+/*
+ * Should return nseconds since last timer tick
+ */
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= (gettimeoffset() * NSEC_PER_USEC);
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+	unsigned long offset;
+	unsigned long clocks_per_jiffy;
 
-	ntp_clear();
+	clocks_per_jiffy = bfin_read_TPERIOD();
+	offset =
+	    (clocks_per_jiffy -
+	     bfin_read_TCOUNT()) / (((clocks_per_jiffy + 1) * HZ) /
+				    USEC_PER_SEC);
 
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	/* Check if we just wrapped the counters and maybe missed a tick */
+	if ((bfin_read_ILAT() & (1 << IRQ_CORETMR))
+	    && (offset < (100000 / HZ / 2)))
+		offset += (USEC_PER_SEC / HZ);
 
-	return 0;
+	return offset*1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 /*
  * Scheduler clock - returns current time in nanosec units.
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b17aeea..edf8f7f 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -20,6 +20,12 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 config GENERIC_IOMAP
        bool
        default y
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 074fe7d..a05dd31 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -42,75 +42,11 @@ unsigned long loops_per_usec;
 extern unsigned long do_slow_gettimeoffset(void);
 static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- *
- * Note: Division is quite slow on CRIS and do_gettimeofday is called
- *       rather often. Maybe we should do some kind of approximation here
- *       (a naive approximation would be to divide by 1024).
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	signed long usec, sec;
-	local_irq_save(flags);
-	usec = do_gettimeoffset();
-
-        /*
-	 * If time_adjust is negative then NTP is slowing the clock
-	 * so make sure not to go into next possible interval.
-	 * Better to lose some accuracy than have time go backwards..
-	 */
-	if (unlikely(time_adjust < 0) && usec > tickadj)
-		usec = tickadj;
-
-	sec = xtime.tv_sec;
-	usec += xtime.tv_nsec / 1000;
-	local_irq_restore(flags);
-
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
+u32 arch_gettimeoffset(void)
 {
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
-	 * made, and then undo it!
-	 */
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
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
+	return do_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
 /*
  * BUG: This routine does not handle hour overflow properly; it just
  *      sets the minutes. Usually you'll only notice that after reboot!
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index dbaed4a..f10e315 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -40,6 +40,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 6ea0177..01b67d0 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -48,7 +48,7 @@ extern void smp_local_timer_interrupt(void);
 
 static unsigned long latch;
 
-static unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
@@ -93,79 +93,10 @@ static unsigned long do_gettimeoffset(void)
 #error no chip configuration
 #endif
 
-	return elapsed_time;
+	return elapsed_time * 1000;
 }
 
 /*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry(&xtime_lock, seq));
-
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
- 	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-/*
  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
  * called 500 ms after the second nowtime has started, because when
  * nowtime is written into the registers of the CMOS clock, it will
@@ -192,6 +123,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
+	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
 	do_timer(1);
 
 #ifndef CONFIG_SMP
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 836fb66..9fd83da 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -58,6 +58,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 7db4159..0b1ecf3 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -90,72 +90,7 @@ void __init time_init(void)
 	mach_sched_init(timer_interrupt);
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		usec = mach_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec/1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-
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
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= 1000 * mach_gettimeoffset();
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
+	return mach_gettimeoffset() * 1000;
 }
-
-EXPORT_SYMBOL(do_settimeofday);
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 80119b3..2bc451f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -69,7 +69,7 @@ config GENERIC_IOMAP
 	bool
 
 config GENERIC_TIME
-	def_bool n
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	def_bool n
@@ -391,6 +391,10 @@ config SH_TMU
 	help
 	  This enables the use of the TMU as the system timer.
 
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+	depends on !SH_TMU
+
 config SH_CMT
 	def_bool y
 	prompt "CMT timer support"
diff --git a/arch/sh/include/asm/timer.h b/arch/sh/include/asm/timer.h
index a7ca3a1..da122a3 100644
--- a/arch/sh/include/asm/timer.h
+++ b/arch/sh/include/asm/timer.h
@@ -10,7 +10,7 @@ struct sys_timer_ops {
 	int (*start)(void);
 	int (*stop)(void);
 	cycle_t (*read)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long (*get_offset)(void);
 #endif
 };
@@ -27,7 +27,7 @@ struct sys_timer {
 extern struct sys_timer tmu_timer, cmt_timer, mtu2_timer;
 extern struct sys_timer *sys_timer;
 
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 static inline unsigned long get_timer_offset(void)
 {
 	return sys_timer->ops->get_offset();
diff --git a/arch/sh/kernel/time_32.c b/arch/sh/kernel/time_32.c
index 23ca711..ae9b0c3 100644
--- a/arch/sh/kernel/time_32.c
+++ b/arch/sh/kernel/time_32.c
@@ -52,65 +52,12 @@ static cycle_t null_hpt_read(void)
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
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
-		/*
-		 * Turn off IRQs when grabbing xtime_lock, so that
-		 * the sys_timer get_offset code doesn't have to handle it.
-		 */
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = get_timer_offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / NSEC_PER_USEC;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
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
-	 * made, and then undo it!
-	 */
-	nsec -= get_timer_offset() * NSEC_PER_USEC;
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
-
-	return 0;
+	return get_timer_offset() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /* last time the RTC clock got updated */
@@ -236,7 +183,7 @@ static void __init init_sh_clocksource(void)
 	clocksource_register(&clocksource_sh);
 }
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 unsigned long long sched_clock(void)
 {
 	unsigned long long ticks = clocksource_sh.read();
diff --git a/arch/sh/kernel/time_64.c b/arch/sh/kernel/time_64.c
index bbb2af1..72a1fb7 100644
--- a/arch/sh/kernel/time_64.c
+++ b/arch/sh/kernel/time_64.c
@@ -144,59 +144,10 @@ static unsigned long usecs_since_tick(void)
 	return result;
 }
 
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = usecs_since_tick();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
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
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * usecs_since_tick();
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
-
-	return 0;
+	return usecs_since_tick() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
 
 /* Dummy RTC ops */
 static void null_rtc_get_time(struct timespec *tv)
diff --git a/arch/sh/kernel/timers/timer-cmt.c b/arch/sh/kernel/timers/timer-cmt.c
index c127293..6c729db 100644
--- a/arch/sh/kernel/timers/timer-cmt.c
+++ b/arch/sh/kernel/timers/timer-cmt.c
@@ -178,7 +178,7 @@ static struct sys_timer_ops cmt_timer_ops = {
 	.init		= cmt_timer_init,
 	.start		= cmt_timer_start,
 	.stop		= cmt_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= cmt_timer_get_offset,
 #endif
 };
diff --git a/arch/sh/kernel/timers/timer-mtu2.c b/arch/sh/kernel/timers/timer-mtu2.c
index fe453c0..22d0c6f 100644
--- a/arch/sh/kernel/timers/timer-mtu2.c
+++ b/arch/sh/kernel/timers/timer-mtu2.c
@@ -186,7 +186,7 @@ struct sys_timer_ops mtu2_timer_ops = {
 	.init		= mtu2_timer_init,
 	.start		= mtu2_timer_start,
 	.stop		= mtu2_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= mtu2_timer_get_offset,
 #endif
 };
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e594559..76b5008 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -35,6 +35,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/sparc/kernel/time.c b/arch/sparc/kernel/time.c
index 00f7383..e673a83 100644
--- a/arch/sparc/kernel/time.c
+++ b/arch/sparc/kernel/time.c
@@ -225,7 +225,7 @@ void __init time_init(void)
 	sbus_time_init();
 }
 
-static inline unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long val = *master_l10_counter;
 	unsigned long usec = (val >> 10) & 0x1fffff;
@@ -234,84 +234,7 @@ static inline unsigned long do_gettimeoffset(void)
 	if (val & 0x80000000)
 		usec += 1000000 / HZ;
 
-	return usec;
-}
-
-/* Ok, my cute asm atomicity trick doesn't work anymore.
- * There are just too many variables that need to be protected
- * now (both members of xtime, et al.)
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
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
-	int ret;
-
-	write_seqlock_irq(&xtime_lock);
-	ret = bus_do_settimeofday(tv);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return ret;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-static int sbus_do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * do_gettimeoffset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	return 0;
+	return usec*1000;
 }
 
 static int set_rtc_mmss(unsigned long secs)
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 6c873dc..ea3fdfe 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -54,6 +54,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8df1e84..d49eb9d 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -88,68 +88,13 @@ void __init time_init(void)
 }
 
 
-int do_settimeofday(struct timespec *tv)
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-	unsigned long delta;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-
-	/* This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-
-	delta = CCOUNT_PER_JIFFY;
-	delta += get_ccount() - get_linux_timer();
-	nsec -= delta * NSEC_PER_CCOUNT;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	return 0;
+	u32 delta = get_linux_timer() - get_ccount();
+	return ((unsigned long) CCOUNT_PER_JIFFY - delta)
+		 * (unsigned long) NSEC_PER_CCOUNT;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long volatile sec, usec, delta, seq;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		sec = xtime.tv_sec;
-		usec = (xtime.tv_nsec / NSEC_PER_USEC);
-
-		delta = get_linux_timer() - get_ccount();
-
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	usec += (((unsigned long) CCOUNT_PER_JIFFY - delta)
-		 * (unsigned long) NSEC_PER_CCOUNT) / NSEC_PER_USEC;
-
-	for (; usec >= 1000000; sec++, usec -= 1000000)
-		;
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
 /*
  * The timer interrupt is called HZ times per second.
  */


