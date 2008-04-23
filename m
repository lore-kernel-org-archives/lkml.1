Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYDWNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYDWNLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYDWNL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:11:26 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34578 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYDWNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:11:24 -0400
Message-ID: <480F356B.8020109@linux.vnet.ibm.com>
Date: Wed, 23 Apr 2008 18:41:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] linux-next: Tree for April 23 - kernel panic during bootup
 on x86_64 and ppc
References: <20080423190248.2f21b33f.sfr@canb.auug.org.au>
In-Reply-To: <20080423190248.2f21b33f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080423 kernel panics at various points on x86_64 and ppc machines
I have listed the call trace of ppc machine followed by the trace of x86_64

on ppc box
-----------

kernel BUG at arch/powerpc/lib/locks.c:36!
Oops: Exception in kernel mode, sig: 5 [#43]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c000000000031e34 LR: c0000000004b91bc CTR: 0000000000000000
REGS: c000000042043160 TRAP: 0700   Tainted: G      D   (2.6.25-next-20080423-sched-devel.git-x86-latest.git-autotest)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 44000044  XER: 20000006
TASK = c00000007e030000[1] 'swapper' THREAD: c000000042040000 CPU: 5
GPR00: 0000000000000001 c0000000420433e0 c0000000008245a8 c0000000426ef580 
GPR04: 0000000000000001 0000000000000000 0000000000000000 0000000000000000 
GPR08: c000000041007070 0000000000000001 00000000ffffffff 000000000000ffff 
GPR12: 0000000600000004 c00000000073b900 0000000000000000 c000000042536000 
GPR16: 4000000002100000 c0000000005f8010 0000000000000000 000000000023f000 Re:
GPR20: 00000000027d69c8 c0000000006d69c8 00000000000000a0 c00000007e95c800 
GPR24: c000000042043b10 c000000042043b10 0000000000000000 0000000000000000 
GPR28: c0000000426ef500 c0000000008a5b4c c0000000007c3c90 c0000000426ef580 
NIP [c000000000031e34] .__spin_yield+0x28/0x80
LR [c0000000004b91bc] ._spin_lock+0x5c/0x88
Call Trace:
[c0000000420433e0] [c000000042043b10] 0xc000000042043b10 (unreliable)
[c000000042043450] [c0000000004b91bc] ._spin_lock+0x5c/0x88
[c0000000420434d0] [c0000000000de66c] .get_unused_fd_flags+0x38/0x174
[c000000042043570] [c00000000012a664] .load_elf_binary+0x18c/0x1670
[c0000000420436b0] [c0000000000e62d8] .search_binary_handler+0xf0/0x2e4
[c000000042043760] [c000000000126ab0] .load_script+0x274/0x2a0
[c000000042043890] [c0000000000e62d8] .search_binary_handler+0xf0/0x2e4
[c000000042043940] [c0000000000e7c64] .do_execve+0x180/0x258
[c000000042043a00] [c000000000010714] .sys_execve+0x70/0xac
[c000000042043aa0] [c0000000000086ac] syscall_exit+0x0/0x40
--- Exception: c01 at .kernel_execve+0x8/0x14
    LR = .run_init_process+0x28/0x40
[c000000042043d90] [c0000000000f05e4] .sys_dup+0x2c/0x44 (unreliable)
[c000000042043e10] [c000000000009284] .init_post+0x98/0xf8
[c000000042043ea0] [c0000000006a2dc4] .kernel_init+0x38c/0x3c0
[c000000042043f90] [c000000000025304] .kernel_thread+0x4c/0x68
Instruction dump:
7c0803a6 4e800020 7c0802a6 f8010010 f821ff91 81430000 2faa0000 794b0420 
2b0b007f 419e0054 7c000026 5400d7fe <0b000000> e8029068 79695564 7d290214 
---[ end trace 8640abe69a316dee ]---
Kernel panic - not syncing: Attempted to kill init!
Call Trace:
[c000000042042c80] [c00000000000f9e8] .show_stack+0x70/0x1bc (unreliable)
[c000000042042d30] [c000000000055704] .panic+0x80/0x1b8
[c000000042042dd0] [c00000000005a270] .do_exit+0x8c/0x758
[c000000042042e90] [c000000000023778] .die+0x24c/0x27c
[c000000042042f30] [c000000000023aa8] ._exception+0x88/0x204
[c0000000420430f0] [c000000000004a84] program_check_common+0x104/0x180
--- Exception: 700 at .__spin_yield+0x28/0x80
    LR = ._spin_lock+0x5c/0x88
[c0000000420433e0] [c000000042043b10] 0xc000000042043b10 (unreliable)
[c000000042043450] [c0000000004b91bc] ._spin_lock+0x5c/0x88
[c0000000420434d0] [c0000000000de66c] .get_unused_fd_flags+0x38/0x174
[c000000042043570] [c00000000012a664] .load_elf_binary+0x18c/0x1670
[c0000000420436b0] [c0000000000e62d8] .search_binary_handler+0xf0/0x2e4
[c000000042043760] [c000000000126ab0] .load_script+0x274/0x2a0
[c000000042043890] [c0000000000e62d8] .search_binary_handler+0xf0/0x2e4
[c000000042043940] [c0000000000e7c64] .do_execve+0x180/0x258
[c000000042043a00] [c000000000010714] .sys_execve+0x70/0xac
[c000000042043aa0] [c0000000000086ac] syscall_exit+0x0/0x40
--- Exception: c01 at .kernel_execve+0x8/0x14
    LR = .run_init_process+0x28/0x40
[c000000042043d90] [c0000000000f05e4] .sys_dup+0x2c/0x44 (unreliable)
[c000000042043e10] [c000000000009284] .init_post+0x98/0xf8
[c000000042043ea0] [c0000000006a2dc4] .kernel_init+0x38c/0x3c0
[c000000042043f90] [c000000000025304] .kernel_thread+0x4c/0x68

Pid: 21, comm: khelper Not tainted 2.6.25-next-20080423-sched-devel.git-x86-latest.git-autotest #1
RIP: 0010:[<ffffffff804eaa77>]  [<ffffffff804eaa77>] _cond_resched+0xc/0x38
RSP: 0000:ffff81003fa9beb0  EFLAGS: 00010202
RAX: 0000000000000075 RBX: ffff81003fa8e630 RCX: ffff81003fa9bee0
RDX: ffff81003fa8e7c8 RSI: ffff81003fa9a010 RDI: 0000000000000003
RBP: ffff81003fa9beb0 R08: 0000000000000000 R09: ffff810001026458
R10: ffff81003fa8e630 R11: 0000000300000000 R12: 0000000000000000
R13: ffff81003fa8e758 R14: ffffffff807e9420 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff81003f9a0800(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khelper (pid: 21, threadinfo ffff81003fa9a000, task ffff81003fa8e630)
Stack:  ffff81003fa8e630 ffffffff80249cd9 ffff81003fa9bda8 ffff81003fa8e630
 ffff81003f9c6000 ffffffff80238a93 ffff81003fa9bee0 ffff81003fa9bee0
 ffffffff80646d40 0000000000000000 ffff81003f9a5120 0000000000000000
Call Trace:
 [<ffffffff80249cd9>] switch_task_namespaces+0x20/0x54
 [<ffffffff80238a93>] ? do_exit+0x4d3/0x661
 [<ffffffff80243e58>] ? request_module+0x0/0x15c
 [<ffffffff802439f7>] ? __call_usermodehelper+0x0/0x60
 [<ffffffff8020cda8>] ? child_rip+0xa/0x12
 [<ffffffff802439f7>] ? __call_usermodehelper+0x0/0x60
 [<ffffffff80243cfd>] ? ____call_usermodehelper+0x0/0x15b
 [<ffffffff8020cd9e>] ? child_rip+0x0/0x12


Code: 33 00 01 75 16 e8 98 f8 d4 ff e8 91 70 d4 ff e8 f2 f4 d4 ff b8 01 00 00 00 eb 02 31 c0 c9 c3 55 48 89 e5 e8 74 e3 d3 ff 83 c0 74 <27> 65 48 8b 04 25 10 00 00 00 f6 80 47 e0 ff ff 10 75 15 83 3d 

on x86_64
----------

RIP  [<ffffffff804eaa77>] _cond_resched+0xc/0x38
 RSP <ffff81003fa9beb0>
invalid opcode: 0000 [2] <4>---[ end trace ca143223eefdc828 ]---
Fixing recursive fault but reboot is needed!
SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Tainted: G      D  2.6.25-next-20080423-sched-devel.git-x86-latest.git-autotest #1
RIP: 0010:[<ffffffff804eaa77>]  [<ffffffff804eaa77>] _cond_resched+0xc/0x38
RSP: 0000:ffff81003f9c9e30  EFLAGS: 00010206
RAX: 0000000000000074 RBX: ffffffff806415a0 RCX: 0000000000000000
RDX: 0000000000001312 RSI: ffff81003f9c8010 RDI: 0000000000000003
RBP: ffff81003f9c9e30 R08: 00000000000003c0 R09: 7fffffffffffffff
R10: ffff8100010193c0 R11: 0000000300000000 R12: 00000000fffffff4
R13: ffff81003f9a6500 R14: ffffffff807e9420 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80688000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f9c8000, task ffff81003f9c6000)
Stack:  ffff81003f9c9e80 ffffffff804eb062 000000133f9b60e0 ffffffff80653e00
 ffff81003f9a6500 ffffffff802d8e28 ffff81003f9a6500 ffffffff80653e00
 ffff81003f9a6550 ffffffff802d897e ffff81003f9a6500 0000000000000000
Call Trace:
 [<ffffffff804eb062>] mutex_lock+0x1e/0x2f
 [<ffffffff802d8e28>] ? sysfs_addrm_start+0x26/0x9a
 [<ffffffff802d897e>] ? sysfs_add_file_mode+0x43/0x74
 [<ffffffff807dd223>] ? cpu_dev_init+0x2c/0x79
 [<ffffffff807c08bb>] ? kernel_init+0x10a/0x2d9
 [<ffffffff804ebd6d>] ? _spin_unlock_irq+0x9/0xd
 [<ffffffff80230d5d>] ? finish_task_switch+0x5f/0x86
 [<ffffffff8020cda8>] ? child_rip+0xa/0x12
 [<ffffffff807c07b1>] ? kernel_init+0x0/0x2d9
 [<ffffffff8020cd9e>] ? child_rip+0x0/0x12


Code: 33 00 01 75 16 e8 98 f8 d4 ff e8 91 70 d4 ff e8 f2 f4 d4 ff b8 01 00 00 00 eb 02 31 c0 c9 c3 55 48 89 e5 e8 74 e3 d3 ff 83 c0 74 <27> 65 48 8b 04 25 10 00 00 00 f6 80 47 e0 ff ff 10 75 15 83 3d 
RIP  [<ffffffff804eaa77>] _cond_resched+0xc/0x38
 RSP <ffff81003f9c9e30>
---[ end trace ca143223eefdc828 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D  2.6.25-next-20080423-sched-devel.git-x86-latest.git-autotest #1

Call Trace:
 [<ffffffff80235624>] panic+0x86/0x146
 [<ffffffff8023611c>] printk+0x4e/0x56
 [<ffffffff80238631>] do_exit+0x71/0x661
 [<ffffffff804ec331>] oops_begin+0x0/0x8c
 [<ffffffff8020e224>] do_invalid_op+0x87/0x91
 [<ffffffff804eaa77>] _cond_resched+0xc/0x38
 [<ffffffff804ebd6d>] _spin_unlock_irq+0x9/0xd
 [<ffffffff8022bd23>] __wake_up+0x38/0x4e
 [<ffffffff804ebf79>] error_exit+0x0/0x51
 [<ffffffff804eaa77>] _cond_resched+0xc/0x38
 [<ffffffff804eb062>] mutex_lock+0x1e/0x2f
 [<ffffffff802d8e28>] sysfs_addrm_start+0x26/0x9a
 [<ffffffff802d897e>] sysfs_add_file_mode+0x43/0x74
 [<ffffffff807dd223>] cpu_dev_init+0x2c/0x79
 [<ffffffff807c08bb>] kernel_init+0x10a/0x2d9
 [<ffffffff804ebd6d>] _spin_unlock_irq+0x9/0xd
 [<ffffffff80230d5d>] finish_task_switch+0x5f/0x86
 [<ffffffff8020cda8>] child_rip+0xa/0x12
 [<ffffffff807c07b1>] kernel_init+0x0/0x2d9
 [<ffffffff8020cd9e>] child_rip+0x0/0x12
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
