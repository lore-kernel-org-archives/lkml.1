Return-Path: <linux-kernel-owner+w=401wt.eu-S966380AbXEHJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966380AbXEHJp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934649AbXEHJp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:45:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49368 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934637AbXEHJpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:45:24 -0400
Date: Tue, 8 May 2007 02:44:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] i386: hpet assumes boot cpu is 0
Message-ID: <20070508094450.GV3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed this in x86_64.  Looks like the kind of thing that will break
voyager on i386.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- tglx.orig/arch/i386/kernel/hpet.c
+++ tglx/arch/i386/kernel/hpet.c
@@ -334,7 +334,7 @@ int __init hpet_enable(void)
 		 * Start hpet with the boot cpu mask and make it
 		 * global after the IO_APIC has been initialized.
 		 */
-		hpet_clockevent.cpumask =cpumask_of_cpu(0);
+		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
 		clockevents_register_device(&hpet_clockevent);
 		global_clock_event = &hpet_clockevent;
 		return 1;
