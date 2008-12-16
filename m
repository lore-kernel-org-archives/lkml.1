Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbYLPVJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbYLPVJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759631AbYLPVIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:08:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40393 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611AbYLPVIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:08:47 -0500
Date: Tue, 16 Dec 2008 22:08:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: linux-next: Tree for December 11
Message-ID: <20081216210834.GM14787@elte.hu>
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au> <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com> <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Thu, Dec 11, 2008 at 15:40, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> > On Thu, Dec 11, 2008 at 12:04, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> Hi all,
> >>
> >> Changes since 20081210:
> >>
> >> New tree:
> >>        nommu
> >>
> >> Undropped tree:
> >>        sound
> >>
> >> Dropped trees (temporarily):
> >>        v4l-dvb (build problem)
> >>        mtd (difficult conflicts)
> >>        drm (build problem)
> >>        semaphore-removal (due to unfixed conflicts against Linus' tree)
> >>        cpu_alloc (build problem)
> >>        perfmon3 (concerns from the x86 team)
> >>        audit (difficult conflicts)
> >>        nommu (build problem)
> >>        staging (build failure)
> >>
> >> The driver-core tree gained a build failure that needed a commit reverted.
> >>
> >> The ftrace tree gained a conflict against Linus' tree.
> >>
> >> The pci tree gained a conflict against the driver-core tree.
> >>
> >> The mtd tree gained 3 conflicts against the arm tree which I could not
> >> easily resolve, so it was dropped.
> >>
> >> The ttydev tree gained a conflict against the async_tx tree requiring a
> >> commit from the async_tx tree to be reverted.
> >>
> >> The nommu tree gained conflicts against the slab and kmemcheck trees and
> >> also a build failure so it was dropped.
> >>
> >> ----------------------------------------------------------------------------
> >
> > Hi.
> >
> > I'm seeing this warning early in boot logs. It does not appear on 2.6.28-rc7.
> > Not sure how long it's been around. Haven't built -next for some time.
> >
> > [    0.004000] Intel machine check reporting enabled on CPU#0.
> > [    0.004000] using mwait in idle threads.
> > [    0.004000] Checking 'hlt' instruction... <4>------------[ cut here
> > ]------------
> > [    0.004167] WARNING: at kernel/sched.c:4364 sub_preempt_count+0xae/0xc0()
> > [    0.004266] Hardware name: HP Compaq nx7300 (GB848ES#ACB)
> > [    0.004361] Modules linked in:
> > [    0.004497] Pid: 0, comm: swapper Not tainted 2.6.28-rc8-next-20081211 #117
> > [    0.004595] Call Trace:
> > [    0.004689]  [<c01324d6>] warn_slowpath+0x86/0xa0
> > [    0.004789]  [<c0155d00>] ? check_usage_forwards+0x10/0xb0
> > [    0.004886]  [<c015394a>] ? save_trace+0x3a/0xa0
> > [    0.004981]  [<c015742d>] ? mark_lock+0x37d/0xe00
> > [    0.005076]  [<c01580f9>] ? __lock_acquire+0x249/0x610
> > [    0.005175]  [<c04a3a02>] ? _spin_unlock_irq+0x22/0x50
> > [    0.005272]  [<c0158e50>] ? trace_hardirqs_on_caller+0x70/0x1a0
> > [    0.005369]  [<c04a3a0d>] ? _spin_unlock_irq+0x2d/0x50
> > [    0.005465]  [<c0124bfe>] sub_preempt_count+0xae/0xc0
> > [    0.005564]  [<c0137012>] _local_bh_enable+0x52/0xc0
> > [    0.005661]  [<c013725f>] __do_softirq+0x11f/0x170
> > [    0.005756]  [<c0137140>] ? __do_softirq+0x0/0x170
> > [    0.005851]  <IRQ>  [<c0137729>] ? irq_exit+0x89/0xa0
> > [    0.005993]  [<c01059ed>] ? do_IRQ+0xad/0x120
> > [    0.006088]  [<c0103aac>] ? common_interrupt+0x2c/0x34
> > [    0.006184]  [<c013007b>] ? mmput+0x2b/0xc0
> > [    0.006281]  [<c06735a8>] ? check_bugs+0xb8/0xe0
> > [    0.006379]  [<c066b7ea>] ? start_kernel+0x26a/0x310
> > [    0.006475]  [<c066b270>] ? unknown_bootoption+0x0/0x210
> > [    0.006572]  [<c066b077>] ? __init_begin+0x77/0xb0
> > [    0.006674] ---[ end trace 4eaa2a86a8e2da22 ]---
> > [    0.016004] OK.
> > [    0.016560] ACPI: Core revision 20081031
> > [    0.044495] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >
> > Config and full dmesg attached.
> >
> 
> The warning can also be reproduced in qemu, so it was easy to bisect.
> 
> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Tue Sep 30 20:50:27 2008 +1000
> 
>     sched: improve preempt debugging
> 
>     This patch helped me out with a problem I recently had....
> 
>     Basically, when the kernel lock is held, then preempt_count
> underflow does not
>     get detected until it is released which may be a long time (and arbitrarily,
>     eg at different points it may be rescheduled). If the bkl is released at
>     schedule, the resulting output is actually fairly cryptic...
> 
>     With any other lock that elevates preempt_count, it is illegal to schedule
>     under it (which would get found pretty quickly). bkl allows scheduling with
>     preempt_count elevated, which makes underflows hard to debug.
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> I understand that not this particular commit is buggy, but at least
> I've got someone to add to the CC. ;)
> 
> Also the author's e-mail looks suspicious.

Suspicious in what way?

	Ingo
