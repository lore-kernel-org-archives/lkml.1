Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYD3AAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYD3AAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYD3AAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:00:07 -0400
Received: from simmts6-srv.bellnexxia.net ([206.47.199.164]:34232 "EHLO
	simmts6-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYD3AAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:00:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4BAF5TF0icIvo8/2dsb2JhbAAIimSiJQ
Message-ID: <4817B67A.40308@gmail.com>
Date: Tue, 29 Apr 2008 20:59:54 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: 2.6.25-git WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x2e/0x46()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

I am getting the following in my dmesg on every boot.  It was reported before[1], so I figured someone was working on it.  However, I haven't seen it get fixed yet, so is there anything I can do to help?


[    0.071066] ------------[ cut here ]------------
[    0.071098] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x2e/0x46()
[    0.071140] Pid: 1, comm: swapper Not tainted 2.6.25-06589-gc65a350 #18
[    0.071169]
[    0.071170] Call Trace:
[    0.071216]  [<ffffffff8022bc88>] warn_on_slowpath+0x53/0x81
[    0.071247]  [<ffffffff80246e8c>] ? save_trace+0x3f/0x95
[    0.071996]  [<ffffffff80248610>] ? mark_lock+0x345/0x36d
[    0.072025]  [<ffffffff80249384>] ? __lock_acquire+0x898/0x8b9
[    0.072055]  [<ffffffff80241ab9>] ? atomic_notifier_chain_register+0x18/0x41
[    0.072087]  [<ffffffff80241ad6>] ? atomic_notifier_chain_register+0x35/0x41
[    0.072118]  [<ffffffff8021be64>] read_apic_id+0x2e/0x46
[    0.072147]  [<ffffffff80611042>] verify_local_APIC+0xaa/0x16a
[    0.072177]  [<ffffffff8061143a>] APIC_init_uniprocessor+0x54/0xf6
[    0.072208]  [<ffffffff806161ed>] ? spawn_softlockup_task+0x56/0x5a
[    0.072237]  [<ffffffff8060b7f4>] kernel_init+0x4c/0x1d6
[    0.072267]  [<ffffffff804a70ea>] ? _spin_unlock_irq+0x50/0x5d
[    0.072296]  [<ffffffff804a6697>] ? trace_hardirqs_on_thunk+0x35/0x3a
[    0.072326]  [<ffffffff80248838>] ? trace_hardirqs_on+0xf8/0x122
[    0.072357]  [<ffffffff8020bf28>] child_rip+0xa/0x12
[    0.072385]  [<ffffffff8020bae3>] ? restore_args+0x0/0x30
[    0.072414]  [<ffffffff8060b7a8>] ? kernel_init+0x0/0x1d6
[    0.072442]  [<ffffffff8020bf1e>] ? child_rip+0x0/0x12
[    0.072468]
[    0.072521] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.072549] ------------[ cut here ]------------
[    0.072575] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x2e/0x46()
[    0.072616] Pid: 1, comm: swapper Tainted: G        W 2.6.25-06589-gc65a350 #18
[    0.072655]
[    0.072656] Call Trace:
[    0.072701]  [<ffffffff8022bc88>] warn_on_slowpath+0x53/0x81
[    0.072729]  [<ffffffff80246e8c>] ? save_trace+0x3f/0x95
[    0.072757]  [<ffffffff80248610>] ? mark_lock+0x345/0x36d
[    0.072786]  [<ffffffff80249384>] ? __lock_acquire+0x898/0x8b9
[    0.072815]  [<ffffffff80241ab9>] ? atomic_notifier_chain_register+0x18/0x41
[    0.072847]  [<ffffffff80241ad6>] ? atomic_notifier_chain_register+0x35/0x41
[    0.072877]  [<ffffffff8021be64>] read_apic_id+0x2e/0x46
[    0.072906]  [<ffffffff80611079>] verify_local_APIC+0xe1/0x16a
[    0.072936]  [<ffffffff8061143a>] APIC_init_uniprocessor+0x54/0xf6
[    0.072965]  [<ffffffff806161ed>] ? spawn_softlockup_task+0x56/0x5a
[    0.072989]  [<ffffffff8060b7f4>] kernel_init+0x4c/0x1d6
[    0.072989]  [<ffffffff804a70ea>] ? _spin_unlock_irq+0x50/0x5d
[    0.072989]  [<ffffffff804a6697>] ? trace_hardirqs_on_thunk+0x35/0x3a
[    0.072989]  [<ffffffff80248838>] ? trace_hardirqs_on+0xf8/0x122
[    0.072989]  [<ffffffff8020bf28>] child_rip+0xa/0x12
[    0.072989]  [<ffffffff8020bae3>] ? restore_args+0x0/0x30
[    0.072989]  [<ffffffff8060b7a8>] ? kernel_init+0x0/0x1d6
[    0.072989]  [<ffffffff8020bf1e>] ? child_rip+0x0/0x12
[    0.072989]
[    0.072989] ---[ end trace 4eaa2a86a8e2da22 ]---


-- 
Kevin Winchester


[1] http://lkml.org/lkml/2008/4/18/333
