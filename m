Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZHYRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZHYRLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZHYRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:11:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60330 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZHYRLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:11:43 -0400
Date: Tue, 25 Aug 2009 10:11:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josht@linux.vnet.ibm.com, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug CPU
Message-ID: <20090825171136.GG6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825080047.GA16139@elte.hu> <20090825161208.GE6616@linux.vnet.ibm.com> <20090825162549.GB25058@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825162549.GB25058@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:25:49PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Tue, Aug 25, 2009 at 10:00:47AM +0200, Ingo Molnar wrote:
> > > 
> > > btw., i'm still seeing crashes with the latest RCU bits:
> > > 
> > > [   20.621740] Testing event sys_enter_futex: OK
> > > [   20.629738] Testing event sys_exit_futex: OK
> > > [   20.637737] Testing event lock_acquire: [reboot]
> > > 
> > > Possibly due to infinite recursion as well. Config attached.
> > 
> > Color me confused...
> > 
> > Unless someone has a better idea, I will send in a patch that adds
> > "notrace" to every RCU API member used by any file in the kernel
> > that has "trace" in its name (excluding ptrace.c and rcutree_trace.c,
> > of course).  This list is as follows:
> > 
> > 	call_rcu()
> > 	call_rcu_sched()
> > 	rcu_read_lock()
> > 	rcu_read_unlock()
> > 
> > So, any better ideas?
> 
> Tracers using RCU should use the _notrace() version of read_lock/unlock.
> I think the callers should be fixed rather than RCU.
> 
> Tracepoints have been designed to use the _notrace variant on the
> instrumentation site. The core of tracepoint management use
> call_rcu_sched(), which can be traced without any problem.
> 
> I have not followed the late tracing development as closely though, so
> errors might have crept in.

Or I might have inadvertently broken something in a non-obvious (to me,
anyway) manner.

So, would you be willing to look at commit bc33f24bd in the -tip
tree and see if there is anything I broke other than the now-fixed
rcu_read_lock_sched_notrace() and rcu_read_unlock_sched_notrace()?
And for that matter, whether my alleged fix for these two API members
really does fix the problem (-tip commit 7c614d6461)?

The -tip tree is at:

	git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

And these patches are on the tip/core/rcu branch.

							Thanx, Paul
