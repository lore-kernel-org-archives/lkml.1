Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYI3ME2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYI3ME2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYI3MEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:04:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYI3MEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:04:20 -0400
Date: Tue, 30 Sep 2008 08:04:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/6] ftrace: port to the new ring_buffer
In-Reply-To: <20080930082302.GA2852@elte.hu>
Message-ID: <alpine.DEB.1.10.0809300801500.30533@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930074514.GB2838@elte.hu> <20080930082302.GA2852@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > very nice! I'd expect breakages and complications too so i 
> > restructured tip/tracing/* a bit: firstly i created a tip/tracing/core 
> > append-only merge branch which collects all the known-robust bits. 
> > Then i created a new branch for your new generic ring-buffer feature: 
> > tip/tracing/ring-buffer, and applied your patches. I've started 
> > testing it.
> 
> -tip testing found that tip/tracing/ring-buffer causes a new lockdep 
> splat:
> 
> [    0.000000] Linux version 2.6.27-rc8-tip-00915-g8cb18a9-dirty (mingo@dione)
>                (gcc version 4.2.3) #37501 SMP Tue Sep 30 10:10:10 CEST 2008
> [...]
> [    0.268001] calling  tracer_alloc_buffers+0x0/0x1e5 @ 1
> [    0.270983] ------------[ cut here ]------------
> [    0.271100] WARNING: at kernel/lockdep.c:2880 check_flags+0x63/0x179()
> [    0.271219] Modules linked in:
> [    0.271356] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-tip-00915-g8cb18a9-dirty #37501
> [    0.271563] Call Trace:
> [    0.271678]  [<ffffffff80271d2b>] warn_on_slowpath+0x5d/0x84
> [    0.271797]  [<ffffffff80295973>] ? __lock_acquire+0xba4/0xbc5
> [    0.271916]  [<ffffffff8029266d>] ? __raw_spin_is_locked+0x17/0x1a
> [    0.272001]  [<ffffffff802929cc>] ? graph_unlock+0x79/0x7e
> [    0.272001]  [<ffffffff8029449f>] ? mark_lock+0x1c/0x361
> [    0.272001]  [<ffffffff8029483a>] ? mark_held_locks+0x56/0x71
> [    0.272001]  [<ffffffff802cbb77>] ? time_hardirqs_off+0x12/0x26
> [    0.272001]  [<ffffffff802934f1>] ? trace_hardirqs_off_caller+0x21/0xc2

I don't even need to look at the configs. There's places I still used the 
"raw_local_irq_save" and that is what in the past has caused this issue.
I'll go and remove those.

-- Steve
