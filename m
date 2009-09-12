Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZILU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZILU1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZILU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZILU1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:27:48 -0400
Subject: Re: [origin tree boot hang] lockup in key_schedule_gc()
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com
In-Reply-To: <20090912135808.GA17416@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
	 <1252748791.2305.89.camel@dhcp231-106.rdu.redhat.com>
	 <20090912104346.GB27935@elte.hu>  <20090912135808.GA17416@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Sep 2009 16:27:06 -0400
Message-Id: <1252787226.13780.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 15:58 +0200, Ingo Molnar wrote:
> here's a new crash related to security changes - a boot lockup on a 
> testbox:
> 
> Pid: 5, comm: events/0 Tainted: G        W  (2.6.31-tip-02301-g1c11bd7-dirty #13102) System Product Name
> EIP: 0060:[<c104ad77>] EFLAGS: 00000046 CPU: 0
> EIP is at trace_hardirqs_off_caller+0x30/0x9a
> EAX: 00000002 EBX: f70431c0 ECX: c18c8e58 EDX: c10138ce
> ESI: c10138ce EDI: 00000002 EBP: f7051ddc ESP: f7051dd4
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b745e530 CR3: 3618f000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: c210fa6c
> DR6: ffff0ff0 DR7: 00000400
> Call Trace:
>  [<c104adec>] trace_hardirqs_off+0xb/0xd
>  [<c10138ce>] default_send_IPI_mask_logical+0xd2/0xe3
>  [<c1013759>] default_send_IPI_all+0x27/0x67
>  [<c1013a97>] arch_trigger_all_cpu_backtrace+0x30/0x54
>  [<c1060c46>] __rcu_pending+0x49/0x113
>  [<c1060d2d>] rcu_check_callbacks+0x1d/0x9c
>  [<c103390c>] update_process_times+0x29/0x3e
>  [<c104713c>] tick_periodic+0x6a/0x6c
>  [<c1047152>] tick_handle_periodic+0x14/0x6a
>  [<c1013463>] smp_apic_timer_interrupt+0x63/0x73
>  [<c100302f>] apic_timer_interrupt+0x2f/0x40
>  [<c15fdaaa>] ? _spin_unlock_irqrestore+0x3d/0x41
>  [<c103a685>] __queue_work+0x2b/0x30
>  [<c103a6d1>] queue_work_on+0x2c/0x36
>  [<c103a7b2>] queue_work+0x13/0x15
>  [<c103a7c8>] schedule_work+0x14/0x16
>  [<c125178a>] key_schedule_gc+0x28/0x4e
>  [<c1251917>] key_garbage_collector+0x167/0x180
>  [<c103a004>] run_workqueue+0xfb/0x1c4
>  [<c1039fe5>] ? run_workqueue+0xdc/0x1c4
>  [<c12517b0>] ? key_garbage_collector+0x0/0x180
>  [<c103a146>] worker_thread+0x79/0x85
>  [<c103d3e3>] ? autoremove_wake_function+0x0/0x38
>  [<c103a0cd>] ? worker_thread+0x0/0x85
>  [<c103d1d2>] kthread+0x65/0x6a
>  [<c103d16d>] ? kthread+0x0/0x6a
>  [<c1003267>] kernel_thread_helper+0x7/0x10
> Pid: 5, comm: events/0 Tainted: G        W  2.6.31-tip-02301-g1c11bd7-dirty #13102
> 
> config and bootlog attached.

Adding dhowells, the keys maintainer, this one certainly isn't obvious
to me off hand.

-Eric

