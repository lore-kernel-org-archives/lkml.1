Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYDZLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYDZLWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYDZLWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:22:07 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:60400 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYDZLWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:22:04 -0400
Message-ID: <48131052.2080102@linux.vnet.ibm.com>
Date: Sat, 26 Apr 2008 16:51:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>, apw@shadowen.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.25-git8 Kernel Bug while bootup on ppc and x86
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting the 2.6.25-git8 kernel on the ppc and x86_64 machine, kernel
bug is hit. This was reported in the next-20080423 kernel 
http://lkml.org/lkml/2008/4/23/206.

Call trace of x86_64 machine

BUG: unable to handle kernel paging request at 00000000ffffffff
IP: [<ffffffff802359e5>] put_files_struct+0x25/0x110
PGD 0 
Oops: 0002 [333] SMP 
CPU 3 
Modules linked in:
Pid: 1391, comm: khelper Tainted: G      D  2.6.25-git8-autotest #1
RIP: 0010:[<ffffffff802359e5>]  [<ffffffff802359e5>] put_files_struct+0x25/0x110
RSP: 0000:ffff81090d06bdb0  EFLAGS: 00010282
RAX: 0000000000000101 RBX: fffffffffffffffe RCX: ffff8100010260e0
RDX: 0000000000000007 RSI: 0000000000000001 RDI: 00000000ffffffff
RBP: 00000000fffffffe R08: 2222222222222267 R09: 2222222222222222
R10: 0000000000000010 R11: 2222222222222222 R12: 00000000ffffffff
R13: ffff81032d2e9000 R14: ffff81090e74b000 R15: ffff81061e4cbce0
FS:  0000000000000000(0000) GS:ffff81032e4ae940(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khelper (pid: 1391, threadinfo ffff81090d06a000, task ffff81090d8113a0)
Stack:  ffff81090d8113a0 fffffffffffffffe 00000000fffffffe ffff81032e556e00
 ffff81032d2e9000 ffff81090e74b000 ffff81061e4cbce0 ffffffff80294278
 ffff81090d06be70 ffffffff80636bc0 ffff81090d3646c0 ffff81032d2e9000
Call Trace:
 [<ffffffff80294278>] do_execve+0x108/0x230
 [<ffffffff802098e9>] sys_execve+0x49/0x80
 [<ffffffff8020c417>] kernel_execve+0x67/0xd0
 [<ffffffff8021d060>] physflat_send_IPI_mask+0x0/0xb0
 [<ffffffff802443e9>] ____call_usermodehelper+0x119/0x130
 [<ffffffff8022e577>] schedule_tail+0x27/0x60
 [<ffffffff8020c3a8>] child_rip+0xa/0x12
 [<ffffffff8021d060>] physflat_send_IPI_mask+0x0/0xb0
 [<ffffffff802442d0>] ____call_usermodehelper+0x0/0x130
 [<ffffffff8020c39e>] child_rip+0x0/0x12


Code: 48 83 c4 18 c3 90 48 83 ec 38 4c 89 64 24 18 48 89 5c 24 08 49 89 fc 48 89 6c 24 10 4c 89 6c 24 20 4c 89 74 24 28 4c 89 7c 24 30 <f0> ff 0f 0f 94 c0 84 c0 0f 84 b8 00 00 00 4c 8b 6f 08 31 ed 41 
RIP  [<ffffffff802359e5>] put_files_struct+0x25/0x110
 RSP <ffff81090d06bdb0>
CR2: 00000000ffffffff
---[ end trace ca143223eefdc828 ]---
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 404k freed
input: AT Translated Set 2 keyboard as /class/input/input0
BUG: unable to handle kernel paging request at 000000010000001c
IP: [<ffffffff804dcfc5>] _spin_lock+0x5/0x20
PGD 0 
Oops: 0002 [334] SMP 
CPU 11 
Modules linked in:
Pid: 1, comm: swapper Tainted: G      D  2.6.25-git8-autotest #1
RIP: 0010:[<ffffffff804dcfc5>]  [<ffffffff804dcfc5>] _spin_lock+0x5/0x20
RSP: 0000:ffff81061e4cba08  EFLAGS: 00010282
RAX: 0000000000000100 RBX: ffffffff805bceb7 RCX: 0000000000000000
RDX: ffff81061e4cbfd8 RSI: 0000000000000001 RDI: 000000010000001c
RBP: ffff81061e740b00 R08: 0000000000000000 R09: 000000000000279c
R10: 0000000000000004 R11: 0000000000479490 R12: 00000000ffffff9c
R13: 00000000000001f8 R14: ffff81061e4cbe10 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff81061e57ef40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000010000001c CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81061e4ca000, task ffff81032e4b9710)
Stack:  ffffffff8028c22e ffff81061e740b00 ffffffff805bceb7 ffff81061e740b00
 ffff81032dd2aa00 00000000000001f8 ffff81061e4cbe10 00000000000001f8
 ffffffff802c6de2 0000000000000000 ffffffff8026232e 0000000000000282
Call Trace:
 [<ffffffff8028c22e>] get_unused_fd_flags+0x2e/0x120
 [<ffffffff802c6de2>] load_elf_binary+0x1b2/0x1d40
 [<ffffffff8026232e>] generic_file_aio_read+0x4de/0x560
 [<ffffffff8028e129>] do_sync_read+0xd9/0x120
 [<ffffffff80248110>] autoremove_wake_function+0x0/0x30
 [<ffffffff8028c5f7>] __dentry_open+0x197/0x2b0
 [<ffffffff80297985>] deny_write_access+0x15/0x40
 [<ffffffff80292944>] open_exec+0xa4/0xc0
 [<ffffffff8029258d>] search_binary_handler+0x8d/0x210
 [<ffffffff802c55e6>] load_script+0x266/0x270
 [<ffffffff80292166>] get_arg_page+0x46/0xb0
 [<ffffffff802924a1>] copy_strings+0x1c1/0x1e0
 [<ffffffff8029258d>] search_binary_handler+0x8d/0x210
 [<ffffffff80294352>] do_execve+0x1e2/0x230
 [<ffffffff802098e9>] sys_execve+0x49/0x80
 [<ffffffff8020c417>] kernel_execve+0x67/0xd0
 [<ffffffff80209078>] init_post+0x58/0xf0
 [<ffffffff8020c3a8>] child_rip+0xa/0x12
 [<ffffffff8020c39e>] child_rip+0x0/0x12


Code: 66 66 90 66 66 90 f0 81 2f 00 00 00 01 0f 94 c0 84 c0 ba 01 00 00 00 75 09 f0 81 07 00 00 00 01 30 d2 89 d0 c3 90 b8 00 01 00 00 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 66 90 66 
RIP  [<ffffffff804dcfc5>] _spin_lock+0x5/0x20
 RSP <ffff81061e4cba08>
CR2: 000000010000001c
---[ end trace ca143223eefdc828 ]---


call trace on ppc boxes - machine 1


Unable to handle kernel paging request for data at address 0x00500081
Faulting instruction address: 0xc0000000003bef00
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c0000000003bef00 LR: c0000000000e9974 CTR: 0000000000000000
REGS: c00000007e0731e0 TRAP: 0300   Not tainted  (2.6.25-git8-autotest)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000082  XER: 2000000a
DAR: 0000000000500081, DSISR: 0000000040000000
TASK = c000000009fd3320[1] 'swapper' THREAD: c00000007e070000 CPU: 1
GPR00: 0000000080000001 c00000007e073460 c00000000067b448 0000000000500081 
GPR04: 0000000000000001 0000000000000000 0000000000000000 0000000000000000 
GPR08: c00000007e0730b0 c000000009fd3320 00000000000000a8 c000000009021d80 
GPR12: 0000000600000004 c0000000006af500 0000000000000000 0000000000000000 
GPR16: c00000000980be00 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 c000000009e80400 4000000001c00000 
GPR24: c00000007e073b20 c00000000980be80 0000000000000000 0000000000500001 
GPR28: ffffffffffffffe8 0000000000000080 c00000000062eca0 0000000000500081 
NIP [c0000000003bef00] __lock_text_start+0x20/0x88
LR [c0000000000e9974] .get_unused_fd_flags+0x40/0x184
Call Trace:
[c00000007e0734e0] [c0000000000e9974] .get_unused_fd_flags+0x40/0x184
[c00000007e073580] [c000000000138ecc] .load_elf_binary+0x1c8/0x1878
[c00000007e0736c0] [c0000000000f1a0c] .search_binary_handler+0x104/0x300
[c00000007e073770] [c0000000001356a0] .load_script+0x2c0/0x2ec
[c00000007e0738a0] [c0000000000f1a0c] .search_binary_handler+0x104/0x300
[c00000007e073950] [c0000000000f1dcc] .do_execve+0x1c4/0x2b8
[c00000007e073a10] [c000000000011aa8] .sys_execve+0x78/0xb4
[c00000007e073ab0] [c00000000000872c] syscall_exit+0x0/0x40
--- Exception: c01 at .kernel_execve+0x8/0x14
    LR = .run_init_process+0x28/0x40
[c00000007e073da0] [c0000000000fb108] .sys_dup+0x2c/0x44 (unreliable)
[c00000007e073e20] [c000000000009300] .init_post+0x90/0xf0
[c00000007e073ea0] [c00000000054edfc] .kernel_init+0x38c/0x3c0
[c00000007e073f90] [c000000000028a98] .kernel_thread+0x4c/0x68
Instruction dump:
e8010010 eba1ffe8 7c0803a6 4e800020 7c0802a6 fbe1fff0 7c7f1b78 f8010010 
38000000 f821ff81 980d01dc 800d0008 <7d20f828> 2c090000 40820010 7c00f92d 
---[ end trace 2de3013543283acc ]---


machine 2


Faulting instruction address: 0xc0000000000586f8
Oops: Kernel access of bad area, sig: 11 [#22]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c0000000000586f8 LR: c0000000000e7668 CTR: c0000000001068e8
REGS: c0000000fe237790 TRAP: 0300   Tainted: G      D   (2.6.25-git8-autotest)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000042  XER: 20000006
DAR: 000000007fe3fb78, DSISR: 0000000040000000
TASK = c0000000fe1a6910[120] 'khelper' THREAD: c0000000fe234000 CPU: 2
GPR00: c0000000000e7668 c0000000fe237a10 c0000000008387b8 000000007fe3fb78 
GPR04: cf00000003794408 c0000000fe137000 0000000000000004 0000000000000000 
GPR08: c000000000998eb8 0000000000000000 0000000000000001 c0000000009995a0 
GPR12: 8000000000009032 c000000000874700 0000000000000000 c0000000005fd188 
GPR16: 4000000001c00000 c0000000005fba10 0000000000000000 00000000002b1000 
GPR20: 00000000022d9e68 c0000000006d9e68 00000000022da0d8 c0000000006da0d8 
GPR24: c0000000fe237c80 c0000000fe077bc0 c0000000fe02a000 c0000000fe229000 
GPR28: 000000007fe3fb78 fffffffffffffffe c0000000007b2248 fffffffffffffffe 
NIP [c0000000000586f8] .put_files_struct+0x30/0x13c
LR [c0000000000e7668] .do_execve+0x220/0x258
Call Trace:
[c0000000fe237a10] [c0000000fe237ab0] 0xc0000000fe237ab0 (unreliable)
[c0000000fe237ab0] [c0000000000e7668] .do_execve+0x220/0x258
[c0000000fe237b70] [c00000000001079c] .sys_execve+0x70/0xac
[c0000000fe237c10] [c00000000000872c] syscall_exit+0x0/0x40
--- Exception: c01 at .kernel_execve+0x8/0x14
    LR = .____call_usermodehelper+0x158/0x16c
[c0000000fe237f00] [c00000000006b29c] .____call_usermodehelper+0x144/0x16c (unreliable)
[c0000000fe237f90] [c000000000025218] .kernel_thread+0x4c/0x68
Instruction dump:
7c0802a6 fb81ffe0 fbc1fff0 fb41ffd0 fb61ffd8 fba1ffe8 fbe1fff8 f8010010 
ebc2ad30 f821ff61 7c7c1b78 7c2004ac <7c001828> 3000ffff 7c00192d 40a2fff4 
---[ end trace 8640abe69a316dee ]---
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 1
Unable to handle kernel paging request for data at address 0xbffffffffe02b000
Faulting instruction address: 0xc0000000000d9a64
Oops: Kernel access of bad area, sig: 11 [#23]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c0000000000d9a64 LR: c0000000000d99f4 CTR: 0000000000000000
REGS: c0000000fe0777b0 TRAP: 0300   Tainted: G      D   (2.6.25-git8-autotest)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000042  XER: 20000003
DAR: bffffffffe02b000, DSISR: 0000000040000000
TASK = c0000000fe070000[1] 'swapper' THREAD: c0000000fe074000 CPU: 0
GPR00: 0000000000000000 c0000000fe077a30 c0000000008387b8 c000000000862620 
GPR04: 00000000000080d0 0000000000000000 0000000000000001 0000000000001000 
GPR08: 0000000000000000 c000000000862620 00000000000080d0 c000000000862620 
GPR12: 00000000a6b962e2 c000000000874300 0000000000000000 c0000000005fd188 
GPR16: 4000000001c00000 c0000000005fba10 0000000000000000 00000000002b1000 
GPR20: 00000000022d9e68 c0000000006d9e68 00000000022da0d8 c0000000006da0d8 
GPR24: c0000000005fcbc8 00000000000080d0 c0000000000dda80 0000000000000001 
GPR28: 0000000000000000 c000000000989420 c0000000007b6600 bffffffffe02b000 
NIP [c0000000000d9a64] .__kmalloc_node+0xd4/0x144
LR [c0000000000d99f4] .__kmalloc_node+0x64/0x144
Call Trace:
[c0000000fe077a30] [c0000000fe077ac0] 0xc0000000fe077ac0 (unreliable)
[c0000000fe077ae0] [c0000000000dda80] .percpu_populate+0x90/0xd8
[c0000000fe077b70] [c0000000000ddb18] .__percpu_populate_mask+0x50/0xf4
[c0000000fe077c20] [c0000000000ddc30] .__percpu_alloc_mask+0x74/0x128
[c0000000fe077cc0] [c0000000006d135c] .ip_rt_init+0x60/0x2bc
[c0000000fe077d70] [c0000000006d1830] .ip_init+0x10/0x34
[c0000000fe077df0] [c0000000006d2610] .inet_init+0x164/0x3e4
[c0000000fe077ea0] [c0000000006a5c38] .kernel_init+0x1fc/0x3c0
[c0000000fe077f90] [c000000000025218] .kernel_thread+0x4c/0x68
Instruction dump:
7f80e000 41be0024 7d635b78 7f85e378 7f46d378 7f24cb78 7fa7eb78 4bffe289 
7c7f1b78 48000014 801d0014 78001f24 <7c1f002a> f81d0000 2fbb0000 38600000 
---[ end trace 8640abe69a316dee ]---
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
