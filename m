Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678Ab0ALQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0ALQih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659Ab0ALQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:38:34 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:50448 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab0ALQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:38:33 -0500
Date: Tue, 12 Jan 2010 11:38:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3b)
Message-ID: <20100112163831.GB13063@Krystal>
References: <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111043016.GD32213@Krystal> <20100111224355.GH6632@linux.vnet.ibm.com> <20100112153854.GA8122@Krystal> <1263313659.28171.3810.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263313659.28171.3810.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:37:26 up 27 days, 55 min,  4 users,  load average: 0.07, 0.07,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
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

Ah! Indeed! Thanks for helping me see the light. ;)

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
