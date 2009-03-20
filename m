Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZCTR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZCTR6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbZCTR6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:58:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61963 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751AbZCTR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gTIsG52TRz70GATKwfjtP6F/+Djvlo+cmq7MS/ESnGzx098kP/2VT1o7FVWy7BZ+ah
         IVv3aL9+dddeIOFQRaYgOZgyWDzX2sIJ5Qh142OBmQqRzfGw3BTpLS97BLVgTMPb5VXd
         g4DfJdDxuEWGXsdl2coIQhFm1Flty5P0RcJxE=
Date: Fri, 20 Mar 2009 18:57:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320175758.GA5936@nowhere>
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <20090320170548.GC5937@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320170548.GC5937@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 06:05:54PM +0100, Frederic Weisbecker wrote:
> On Thu, Mar 19, 2009 at 08:33:57AM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > these latest ftrace changes caused a lockup on a -tip testsystem:
> > 
> > Note, even with Rusty's offstack-cpumask fix applied (in latest 
> > -tip), i can reproduce a lockup:
> > 
> > [    4.132872] calling  init_mmio_trace+0x0/0x12 @ 1
> > [    4.137551] initcall init_mmio_trace+0x0/0x12 returned 0 after 10 usecs
> > [    4.144149] calling  init_graph_trace+0x0/0x12 @ 1
> > [    4.148913] Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=4294680313/10000 jiffies)
> > [   18.620342] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
> > [   18.620342] Call Trace:
> > [   18.620342]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8021b505>] dump_stack+0x77/0x82
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
> > [   18.620342]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
> > [   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
> > [   18.620342]  [<ffffffff811f1a6d>] ? _spin_unlock_irq+0x9/0x3b
> > [   18.620342]  [<ffffffff811f1a9b>] ? _spin_unlock_irq+0x37/0x3b
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
> > [   18.620342]  [<ffffffff8025e8e4>] ? idle_cpu+0x4/0x33
> > [   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
> > [   18.620342]  [<ffffffff80284453>] ? __local_bh_disable+0x11/0x16c
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff80219305>] handle_irq+0x15d/0x171
> > [   18.620342]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
> > [   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
> > [   18.620342]  [<ffffffff8028aa1d>] run_timer_softirq+0x1c1/0x2af
> > [   18.620342]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
> > [   18.620342]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
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
> 
> 
> Tested under x86-32 and can't reproduce...
> Hopefully this is not because I'm testing on UP.
> 


Now I've tested on x86-64 SMP and still nothing.
Note that I've not only tested the selftests but also the function
graph tracer. But nothing weird appeared.

