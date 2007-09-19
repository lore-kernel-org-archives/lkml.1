Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXISPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXISPZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXISPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:25:42 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58052 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754793AbXISPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:25:41 -0400
Date: Wed, 19 Sep 2007 17:25:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs
 rcu_read_lock()
Message-ID: <20070919172537.3dceb0d3@twins>
In-Reply-To: <d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
References: <20070919104125.286538000@chello.nl>
	<20070919105054.332308000@chello.nl>
	<d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
	<20070919163111.05c18021@twins>
	<d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 11:16:21 -0400 "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> wrote:

> On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 19 Sep 2007 10:17:25 -0400 "Dmitry Torokhov"
> > <dmitry.torokhov@gmail.com> wrote:
> >
> > > Hi Peter,
> > >
> > > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > Warn when rcu_dereference() is not used in combination with rcu_read_lock()
> > > >
> > >
> > > According to Paul it is fine to use RCU primitives (when accompanied
> > > with proper comments) when the read-size critical section is guarded
> > > by spin_lock_irqsave()/spin_lock_irqsrestore() instead of
> > > rcu_read_lock()/rcu_read_unlock() and writers synchronize with
> > > synchronize_sched(), not synchronize_rcu(). Your patch will trigger
> > > warnign on such valid usages.
> > >
> >
> > Sounds fragile to begin with. But you're right in that that is valid
> > for Linux as you know it. However in -rt most/all spinlocks are
> > converted to sleeping locks. In that case sync_sched() is not enough.
> >
> 
> OK, then it goes beyond RCU... We need to come up with something that
> can be used to synchronize with IRQ handlers (quite often in driver
> code one needs to be sure that current invocation of IRQ handler
> completed before doing something). And once we have it splinlock + RCU
> users can just use that method.

Sound like you want a completion or workqueue.
