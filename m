Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYGXNt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYGXNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYGXNtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:49:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:61183 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYGXNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=b07xOjpyr34z3sfAMkz+YSUyDNxkKOTi6tf64ZNEJLI09GhzXWiZ0Lxk98A9berYtQ
         mCZa80Ko9uvDP+w5fHsjpyqyG6ZKnOXI4XJzIYmcR9bcbzkvInVlOqvnql/hnRLSBsFG
         CFL+QP7XInM18Zm01/hRqkTJAl4bE/UNoAk3E=
Message-ID: <84144f020807240649ra4ef475x9f19f1474678ea2f@mail.gmail.com>
Date: Thu, 24 Jul 2008 16:49:38 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Dieter Ries" <clip2@gmx.de>
Subject: Re: Current Git: BUG: unable to handle kernel paging request at 0000000001a40ca0
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
       e1000-devel@lists.sourceforge.net, "Patrick McHardy" <kaber@trash.net>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48882687.7020508@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488750AA.20707@gmx.de>
	 <19f34abd0807231046o4b194409w7d0e28a7cd745afa@mail.gmail.com>
	 <48877200.9040608@gmx.de> <4887A860.6070607@gmx.de>
	 <19f34abd0807231500m3d780d90i39626023e0685369@mail.gmail.com>
	 <48882687.7020508@gmx.de>
X-Google-Sender-Auth: ef12f4a2e4dee3a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dieter,

On Thu, Jul 24, 2008 at 9:51 AM, Dieter Ries <clip2@gmx.de> wrote:
> Vegard Nossum schrieb:
>>
>> On Wed, Jul 23, 2008 at 11:53 PM, Dieter Ries <clip3@gmx.de> wrote:
>>>>>
>>>>> Dieter: If this is reproducible, it would probably help quite a bit to
>>>>> configure the kernel with CONFIG_SLUB_DEBUG and boot with
>>>>> slub_debug=FZPUT (unless you already have CONFIG_SLUB_DEBUG_ON set, in
>>>>> which case you are already running with the SLUB debugging at boot).
>>>>> It might catch the corruption before it becomes fatal, or give us some
>>>>> more clues anyway.
>>>
>>> I tried to bisect the bug, which failed because there were too many
>>> kernels
>>> not booting with other problems, I guess bisecting just fails in the
>>> merge
>>> window.
>>>
>>> With CONFIG_SLUB_DEBUG_ON the output looks different, unfortunately
>>> netconsole stops before those are transmitted.
>
> I think I managed to catch one of those:
>
>
> general protection fault: 0000 [1] SMP
> CPU 0
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.26-06373-gcaf076e #49
> RIP: 0010:[<ffffffff805e08f9>]  [<ffffffff805e08f9>]
> nf_nat_move_storage+0x21/0x7a
> RSP: 0018:ffffffff8091ab80  EFLAGS: 00010206
> RAX: ffffffff805e08d8 RBX: ffff88007d1fb948 RCX: 000000000000006b
> RDX: ffff88007d175e10 RSI: ffff88007d175e7b RDI: ffff88007d1fb948
> RBP: ffffffff8091aba0 R08: 0000000000000000 R09: ffff88007d175e90
> R10: ffffe20000000008 R11: ffff88007d175e10 R12: 59d2c3ffff88007d
> R13: ffff88007d175e7b R14: 00000000000000a0 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffffffff8089ee80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff808b0000, task ffffffff80842340)
> Stack:  0000000000000002 ffff88007d3d2000 ffff88007d1fb948 0000000000000070
>  ffffffff8091abf0 ffffffff8059d3c4 ffffffff8091ac40 0000000100000001
>  ffffffff809e3658 ffff88007d3d2000 0000000000000002 ffff88007f9f6500
> Call Trace:
>  <IRQ>  [<ffffffff8059d3c4>] __nf_ct_ext_add+0x15f/0x1f7
>  [<ffffffff805e762c>] nf_nat_fn+0x84/0x152
>  [<ffffffff805e77d8>] nf_nat_in+0x2f/0x71
>  [<ffffffff805953d8>] nf_iterate+0x48/0x85
>  [<ffffffff805b19c0>] ? ip_rcv_finish+0x0/0x35d
>  [<ffffffff80595478>] nf_hook_slow+0x63/0xcb
>  [<ffffffff805b19c0>] ? ip_rcv_finish+0x0/0x35d
>  [<ffffffff8028fe7c>] ? __slab_alloc+0x413/0x4bd
>  [<ffffffff805b21b8>] ip_rcv+0x257/0x297
>  [<ffffffff80581461>] netif_receive_skb+0x1f1/0x263
>  [<ffffffff80495b34>] e1000_receive_skb+0x46/0x5d
>  [<ffffffff8049830b>] e1000_clean_rx_irq+0x20e/0x2a6
>  [<ffffffff8024cce8>] ? getnstimeofday+0x3f/0xa0
>  [<ffffffff804952ce>] e1000_clean+0x6d/0x218
>  [<ffffffff8024ad39>] ? hrtimer_get_next_event+0xa8/0xb8
>  [<ffffffff80583569>] net_rx_action+0xa9/0x17c
>  [<ffffffff80239b51>] __do_softirq+0x65/0xd5
>  [<ffffffff8020c5dc>] call_softirq+0x1c/0x28
>  [<ffffffff8020dd0a>] do_softirq+0x39/0x77
>  [<ffffffff80239aab>] irq_exit+0x44/0x85
>  [<ffffffff8020dff5>] do_IRQ+0x147/0x16a
>  [<ffffffff8020b8a1>] ret_from_intr+0x0/0xa

Dieter, can you please try this patch:

http://lkml.org/lkml/2008/7/24/186

Patrick, it looks like this could be the same bug Ingo is hitting?
