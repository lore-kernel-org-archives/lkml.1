Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbXJLMlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbXJLMlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXJLMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:40:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:60840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXJLMk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:40:57 -0400
Date: Fri, 12 Oct 2007 14:40:54 +0200
From: Jan Blunck <jblunck@suse.de>
To: mingo@redhat.com
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: kernel NULL pointer dereference in check_spread+0x0/0x26
Message-ID: <20071012124054.GD8471@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is with 2.6.23-mm1 and allmodconfig.

Seems that se in the following is a NULL pointer.

453     static void check_spread(struct cfs_rq *cfs_rq, struct
sched_entity *se)
454     {
455     #ifdef CONFIG_SCHED_DEBUG
456             s64 d = se->vruntime - cfs_rq->min_vruntime;
457
458             if (d < 0)
459                     d = -d;

Cheers,
Jan

--
[    1.344000] Unable to handle kernel NULL pointer dereference at 0000000000000040 RIP: 
[    1.348000]  [<ffffffff8022dd7d>] check_spread+0x0/0x26
[    1.356000] PGD 0 
[    1.360000] Oops: 0000 [1] SMP 
[    1.364000] last sysfs file: 
[    1.368000] CPU 1 
[    1.368000] Modules linked in:
[    1.372000] Pid: 2, comm: kthreadd Not tainted 2.6.23-mm1-jbl-gab69b1c9 #4
[    1.380000] RIP: 0010:[<ffffffff8022dd7d>]  [<ffffffff8022dd7d>] check_spread+0x0/0x26
[    1.388000] RSP: 0018:ffff810005753d58  EFLAGS: 00010083
[    1.392000] RAX: 0000000000001908 RBX: ffff81008006b900 RCX: 0000000000000c31
[    1.400000] RDX: 0000000003938700 RSI: 0000000000000000 RDI: ffff81008006b900
[    1.408000] RBP: ffff810005753d90 R08: ffff810005753d40 R09: ffff8100800d0798
[    1.416000] R10: ffffffffffffffff R11: 0000000000000001 R12: ffff810005c12000
[    1.424000] R13: ffff810005c12048 R14: 0000000000000000 R15: 0000000000000001
[    1.428000] FS:  0000000000000000(0000) GS:ffff810005401960(0000) knlGS:0000000000000000
[    1.440000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    1.444000] CR2: 0000000000000040 CR3: 0000000000201000 CR4: 00000000000006e0
[    1.452000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.460000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.468000] Process kthreadd (pid: 2, threadinfo ffff810005752000, task ffff810005750000)
[    1.476000] last branch before last exception/interrupt
[    1.480000]  from  [<ffffffff802363f2>] task_new_fair+0xd0/0x111
[    1.488000]  to  [<ffffffff8022dd7d>] check_spread+0x0/0x26
[    1.492000] Stack:  ffffffff802363f7 ffff8100800d0780 ffff8100800d0780 ffff810005c12000
[    1.500000]  000000000000000f 0000000000000000 0000000000000000 ffff810005753dc0
[    1.508000]  ffffffff80236cf1 0000000000800711 0000000000000286 ffff810005c12000
[    1.516000] Call Trace:
[    1.520000]  [<ffffffff802363f7>] task_new_fair+0xd5/0x111
[    1.524000]  [<ffffffff80236cf1>] wake_up_new_task+0x84/0xb8
[    1.532000]  [<ffffffff802395be>] do_fork+0x186/0x286
[    1.536000]  [<ffffffff8025e101>] __lock_acquire+0xe4b/0xf40
[    1.544000]  [<ffffffff8020d021>] kernel_thread+0x81/0xde
[    1.548000]  [<ffffffff8024fc72>] kthread+0x0/0x76
[    1.552000]  [<ffffffff8020d07e>] child_rip+0x0/0x12
[    1.560000]  [<ffffffff8024fad1>] kthreadd+0xcd/0x143
[    1.564000]  [<ffffffff8020d088>] child_rip+0xa/0x12
[    1.568000]  [<ffffffff8020c79c>] restore_args+0x0/0x30
[    1.576000]  [<ffffffff802a9bea>] __mpol_free+0x3b/0x40
[    1.580000]  [<ffffffff8024fa04>] kthreadd+0x0/0x143
[    1.584000]  [<ffffffff8020d07e>] child_rip+0x0/0x12
[    1.592000] 
[    1.592000] INFO: lockdep is turned off.
[    1.596000] 
[    1.596000] Code: 48 8b 46 40 48 2b 47 20 55 48 89 e5 48 99 48 31 d0 48 29 d0 
[    1.604000] RIP  [<ffffffff8022dd7d>] check_spread+0x0/0x26
[    1.612000]  RSP <ffff810005753d58>
[    1.616000] CR2: 0000000000000040
[    1.620000] kthreadd used greatest stack depth: 5512 bytes left
[   36.348000] BUG: spinlock lockup on CPU#2, swapper/0, ffff8100800d0780
[   36.356000] 
[   36.356000] Call Trace:
[   36.360000]  <IRQ>  [<ffffffff80357e07>] _raw_spin_lock+0x126/0x14e
[   36.368000]  [<ffffffff80449e5f>] _spin_lock+0x46/0x53
[   36.372000]  [<ffffffff80235547>] scheduler_tick+0x42/0x1d8
[   36.376000]  [<ffffffff80244684>] update_process_times+0x82/0x92
[   36.384000]  [<ffffffff80257bd6>] tick_periodic+0x6e/0x7a
[   36.388000]  [<ffffffff80257c03>] tick_handle_periodic+0x21/0x5e
[   36.396000]  [<ffffffff8020b244>] default_idle+0x0/0x64
[   36.400000]  [<ffffffff8021d226>] smp_local_timer_interrupt+0x5a/0x5e
[   36.408000]  [<ffffffff8021d83e>] smp_apic_timer_interrupt+0x3a/0x54
[   36.416000]  [<ffffffff8020b244>] default_idle+0x0/0x64
[   36.420000]  [<ffffffff8020ceab>] apic_timer_interrupt+0x6b/0x70
[   36.428000]  <EOI>  [<ffffffff8020b28e>] default_idle+0x4a/0x64
[   36.432000]  [<ffffffff8020b28c>] default_idle+0x48/0x64
[   36.440000]  [<ffffffff8020b365>] cpu_idle+0xbd/0xf8
[   36.444000]  [<ffffffff8021cd77>] start_secondary+0x3d6/0x3e7
[   36.448000] 
[   36.452000] INFO: lockdep is turned off.
