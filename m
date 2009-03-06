Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZCFHBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZCFHBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZCFHBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:01:16 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:40069 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZCFHBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:01:16 -0500
Date: Fri, 6 Mar 2009 12:31:07 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 1/4] timers: framework to identify pinned timers.
Message-ID: <20090306070107.GC9190@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121456.GB9855@linux.vnet.ibm.com> <20090305165340.GA6984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090305165340.GA6984@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2009-03-05 17:53:40]:

> On 03/04, Arun R Bharadwaj wrote:
> >
> > +static inline unsigned long tbase_get_flag_bits(struct timer_list *timer)
> > +{
> > +	return tbase_get_deferrable(timer->base) |
> > +				tbase_get_pinned(timer->base);
> > +}
> 
> I'd say this looks a bit strange. Hopefully compiler can optimize this code
> to return (unsigned long)base & (TBASE_DEFERRABLE_FLAG | TBASE_PINNED_FLAG).
>

Misread the above statement.
The code is functionally correct. But not sure if the compiler
optimizes in the way that you have mentioned.

> > @@ -736,6 +759,7 @@ void add_timer_on(struct timer_list *tim
> >  	struct tvec_base *base = per_cpu(tvec_bases, cpu);
> >  	unsigned long flags;
> >
> > +	timer_set_pinned(timer);
> 
> But we never clear TBASE_PINNED_FLAG?
> 
> If we use mod_timer() next time, the timer remains "pinned". I do not say
> this is really wrong, but a bit strange imho.
> 
> Oleg.
> 
