Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536Ab0ALQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0ALQyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214Ab0ALQyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:54:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54185 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0ALQyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:54:16 -0500
Date: Tue, 12 Jan 2010 08:54:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3b)
Message-ID: <20100112165413.GA6812@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111043016.GD32213@Krystal> <20100111224355.GH6632@linux.vnet.ibm.com> <20100112153854.GA8122@Krystal> <1263313659.28171.3810.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263313659.28171.3810.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:27:39AM -0500, Steven Rostedt wrote:
> On Tue, 2010-01-12 at 10:38 -0500, Mathieu Desnoyers wrote:
> 
> > > The UP-kernel case is handled by the #ifdef in sys_membarrier(), though
> > > with a bit larger code footprint than the embedded guys would probably
> > > prefer.  (Or is the compiler smart enough to omit these function given no
> > > calls to them?  If not, recommend putting them under CONFIG_SMP #ifdef.)
> > 
> > Hrm, that's a bit odd. I agree that UP systems could simply return
> > -ENOSYS for sys_membarrier, but then I wonder how userland could
> > distinguish between:
> > 
> > - an old kernel not supporting sys_membarrier()
> >   -> in this case we need to use the smp_mb() fallback on the read-side
> >      and in synchronize_rcu().
> > - a recent kernel supporting sys_membarrier(), CONFIG_SMP
> >   -> can use the barrier() on read-side, call sys_membarrier upon
> >      update.
> > - a recent kernel supporting sys_membarrier, !CONFIG_SMP
> >   -> calls to sys_membarrier() are not required, nor is barrier().
> > 
> > Or maybe we just postpone the userland smp_mb() question to another
> > thread. This will eventually need to be addressed anyway. Maybe with a
> > vgetmaxcpu() vsyscall.
> 
> I think Paul means to wrap all your other functions under the #ifdef.
> What you have for sys_membarrier() is fine (just return 0 on UP) but you
> also need to wrap the helper function above it under #ifdef CONFIG_SMP.
> Don't rely on the compiler to optimize them out. If anything, you'll
> probably get a bunch of warnings about static functions unused.

Yes -- much clearer statement of what I was getting at.  ;-)

							Thanx, Paul
