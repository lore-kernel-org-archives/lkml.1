Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXAZTpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXAZTpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161229AbXAZTpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:45:06 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:50414 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161228AbXAZTpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:45:04 -0500
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 14:45:04 EST
Date: Fri, 26 Jan 2007 19:22:40 +0000
From: Sean Young <sean@mess.org>
To: linux-kernel@vger.kernel.org
Subject: [LOCKDEP] Possible recursive locking detected
Message-ID: <20070126192240.GA19725@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.config: http://www.msxnet.org/config-2.6.20-rc5

=============================================
[ INFO: possible recursive locking detected ]
2.6.20-rc5 #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&q->lock){++..}, at: [<c0114dc0>] __wake_up+0x18/0x43

but task is already holding lock:
 (&q->lock){++..}, at: [<c0114dc0>] __wake_up+0x18/0x43

other info that might help us debug this:
3 locks held by swapper/0:
 #0:  (slock-AF_INET/1){-+..}, at: [<c02d9ed8>] tcp_v4_rcv+0x673/0x85b
 #1:  (af_callback_keys + sk->sk_family#2){-.-?}, at: [<c029d137>] sock_def_readable+0x15/0x6e
 #2:  (&q->lock){++..}, at: [<c0114dc0>] __wake_up+0x18/0x43

stack backtrace:
 [<c0130f78>] __lock_acquire+0xab7/0xd7b
 [<c012e86a>] add_lock_to_list+0x36/0x8f
 [<c0131293>] lock_acquire+0x57/0x6f
 [<c0114dc0>] __wake_up+0x18/0x43
 [<c0306f7a>] _spin_lock_irqsave+0x32/0x41
 [<c0114dc0>] __wake_up+0x18/0x43
 [<c0114dc0>] __wake_up+0x18/0x43
 [<c017fd65>] ep_poll_safewake+0x9b/0xd4
 [<c0180d5f>] ep_poll_callback+0x83/0xb4
 [<c0114a1b>] __wake_up_common+0x39/0x59
 [<c0114dda>] __wake_up+0x32/0x43
 [<c029d18e>] sock_def_readable+0x6c/0x6e
 [<c02d0562>] tcp_data_queue+0x421/0xbd1
 [<c02d9ed8>] tcp_v4_rcv+0x673/0x85b
 [<c02d22a5>] tcp_rcv_established+0x360/0x68b
 [<c02d7c73>] tcp_v4_do_rcv+0x95/0x2d9
 [<c02d9ed8>] tcp_v4_rcv+0x673/0x85b
 [<c0306c43>] _spin_lock_nested+0x27/0x32
 [<c02da0ae>] tcp_v4_rcv+0x849/0x85b
 [<c02bf8f8>] ip_local_deliver+0x100/0x268
 [<c0306c77>] _spin_lock+0x29/0x34
 [<c02bf5f4>] ip_rcv+0x263/0x467
 [<c0106c97>] enable_8259A_irq+0xd/0x4b
 [<c0106c97>] enable_8259A_irq+0xd/0x4b
 [<c02a34ca>] netif_receive_skb+0x1f3/0x2e7
 [<c012ff8e>] trace_hardirqs_on+0x76/0x14a
 [<c02a4d69>] process_backlog+0x79/0xf3
 [<c02a4f7c>] net_rx_action+0x97/0x167
 [<c011d0f7>] __do_softirq+0x4b/0x9c
 [<c011d187>] do_softirq+0x3f/0x41
 [<c0105228>] do_IRQ+0x52/0x8a
 [<c0103708>] common_interrupt+0x24/0x34
 [<c0103712>] common_interrupt+0x2e/0x34
 [<e1a88e4a>] acpi_processor_idle+0x1bc/0x356 [processor]
 [<e1a88e4d>] acpi_processor_idle+0x1bf/0x356 [processor]
 [<c010133a>] cpu_idle+0x39/0x4e
 [<c040a6b5>] start_kernel+0x28f/0x32a
 [<c040a1cd>] unknown_bootoption+0x0/0x259
 =======================
