Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZDTURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZDTURw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZDTURf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:17:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbZDTURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:17:35 -0400
Date: Mon, 20 Apr 2009 16:17:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <20090420194542.GB5974@nowhere>
Message-ID: <alpine.DEB.2.00.0904201616430.10097@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192803.GA25629@elte.hu> <20090420194542.GB5974@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [   16.033417] Running tests again, along with the function tracer
> > [   16.039141] Running tests on trace events:
> > [   16.043063] Testing event kfree_skb: OK
> > [   16.052521] Testing event kmalloc: OK
> > [   16.061510] Testing event kmem_cache_alloc: OK
> > [   16.071902] Testing event kmalloc_node: OK
> > [   16.081756] Testing event kmem_cache_alloc_node: OK
> > [   16.091759] Testing event kfree: OK
> > [   16.100517] Testing event kmem_cache_free: OK
> > [   16.110523] Testing event irq_handler_exit: OK
> > [   16.120524] Testing event irq_handler_entry: OK
> > [   16.130521] Testing event softirq_entry: OK
> > [   16.139833] Testing event softirq_exit: OK
> > [   16.149597] Testing event lock_acquired: OK
> > [   16.160062] Testing event lock_acquire: OK
> > [   16.171719] Testing event lock_release: <0>BUG: spinlock lockup on CPU#0, swapper/0, 80cd0240
> > [   16.176013] Pid: 0, comm: swapper Not tainted 2.6.30-rc2-tip-01538-ge8201b9-dirty #34096
> > [   16.176013] Call Trace:
> > [   16.176013]  [<80944340>] ? printk+0x15/0x1d
> > [   16.176013]  [<803a410a>] _raw_spin_lock+0x19a/0x1b0
> > [   16.176013]  [<80947bb7>] _spin_lock_irqsave+0x57/0x70
> > [   16.176013]  [<8012b2ca>] __wake_up+0x1a/0x50
> > [   16.176013]  [<8019392f>] trace_wake_up+0x2f/0x40
> 
> 
> The function tracer, used in the selftest, uses trace_current_buffer_unlock_commit
> which in turn calls trace_wake_up.
> 
> The function tracer shouldn't call trace_wake_up() (might hold
> the rq lock already).
> 
> I'm preparing a fix.
> 

Hmm, doesn't the trace wakeup test if the runqueue lock is locked or not?

-- Steve

