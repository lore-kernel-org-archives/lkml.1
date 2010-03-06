Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0CFA3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:29:15 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:43239 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0CFA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:29:13 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzab9bhzz1202hzzz2fh6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B91A1D1.2020208@am.sony.com>
Date: Fri, 5 Mar 2010 16:29:05 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] ftrace - add notrace to sched_clock on various arm platforms
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add notrace attribute to sched_clock, and
subsidiary clock routines, to avoid
recursion within ftrace.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 arch/arm/mach-mmp/time.c       |    2 +-
 arch/arm/mach-pxa/time.c       |    2 +-
 arch/arm/mach-realview/core.c  |    2 +-
 arch/arm/mach-sa1100/generic.c |    2 +-
 arch/arm/mach-versatile/core.c |    2 +-
 arch/arm/plat-omap/common.c    |   14 +++++++-------
 arch/arm/plat-omap/io.c        |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -72,7 +72,7 @@ static inline uint32_t timer_read(void)
 	return __raw_readl(TIMERS_VIRT_BASE + TMR_CVWR(0));
 }

-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	unsigned long long v = cnt32_to_63(timer_read());
 	return (v * tcr2ns_scale) >> TCR2NS_SCALE_FACTOR;
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -51,7 +51,7 @@ static void __init set_oscr2ns_scale(uns
 		oscr2ns_scale++;
 }

-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	unsigned long long v = cnt32_to_63(OSCR);
 	return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -82,7 +82,7 @@ void __init realview_adjust_zones(int no
  * This is the RealView sched_clock implementation.  This has
  * a resolution of 41.7ns, and a maximum value of about 179s.
  */
-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	unsigned long long v;

--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -119,7 +119,7 @@ unsigned int sa11x0_getspeed(unsigned in
  *
  *  ( * 1E9 / 3686400 => * 78125 / 288)
  */
-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	unsigned long long v = cnt32_to_63(OSCR);

--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -238,7 +238,7 @@ void __init versatile_map_io(void)
  * long as there is always less than 89 seconds between successive
  * calls to this function.
  */
-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	unsigned long long v = cnt32_to_63(readl(VERSATILE_REFCOUNTER));

--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(omap_get_var_config);
 #include <linux/clocksource.h>

 #ifdef CONFIG_ARCH_OMAP16XX
-static cycle_t omap16xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap16xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP16XX_TIMER_32K_SYNCHRONIZED);
 }
@@ -110,7 +110,7 @@ static cycle_t omap16xx_32k_read(struct
 #endif

 #ifdef CONFIG_ARCH_OMAP2420
-static cycle_t omap2420_32k_read(struct clocksource *cs)
+static cycle_t notrace omap2420_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP2420_32KSYNCT_BASE + 0x10);
 }
@@ -119,7 +119,7 @@ static cycle_t omap2420_32k_read(struct
 #endif

 #ifdef CONFIG_ARCH_OMAP2430
-static cycle_t omap2430_32k_read(struct clocksource *cs)
+static cycle_t notrace omap2430_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP2430_32KSYNCT_BASE + 0x10);
 }
@@ -128,7 +128,7 @@ static cycle_t omap2430_32k_read(struct
 #endif

 #ifdef CONFIG_ARCH_OMAP3
-static cycle_t omap34xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap34xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP3430_32KSYNCT_BASE + 0x10);
 }
@@ -137,7 +137,7 @@ static cycle_t omap34xx_32k_read(struct
 #endif

 #ifdef CONFIG_ARCH_OMAP4
-static cycle_t omap44xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap44xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP4430_32KSYNCT_BASE + 0x10);
 }
@@ -149,7 +149,7 @@ static cycle_t omap44xx_32k_read(struct
  * Kernel assumes that sched_clock can be called early but may not have
  * things ready yet.
  */
-static cycle_t omap_32k_read_dummy(struct clocksource *cs)
+static cycle_t notrace omap_32k_read_dummy(struct clocksource *cs)
 {
 	return 0;
 }
@@ -167,7 +167,7 @@ static struct clocksource clocksource_32
  * Returns current time from boot in nsecs. It's OK for this to wrap
  * around for now, as it's just a relative time stamp.
  */
-unsigned long long sched_clock(void)
+unsigned long long notrace sched_clock(void)
 {
 	return clocksource_cyc2ns(clocksource_32k.read(&clocksource_32k),
 				  clocksource_32k.mult, clocksource_32k.shift);
--- a/arch/arm/plat-omap/io.c
+++ b/arch/arm/plat-omap/io.c
@@ -159,7 +159,7 @@ u16 omap_readw(u32 pa)
 }
 EXPORT_SYMBOL(omap_readw);

-u32 omap_readl(u32 pa)
+u32 notrace omap_readl(u32 pa)
 {
 	if (cpu_class_is_omap1())
 		return __raw_readl(OMAP1_IO_ADDRESS(pa));

