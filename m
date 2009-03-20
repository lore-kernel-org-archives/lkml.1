Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZCTRno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZCTRno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbZCTRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:43:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40240 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbZCTRne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:43:34 -0400
Date: Fri, 20 Mar 2009 10:43:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320174331.GH6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 01:21:47PM -0400, Steven Rostedt wrote:
> 
> I'm still not able to reproduce, but...
> 
> On Thu, 19 Mar 2009, Ingo Molnar wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > these latest ftrace changes caused a lockup on a -tip testsystem:
> > 
> > Note, even with Rusty's offstack-cpumask fix applied (in latest 
> > -tip), i can reproduce a lockup:
> > 

[ . . . ]

> This looks like it is RCU/stop_machine related. The CPU is stuck in
> in stop_machine? I see that rcu_torture is running. Does this go away if 
> you turn off rcu_torture?

Grasping at straws...  Does Lai's rcu_barrier() fix help?

							Thanx, Paul

> -- Steve
> 
> > [   18.620342]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
> > [   18.620342]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
> > [   18.620342]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
> > [   18.620342]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
> > [   18.620342]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
> > [   18.620342]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
> > [   18.620342]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
> > [   18.620342]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
> > [   18.620342]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
> > [   18.620342]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
> > [   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
> > [   18.620342]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
> > [   18.620342]  [<ffffffff80216060>] ? child_rip+0x0/0x20
> > [   64.758749] INFO: RCU detected CPU 0 stall (t=4294710313/40000 jiffies)
> > [   64.758749] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
> > 
> > (the hang is real - it lasted overnight without the system ever 
> > managing to boot up.)
> > 
> > Config (note, it's different from the config i sent last) and full 
> > bootlog attached.
> > 
> > 	Ingo
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
