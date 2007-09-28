Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbXI1XFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbXI1XFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbXI1XFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:05:38 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:55775 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXI1XFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:05:37 -0400
Date: Fri, 28 Sep 2007 19:05:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gautham R Shenoy <ego@in.ibm.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       a.p.zijlstra@chello.nl, bunk@kernel.org, oleg@tv-sign.ru,
       srostedt@redhat.com
Subject: Re: [PATCH RFC 6/9] RCU priority boosting for preemptible RCU
In-Reply-To: <20070928225649.GA9899@in.ibm.com>
Message-ID: <Pine.LNX.4.58.0709281901470.17405@gandalf.stny.rr.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183901.GF3819@linux.vnet.ibm.com> <20070928225649.GA9899@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Fri, 28 Sep 2007, Gautham R Shenoy wrote:

> >
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> > +/*
> > + * Task state with respect to being RCU-boosted.  This state is changed
> > + * by the task itself in response to the following three events:
> 							^^^
> > + * 1. Preemption (or block on lock) while in RCU read-side critical section.
>
> I am wondering, can a task block on a lock while in RCU read-side
> critical section?

I think this may be specific to the -rt patch. In the -rt patch,
spin_locks turn into mutexes, and therefor can block a read-side critical
section.


> > + * 2. Outermost rcu_read_unlock() for blocked RCU read-side critical section.
> > + *
>
> Event #3. is missing?

I guess Paul needs to answer that one ;-)

-- Steve

