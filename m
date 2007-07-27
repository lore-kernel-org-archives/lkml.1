Return-Path: <linux-kernel-owner+w=401wt.eu-S936213AbXG0Nkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936213AbXG0Nkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932707AbXG0Nkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:40:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57670 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbXG0Nkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:40:42 -0400
Message-ID: <46A9F5D7.4050501@garzik.org>
Date: Fri, 27 Jul 2007 09:40:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
CC: kernel list <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: NFSv4 poops itself
References: <46A9EAB0.3090306@garzik.org> <200707271537.00647.marc.dietrich@ap.physik.uni-giessen.de>
In-Reply-To: <200707271537.00647.marc.dietrich@ap.physik.uni-giessen.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(please don't drop CC's when you reply to email; you are cutting 
relevant people out of the loop)


Marc Dietrich wrote:
> me too, my server has 2.6.18-? (openSUSE 10.2). On the client 
> (2.6.23-rc1-mm1), I also see (shortly before the hang)
> 
> Jul 26 13:09:19 fb07-iapwap2 kernel: =================================
> Jul 26 13:09:19 fb07-iapwap2 kernel: [ INFO: inconsistent lock state ]
> Jul 26 13:09:19 fb07-iapwap2 kernel: 2.6.23-rc1-mm1 #1
> Jul 26 13:09:19 fb07-iapwap2 kernel: ---------------------------------
> Jul 26 13:09:19 fb07-iapwap2 kernel: inconsistent {softirq-on-W} -> 
> {in-softirq-W} usage.
> Jul 26 13:09:19 fb07-iapwap2 kernel: hald/3873 [HC0[0]:SC1[1]:HE1:SE0] takes:
> Jul 26 13:09:19 fb07-iapwap2 kernel:  (rpc_credcache_lock){-+..}, at: 
> [<c01dc166>] _atomic_dec_and_lock+0x16/0x60
> Jul 26 13:09:19 fb07-iapwap2 kernel: {softirq-on-W} state was registered at:
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013d4f7>] mark_lock+0x77/0x630
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013c094>] add_lock_to_list+0x44/0xc0
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013e8af>] 
> __lock_acquire+0x65f/0x1020
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013db0e>] mark_held_locks+0x5e/0x80
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c012448d>] local_bh_enable+0x7d/0x130
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013f2cf>] lock_acquire+0x5f/0x80
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> _atomic_dec_and_lock+0x16/0x60
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> _atomic_dec_and_lock+0x16/0x60
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> _atomic_dec_and_lock+0x16/0x60
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf770>] put_rpccred+0x60/0x110 
> [sunrpc]
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf840>] 
> rpcauth_unbindcred+0x20/0x60 [sunrpc]
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcece1f4>] rpc_put_task+0x44/0xb0 
> [sunrpc]
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcec8ffd>] rpc_call_sync+0x2d/0x40 
> [sunrpc]
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced680d>] rpcb_register+0x10d/0x1c0 
> [sunrpc]
> Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced06ef>] svc_register+0x8f/0x160 
> [sunrpc]
[continues]

That's quite interesting.  I wonder if I enable lock debugging and 
tracing, if new stuff will appear.

	Jeff


