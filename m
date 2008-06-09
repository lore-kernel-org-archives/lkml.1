Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbYFIW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbYFIW01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYFIWXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53914 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbYFIWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:41 -0400
Date: Tue, 10 Jun 2008 01:22:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k/q40/config.c: make functions static
Message-ID: <20080609222246.GJ1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- q40_reset()
- q40_halt()
- q40_disable_irqs()
- q40_gettimeoffset()
- q40_hwclk()
- q40_get_ss()
- q40_set_clock_mmss()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/q40/config.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

f7f0479cf9fd335f7b8a52cb4ef008181bcdf4d4 diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index 476e18e..be9de2f 100644
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
 
@@ -227,7 +227,7 @@ static inline unsigned char bin2bcd(unsigned char b)
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
@@ -285,7 +285,7 @@ int q40_hwclk(int op, struct rtc_time *t)
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

