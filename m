Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbXFJJfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbXFJJfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXFJJbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:18 -0400
Received: from www.osadl.org ([213.239.205.134]:43087 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753700AbXFJJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:31:04 -0400
Message-Id: <20070610092446.849022958@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 13/23] i386: hpet assumes boot cpu is 0
Content-Disposition: inline; filename=i386-hpet-fix-cpu0-assumption.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

I fixed this in x86_64.  Looks like the kind of thing that will break
voyager on i386.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/i386/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-10 10:44:39.000000000 +0200
@@ -325,7 +325,7 @@ int __init hpet_enable(void)
 		 * Start hpet with the boot cpu mask and make it
 		 * global after the IO_APIC has been initialized.
 		 */
-		hpet_clockevent.cpumask =cpumask_of_cpu(0);
+		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 		clockevents_register_device(&hpet_clockevent);
 		global_clock_event = &hpet_clockevent;
 		return 1;

-- 

