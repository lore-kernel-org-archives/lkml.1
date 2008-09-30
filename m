Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYI3IbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYI3IbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYI3IbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:31:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYI3IbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:31:14 -0400
Date: Tue, 30 Sep 2008 10:30:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/6] ftrace: port to the new ring_buffer
Message-ID: <20080930083051.GA10127@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930074514.GB2838@elte.hu> <20080930082302.GA2852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930082302.GA2852@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -tip testing found that tip/tracing/ring-buffer causes a new lockdep 
> splat:

FYI, triggered on a number of 32-bit test-systems as well - see the log 
below.

	Ingo

[    0.564008] calling  tracer_alloc_buffers+0x0/0x16b @ 1
[    0.574504] ------------[ cut here ]------------
[    0.576002] WARNING: at kernel/lockdep.c:2880 check_flags+0x5a/0x155()
[    0.576002] Modules linked in:
[    0.576002] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-tip-00915-g8cb18a9-dirty #37502
[    0.576002]  [<c01536c4>] warn_on_slowpath+0x46/0x6a
[    0.576002]  [<c0170b14>] ? trace_hardirqs_off+0xb/0xd
[    0.576002]  [<c0173294>] ? __lock_acquire+0xa91/0xaad
[    0.576002]  [<c01a6470>] ? get_page_from_freelist+0x37b/0x455
[    0.576002]  [<c0170044>] ? __raw_spin_is_locked+0x15/0x18
[    0.576002]  [<c0171cf8>] ? find_usage_backwards+0x21/0xe1
[    0.576002]  [<c019f852>] ? time_hardirqs_off+0xe/0x1f
[    0.576002]  [<c0170a66>] ? trace_hardirqs_off_caller+0x15/0xb8
[    0.576002]  [<c0170b14>] ? trace_hardirqs_off+0xb/0xd
[    0.576002]  [<c0120ef0>] ? native_sched_clock+0x83/0x9f
[    0.576002]  [<c0170169>] check_flags+0x5a/0x155
[    0.576002]  [<c01732ec>] lock_acquire+0x3c/0x97
[    0.576002]  [<c14296e9>] _spin_lock+0x23/0x50
[    0.576002]  [<c019bd32>] ? ring_buffer_reset_cpu+0x3f/0x5f
[    0.576002]  [<c019bd32>] ring_buffer_reset_cpu+0x3f/0x5f
[    0.576002]  [<c019e314>] tracing_reset+0xa/0xc
[    0.576002]  [<c01a0b36>] boot_trace_init+0x24/0x3b
[    0.576002]  [<c208577c>] tracer_alloc_buffers+0x137/0x16b
[    0.576002]  [<c010113f>] do_one_initcall+0x57/0x149
[    0.576002]  [<c2085645>] ? tracer_alloc_buffers+0x0/0x16b
[    0.576002]  [<c207bd1c>] ? setup_boot_APIC_clock+0x4b6/0x4cb
[    0.576002]  [<c1421701>] ? print_cpu_info+0x83/0x112
[    0.576002]  [<c2085645>] ? tracer_alloc_buffers+0x0/0x16b
[    0.576002]  [<c206a4c6>] kernel_init+0x54/0x1e2
[    0.576002]  [<c206a472>] ? kernel_init+0x0/0x1e2
[    0.576002]  [<c011cbd3>] kernel_thread_helper+0x7/0x10
[    0.576002]  =======================
[    0.576002] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.576002] possible reason: unannotated irqs-off.
[    0.576002] irq event stamp: 5283
[    0.576002] hardirqs last  enabled at (5283): [<c0172396>] trace_hardirqs_on+0xb/0xd
[    0.576002] hardirqs last disabled at (5282): [<c0170b14>] trace_hardirqs_off+0xb/0xd
[    0.576002] softirqs last  enabled at (2226): [<c015817d>] __do_softirq+0xe9/0xf1
[    0.576002] softirqs last disabled at (2219): [<c011e206>] do_softirq+0x7e/0xdf
[    0.576017] initcall tracer_alloc_buffers+0x0/0x16b returned 0 after 7 msecs
[    0.580235] lockdep: fixing up alternatives.
[    0.584057] CPU 1 irqstacks, hard=c2299000 soft=c2291000
[    0.588007] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4020.67 BogoMIPS (lpj=8041348)
