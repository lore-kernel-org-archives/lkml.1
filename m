Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbYGQTaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbYGQTaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760214AbYGQTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:16 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:50770 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbYGQTWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:50 -0400
Message-Id: <20080717191754.724236725@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:26 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 19/29] m68k/q40/config.c: make functions static
Content-Disposition: inline; filename=m68k-q40-config.c-make-functions-static.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- q40_reset()
- q40_halt()
- q40_disable_irqs()
- q40_gettimeoffset()
- q40_hwclk()
- q40_get_ss()
- q40_set_clock_mmss()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/q40/config.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -41,14 +41,12 @@ static void q40_get_model(char *model);
 static int  q40_get_hardware_list(char *buffer);
 extern void q40_sched_init(irq_handler_t handler);
 
-extern unsigned long q40_gettimeoffset(void);
-extern int q40_hwclk(int, struct rtc_time *);
-extern unsigned int q40_get_ss(void);
-extern int q40_set_clock_mmss(unsigned long);
+static unsigned long q40_gettimeoffset(void);
+static int q40_hwclk(int, struct rtc_time *);
+static unsigned int q40_get_ss(void);
+static int q40_set_clock_mmss(unsigned long);
 static int q40_get_rtc_pll(struct rtc_pll_info *pll);
 static int q40_set_rtc_pll(struct rtc_pll_info *pll);
-extern void q40_reset(void);
-void q40_halt(void);
 extern void q40_waitbut(void);
 void q40_set_vectors(void);
 
@@ -127,7 +125,7 @@ static void q40_heartbeat(int on)
 }
 #endif
 
-void q40_reset(void)
+static void q40_reset(void)
 {
         halted = 1;
         printk("\n\n*******************************************\n"
@@ -137,7 +135,8 @@ void q40_reset(void)
 	while (1)
 		;
 }
-void q40_halt(void)
+
+static void q40_halt(void)
 {
         halted = 1;
         printk("\n\n*******************\n"
@@ -165,7 +164,8 @@ static unsigned int serports[] =
 {
 	0x3f8,0x2f8,0x3e8,0x2e8,0
 };
-void q40_disable_irqs(void)
+
+static void q40_disable_irqs(void)
 {
 	unsigned i, j;
 
@@ -227,7 +227,7 @@ static inline unsigned char bin2bcd(unsi
 }
 
 
-unsigned long q40_gettimeoffset(void)
+static unsigned long q40_gettimeoffset(void)
 {
 	return 5000 * (ql_ticks != 0);
 }
@@ -248,7 +248,7 @@ unsigned long q40_gettimeoffset(void)
  * };
  */
 
-int q40_hwclk(int op, struct rtc_time *t)
+static int q40_hwclk(int op, struct rtc_time *t)
 {
 	if (op) {
 		/* Write.... */
@@ -285,7 +285,7 @@ int q40_hwclk(int op, struct rtc_time *t
 	return 0;
 }
 
-unsigned int q40_get_ss(void)
+static unsigned int q40_get_ss(void)
 {
 	return bcd2bin(Q40_RTC_SECS);
 }
@@ -295,7 +295,7 @@ unsigned int q40_get_ss(void)
  * clock is out by > 30 minutes.  Logic lifted from atari code.
  */
 
-int q40_set_clock_mmss(unsigned long nowtime)
+static int q40_set_clock_mmss(unsigned long nowtime)
 {
 	int retval = 0;
 	short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

