Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYCAQWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYCAQWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbYCAQUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:20:14 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57150 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbYCAQUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:20:11 -0500
Date: Sat, 1 Mar 2008 18:18:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper extern for late_time_init
Message-ID: <20080301161845.GL25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper extern for late_time_init in 
include/linux/init.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mips/pmc-sierra/yosemite/setup.c |    3 ---
 arch/ppc/platforms/sbc82xx.c          |    2 --
 arch/um/kernel/time.c                 |    3 +--
 arch/x86/kernel/time_32.c             |    1 -
 include/asm-x86/time.h                |    1 -
 include/linux/init.h                  |    2 ++
 6 files changed, 3 insertions(+), 9 deletions(-)

c806b8c024ced4ff11ba7083a4861ebfae857721 foobar
diff --git a/arch/mips/pmc-sierra/yosemite/setup.c b/arch/mips/pmc-sierra/yosemite/setup.c
index 855977c..6537d90 100644
--- a/arch/mips/pmc-sierra/yosemite/setup.c
+++ b/arch/mips/pmc-sierra/yosemite/setup.c
@@ -143,9 +143,6 @@ void __init plat_time_init(void)
 mips_hpt_frequency = 33000000 * 3 * 5;
 }
 
-/* No other usable initialization hook than this ...  */
-extern void (*late_time_init)(void);
-
 unsigned long ocd_base;
 
 EXPORT_SYMBOL(ocd_base);
diff --git a/arch/ppc/platforms/sbc82xx.c b/arch/ppc/platforms/sbc82xx.c
index cc0935c..b5e2cec 100644
--- a/arch/ppc/platforms/sbc82xx.c
+++ b/arch/ppc/platforms/sbc82xx.c
@@ -30,8 +30,6 @@ static void (*callback_init_IRQ)(void);
 
 extern unsigned char __res[sizeof(bd_t)];
 
-extern void (*late_time_init)(void);
-
 #ifdef CONFIG_GEN_RTC
 TODC_ALLOC();
 
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index e066e84..0d0cea2 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/clockchips.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/threads.h>
@@ -109,8 +110,6 @@ static void __init setup_itimer(void)
 	clockevents_register_device(&itimer_clockevent);
 }
 
-extern void (*late_time_init)(void);
-
 void __init time_init(void)
 {
 	long long nsecs;
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 1a89e93..2ff21f3 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -115,7 +115,6 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
 void __init hpet_time_init(void)
 {
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index 68779b0..bce72d7 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -1,7 +1,6 @@
 #ifndef _ASMX86_TIME_H
 #define _ASMX86_TIME_H
 
-extern void (*late_time_init)(void);
 extern void hpet_time_init(void);
 
 #include <asm/mc146818rtc.h>
diff --git a/include/linux/init.h b/include/linux/init.h
index fb58c04..21d658c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -147,6 +147,8 @@ extern unsigned int reset_devices;
 void setup_arch(char **);
 void prepare_namespace(void);
 
+extern void (*late_time_init)(void);
+
 #endif
   
 #ifndef MODULE
