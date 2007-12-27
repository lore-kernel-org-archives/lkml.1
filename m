Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbXL0Iuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbXL0Iuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXL0IuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:50:16 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37276 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXL0IuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:50:13 -0500
Message-ID: <47736732.7040400@linux.vnet.ibm.com>
Date: Thu, 27 Dec 2007 14:19:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc6-mm1 Kernel panics at different functions ()
References: <20071222233056.d652743e.akpm@linux-foundation.org>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.24-rc6-mm1 kernel with hotfix x86-fix-system-gate-related-crash.patch applied
panics while booting on a x86_64 box

Unable to handle kernel NULL pointer dereference at 0000000000000046 RIP: 
 [<ffffffff80369a0b>] rb_erase+0xe7/0x2a3
PGD 17ff65067 PUD 17f1c7067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
CPU 0 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.24-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff80369a0b>]  [<ffffffff80369a0b>] rb_erase+0xe7/0x2a3
RSP: 0000:ffffffff80650e00  EFLAGS: 00010002
RAX: ffff8101fe9568c8 RBX: ffff8100010062a8 RCX: ffff8101fe9568b0
RDX: ffff8101fe9568c8 RSI: 0000000000000046 RDI: 0000000000000000
RBP: ffffffff80650e10 R08: ffff8101fe9568c8 R09: 0000000000000086
R10: 0000000000000000 R11: 00000000000001e8 R12: ffff8100010062b8
R13: 0000000000000002 R14: ffff810001006260 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff805dc000(0000) knlGS:00000000f31ffbb0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000046 CR3: 000000017f0ab000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805a2080)
Stack:  ffff8100010062a8 ffff8101fe9568b0 ffffffff80650e40 ffffffff8024be16
 ffffffff80369d65 ffffffff80369d65 ffff8101fe9568b0 ffff8100010062a8
 ffffffff80650eb0 ffffffff8024c1d5 ffffffffb88cc28e 0000000006e73eff
Call Trace:
 <IRQ>  [<ffffffff8024be16>] __remove_hrtimer+0x2e/0x3c
 [<ffffffff80369d65>] __down_read_trylock+0x16/0x42
 [<ffffffff80369d65>] __down_read_trylock+0x16/0x42
 [<ffffffff8024c1d5>] hrtimer_run_queues+0x130/0x191
 [<ffffffff8023fd09>] run_timer_softirq+0x28/0x1a7
 [<ffffffff8023c018>] __do_softirq+0x55/0xc2
 [<ffffffff8020c73c>] call_softirq+0x1c/0x28
 [<ffffffff8020e719>] do_softirq+0x32/0x9d
 [<ffffffff8023c0dd>] irq_exit+0x3f/0x41
 [<ffffffff8021ff85>] smp_apic_timer_interrupt+0x92/0xa7
 [<ffffffff8020c1e6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff802095f5>] default_idle+0x36/0x5e
 [<ffffffff802095f0>] default_idle+0x31/0x5e
 [<ffffffff802095bf>] default_idle+0x0/0x5e
 [<ffffffff802096b6>] cpu_idle+0x90/0xb2
 [<ffffffff804b0126>] rest_init+0x5a/0x5c
 [<ffffffff806017ee>] start_kernel+0x2b8/0x2c4
 [<ffffffff8060112b>] _sinittext+0x12b/0x132


Code: 48 8b 06 83 e0 03 4c 09 c0 48 89 06 4d 85 c0 74 12 49 39 48 
RIP  [<ffffffff80369a0b>] rb_erase+0xe7/0x2a3
 RSP <ffffffff80650e00>
CR2: 0000000000000046

The gdb for the above panic

(gdb) l *0xffffffff80369a0b
0xffffffff80369a0b is in rb_erase (include/linux/rbtree.h:125).
120     #define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
121     #define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
122
123     static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
124     {
125             rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
126     }
127     static inline void rb_set_color(struct rb_node *rb, int color)
128     {
129             rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;


And when i tried rebooting again, i got the following traces one after the another
continuous in the second boot up 

Unable to handle kernel paging request at 000000000000407f RIP: 
 [<ffffffff804b2bd3>] _spin_lock_irqsave+0xc/0x1d
PGD 1ff102067 PUD ffff8101fe6e4000 
Oops: 0002 [1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
CPU 3 
Modules linked in:
Pid: 16511, comm: ,@ Tainted: G   M    2.6.24-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff804b2bd3>]  [<ffffffff804b2bd3>] _spin_lock_irqsave+0xc/0x1d
RSP: 0000:ffff8101fe6e4178  EFLAGS: 00010046
RAX: 0000000000000046 RBX: 000000000000407b RCX: 0000000000000001
RDX: 0000000000000100 RSI: 0000000000000002 RDI: 000000000000407f
RBP: ffff8101fe6e4178 R08: 0000000000000001 R09: ffff8101fe6e43e0
R10: 0000000000000000 R11: 0000000000000008 R12: 0000000000000000
R13: 0000000000000002 R14: ffff8101fe6e4000 R15: ffff8101fe6e4298
FS:  0000000000000000(0000) GS:ffff8101fff13000(0063) knlGS:00000000f7d4a080
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 000000000000407f CR3: 00000001ff1f2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ,@ (pid: 16511, threadinfo 00000000ffffffff, task ffff8101fe6e4000)
Stack:  ffff8101fe6e4198 ffffffff80369d65 000000000000407b 000000000000407f
 ffff8101fe6e41a8 ffffffff8024c599 ffff8101fe6e4288 ffffffff8022473a
 0000000000000000 0000000000000000 0000000000000000 000000000000401b
Call Trace:


Code: f0 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c9 c3 55 48 89 
RIP  [<ffffffff804b2bd3>] _spin_lock_irqsave+0xc/0x1d
 RSP <ffff8101fe6e4178>
CR2: 000000000000407f

0xffffffff804b2bd3 is in _spin_lock_irqsave (include/asm/spinlock.h:75).
70               * and should be optimal for the uncontended case. Note the tail must
71               * be in the high byte, otherwise the 16-bit wide increment of the low
72               * byte would carry up and contaminate the high byte.
73               */
74
75              __asm__ __volatile__ (
76                      LOCK_PREFIX "xaddw %w0, %1\n"
77                      "1:\t"
78                      "cmpb %h0, %b0\n\t"
79                      "je 2f\n\t"

PGD 0 
Oops: 0000 [3] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G   M  D 2.6.24-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff80369c2b>]  [<ffffffff80369c2b>] rb_next+0x1e/0x4f
RSP: 0000:ffff81017ff3be10  EFLAGS: 00010002
RAX: 0000000000000002 RBX: ffff8101000332a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8101000332a8 RDI: 0000000000000002
RBP: ffff81017ff3be10 R08: 00000000000001e8 R09: 0000000000000086
R10: 0000000000000001 R11: 00000000000001e8 R12: ffff8101fe71dec8
R13: 0000000000000002 R14: ffff810100033260 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff81017ff0e000(0000) knlGS:00000000f7ea3b80
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000012 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff8100e3b4a000, task ffff81007ff6c000)
Stack:  ffff81017ff3be40 ffffffff8024be06 000000008020bb29 000000008020bb29
 ffff8101fe71dec8 ffff8101000332a8 ffff81017ff3beb0 ffffffff8024c1d5
 ffffffffb88cc1cc 000000000848661b ffffffffb88cc1cc 000000000848661b
Call Trace:
 <IRQ>  [<ffffffff8024be06>] __remove_hrtimer+0x1e/0x3c
 [<ffffffff8024c1d5>] hrtimer_run_queues+0x130/0x191
 [<ffffffff8023fd09>] run_timer_softirq+0x28/0x1a7
 [<ffffffff8023c018>] __do_softirq+0x55/0xc2
 [<ffffffff8020c73c>] call_softirq+0x1c/0x28
 [<ffffffff8020e719>] do_softirq+0x32/0x9d
 [<ffffffff8023c0dd>] irq_exit+0x3f/0x41
 [<ffffffff8021ff85>] smp_apic_timer_interrupt+0x92/0xa7
 [<ffffffff8020c1e6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff802095f5>] default_idle+0x36/0x5e
 [<ffffffff802095f0>] default_idle+0x31/0x5e
 [<ffffffff802095bf>] default_idle+0x0/0x5e
 [<ffffffff802096b6>] cpu_idle+0x90/0xb2
 [<ffffffff8021f0c1>] start_secondary+0x3ad/0x3b9


Code: 48 83 7f 10 00 74 06 48 8b 7f 10 eb f3 48 89 f8 eb 1d 48 89 
RIP  [<ffffffff80369c2b>] rb_next+0x1e/0x4f
 RSP <ffff81017ff3be10>
CR2: 0000000000000012


0xffffffff80369c2b is in rb_next (lib/rbtree.c:333).
328             /* If we have a right-hand child, go down and then left as far
329                as we can. */
330             if (node->rb_right) {
331                     node = node->rb_right; 
332                     while (node->rb_left)
333                             node=node->rb_left;
334                     return node;
335             }
336
337             /* No right-hand children.  Everything down and left is

Unable to handle kernel paging request at 000000008020bb81 RIP: 
 [<ffffffff80242abd>] exit_signals+0x27/0x10a
PGD 1ff102067 PUD 0 
Oops: 0000 [5] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
CPU 3 
Modules linked in:
Pid: 16511, comm: ,@ Tainted: G   M  D 2.6.24-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff80242abd>]  [<ffffffff80242abd>] exit_signals+0x27/0x10a
RSP: 0000:ffff8101fe6e3cf8  EFLAGS: 00010003
RAX: 000000008020bb29 RBX: 0000000000000046 RCX: 00000000ffffffff
RDX: ffff8101fe6e4000 RSI: 0000000000000000 RDI: ffff8101fe6e4000
RBP: ffff8101fe6e3d18 R08: 0000000000000000 R09: ffffffff80662540
R10: ffffffff80662540 R11: ffff810004ab9740 R12: ffff8101fe6e4000
R13: 0000000000000000 R14: ffff8101fe6e4000 R15: ffff8101fe6e3e88
FS:  0000000000000000(0000) GS:ffff8101fff13000(0063) knlGS:00000000f7d4a080
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 000000008020bb81 CR3: 00000001ff1f2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ,@ (pid: 16511, threadinfo 00000000ffffffff, task ffff8101fe6e4000)
Stack:  ffff8101fe6e4000 0000000000000046 ffff8101fe6e4000 0000000000000009
 ffff8101fe6e3d68 ffffffff80239b8c ffff8101fe6e3d48 ffffffff803c241d
 0000000000000046 0000000000000046 ffff8101fe6e3e88 0000000000000009
Call Trace:


Code: f6 40 58 08 75 07 48 83 78 48 00 74 0b 41 83 4c 24 14 04 e9 
RIP  [<ffffffff80242abd>] exit_signals+0x27/0x10a
 RSP <ffff8101fe6e3cf8>
CR2: 000000008020bb81

0xffffffff80242abd is in exit_signals (include/linux/sched.h:555).
550     #define SIGNAL_GROUP_EXIT       0x00000008 /* group exit in progress */
551
552     /* If true, all threads except ->group_exit_task have pending SIGKILL */
553     static inline int signal_group_exit(const struct signal_struct *sig)
554     {
555             return  (sig->flags & SIGNAL_GROUP_EXIT) ||
556                     (sig->group_exit_task != NULL);
557     }
558
559     /*

 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
