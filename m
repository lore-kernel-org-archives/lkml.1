Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbXGSOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbXGSOBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbXGSNtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:48639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764819AbXGSNs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:57 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: chrisw@sous-sol.org, mingo@elte.hu, johnstul@us.ibm.com, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [26/48] i386: hpet assumes boot cpu is 0
Message-Id: <20070719134856.3813D14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chris Wright <chrisw@sous-sol.org>

I fixed this in x86_64.  Looks like the kind of thing that will break voyager
on i386.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/hpet.c
===================================================================
--- linux.orig/arch/i386/kernel/hpet.c
+++ linux/arch/i386/kernel/hpet.c
@@ -321,7 +321,7 @@ int __init hpet_enable(void)
 		 * Start hpet with the boot cpu mask and make it
 		 * global after the IO_APIC has been initialized.
 		 */
-		hpet_clockevent.cpumask =cpumask_of_cpu(0);
+		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 		clockevents_register_device(&hpet_clockevent);
 		global_clock_event = &hpet_clockevent;
 		return 1;
