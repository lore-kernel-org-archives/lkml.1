Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZHUSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZHUSnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZHUSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:43:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44798 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZHUSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:43:17 -0400
Date: Sat, 22 Aug 2009 00:13:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-20-19-18 uploaded
Message-ID: <20090821184314.GA17316@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org> <20090821103813.GA27473@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090821103813.GA27473@darkstar>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young <hidave.darkstar@gmail.com> [2009-08-21 18:38:57]:

> Hi andrew
> 
> cgroup build fail:
> 
> kernel/sched.c:10452: error: expected ';', ',' or ')' before 'bool'
> kernel/sched.c:10536: error: 'cpu_cgroup_attach' undeclared here (not in a function)
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....
> 
> fixing:
> --
> 
> --- linux-2.6.orig/kernel/sched.c	2009-08-21 18:08:16.000000000 +0800
> +++ linux-2.6/kernel/sched.c	2009-08-21 18:20:03.000000000 +0800
> @@ -10448,7 +10448,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
> 
>  static void
>  cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> -		  struct cgroup *old_cont, struct task_struct *tsk
> +		  struct cgroup *old_cont, struct task_struct *tsk,
>  		  bool threadgroup)

Beyond this, I am seeing a bootup issue that I am yet to debug

HugeTLB registered 2 MB page size, pre-allocated 0 pages
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff810f3e28>] sget+0x161/0x491
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.31-rc6-mm1 #111 IBM System x3250
-[436482A]-
RIP: 0010:[<ffffffff810f3e28>]  [<ffffffff810f3e28>] sget+0x161/0x491
RSP: 0018:ffff88012df7bc50  EFLAGS: 00010286
RAX: 0000000000000000 RBX: fffffffffffffe08 RCX: 0000000000000033
RDX: ffff880005800000 RSI: ffff88000580ec80 RDI: 0000000000000246
RBP: ffff88012df7bcc0 R08: ffffffff810f3d2e R09: ffffffff810df9ec
R10: 000000000000005b R11: 00000000001d95d4 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff816c9af0 R15: ffff88012df7a000
FS:  0000000000000000(0000) GS:ffff880005800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88012df7a000, task
ffff88007dfc8040)
Stack:
 ffff88012df7a000 ffff88012df7bfd8 0000000000000000 ffffffff810f3617
<0> ffffffff810f360c ffffffff816c9b20 ffffffff816c9b40
ffffffff816c9b30
<0> ffffffff816c9b38 00000000fffffff4 ffff88007df89880
0000000000000000
Call Trace:
 [<ffffffff810f3617>] ? set_anon_super+0x0/0xe7
 [<ffffffff810f360c>] ? compare_single+0x0/0xb
 [<ffffffff8141f48f>] ? rpc_fill_super+0x0/0xa7
 [<ffffffff810f461f>] get_sb_single+0x33/0xa9
 [<ffffffff8141ec67>] rpc_get_sb+0x16/0x18
 [<ffffffff810f4433>] vfs_kern_mount+0x9d/0x158
 [<ffffffff8110d40b>] simple_pin_fs+0x45/0xb2
 [<ffffffff8179103c>] ? init_nfs_fs+0x0/0x14c
 [<ffffffff814200ae>] rpc_get_mount+0x1e/0x31
 [<ffffffff811aefa0>] nfs_cache_register+0x18/0x83
 [<ffffffff810117f8>] ? sched_clock+0x9/0xd
 [<ffffffff810712fb>] ? lock_release_holdtime+0x189/0x18e
 [<ffffffff81790f42>] ? init_iso9660_fs+0x0/0x61
 [<ffffffff81448763>] ? _write_unlock+0x26/0x48
 [<ffffffff8179103c>] ? init_nfs_fs+0x0/0x14c
 [<ffffffff811aeab6>] nfs_dns_resolver_init+0x10/0x12
 [<ffffffff8179104a>] init_nfs_fs+0xe/0x14c
 [<ffffffff8100905c>] do_one_initcall+0x56/0x133
 [<ffffffff81092637>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff81130000>] ? elf_core_dump+0x289/0xeab
 [<ffffffff8176f693>] kernel_init+0x153/0x1a9
 [<ffffffff8100cd2a>] child_rip+0xa/0x20
 [<ffffffff8176f540>] ? kernel_init+0x0/0x1a9
 [<ffffffff8100cd20>] ? child_rip+0x0/0x20
Code: 20 ff ff 49 8b bc 24 a0 05 00 00 e8 d1 20 ff ff 4c 89 e7 e8 c9
20 ff ff e9 2c 03 00 00 48 8b 83 f8 01 00 00 48 8d 98 08 fe ff ff <48>
8b 83 f8 01 00 00 0f 18 08 48 8d 83 f8 01 00 00 48 39 45 b8 
RIP  [<ffffffff810f3e28>] sget+0x161/0x491
 RSP <ffff88012df7bc50>
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---
note: swapper[1] exited with preempt_count 2
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.31-rc6-mm1 #111
Call Trace:
 [<ffffffff81445433>] panic+0xaf/0x165
 [<ffffffff81056e17>] ? exit_ptrace+0x36/0x119
 [<ffffffff81050850>] ? do_exit+0x2d8/0x74d
 [<ffffffff81050850>] ? do_exit+0x2d8/0x74d
 [<ffffffff814486c2>] ? _write_unlock_irq+0x26/0x4e
 [<ffffffff810505f0>] do_exit+0x78/0x74d
 [<ffffffff8144a114>] oops_end+0xb9/0xc1
 [<ffffffff8102e3b7>] no_context+0x1ea/0x1f9
 [<ffffffff8102e57f>] __bad_area_nosemaphore+0x1b9/0x1df
 [<ffffffff810117f8>] ? sched_clock+0x9/0xd
 [<ffffffff8107256b>] ? __lock_acquire+0x61f/0xa03
 [<ffffffff8107256b>] ? __lock_acquire+0x61f/0xa03
 [<ffffffff810117b6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff810117f8>] ? sched_clock+0x9/0xd
 [<ffffffff8107256b>] ? __lock_acquire+0x61f/0xa03
 [<ffffffff810117b6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8102e5b3>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8144b6bd>] do_page_fault+0x223/0x359
 [<ffffffff81449575>] page_fault+0x25/0x30
 [<ffffffff810df9ec>] ? interleave_nodes+0x3a/0x73
 [<ffffffff810f3d2e>] ? sget+0x67/0x491
 [<ffffffff810f3e28>] ? sget+0x161/0x491
 [<ffffffff810f3617>] ? set_anon_super+0x0/0xe7
 [<ffffffff810f360c>] ? compare_single+0x0/0xb
 [<ffffffff8141f48f>] ? rpc_fill_super+0x0/0xa7
 [<ffffffff810f461f>] get_sb_single+0x33/0xa9
 [<ffffffff8141ec67>] rpc_get_sb+0x16/0x18
 [<ffffffff810f4433>] vfs_kern_mount+0x9d/0x158
 [<ffffffff8110d40b>] simple_pin_fs+0x45/0xb2
 [<ffffffff8179103c>] ? init_nfs_fs+0x0/0x14c
 [<ffffffff814200ae>] rpc_get_mount+0x1e/0x31
 [<ffffffff811aefa0>] nfs_cache_register+0x18/0x83
 [<ffffffff810117f8>] ? sched_clock+0x9/0xd
 [<ffffffff810712fb>] ? lock_release_holdtime+0x189/0x18e
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 0
 [<ffffffff81790f42>] ? init_iso9660_fs+0x0/0x61
 [<ffffffff81448763>] ? _write_unlock+0x26/0x48
 [<ffffffff8179103c>] ? init_nfs_fs+0x0/0x14c
 [<ffffffff811aeab6>] nfs_dns_resolver_init+0x10/0x12
 [<ffffffff8179104a>] init_nfs_fs+0xe/0x14c
 [<ffffffff8100905c>] do_one_initcall+0x56/0x133
 [<ffffffff81092637>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff81130000>] ? elf_core_dump+0x289/0xeab
 [<ffffffff8176f693>] kernel_init+0x153/0x1a9
 [<ffffffff8100cd2a>] child_rip+0xa/0x20
 [<ffffffff8176f540>] ? kernel_init+0x0/0x1a9
 [<ffffffff8100cd20>] ? child_rip+0x0/0x20




-- 
	Balbir
