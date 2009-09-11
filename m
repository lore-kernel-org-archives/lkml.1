Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZIKGKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZIKGKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZIKGKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:10:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZIKGKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:10:31 -0400
Date: Fri, 11 Sep 2009 08:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
Message-ID: <20090911061024.GA27833@elte.hu>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljkm9yew.fsf@depni.sinp.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> >    perf stat --repeat 3 make -j4 bzImage
> 
> BFS hangs here:
> 
> [  128.859000] BUG: soft lockup - CPU#2 stuck for 61s! [sh:7946]
> [  128.859016] Modules linked in:
> [  128.859016] CPU 2:
> [  128.859016] Modules linked in:
> [  128.859016] Pid: 7946, comm: sh Not tainted 2.6.31-bfs211-dirty #4 GA-MA790FX-DQ6
> [  128.859016] RIP: 0010:[<ffffffff81055a52>]  [<ffffffff81055a52>] task_oncpu_function_call+0x22/0x40
> [  128.859016] RSP: 0018:ffff880205967e18  EFLAGS: 00000246
> [  128.859016] RAX: 0000000000000002 RBX: ffff880205964cc0 RCX: 000000000000dd00
> [  128.859016] RDX: ffff880211138c00 RSI: ffffffff8108d3f0 RDI: ffff88022e42a100
> [  128.859016] RBP: ffffffff8102d76e R08: ffff880028066000 R09: 0000000000000000
> [  128.859016] R10: 0000000000000000 R11: 0000000000000058 R12: ffffffff8108d3f0
> [  128.859016] R13: ffff880211138c00 R14: 0000000000000001 R15: 000000000000e260
> [  128.859016] FS:  00002b9ba0924e00(0000) GS:ffff880028066000(0000) knlGS:0000000000000000
> [  128.859016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  128.859016] CR2: 00002b9ba091e4a8 CR3: 0000000001001000 CR4: 00000000000006e0
> [  128.859016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  128.859016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  128.859016] Call Trace:
> [  128.859016]  [<ffffffff8108ee3b>] ? perf_counter_remove_from_context+0x3b/0x90
> [  128.859016]  [<ffffffff810904b4>] ? perf_counter_exit_task+0x114/0x340
> [  128.859016]  [<ffffffff810c3f66>] ? filp_close+0x56/0x90
> [  128.859016]  [<ffffffff8105d3ac>] ? do_exit+0x14c/0x6f0
> [  128.859016]  [<ffffffff8105d991>] ? do_group_exit+0x41/0xb0
> [  128.859016]  [<ffffffff8105da12>] ? sys_exit_group+0x12/0x20
> [  128.859016]  [<ffffffff8102cceb>] ? system_call_fastpath+0x16/0x1b
> 
> So, got nothing to compare with.

Could still compare -j5 to -j4 on -tip, to see why -j4 is 3% short 
of -j5's throughput.

(Plus maybe the NEW_FAIR_SLEEPERS change in -tip fixes the 3% drop.)

	Ingo
