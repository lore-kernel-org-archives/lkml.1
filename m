Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXISV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXISV3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbXISV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:29:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:24794 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbXISV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tfeeAcwGBdzMm3g0lfljSX3OcYLTfuwSx/7gZcJYcD64j3CY2djE7iwsnJKXakL3RwunwXOG9Jget+bXuETP/pkLnObit99plcD+igdpc59rzu3msTrdUX2y5C9QoouuBdrJVE/XH1nPIt05s8Q96eUDHFneCRa41p8nrn0pVG4=
Message-ID: <d120d5000709191429n29f5dc78g2746de3ee4e9ca81@mail.gmail.com>
Date: Wed, 19 Sep 2007 17:29:09 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919231943.4b121361@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
	 <20070919173249.GE8666@linux.vnet.ibm.com>
	 <20070919174857.GA11922@linux.vnet.ibm.com>
	 <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
	 <20070919214110.5d832f28@lappy>
	 <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
	 <20070919221349.2935f69d@lappy>
	 <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
	 <20070919231943.4b121361@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 19 Sep 2007 16:41:04 -0400 "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> wrote:
>
> > > If the IRQ handler does rcu_read_lock(),unlock() and the i8042_stop()
> > > function does sync_rcu() instead of _sched(), it should be good again.
> > > It will not affect anything else than the task that calls _stop(). And
> > > even there the only change is that the sleep might be a tad longer.
> >
> > And the IRQ handler needs to do some extra job... Anyway, it looks -rt
> > breaks synchronize_sched() and needs to have it fixed:
> >
> > "/**
> >  * synchronize_sched - block until all CPUs have exited any non-preemptive
> >  * kernel code sequences.
> >  *
> >  * This means that all preempt_disable code sequences, including NMI and
> >  * hardware-interrupt handlers, in progress on entry will have completed
> >  * before this primitive returns."
>
> That still does as it says in -rt. Its just that the interrupt handler
> will be preemptible so the guarantees it gives are useless.

Please note "... including NMI and hardware-interrupt handlers ..."

>
> > > I find it curious that a driver that is 'low performant' and does not
> > > suffer lock contention pioneers locking schemes. I agree with
> > > optimizing, but this is not the place to push the envelope.
> >
> > Please realize that evey microsecond wasted on a 'low performant'
> > driver is taken from high performers and if we can help it why
> > shouldn't we?
>
> sure, but the cache eviction caused by running the driver will have
> more impact than the added rcu_read_{,un}lock() calls.

Are you saying that adding rcu_read_{,un}lock() will help with cache
eviction? How?

-- 
Dmitry
