Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbXIUOal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbXIUOal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbXIUOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:30:34 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53802 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822AbXIUOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:30:33 -0400
Date: Fri, 21 Sep 2007 16:30:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs
 rcu_read_lock()
Message-ID: <20070921163027.21e1e124@twins>
In-Reply-To: <d120d5000709210715q22682893ib87998727baffe38@mail.gmail.com>
References: <20070919174857.GA11922@linux.vnet.ibm.com>
	<20070919214110.5d832f28@lappy>
	<d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
	<20070919221349.2935f69d@lappy>
	<d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com>
	<20070919231943.4b121361@lappy>
	<d120d5000709191429n29f5dc78g2746de3ee4e9ca81@mail.gmail.com>
	<20070919234700.3b532dcd@lappy>
	<d120d5000709201031o687ac0d5qe4d32406c12a7886@mail.gmail.com>
	<20070921000155.GI9825@linux.vnet.ibm.com>
	<d120d5000709210715q22682893ib87998727baffe38@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:15:10 -0400 "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> wrote:

> On 9/20/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Sep 20, 2007 at 01:31:35PM -0400, Dmitry Torokhov wrote:
> > >
> > > OK, then what is the purpose of synchronize_sched() in -rt?
> >
> > To wait for all preempt-disable, irq-disable, hard-irq, and SMI/NMI code
> > sequences to complete.
> 
> OK, so what spin_lock_irq[save]? Does is disable IRQs in -rt or not anymore?
> If IRQs are disabled it appears that I can continue using synchronize_sched().

No it will not disable IRQs anymore.

> >
> > > You really need to provide users with a replacement. There are several
> > > drivers that use it and for example r8169 is not what you'd call a
> > > 'low performer'.
> >
> > I did look at making a synchronize_all_irq() some time back, and all
> > the approaches I came up with at the time were busted.
> >
> > But I just took another look, and I think I see a way to handle it.
> > Either that, or I simply forgot the way in which this approach is
> > broken...
> >
> > I will stare at is some more.
> >
> 
> Thank you.

I think the patch posted by Paul earlier today should work.
