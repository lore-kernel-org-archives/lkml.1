Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbZBEBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbZBEBBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbZBEBAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:00:48 -0500
Received: from tundra.namei.org ([65.99.196.166]:2087 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbZBEBAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:00:47 -0500
Date: Thu, 5 Feb 2009 12:00:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] integrity
In-Reply-To: <1233794297.2962.7.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0902051159560.5539@tundra.namei.org>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>  <alpine.LRH.1.10.0902051013430.4638@tundra.namei.org> <1233794297.2962.7.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Mimi Zohar wrote:

> On Thu, 2009-02-05 at 10:16 +1100, James Morris wrote:
> > I get an oops on boot with this.
> > 
> > Do you have lock and list debugging enabled?
> 
> In the past I had them enabled.  Just recompiled now with them enabled
> and was able to boot without problems.

Do you have CONFIG_PREEMPT_RCU and SMP ?

> 
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> 
> 
> > [    2.244280] ------------[ cut here ]------------
> > [    2.245261] WARNING: at kernel/mutex.c:135 mutex_lock_nested+0x325/0x380()
> > [    2.245261] Hardware name: PowerEdge T105
> > [    2.245261] Modules linked in:
> > [    2.245261] Pid: 1, comm: swapper Not tainted 2.6.28 #37
> > [    2.245261] Call Trace:
> > [    2.245261]  [<ffffffff8104f15f>] warn_slowpath+0xaf/0x110
> > [    2.245261]  [<ffffffff8107986d>] ? __lock_acquire+0x58d/0x1b80
> > [    2.245261]  [<ffffffff8107986d>] ? __lock_acquire+0x58d/0x1b80
> > [    2.245261]  [<ffffffff81383f75>] mutex_lock_nested+0x325/0x380
> > [    2.245261]  [<ffffffff810418fe>] ? __wake_up+0x4e/0x70
> > [    2.245261]  [<ffffffff81385c4d>] ? _spin_unlock_irqrestore+0x6d/0x90
> > [    2.245261]  [<ffffffff81078752>] ? trace_hardirqs_on_caller+0x172/0x1d0
> > [    2.245261]  [<ffffffff8125b7db>] tpm_transmit+0x5b/0x270
> > [    2.245261]  [<ffffffff8125ba64>] transmit_cmd+0x14/0x50
> > [    2.245261]  [<ffffffff8125baef>] __tpm_pcr_read+0x4f/0x80
> > [    2.245261]  [<ffffffff810e9f07>] ? kfree+0xc7/0x140
> > [    2.245261]  [<ffffffff81078752>] ? trace_hardirqs_on_caller+0x172/0x1d0
> > [    2.245261]  [<ffffffff810787bd>] ? trace_hardirqs_on+0xd/0x10
> > [    2.245261]  [<ffffffff811b342f>] ? kobject_uevent_env+0x11f/0x3f0
> > [    2.245261]  [<ffffffff810a3e85>] ? __rcu_read_lock+0xc5/0xf0
> > [    2.245261]  [<ffffffff810a3d8b>] ? __rcu_read_unlock+0xbb/0xf0
> > [    2.245261]  [<ffffffff81078752>] ? trace_hardirqs_on_caller+0x172/0x1d0
> > [    2.245261]  [<ffffffff810787bd>] ? trace_hardirqs_on+0xd/0x10
> > [    2.245261]  [<ffffffff8125c6b5>] ? tpm_chip_find_get+0xd5/0xf0
> > [    2.245261]  [<ffffffff8125c7d2>] tpm_pcr_read+0x42/0x70
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff8118d8b7>] ima_init+0x27/0x160
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff815f5dd8>] init_ima+0xe/0x1a
> > [    2.245261]  [<ffffffff8100a03c>] do_one_initcall+0x3c/0x180
> > [    2.245261]  [<ffffffff810a2a3e>] ? register_irq_proc+0xbe/0xe0
> > [    2.245261]  [<ffffffff81140000>] ? v2_read_dquot+0x240/0x2a0
> > [    2.245261]  [<ffffffff815ce703>] kernel_init+0x14d/0x1a3
> > [    2.245261]  [<ffffffff813855a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [    2.245261]  [<ffffffff81015ada>] child_rip+0xa/0x20
> > [    2.245261]  [<ffffffff810153be>] ? restore_args+0x0/0x30
> > [    2.245261]  [<ffffffff815ce5b6>] ? kernel_init+0x0/0x1a3
> > [    2.245261]  [<ffffffff81015ad0>] ? child_rip+0x0/0x20
> > [    2.245261] ---[ end trace 9947c764f5d88c86 ]---
> > [    2.245261] BUG: unable to handle kernel paging request at ffffffff00060000
> > [    2.245261] IP: [<ffffffff811cac36>] __list_add+0x26/0xa0
> > [    2.245261] PGD 203067 PUD 0
> > [    2.245261] Oops: 0000 [#1] PREEMPT SMP
> > [    2.245261] last sysfs file:
> > [    2.245261] CPU 0
> > [    2.245261] Modules linked in:
> > [    2.245261] Pid: 1, comm: swapper Tainted: G        W  2.6.28 #37
> > [    2.245261] RIP: 0010:[<ffffffff811cac36>]  [<ffffffff811cac36>] __list_add+0x26/0xa0
> > [    2.245261] RSP: 0018:ffff88012fa7fb80  EFLAGS: 00010046
> > [    2.245261] RAX: ffffffff00060000 RBX: ffffffff81559ce8 RCX: 0000000000000000
> > [    2.245261] RDX: ffffffff81559ce8 RSI: ffffffff00060000 RDI: ffff88012fa7fbd0
> > [    2.245261] RBP: ffff88012fa7fba0 R08: 0000000000000002 R09: 0000000000000001
> > [    2.245261] R10: ffff8801afa7f95f R11: ffff88012fa7f8e0 R12: ffffffff00060000
> > [    2.245261] R13: ffff88012fa7fbd0 R14: ffff88012fa80000 R15: ffffffff8125b7db
> > [    2.245261] FS:  0000000000000000(0000) GS:ffffffff8159fe00(0000) knlGS:0000000000000000
> > [    2.245261] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [    2.245261] CR2: ffffffff00060000 CR3: 0000000000201000 CR4: 00000000000006e0
> > [    2.245261] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    2.245261] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [    2.245261] Process swapper (pid: 1, threadinfo ffff88012fa7e000, task ffff88012fa80000)
> > [    2.245261] Stack:
> > [    2.245261]  0000000000000246 ffffffff81559cb0 0000000000000246 ffffffff81559cb8
> > [    2.245261]  ffff88012fa7fc30 ffffffff81383d49 ffffffff8125b7db ffffffff810418fe
> > [    2.245261]  0000000000000001 ffffffff81559ce8 ffff88012fa7fbd0 ffff88012fa7fbd0
> > [    2.245261] Call Trace:
> > [    2.245261]  [<ffffffff81383d49>] mutex_lock_nested+0xf9/0x380
> > [    2.245261]  [<ffffffff8125b7db>] ? tpm_transmit+0x5b/0x270
> > [    2.245261]  [<ffffffff810418fe>] ? __wake_up+0x4e/0x70
> > [    2.245261]  [<ffffffff8125b7db>] tpm_transmit+0x5b/0x270
> > [    2.245261]  [<ffffffff8125ba64>] transmit_cmd+0x14/0x50
> > [    2.245261]  [<ffffffff8125baef>] __tpm_pcr_read+0x4f/0x80
> > [    2.245261]  [<ffffffff810e9f07>] ? kfree+0xc7/0x140
> > [    2.245261]  [<ffffffff81078752>] ? trace_hardirqs_on_caller+0x172/0x1d0
> > [    2.245261]  [<ffffffff810787bd>] ? trace_hardirqs_on+0xd/0x10
> > [    2.245261]  [<ffffffff811b342f>] ? kobject_uevent_env+0x11f/0x3f0
> > [    2.245261]  [<ffffffff810a3e85>] ? __rcu_read_lock+0xc5/0xf0
> > [    2.245261]  [<ffffffff810a3d8b>] ? __rcu_read_unlock+0xbb/0xf0
> > [    2.245261]  [<ffffffff81078752>] ? trace_hardirqs_on_caller+0x172/0x1d0
> > [    2.245261]  [<ffffffff810787bd>] ? trace_hardirqs_on+0xd/0x10
> > [    2.245261]  [<ffffffff8125c6b5>] ? tpm_chip_find_get+0xd5/0xf0
> > [    2.245261]  [<ffffffff8125c7d2>] tpm_pcr_read+0x42/0x70
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff8118d8b7>] ima_init+0x27/0x160
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff815f5dca>] ? init_ima+0x0/0x1a
> > [    2.245261]  [<ffffffff815f5dd8>] init_ima+0xe/0x1a
> > [    2.245261]  [<ffffffff8100a03c>] do_one_initcall+0x3c/0x180
> > [    2.245261]  [<ffffffff810a2a3e>] ? register_irq_proc+0xbe/0xe0
> > [    2.245261]  [<ffffffff81140000>] ? v2_read_dquot+0x240/0x2a0
> > [    2.245261]  [<ffffffff815ce703>] kernel_init+0x14d/0x1a3
> > [    2.245261]  [<ffffffff813855a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [    2.245261]  [<ffffffff81015ada>] child_rip+0xa/0x20
> > [    2.245261]  [<ffffffff810153be>] ? restore_args+0x0/0x30
> > [    2.245261]  [<ffffffff815ce5b6>] ? kernel_init+0x0/0x1a3
> > [    2.245261]  [<ffffffff81015ad0>] ? child_rip+0x0/0x20
> > [    2.245261] Code: 98 0f 1f 40 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 d3 4c 89 6d f8 48 8b 42 08 49 89 fd 49 89 f4 48 39 f0 75 27 <49> 8b 04 24 48 39 d8 75 43 4c 89 6b 08 49 89 5d 00 4d 89 65 08
> > [    2.245261] RIP  [<ffffffff811cac36>] __list_add+0x26/0xa0
> > [    2.245261]  RSP <ffff88012fa7fb80>
> > [    2.245261] CR2: ffffffff00060000
> > [    2.245261] ---[ end trace 9947c764f5d88c86 ]---
> > [    2.822672] Kernel panic - not syncing: Attempted to kill init!
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
