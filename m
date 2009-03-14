Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZCNPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZCNPMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZCNPMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:12:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:41083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZCNPMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:12:00 -0400
Subject: [PATCH -tip] x86: i8253 cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:41:33 +0530
Message-Id: <1237043493.4546.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: i8253 cleanup

Impact: cleanup

 - fix various style problems
  - fix header file issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/i8253.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 10f92fb..8613ee2 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -3,26 +3,26 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
 
-#include <asm/smp.h>
-#include <asm/delay.h>
 #include <asm/i8253.h>
-#include <asm/io.h>
 #include <asm/hpet.h>
+#include <asm/smp.h>
 
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 #ifdef CONFIG_X86_32
 static void pit_disable_clocksource(void);
-#else
+#else /* CONFIG_X86_32 */
 static inline void pit_disable_clocksource(void) { }
-#endif
+#endif /* CONFIG_X86_32 */
 
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
@@ -40,7 +40,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 {
 	spin_lock(&i8253_lock);
 
-	switch(mode) {
+	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_pit(0x34, PIT_MODE);
@@ -133,11 +133,11 @@ void __init setup_pit_timer(void)
  */
 static cycle_t pit_read(void)
 {
+	static int old_count;
 	unsigned long flags;
+	static u32 old_jifs;
 	int count;
 	u32 jifs;
-	static int old_count;
-	static u32 old_jifs;
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	/*
@@ -179,9 +179,9 @@ static cycle_t pit_read(void)
 	 * Previous attempts to handle these cases intelligently were
 	 * buggy, so we just do the simple thing now.
 	 */
-	if (count > old_count && jifs == old_jifs) {
+	if (count > old_count && jifs == old_jifs)
 		count = old_count;
-	}
+
 	old_count = count;
 	old_jifs = jifs;
 
@@ -227,6 +227,7 @@ static int __init init_pit_clocksource(void)
 
 	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
 						   clocksource_pit.shift);
+
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
-- 
1.6.0.6



