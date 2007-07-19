Return-Path: <linux-kernel-owner+w=401wt.eu-S936508AbXGSKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936508AbXGSKLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760719AbXGSJzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:38 -0400
Received: from mail.suse.de ([195.135.220.2]:35393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbXGSJzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:19 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [29/58] x86_64: fiuxp pt_reqs leftovers
Message-Id: <20070719095514.CA06814E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
The hpet_rtc_interrupt handler still uses pt_regs. Fix it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/hpet.c
===================================================================
--- linux.orig/arch/x86_64/kernel/hpet.c
+++ linux/arch/x86_64/kernel/hpet.c
@@ -439,7 +439,7 @@ int hpet_rtc_dropped_irq(void)
 	return 1;
 }
 
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
 	struct rtc_time curr_time;
 	unsigned long rtc_int_flag = 0;
