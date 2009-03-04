Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZCDQxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZCDQxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZCDQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:52:52 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51670 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZCDQww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:52:52 -0500
Date: Wed, 4 Mar 2009 22:22:08 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090304165208.GA26432@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com> <1236184389.5937.40.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1236184389.5937.40.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker <dwalker@fifo99.com> [2009-03-04 08:33:09]:

> On Wed, 2009-03-04 at 17:49 +0530, Arun R Bharadwaj wrote:
> > @@ -649,6 +650,16 @@ __mod_timer(struct timer_list *timer, un
> >  
> >         new_base = __get_cpu_var(tvec_bases);
> >  
> > +       current_cpu = smp_processor_id();
> > +       preferred_cpu = get_nohz_load_balancer();
> > +       if (enable_timer_migration && !tbase_get_pinned(timer->base)
> > &&
> > +                       idle_cpu(current_cpu) && preferred_cpu != -1)
> > {
> > +               new_base = per_cpu(tvec_bases, preferred_cpu);
> > +               timer_set_base(timer, new_base);
> > +               timer->expires = expires;
> > +               internal_add_timer(new_base, timer);
> > +               goto out_unlock;
> > +       }
> 
> Are you sure this compiles w/ CONFIG_SMP=n ? It looks like
> enable_timer_migration wouldn't exist in that case, but the chunks your
> adding in the timer code are still using it.
> 
> Daniel
>

Hi Daniel,

Thanks for pointing this out. I'll clean this up in my next iteration.

--arun
