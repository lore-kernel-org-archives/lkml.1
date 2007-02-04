Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXBDOzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXBDOzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 09:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXBDOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 09:55:13 -0500
Received: from thccv19.oz.nthu.edu.tw ([140.114.63.219]:34893 "EHLO
	thccv19.oz.nthu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbXBDOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 09:55:12 -0500
From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
To: <linux-kernel@vger.kernel.org>
Subject: Kernel BUG at mm/slab.c:595
Date: Sun, 4 Feb 2007 22:55:19 +0800
Message-ID: <003801c7486c$7d862680$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
thread-index: AcdIbHzAWkIQLTmhROGUB2D4rnDghQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

           I am developing my module, but meet a bug. Is the bug created by
me??

           Kernel:2.6.18  on SUSE10.1 + Intel DualCore

Feb  5 00:57:39 VM-SUSE kernel: ----------- [cut here ] --------- [please
bite here ] ---------

Feb  5 00:57:39 VM-SUSE kernel: Kernel BUG at mm/slab.c:595

Feb  5 00:57:39 VM-SUSE kernel: invalid opcode: 0000 [1] SMP

Feb  5 00:57:39 VM-SUSE kernel: CPU 1

Feb  5 00:57:39 VM-SUSE kernel: Modules linked in: raid0 mymodule
acpi_cpufreq edd freq_table ipv6 button battery ac 

loop d

Feb  5 00:57:39 VM-SUSE kernel: Pid: 3239, comm: read_helper_1 Tainted: GF
2.6.18-yuchen #1

Feb  5 00:57:39 VM-SUSE kernel: RIP: 0010:[<ffffffff8027d4a6>]
[<ffffffff8027d4a6>] kfree+0x5e/0x1bd

Feb  5 00:57:39 VM-SUSE kernel: RSP: 0018:ffff810036d19dd0  EFLAGS: 00010046

Feb  5 00:57:39 VM-SUSE kernel: RAX: 0000000000000000 RBX: 0000000000004000
RCX: 000000000000003f

Feb  5 00:57:39 VM-SUSE kernel: RDX: ffff810000771840 RSI: 0000000000040000
RDI: 00000000000082b8

Feb  5 00:57:39 VM-SUSE kernel: RBP: ffffffff882b8d78 R08: 00000000fffffffc
R09: ffff810036d19ba0

Feb  5 00:57:39 VM-SUSE kernel: R10: 0000000000000001 R11: 0000000000000000
R12: 0000000000000009

Feb  5 00:57:39 VM-SUSE kernel: R13: ffff8100364f74c8 R14: 0000000000000286
R15: 0000000000023000

Feb  5 00:57:39 VM-SUSE kernel: FS:  0000000000000000(0000)
GS:ffff81003fea1ac0(0000) knlGS:0000000000000000

Feb  5 00:57:39 VM-SUSE kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b

Feb  5 00:57:39 VM-SUSE kernel: CR2: 00002afccd5f0795 CR3: 000000003ceaf000
CR4: 00000000000006e0

Feb  5 00:57:39 VM-SUSE kernel: Process read_helper_1 (pid: 3239, threadinfo
ffff810036d18000, task ffff8100017757a0)

Feb  5 00:57:39 VM-SUSE kernel: Stack:  0000000000000246 ffff81003aca7540
0000000000004000 ffff8100364f7400

Feb  5 00:57:39 VM-SUSE kernel:  0000000000000009 ffff8100364f74c8
ffff8100364f7528 ffffffff882b5b0b

Feb  5 00:57:39 VM-SUSE kernel:  0000000000000001 0000002700000020
0000000000626473 ffff8100017757a0

Feb  5 00:57:39 VM-SUSE kernel: Call Trace:

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b5b0b>]
:mymodule:helper_get_info+0x517/0x755

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242c84>]
keventd_create_kthread+0x0/0x61

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b623e>]
:mymodule:thread_func_th1+0x107/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8024307c>]
autoremove_wake_function+0x0/0x2e

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b6137>]
:mymodule:thread_func_th1+0x0/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242f3b>] kthread+0xec/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020a55c>] child_rip+0xa/0x12

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242c84>]
keventd_create_kthread+0x0/0x61

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242e4f>] kthread+0x0/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020a552>] child_rip+0x0/0x12

Feb  5 00:57:39 VM-SUSE kernel:

Feb  5 00:57:39 VM-SUSE kernel:

Feb  5 00:57:39 VM-SUSE kernel: Code: 0f 0b 68 fd 46 40 80 c2 53 02 4c 8b 6a
28 65 8b 04 25 2c 00

Feb  5 00:57:39 VM-SUSE kernel: RIP  [<ffffffff8027d4a6>] kfree+0x5e/0x1bd

Feb  5 00:57:39 VM-SUSE kernel:  RSP <ffff810036d19dd0>

Feb  5 00:57:39 VM-SUSE kernel:  <3>BUG: sleeping function called from
invalid context at kernel/rwsem.c:20

Feb  5 00:57:39 VM-SUSE kernel: in_atomic():0, irqs_disabled():1

Feb  5 00:57:39 VM-SUSE kernel:

Feb  5 00:57:39 VM-SUSE kernel: Call Trace:

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80245819>] down_read+0x15/0x24

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8023d099>]
blocking_notifier_call_chain+0x13/0x36

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff802331d0>] do_exit+0x20/0x8f4

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8033f84e>]
do_unblank_screen+0x2c/0x139

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020ae9a>]
kernel_math_error+0x0/0x90

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020b441>]
do_invalid_op+0xad/0xb7

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8027d4a6>] kfree+0x5e/0x1bd

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff802f1de3>] vsnprintf+0x314/0x595

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020a3a1>] error_exit+0x0/0x84

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8027d4a6>] kfree+0x5e/0x1bd

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b5b0b>]
:mymodule:helper_get_info+0x517/0x755

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242c84>]
keventd_create_kthread+0x0/0x61

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b623e>]
:mymodule:thread_func_th1+0x107/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8024307c>]
autoremove_wake_function+0x0/0x2e

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff882b6137>]
:mymodule:thread_func_th1+0x0/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242f3b>] kthread+0xec/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020a55c>] child_rip+0xa/0x12

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242c84>]
keventd_create_kthread+0x0/0x61

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff80242e4f>] kthread+0x0/0x121

Feb  5 00:57:39 VM-SUSE kernel:  [<ffffffff8020a552>] child_rip+0x0/0x12

Feb  5 00:57:39 VM-SUSE kernel:




