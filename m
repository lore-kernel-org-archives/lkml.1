Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXCTBIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXCTBIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030825AbXCTBIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:08:25 -0400
Received: from www.osadl.org ([213.239.205.134]:43335 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030802AbXCTBIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:08:24 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
	 <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
	 <1174337777.13341.621.camel@localhost.localdomain>
	 <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 02:15:29 +0100
Message-Id: <1174353329.13341.762.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 22:51 +0100, Stefan Prechtel wrote:
> 2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> > On Mon, 2007-03-19 at 21:35 +0100, Stefan Prechtel wrote:
> > >            CPU0       CPU1
> > >  0:      28289          0  local-APIC-edge-fasteio   timer
> > > ...
> > > LOC:      28237      28236
> > >
> > > after a read: (I hope that is this what you want :-)
> > >            CPU0       CPU1
> > >   0:      30344          0  local-APIC-edge-fasteio   timer
> > > ...
> > > LOC:      30292      30291
> >
> > Is this with AC plugged in ? If yes, please provide the same numbers for
> > battery mode.
> 
> Yes. And here is the output for battery mode (2.6.20):
>            CPU0       CPU1
>   0:     292153          0  local-APIC-edge-fasteio   timer
> LOC:     292114     292113
> 
>            CPU0       CPU1
>   0:     293263          0  local-APIC-edge-fasteio   timer
> LOC:     293224     293223

Hmm. Can you please apply the following patch on top of 2.6.20 and
check, if the WARN_ON_ONCE triggers when you boot w/o AC plugged ?

Thanks,

	tglx

Index: linux-2.6.20/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/apic.c
+++ linux-2.6.20/arch/i386/kernel/apic.c
@@ -1174,6 +1174,8 @@ void switch_APIC_timer_to_ipi(void *cpum
 	cpumask_t mask = *(cpumask_t *)cpumask;
 	int cpu = smp_processor_id();
 
+	WARN_ON_ONCE(1);
+
 	if (cpu_isset(cpu, mask) &&
 	    !cpu_isset(cpu, timer_bcast_ipi)) {
 		disable_APIC_timer();


