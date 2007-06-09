Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXFIU6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXFIU6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbXFIU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:58:33 -0400
Received: from ms4-1.1blu.de ([213.83.63.61]:54948 "EHLO ms4-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbXFIU6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:58:31 -0400
X-Greylist: delayed 2410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 16:58:30 EDT
MIME-Version: 1.0
Date: Sat, 9 Jun 2007 22:18:19 +0200
From: Lukas Razik <linux@razik.name>
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM] sleeping function called from invalid context at mm/slab.c
Message-ID: <346e9b4ab8816bdf04540fe28ed949eb@mb8-2.1blu.de>
User-Agent: 1blu Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Con-Id: 21979
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm new to kernel programming and I try to develop a fake ethernet driver for v2.6.21.3 which I really need based on netdev but I ran into the following issue:
If the kernel calls the 'dev->hard_start_xmit' function of my driver then this calls another one which try to create a socket in the following "normal way":

struct socket *ssock = NULL;
...
sock_create(family, SOCK_STREAM, IPPROTO_TCP, &ssock);

But at this point I get an error message from the kernel as appended below.
So what have I done wrong?

Regards and many thanks for any help!
Lukas


Jun  9 12:02:29 consystor kernel: BUG: sleeping function called from invalid context at mm/slab.c:3032
Jun  9 12:02:29 consystor kernel: in_atomic():1, irqs_disabled():0
Jun  9 12:02:29 consystor kernel:  [<c011b13d>] __might_sleep+0xad/0xc0
Jun  9 12:02:29 consystor kernel:  [<c016a0df>] kmem_cache_alloc+0x6f/0x80
Jun  9 12:02:29 consystor kernel:  [<c02f6930>] sock_alloc_inode+0x10/0x50
Jun  9 12:02:29 consystor kernel:  [<c0180277>] alloc_inode+0x17/0x170
Jun  9 12:02:29 consystor kernel:  [<c0180c2c>] new_inode+0x1c/0x90
Jun  9 12:02:29 consystor kernel:  [<c02f6c7f>] sock_alloc+0xf/0x90
Jun  9 12:02:29 consystor kernel:  [<c02f7918>] __sock_create+0x58/0x2d0
Jun  9 12:02:29 consystor kernel:  [<c02f7ba9>] sock_create+0x19/0x30
Jun  9 12:02:29 consystor kernel:  [<f8ca63a6>] ethos_socket_tx+0xe4/0x16e [ethos]
Jun  9 12:02:29 consystor kernel:  [<c01188d6>] scheduler_tick+0x66/0x90
Jun  9 12:02:29 consystor kernel:  [<c0107566>] profile_pc+0x36/0x60
Jun  9 12:02:29 consystor kernel:  [<c011f549>] profile_tick+0x49/0x80
Jun  9 12:02:29 consystor kernel:  [<c0137ec5>] tick_handle_periodic+0x15/0x70
Jun  9 12:02:29 consystor kernel:  [<c010edf5>] local_apic_timer_interrupt+0x55/0x60
Jun  9 12:02:29 consystor kernel:  [<c012313b>] irq_exit+0xb/0x50
Jun  9 12:02:29 consystor kernel:  [<c010ee24>] smp_apic_timer_interrupt+0x24/0x30
Jun  9 12:02:29 consystor kernel:  [<c0104d5c>] apic_timer_interrupt+0x28/0x30
Jun  9 12:02:29 consystor kernel:  [<c011e683>] vprintk+0x1b3/0x2b0
Jun  9 12:02:29 consystor kernel:  [<c011e68d>] vprintk+0x1bd/0x2b0
Jun  9 12:02:29 consystor kernel:  [<c011e683>] vprintk+0x1b3/0x2b0
Jun  9 12:02:29 consystor kernel:  [<c011e68d>] vprintk+0x1bd/0x2b0
Jun  9 12:02:29 consystor kernel:  [<c035ce8a>] _read_lock+0x1a/0x90
Jun  9 12:02:29 consystor kernel:  [<c02fae1e>] sock_def_write_space+0x1e/0xb0
Jun  9 12:02:29 consystor kernel:  [<c035d19d>] _read_unlock+0xd/0x30
Jun  9 12:02:29 consystor kernel:  [<c02fa468>] sock_wfree+0x38/0x40
Jun  9 12:02:29 consystor kernel:  [<c035d13d>] _spin_unlock+0xd/0x30
Jun  9 12:02:29 consystor kernel:  [<f8ca62b2>] ethos_interrupt+0x83/0x93 [ethos]
Jun  9 12:02:29 consystor kernel:  [<f8ca6425>] ethos_socket_tx+0x163/0x16e [ethos]
Jun  9 12:02:29 consystor kernel:  [<c0122ed7>] local_bh_enable+0x37/0xe0
Jun  9 12:02:29 consystor kernel:  [<c02f9485>] sock_queue_rcv_skb+0xe5/0x100
Jun  9 12:02:29 consystor kernel:  [<c0126cd5>] do_gettimeofday+0x45/0x140
Jun  9 12:02:29 consystor kernel:  [<c02ad0b3>] speedo_start_xmit+0x1c3/0x2c0
Jun  9 12:02:29 consystor kernel:  [<c0301e27>] dev_hard_start_xmit+0x57/0xe0
Jun  9 12:02:29 consystor kernel:  [<c035cd4d>] _spin_lock+0xd/0x80
Jun  9 12:02:29 consystor kernel:  [<c030e105>] __qdisc_run+0x195/0x1c0
Jun  9 12:02:29 consystor kernel:  [<c0122ed7>] local_bh_enable+0x37/0xe0
Jun  9 12:02:29 consystor kernel:  [<c032d8f6>] tcp_ack_saw_tstamp+0x16/0x50
Jun  9 12:02:29 consystor kernel:  [<c032ccf4>] tcp_undo_cwr+0xd4/0x100
Jun  9 12:02:29 consystor kernel:  [<c032d3fb>] tcp_fastretrans_alert+0x16b/0x650
Jun  9 12:02:29 consystor kernel:  [<c032e4e0>] tcp_ack+0x160/0x320
Jun  9 12:02:29 consystor kernel:  [<c0330705>] tcp_rcv_established+0x205/0x6a0
Jun  9 12:02:29 consystor kernel:  [<c0247cf2>] __next_cpu+0x12/0x20
Jun  9 12:02:29 consystor kernel:  [<c0117bb1>] find_busiest_group+0x4d1/0x580
Jun  9 12:02:29 consystor kernel:  [<c0338f70>] tcp_v4_rcv+0x640/0x820
Jun  9 12:02:29 consystor kernel:  [<c0117d74>] load_balance+0x74/0x290
Jun  9 12:02:29 consystor kernel:  [<c0247cf2>] __next_cpu+0x12/0x20
Jun  9 12:02:29 consystor kernel:  [<f8ca64ea>] ethos_tx+0xba/0xd3 [ethos]
Jun  9 12:02:29 consystor kernel:  [<c03016c0>] __net_timestamp+0x10/0x30
Jun  9 12:02:29 consystor kernel:  [<c03017c5>] dev_queue_xmit_nit+0xe5/0x130
Jun  9 12:02:30 consystor kernel:  [<c0301e27>] dev_hard_start_xmit+0x57/0xe0
Jun  9 12:02:30 consystor kernel:  [<c030dffa>] __qdisc_run+0x8a/0x1c0
Jun  9 12:02:30 consystor kernel:  [<c030210e>] dev_queue_xmit+0x25e/0x2d0
Jun  9 12:02:30 consystor kernel:  [<c0307df1>] neigh_connected_output+0x81/0xb0
Jun  9 12:02:30 consystor kernel:  [<c0320762>] ip_output+0x1b2/0x2a0
Jun  9 12:02:30 consystor kernel:  [<c035b47c>] schedule+0x3dc/0x750
Jun  9 12:02:30 consystor kernel:  [<c01f8075>] journal_put_journal_head+0x65/0x120
Jun  9 12:02:30 consystor kernel:  [<c03228ae>] ip_push_pending_frames+0x40e/0x4a0
Jun  9 12:02:30 consystor kernel:  [<c033c8e7>] raw_sendmsg+0x347/0x470
Jun  9 12:02:30 consystor kernel:  [<c035cd4d>] _spin_lock+0xd/0x80
Jun  9 12:02:30 consystor kernel:  [<c0345647>] inet_sendmsg+0x47/0x60
Jun  9 12:02:30 consystor kernel:  [<c02f6eb1>] sock_sendmsg+0xe1/0xf0
Jun  9 12:02:30 consystor kernel:  [<c02f700c>] sock_recvmsg+0xfc/0x100
Jun  9 12:02:30 consystor kernel:  [<c01324d0>] autoremove_wake_function+0x0/0x50
Jun  9 12:02:30 consystor kernel:  [<c01324d0>] autoremove_wake_function+0x0/0x50
Jun  9 12:02:30 consystor kernel:  [<c02790fe>] n_tty_receive_buf+0x20e/0xaf0
Jun  9 12:02:30 consystor kernel:  [<c024d50c>] copy_from_user+0x3c/0x70
Jun  9 12:02:30 consystor kernel:  [<c024d50c>] copy_from_user+0x3c/0x70
Jun  9 12:02:30 consystor kernel:  [<c02f89b5>] sys_sendmsg+0x155/0x1b0
Jun  9 12:02:30 consystor kernel:  [<c0150e89>] buffered_rmqueue+0xf9/0x1a0
Jun  9 12:02:30 consystor kernel:  [<c014d8b3>] filemap_nopage+0x203/0x420
Jun  9 12:02:30 consystor kernel:  [<c015aedc>] do_no_page+0x18c/0x2f0
Jun  9 12:02:30 consystor kernel:  [<c015b34a>] __handle_mm_fault+0x15a/0x2a0
Jun  9 12:02:30 consystor kernel:  [<c02f8e39>] sys_socketcall+0x259/0x280
Jun  9 12:02:30 consystor kernel:  [<c012247c>] sys_gettimeofday+0x2c/0x70
Jun  9 12:02:30 consystor kernel:  [<c0104304>] syscall_call+0x7/0xb
Jun  9 12:02:30 consystor kernel:  =======================


