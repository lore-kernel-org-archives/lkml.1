Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbXBFD5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbXBFD5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXBFD5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:57:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbXBFD5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:57:45 -0500
Date: Mon, 5 Feb 2007 19:57:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.19.2, 2.6.20 Kernel oops
Message-Id: <20070205195739.cabf67fa.akpm@linux-foundation.org>
In-Reply-To: <20070205110829.GC22820@mail.muni.cz>
References: <20070205110829.GC22820@mail.muni.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 12:08:29 +0100 Lukas Hejtmanek <xhejtman@mail.muni.cz> wrote:

> Hello,
> 
> playing with my java application that sends data into network I got the
> following oops. I got also similar oops in interrupt handler but such
> situation results in kernel panic so I'm unable to provide exact oops,
> however, it also crashes in page_to_pfn.
> 
> kernel: [  222.002013] CPU 0
> kernel: [  222.002014] Modules linked in: container fan button ac thermal processor myri10ge megaraid_sas serio_raw psmouse evdev
> kernel: [  222.002020] Pid: 3234, comm: java Not tainted 2.6.20 #1
> kernel: [  222.002021] RIP: 0010:[page_to_pfn+0/64] [page_to_pfn+0/64] page_to_pfn+0x0/0x40
> kernel: [  222.002024] RSP: 0018:ffff81024ebf9ac0 EFLAGS: 00010246
> kernel: [  222.002026] RAX: ffff8102574213c0 RBX: ffff810256f07800 RCX: ffff81022e5600c0
> kernel: [  222.002027] RDX: 0000000000000740 RSI: 0000000000000000 RDI: 0000000000000000
> kernel: [  222.002028] RBP: 0000000000000740 R08: 0000000000000002 R09: ffff8102536b9a40
> kernel: [  222.002030] R10: 0000000000000007 R11: ffffffff80259650 R12: 0000000000000000
> kernel: [  222.002031] R13: ffff810257422460 R14: 0000000000000002 R15: ffff81022e5600c0
> kernel: [  222.002033] FS:  0000000041061950(0063) GS:ffffffff80649000(0000) knlGS:0000000000000000
> kernel: [  222.002034] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: [  222.002036] CR2: 0000000000000000 CR3: 0000000251dbb000 CR4: 00000000000006e0
> kernel: [  222.002037] Process java (pid: 3234, threadinfo ffff81024ebf8000, task ffff81024ebdc7a0)
> kernel: [  222.002038] Stack:  ffffffff804c4f77 ffff810257422400 0000000000000002 ffff81024ebf9f28
> kernel: [  222.002042]  fffffffffffff240 0000000000000740 ffff810257422460 0000000000000002
> kernel: [  222.002044]  ffffffff804c3ba5 0000000000000010 ffff81022e5600c0 ffff8102536b9a40
> kernel: [  222.002046] Call Trace:
> kernel: [  222.002051] [ioat_dma_memcpy_buf_to_pg+71/224] ioat_dma_memcpy_buf_to_pg+0x47/0xe0
> kernel: [  222.002053]  [dma_memcpy_to_iovec+613/768] dma_memcpy_to_iovec+0x265/0x300
> kernel: [  222.002057] [dma_skb_copy_datagram_iovec+115/656] dma_skb_copy_datagram_iovec+0x73/0x290
> kernel: [  222.002060]  [tcp_recvmsg+1764/3296] tcp_recvmsg+0x6e4/0xce0
> kernel: [  222.002063]  [sock_common_recvmsg+48/80] sock_common_recvmsg+0x30/0x50
> kernel: [  222.002065]  [sock_recvmsg+281/352] sock_recvmsg+0x119/0x160
> kernel: [  222.002069]  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
> kernel: [  222.002071]  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
> kernel: [  222.002073]  [__handle_mm_fault+1741/2896] __handle_mm_fault+0x6cd/0xb50
> kernel: [  222.002076]  [sys_recvfrom+250/400] sys_recvfrom+0xfa/0x190
> kernel: [  222.002078]  [tty_ldisc_deref+100/128] tty_ldisc_deref+0x64/0x80
> kernel: [  222.002080]  [tty_write+540/592] tty_write+0x21c/0x250
> kernel: [  222.002083]  [system_call+126/131] system_call+0x7e/0x83
> kernel: [  222.002084]
> kernel: [  222.002085]
> kernel: [  222.002085] Code: 48 8b 07 48 c1 e8 3a 48 8b 14 c5 80 b8 65 80 48 b8 b7 6d db
> kernel: [  222.002092]  RSP <ffff81024ebf9ac0>
> 

Is that the whole oops message?  There should have been a few interesting
lines preceding the above.

We went splat in
ioat_dma_memcpy_buf_to_pg->pci_map_page->lowmem_page_address->page_to_pfn.

I'm not sure how you can oops on the first instruction of page_to_pfn(). 
Maybe a trashed stack pointer?  Seeing the first part of the oops message
will help.


