Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYLSKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYLSKzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYLSKyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:54:52 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:43576 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYLSKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:54:50 -0500
Date: Fri, 19 Dec 2008 16:24:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, yinghai@kernel.org, mel@csn.ul.ie
Subject: [BUG] next-20081216 -  WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081219105441.GA19750@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	next-200816 kernel panics, while boot up on x86_64 machine.

Initializing CPU#0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
PGD 0 
Oops: 0002 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc7-autotest #1
RIP: 0010:[<ffffffff80700449>]  [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
RSP: 0018:ffffffff806f1f68  EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff80766940
RDX: 0000000000000100 RSI: 0000000000000096 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff8800808b0000 R09: 0000000000000000
R10: ffff880001012c80 R11: ffffffff80349d00 R12: 0000000000000000
R13: ffffffff80727240 R14: ffffffff80729a80 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff806e2480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff806f0000, task ffffffff806713a0)
Stack:
 0000000000000003 ffffffff8070048d ffffffff806d4ea0 ffffffff804ff724
 0000000000000003 ffffffff806f9b23 0000000000000000 00000000007e0c30
 ffffffff80729a80 0000000000093350 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8070048d>] native_init_IRQ+0x9/0x931
 [<ffffffff804ff724>] register_cpu_notifier+0x1f/0x23
 [<ffffffff806f9b23>] start_kernel+0x1bd/0x318
 [<ffffffff806f938f>] x86_64_start_kernel+0xde/0xe2
Code: 85 c0 75 0d 59 48 c7 c7 20 2f 67 80 e9 15 d5 cb ff 5a c3 53 31 db e8 ec 86 00 00 31 ff e8 46 ee b0 ff 89 df e8 ce 4e b6 ff 89 df <c7> 40 48 00 02 00 00 48 c7 40 40 00 00 00 00 c7 40 4c 01 00 00 
RIP  [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
 RSP <ffffffff806f1f68>
CR2: 0000000000000048
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x32/0x229()
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-autotest #1
Call Trace:
 [<ffffffff80237267>] warn_on_slowpath+0x51/0x6d
 [<ffffffff80257069>] kallsyms_lookup+0x49/0x80
 [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
 [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
 [<ffffffff8024ba92>] up+0xe/0x36
 [<ffffffff80237935>] release_console_sem+0x18a/0x1a5
 [<ffffffff80252f8f>] smp_call_function_mask+0x32/0x229
 [<ffffffff80516059>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8039a34f>] mix_pool_bytes_extract+0x5c/0x155
 [<ffffffff80237ea1>] printk+0x4e/0x56
 [<ffffffff80258d89>] crash_kexec+0xe6/0xef
 [<ffffffff802531b0>] smp_call_function+0x2a/0x2f
 [<ffffffff8021cdba>] native_smp_send_stop+0x1a/0x26
 [<ffffffff80237322>] panic+0x95/0x13f
 [<ffffffff80237ea1>] printk+0x4e/0x56
 [<ffffffff80239c4f>] do_exit+0x71/0x781
 [<ffffffff80516be1>] oops_begin+0x0/0x8d
 [<ffffffff805184c9>] do_page_fault+0x72c/0x7e5
 [<ffffffff80516199>] error_exit+0x0/0x51
 [<ffffffff80349d00>] delay_loop+0x0/0x29
 [<ffffffff80700449>] init_ISA_irqs+0x18/0x53
 [<ffffffff80700447>] init_ISA_irqs+0x16/0x53
 [<ffffffff8070048d>] native_init_IRQ+0x9/0x931
 [<ffffffff804ff724>] register_cpu_notifier+0x1f/0x23
 [<ffffffff806f9b23>] start_kernel+0x1bd/0x318
 [<ffffffff806f938f>] x86_64_start_kernel+0xde/0xe2
---[ end trace 4eaa2a86a8e2da22 ]---


git-bisect start
# good: [8b1fae4e4200388b64dd88065639413cb3f1051c] Linux 2.6.28-rc8
git-bisect good 8b1fae4e4200388b64dd88065639413cb3f1051c
# bad: [2c5aeead3f33fe8cb92b2ba78f9808149e2a67b6] Add linux-next specific files for 20081216
git-bisect bad 2c5aeead3f33fe8cb92b2ba78f9808149e2a67b6
# bad: [0c9de092b4d35d2352b6bdad4dabe329ae26baa1] Merge commit 'kvm/master'
git-bisect bad 0c9de092b4d35d2352b6bdad4dabe329ae26baa1
# bad: [d762bf4f9299644385149e860378569fb8da5a44] Merge commit 'acpi/test'
git-bisect bad d762bf4f9299644385149e860378569fb8da5a44
# good: [ff7f8bd0fdbada0a12c9b252cc08eac4e88d6d8e] Merge branch 'quilt/driver-core'
git-bisect good ff7f8bd0fdbada0a12c9b252cc08eac4e88d6d8e
# bad: [36046a54cc8a010d0e2e10f08a7deb0b6fd6a55d] Merge commit 'safe-poison-pointers/auto-safe-poison-pointers-next'
git-bisect bad 36046a54cc8a010d0e2e10f08a7deb0b6fd6a55d
# good: [e76bd8d9850c2296a7e8e24c9dce9b5e6b55fe2f] sched: avoid stack var in move_task_off_dead_cpu
git-bisect good e76bd8d9850c2296a7e8e24c9dce9b5e6b55fe2f
# bad: [71007b38ab0295e93697d0dd6dff1db1b8c42854] Merge branch 'cpus4096' into auto-cpus4096-next
git-bisect bad 71007b38ab0295e93697d0dd6dff1db1b8c42854
# good: [b29144c317fb748dae6d72c0f88eda9d43165b8d] Merge branches 'tracing/ftrace' and 'tracing/function-graph-tracer' into tracing/core
git-bisect good b29144c317fb748dae6d72c0f88eda9d43165b8d
# good: [da485e0cb16726797e99a595a399b9fc721b91bc] tracing/fastboot: include missing headers
git-bisect good da485e0cb16726797e99a595a399b9fc721b91bc
# good: [81444a799550214f549caf579cf65a0ca55e70b7] Merge branch 'tracing/fastboot' into cpus4096
git-bisect good 81444a799550214f549caf579cf65a0ca55e70b7
# good: [45ab6b0c76d0e4cce5bd608ccf97b0f6b20f18df] Merge branch 'sched/core' into cpus4096
git-bisect good 45ab6b0c76d0e4cce5bd608ccf97b0f6b20f18df
# bad: [50dd94e017ec39f85c26b6c10ed9fb2d7a7d8042] sparseirq: fix typo in !CONFIG_IO_APIC case
git-bisect bad 50dd94e017ec39f85c26b6c10ed9fb2d7a7d8042
# bad: [99d093d12897562a253540a902bbf65ec16042ac] x86: use NR_IRQS_LEGACY
git-bisect bad 99d093d12897562a253540a902bbf65ec16042ac
# bad: [0b8f1efad30bd58f89961b82dfe68b9edf8fd2ac] sparse irq_desc[] array: core kernel and x86 changes
git-bisect bad 0b8f1efad30bd58f89961b82dfe68b9edf8fd2ac

The git-bisect points to below commit 

commit 0b8f1efad30bd58f89961b82dfe68b9edf8fd2ac
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 5 18:58:31 2008 -0800

    sparse irq_desc[] array: core kernel and x86 changes
	    
	Impact: new feature

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
