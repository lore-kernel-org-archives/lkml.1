Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXISPQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXISPQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXISPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:16:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:49884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXISPQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mffkznxVCeQUkrA8reYRQvp4vL6Wyzf64nMeRDt+OHmEHd8XlTbEiTG+zycTeq34WdWW2n0qx83QBaFsjib/4IuahATCaJ7TKE9qlmGrp2bEuQ5QfaWsWv/Gy47lKrM1ge67PcuXpHGL//zBM+F+8OfcQm+j/lH2aMUsFPpXwuM=
Message-ID: <d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
Date: Wed, 19 Sep 2007 11:16:21 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919163111.05c18021@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <20070919105054.332308000@chello.nl>
	 <d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
	 <20070919163111.05c18021@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 19 Sep 2007 10:17:25 -0400 "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> wrote:
>
> > Hi Peter,
> >
> > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Warn when rcu_dereference() is not used in combination with rcu_read_lock()
> > >
> >
> > According to Paul it is fine to use RCU primitives (when accompanied
> > with proper comments) when the read-size critical section is guarded
> > by spin_lock_irqsave()/spin_lock_irqsrestore() instead of
> > rcu_read_lock()/rcu_read_unlock() and writers synchronize with
> > synchronize_sched(), not synchronize_rcu(). Your patch will trigger
> > warnign on such valid usages.
> >
>
> Sounds fragile to begin with. But you're right in that that is valid
> for Linux as you know it. However in -rt most/all spinlocks are
> converted to sleeping locks. In that case sync_sched() is not enough.
>

OK, then it goes beyond RCU... We need to come up with something that
can be used to synchronize with IRQ handlers (quite often in driver
code one needs to be sure that current invocation of IRQ handler
completed before doing something). And once we have it splinlock + RCU
users can just use that method.

-- 
Dmitry
