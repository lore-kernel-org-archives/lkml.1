Return-Path: <linux-kernel-owner+w=401wt.eu-S940041AbXGaDf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940041AbXGaDf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbXGaDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:35:48 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:51556 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbXGaDfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:35:46 -0400
Subject: [Fwd: [PlanetCCRMA] atl1 driver; sleeping function]
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Matt Barber <brbrofsvl@gmail.com>,
       nando@ccrma.Stanford.EDU
Content-Type: text/plain
Date: Mon, 30 Jul 2007 20:35:42 -0700
Message-Id: <1185852942.32478.3.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, I'm forwading this report from a Planet CCRMA user, this is
happening to him with 2.6.21.6-rt21...

-- Fernando

-------- Forwarded Message --------
From: Matt Barber
To: planetccrma@ccrma.Stanford.EDU
Subject: [PlanetCCRMA] atl1 driver; sleeping function
Date: Mon, 30 Jul 2007 06:09:58 -0400

Hello,

I'm getting a set of BUG messages in my dmesg with the newest ccrma
kernel.  This is a new box, so I haven't tried the older ccrma
kernels, but the bugs aren't there with Fedora stock.  They look like
this (probably at least a hundred more by now):

BUG: sleeping function called from invalid context IRQ-219(2243) at
kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d289a>] tcp_send_ack+0xeb/0xef
 [<c05d1617>] tcp_rcv_established+0x52a/0x7ff
 [<c05d7234>] tcp_v4_do_rcv+0x1bf/0x494
 [<c05d9955>] tcp_v4_rcv+0x863/0x8d6
 [<c05bff3a>] ip_local_deliver+0x18f/0x23d
 [<c05bfd72>] ip_rcv+0x41d/0x456
 [<c05a3991>] netif_receive_skb+0x2cc/0x35e
 [<c05a524a>] process_backlog+0x76/0xc9
 [<c05a5419>] net_rx_action+0xa7/0x1a5
 [<c042e276>] ___do_softirq+0xfe/0x214
 [<c042e6a6>] do_softirq_from_hardirq+0x48/0x61
 [<c0459204>] do_irqd+0x21a/0x282
 [<c043ad18>] kthread+0xb0/0xd8
 [<c0405bbf>] kernel_thread_helper+0x7/0x10
 =======================
printk: 6 messages suppressed.
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]
BUG: sleeping function called from invalid context firefox-bin(17517)
at kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d41ad>] tcp_push_one+0xb3/0xd8
 [<c05c9f92>] tcp_sendmsg+0x7c8/0x9f9
 [<c05e2ce1>] inet_sendmsg+0x3b/0x45
 [<c059a86a>] sock_sendmsg+0xd0/0xeb
 [<c059b1bf>] sys_sendto+0x11b/0x13b
 [<c059b216>] sys_send+0x37/0x3b
 [<c059bb9e>] sys_socketcall+0x14a/0x261
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fd8410>] 0xb7fd8410
 =======================
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]
BUG: sleeping function called from invalid context IRQ-219(2243) at
kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d289a>] tcp_send_ack+0xeb/0xef
 [<c05d1617>] tcp_rcv_established+0x52a/0x7ff
 [<c05d7234>] tcp_v4_do_rcv+0x1bf/0x494
 [<c05d9955>] tcp_v4_rcv+0x863/0x8d6
 [<c05bff3a>] ip_local_deliver+0x18f/0x23d
 [<c05bfd72>] ip_rcv+0x41d/0x456
 [<c05a3991>] netif_receive_skb+0x2cc/0x35e
 [<c05a524a>] process_backlog+0x76/0xc9
 [<c05a5419>] net_rx_action+0xa7/0x1a5
 [<c042e276>] ___do_softirq+0xfe/0x214
 [<c042e6a6>] do_softirq_from_hardirq+0x48/0x61
 [<c0459204>] do_irqd+0x21a/0x282
 [<c043ad18>] kthread+0xb0/0xd8
 [<c0405bbf>] kernel_thread_helper+0x7/0x10
 =======================
printk: 14 messages suppressed.
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]
BUG: sleeping function called from invalid context firefox-bin(17517)
at kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d41ad>] tcp_push_one+0xb3/0xd8
 [<c05c9f92>] tcp_sendmsg+0x7c8/0x9f9
 [<c05e2ce1>] inet_sendmsg+0x3b/0x45
 [<c059a86a>] sock_sendmsg+0xd0/0xeb
 [<c059b1bf>] sys_sendto+0x11b/0x13b
 [<c059b216>] sys_send+0x37/0x3b
 [<c059bb9e>] sys_socketcall+0x14a/0x261
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fd8410>] 0xb7fd8410
 =======================
BUG: sleeping function called from invalid context IRQ-219(2243) at
kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d4037>] __tcp_push_pending_frames+0x6ec/0x7af
 [<c05d11f4>] tcp_rcv_established+0x107/0x7ff
 [<c05d7234>] tcp_v4_do_rcv+0x1bf/0x494
 [<c05d9955>] tcp_v4_rcv+0x863/0x8d6
 [<c05bff3a>] ip_local_deliver+0x18f/0x23d
 [<c05bfd72>] ip_rcv+0x41d/0x456
 [<c05a3991>] netif_receive_skb+0x2cc/0x35e
 [<c05a524a>] process_backlog+0x76/0xc9
 [<c05a5419>] net_rx_action+0xa7/0x1a5
 [<c042e276>] ___do_softirq+0xfe/0x214
 [<c042e6a6>] do_softirq_from_hardirq+0x48/0x61
 [<c0459204>] do_irqd+0x21a/0x282
 [<c043ad18>] kthread+0xb0/0xd8
 [<c0405bbf>] kernel_thread_helper+0x7/0x10
 =======================
BUG: sleeping function called from invalid context pidgin(21337) at
kernel/rtmutex.c:613
in_atomic():0 [00000000], irqs_disabled():1
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c060511d>] __rt_spin_lock+0x21/0x3d
 [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
 [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
 [<c05b29bd>] __qdisc_run+0xb7/0x1cf
 [<c05a5661>] dev_queue_xmit+0x14a/0x239
 [<c05c4a40>] ip_output+0x207/0x243
 [<c05c41ea>] ip_queue_xmit+0x3b2/0x402
 [<c05d26d7>] tcp_transmit_skb+0x6e5/0x713
 [<c05d4037>] __tcp_push_pending_frames+0x6ec/0x7af
 [<c05ca0cb>] tcp_sendmsg+0x901/0x9f9
 [<c05e2ce1>] inet_sendmsg+0x3b/0x45
 [<c059a86a>] sock_sendmsg+0xd0/0xeb
 [<c059b1bf>] sys_sendto+0x11b/0x13b
 [<c059b216>] sys_send+0x37/0x3b
 [<c059bb9e>] sys_socketcall+0x14a/0x261
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fe3410>] 0xb7fe3410
 =======================
printk: 8 messages suppressed.
network driver disabled raw interrupts: atl1_xmit_frame+0x0/0x6c6 [atl1]


The card in question is

03:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapt
er (rev b0)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8226
        Flags: bus master, fast devsel, latency 0, IRQ 219
        Memory at fe9c0000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at fe9a0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable+
        Capabilities: [58] Express Endpoint IRQ 0
        Capabilities: [6c] Vital Product Data




The corresponding module is

alias eth0 atl1


Searching online, it looks like the atl1 driver has had some problems
in some contexts.  Anyway, I thought I'd pass this along to whom it
may concern.  I don't notice any network or other problems as a user
-- I just happened to notice it in dmesg.

Thanks,

Matt


