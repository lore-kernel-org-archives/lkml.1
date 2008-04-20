Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYDTVxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYDTVxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYDTVwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:52:54 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:51492 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYDTVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:52:52 -0400
Message-ID: <480B78C3.4040205@ccr.jussieu.fr>
Date: Sun, 20 Apr 2008 19:09:23 +0200
From: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org
Subject: [PATCH] soft lockup rose_node_list_lock
References: <480A6034.1080806@ccr.jussieu.fr> <20080419.184010.113401925.davem@davemloft.net>
In-Reply-To: <20080419.184010.113401925.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From f40c15d0ea5a22178e6cbb0331486d2297abeeb7 Mon Sep 17 00:00:00 2001
From: Bernard Pidoux <f6bvp@amsat.org>
Date: Sun, 20 Apr 2008 18:19:06 +0200
Subject: [PATCH] soft lockup rose_node_list_lock

[ INFO: possible recursive locking detected ]
2.6.25 #3
---------------------------------------------
ax25ipd/3811 is trying to acquire lock:
  (rose_node_list_lock){-+..}, at: [<f8d31f1a>] rose_get_neigh+0x1a/0xa0 
[rose]

but task is already holding lock:
  (rose_node_list_lock){-+..}, at: [<f8d31fed>] 
rose_route_frame+0x4d/0x620 [rose]

other info that might help us debug this:
6 locks held by ax25ipd/3811:
  #0:  (&tty->atomic_write_lock){--..}, at: [<c0259a1c>] 
tty_write_lock+0x1c/0x50
  #1:  (rcu_read_lock){..--}, at: [<c02aea36>] net_rx_action+0x96/0x230
  #2:  (rcu_read_lock){..--}, at: [<c02ac5c0>] netif_receive_skb+0x100/0x2f0
  #3:  (rose_node_list_lock){-+..}, at: [<f8d31fed>] 
rose_route_frame+0x4d/0x620 [rose]
  #4:  (rose_neigh_list_lock){-+..}, at: [<f8d31ff7>] 
rose_route_frame+0x57/0x620 [rose]
  #5:  (rose_route_list_lock){-+..}, at: [<f8d32001>] 
rose_route_frame+0x61/0x620 [rose]

stack backtrace:
Pid: 3811, comm: ax25ipd Not tainted 2.6.25 #3
  [<c0147e27>] print_deadlock_bug+0xc7/0xd0
  [<c0147eca>] check_deadlock+0x9a/0xb0
  [<c0149cd2>] validate_chain+0x1e2/0x310
  [<c0149b95>] ? validate_chain+0xa5/0x310
  [<c010a7d8>] ? native_sched_clock+0x88/0xc0
  [<c0149fa1>] __lock_acquire+0x1a1/0x750
  [<c014a5d1>] lock_acquire+0x81/0xa0
  [<f8d31f1a>] ? rose_get_neigh+0x1a/0xa0 [rose]
  [<c03201a3>] _spin_lock_bh+0x33/0x60
  [<f8d31f1a>] ? rose_get_neigh+0x1a/0xa0 [rose]
  [<f8d31f1a>] rose_get_neigh+0x1a/0xa0 [rose]
  [<f8d32404>] rose_route_frame+0x464/0x620 [rose]
  [<c031ffdd>] ? _read_unlock+0x1d/0x20
  [<f8d31fa0>] ? rose_route_frame+0x0/0x620 [rose]
  [<f8d1c396>] ax25_rx_iframe+0x66/0x3b0 [ax25]
  [<f8d1f42f>] ? ax25_start_t3timer+0x1f/0x40 [ax25]
  [<f8d1e65b>] ax25_std_frame_in+0x7fb/0x890 [ax25]
  [<c0320005>] ? _spin_unlock_bh+0x25/0x30
  [<f8d1bdf6>] ax25_kiss_rcv+0x2c6/0x800 [ax25]
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c014a8a7>] ? __lock_release+0x47/0x70
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c031ffdd>] ? _read_unlock+0x1d/0x20
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c02a4d3a>] ? sock_queue_rcv_skb+0x13a/0x1d0
  [<c02a4c45>] ? sock_queue_rcv_skb+0x45/0x1d0
  [<f8d1bb30>] ? ax25_kiss_rcv+0x0/0x800 [ax25]
  [<c02ac715>] netif_receive_skb+0x255/0x2f0
  [<c02ac5c0>] ? netif_receive_skb+0x100/0x2f0
  [<c02af05c>] process_backlog+0x7c/0xf0
  [<c02aeb0c>] net_rx_action+0x16c/0x230
  [<c02aea36>] ? net_rx_action+0x96/0x230
  [<c012bd53>] __do_softirq+0x93/0x120
  [<f8d2a68a>] ? mkiss_receive_buf+0x33a/0x3f0 [mkiss]
  [<c012be37>] do_softirq+0x57/0x60
  [<c012c265>] local_bh_enable_ip+0xa5/0xe0
  [<c0320005>] _spin_unlock_bh+0x25/0x30
  [<f8d2a68a>] mkiss_receive_buf+0x33a/0x3f0 [mkiss]
  [<c025ea37>] pty_write+0x47/0x60
  [<c025c620>] write_chan+0x1b0/0x220
  [<c0259a1c>] ? tty_write_lock+0x1c/0x50
  [<c011fec0>] ? default_wake_function+0x0/0x10
  [<c0259bea>] tty_write+0x12a/0x1c0
  [<c025c470>] ? write_chan+0x0/0x220
  [<c018bbc6>] vfs_write+0x96/0x130
  [<c0259ac0>] ? tty_write+0x0/0x1c0
  [<c018c24d>] sys_write+0x3d/0x70
  [<c0104d1e>] sysenter_past_esp+0x5f/0xa5
  =======================
BUG: soft lockup - CPU#0 stuck for 61s! [ax25ipd:3811]

Pid: 3811, comm: ax25ipd Not tainted (2.6.25 #3)
EIP: 0060:[<c010a9db>] EFLAGS: 00000246 CPU: 0
EIP is at native_read_tsc+0xb/0x20
EAX: b404aa2c EBX: b404a9c9 ECX: 017f1000 EDX: 0000076b
ESI: 00000001 EDI: 00000000 EBP: ecc83afc ESP: ecc83afc
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7f5f000 CR3: 2cd8e000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
  [<c0204937>] delay_tsc+0x17/0x30
  [<c02048e9>] __delay+0x9/0x10
  [<c02127f6>] __spin_lock_debug+0x76/0xf0
  [<c0212618>] ? spin_bug+0x18/0x100
  [<c0147923>] ? __lock_contended+0xa3/0x110
  [<c0212998>] _raw_spin_lock+0x68/0x90
  [<c03201bf>] _spin_lock_bh+0x4f/0x60
  [<f8d31f1a>] ? rose_get_neigh+0x1a/0xa0 [rose]
  [<f8d31f1a>] rose_get_neigh+0x1a/0xa0 [rose]
  [<f8d32404>] rose_route_frame+0x464/0x620 [rose]
  [<c031ffdd>] ? _read_unlock+0x1d/0x20
  [<f8d31fa0>] ? rose_route_frame+0x0/0x620 [rose]
  [<f8d1c396>] ax25_rx_iframe+0x66/0x3b0 [ax25]
  [<f8d1f42f>] ? ax25_start_t3timer+0x1f/0x40 [ax25]
  [<f8d1e65b>] ax25_std_frame_in+0x7fb/0x890 [ax25]
  [<c0320005>] ? _spin_unlock_bh+0x25/0x30
  [<f8d1bdf6>] ax25_kiss_rcv+0x2c6/0x800 [ax25]
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c014a8a7>] ? __lock_release+0x47/0x70
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c031ffdd>] ? _read_unlock+0x1d/0x20
  [<c02a4769>] ? sock_def_readable+0x59/0x80
  [<c02a4d3a>] ? sock_queue_rcv_skb+0x13a/0x1d0
  [<c02a4c45>] ? sock_queue_rcv_skb+0x45/0x1d0
  [<f8d1bb30>] ? ax25_kiss_rcv+0x0/0x800 [ax25]
  [<c02ac715>] netif_receive_skb+0x255/0x2f0
  [<c02ac5c0>] ? netif_receive_skb+0x100/0x2f0
  [<c02af05c>] process_backlog+0x7c/0xf0
  [<c02aeb0c>] net_rx_action+0x16c/0x230
  [<c02aea36>] ? net_rx_action+0x96/0x230
  [<c012bd53>] __do_softirq+0x93/0x120
  [<f8d2a68a>] ? mkiss_receive_buf+0x33a/0x3f0 [mkiss]
  [<c012be37>] do_softirq+0x57/0x60
  [<c012c265>] local_bh_enable_ip+0xa5/0xe0
  [<c0320005>] _spin_unlock_bh+0x25/0x30
  [<f8d2a68a>] mkiss_receive_buf+0x33a/0x3f0 [mkiss]
  [<c025ea37>] pty_write+0x47/0x60
  [<c025c620>] write_chan+0x1b0/0x220
  [<c0259a1c>] ? tty_write_lock+0x1c/0x50
  [<c011fec0>] ? default_wake_function+0x0/0x10
  [<c0259bea>] tty_write+0x12a/0x1c0
  [<c025c470>] ? write_chan+0x0/0x220
  [<c018bbc6>] vfs_write+0x96/0x130
  [<c0259ac0>] ? tty_write+0x0/0x1c0
  [<c018c24d>] sys_write+0x3d/0x70
  [<c0104d1e>] sysenter_past_esp+0x5f/0xa5
  =======================

Since rose_route_frame() does not use rose_node_list we can safely
remove rose_node_list_lock spin lock here and let it be free for
rose_get_neigh().

Signed-off-by: Bernard Pidoux <f6bvp@amsat.org>
---
  net/rose/rose_route.c |    2 --
  1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index fb9359f..5053a53 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -857,7 +857,6 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
         src_addr  = (rose_address *)(skb->data + 9);
         dest_addr = (rose_address *)(skb->data + 4);

-       spin_lock_bh(&rose_node_list_lock);
         spin_lock_bh(&rose_neigh_list_lock);
         spin_lock_bh(&rose_route_list_lock);

@@ -1060,7 +1059,6 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb 
*ax25)
  out:
         spin_unlock_bh(&rose_route_list_lock);
         spin_unlock_bh(&rose_neigh_list_lock);
-       spin_unlock_bh(&rose_node_list_lock);

         return res;
  }
--
1.5.5
