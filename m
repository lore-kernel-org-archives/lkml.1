Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXCKPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXCKPfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933770AbXCKPfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 11:35:25 -0400
Received: from mxl144v79.mxlogic.net ([208.65.144.79]:40300 "EHLO
	p02c11o146.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbXCKPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 11:35:24 -0400
Date: Sun, 11 Mar 2007 17:04:31 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Roland Dreier <roland.list@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!)
Message-ID: <20070311150431.GE31985@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311135051.GA31985@mellanox.co.il>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 11 Mar 2007 15:06:45.0502 (UTC) FILETIME=[E26589E0:01C763EE]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--1.570200-4.000000-31
X-Spam: [F=0.5000185045; S=0.500(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [63.251.237.3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


After adding some printks, I started getting these:

[  597.036720] BUG: MAX_STACK_TRACE_ENTRIES too low!
[  597.041546] turning off the locking correctness validator.
[  597.047135]  [<c023a922>] save_trace+0x8a/0x8f
[  597.051751]  [<c023ae8c>] mark_lock+0x65/0x3ff
[  597.056366]  [<c023a8d6>] save_trace+0x3e/0x8f
[  597.060980]  [<c023a9f0>] add_lock_to_list+0x62/0x85
[  597.066116]  [<c023b992>] __lock_acquire+0x3f4/0xbb9
[  597.071252]  [<f89da11f>] send_mad+0x79/0x103 [ib_sa]
[  597.076474]  [<c031a475>] idr_get_new_above_int+0x13c/0x216
[  597.082225]  [<c023c43d>] lock_acquire+0x56/0x71
[  597.087018]  [<f89da11f>] send_mad+0x79/0x103 [ib_sa]
[  597.092240]  [<c051ad41>] _spin_lock_irqsave+0x32/0x41
[  597.097547]  [<f89da11f>] send_mad+0x79/0x103 [ib_sa]
[  597.102770]  [<f89da11f>] send_mad+0x79/0x103 [ib_sa]
[  597.107989]  [<f89da8d9>] ib_sa_path_rec_get+0x134/0x172 [ib_sa]
[  597.114166]  [<f899b73f>] path_rec_start+0x115/0x143 [ib_ipoib]
[  597.120254]  [<f899cb38>] path_rec_completion+0x0/0x4f4 [ib_ipoib]
[  597.126610]  [<f899b874>] path_rec_create+0x77/0x9d [ib_ipoib]
[  597.132617]  [<f899c9fe>] ipoib_start_xmit+0x441/0x57b [ib_ipoib]
[  597.138888]  [<c051ae06>] _spin_unlock_irqrestore+0x34/0x39
[  597.144635]  [<c023b435>] trace_hardirqs_on+0x106/0x141
[  597.150035]  [<c04a058b>] dev_queue_xmit+0x109/0x245
[  597.155167]  [<c022ae27>] __mod_timer+0x94/0x9e
[  597.159871]  [<c04a0423>] dev_hard_start_xmit+0x1be/0x21d
[  597.165438]  [<c04a9fa9>] __qdisc_run+0xd7/0x190
[  597.170226]  [<c04a05b7>] dev_queue_xmit+0x135/0x245
[  597.175360]  [<c04ce267>] arp_process+0x2c0/0x512
[  597.180234]  [<f8954346>] mthca_tavor_interrupt+0xf3/0x12b [ib_mthca]
[  597.186855]  [<c04a088b>] netif_receive_skb+0x1c4/0x1da
[  597.192254]  [<c023b435>] trace_hardirqs_on+0x106/0x141
[  597.197648]  [<c04a0935>] process_backlog+0x94/0x107
[  597.202785]  [<c049f02b>] net_rx_action+0x9a/0x15e
[  597.207743]  [<c0227643>] __do_softirq+0x69/0xd5
[  597.212530]  [<c02276e6>] do_softirq+0x37/0x4d
[  597.217147]  [<c020617e>] do_IRQ+0x5c/0x72
[  597.221415]  [<c0204b52>] common_interrupt+0x2e/0x34
[  597.226549]  [<c02029ef>] default_idle+0x3b/0x54
[  597.231337]  [<c02029f1>] default_idle+0x3d/0x54
[  597.236124]  [<c0202aaa>] cpu_idle+0xa2/0xbb
[  597.240567]  =======================

And sometimes these:

[  404.493572] KERNEL: assertion (!timer_pending(&dev->watchdog_timer)) failed at net/sched/sch_generic.c (608)

-- 
MST
