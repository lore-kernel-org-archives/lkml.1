Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXI3DLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXI3DLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXI3DLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:11:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37603 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXI3DLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:11:39 -0400
Date: Sat, 29 Sep 2007 20:11:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       a.p.zijlstra@chello.nl, bunk@kernel.org, oleg@tv-sign.ru,
       srostedt@redhat.com
Subject: Re: [PATCH RFC 6/9] RCU priority boosting for preemptible RCU
Message-ID: <20070930031131.GF9119@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183901.GF3819@linux.vnet.ibm.com> <20070928225649.GA9899@in.ibm.com> <Pine.LNX.4.58.0709281901470.17405@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0709281901470.17405@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 07:05:14PM -0400, Steven Rostedt wrote:
> 
> 
> --
> On Fri, 28 Sep 2007, Gautham R Shenoy wrote:
> 
> > >
> > > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> > > +/*
> > > + * Task state with respect to being RCU-boosted.  This state is changed
> > > + * by the task itself in response to the following three events:
> > 							^^^
> > > + * 1. Preemption (or block on lock) while in RCU read-side critical section.
> >
> > I am wondering, can a task block on a lock while in RCU read-side
> > critical section?
> 
> I think this may be specific to the -rt patch. In the -rt patch,
> spin_locks turn into mutexes, and therefor can block a read-side critical
> section.

Yep!  I do need to fix the comment.

> > > + * 2. Outermost rcu_read_unlock() for blocked RCU read-side critical section.
> > > + *
> >
> > Event #3. is missing?
> 
> I guess Paul needs to answer that one ;-)

An older version had three, the new one has two, and I forgot to s/three/two/.

							Thanx, Paul
