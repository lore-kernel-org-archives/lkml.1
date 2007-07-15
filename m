Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXGOQJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXGOQJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762290AbXGOQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:04 -0400
Received: from www.osadl.org ([213.239.205.134]:42532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761373AbXGOQE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:59 -0400
Message-Id: <20070715155541.097810632@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 10/33] x86_64: fiuxp pt_reqs leftovers
Content-Disposition: inline; filename=x86_64-fix-irq-regs-leftovers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hpet_rtc_interrupt handler still uses pt_regs. Fix it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/hpet.c	2007-07-15 17:27:01.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/hpet.c	2007-07-15 17:49:03.000000000 +0200
@@ -439,7 +439,7 @@ int hpet_rtc_dropped_irq(void)
 	return 1;
 }
 
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
 	struct rtc_time curr_time;
 	unsigned long rtc_int_flag = 0;

-- 

