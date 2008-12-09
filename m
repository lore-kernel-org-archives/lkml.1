Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYLIJAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYLIJAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYLII7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:59:52 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:53490 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYLII7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mjBvbZEis6ZnvfvxC33hWsEAfhWveS8GJsIh0nPCy7MVPUVQoADZK8PqoOuZP9JA05
         swWWPM1d6V1HnurIbGalx3ME3cc5CinYQSYzQyyw2vTmMeqe75ugA0UEnjr8KHp+49ci
         jhpO5vxZkbtY6rWNCGITxqy+ZUbDia2No3EmY=
Message-ID: <c62985530812090059g27bcb36dg8318123d16a15664@mail.gmail.com>
Date: Tue, 9 Dec 2008 09:59:50 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [crash] Re: [PATCH 1/3] tracing/function-graph-tracer: introduce __notrace_funcgraph to filter special functions
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081209023822.GA3602@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu>
	 <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
	 <20081208155018.GB405@elte.hu> <20081209023822.GA3602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/9 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> yes - but there's a few pending regressions right now delaying the
>> reintegration.
>
> one of them is a new type of ftrace crash that started triggering in
> tip/master:
>
> [    3.610253] initcall init_stack_trace+0x0/0x12 returned 0 after 105468 usecs
> [    3.616017] calling  init_function_trace+0x0/0x12 @ 1
> [    3.620014] Testing tracer function: <1>BUG: unable to handle kernel paging request at ffffffffffffff89
> [    3.648007] IP: [<ffffffff802113a9>] save_rest+0x9/0x70
> [    3.648007] PGD 203067 PUD 204067 PMD 0
> [    3.648007] Thread overran stack, or stack corrupted
> [    3.648007] Oops: 0000 [#1] SMP
> [    3.648007] last sysfs file:
> [    3.648007] CPU 0
> [    3.648007] Pid: 0, comm: swapper Not tainted 2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
> [    3.648007] RIP: 0010:[<ffffffff802113a9>]  [<ffffffff802113a9>] save_rest+0x9/0x70
> [    3.648007] RSP: 0018:ffffffff816fde40  EFLAGS: 00010296
> [    3.648007] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0000000000000003
> [    3.648007] RDX: 0000000000000000 RSI: ffffffff80218b1c RDI: ffffffff80218acc
> [    3.648007] RBP: ffffffff816fde88 R08: ffffffff8025e538 R09: 0000000000000001
> [    3.648007] R10: ffffffff80242084 R11: 0000000000000000 R12: 0000000000000001
> [    3.648007] R13: ffffffff8177f3a0 R14: ffffffff81782390 R15: 0000000000092f70
> [    3.648007] FS:  0000000000000000(0000) GS:ffffffff816f1b00(0000) knlGS:0000000000000000
> [    3.648007] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    3.648007] CR2: ffffffffffffff89 CR3: 0000000000201000 CR4: 00000000000006e0
> [    3.648007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    3.648007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    3.648007] Process swapper (pid: 0, threadinfo ffffffff816fc000, task ffffffff8150d4a0)
> [    3.648007] Stack:
> [    3.648007]  ffffffff802112d6 0000000000000000 0000000000000003 0000000000000000
> [    3.648007]  ffffffff816fc010 0000000000000003 ffffffff8025e538 0000000000000001
> [    3.648007]  ffffffff80218ad1 ffffffff816fde98 ffffffff80218b1c ffffffff816fdec8
> [    3.648007] Call Trace:
> [    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
> [    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
> [    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
> [    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
> [    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
> [    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
> [    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
> [    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
> [    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
> [    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
> [    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
> [    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
> [    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
> [    3.648007] Code: 00 00 00 75 0b 58 65 48 8b 24 25 30 00 00 00 50 e8 78 6e c7 00 c3 66 66 66 90 66 66 66 90 66 66 66 90 4c 8b 5c 24 38 48 89 5c 24 <38> 48 89 6c 24 30 4c 89 64 24 28 4c 89 6c 24 20 4c 89 74 24 18
> [    3.648007] RIP  [<ffffffff802113a9>] save_rest+0x9/0x70
> [    3.648007]  RSP <ffffffff816fde40>
> [    3.648007] CR2: ffffffffffffff89
> [    3.648007] ---[ end trace 5a5d197966b56a2e ]---
> [    3.648007] Kernel panic - not syncing: Attempted to kill the idle task!
> [    3.648007] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
>
> Full crashlog and config attached.
>
>        Ingo
>


Ok I will try this config this evening.
Thanks.
