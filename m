Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZCFPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZCFPHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZCFPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:07:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZCFPHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:07:09 -0500
Date: Fri, 6 Mar 2009 16:03:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 1/4] timers: framework to identify pinned timers.
Message-ID: <20090306150335.GB5828@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121456.GB9855@linux.vnet.ibm.com> <20090305165340.GA6984@redhat.com> <20090306061438.GB9190@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306061438.GB9190@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Arun R Bharadwaj wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2009-03-05 17:53:40]:
>
> > > @@ -736,6 +759,7 @@ void add_timer_on(struct timer_list *tim
> > >  	struct tvec_base *base = per_cpu(tvec_bases, cpu);
> > >  	unsigned long flags;
> > >
> > > +	timer_set_pinned(timer);
> >
> > But we never clear TBASE_PINNED_FLAG?
> >
> > If we use mod_timer() next time, the timer remains "pinned". I do not say
> > this is really wrong, but a bit strange imho.
> >
> > Oleg.
> >
>
> The pinned timer would expect to continue firing on the same CPU
> although it does a mod_timer() the next time, right?

Why? Let's suppose we call queue_delayed_work_on(), and next time
we use queue_delayed_work() with the same dwork. The timer is still
pinned, this doesn't look consistent to me.

> Thats why I have not cleared the TBASE_PINNED_FLAG.

Personally, I don't like this flag. I think that "pinned" should
be the argument for mod_timer(), not the "property" of timer_list.

Oleg.

