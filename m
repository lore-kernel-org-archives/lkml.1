Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXH1Juy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXH1Juy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXH1Jum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:50:42 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10661 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXH1Jug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:50:36 -0400
X-IronPort-AV: i="4.19,315,1183348800"; 
   d="scan'208"; a="38269078:sNHT98459480"
Subject: [GIT PULL] Blackfin update for 2.6.23-rc4
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 28 Aug 2007 17:50:24 +0800
Message-Id: <1188294624.1283.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 28 Aug 2007 09:50:31.0983 (UTC) FILETIME=[DF85CBF0:01C7E958]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 - Blackfin anomaly handling update
 - bug fixing

 arch/blackfin/kernel/bfin_gpio.c                   |   10 +-
 arch/blackfin/kernel/cplbinit.c                    |    4 +-
 arch/blackfin/kernel/setup.c                       |   20 +-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memcpy.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    4 +-
 arch/blackfin/mach-bf533/head.S                    |   22 +-
 arch/blackfin/mach-bf537/head.S                    |   30 +-
 arch/blackfin/mach-bf548/head.S                    |   14 +-
 arch/blackfin/mach-bf561/head.S                    |   23 +-
 arch/blackfin/mach-common/cache.S                  |    8 +-
 arch/blackfin/mach-common/cacheinit.S              |    6 +-
 arch/blackfin/mach-common/cplbmgr.S                |   54 ++--
 arch/blackfin/mach-common/dpmc.S                   |   52 ++--
 arch/blackfin/mach-common/entry.S                  |   10 +-
 arch/blackfin/mach-common/interrupt.S              |    6 +-
 arch/blackfin/mach-common/lock.S                   |   20 +-
 arch/blackfin/mach-common/pm.c                     |    6 +
 arch/blackfin/oprofile/op_blackfin.h               |    8 +-
 drivers/serial/bfin_5xx.c                          |   14 +-
 include/asm-blackfin/blackfin.h                    |  112 ++---
 include/asm-blackfin/mach-bf527/anomaly.h          |   39 ++
 include/asm-blackfin/mach-bf533/anomaly.h          |  467 ++++++++++----------
 include/asm-blackfin/mach-bf533/bf533.h            |    2 +-
 include/asm-blackfin/mach-bf533/cdefBF532.h        |   10 +-
 include/asm-blackfin/mach-bf537/anomaly.h          |  246 ++++++-----
 include/asm-blackfin/mach-bf537/bf537.h            |    2 +-
 include/asm-blackfin/mach-bf537/cdefBF534.h        |    4 +-
 include/asm-blackfin/mach-bf548/anomaly.h          |  142 ++++---
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |    4 +-
 include/asm-blackfin/mach-bf561/anomaly.h          |  410 ++++++++++-------
 include/asm-blackfin/mach-bf561/bf561.h            |    2 +-
 include/asm-blackfin/mach-bf561/cdefBF561.h        |    9 +-
 include/asm-blackfin/mach-bf561/portmux.h          |    2 +-
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    4 +-
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |  132 +++---
 include/asm-blackfin/system.h                      |   93 +++--
 37 files changed, 1057 insertions(+), 938 deletions(-)
 create mode 100644 include/asm-blackfin/mach-bf527/anomaly.h

Bryan Wu (1):
      Blackfin arch: fix bugs report by Andy Liu <yjhsou@gmail.com>, AD1836 can't be probed in BF561-EZ

Michael Hennerich (1):
      Blackfin arch: Update/Fix PM support add new pm_ops valid

Mike Frysinger (8):
      Blackfin arch: cleanup and standardize anomaly.h file format -- no functional changes
      Blackfin arch: revise anomaly handling by basing things on the compiler not the kconfig defines
      Blackfin arch: update BF54x anomaly list
      Blackfin arch: use the [CS]SYNC() macros which include anomaly workarounds rather than __builtin_bfin_[cs]sync()
      Blackfin arch: reorganize headers slightly so we can be sure things are defined early enough
      Blackfin arch: use HI/LO macros rather than masking the bit ranges ourselves
      Blackfin arch: fix typo... we want csync in CSYNC(), not ssync
      Blackfin arch: update to latest anomaly sheets

Robin Getz (1):
      Blackfin arch: Fix Anomaly hanlding, as pointed out by Mike

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bafcfa5..deec308 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(set_gpio_ ## name);
 SET_GPIO_SC(maska)
 SET_GPIO_SC(maskb)
 
-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
@@ -273,7 +273,7 @@ SET_GPIO_SC(data)
 #endif
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 void set_gpio_toggle(unsigned short gpio)
 {
 	unsigned long flags;
@@ -311,7 +311,7 @@ SET_GPIO_P(maska)
 SET_GPIO_P(maskb)
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 void set_gpiop_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
@@ -345,7 +345,7 @@ GET_GPIO(maska)
 GET_GPIO(maskb)
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 unsigned short get_gpio_data(unsigned short gpio)
 {
 	unsigned long flags;
@@ -379,7 +379,7 @@ GET_GPIO_P(both)
 GET_GPIO_P(maska)
 GET_GPIO_P(maskb)
 
-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 unsigned short get_gpiop_data(unsigned short gpio)
 {
 	unsigned long flags;
diff --git a/arch/blackfin/kernel/cplbinit.c b/arch/blackfin/kernel/cplbinit.c
index bbdb403..3b1c87c 100644
--- a/arch/blackfin/kernel/cplbinit.c
+++ b/arch/blackfin/kernel/cplbinit.c
@@ -230,8 +230,8 @@ static void __fill_code_cplbtab(struct cplb_tab *t, int i, u32 a_start, u32 a_en
 				cplb_data[i].psize,
 				cplb_data[i].i_conf);
 	} else {
-#if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
-		if (i == SDRAM_KERN) {
+#if defined(CONFIG_BLKFIN_CACHE)
+		if (ANOMALY_05000263 && i == SDRAM_KERN) {
 			fill_cplbtab(t,
 					cplb_data[i].start,
 					cplb_data[i].end,
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 88f221b..02c1527 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -179,14 +179,16 @@ void __init setup_arch(char **cmdline_p)
 	cclk = get_cclk();
 	sclk = get_sclk();
 
-#if !defined(CONFIG_BFIN_KERNEL_CLOCK) && defined(ANOMALY_05000273)
-	if (cclk == sclk)
+#if !defined(CONFIG_BFIN_KERNEL_CLOCK)
+	if (ANOMALY_05000273 && cclk == sclk)
 		panic("ANOMALY 05000273, SCLK can not be same as CCLK");
 #endif
 
-#if defined(ANOMALY_05000266)
-	bfin_read_IMDMA_D0_IRQ_STATUS();
-	bfin_read_IMDMA_D1_IRQ_STATUS();
+#ifdef BF561_FAMILY
+	if (ANOMALY_05000266) {
+		bfin_read_IMDMA_D0_IRQ_STATUS();
+		bfin_read_IMDMA_D1_IRQ_STATUS();
+	}
 #endif
 
 #ifdef DEBUG_SERIAL_EARLY_INIT
@@ -260,7 +262,7 @@ void __init setup_arch(char **cmdline_p)
 	    && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
 		mtd_size =
 		    PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
-#  if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
+#  if (defined(CONFIG_BLKFIN_CACHE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -289,7 +291,7 @@ void __init setup_arch(char **cmdline_p)
 	_ebss = memory_mtd_start;	/* define _ebss for compatible */
 #endif				/* CONFIG_MTD_UCLINUX */
 
-#if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
+#if (defined(CONFIG_BLKFIN_CACHE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -337,10 +339,8 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu Mhz System Clock\n",
 	       cclk / 1000000,  sclk / 1000000);
 
-#if defined(ANOMALY_05000273)
-	if ((cclk >> 1) <= sclk)
+	if (ANOMALY_05000273 && (cclk >> 1) <= sclk)
 		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
-#endif
 
 	printk(KERN_INFO "Board Memory: %ldMB\n", physical_mem_end >> 20);
 	printk(KERN_INFO "Kernel Managed Memory: %ldMB\n", _ramend >> 20);
diff --git a/arch/blackfin/lib/memcmp.S b/arch/blackfin/lib/memcmp.S
index b88c5d2..219fa28 100644
--- a/arch/blackfin/lib/memcmp.S
+++ b/arch/blackfin/lib/memcmp.S
@@ -61,7 +61,7 @@ ENTRY(_memcmp)
 
 	LSETUP (.Lquad_loop_s, .Lquad_loop_e) LC0=P1;
 .Lquad_loop_s:
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 	R0 = [P0++];
 	R1 = [I0++];
 #else
diff --git a/arch/blackfin/lib/memcpy.S b/arch/blackfin/lib/memcpy.S
index 14a5585..2e63364 100644
--- a/arch/blackfin/lib/memcpy.S
+++ b/arch/blackfin/lib/memcpy.S
@@ -98,7 +98,7 @@ ENTRY(_memcpy)
 	R0 = R1;
 	I1 = P1;
 	R3 = [I1++];
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 .Lword_loops:
 	[P0++] = R3;
 .Lword_loope:
diff --git a/arch/blackfin/lib/memmove.S b/arch/blackfin/lib/memmove.S
index 6ee6e20..33f8653 100644
--- a/arch/blackfin/lib/memmove.S
+++ b/arch/blackfin/lib/memmove.S
@@ -70,7 +70,7 @@ ENTRY(_memmove)
 	R1 = [I0++];
 
 	LSETUP (.Lquad_loops, .Lquad_loope) LC0=P1;
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 .Lquad_loops:
 	[P0++] = R1;
 .Lquad_loope:
@@ -102,7 +102,7 @@ ENTRY(_memmove)
 	R1 = B[P3--] (Z);
 	CC = P2 == 0;
 	IF CC JUMP .Lno_loop;
-#ifdef ANOMALY_05000245
+#if ANOMALY_05000245
 	NOP;
 	NOP;
 #endif
diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 7dd0e9c..69da0e8 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -144,38 +144,38 @@ ENTRY(__start)
 	ssync;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -264,7 +264,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -417,8 +417,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 429c8a1..b1d4b91 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -100,38 +100,38 @@ ENTRY(__start)
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -141,12 +141,12 @@ ENTRY(__start)
 	 */
 	p0.h = hi(BFIN_PORT_MUX);
 	p0.l = lo(BFIN_PORT_MUX);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	R0.L = W[P0]; /* Read */
 	SSYNC;
 #endif
 	R0 = (PGDE_UART | PFTE_UART)(Z);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	W[P0] = R0.L; /* Write */
 	SSYNC;
 #endif
@@ -155,12 +155,12 @@ ENTRY(__start)
 
 	p0.h = hi(PORTF_FER);
 	p0.l = lo(PORTF_FER);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	R0.L = W[P0]; /* Read */
 	SSYNC;
 #endif
 	R0 = 0x000F(Z);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	W[P0] = R0.L; /* Write */
 	SSYNC;
 #endif
@@ -274,7 +274,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -436,8 +436,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 06751ae..47cd917 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -97,8 +97,8 @@ ENTRY(__stext)
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
@@ -106,8 +106,8 @@ ENTRY(__stext)
 	SSYNC;
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
@@ -172,7 +172,7 @@ ENTRY(__stext)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined (ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop;
 	nop;
 	nop;
@@ -335,8 +335,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 38650a6..1738934 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -100,38 +100,37 @@ ENTRY(__start)
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
-	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -220,7 +219,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -372,8 +371,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index 7063795..0521b15 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -79,8 +79,8 @@ ENTRY(_icache_invalidate)
 ENTRY(_invalidate_entire_icache)
 	[--SP] = ( R7:5);
 
-	P0.L = (IMEM_CONTROL & 0xFFFF);
-	P0.H = (IMEM_CONTROL >> 16);
+	P0.L = LO(IMEM_CONTROL);
+	P0.H = HI(IMEM_CONTROL);
 	R7 = [P0];
 
 	/* Clear the IMC bit , All valid bits in the instruction
@@ -197,8 +197,8 @@ ENTRY(_invalidate_entire_dcache)
 ENTRY(_dcache_invalidate)
 	[--SP] = ( R7:6);
 
-	P0.L = (DMEM_CONTROL & 0xFFFF);
-	P0.H = (DMEM_CONTROL >> 16);
+	P0.L = LO(DMEM_CONTROL);
+	P0.H = HI(DMEM_CONTROL);
 	R7 = [P0];
 
 	/* Clear the DMC[1:0] bits, All valid bits in the data
diff --git a/arch/blackfin/mach-common/cacheinit.S b/arch/blackfin/mach-common/cacheinit.S
index 5be6b97..afa0adf 100644
--- a/arch/blackfin/mach-common/cacheinit.S
+++ b/arch/blackfin/mach-common/cacheinit.S
@@ -38,13 +38,13 @@
 
 .text
 
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 #if defined(CONFIG_BLKFIN_CACHE)
 ENTRY(_bfin_write_IMEM_CONTROL)
 
 	/* Enable Instruction Cache */
-	P0.l = (IMEM_CONTROL & 0xFFFF);
-	P0.h = (IMEM_CONTROL >> 16);
+	P0.l = LO(IMEM_CONTROL);
+	P0.h = HI(IMEM_CONTROL);
 
 	/* Anomaly 05000125 */
 	CLI R1;
diff --git a/arch/blackfin/mach-common/cplbmgr.S b/arch/blackfin/mach-common/cplbmgr.S
index e4b47e0..cef94c1 100644
--- a/arch/blackfin/mach-common/cplbmgr.S
+++ b/arch/blackfin/mach-common/cplbmgr.S
@@ -75,15 +75,15 @@ ENTRY(_cplb_mgr)
 	* from the configuration table.
  	*/
 
-	P4.L = (ICPLB_FAULT_ADDR & 0xFFFF);
-	P4.H = (ICPLB_FAULT_ADDR >> 16);
+	P4.L = LO(ICPLB_FAULT_ADDR);
+	P4.H = HI(ICPLB_FAULT_ADDR);
 
 	P1 = 16;
 	P5.L = _page_size_table;
 	P5.H = _page_size_table;
 
-	P0.L = (ICPLB_DATA0 & 0xFFFF);
-	P0.H = (ICPLB_DATA0 >> 16);
+	P0.L = LO(ICPLB_DATA0);
+	P0.H = HI(ICPLB_DATA0);
 	R4 = [P4];		/* Get faulting address*/
 	R6 = 64;		/* Advance past the fault address, which*/
 	R6 = R6 + R4;		/* we'll use if we find a match*/
@@ -117,13 +117,13 @@ ENTRY(_cplb_mgr)
 	I0 = R4;		/* Fault address we'll search for*/
 
 	/* set up pointers */
-	P0.L = (ICPLB_DATA0 & 0xFFFF);
-	P0.H = (ICPLB_DATA0 >> 16);
+	P0.L = LO(ICPLB_DATA0);
+	P0.H = HI(ICPLB_DATA0);
 
 	/* The replacement procedure for ICPLBs */
 
-	P4.L = (IMEM_CONTROL & 0xFFFF);
-	P4.H = (IMEM_CONTROL >> 16);
+	P4.L = LO(IMEM_CONTROL);
+	P4.H = HI(IMEM_CONTROL);
 
 	/* disable cplbs */
 	R5 = [P4];		/* Control Register*/
@@ -243,8 +243,8 @@ ENTRY(_cplb_mgr)
 	 * last entry of the table.
 	 */
 
-	P1.L = (ICPLB_DATA15 & 0xFFFF);		/* ICPLB_DATA15 */
-	P1.H = (ICPLB_DATA15 >> 16);
+	P1.L = LO(ICPLB_DATA15);		/* ICPLB_DATA15 */
+	P1.H = HI(ICPLB_DATA15);
 	[P1] = R2;
 	[P1-0x100] = R4;
 #ifdef	CONFIG_CPLB_INFO
@@ -292,10 +292,10 @@ ENTRY(_cplb_mgr)
 	 * pending writes associated with the CPLB.
 	 */
 
-	P4.L = (DCPLB_STATUS & 0xFFFF);
-	P4.H = (DCPLB_STATUS >> 16);
-	P3.L = (DCPLB_DATA0 & 0xFFFF);
-	P3.H = (DCPLB_DATA0 >> 16);
+	P4.L = LO(DCPLB_STATUS);
+	P4.H = HI(DCPLB_STATUS);
+	P3.L = LO(DCPLB_DATA0);
+	P3.H = HI(DCPLB_DATA0);
 	R5 = [P4];
 
 	/* A protection violation can be caused by more than just writes
@@ -355,11 +355,11 @@ ENTRY(_cplb_mgr)
 	 * config table, that covers the faulting address.
 	 */
 
-	P1.L = (DCPLB_DATA15 & 0xFFFF);
-	P1.H = (DCPLB_DATA15 >> 16);
+	P1.L = LO(DCPLB_DATA15);
+	P1.H = HI(DCPLB_DATA15);
 
-	P4.L = (DCPLB_FAULT_ADDR & 0xFFFF);
-	P4.H = (DCPLB_FAULT_ADDR >> 16);
+	P4.L = LO(DCPLB_FAULT_ADDR);
+	P4.H = HI(DCPLB_FAULT_ADDR);
 	R4 = [P4];
 	I0 = R4;
 
@@ -368,8 +368,8 @@ ENTRY(_cplb_mgr)
 	R6 = R1;	/* Save for later*/
 
 	/* Turn off CPLBs while we work.*/
-	P4.L = (DMEM_CONTROL & 0xFFFF);
-	P4.H = (DMEM_CONTROL >> 16);
+	P4.L = LO(DMEM_CONTROL);
+	P4.H = HI(DMEM_CONTROL);
 	R5 = [P4];
 	BITCLR(R5,ENDCPLB_P);
 	CLI R0;
@@ -384,8 +384,8 @@ ENTRY(_cplb_mgr)
 	 * are no good.
 	 */
 
-	I1.L = (DCPLB_DATA0 & 0xFFFF);
-	I1.H = (DCPLB_DATA0 >> 16);
+	I1.L = LO(DCPLB_DATA0);
+	I1.H = HI(DCPLB_DATA0);
 	P1 = 2;
 	P2 = 16;
 	I2.L = _dcplb_preference;
@@ -405,7 +405,7 @@ ENTRY(_cplb_mgr)
 	P3.L = _page_size_table; /* retrieve end address */
 	P3.H = _page_size_table; /* retrieve end address */
 	R3 = 0x1002;		/* 16th - position, 2 bits -length */
-#ifdef ANOMALY_05000209
+#if ANOMALY_05000209
 	nop;			/* Anomaly 05000209 */
 #endif
 	R7 = EXTRACT(R1,R3.l);
@@ -475,8 +475,8 @@ ENTRY(_cplb_mgr)
 	 * one space closer to the start.
 	 */
 
-	R1.L = (DCPLB_DATA16 & 0xFFFF);		/* DCPLB_DATA15 + 4 */
-	R1.H = (DCPLB_DATA16 >> 16);
+	R1.L = LO(DCPLB_DATA16);		/* DCPLB_DATA15 + 4 */
+	R1.H = HI(DCPLB_DATA16);
 	R0 = P0;
 
 	/* If the victim happens to be in DCPLB15,
@@ -549,8 +549,8 @@ ENTRY(_cplb_mgr)
 	 * if necessary.
 	 */
 
-	P1.L = (DCPLB_DATA15 & 0xFFFF);
-	P1.H = (DCPLB_DATA15 >> 16);
+	P1.L = LO(DCPLB_DATA15);
+	P1.H = HI(DCPLB_DATA15);
 
 	/* If the DCPLB has cache bits set, but caching hasn't
 	 * been enabled, then we want to mask off the cache-in-L1
diff --git a/arch/blackfin/mach-common/dpmc.S b/arch/blackfin/mach-common/dpmc.S
index 97cdcd6..04194dc 100644
--- a/arch/blackfin/mach-common/dpmc.S
+++ b/arch/blackfin/mach-common/dpmc.S
@@ -39,8 +39,8 @@ ENTRY(_unmask_wdog_wakeup_evt)
 	P0.H = hi(SICA_IWR1);
 	P0.L = lo(SICA_IWR1);
 #else
-	P0.h = (SIC_IWR >> 16);
-	P0.l = (SIC_IWR & 0xFFFF);
+	P0.h = HI(SIC_IWR);
+	P0.l = LO(SIC_IWR);
 #endif
 	R7 = [P0];
 #if defined(CONFIG_BF561)
@@ -60,11 +60,11 @@ ENTRY(_unmask_wdog_wakeup_evt)
 	 */
 	R7 = 0x0000(z);
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_STAT >> 16);
-	P0.l = (WDOGA_STAT & 0xFFFF);
+	P0.h = HI(WDOGA_STAT);
+	P0.l = LO(WDOGA_STAT);
 #else
-	P0.h = (WDOG_STAT >> 16);
-	P0.l = (WDOG_STAT & 0xFFFF);
+	P0.h = HI(WDOG_STAT);
+	P0.l = LO(WDOG_STAT);
 #endif
 	[P0] = R7;
 	SSYNC;
@@ -73,21 +73,21 @@ ENTRY(_unmask_wdog_wakeup_evt)
 ENTRY(_program_wdog_timer)
 	[--SP] = ( R7:0, P5:0 );
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CNT >> 16);
-	P0.l = (WDOGA_CNT & 0xFFFF);
+	P0.h = HI(WDOGA_CNT);
+	P0.l = LO(WDOGA_CNT);
 #else
-	P0.h = (WDOG_CNT >> 16);
-	P0.l = (WDOG_CNT & 0xFFFF);
+	P0.h = HI(WDOG_CNT);
+	P0.l = LO(WDOG_CNT);
 #endif
 	[P0] = R0;
 	SSYNC;
 
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = W[P0](Z);
 	CC = BITTST(R7,1);
@@ -97,11 +97,11 @@ ENTRY(_program_wdog_timer)
 
 .LSKIP_WRITE_TO_STAT:
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	    P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	    P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = W[P0](Z);
 	BITCLR(R7,1);   /* Enable GP event */
@@ -122,11 +122,11 @@ ENTRY(_clear_wdog_wakeup_evt)
 	[--SP] = ( R7:0, P5:0 );
 
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = 0x0AD6(Z);
 	W[P0] = R7.L;
@@ -149,11 +149,11 @@ ENTRY(_clear_wdog_wakeup_evt)
 ENTRY(_disable_wdog_timer)
 	[--SP] = ( R7:0, P5:0 );
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = 0xAD6(Z);
 	W[P0] = R7.L;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index d61bba9..b1cdbbc 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -69,7 +69,7 @@
  * patch up CPLB misses on the kernel stack.
  */
 ENTRY(_ex_dcplb)
-#if defined(ANOMALY_05000261)
+#if ANOMALY_05000261
 	/*
 	 * Work around an anomaly: if we see a new DCPLB fault, return
 	 * without doing anything.  Then, if we get the same fault again,
@@ -137,7 +137,7 @@ ENTRY(_ex_single_step)
 
 _return_from_exception:
 	DEBUG_START_HWTRACE(p5, r7)
-#ifdef ANOMALY_05000257
+#if ANOMALY_05000257
 	R7=LC0;
 	LC0=R7;
 	R7=LC1;
@@ -634,7 +634,7 @@ ENTRY(_return_from_int)
 	p1.h = _schedule_and_signal_from_int;
 	[p0] = p1;
 	csync;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	r0.l = lo(CONFIG_BOOT_LOAD);
 	r0.h = hi(CONFIG_BOOT_LOAD);
 	reti = r0;
@@ -648,7 +648,7 @@ ENTRY(_return_from_int)
 ENDPROC(_return_from_int)
 
 ENTRY(_lower_to_irq14)
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	r0.l = lo(CONFIG_BOOT_LOAD);
 	r0.h = hi(CONFIG_BOOT_LOAD);
 	reti = r0;
@@ -1169,7 +1169,7 @@ _exception_stack:
 	.endr
 _exception_stack_top:
 
-#if defined(ANOMALY_05000261)
+#if ANOMALY_05000261
 /* Used by the assembly entry point to work around an anomaly.  */
 _last_cplb_fault_retx:
 	.long 0;
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index 203e207..14ef800 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -140,7 +140,7 @@ __common_int_entry:
 	fp = 0;
 #endif
 
-#if defined (ANOMALY_05000283) || defined (ANOMALY_05000315)
+#if ANOMALY_05000283 || ANOMALY_05000315
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
@@ -163,7 +163,7 @@ ENTRY(_evt_ivhw)
 #ifdef CONFIG_FRAME_POINTER
 	fp = 0;
 #endif
-#ifdef	ANOMALY_05000283
+#if ANOMALY_05000283
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
@@ -207,7 +207,7 @@ ENTRY(_evt_evt2)
 #ifdef CONFIG_FRAME_POINTER
 	fp = 0;
 #endif
-#ifdef	ANOMALY_05000283
+#if ANOMALY_05000283
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
diff --git a/arch/blackfin/mach-common/lock.S b/arch/blackfin/mach-common/lock.S
index 386ac8d..190edb3 100644
--- a/arch/blackfin/mach-common/lock.S
+++ b/arch/blackfin/mach-common/lock.S
@@ -43,12 +43,12 @@ ENTRY(_cache_grab_lock)
 
 	[--SP]=( R7:0,P5:0 );
 
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
-	P5.H = (ICPLB_ADDR0 >> 16);
-	P5.L = (ICPLB_ADDR0 & 0xFFFF);
-	P4.H = (ICPLB_DATA0 >> 16);
-	P4.L = (ICPLB_DATA0 & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
+	P5.H = HI(ICPLB_ADDR0);
+	P5.L = LO(ICPLB_ADDR0);
+	P4.H = HI(ICPLB_DATA0);
+	P4.L = LO(ICPLB_DATA0);
 	R7 = R0;
 
 	/* If the code of interest already resides in the cache
@@ -167,8 +167,8 @@ ENTRY(_cache_lock)
 
 	[--SP]=( R7:0,P5:0 );
 
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
 
 	/* Disable the Interrupts*/
 	CLI R3;
@@ -195,8 +195,8 @@ ENDPROC(_cache_lock)
  */
 
 ENTRY(_read_iloc)
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
 	R1 = 0xF;
 	R0 = [P1];
 	R0 = R0 >> 3;
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 1772d8d..b103027 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -158,10 +158,16 @@ static int bfin_pm_finish(suspend_state_t state)
 	return 0;
 }
 
+static int bfin_pm_valid(suspend_state_t state)
+{
+	return (state == PM_SUSPEND_STANDBY);
+}
+
 struct pm_ops bfin_pm_ops = {
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
+	.valid	= bfin_pm_valid,
 };
 
 static int __init bfin_pm_init(void)
diff --git a/arch/blackfin/oprofile/op_blackfin.h b/arch/blackfin/oprofile/op_blackfin.h
index f88f446..05dd08c 100644
--- a/arch/blackfin/oprofile/op_blackfin.h
+++ b/arch/blackfin/oprofile/op_blackfin.h
@@ -68,7 +68,7 @@ static inline unsigned int ctr_read(void)
 	unsigned int tmp;
 
 	tmp = bfin_read_PFCTL();
-	__builtin_bfin_csync();
+	CSYNC();
 
 	return tmp;
 }
@@ -76,21 +76,21 @@ static inline unsigned int ctr_read(void)
 static inline void ctr_write(unsigned int val)
 {
 	bfin_write_PFCTL(val);
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 static inline void count_read(unsigned int *count)
 {
 	count[0] = bfin_read_PFCNTR0();
 	count[1] = bfin_read_PFCNTR1();
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 static inline void count_write(unsigned int *count)
 {
 	bfin_write_PFCNTR0(count[0]);
 	bfin_write_PFCNTR1(count[1]);
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 extern int pm_overflow_handler(int irq, struct pt_regs *regs);
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 66c92bc..1e79ee6 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -173,12 +173,12 @@ void kgdb_put_debug_char(int chr)
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
 	
 	while (!(UART_GET_LSR(uart) & THRE)) {
-		__builtin_bfin_ssync();
+		SSYNC();
 	}
 	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	__builtin_bfin_ssync();
+	SSYNC();
 	UART_PUT_CHAR(uart, (unsigned char)chr);
-	__builtin_bfin_ssync();
+	SSYNC();
 }
 
 int kgdb_get_debug_char(void)
@@ -192,12 +192,12 @@ int kgdb_get_debug_char(void)
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
 	
 	while(!(UART_GET_LSR(uart) & DR)) {
-		__builtin_bfin_ssync();
+		SSYNC();
 	}
 	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	__builtin_bfin_ssync();
+	SSYNC();
 	chr = UART_GET_CHAR(uart);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	return chr;
 }
@@ -1203,7 +1203,7 @@ static int __init bfin_serial_init(void)
 			IRQF_DISABLED, "BFIN_UART_RX", uart);
 		pr_info("Request irq for kgdb uart port\n");
 		UART_PUT_IER(uart, UART_GET_IER(uart) | ERBFI);
-		__builtin_bfin_ssync();
+		SSYNC();
 		t.c_cflag = CS8|B57600;
 		t.c_iflag = 0;
 		t.c_oflag = 0;
diff --git a/include/asm-blackfin/blackfin.h b/include/asm-blackfin/blackfin.h
index 25b934b..984b74f 100644
--- a/include/asm-blackfin/blackfin.h
+++ b/include/asm-blackfin/blackfin.h
@@ -11,78 +11,57 @@
 #define HI(con32) (((con32) >> 16) & 0xFFFF)
 #define hi(con32) (((con32) >> 16) & 0xFFFF)
 
-#include <asm/mach/blackfin.h>
-#include <asm/bfin-global.h>
+#include <asm/mach/anomaly.h>
 
 #ifndef __ASSEMBLY__
 
 /* SSYNC implementation for C file */
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"nop;nop;\n\t"
-			"ssync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
-}
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void SSYNC (void)
+static inline void SSYNC(void)
 {
 	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"ssync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
+	if (ANOMALY_05000312)
+		__asm__ __volatile__(
+			"cli %0;"
+			"nop;"
+			"nop;"
+			"ssync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (ANOMALY_05000244)
+		__asm__ __volatile__(
+			"nop;"
+			"nop;"
+			"nop;"
+			"ssync;"
+		);
+	else
+		__asm__ __volatile__("ssync;");
 }
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	__asm__ __volatile__ ("nop; nop; nop;\n\t"
-			"ssync;\n\t"
-			::);
-}
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	__asm__ __volatile__ ("ssync;\n\t");
-}
-#endif
 
 /* CSYNC implementation for C file */
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"nop;nop;\n\t"
-			"csync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
-}
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void CSYNC (void)
+static inline void CSYNC(void)
 {
 	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"csync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
-}
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	__asm__ __volatile__ ("nop; nop; nop;\n\t"
-			"ssync;\n\t"
-			::);
+	if (ANOMALY_05000312)
+		__asm__ __volatile__(
+			"cli %0;"
+			"nop;"
+			"nop;"
+			"csync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (ANOMALY_05000244)
+		__asm__ __volatile__(
+			"nop;"
+			"nop;"
+			"nop;"
+			"csync;"
+		);
+	else
+		__asm__ __volatile__("csync;");
 }
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	__asm__ __volatile__ ("csync;\n\t");
-}
-#endif
 
 #else  /* __ASSEMBLY__ */
 
@@ -91,19 +70,15 @@ static inline void CSYNC (void)
 #define ssync(x) SSYNC(x)
 #define csync(x) CSYNC(x)
 
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
+#if ANOMALY_05000312
 #define SSYNC(scratch) cli scratch; nop; nop; SSYNC; sti scratch;
 #define CSYNC(scratch) cli scratch; nop; nop; CSYNC; sti scratch;
 
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-#define SSYNC(scratch) cli scratch; nop; nop; SSYNC; sti scratch;
-#define CSYNC(scratch) cli scratch; nop; nop; CSYNC; sti scratch;
-
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
+#elif ANOMALY_05000244
 #define SSYNC(scratch) nop; nop; nop; SSYNC;
 #define CSYNC(scratch) nop; nop; nop; CSYNC;
 
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
+#else
 #define SSYNC(scratch) SSYNC;
 #define CSYNC(scratch) CSYNC;
 
@@ -111,4 +86,7 @@ static inline void CSYNC (void)
 
 #endif /* __ASSEMBLY__ */
 
+#include <asm/mach/blackfin.h>
+#include <asm/bfin-global.h>
+
 #endif				/* _BLACKFIN_H_ */
diff --git a/include/asm-blackfin/mach-bf527/anomaly.h b/include/asm-blackfin/mach-bf527/anomaly.h
new file mode 100644
index 0000000..6112bc3
--- /dev/null
+++ b/include/asm-blackfin/mach-bf527/anomaly.h
@@ -0,0 +1,39 @@
+/*
+ * File: include/asm-blackfin/mach-bf527/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+/* This file shoule be up to date with:
+ *  - Revision A, May 30, 2007; ADSP-BF527 Blackfin Processor Anomaly List
+ */
+
+#ifndef _MACH_ANOMALY_H_
+#define _MACH_ANOMALY_H_
+
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (1)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (1)
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
+#define ANOMALY_05000301 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* Incorrect Access of OTP_STATUS During otp_write() Function */
+#define ANOMALY_05000328 (1)
+/* Disallowed Configuration Prevents Subsequent Allowed Configuration on Host DMA Port */
+#define ANOMALY_05000337 (1)
+/* TWI Does Not Operate Correctly Under Certain Signal Termination Conditions */
+#define ANOMALY_05000342 (1)
+/* Boot ROM Kernel Incorrectly Alters Reset Value of USB Register */
+#define ANOMALY_05000347 (1)
+
+#endif
diff --git a/include/asm-blackfin/mach-bf533/anomaly.h b/include/asm-blackfin/mach-bf533/anomaly.h
index 7302f29..caea0b0 100644
--- a/include/asm-blackfin/mach-bf533/anomaly.h
+++ b/include/asm-blackfin/mach-bf533/anomaly.h
@@ -1,247 +1,258 @@
 /*
- * File:         include/asm-blackfin/mach-bf533/anomaly.h
- * Based on:
- * Author:
+ * File: include/asm-blackfin/mach-bf533/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision U, May 17, 2006; ADSP-BF533 Blackfin Processor Anomaly List
- *  - Revision Y, May 17, 2006; ADSP-BF532 Blackfin Processor Anomaly List
- *  - Revision T, May 17, 2006; ADSP-BF531 Blackfin Processor Anomaly List
+ *  - Revision X,  March 23, 2007; ADSP-BF533 Blackfin Processor Anomaly List
+ *  - Revision AB, March 23, 2007; ADSP-BF532 Blackfin Processor Anomaly List
+ *  - Revision W,  March 23, 2007; ADSP-BF531 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
 /* We do not support 0.1 or 0.2 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1) || defined(CONFIG_BF_REV_0_2))
-#error Kernel will not work on BF533 Version 0.1 or 0.2
+#if __SILICON_REVISION__ < 3
+# error Kernel will not work on BF533 silicon version 0.0, 0.1, or 0.2
 #endif
 
-/* Issues that are common to 0.5, 0.4, and 0.3 silicon */
-#if  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_4) \
-		|| defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000105 /* Watchpoint Status Register (WPSTAT) bits are set on
-                            every corresponding match */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-                            Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-                            registers. */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits*/
-#define ANOMALY_05000167 /* Turning Serial Ports on With External Frame Syncs */
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#define ANOMALY_05000208 /* VSTAT status bit in PLL_STAT register is not
-                            functional */
-#define ANOMALY_05000219 /* NMI event at boot time results in unpredictable
-                            state */
-#define ANOMALY_05000229 /* SPI Slave Boot Mode modifies registers */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000273 /* Writes to Synchronous SDRAM memory may be lost */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-                            control */
-#define ANOMALY_05000283 /* A system MMR write is stalled indefinitely when
-                            killed in a particular stage*/
-#define ANOMALY_05000311 /* Erroneous flag pin operations under specific
-			    sequences */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
-#define ANOMALY_05000313 /* PPI Is Level-Sensitive on First Transfer  */
-#define ANOMALY_05000315 /* Killed System MMR Write Completes Erroneously On
-			  *  Next System MMR Access */
-#define ANOMALY_05000319 /* Internal Voltage Regulator Values of 1.05V, 1.10V
-			  *  and 1.15V Not Allowed for LQFP Packages */
-#endif /* Issues that are common to 0.5, 0.4, and 0.3 silicon */
+#if defined(__ADSPBF531__)
+# define ANOMALY_BF531 1
+#else
+# define ANOMALY_BF531 0
+#endif
+#if defined(__ADSPBF532__)
+# define ANOMALY_BF532 1
+#else
+# define ANOMALY_BF532 0
+#endif
+#if defined(__ADSPBF533__)
+# define ANOMALY_BF533 1
+#else
+# define ANOMALY_BF533 0
+#endif
 
-/* These issues only occur on 0.3 or 0.4 BF533 */
-#if (defined(CONFIG_BF_REV_0_4) || defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000099 /* UART Line Status Register (UART_LSR) bits are not
-                            updated at the same time. */
-#define ANOMALY_05000158 /* Boot fails when data cache enabled: Data from a Data
-        		    Cache Fill can be corrupted after or during
-                            Instruction DMA if certain core stalls exist */
-#define ANOMALY_05000179 /* PPI_COUNT cannot be programmed to 0 in General
-                            Purpose TX or RX modes */
-#define ANOMALY_05000198 /* Failing SYSTEM MMR accesses when stalled by
-                            preceding memory read */
-#define ANOMALY_05000200 /* SPORT TFS and DT are incorrectly driven during
-                            inactive channels in certain conditions */
-#define ANOMALY_05000202 /* Possible infinite stall with specific dual dag
-                            situation */
-#define ANOMALY_05000215 /* UART TX Interrupt masked erroneously */
-#define ANOMALY_05000225 /* Incorrect pulse-width of UART start-bit */
-#define ANOMALY_05000227 /* Scratchpad memory bank reads may return incorrect
-                            data*/
-#define ANOMALY_05000230 /* UART Receiver is less robust against Baudrate
-                            Differences in certain Conditions */
-#define ANOMALY_05000231 /* UART STB bit incorrectly affects receiver setting */
-#define ANOMALY_05000242 /* DF bit in PLL_CTL register does not respond to
-                            hardware reset */
-#define ANOMALY_05000244 /* With instruction cache enabled, a CSYNC or SSYNC or
-                            IDLE around a Change of Control causes
-                            unpredictable results */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an access in the
-                            shadow of a conditional branch */
-#define ANOMALY_05000246 /* Data CPLB's should prevent spurious hardware
-                            errors */
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-                            interrupt not functional */
-#define ANOMALY_05000257 /* An interrupt or exception during short Hardware
-                            loops may cause the instruction fetch unit to
-                            malfunction */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bit 9 and 12 of
-                            the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB exception */
-#define ANOMALY_05000264 /* A Sync instruction (CSYNC, SSYNC) or an IDLE
-                            instruction will cause an infinite stall in the
-                            second to last instruction in a hardware loop */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            SPORT external receive and transmit clocks. */
-#define ANOMALY_05000269 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to increase. */
-#define ANOMALY_05000270 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to decrease */
-#endif /* issues only occur on 0.3 or 0.4 BF533 */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
+#define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
+/* Watchpoint Status Register (WPSTAT) Bits Are Set on Every Corresponding Match */
+#define ANOMALY_05000105 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Instruction DMA Can Cause Data Cache Fills to Fail (Boot Implications) */
+#define ANOMALY_05000158 (__SILICON_REVISION__ < 5)
+/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+#define ANOMALY_05000166 (1)
+/* Turning Serial Ports on with External Frame Syncs */
+#define ANOMALY_05000167 (1)
+/* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
+#define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
+/* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
+#define ANOMALY_05000180 (1)
+/* Timer Pin Limitations for PPI TX Modes with External Frame Syncs */
+#define ANOMALY_05000183 (__SILICON_REVISION__ < 4)
+/* False Protection Exceptions */
+#define ANOMALY_05000189 (__SILICON_REVISION__ < 4)
+/* False I/O Pin Interrupts on Edge-Sensitive Inputs When Polarity Setting Is Changed */
+#define ANOMALY_05000193 (__SILICON_REVISION__ < 4)
+/* Restarting SPORT in Specific Modes May Cause Data Corruption */
+#define ANOMALY_05000194 (__SILICON_REVISION__ < 4)
+/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+#define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
+/* Current DMA Address Shows Wrong Value During Carry Fix */
+#define ANOMALY_05000199 (__SILICON_REVISION__ < 4)
+/* SPORT TFS and DT Are Incorrectly Driven During Inactive Channels in Certain Conditions */
+#define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
+/* Receive Frame Sync Not Ignored During Active Frames in SPORT Multi-Channel Mode */
+#define ANOMALY_05000201 (__SILICON_REVISION__ < 4)
+/* Possible Infinite Stall with Specific Dual-DAG Situation */
+#define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
+/* Specific Sequence That Can Cause DMA Error or DMA Stopping */
+#define ANOMALY_05000203 (__SILICON_REVISION__ < 4)
+/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+#define ANOMALY_05000204 (__SILICON_REVISION__ < 4 && ANOMALY_BF533)
+/* Recovery from "Brown-Out" Condition */
+#define ANOMALY_05000207 (__SILICON_REVISION__ < 4)
+/* VSTAT Status Bit in PLL_STAT Register Is Not Functional */
+#define ANOMALY_05000208 (1)
+/* Speed Path in Computational Unit Affects Certain Instructions */
+#define ANOMALY_05000209 (__SILICON_REVISION__ < 4)
+/* UART TX Interrupt Masked Erroneously */
+#define ANOMALY_05000215 (__SILICON_REVISION__ < 5)
+/* NMI Event at Boot Time Results in Unpredictable State */
+#define ANOMALY_05000219 (1)
+/* Incorrect Pulse-Width of UART Start Bit */
+#define ANOMALY_05000225 (__SILICON_REVISION__ < 5)
+/* Scratchpad Memory Bank Reads May Return Incorrect Data */
+#define ANOMALY_05000227 (__SILICON_REVISION__ < 5)
+/* SPI Slave Boot Mode Modifies Registers from Reset Value */
+#define ANOMALY_05000229 (1)
+/* UART Receiver is Less Robust Against Baudrate Differences in Certain Conditions */
+#define ANOMALY_05000230 (__SILICON_REVISION__ < 5)
+/* UART STB Bit Incorrectly Affects Receiver Setting */
+#define ANOMALY_05000231 (__SILICON_REVISION__ < 5)
+/* PPI_FS3 Is Not Driven in 2 or 3 Internal Frame Sync Transmit Modes */
+#define ANOMALY_05000233 (__SILICON_REVISION__ < 4)
+/* Incorrect Revision Number in DSPID Register */
+#define ANOMALY_05000234 (__SILICON_REVISION__ == 4)
+/* DF Bit in PLL_CTL Register Does Not Respond to Hardware Reset */
+#define ANOMALY_05000242 (__SILICON_REVISION__ < 4)
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (1)
+/* Data CPLBs Should Prevent Spurious Hardware Errors */
+#define ANOMALY_05000246 (__SILICON_REVISION__ < 5)
+/* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ == 4)
+/* Maximum External Clock Speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 5)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 4)
+/* Entering Hibernate State with RTC Seconds Interrupt Not Functional */
+#define ANOMALY_05000255 (__SILICON_REVISION__ < 5)
+/* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 5)
+/* Instruction Cache Is Corrupted When Bits 9 and 12 of the ICPLB Data Registers Differ */
+#define ANOMALY_05000258 (__SILICON_REVISION__ < 5)
+/* ICPLB_STATUS MMR Register May Be Corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ < 5)
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 5)
+/* Stores To Data Cache May Be Lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 5)
+/* Hardware Loop Corrupted When Taking an ICPLB Exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ < 5)
+/* CSYNC/SSYNC/IDLE Causes Infinite Stall in Penultimate Instruction in Hardware Loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 5)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (__SILICON_REVISION__ < 5)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Increase */
+#define ANOMALY_05000269 (__SILICON_REVISION__ < 5)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
+#define ANOMALY_05000270 (__SILICON_REVISION__ < 5)
+/* Spontaneous Reset of Internal Voltage Regulator */
+#define ANOMALY_05000271 (__SILICON_REVISION__ < 4)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* Writes to Synchronous SDRAM Memory May Be Lost */
+#define ANOMALY_05000273 (1)
+/* Timing Requirements Change for External Frame Sync PPI Modes with Non-Zero PPI_DELAY */
+#define ANOMALY_05000276 (1)
+/* Writes to an I/O Data Register One SCLK Cycle after an Edge Is Detected May Clear Interrupt */
+#define ANOMALY_05000277 (1)
+/* Disabling Peripherals with DMA Running May Cause DMA System Instability */
+#define ANOMALY_05000278 (1)
+/* False Hardware Error Exception When ISR Context Is Not Restored */
+#define ANOMALY_05000281 (1)
+/* Memory DMA Corruption with 32-Bit Data and Traffic Control */
+#define ANOMALY_05000282 (1)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (1)
+/* SPORTs May Receive Bad Data If FIFOs Fill Up */
+#define ANOMALY_05000288 (1)
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+#define ANOMALY_05000302 (__SILICON_REVISION__ < 5)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
+/* New Feature: Additional PPI Frame Sync Sampling Options (Not Available On Older Silicon) */
+#define ANOMALY_05000306 (__SILICON_REVISION__ < 5)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Erroneous Flag (GPIO) Pin Operations under Specific Sequences */
+#define ANOMALY_05000311 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI Is Level-Sensitive on First Transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (1)
+/* Internal Voltage Regulator Values of 1.05V, 1.10V and 1.15V Not Allowed for LQFP Packages */
+#define ANOMALY_05000319 (ANOMALY_BF531 || ANOMALY_BF532)
 
-/* These issues are only on 0.4 silicon */
-#if (defined(CONFIG_BF_REV_0_4))
-#define ANOMALY_05000234 /* Incorrect Revision Number in DSPID Register */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) */
-#endif /* issues are only on 0.4 silicon */
+/* These anomalies have been "phased" out of analog.com anomaly sheets and are
+ * here to show running on older silicon just isn't feasible.
+ */
 
-/* These issues are only on 0.3 silicon */
-#if defined(CONFIG_BF_REV_0_3)
-#define ANOMALY_05000183 /* Timer Pin limitations for PPI TX Modes with
-                            External Frame Syncs */
-#define ANOMALY_05000189 /* False Protection Exceptions caused by Speculative
-                            Instruction or Data Fetches, or by Fetches at the
-                            boundary of reserved memory space */
-#define ANOMALY_05000193 /* False Flag Pin Interrupts on Edge Sensitive Inputs
-                            when polarity setting is changed */
-#define ANOMALY_05000194 /* Sport Restarting in specific modes may cause data
-                            corruption */
-#define ANOMALY_05000199 /* DMA current address shows wrong value during carry
-                            fix */
-#define ANOMALY_05000201 /* Receive frame sync not ignored during active
-                            frames in sport MCM */
-#define ANOMALY_05000203 /* Specific sequence that can cause DMA error or DMA
-                            stopping */
-#if defined(CONFIG_BF533)
-#define ANOMALY_05000204 /* Incorrect data read with write-through cache and
-                            allocate cache lines on reads only mode */
-#endif /* CONFIG_BF533 */
-#define ANOMALY_05000207 /* Recovery from "brown-out" condition */
-#define ANOMALY_05000209 /* Speed-Path in computational unit affects certain
-                            instructions */
-#define ANOMALY_05000233 /* PPI_FS3 is not driven in 2 or 3 internal Frame
-                            Sync Transmit Mode */
-#define ANOMALY_05000271 /* Spontaneous reset of Internal Voltage Regulator */
-#endif /* only on 0.3 silicon */
+/* Watchpoints (Hardware Breakpoints) are not supported */
+#define ANOMALY_05000067 (__SILICON_REVISION__ < 3)
+/* Reserved bits in SYSCFG register not set at power on */
+#define ANOMALY_05000109 (__SILICON_REVISION__ < 3)
+/* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
+#define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
+/* DTEST_COMMAND initiated memory access may be incorrect if data cache or DMA is active */
+#define ANOMALY_05000123 (__SILICON_REVISION__ < 3)
+/* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
+#define ANOMALY_05000124 (__SILICON_REVISION__ < 3)
+/* Erroneous exception when enabling cache */
+#define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
+/* SPI clock polarity and phase bits incorrect during booting */
+#define ANOMALY_05000126 (__SILICON_REVISION__ < 3)
+/* DMEM_CONTROL is not set on Reset */
+#define ANOMALY_05000137 (__SILICON_REVISION__ < 3)
+/* SPI boot will not complete if there is a zero fill block in the loader file */
+#define ANOMALY_05000138 (__SILICON_REVISION__ < 3)
+/* Allowing the SPORT RX FIFO to fill will cause an overflow */
+#define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
+/* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
+#define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
+/* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
+#define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
+/* A read from external memory may return a wrong value with data cache enabled */
+#define ANOMALY_05000143 (__SILICON_REVISION__ < 3)
+/* DMA and TESTSET conflict when both are accessing external memory */
+#define ANOMALY_05000144 (__SILICON_REVISION__ < 3)
+/* In PWM_OUT mode, you must enable the PPI block to generate a waveform from PPI_CLK */
+#define ANOMALY_05000145 (__SILICON_REVISION__ < 3)
+/* MDMA may lose the first few words of a descriptor chain */
+#define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
+/* The source MDMA descriptor may stop with a DMA Error */
+#define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
+/* When booting from a 16-bit asynchronous memory device, the upper 8-bits of each word must be 0x00 */
+#define ANOMALY_05000148 (__SILICON_REVISION__ < 3)
+/* Frame Delay in SPORT Multichannel Mode */
+#define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
+/* SPORT TFS signal is active in Multi-channel mode outside of valid channels */
+#define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
+/* Timer1 can not be used for PWMOUT mode when a certain PPI mode is in use */
+#define ANOMALY_05000155 (__SILICON_REVISION__ < 3)
+/* A killed 32-bit System MMR write will lead to the next system MMR access thinking it should be 32-bit. */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
+/* SPORT transmit data is not gated by external frame sync in certain conditions */
+#define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
+/* SDRAM auto-refresh and subsequent Power Ups */
+#define ANOMALY_05000168 (__SILICON_REVISION__ < 3)
+/* DATA CPLB page miss can result in lost write-through cache data writes */
+#define ANOMALY_05000169 (__SILICON_REVISION__ < 3)
+/* DMA vs Core accesses to external memory */
+#define ANOMALY_05000173 (__SILICON_REVISION__ < 3)
+/* Cache Fill Buffer Data lost */
+#define ANOMALY_05000174 (__SILICON_REVISION__ < 3)
+/* Overlapping Sequencer and Memory Stalls */
+#define ANOMALY_05000175 (__SILICON_REVISION__ < 3)
+/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+#define ANOMALY_05000176 (__SILICON_REVISION__ < 3)
+/* Disabling the PPI resets the PPI configuration registers */
+#define ANOMALY_05000181 (__SILICON_REVISION__ < 3)
+/* PPI TX Mode with 2 External Frame Syncs */
+#define ANOMALY_05000185 (__SILICON_REVISION__ < 3)
+/* PPI does not invert the Driving PPICLK edge in Transmit Modes */
+#define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
+/* In PPI Transmit Modes with External Frame Syncs POLC */
+#define ANOMALY_05000192 (__SILICON_REVISION__ < 3)
+/* Internal Voltage Regulator may not start up */
+#define ANOMALY_05000206 (__SILICON_REVISION__ < 3)
 
-#if defined(CONFIG_BF_REV_0_2)
-#define ANOMALY_05000067 /* Watchpoints (Hardware Breakpoints) are not
-			  *  supported */
-#define ANOMALY_05000109 /* Reserved bits in SYSCFG register not set at
-			  *  power on */
-#define ANOMALY_05000116 /* Trace Buffers may record discontinuities into
-			  *  emulation mode and/or exception, NMI, reset
-			  *  handlers */
-#define ANOMALY_05000123 /* DTEST_COMMAND initiated memory access may be
-			  *  incorrect if data cache or DMA is active */
-#define ANOMALY_05000124 /* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1,
-			  *  or 1:1 */
-#define ANOMALY_05000125 /* Erroneous exception when enabling cache */
-#define ANOMALY_05000126 /* SPI clock polarity and phase bits incorrect
-			  *  during booting */
-#define ANOMALY_05000137 /* DMEM_CONTROL is not set on Reset */
-#define ANOMALY_05000138 /* SPI boot will not complete if there is a zero fill
-			  * block in the loader file */
-#define ANOMALY_05000140 /* Allowing the SPORT RX FIFO to fill will cause an
-			  *  overflow */
-#define ANOMALY_05000141 /* An Infinite Stall occurs with a particular sequence
-			  *  of consecutive dual dag events */
-#define ANOMALY_05000142 /* Interrupts may be lost when a programmable input
-			  *  flag is configured to be edge sensitive */
-#define ANOMALY_05000143 /* A read from external memory may return a wrong
-			  *  value with data cache enabled */
-#define ANOMALY_05000144 /* DMA and TESTSET conflict when both are accessing
-			  *  external memory */
-#define ANOMALY_05000145 /* In PWM_OUT mode, you must enable the PPI block to
-			  *  generate a waveform from PPI_CLK */
-#define ANOMALY_05000146 /* MDMA may lose the first few words of a descriptor
-			  *  chain */
-#define ANOMALY_05000147 /* The source MDMA descriptor may stop with a DMA
-			  *  Error */
-#define ANOMALY_05000148 /* When booting from a 16-bit asynchronous memory
-			  *  device, the upper 8-bits of each word must be
-			  *  0x00 */
-#define ANOMALY_05000153 /* Frame Delay in SPORT Multichannel Mode */
-#define ANOMALY_05000154 /* SPORT TFS signal is active in Multi-channel mode
-			  *  outside of valid channels */
-#define ANOMALY_05000155 /* Timer1 can not be used for PWMOUT mode when a
-			  *  certain PPI mode is in use */
-#define ANOMALY_05000157 /* A killed 32-bit System MMR write will lead to
-			  *  the next system MMR access thinking it should be
-			  *  32-bit. */
-#define ANOMALY_05000163 /* SPORT transmit data is not gated by external frame
-			  *  sync in certain conditions */
-#define ANOMALY_05000168 /* SDRAM auto-refresh and subsequent Power Ups */
-#define ANOMALY_05000169 /* DATA CPLB page miss can result in lost
-			  *  write-through cache data writes */
-#define ANOMALY_05000173 /* DMA vs Core accesses to external memory */
-#define ANOMALY_05000174 /* Cache Fill Buffer Data lost */
-#define ANOMALY_05000175 /* Overlapping Sequencer and Memory Stalls */
-#define ANOMALY_05000176 /* Multiplication of (-1) by (-1) followed by an
-			  *  accumulator saturation */
-#define ANOMALY_05000181 /* Disabling the PPI resets the PPI configuration
-			  *  registers */
-#define ANOMALY_05000185 /* PPI TX Mode with 2 External Frame Syncs */
-#define ANOMALY_05000191 /* PPI does not invert the Driving PPICLK edge in
-			  *  Transmit Modes */
-#define ANOMALY_05000192 /* In PPI Transmit Modes with External Frame Syncs
-			  *  POLC */
-#define ANOMALY_05000206 /* Internal Voltage Regulator may not start up */
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000266 (0)
 
 #endif
-
-#endif /*  _MACH_ANOMALY_H_ */
diff --git a/include/asm-blackfin/mach-bf533/bf533.h b/include/asm-blackfin/mach-bf533/bf533.h
index 185fc12..41e4e83 100644
--- a/include/asm-blackfin/mach-bf533/bf533.h
+++ b/include/asm-blackfin/mach-bf533/bf533.h
@@ -226,7 +226,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
diff --git a/include/asm-blackfin/mach-bf533/cdefBF532.h b/include/asm-blackfin/mach-bf533/cdefBF532.h
index 74f967b..40c1ad3 100644
--- a/include/asm-blackfin/mach-bf533/cdefBF532.h
+++ b/include/asm-blackfin/mach-bf533/cdefBF532.h
@@ -30,11 +30,9 @@
 
 #ifndef _CDEF_BF532_H
 #define _CDEF_BF532_H
-/*
-#if !defined(__ADSPLPBLACKFIN__)
-#warning cdefBF532.h should only be included for 532 compatible chips.
-#endif
-*/
+
+#include <asm/blackfin.h>
+
 /*include all Core registers and bit definitions*/
 #include "defBF532.h"
 
@@ -65,7 +63,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
diff --git a/include/asm-blackfin/mach-bf537/anomaly.h b/include/asm-blackfin/mach-bf537/anomaly.h
index 4453e61..3803f15 100644
--- a/include/asm-blackfin/mach-bf537/anomaly.h
+++ b/include/asm-blackfin/mach-bf537/anomaly.h
@@ -1,139 +1,141 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf537/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
+ * File: include/asm-blackfin/mach-bf537/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision J, June 1, 2006; ADSP-BF537 Blackfin Processor Anomaly List
- *  - Revision I, June 1, 2006; ADSP-BF536 Blackfin Processor Anomaly List
- *  - Revision J, June 1, 2006; ADSP-BF534 Blackfin Processor Anomaly List
+ *  - Revision M, March 13, 2007; ADSP-BF537 Blackfin Processor Anomaly List
+ *  - Revision L, March 13, 2007; ADSP-BF536 Blackfin Processor Anomaly List
+ *  - Revision M, March 13, 2007; ADSP-BF534 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
 /* We do not support 0.1 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1))
-#error Kernel will not work on BF537/6/4 Version 0.1
+#if __SILICON_REVISION__ < 2
+# error Kernel will not work on BF537 silicon version 0.0 or 0.1
 #endif
 
-#if (defined(CONFIG_BF_REV_0_3) || defined(CONFIG_BF_REV_0_2))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-                            Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-                            registers. */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits*/
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000247 /* CLKIN Buffer Output Enable Reset Behavior Is
-                            Changed */
-#endif
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            SPORT external receive and transmit clocks. */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000273 /* Writes to Synchronous SDRAM memory may be lost */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-                            control */
-#define ANOMALY_05000283 /* A system MMR write is stalled indefinitely when
-                            killed in a particular stage*/
-#define ANOMALY_05000310 /* False hardware errors caused by fetches at the
-			  *  boundary of reserved memory */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
-#define ANOMALY_05000313 /* PPI is level sensitive on first transfer */
-#define ANOMALY_05000322 /* EMAC RMII mode at 10-Base-T speed: RX frames not
-			  *  received properly */
+#if defined(__ADSPBF534__)
+# define ANOMALY_BF534 1
+#else
+# define ANOMALY_BF534 0
 #endif
-
-#if defined(CONFIG_BF_REV_0_2)
-#define ANOMALY_05000244 /* With instruction cache enabled, a CSYNC or SSYNC or
-                            IDLE around a Change of Control causes
-                            unpredictable results */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000252 /* EMAC Tx DMA error after an early frame abort */
+#if defined(__ADSPBF536__)
+# define ANOMALY_BF536 1
+#else
+# define ANOMALY_BF536 0
 #endif
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-                            interrupt not functional */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000256 /* EMAC MDIO input latched on wrong MDC edge */
+#if defined(__ADSPBF537__)
+# define ANOMALY_BF537 1
+#else
+# define ANOMALY_BF537 0
 #endif
-#define ANOMALY_05000257 /* An interrupt or exception during short Hardware
-                            loops may cause the instruction fetch unit to
-                            malfunction */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bit 9 and 12 of
-                            the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB exception */
-#define ANOMALY_05000264 /* A Sync instruction (CSYNC, SSYNC) or an IDLE
-                            instruction will cause an infinite stall in the
-                            second to last instruction in a hardware loop */
-#define ANOMALY_05000268 /* Memory DMA error when peripheral DMA is running
-                            and non-zero DEB_TRAFFIC_PERIOD value */
-#define ANOMALY_05000270 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to decrease */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000280 /* SPI Master boot mode does not work well with
-                            Atmel Dataflash devices */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context
-			  *  is not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-			  *  control */
-#define ANOMALY_05000283 /* System MMR Write Is Stalled Indefinitely When
-			  *  Killed in a Particular Stage */
-#define ANOMALY_05000285 /* New Feature: EMAC TX DMA Word Alignment
-			  *  (Not Available On Older Silicon) */
-#define ANOMALY_05000288 /* SPORTs may receive bad data if FIFOs fill up */
-#define ANOMALY_05000315 /* Killed System MMR Write Completes Erroneously
-			  *  On Next System MMR Access */
-#define ANOMALY_05000316 /* EMAC RMII mode: collisions occur in Full Duplex
-			  *  mode */
-#define ANOMALY_05000321 /* EMAC RMII mode: TX frames in half duplex fail with
-			  *  status No Carrier */
-#endif  /* CONFIG_BF_REV_0_2 */
 
-#endif /* _MACH_ANOMALY_H_ */
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+#define ANOMALY_05000074 (1)
+/* DMA_RUN bit is not valid after a Peripheral Receive Channel DMA stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H cannot be used to access 16-bit System MMR registers */
+#define ANOMALY_05000122 (1)
+/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 2)
+/* PPI_DELAY not functional in PPI modes with 0 frame syncs */
+#define ANOMALY_05000180 (1)
+/* Instruction Cache Is Not Functional */
+#define ANOMALY_05000237 (__SILICON_REVISION__ < 2)
+/* If i-cache is on, CSYNC/SSYNC/IDLE around Change of Control causes failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 3)
+/* Spurious Hardware Error from an access in the shadow of a conditional branch */
+#define ANOMALY_05000245 (1)
+/* CLKIN Buffer Output Enable Reset Behavior Is Changed */
+#define ANOMALY_05000247 (1)
+/* Incorrect Bit-Shift of Data Word in Multichannel (TDM) mode in certain conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ < 3)
+/* EMAC Tx DMA error after an early frame abort */
+#define ANOMALY_05000252 (__SILICON_REVISION__ < 3)
+/* Maximum external clock speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 3)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT mode with external clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 2)
+/* Entering Hibernate Mode with RTC Seconds event interrupt not functional */
+#define ANOMALY_05000255 (__SILICON_REVISION__ < 3)
+/* EMAC MDIO input latched on wrong MDC edge */
+#define ANOMALY_05000256 (__SILICON_REVISION__ < 3)
+/* Interrupt/Exception during short hardware loop may cause bad instruction fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 3)
+/* Instruction Cache is corrupted when bits 9 and 12 of the ICPLB Data registers differ */
+#define ANOMALY_05000258 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ == 1) || __SILICON_REVISION__ == 2)
+/* ICPLB_STATUS MMR register may be corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ == 2)
+/* DCPLB_FAULT_ADDR MMR register may be corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 3)
+/* Stores to data cache may be lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 3)
+/* Hardware loop corrupted when taking an ICPLB exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ == 2)
+/* CSYNC/SSYNC/IDLE causes infinite stall in second to last instruction in hardware loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 3)
+/* Sensitivity to noise with slow input edge rates on external SPORT TX and RX clocks */
+#define ANOMALY_05000265 (1)
+/* Memory DMA error when peripheral DMA is running with non-zero DEB_TRAFFIC_PERIOD */
+#define ANOMALY_05000268 (__SILICON_REVISION__ < 3)
+/* High I/O activity causes output voltage of internal voltage regulator (VDDint) to decrease */
+#define ANOMALY_05000270 (__SILICON_REVISION__ < 3)
+/* Certain data cache write through modes fail for VDDint <=0.9V */
+#define ANOMALY_05000272 (1)
+/* Writes to Synchronous SDRAM memory may be lost */
+#define ANOMALY_05000273 (__SILICON_REVISION__ < 3)
+/* Writes to an I/O data register one SCLK cycle after an edge is detected may clear interrupt */
+#define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
+/* Disabling Peripherals with DMA running may cause DMA system instability */
+#define ANOMALY_05000278 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ < 3) || (ANOMALY_BF534 && __SILICON_REVISION__ < 2))
+/* SPI Master boot mode does not work well with Atmel Data flash devices */
+#define ANOMALY_05000280 (1)
+/* False Hardware Error Exception when ISR context is not restored */
+#define ANOMALY_05000281 (__SILICON_REVISION__ < 3)
+/* Memory DMA corruption with 32-bit data and traffic control */
+#define ANOMALY_05000282 (__SILICON_REVISION__ < 3)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (__SILICON_REVISION__ < 3)
+/* New Feature: EMAC TX DMA Word Alignment (Not Available On Older Silicon) */
+#define ANOMALY_05000285 (__SILICON_REVISION__ < 3)
+/* SPORTs may receive bad data if FIFOs fill up */
+#define ANOMALY_05000288 (__SILICON_REVISION__ < 3)
+/* Memory to memory DMA source/destination descriptors must be in same memory space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
+#define ANOMALY_05000304 (__SILICON_REVISION__ < 3)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 3)
+/* SCKELOW Bit Does Not Maintain State Through Hibernate */
+#define ANOMALY_05000307 (__SILICON_REVISION__ < 3)
+/* Writing UART_THR while UART clock is disabled sends erroneous start bit */
+#define ANOMALY_05000309 (__SILICON_REVISION__ < 3)
+/* False hardware errors caused by fetches at the boundary of reserved memory */
+#define ANOMALY_05000310 (1)
+/* Errors when SSYNC, CSYNC, or loads to LT, LB and LC registers are interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI is level sensitive on first transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode: collisions occur in Full Duplex mode */
+#define ANOMALY_05000316 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode: TX frames in half duplex fail with status No Carrier */
+#define ANOMALY_05000321 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode at 10-Base-T speed: RX frames not received properly */
+#define ANOMALY_05000322 (1)
+
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000125 (0)
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000198 (0)
+#define ANOMALY_05000266 (0)
+#define ANOMALY_05000311 (0)
+
+#endif
diff --git a/include/asm-blackfin/mach-bf537/bf537.h b/include/asm-blackfin/mach-bf537/bf537.h
index b8924cd..04b0816 100644
--- a/include/asm-blackfin/mach-bf537/bf537.h
+++ b/include/asm-blackfin/mach-bf537/bf537.h
@@ -206,7 +206,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
diff --git a/include/asm-blackfin/mach-bf537/cdefBF534.h b/include/asm-blackfin/mach-bf537/cdefBF534.h
index 84e58fa..78227bc 100644
--- a/include/asm-blackfin/mach-bf537/cdefBF534.h
+++ b/include/asm-blackfin/mach-bf537/cdefBF534.h
@@ -32,6 +32,8 @@
 #ifndef _CDEF_BF534_H
 #define _CDEF_BF534_H
 
+#include <asm/blackfin.h>
+
 /* Include all Core registers and bit definitions 									*/
 #include "defBF534.h"
 
@@ -57,7 +59,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
diff --git a/include/asm-blackfin/mach-bf548/anomaly.h b/include/asm-blackfin/mach-bf548/anomaly.h
index aca1d4b..2248378 100644
--- a/include/asm-blackfin/mach-bf548/anomaly.h
+++ b/include/asm-blackfin/mach-bf548/anomaly.h
@@ -1,74 +1,82 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf548/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * File: include/asm-blackfin/mach-bf548/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+/* This file shoule be up to date with:
+ *  - Revision C, July 16, 2007; ADSP-BF549 Silicon Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-			    slot1 and store of a P register in slot 2 is not
-			    supported */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-			    Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-			    registers. */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an Access in the
-			    Shadow of a Conditional Branch */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-			    interrupt not functional */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-			    SPORT external receive and transmit clocks. */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-			    VDDint <=0.9V */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-			    not restored */
-#define ANOMALY_05000310 /* False Hardware Errors Caused by Fetches at the
-			    Boundary of Reserved Memory */
-#define ANOMALY_05000312 /* Errors When SSYNC, CSYNC, or Loads to LT, LB and
-			    LC Registers Are Interrupted */
-#define ANOMALY_05000324 /* TWI Slave Boot Mode Is Not Functional */
-#define ANOMALY_05000325 /* External FIFO Boot Mode Is Not Functional */
-#define ANOMALY_05000327 /* Data Lost When Core and DMA Accesses Are Made to
-			    the USB FIFO Simultaneously */
-#define ANOMALY_05000328 /* Incorrect Access of OTP_STATUS During otp_write()
-			    function */
-#define ANOMALY_05000329 /* Synchronous Burst Flash Boot Mode Is Not Functional
-			    */
-#define ANOMALY_05000330 /* Host DMA Boot Mode Is Not Functional */
-#define ANOMALY_05000334 /* Inadequate Timing Margins on DDR DQS to DQ and DQM
-			    Skew */
-#define ANOMALY_05000335 /* Inadequate Rotary Debounce Logic Duration */
-#define ANOMALY_05000336 /* Phantom Interrupt Occurs After First Configuration
-			    of Host DMA Port */
-#define ANOMALY_05000337 /* Disallowed Configuration Prevents Subsequent
-			    Allowed Configuration on Host DMA Port */
-#define ANOMALY_05000338 /* Slave-Mode SPI0 MISO Failure With CPHA = 0 */
 
-#endif /* _MACH_ANOMALY_H_ */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (1)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (1)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* False Hardware Error Exception when ISR context is not restored */
+#define ANOMALY_05000281 (1)
+/* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
+#define ANOMALY_05000304 (1)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* TWI Slave Boot Mode Is Not Functional */
+#define ANOMALY_05000324 (1)
+/* External FIFO Boot Mode Is Not Functional */
+#define ANOMALY_05000325 (1)
+/* Data Lost When Core and DMA Accesses Are Made to the USB FIFO Simultaneously */
+#define ANOMALY_05000327 (1)
+/* Incorrect Access of OTP_STATUS During otp_write() Function */
+#define ANOMALY_05000328 (1)
+/* Synchronous Burst Flash Boot Mode Is Not Functional */
+#define ANOMALY_05000329 (1)
+/* Host DMA Boot Mode Is Not Functional */
+#define ANOMALY_05000330 (1)
+/* Inadequate Timing Margins on DDR DQS to DQ and DQM Skew */
+#define ANOMALY_05000334 (1)
+/* Inadequate Rotary Debounce Logic Duration */
+#define ANOMALY_05000335 (1)
+/* Phantom Interrupt Occurs After First Configuration of Host DMA Port */
+#define ANOMALY_05000336 (1)
+/* Disallowed Configuration Prevents Subsequent Allowed Configuration on Host DMA Port */
+#define ANOMALY_05000337 (1)
+/* Slave-Mode SPI0 MISO Failure With CPHA = 0 */
+#define ANOMALY_05000338 (1)
+/* If Memory Reads Are Enabled on SDH or HOSTDP, Other DMAC1 Peripherals Cannot Read */
+#define ANOMALY_05000340 (1)
+/* Boot Host Wait (HWAIT) and Boot Host Wait Alternate (HWAITA) Signals Are Swapped */
+#define ANOMALY_05000344 (1)
+/* USB Calibration Value Is Not Intialized */
+#define ANOMALY_05000346 (1)
+/* Boot ROM Kernel Incorrectly Alters Reset Value of USB Register */
+#define ANOMALY_05000347 (1)
+/* Data Lost when Core Reads SDH Data FIFO */
+#define ANOMALY_05000349 (1)
+/* PLL Status Register Is Inaccurate */
+#define ANOMALY_05000351 (1)
+
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000125 (0)
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000198 (0)
+#define ANOMALY_05000244 (0)
+#define ANOMALY_05000261 (0)
+#define ANOMALY_05000263 (0)
+#define ANOMALY_05000266 (0)
+#define ANOMALY_05000273 (0)
+#define ANOMALY_05000311 (0)
+
+#endif
diff --git a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
index cdf29e7..aefab3f 100644
--- a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
@@ -31,6 +31,8 @@
 #ifndef _CDEF_BF54X_H
 #define _CDEF_BF54X_H
 
+#include <asm/blackfin.h>
+
 #include "defBF54x_base.h"
 #include <asm/system.h>
 
@@ -60,7 +62,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR2, 0);
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
diff --git a/include/asm-blackfin/mach-bf561/anomaly.h b/include/asm-blackfin/mach-bf561/anomaly.h
index f5b32d6..bed9564 100644
--- a/include/asm-blackfin/mach-bf561/anomaly.h
+++ b/include/asm-blackfin/mach-bf561/anomaly.h
@@ -1,184 +1,256 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf561/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * File: include/asm-blackfin/mach-bf561/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision L, 10Aug2006; ADSP-BF561 Silicon Anomaly List
+ *  - Revision N, March 28, 2007; ADSP-BF561 Silicon Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
-/* We do not support 0.1 or 0.4 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1) || defined(CONFIG_BF_REV_0_2) || defined(CONFIG_BF_REV_0_4))
-#error Kernel will not work on BF561 Version 0.1, 0.2, or 0.4
+/* We do not support 0.1, 0.2, or 0.4 silicon - sorry */
+#if __SILICON_REVISION__ < 3 || __SILICON_REVISION__ == 4
+# error Kernel will not work on BF561 silicon version 0.0, 0.1, 0.2, or 0.4
 #endif
 
-/* Issues that are common to 0.5 and  0.3 silicon */
-#if  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000099 /* UART Line Status Register (UART_LSR) bits are not
-                            updated at the same time. */
-#define ANOMALY_05000120 /* Testset instructions restricted to 32-bit aligned
-                            memory locations */
-#define ANOMALY_05000122 /* Rx.H cannot be used to access 16-bit System MMR
-                            registers */
-#define ANOMALY_05000127 /* Signbits instruction not functional under certain
-                            conditions */
-#define ANOMALY_05000149 /* IMDMA S1/D1 channel may stall */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits */
-#define ANOMALY_05000167 /* Turning Serial Ports on With External Frame Syncs */
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#define ANOMALY_05000182 /* IMDMA does not operate to full speed for 600MHz
-                            and higher devices */
-#define ANOMALY_05000187 /* IMDMA Corrupted Data after a Halt */
-#define ANOMALY_05000190 /* PPI not functional at core voltage < 1Volt */
-#define ANOMALY_05000208 /* VSTAT status bit in PLL_STAT register is not
-                            functional */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an access in the
-                            shadow of a conditional branch */
-#define ANOMALY_05000257 /* Interrupt/Exception during short hardware loop
-                            may cause bad instruction fetches */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            external SPORT TX and RX clocks */
-#define ANOMALY_05000267 /* IMDMA may corrupt data under certain conditions */
-#define ANOMALY_05000269 /* High I/O activity causes output voltage of internal
-                            voltage regulator (VDDint) to increase */
-#define ANOMALY_05000270 /* High I/O activity causes output voltage of internal
-                            voltage regulator (VDDint) to decrease */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000274 /* Data cache write back to external synchronous memory
-                            may be lost */
-#define ANOMALY_05000275 /* PPI Timing and sampling informaton updates */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
+#define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
+/* Trace Buffers may contain errors in emulation mode and/or exception, NMI, reset handlers */
+#define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
+/* Testset instructions restricted to 32-bit aligned memory locations */
+#define ANOMALY_05000120 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Erroneous exception when enabling cache */
+#define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
+/* Signbits instruction not functional under certain conditions */
+#define ANOMALY_05000127 (1)
+/* Two bits in the Watchpoint Status Register (WPSTAT) are swapped */
+#define ANOMALY_05000134 (__SILICON_REVISION__ < 3)
+/* Enable wires from the Data Watchpoint Address Control Register (WPDACTL) are swapped */
+#define ANOMALY_05000135 (__SILICON_REVISION__ < 3)
+/* Stall in multi-unit DMA operations */
+#define ANOMALY_05000136 (__SILICON_REVISION__ < 3)
+/* Allowing the SPORT RX FIFO to fill will cause an overflow */
+#define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
+/* Infinite Stall may occur with a particular sequence of consecutive dual dag events */
+#define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
+/* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
+#define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
+/* DMA and TESTSET conflict when both are accessing external memory */
+#define ANOMALY_05000144 (__SILICON_REVISION__ < 3)
+/* In PWM_OUT mode, you must enable the PPI block to generate a waveform from PPI_CLK */
+#define ANOMALY_05000145 (__SILICON_REVISION__ < 3)
+/* MDMA may lose the first few words of a descriptor chain */
+#define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
+/* Source MDMA descriptor may stop with a DMA Error near beginning of descriptor fetch */
+#define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
+/* IMDMA S1/D1 channel may stall */
+#define ANOMALY_05000149 (1)
+/* DMA engine may lose data due to incorrect handshaking */
+#define ANOMALY_05000150 (__SILICON_REVISION__ < 3)
+/* DMA stalls when all three controllers read data from the same source */
+#define ANOMALY_05000151 (__SILICON_REVISION__ < 3)
+/* Execution stall when executing in L2 and doing external accesses */
+#define ANOMALY_05000152 (__SILICON_REVISION__ < 3)
+/* Frame Delay in SPORT Multichannel Mode */
+#define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
+/* SPORT TFS signal stays active in multichannel mode outside of valid channels */
+#define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
+/* Timers in PWM-Out Mode with PPI GP Receive (Input) Mode with 0 Frame Syncs */
+#define ANOMALY_05000156 (__SILICON_REVISION__ < 4)
+/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
+/* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
+#define ANOMALY_05000159 (__SILICON_REVISION__ < 3)
+/* A read from external memory may return a wrong value with data cache enabled */
+#define ANOMALY_05000160 (__SILICON_REVISION__ < 3)
+/* Data Cache Fill data can be corrupted after/during Instruction DMA if certain core stalls exist */
+#define ANOMALY_05000161 (__SILICON_REVISION__ < 3)
+/* DMEM_CONTROL<12> is not set on Reset */
+#define ANOMALY_05000162 (__SILICON_REVISION__ < 3)
+/* SPORT transmit data is not gated by external frame sync in certain conditions */
+#define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
+/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+#define ANOMALY_05000166 (1)
+/* Turning Serial Ports on with External Frame Syncs */
+#define ANOMALY_05000167 (1)
+/* SDRAM auto-refresh and subsequent Power Ups */
+#define ANOMALY_05000168 (__SILICON_REVISION__ < 5)
+/* DATA CPLB page miss can result in lost write-through cache data writes */
+#define ANOMALY_05000169 (__SILICON_REVISION__ < 5)
+/* Boot-ROM code modifies SICA_IWRx wakeup registers */
+#define ANOMALY_05000171 (__SILICON_REVISION__ < 5)
+/* DSPID register values incorrect */
+#define ANOMALY_05000172 (__SILICON_REVISION__ < 3)
+/* DMA vs Core accesses to external memory */
+#define ANOMALY_05000173 (__SILICON_REVISION__ < 3)
+/* Cache Fill Buffer Data lost */
+#define ANOMALY_05000174 (__SILICON_REVISION__ < 5)
+/* Overlapping Sequencer and Memory Stalls */
+#define ANOMALY_05000175 (__SILICON_REVISION__ < 5)
+/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+#define ANOMALY_05000176 (__SILICON_REVISION__ < 5)
+/* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
+#define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
+/* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
+#define ANOMALY_05000180 (1)
+/* Disabling the PPI resets the PPI configuration registers */
+#define ANOMALY_05000181 (__SILICON_REVISION__ < 5)
+/* IMDMA does not operate to full speed for 600MHz and higher devices */
+#define ANOMALY_05000182 (1)
+/* Timer Pin limitations for PPI TX Modes with External Frame Syncs */
+#define ANOMALY_05000184 (__SILICON_REVISION__ < 5)
+/* PPI TX Mode with 2 External Frame Syncs */
+#define ANOMALY_05000185 (__SILICON_REVISION__ < 5)
+/* PPI packing with Data Length greater than 8 bits (not a meaningful mode) */
+#define ANOMALY_05000186 (__SILICON_REVISION__ < 5)
+/* IMDMA Corrupted Data after a Halt */
+#define ANOMALY_05000187 (1)
+/* IMDMA Restrictions on Descriptor and Buffer Placement in Memory */
+#define ANOMALY_05000188 (__SILICON_REVISION__ < 5)
+/* False Protection Exceptions */
+#define ANOMALY_05000189 (__SILICON_REVISION__ < 5)
+/* PPI not functional at core voltage < 1Volt */
+#define ANOMALY_05000190 (1)
+/* PPI does not invert the Driving PPICLK edge in Transmit Modes */
+#define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
+/* False I/O Pin Interrupts on Edge-Sensitive Inputs When Polarity Setting Is Changed */
+#define ANOMALY_05000193 (__SILICON_REVISION__ < 5)
+/* Restarting SPORT in Specific Modes May Cause Data Corruption */
+#define ANOMALY_05000194 (__SILICON_REVISION__ < 5)
+/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+#define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
+/* Current DMA Address Shows Wrong Value During Carry Fix */
+#define ANOMALY_05000199 (__SILICON_REVISION__ < 5)
+/* SPORT TFS and DT Are Incorrectly Driven During Inactive Channels in Certain Conditions */
+#define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
+/* Possible Infinite Stall with Specific Dual-DAG Situation */
+#define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
+/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+#define ANOMALY_05000204 (__SILICON_REVISION__ < 5)
+/* Specific sequence that can cause DMA error or DMA stopping */
+#define ANOMALY_05000205 (__SILICON_REVISION__ < 5)
+/* Recovery from "Brown-Out" Condition */
+#define ANOMALY_05000207 (__SILICON_REVISION__ < 5)
+/* VSTAT Status Bit in PLL_STAT Register Is Not Functional */
+#define ANOMALY_05000208 (1)
+/* Speed Path in Computational Unit Affects Certain Instructions */
+#define ANOMALY_05000209 (__SILICON_REVISION__ < 5)
+/* UART TX Interrupt Masked Erroneously */
+#define ANOMALY_05000215 (__SILICON_REVISION__ < 5)
+/* NMI Event at Boot Time Results in Unpredictable State */
+#define ANOMALY_05000219 (__SILICON_REVISION__ < 5)
+/* Data Corruption with Cached External Memory and Non-Cached On-Chip L2 Memory */
+#define ANOMALY_05000220 (__SILICON_REVISION__ < 5)
+/* Incorrect Pulse-Width of UART Start Bit */
+#define ANOMALY_05000225 (__SILICON_REVISION__ < 5)
+/* Scratchpad Memory Bank Reads May Return Incorrect Data */
+#define ANOMALY_05000227 (__SILICON_REVISION__ < 5)
+/* UART Receiver is Less Robust Against Baudrate Differences in Certain Conditions */
+#define ANOMALY_05000230 (__SILICON_REVISION__ < 5)
+/* UART STB Bit Incorrectly Affects Receiver Setting */
+#define ANOMALY_05000231 (__SILICON_REVISION__ < 5)
+/* SPORT data transmit lines are incorrectly driven in multichannel mode */
+#define ANOMALY_05000232 (__SILICON_REVISION__ < 5)
+/* DF Bit in PLL_CTL Register Does Not Respond to Hardware Reset */
+#define ANOMALY_05000242 (__SILICON_REVISION__ < 5)
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (__SILICON_REVISION__ < 5)
+/* TESTSET operation forces stall on the other core */
+#define ANOMALY_05000248 (__SILICON_REVISION__ < 5)
+/* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ > 2 && __SILICON_REVISION__ < 5)
+/* Exception Not Generated for MMR Accesses in Reserved Region */
+#define ANOMALY_05000251 (__SILICON_REVISION__ < 5)
+/* Maximum External Clock Speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 5)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 3)
+/* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 5)
+/* Instruction Cache Is Corrupted When Bits 9 and 12 of the ICPLB Data Registers Differ */
+#define ANOMALY_05000258 (__SILICON_REVISION__ < 5)
+/* ICPLB_STATUS MMR Register May Be Corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ < 5)
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 5)
+/* Stores To Data Cache May Be Lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 5)
+/* Hardware Loop Corrupted When Taking an ICPLB Exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ < 5)
+/* CSYNC/SSYNC/IDLE Causes Infinite Stall in Penultimate Instruction in Hardware Loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 5)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (__SILICON_REVISION__ < 5)
+/* IMDMA destination IRQ status must be read prior to using IMDMA */
+#define ANOMALY_05000266 (__SILICON_REVISION__ > 3)
+/* IMDMA may corrupt data under certain conditions */
+#define ANOMALY_05000267 (1)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Increase */
+#define ANOMALY_05000269 (1)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
+#define ANOMALY_05000270 (1)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* Data cache write back to external synchronous memory may be lost */
+#define ANOMALY_05000274 (1)
+/* PPI Timing and Sampling Information Updates */
+#define ANOMALY_05000275 (__SILICON_REVISION__ > 2)
+/* Timing Requirements Change for External Frame Sync PPI Modes with Non-Zero PPI_DELAY */
+#define ANOMALY_05000276 (__SILICON_REVISION__ < 5)
+/* Disabling Peripherals with DMA Running May Cause DMA System Instability */
+#define ANOMALY_05000278 (__SILICON_REVISION__ < 5)
+/* False Hardware Error Exception When ISR Context Is Not Restored */
+#define ANOMALY_05000281 (__SILICON_REVISION__ < 5)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (1)
+/* A read will receive incorrect data under certain conditions */
+#define ANOMALY_05000287 (__SILICON_REVISION__ < 5)
+/* SPORTs May Receive Bad Data If FIFOs Fill Up */
+#define ANOMALY_05000288 (__SILICON_REVISION__ < 5)
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+#define ANOMALY_05000302 (1)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
+/* SCKELOW Bit Does Not Maintain State Through Hibernate */
+#define ANOMALY_05000307 (__SILICON_REVISION__ < 5)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI Is Level-Sensitive on First Transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (1)
+/* PF2 Output Remains Asserted After SPI Master Boot */
+#define ANOMALY_05000320 (__SILICON_REVISION__ > 3)
+/* Erroneous GPIO Flag Pin Operations Under Specific Sequences */
+#define ANOMALY_05000323 (1)
+/* SPORT Secondary Receive Channel Not Functional When Word Length Exceeds 16 Bits */
+#define ANOMALY_05000326 (__SILICON_REVISION__ > 3)
+/* New Feature: 24-Bit SPI Boot Mode Support (Not Available On Older Silicon) */
+#define ANOMALY_05000331 (__SILICON_REVISION__ < 5)
+/* New Feature: Slave SPI Boot Mode Supported (Not Available On Older Silicon) */
+#define ANOMALY_05000332 (__SILICON_REVISION__ < 5)
+/* Flag Data Register Writes One SCLK Cycle After Edge Is Detected May Clear Interrupt Status */
+#define ANOMALY_05000333 (__SILICON_REVISION__ < 5)
 
-#endif /*  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_3)) */
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000158 (0)
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000273 (0)
+#define ANOMALY_05000311 (0)
 
-#if  (defined(CONFIG_BF_REV_0_5))
-#define ANOMALY_05000254 /* Incorrect Timer Pulse Width in Single-Shot PWM_OUT
-                            mode with external clock */
-#define ANOMALY_05000266 /* IMDMA destination IRQ status must be read prior to
-                            using IMDMA */
 #endif
-
-#if  (defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000156 /* Timers in PWM-Out Mode with PPI GP Receive (Input)
-                            Mode with 0 Frame Syncs */
-#define ANOMALY_05000168 /* SDRAM auto-refresh and subsequent Power Ups */
-#define ANOMALY_05000169 /* DATA CPLB page miss can result in lost write-through
-                            cache data writes */
-#define ANOMALY_05000171 /* Boot-ROM code modifies SICA_IWRx wakeup registers */
-#define ANOMALY_05000174 /* Cache Fill Buffer Data lost */
-#define ANOMALY_05000175 /* Overlapping Sequencer and Memory Stalls */
-#define ANOMALY_05000176 /* Multiplication of (-1) by (-1) followed by an
-                            accumulator saturation */
-#define ANOMALY_05000179 /* PPI_COUNT cannot be programmed to 0 in General
-                            Purpose TX or RX modes */
-#define ANOMALY_05000181 /* Disabling the PPI resets the PPI configuration
-                            registers */
-#define ANOMALY_05000184 /* Timer Pin limitations for PPI TX Modes with
-                            External Frame Syncs */
-#define ANOMALY_05000185 /* PPI TX Mode with 2 External Frame Syncs */
-#define ANOMALY_05000186 /* PPI packing with Data Length greater than 8 bits
-                            (not a meaningful mode) */
-#define ANOMALY_05000188 /* IMDMA Restrictions on Descriptor and Buffer
-                            Placement in Memory */
-#define ANOMALY_05000189 /* False Protection Exception */
-#define ANOMALY_05000193 /* False Flag Pin Interrupts on Edge Sensitive Inputs
-                            when polarity setting is changed */
-#define ANOMALY_05000194 /* Restarting SPORT in specific modes may cause data
-                            corruption */
-#define ANOMALY_05000198 /* Failing MMR accesses when stalled by preceding
-                            memory read */
-#define ANOMALY_05000199 /* DMA current address shows wrong value during carry
-                            fix */
-#define ANOMALY_05000200 /* SPORT TFS and DT are incorrectly driven during
-                            inactive channels in certain conditions */
-#define ANOMALY_05000202 /* Possible infinite stall with specific dual-DAG
-                            situation */
-#define ANOMALY_05000204 /* Incorrect data read with write-through cache and
-                            allocate cache lines on reads only mode */
-#define ANOMALY_05000205 /* Specific sequence that can cause DMA error or DMA
-                            stopping */
-#define ANOMALY_05000207 /* Recovery from "brown-out" condition */
-#define ANOMALY_05000209 /* Speed-Path in computational unit affects certain
-                            instructions */
-#define ANOMALY_05000215 /* UART TX Interrupt masked erroneously */
-#define ANOMALY_05000219 /* NMI event at boot time results in unpredictable
-                            state */
-#define ANOMALY_05000220 /* Data Corruption with Cached External Memory and
-                            Non-Cached On-Chip L2 Memory */
-#define ANOMALY_05000225 /* Incorrect pulse-width of UART start-bit */
-#define ANOMALY_05000227 /* Scratchpad memory bank reads may return incorrect
-                            data */
-#define ANOMALY_05000230 /* UART Receiver is less robust against Baudrate
-                            Differences in certain Conditions */
-#define ANOMALY_05000231 /* UART STB bit incorrectly affects receiver setting */
-#define ANOMALY_05000232 /* SPORT data transmit lines are incorrectly driven in
-                            multichannel mode */
-#define ANOMALY_05000242 /* DF bit in PLL_CTL register does not respond to
-                            hardware reset */
-#define ANOMALY_05000244 /* If i-cache is on, CSYNC/SSYNC/IDLE around Change of
-                            Control causes failures */
-#define ANOMALY_05000248 /* TESTSET operation forces stall on the other core */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) mode in certain conditions */
-#define ANOMALY_05000251 /* Exception not generated for MMR accesses in
-                            reserved region */
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bits 9 and 12
-                            of the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB
-                            exception */
-#define ANOMALY_05000264 /* CSYNC/SSYNC/IDLE causes infinite stall in second
-                            to last instruction in hardware loop */
-#define ANOMALY_05000276 /* Timing requirements change for External Frame
-                            Sync PPI Modes with non-zero PPI_DELAY */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000283 /* An MMR write is stalled indefinitely when killed
-                            in a particular stage */
-#define ANOMALY_05000287 /* A read will receive incorrect data under certain
-                            conditions */
-#define ANOMALY_05000288 /* SPORTs may receive bad data if FIFOs fill up */
-#endif
-
-#endif /* _MACH_ANOMALY_H_ */
diff --git a/include/asm-blackfin/mach-bf561/bf561.h b/include/asm-blackfin/mach-bf561/bf561.h
index 96a5d3a..8cc2e00 100644
--- a/include/asm-blackfin/mach-bf561/bf561.h
+++ b/include/asm-blackfin/mach-bf561/bf561.h
@@ -311,7 +311,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 6e87ab2..de97479 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -31,11 +31,8 @@
 #ifndef _CDEF_BF561_H
 #define _CDEF_BF561_H
 
-/*
-#if !defined(__ADSPBF561__)
-#warning cdefBF561.h should only be included for BF561 chip.
-#endif
-*/
+#include <asm/blackfin.h>
+
 /* include all Core registers and bit definitions */
 #include "defBF561.h"
 
@@ -67,7 +64,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SICA_IWR1, 0);
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
diff --git a/include/asm-blackfin/mach-bf561/portmux.h b/include/asm-blackfin/mach-bf561/portmux.h
index 10d11d5..132ad31 100644
--- a/include/asm-blackfin/mach-bf561/portmux.h
+++ b/include/asm-blackfin/mach-bf561/portmux.h
@@ -81,7 +81,7 @@
 #define P_TMR1		(P_DEFINED | P_IDENT(GPIO_PF1))
 #define P_TMR0		(P_DEFINED | P_IDENT(GPIO_PF0))
 #define P_SPI0_MOSI	(P_DONTCARE)
-#define P_SPI0_MIS0	(P_DONTCARE)
+#define P_SPI0_MISO	(P_DONTCARE)
 #define P_SPI0_SCK	(P_DONTCARE)
 
 #endif /* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
index 94ed381..ede210e 100644
--- a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
@@ -39,7 +39,7 @@
 #define bfin_read_SRAM_BASE_ADDRESS()        bfin_read32(SRAM_BASE_ADDRESS)
 #define bfin_write_SRAM_BASE_ADDRESS(val)    bfin_write32(SRAM_BASE_ADDRESS,val)
 #define bfin_read_DMEM_CONTROL()             bfin_read32(DMEM_CONTROL)
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 extern void bfin_write_DMEM_CONTROL(unsigned int val);
 #else
 #define bfin_write_DMEM_CONTROL(val)         bfin_write32(DMEM_CONTROL,val)
@@ -129,7 +129,7 @@ extern void bfin_write_DMEM_CONTROL(unsigned int val);
 #define DTEST_DATA3            0xFFE0040C
 */
 #define bfin_read_IMEM_CONTROL()             bfin_read32(IMEM_CONTROL)
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 extern void bfin_write_IMEM_CONTROL(unsigned int val);
 #else
 #define bfin_write_IMEM_CONTROL(val)         bfin_write32(IMEM_CONTROL,val)
diff --git a/include/asm-blackfin/mach-common/def_LPBlackfin.h b/include/asm-blackfin/mach-common/def_LPBlackfin.h
index be1ece8..260515d 100644
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -33,81 +33,77 @@
 
 #include <asm/mach/anomaly.h>
 
-/*#if !defined(__ADSPLPBLACKFIN__)
-#warning def_LPBlackfin.h should only be included for 532 compatible chips.
-#endif
-*/
-
 #define MK_BMSK_(x) (1<<x)
 
-#if defined(ANOMALY_05000198)
-
-#define bfin_read8(addr) ({ unsigned char __v; \
-		__asm__ __volatile__ ("NOP;\n\t" \
-			"%0 = b[%1] (z);\n\t" \
-			: "=d"(__v) : "a"(addr)); \
-		__v; })
-
-#define bfin_read16(addr) ({ unsigned __v; \
-                       __asm__ __volatile__ ("NOP;\n\t"\
-	         			     			"%0 = w[%1] (z);\n\t"\
-  : "=d"(__v) : "a"(addr)); (unsigned short)__v; })
-
-#define bfin_read32(addr) ({ unsigned __v; \
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "%0 = [%1];\n\t"\
-  : "=d"(__v) : "a"(addr)); __v; })
+#ifndef __ASSEMBLY__
 
-#define bfin_write8(addr, val) ({ \
-		__asm__ __volatile__ ("NOP;\n\t" \
-			"b[%0] = %1;\n\t" \
-			: : "a"(addr), "d"(val) : "memory");})
-
-#define bfin_write16(addr,val) ({\
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "w[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
-#define bfin_write32(addr,val) ({\
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
+#include <linux/types.h>
 
+#if ANOMALY_05000198
+# define NOP_PAD_ANOMALY_05000198 "nop;"
 #else
-
-#define bfin_read8(addr) ({ unsigned char __v; \
-		__asm__ __volatile__ ( \
-			"%0 = b[%1] (z);\n\t" \
-			:"=d"(__v) : "a"(addr)); \
-		__v; })
-
-#define bfin_read16(addr) ({ unsigned __v; \
-                       __asm__ __volatile__ (\
-	         			     			"%0 = w[%1] (z);\n\t"\
-  : "=d"(__v) : "a"(addr)); (unsigned short)__v; })
-
-#define bfin_read32(addr) ({ unsigned __v; \
-                      __asm__ __volatile__ (\
-                                            "%0 = [%1];\n\t"\
-  : "=d"(__v) : "a"(addr)); __v; })
-
-#define bfin_write8(addr, val) ({ \
-		__asm__ __volatile__ ( \
-			"b[%0] = %1; \n\t" \
-			::"a"(addr), "d"(val) : "memory");})
-
-#define bfin_write16(addr,val) ({\
-                      __asm__ __volatile__ (\
-                                            "w[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
-#define bfin_write32(addr,val) ({\
-                      __asm__ __volatile__ (\
-                                            "[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
+# define NOP_PAD_ANOMALY_05000198
 #endif
 
+#define bfin_read8(addr) ({ \
+	uint8_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = b[%1] (z);" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_read16(addr) ({ \
+	uint16_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = w[%1] (z);" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_read32(addr) ({ \
+	uint32_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = [%1];" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_write8(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"b[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#define bfin_write16(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"w[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#define bfin_write32(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#endif /* __ASSEMBLY__ */
+
 /**************************************************
  * System Register Bits
  **************************************************/
diff --git a/include/asm-blackfin/system.h b/include/asm-blackfin/system.h
index 5e5f1a0..b03cf7d 100644
--- a/include/asm-blackfin/system.h
+++ b/include/asm-blackfin/system.h
@@ -36,6 +36,7 @@
 
 #include <linux/linkage.h>
 #include <linux/compiler.h>
+#include <asm/mach/anomaly.h>
 
 /*
  * Interrupt configuring macros.
@@ -43,53 +44,60 @@
 
 extern unsigned long irq_flags;
 
-#define local_irq_enable() do {		\
-	__asm__ __volatile__ (		\
-		"sti %0;"		\
-		::"d"(irq_flags));	\
-} while (0)
+#define local_irq_enable() \
+	__asm__ __volatile__( \
+		"sti %0;" \
+		: \
+		: "d" (irq_flags) \
+	)
 
-#define local_irq_disable() do {	\
-	int _tmp_dummy;			\
-	__asm__ __volatile__ (		\
-		"cli %0;"		\
-		:"=d" (_tmp_dummy):);	\
-} while (0)
+#define local_irq_disable() \
+	do { \
+		int __tmp_dummy; \
+		__asm__ __volatile__( \
+			"cli %0;" \
+			: "=d" (__tmp_dummy) \
+		); \
+	} while (0)
 
-#if defined(ANOMALY_05000244) && defined (CONFIG_BLKFIN_CACHE)
-#define idle_with_irq_disabled() do {   \
-        __asm__ __volatile__ (          \
-                "nop; nop;\n"           \
-                ".align 8;\n"           \
-                "sti %0; idle;\n"       \
-                ::"d" (irq_flags));     \
-} while (0)
+#if ANOMALY_05000244 && defined(CONFIG_BLKFIN_CACHE)
+# define NOP_PAD_ANOMALY_05000244 "nop; nop;"
 #else
-#define idle_with_irq_disabled() do {   \
-	__asm__ __volatile__ (          \
-		".align 8;\n"           \
-		"sti %0; idle;\n"       \
-		::"d" (irq_flags));     \
-} while (0)
+# define NOP_PAD_ANOMALY_05000244
 #endif
 
+#define idle_with_irq_disabled() \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000244 \
+		".align 8;" \
+		"sti %0;" \
+		"idle;" \
+		: \
+		: "d" (irq_flags) \
+	)
+
 #ifdef CONFIG_DEBUG_HWERR
-#define __save_and_cli(x) do {			\
-	__asm__ __volatile__ (		        \
-		"cli %0;\n\tsti %1;"		\
-		:"=&d"(x): "d" (0x3F));		\
-} while (0)
+# define __save_and_cli(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		"sti %1;" \
+		: "=&d" (x) \
+		: "d" (0x3F) \
+	)
 #else
-#define __save_and_cli(x) do {		\
-	__asm__ __volatile__ (          \
-		"cli %0;"		\
-		:"=&d"(x):);		\
-} while (0)
+# define __save_and_cli(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		: "=&d" (x) \
+	)
 #endif
 
-#define local_save_flags(x) asm volatile ("cli %0;"     \
-					  "sti %0;"     \
-				    	  :"=d"(x):);
+#define local_save_flags(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		"sti %0;" \
+		: "=d" (x) \
+	)
 
 #ifdef CONFIG_DEBUG_HWERR
 #define irqs_enabled_from_flags(x) (((x) & ~0x3f) != 0)
@@ -97,10 +105,11 @@ extern unsigned long irq_flags;
 #define irqs_enabled_from_flags(x) ((x) != 0x1f)
 #endif
 
-#define local_irq_restore(x) do {			\
-	if (irqs_enabled_from_flags(x))			\
-		local_irq_enable ();			\
-} while (0)
+#define local_irq_restore(x) \
+	do { \
+		if (irqs_enabled_from_flags(x)) \
+			local_irq_enable(); \
+	} while (0)
 
 /* For spinlocks etc */
 #define local_irq_save(x) __save_and_cli(x)
