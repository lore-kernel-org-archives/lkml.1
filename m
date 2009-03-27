Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZC0NvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZC0NvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZC0Nuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:50:51 -0400
Received: from main.gmane.org ([80.91.229.2]:45028 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbZC0Nut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:50:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philippe Reynes <philippe.reynes@isismpp.fr>
Subject: Re: [Announce] 2.6.29-rt1
Date: Fri, 27 Mar 2009 13:50:34 +0000 (UTC)
Message-ID: <gqilj9$c27$2@ger.gmane.org>
References: <49b7c2350903260354p6eaf50ebo87985dcfb8d48ba0@mail.gmail.com>
	<gqi6oc$1s3$1@ger.gmane.org> <gqic7t$c27$1@ger.gmane.org>
	<alpine.LFD.2.00.0903271236270.3397@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: extranet.isismpp.fr
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've activated ftrace, and I've got this trace :




Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c0095fd0 LR: c0095f18 CTR: c03f402c
REGS: ddcb7b50 TRAP: 0700   Not tainted  (2.6.29-rt1)
MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24042088  XER: 00000000
TASK = df89c4c0[901] 'IRQ-16' THREAD: ddcb6000
GPR00: 00000001 ddcb7c00 df89c4c0 df803e24 df803e10 df803e08 00000000 
ddc8b020 
GPR08: 00000000 0000001b df89c4c0 ddcb7c00 4224a620 100a0878 c052bb94 
00200200 
GPR16: 00100100 c058aed8 c058aedc ddcb7c08 c0590000 c0590000 c052bb54 
00000020 
GPR24: ddcb7c78 00000010 df80ae00 00000000 df816800 00000000 df803e00 
ddcb7c00 
NIP [c0095fd0] cache_alloc_refill+0x194/0x644
LR [c0095f18] cache_alloc_refill+0xdc/0x644
Call Trace:
[ddcb7c00] [c0095f18] cache_alloc_refill+0xdc/0x644 (unreliable)
[ddcb7c70] [c009670c] kmem_cache_alloc+0x80/0x1d4
[ddcb7cb0] [c003456c] __sigqueue_do_alloc+0xb0/0xfc
[ddcb7cd0] [c0034b4c] send_signal+0x128/0x2a8
[ddcb7d00] [c00350d0] __group_send_sig_info+0x2c/0x34
[ddcb7d10] [c0035140] group_send_sig_info+0x68/0x84
[ddcb7d40] [c00351c0] __kill_pgrp_info+0x64/0x90
[ddcb7d60] [c003523c] kill_pgrp+0x50/0x68
[ddcb7d80] [c025e808] n_tty_receive_buf+0x420/0xe98
[ddcb7e60] [c0262450] flush_to_ldisc+0x10c/0x188
[ddcb7e90] [c0262520] tty_flip_buffer_push+0x54/0x5c
[ddcb7eb0] [c026a814] serial8250_handle_port+0x27c/0x2ac
[ddcb7ef0] [c026a8ac] serial8250_interrupt+0x68/0xd8
[ddcb7f10] [c0057238] handle_IRQ_event+0xe8/0x1d4
[ddcb7f50] [c0057bec] thread_simple_irq+0x7c/0xd8
[ddcb7f80] [c0057d38] do_irqd+0xf0/0x33c
[ddcb7fd0] [c003fd00] kthread+0x5c/0x8c
[ddcb7ff0] [c00131c0] kernel_thread+0x4c/0x68
Instruction dump:
7f87f000 40be0018 80fe0010 38000001 901e0048 7f872000 419e00e8 80070010 
813a001c 7c090010 38000000 7c000114 <0f000000> 38190001 38c7001c 7c0903a6 
---[ end trace b6da798bf0ad8dcb ]---
------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:806!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c03f3b64 LR: c03f41d0 CTR: c03f3af4
REGS: ddcb7890 TRAP: 0700   Tainted: G      D     (2.6.29-rt1)
MSR: 00021032 <ME,CE,IR,DR>  CR: 84042028  XER: 20000000
TASK = df89c4c0[901] 'IRQ-16' THREAD: ddcb6000
GPR00: 00000001 ddcb7940 df89c4c0 c055e748 00000000 00001032 00000000 
00004000 
GPR08: df89c4c0 00000001 df89c4c0 ddcb6000 4c592aa0 100a0878 c052bb94 
00200200 
GPR16: 00100100 c058aed8 c058aedc ddcb7c08 c0590000 c0590000 c052bb54 
00000020 
GPR24: 00000001 00000010 ddcb7a38 df89c4c0 c055e748 00000005 ddcb6000 
ddcb7940 
NIP [c03f3b64] rt_spin_lock_slowlock+0x7c/0x284
LR [c03f41d0] __rt_spin_lock+0x7c/0x84
Call Trace:
[ddcb7940] [00001032] 0x1032 (unreliable)
[ddcb79b0] [c03f41d0] __rt_spin_lock+0x7c/0x84
[ddcb79c0] [c03f4440] rt_write_lock+0x28/0x30
[ddcb79d0] [c002a3a4] do_exit+0x208/0x710
[ddcb7a10] [c0010e18] kernel_bad_stack+0x0/0x54
[ddcb7a30] [c0011010] _exception+0x68/0x174
[ddcb7b20] [c0011838] program_check_exception+0x520/0x530
[ddcb7b40] [c00139e8] ret_from_except_full+0x0/0x4c
--- Exception: 700 at cache_alloc_refill+0x194/0x644
    LR = cache_alloc_refill+0xdc/0x644
[ddcb7c70] [c009670c] kmem_cache_alloc+0x80/0x1d4
[ddcb7cb0] [c003456c] __sigqueue_do_alloc+0xb0/0xfc
[ddcb7cd0] [c0034b4c] send_signal+0x128/0x2a8
[ddcb7d00] [c00350d0] __group_send_sig_info+0x2c/0x34
[ddcb7d10] [c0035140] group_send_sig_info+0x68/0x84
[ddcb7d40] [c00351c0] __kill_pgrp_info+0x64/0x90
[ddcb7d60] [c003523c] kill_pgrp+0x50/0x68
[ddcb7d80] [c025e808] n_tty_receive_buf+0x420/0xe98
[ddcb7e60] [c0262450] flush_to_ldisc+0x10c/0x188
[ddcb7e90] [c0262520] tty_flip_buffer_push+0x54/0x5c
[ddcb7eb0] [c026a814] serial8250_handle_port+0x27c/0x2ac
[ddcb7ef0] [c026a8ac] serial8250_interrupt+0x68/0xd8
[ddcb7f10] [c0057238] handle_IRQ_event+0xe8/0x1d4
[ddcb7f50] [c0057bec] thread_simple_irq+0x7c/0xd8
[ddcb7f80] [c0057d38] do_irqd+0xf0/0x33c
[ddcb7fd0] [c003fd00] kthread+0x5c/0x8c
[ddcb7ff0] [c00131c0] kernel_thread+0x4c/0x68
Instruction dump:
2f800000 40be0018 39230008 907c0004 907c0000 91290004 91230008 801c0010 
5400003a 7c001278 7c000034 5400d97e <0f000000> 81420000 69490002 3129ffff 
---[ end trace b6da798bf0ad8dcc ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: IRQ-16/0x00000001/901, CPU#0
Modules linked in:
Call Trace:
[ddcb7680] [c000840c] show_stack+0xa4/0x158 (unreliable)
[ddcb76c0] [c00084f0] dump_stack+0x30/0x38
[ddcb76d0] [c00206f0] __schedule_bug+0x6c/0x74
[ddcb76e0] [c03f2050] __schedule+0x68/0x3c4
[ddcb7700] [c03f2668] schedule+0x34/0x54
[ddcb7710] [c002a254] do_exit+0xb8/0x710
[ddcb7750] [c0010e18] kernel_bad_stack+0x0/0x54
[ddcb7770] [c0011010] _exception+0x68/0x174
[ddcb7860] [c0011838] program_check_exception+0x520/0x530
[ddcb7880] [c00139e8] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x7c/0x284
    LR = __rt_spin_lock+0x7c/0x84
[ddcb7940] [00001032] 0x1032 (unreliable)
[ddcb79b0] [c03f41d0] __rt_spin_lock+0x7c/0x84
[ddcb79c0] [c03f4440] rt_write_lock+0x28/0x30
[ddcb79d0] [c002a3a4] do_exit+0x208/0x710
[ddcb7a10] [c0010e18] kernel_bad_stack+0x0/0x54
[ddcb7a30] [c0011010] _exception+0x68/0x174
[ddcb7b20] [c0011838] program_check_exception+0x520/0x530
[ddcb7b40] [c00139e8] ret_from_except_full+0x0/0x4c
--- Exception: 700 at cache_alloc_refill+0x194/0x644
    LR = cache_alloc_refill+0xdc/0x644
[ddcb7c70] [c009670c] kmem_cache_alloc+0x80/0x1d4
[ddcb7cb0] [c003456c] __sigqueue_do_alloc+0xb0/0xfc
[ddcb7cd0] [c0034b4c] send_signal+0x128/0x2a8
[ddcb7d00] [c00350d0] __group_send_sig_info+0x2c/0x34
[ddcb7d10] [c0035140] group_send_sig_info+0x68/0x84
[ddcb7d40] [c00351c0] __kill_pgrp_info+0x64/0x90
[ddcb7d60] [c003523c] kill_pgrp+0x50/0x68
[ddcb7d80] [c025e808] n_tty_receive_buf+0x420/0xe98
[ddcb7e60] [c0262450] flush_to_ldisc+0x10c/0x188
[ddcb7e90] [c0262520] tty_flip_buffer_push+0x54/0x5c
[ddcb7eb0] [c026a814] serial8250_handle_port+0x27c/0x2ac
[ddcb7ef0] [c026a8ac] serial8250_interrupt+0x68/0xd8
[ddcb7f10] [c0057238] handle_IRQ_event+0xe8/0x1d4
[ddcb7f50] [c0057bec] thread_simple_irq+0x7c/0xd8
[ddcb7f80] [c0057d38] do_irqd+0xf0/0x33c
[ddcb7fd0] [c003fd00] kthread+0x5c/0x8c
[ddcb7ff0] [c00131c0] kernel_thread+0x4c/0x68






Le Fri, 27 Mar 2009 13:04:14 +0100, Thomas Gleixner a écrit :

> On Fri, 27 Mar 2009, Philippe Reynes wrote:
> 
>> Hi all
>> 
>> I've tried to remove the mlockall(MCL_CURRENT|MCL_FUTURE) and now, the
>> kernel don't crash. But a data corruption appear in the data saved by
>> the application. Such corruption never occurs with other kernel (2.6.28
>> and 2.6.29). I'll investigate if it could be an application bug.
> 
> I don't think that mlockall or the application is the culprit. The bug
> happens in the middle of the slab cache code.
> 
>> > server calling Oops: Exception in kernel mode, sig: 5 [#1] PREEMPT
>> > MPC837x RR605
>> > Modules linked in:
>> > NIP: c0075b08 LR: c0075a50 CTR: c00d7d90 REGS: dbb6dcb0 TRAP: 0700  
>> > Not tainted  (2.6.29-rt1) MSR: 00029032 <EE,ME,CE,IR,DR>  CR:
>> > 24002488  XER: 00000000 TASK = dddea1e0[1769] 'vsftpd' THREAD:
>> > dbb6c000 GPR00: 00000001 dbb6dd60 dddea1e0 df803e24 df803e10 df803e08
>> > 00000000 ddc72020 GPR08: 00000000 0000001b dddea1e0 df803e24 24000482
>> > 100bf094 00000000 c04aa6fc
>> > GPR16: 00200200 00100100 c04e5958 c04e595c dbb6dd68 c04e0000 c04e0000
>> > c04aa6bc
>> > GPR24: 00000020 dbb6ddd8 00000010 df80ae00 00000000 dbb6de38 df816800
>> > df803e00
>> > NIP [c0075b08] cache_alloc_refill+0x180/0x62c
> 
> addr2line -e vmlinux c0075b08
> linux-2.6.29/mm/slab.c:3150
> 
> That's BUG_ON(slabp->inuse >= cachep->num);
> 
>> > LR [c0075a50] cache_alloc_refill+0xc8/0x62c Call Trace:
>> > [dbb6dd60] [c038878c] preempt_schedule_irq+0x5c/0x80 (unreliable)
> 
> Hmm. This one is interesting. Might be we got preempted here - which
> should be fine, but who knows what we missed when we reworked the
> locking.
> 
> Thanks,
> 
> 	tglx


