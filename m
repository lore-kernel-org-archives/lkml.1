Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbXE1Ikl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbXE1Ikl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbXE1Igr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:47 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:43596 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300052:sNHT30607108"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 12/20] Blackfin arch: unify differences between our diff head.S files -- no functional changes
Date: Mon, 28 May 2007 16:37:47 +0800
Message-Id: <11803414793424-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/head.S |   17 +++++++++--------
 arch/blackfin/mach-bf537/head.S |   22 ++++++++++++----------
 arch/blackfin/mach-bf561/head.S |   20 +++++++++++---------
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 4db9e62..33d1f62 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -51,13 +51,14 @@ ENTRY(__start)
 ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
-	/* Set the SYSCFG register */
+	/* Set the SYSCFG register:
+	 * Enable Cycle Counter and Nesting Of Interrupts (3rd Bit)
+	 */
 	R0 = 0x36;
-	/*Enable Cycle Counter and Nesting Of Interrupts(3rd Bit)*/
 	SYSCFG = R0;
 	R0 = 0;
 
-	/*Clear Out All the data and pointer  Registers*/
+	/* Clear Out All the data and pointer Registers */
 	R1 = R0;
 	R2 = R0;
 	R3 = R0;
@@ -79,7 +80,7 @@ ENTRY(__stext)
 	L2 = r0;
 	L3 = r0;
 
-	/* Clear Out All the DAG Registers*/
+	/* Clear Out All the DAG Registers */
 	B0 = r0;
 	B1 = r0;
 	B2 = r0;
@@ -303,7 +304,7 @@ ENTRY(_real_start)
 .L_clear_zero:
 	W[p1++] = r0;
 
-/* pass the uboot arguments to the global value command line */
+	/* pass the uboot arguments to the global value command line */
 	R0 = R7;
 	call _cmdline_init;
 
@@ -322,7 +323,7 @@ ENTRY(_real_start)
 	[p1] = r1;
 
 	/*
-	 *  load the current thread pointer and stack
+	 * load the current thread pointer and stack
 	 */
 	r1.l = _init_thread_union;
 	r1.h = _init_thread_union;
@@ -439,8 +440,8 @@ ENTRY(_start_dma_code)
 
 	p0.h = hi(SIC_IWR);
 	p0.l = lo(SIC_IWR);
-	r0.l = lo(IWR_ENABLE_ALL)
-	r0.h = hi(IWR_ENABLE_ALL)
+	r0.l = lo(IWR_ENABLE_ALL);
+	r0.h = hi(IWR_ENABLE_ALL);
 	[p0] = r0;
 	SSYNC;
 
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 2c2652b..3f490bf 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -40,7 +40,7 @@
 .extern ___bss_start
 .extern _bf53x_relocate_l1_mem
 
-#define INITIAL_STACK   0xFFB01000
+#define INITIAL_STACK	0xFFB01000
 
 .text
 
@@ -48,12 +48,14 @@ ENTRY(__start)
 ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
-	/* Set the SYSCFG register */
+	/* Set the SYSCFG register:
+	 * Enable Cycle Counter and Nesting Of Interrupts (3rd Bit)
+	 */
 	R0 = 0x36;
-	SYSCFG = R0;   /*Enable Cycle Counter and Nesting Of Interrupts(3rd Bit)*/
+	SYSCFG = R0;
 	R0 = 0;
 
-	/* Clear Out All the data and pointer  Registers*/
+	/* Clear Out All the data and pointer Registers */
 	R1 = R0;
 	R2 = R0;
 	R3 = R0;
@@ -75,7 +77,7 @@ ENTRY(__stext)
 	L2 = r0;
 	L3 = r0;
 
-	/* Clear Out All the DAG Registers*/
+	/* Clear Out All the DAG Registers */
 	B0 = r0;
 	B1 = r0;
 	B2 = r0;
@@ -191,7 +193,7 @@ ENTRY(__stext)
 
 	p0.h = hi(UART_DLL);
 	p0.l = lo(UART_DLL);
-	r0 = 0x00(Z);
+	r0 = 0x0(Z);
 	w[p0] = r0.L;
 	ssync;
 
@@ -218,6 +220,7 @@ ENTRY(__stext)
 #if CONFIG_BFIN_KERNEL_CLOCK
 	call _start_dma_code;
 #endif
+
 	/* Code for initializing Async memory banks */
 
 	p2.h = hi(EBIU_AMBCTL1);
@@ -291,7 +294,7 @@ ENTRY(_real_start)
 	p2.h = ___bss_stop;
 	r0 = 0;
 	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss ) lc0 = p2;
+	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
 .L_clear_bss:
 	B[p1++] = r0;
 
@@ -306,7 +309,7 @@ ENTRY(_real_start)
 	r0 = r0 >> 1;
 	p2 = r0;
 	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero ) lc0 = p2;
+	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
 .L_clear_zero:
 	W[p1++] = r0;
 
@@ -328,9 +331,8 @@ ENTRY(_real_start)
 	r1 = p3;
 	[p1] = r1;
 
-
 	/*
-	 *  load the current thread pointer and stack
+	 * load the current thread pointer and stack
 	 */
 	r1.l = _init_thread_union;
 	r1.h = _init_thread_union;
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index ad9187a..3029e94 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -46,14 +46,16 @@
 
 ENTRY(__start)
 ENTRY(__stext)
-	/*  R0: argument of command line string, passed from uboot, save it */
+	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
-	/* Set the SYSCFG register */
+	/* Set the SYSCFG register:
+	 * Enable Cycle Counter and Nesting Of Interrupts (3rd Bit)
+	 */
 	R0 = 0x36;
-	SYSCFG = R0; /*Enable Cycle Counter and Nesting Of Interrupts(3rd Bit)*/
+	SYSCFG = R0;
 	R0 = 0;
 
-	/*Clear Out All the data and pointer  Registers*/
+	/* Clear Out All the data and pointer Registers */
 	R1 = R0;
 	R2 = R0;
 	R3 = R0;
@@ -75,7 +77,7 @@ ENTRY(__stext)
 	L2 = r0;
 	L3 = r0;
 
-	/* Clear Out All the DAG Registers*/
+	/* Clear Out All the DAG Registers */
 	B0 = r0;
 	B1 = r0;
 	B2 = r0;
@@ -238,7 +240,7 @@ ENTRY(_real_start)
 	p2.h = ___bss_stop;
 	r0 = 0;
 	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss ) lc0 = p2;
+	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
 .L_clear_bss:
 	B[p1++] = r0;
 
@@ -253,11 +255,11 @@ ENTRY(_real_start)
 	r0 = r0 >> 1;
 	p2 = r0;
 	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero ) lc0 = p2;
+	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
 .L_clear_zero:
 	W[p1++] = r0;
 
-/* pass the uboot arguments to the global value command line */
+	/* pass the uboot arguments to the global value command line */
 	R0 = R7;
 	call _cmdline_init;
 
@@ -350,7 +352,7 @@ ENTRY(_start_dma_code)
 	if ! CC jump .Lcheck_again;
 
 	/* Configure SCLK & CCLK Dividers */
-	   	r0 = (CONFIG_CCLK_ACT_DIV | CONFIG_SCLK_DIV);
+	r0 = (CONFIG_CCLK_ACT_DIV | CONFIG_SCLK_DIV);
 	p0.h = hi(PLL_DIV);
 	p0.l = lo(PLL_DIV);
 	w[p0] = r0.l;
-- 
1.5.2
