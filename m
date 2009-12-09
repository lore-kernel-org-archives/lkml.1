Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZLISgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZLISgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZLISge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:36:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54545 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbZLISgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=QlJavTKisVFsYdt41TXC96MsJiIv492nhY1hIcoZJmxVHcbmG8ug5+LndGbigwVvCs
         Z2OFPcvmu7BDd1aTV8n/xXXIUwO9vGAYWlhcXKf831Eq3ArExouivXraDmxkwJ2j2GFe
         u10vp9qW23TQtcpiVwCHQqs+8v9mV2P90GwWE=
MIME-Version: 1.0
In-Reply-To: <20091209183042.GD6938@linux.vnet.ibm.com>
References: <8b8dd87a0912080924q3890ea8o23f6d1cfab37e306@mail.gmail.com>
	 <20091208200657.GA12990@linux.vnet.ibm.com>
	 <8b8dd87a0912081741q24177e1bt3f624eded1590ca6@mail.gmail.com>
	 <20091209020834.GK6779@linux.vnet.ibm.com>
	 <8b8dd87a0912090115i3c4877b8s2e47f84f9c66ff7@mail.gmail.com>
	 <20091209140334.GB6812@linux.vnet.ibm.com>
	 <8b8dd87a0912090657y2702ecd7x5f41beb3ab785ccf@mail.gmail.com>
	 <20091209165304.GB6938@linux.vnet.ibm.com>
	 <8b8dd87a0912090935s75de7011s905c3007311a6b6b@mail.gmail.com>
	 <20091209183042.GD6938@linux.vnet.ibm.com>
Date: Wed, 9 Dec 2009 20:36:33 +0200
Message-ID: <8b8dd87a0912091036t3a3499c4p67be783252d80dc@mail.gmail.com>
Subject: Re: Badness at kernel/rcutree.c:1228
From: kordex - <kordex@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will turn debugging options on after
http://lkml.org/lkml/2009/12/9/44 gets traced down so I can do that.

--Mikko Kortelainen

2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> In that case, the best thing would be to drop the warning into the
> beginnings and ends of processing for system calls used by your workload.
> The hope would be to find it triggering at the end of a given syscall,
> permitting you to binary search the intervening code.
>
> Given that I cannot reproduce this, I cannot do much more than to offer
> random hints.
>
>                                                        Thanx, Paul
>
> On Wed, Dec 09, 2009 at 07:35:44PM +0200, kordex - wrote:
>> It did actually show the Badness after system had been running a long
>> time. And this cut from it shows that system was fully done kernel
>> init routines as there is ntpd running:
>>
>> warning: `ntpd' uses 32-bit capabilities (legacy support in use)
>> ------------[ cut here ]------------
>> Badness at kernel/rcutree.c:1228
>> NIP: c004ecbc LR: c004f14c CTR: c007bd70
>> REGS: df34dde0 TRAP: 0700   Not tainted  (2.6.32)
>>
>> --Mikko Kortelainen
>>
>> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> > Hmmm...  Didn't the first console output you sent me show the beenonline
>> > WARN_ON_ONCE() triggering during late boot?  Yes, you had other failures
>> > later, but it might be that whatever is triggering this warning is
>> > related to those failures, right?
>> >
>> >                                                        Thanx, Paul
>> >
>> > On Wed, Dec 09, 2009 at 04:57:54PM +0200, kordex - wrote:
>> >> Sorry but,
>> >>
>> >> Where actually this "down nearer to the point in the boot-up sequence"
>> >> would be as I encountered the errors while the system was running (had
>> >> been for days).
>> >>
>> >> --Mikko Kortelainen
>> >>
>> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> >> > On Wed, Dec 09, 2009 at 11:15:17AM +0200, kordex - wrote:
>> >> >> Hey,
>> >> >>
>> >> >> I hope it's in the right place.
>> >> >
>> >> > Looks fine to me.
>> >> >
>> >> > And the fact that you did -not- see anything in your dmesg indicates
>> >> > that the beenonline fields are set correctly at that point, as expected.
>> >> > You will only see a complaint if the beenonline fields have been
>> >> > corrupted.
>> >> >
>> >> > Please move them down nearer to the point in the boot-up sequence where
>> >> > you were seeing the failure.  Please note that interrupts had been on
>> >> > for one good long time when your original kernel complained, so there
>> >> > had been a very large number of executions with beenonline set
>> >> > correctly.
>> >> >
>> >> > So it will probably be faster to start at the original failure
>> >> > and move towards boot rather than vice versa.
>> >> >
>> >> >                                                        Thanx, Paul
>> >> >
>> >> >> --Mikko Kortelainen
>> >> >>
>> >> >> navi:/usr/src# diff -Naur a/init/main.c b/init/main.c
>> >> >> --- a/init/main.c       2009-12-03 05:51:21.000000000 +0200
>> >> >> +++ b/init/main.c       2009-12-09 03:22:15.000000000 +0200
>> >> >> @@ -81,6 +81,9 @@
>> >> >>  #include <asm/smp.h>
>> >> >>  #endif
>> >> >>
>> >> >> +/* DEBUG STATEMENT 2009/12/08 */
>> >> >> +#include <linux/rcutree.h>
>> >> >> +
>> >> >>  static int kernel_init(void *);
>> >> >>
>> >> >>  extern void init_IRQ(void);
>> >> >> @@ -589,6 +592,10 @@
>> >> >>                 local_irq_disable();
>> >> >>         }
>> >> >>         rcu_init();
>> >> >> +
>> >> >> +       /* DEBUG STATEMENT 2009/12/08 */
>> >> >> +       WARN_ON_ONCE(rcu_check_beenonline());
>> >> >> +
>> >> >>         /* init some links before init_ISA_irqs() */
>> >> >>         early_irq_init();
>> >> >>         init_IRQ();
>> >> >>
>> >> >>
>> >> >>
>> >> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> >> >> > On Wed, Dec 09, 2009 at 03:41:00AM +0200, kordex - wrote:
>> >> >> >> Hey,
>> >> >> >>
>> >> >> >> I put the debug function under init/main.c after rcu_init(); but there
>> >> >> >> is no output on dmesg which means that it receives zero value.
>> >> >> >>
>> >> >> >> Full dmesg: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.rcu-init.txt
>> >> >> >
>> >> >> > Could you please send the patch you applied to, as you said, put the
>> >> >> > debug function under init/main.c after rcu_init()?
>> >> >> >
>> >> >> >                                                        Thanx, Paul
>> >> >> >
>> >> >> >> --Mikko Kortelainen
>> >> >> >>
>> >> >> >> 2009/12/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> >> >> >> > On Tue, Dec 08, 2009 at 11:22:07AM -0800, Paul E. McKenney wrote:
>> >> >> >> >> At this point, I must defer to those more skilled than I at diagnosing
>> >> >> >> >> early-boot problems.
>> >> >> >> >
>> >> >> >> > Well, that is silly on my part -- the problem seems to appear late in
>> >> >> >> > boot, and you had no problem capturing that portion of the boot log.
>> >> >> >> >
>> >> >> >> > So please see below for a patch providing a rcu_check_beenonline()
>> >> >> >> > function that, when called after rcu_init(), returns non-zero if the
>> >> >> >> > beenonline fields have become corrupted.  So put calls of the form:
>> >> >> >> >
>> >> >> >> >        WARN_ON_ONCE(rcu_check_beenonline());
>> >> >> >> >
>> >> >> >> > in the initialization code path preceding the problem.  Either #include
>> >> >> >> > rcupdate.h or explicitly declare the function as appropriate.
>> >> >> >> >
>> >> >> >> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> >> >> >> > ---
>> >> >> >> >
>> >> >> >> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
>> >> >> >> > index 9642c6b..190a687 100644
>> >> >> >> > --- a/include/linux/rcutree.h
>> >> >> >> > +++ b/include/linux/rcutree.h
>> >> >> >> > @@ -39,6 +39,8 @@ extern int rcu_cpu_notify(struct notifier_block *self,
>> >> >> >> >  extern int rcu_needs_cpu(int cpu);
>> >> >> >> >  extern int rcu_expedited_torture_stats(char *page);
>> >> >> >> >
>> >> >> >> > +extern int rcu_check_beenonline(void);
>> >> >> >> > +
>> >> >> >> >  #ifdef CONFIG_TREE_PREEMPT_RCU
>> >> >> >> >
>> >> >> >> >  extern void __rcu_read_lock(void);
>> >> >> >> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> >> >> >> > index 207125b..27d3722 100644
>> >> >> >> > --- a/kernel/rcutree.c
>> >> >> >> > +++ b/kernel/rcutree.c
>> >> >> >> > @@ -77,6 +77,17 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
>> >> >> >> >  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
>> >> >> >> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
>> >> >> >> >
>> >> >> >> > +/*
>> >> >> >> > + * Ad-hoc diagnostic function, for use only after rcu_init() has
>> >> >> >> > + * returned.  Assumes that the boot CPU is CPU 0.  Assumes that
>> >> >> >> > + * the kernel has been built with CONFIG_TREE_RCU.  Not for inclusion.
>> >> >> >> > + * Usage: "WARN_ON_ONCE(rcu_check_beenonline());"
>> >> >> >> > + */
>> >> >> >> > +int rcu_check_beenonline(void)
>> >> >> >> > +{
>> >> >> >> > +       return !per_cpu(rcu_sched_data, 0).beenonline ||
>> >> >> >> > +              !per_cpu(rcu_bh_data, 0).beenonline;
>> >> >> >> > +}
>> >> >> >> >
>> >> >> >> >  /*
>> >> >> >> >  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
>> >> >> >> >
>> >> >> >
>> >> >
>> >
>
