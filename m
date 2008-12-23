Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbYLWVgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbYLWVgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYLWVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:36:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47426 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYLWVgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:36:45 -0500
Date: Tue, 23 Dec 2008 22:36:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: panic with tg_shares_up again?
Message-ID: <20081223213630.GA5053@elte.hu>
References: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> yesterday's tip on one 32 cores sytem

Does reverting this:

| commit d71f5a7c8bf9cd7c74159a53e522e363f2eddaf5
| Author: Ken Chen <kenchen@google.com>
| Date:   Fri Dec 19 10:11:50 2008 -0800
|
|     sched: fix uneven per-cpu task_group share distribution

solve the crash?

> 
> [   22.048032] calling  hpet_late_init+0x0/0x19c @ 1
> [   22.052037] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> [   22.057035] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
> [   22.068047] divide error: 0000 [#1] SMP
> [   22.071994] last sysfs file:
> [   22.072030] CPU 8
> [   22.072030] Modules linked in:
> [   22.072030] Pid: 0, comm: swapper Not tainted
> 2.6.28-rc8-tip-01347-gab88ef6-dirty #327
> [   22.072030] RIP: 0010:[<ffffffff8025066e>]  [<ffffffff8025066e>]
> tg_shares_up+0x100/0x1d1
> [   22.072030] RSP: 0018:ffff882024a87d48  EFLAGS: 00010246
> [   22.072030] RAX: 0000000000618800 RBX: ffff880028081680 RCX: ffff88084421d680
> [   22.072030] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
> [   22.072030] RBP: ffff882024a87db8 R08: 0000000000000080 R09: ffff88104441e460
> [   22.072030] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81117da0
> [   22.072030] R13: 0000000000000040 R14: 0000000000000004 R15: 0000000000000800
> [   22.072030] FS:  0000000000000000(0000) GS:ffff881824da7980(0000)
> knlGS:0000000000000000
> [   22.072030] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   22.072030] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   22.072030] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   22.072030] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   22.072030] Process swapper (pid: 0, threadinfo ffff88182467c000,
> task ffff880824af9650)
> [   22.072030] Stack:
> [   22.072030]  0000000000000020 ffffffff810ed680 0000000000001000
> 0000000000000000
> [   22.072030]  0000000000000000 ffff88104441e460 0000000000000283
> 00000004810ee000
> [   22.072030]  0000000000000000 ffffffff81117da0 ffff88104441e360
> ffffffff8025056e
> [   22.072030] Call Trace:
> [   22.072030]  <IRQ> <0> [<ffffffff8025056e>] ? tg_shares_up+0x0/0x1d1
> [   22.072030]  [<ffffffff8024a9e1>] ? tg_nop+0x0/0x8
> [   22.072030]  [<ffffffff8024cd78>] walk_tg_tree+0x74/0x8d
> [   22.072030]  [<ffffffff80254063>] update_shares+0x48/0x4d
> [   22.072030]  [<ffffffff80254478>] rebalance_domains+0x161/0x53c
> [   22.072030]  [<ffffffff8025489c>] run_rebalance_domains+0x49/0xe4
> [   22.072030]  [<ffffffff8026020a>] __do_softirq+0x83/0x145
> [   22.072030]  [<ffffffff8022a15c>] call_softirq+0x1c/0x28
> [   22.072030]  [<ffffffff8022b0a0>] do_softirq+0x34/0x76
> [   22.072030]  [<ffffffff8025ff1b>] irq_exit+0x3f/0x82
> [   22.072030]  [<ffffffff8023a75d>] smp_apic_timer_interrupt+0x93/0xac
> [   22.072030]  [<ffffffff80229b73>] apic_timer_interrupt+0x13/0x20
> [   22.072030]  <EOI> <0>Code: 44 24 08 4a 8b 0c f0 48 85 c9 0f 84 b6
> 00 00 00 49 8b 44 24 10 4a 8b 04 f0 48 8b 80 a8 00 00 00 48 85 c0 74
> 10 49 0f af c7 31 d2 <48> f7 75 b0 48 89 45 d0 eb 11 4c 89 f8 31 d2 48
> c7 45 d0 00 00
> [   22.072030] RIP  [<ffffffff8025066e>] tg_shares_up+0x100/0x1d1
> [   22.072030]  RSP <ffff882024a87d48>
