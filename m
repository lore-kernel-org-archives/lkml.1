Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZIOJew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZIOJew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZIOJes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:34:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZIOJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:34:47 -0400
Date: Tue, 15 Sep 2009 11:34:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (bf438284)
Message-ID: <20090915093440.GA7921@elte.hu>
References: <20090915080953.GA24958@elte.hu> <4AAF5757.30500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAF5757.30500@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Ingo Molnar a ?crit :
> > FYI, we still have this one on latest mainline:
> > 
> > [    2.159614] NET: Registered protocol family 16
> > [    2.163109] initcall netlink_proto_init+0x0/0x1b0 returned 0 after 5859 usecs
> > [    2.164008] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (bf438284)
> > [    2.165006] 0100000002000000000000000000000000000000ad4eaddeffffffffffffffff
> > [    2.172006]  i i i i i i u u i i i i i i i i i i i i i i i i i i i i i i i i
> > [    2.179005]          ^
> > [    2.180005] 
> > [    2.181008] Pid: 1, comm: swapper Not tainted (2.6.31-tip-02389-gc9f313c-dirty #151) 
> > [    2.182006] EIP: 0060:[<815a8101>] EFLAGS: 00010282 CPU: 0
> > [    2.183009] EIP is at sock_init_data+0xe1/0x210
> > [    2.184006] EAX: 0001b000 EBX: bf855938 ECX: 8233b614 EDX: 819ac7bf
> > [    2.185006] ESI: bf855800 EDI: bf438280 EBP: bf867f10 ESP: 81b3afcc
> > [    2.186006]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > [    2.187006] CR0: 8005003b CR2: bf83bdf0 CR3: 01b2c000 CR4: 000006d0
> > [    2.188006] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > [    2.189006] DR6: ffff4ff0 DR7: 00000400
> > [    2.190005]  [<815d82b5>] __netlink_create+0x35/0xa0
> > [    2.192005]  [<815dabaa>] netlink_kernel_create+0x5a/0x150
> > [    2.194004]  [<815bc8ee>] rtnetlink_net_init+0x1e/0x40
> > [    2.196005]  [<815af381>] register_pernet_operations+0x11/0x30
> > [    2.198004]  [<815af4be>] register_pernet_subsys+0x1e/0x30
> > [    2.200004]  [<81adb49c>] rtnetlink_init+0x4c/0x100
> > [    2.202004]  [<81adbfe5>] netlink_proto_init+0x105/0x1b0
> > [    2.204004]  [<81001127>] do_one_initcall+0x27/0x190
> > [    2.206004]  [<81a9f567>] do_initcalls+0x27/0x40
> > [    2.208004]  [<81a9f5a6>] do_basic_setup+0x26/0x30
> > [    2.210004]  [<81a9f907>] kernel_init+0x57/0xa0
> > [    2.212004]  [<81004867>] kernel_thread_helper+0x7/0x30
> > [    2.214004]  [<ffffffff>] 0xffffffff
> > [    2.216021] calling  bdi_class_init+0x0/0x30 @ 1
> > [    2.217015] device class 'bdi': registering
> > [    2.218702] initcall bdi_class_init+0x0/0x30 returned 0 after 976 usecs
> > [    2.219041] calling  kobject_uevent_init+0x0/0x50 @ 1
> > 
> > config attached.
> > 
> > 	Ingo
> > 
> 
> I thought this was already discussed and fixed somehow ?

yes, it looked familar.

> Either we add kmemcheck annotations, or we switch sock->type from short
> to int to avoid the hole, and possibly to speedup things...
> 
> [PATCH] net: kmemcheck annotation in struct socket
> 
> struct socket has a 16 bit hole that triggers kmemcheck warnings.
> 
> As suggested by Ingo, use kmemcheck annotations
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  include/linux/net.h |    5 +++++
>  net/socket.c        |    1 +
>  2 files changed, 6 insertions(+)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
