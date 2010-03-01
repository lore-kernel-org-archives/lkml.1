Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0CASvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:51:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0CASvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:51:09 -0500
Date: Mon, 1 Mar 2010 10:50:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] more lockdep-RCU and RCU_FAST_NO_HZ
	fixes
Message-ID: <20100301185059.GF6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100227225240.GA16515@linux.vnet.ibm.com> <20100228085505.GA2067@elte.hu> <20100228163218.GD6846@linux.vnet.ibm.com> <20100301121045.GA30901@elte.hu> <20100301160813.GA6758@linux.vnet.ibm.com> <1267466290.1579.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267466290.1579.29.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 06:58:10PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-03-01 at 08:08 -0800, Paul E. McKenney wrote:
> > On Mon, Mar 01, 2010 at 01:10:45PM +0100, Ingo Molnar wrote:
> > > 
> > > FYI, even with your patch applied i'm getting this in -tip testing:
> > > 
> > > [    0.000000] Memory: 914996k/1047744k available (15146k kernel code, 452k absent, 131584k reserved, 12516k data, 2552k init)
> > > [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> > > [    0.000000] 
> > > [    0.000000] ===================================================
> > > [    0.000000] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > [    0.000000] ---------------------------------------------------
> > > [    0.000000] include/linux/cgroup.h:492 invoked rcu_dereference_check() without protection!
> > > [    0.000000] 
> > > [    0.000000] other info that might help us debug this:
> > > [    0.000000] 
> > > [    0.000000] 1 lock held by swapper/0:
> > > [    0.000000]  #0:  (&rq->lock){......}, at: [<ffffffff81ec0bad>] init_idle+0x31/0x1ee
> > > [    0.000000] 
> > > [    0.000000] stack backtrace:
> > > [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-tip+ #10563
> > > [    0.000000] Call Trace:
> > > [    0.000000]  [<ffffffff810ad1c1>] lockdep_rcu_dereference+0xa1/0xb0
> > > [    0.000000]  [<ffffffff81ec0cbd>] init_idle+0x141/0x1ee
> > > [    0.000000]  [<ffffffff82ceff40>] sched_init+0x43a/0x4b6
> > > [    0.000000]  [<ffffffff82cdcceb>] start_kernel+0x1b3/0x49e
> > > [    0.000000]  [<ffffffff82cdc319>] x86_64_start_reservations+0x120/0x124
> > > [    0.000000]  [<ffffffff82cdc46b>] x86_64_start_kernel+0x14e/0x15d
> > > [    0.000000] Hierarchical RCU implementation.
> > > [    0.000000] RCU-based detection of stalled CPUs is enabled.
> > > [    0.000000] NR_IRQS:4352
> > > 
> > > Config attached.
> > > 
> > > The sha1 is:
> > > 
> > >   b5fabe1: Merge branch 'perf/urgent'
> > > 
> > > i.e. your latest fix is included:
> > > 
> > >   90a6501: sched, rcu: Fix rcu_dereference() for RCU-lockdep
> > 
> > Sigh!  I clearly need a more organized approach for handling this very
> > early boot stuff.  Fix is in progress, please accept my apologies for
> > the hassle!
> 
> add: system_state != SYSTEM_RUNNING, to all the default
> rcu_read_lock*_held thingies?

My current thought is !rcu_scheduler active to rcu_read_lock*_held() and
to rcu_dereference_check(), but yes, that is pretty much the approach
that I am taking.  ;-)

							Thanx, Paul
