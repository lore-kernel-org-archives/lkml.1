Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbXGPOwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbXGPOwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXGPOwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:52:36 -0400
Received: from mx2.netapp.com ([216.240.18.37]:23021 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbXGPOwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:52:35 -0400
X-IronPort-AV: E=Sophos;i="4.16,542,1175497200"; 
   d="scan'208";a="82563264"
Subject: Re: sunrpc-related Oops in latest git
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070715170523.2bed7110@dhcp-255-175.norway.atmel.com>
References: <20070715170523.2bed7110@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Network Appliance Inc
Date: Mon, 16 Jul 2007 10:52:14 -0400
Message-Id: <1184597534.11083.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 16 Jul 2007 14:52:16.0184 (UTC) FILETIME=[E6B46380:01C7C7B8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 17:05 +0200, Haavard Skinnemoen wrote:
> Hi Trond,
> 
> While testing my avr32 updates on the latest git tree, I got this:
> 
> VFS: Mounted root (nfs filesystem).
> Freeing init memory: 56K (90000000 - 9000e000)
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ptbr = 90161f44 pgd = 00000000
> Oops: Kernel access of bad area, sig: 11 [#1]
> FRAME_POINTER chip: 0x01f:0x1e82 rev 2
> Modules linked in:
> PC is at queue_work+0x2a/0x34
> LR is at __init_begin+0x70000000/0x1c
> pc : [<900215f2>]    lr : [<00000000>]    Not tainted
> sp : 9014fcf0  r12: 00000000  r11: 90009074
> r10: 00100100  r9 : 90009078  r8 : 90009078
> r7 : 9014fcf0  r6 : 9025652c  r5 : 90009004  r4 : 0000106c
> r3 : 00001064  r2 : 00001064  r1 : 90263000  r0 : 901b1320
> Flags: qvnZc
> Mode bits: hrje....g
> CPU Mode: Interrupt level 0
> Process: swapper [0] (task: 90153afc thread: 9014e000)
> Stack: (0x9014fcf0 to 0x90150000)
> fce0:                                     900f983a 9014fd08 9025652c 90009004
> fd00: 0000106c 00000000 900f98a2 9014fd1c 9000906c 90009004 0000106c 900f6edc
> fd20: 9014fd30 9024c000 90009004 0000106c 900f8d08 9014fd5c 00001064 90009004
> fd40: 0000106c 901b1320 00001064 90263000 901b1320 900cd15a 9014fd8c 900bc7f6
> fd60: 9014fd80 00000000 00000000 0000106c 90263000 0000106c 0abfffaf 901b1320
> fd80: 900e6010 9014fda4 90263000 90263000 0000106c 901b1320 9025d834 0abfffaf
> fda0: 901b1320 900e6406 9014fdf4 90263000 901b1344 0000106c 9016e110 9025d834
> fdc0: 0abfffaf 901b1320 900d0286 0abfffad 00000011 0000106c 10775008 90268540
> fde0: 00001080 00000024 0000106c 0abfffad 0abfffaf 900e65bc 9014fe18 901b1320
> fe00: 00000011 10775008 00000000 9016caa0 00000800 00000500 900cf3f6 9014fe2c
> fe20: 901b1320 00000011 10775008 900cf76e 9014fe50 9000a820 901b1140 10775008
> fe40: 901b1164 9016caa0 00000800 00000500 900c112a 9014fe74 9016ca88 901b1140
> fe60: 10775008 901af800 9016caa0 00000800 00000500 900b1f44 9014feac 901b1140
> fe80: 0000003b 10775008 000004fe 901afb80 0000003b 00000500 901af800 00000040
> fea0: 00000003 900b1dbc 0000003d 900c2808 9014fed4 901af918 901af800 10775008
> fec0: 9016c710 9016c700 fffedde1 007f0000 0000012c 9001ae96 9014fef8 00000000
> fee0: 90168174 10775008 0000000a 90161904 00000000 007f0000 9001aefa 9014ff1c
> ff00: 00810022 00000000 10775008 00000000 90161904 00000000 007f0000 9001b0a0
> ff20: 9014ff30 9016aa0c 00000000 10775008 9000f074 9014ff44 9016aa0c 00000000
> ff40: 10775008 9000e4fe 9014ffb0 90169058 90161930 10775008 9000be70 90161904
> ff60: 00000000 007f0000 00400024 9000e4da 900112ba 90268000 90153978 00000000
> ff80: 90153d74 00000200 9014e000 9014ffb0 90169058 90161930 10775008 9000be70
> ffa0: 90161904 00000000 007f0000 007f0000 90102df6 9014ffc4 90169058 90161930
> ffc0: 10775008 9000072c 9014ffdc 90169058 90161930 10775008 9000be70 00000000
> ffe0: 00000000 107cb030 10770fa0 10775008 901729c8 901729c8 00000000 007f0000
> Call trace:
>  [<900f983a>] __rpc_do_wake_up_task+0x18a/0x1c4
>  [<900f98a2>] rpc_wake_up_task+0x2e/0x40
>  [<900f6edc>] xprt_complete_rqst+0x64/0x74
>  [<900f8d08>] xs_udp_data_ready+0xd0/0xf0
>  [<900bc7f6>] sock_queue_rcv_skb+0xa2/0xd0
>  [<900e6010>] udp_queue_rcv_skb+0x9c/0x114
>  [<900e6406>] __udp4_lib_rcv+0x37e/0x528
>  [<900e65bc>] udp_rcv+0xc/0x14
>  [<900cf3f6>] ip_local_deliver+0x7e/0xcc
>  [<900cf76e>] ip_rcv+0x32a/0x35c
>  [<900c112a>] netif_receive_skb+0x136/0x188
>  [<900b1f44>] macb_poll+0x27c/0x318
>  [<900c2808>] net_rx_action+0x48/0xc4
>  [<9001ae96>] __do_softirq+0x32/0x74
>  [<9001aefa>] do_softirq+0x22/0x3c
>  [<9001b0a0>] irq_exit+0x24/0x30
>  [<9000f074>] do_IRQ+0x3c/0x50
>  [<9000e4fe>] irq_level0+0x18/0x5e
>  [<90102df6>] rest_init+0x3a/0x48
>  [<9000072c>] start_kernel+0x1f0/0x220
>  [<00000000>] __init_begin+0x70000000/0x1c
> 
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> As you can see, I'm using nfsroot. git-bisect blames this commit:
> 
> 4ada539ed77c7a2bbcb75cafbbd7bd8d2b9bef7b is first bad commit
> commit 4ada539ed77c7a2bbcb75cafbbd7bd8d2b9bef7b
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Thu Jun 14 17:26:17 2007 -0400
> 
>     SUNRPC: Make create_client() take a reference to the rpciod workqueue
> 
>     Ensures that an rpc_client always has the possibility to send asynchronous
>     RPC calls.
> 
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> :040000 040000 d09b2ebe7a650d9be8a0b0606652f9768779cf18 7ec13589a51d237ecdfd32a46806b43c28a55ed8 M      net
> 
> Please let me know if there's anything I can do to help debug this.
> 
> Håvard

So you are saying that if you revert this patch, and only this patch,
then it fixes nfsroot? (sorry, I tend not to trust git-bisect)

Trond
