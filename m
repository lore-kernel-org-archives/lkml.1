Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZD1UdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZD1UdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZD1Ucu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:32:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:57812 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZD1Uct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=glheH6fu1qNNMk8TWE8KKOOOEfOValyGjxUNNn5AWLkZh/AvEsr7DJrqF9CpBIrsKC
         PkGPsDo4wyd7B1WiJ59LX5/4uCwXUgJ0i15/um0b54y+mh6l/WmvXhQvqYeA4G0yMJPm
         u8uvKLZgmHVognX/e3Rv4An1dWHpZfPfL2o7Y=
Date: Tue, 28 Apr 2009 22:32:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Function graph tracer hang
Message-ID: <20090428203244.GE7337@nowhere>
References: <20090417144055.857407604@goodmis.org> <20090417151135.GG23493@elte.hu> <20090417151303.GA18267@elte.hu> <20090428111223.GA20526@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428111223.GA20526@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 01:12:23PM +0200, Ingo Molnar wrote:
> 
> FYI, a testbox triggered this message today:
> 
>   BUG: Function graph tracer hang!
> 
> i've attached the bootlog. Not sure how reproducible it is. I havent 
> seen this message recently.
> 
> [    3.847095] Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=10000 jiffies)
> [   13.856011] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
> [   13.856011] Call Trace:
> [   13.856011]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802105c8>] dump_trace+0x289/0x325
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802118fb>] show_trace+0x15/0x17
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
> [   13.856011]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
> [   13.856011]  [<ffffffff80250112>] ? tg_shares_up+0x20c/0x22c
> [   13.856011]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
> [   13.856011]  [<ffffffff802cd04f>] ? trace_clock_local+0x28/0x35
> [   13.856011]  [<ffffffff802e7ab5>] ftrace_push_return_trace+0x84/0x108
> [   13.856011]  [<ffffffff80250112>] ? tg_shares_up+0x20c/0x22c
> [   13.856011]  [<ffffffff8022cfdd>] prepare_ftrace_return+0x104/0x164
> [   13.856011]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
> [   13.856011]  [<ffffffff8024c8ce>] ? cpumask_next+0x9/0x37
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
> [   13.856011]  [<ffffffff8024ff06>] ? tg_shares_up+0x0/0x22c
> [   13.856011]  [<ffffffff80247568>] ? tg_nop+0x0/0xd
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8025aba7>] walk_tg_tree+0xac/0x11a
> [   13.856011]  [<ffffffff8025ffd6>] ? rebalance_domains+0xc0/0x2da
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8025b030>] update_shares+0x64/0x69
> [   13.856011]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8025fa03>] load_balance+0xb6/0x5c9
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff802600e5>] rebalance_domains+0x1cf/0x2da
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff80260234>] run_rebalance_domains+0x44/0x153
> [   13.856011]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
> [   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
> [   13.856011]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
> [   13.856011]  <EOI>  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
> [   13.856011]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
> [   13.856011]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
> [   13.856011]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
> [   13.856011]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
> [   13.856011]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
> [   13.856011]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
> [   13.856011]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
> [   13.856011]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
> [   13.856011]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
> [   13.856011]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
> [   13.856011]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
> [   13.856011]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20



Stuck in the timer interrupt.


> CONFIG_HZ_1000=y
> CONFIG_HZ=1000


A lot of timer interrupts.



> CONFIG_PROFILE_ALL_BRANCHES=y

And, looks like a very close recipe to the last hangs we had with
the function graph tracer.
So I'm tempted by the same diagnosis you did with branch prediction
tracing.

Note that the branch profiler does that:

______f.miss_hit[______r]++;

Which is a read + write on the cacheline.
If each "if" are profiled in the timer interrupt, we can
have the cachelines doing a ping-pong of dirtifying since the above
variable is shared.

Then the timer interrupt becomes slower. The function graph tracer itself makes
it slower.
Moreover it is traced itself. So not only the "if" in code are traced, but also
each "if" processed by the function graph tracer on function calls and returns.

Which means a fair amount of cacheline dirtifying.

Then if the timer interrupt is slowed, and we have a lot of them (1000 Hz),
the system spends all of its time inside it.

At least we need the branch tracing to be done per cpu, I guess.

Frederic.

