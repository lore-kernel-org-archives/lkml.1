Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbZEKW5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbZEKW5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbZEKW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:57:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461AbZEKW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:57:04 -0400
Message-Id: <200905112257.03981.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:57:03 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] mips: use PIT_TICK_RATE in i8253
Content-Disposition: inline
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18l2aIAZ2M+pDwI7xzM+zBIHMvHAEYVhASj48o
 7+KfTF9TIUX953fJOaE6RcwK4bjgoXq+/59vM9msMioFZUy6RB
 9Fb/bI93+utSTySsWEkoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PIT_TICK_RATE instead of CLOCK_TICK_RATE allows
us to later change CLOCK_TICK_RATE to a more sensible
time base value for platforms that do not base their
system timer off an i8253.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/kernel/i8253.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index ed20e7f..3545419 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/timex.h>
 
 #include <asm/delay.h>
 #include <asm/i8253.h>
@@ -115,7 +116,7 @@ void __init setup_pit_timer(void)
 	 * IO_APIC has been initialized.
 	 */
 	cd->cpumask = cpumask_of(cpu);
-	clockevent_set_clock(cd, CLOCK_TICK_RATE);
+	clockevent_set_clock(cd, PIT_TICK_RATE);
 	cd->max_delta_ns = clockevent_delta2ns(0x7FFF, cd);
 	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
 	clockevents_register_device(cd);
@@ -203,7 +204,7 @@ static int __init init_pit_clocksource(void)
 	if (num_possible_cpus() > 1) /* PIT does not scale! */
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
+	clocksource_pit.mult = clocksource_hz2mult(PIT_TICK_RATE, 20);
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
-- 
1.6.0.4

-- 


