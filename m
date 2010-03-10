Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0CJC2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:28:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57999 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab0CJC2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:28:04 -0500
Date: Tue, 9 Mar 2010 18:28:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, josh@joshtriplett.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] rcu: don't ignore preempt_disable() in the idle loop
Message-ID: <20100310022800.GG6203@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4B962D57.1000406@cn.fujitsu.com> <20100310013035.GB6203@linux.vnet.ibm.com> <4B970064.2040802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B970064.2040802@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:13:56AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> >>
> >> This is another try, it uses the fact that idle loops
> >> are executing with preept_count()=1.
> >> But I didn't look deep into all idle loops.
> > 
> > Hello, Lai!
> > 
> > One question below...
> > 
> > 						Thanx, Paul
> > 
> 
> [...]
> 
> >> +
> >> +	if ((preempt_count() & PREEMPT_MASK) > IDLE_CORE_LOOP_PREEMPT_COUNT)
> >> +		return 0;
> > 
> > How does this work in CONFIG_PREEMPT=n kernels?  I don't see how it
> > does, regardless of what preempt_count() returns in this case.
> 
> You are right, It cannot work in CONFIG_PREEMPT=n kernels.
> ignore this stupid patch.

Don't be too hard on yourself -- it is an interesting idea, just doesn't
seem to quite work out.  Perhaps it will lead you to another idea that
does work.

							Thanx, Paul
