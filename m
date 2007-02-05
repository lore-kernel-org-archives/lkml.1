Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXBELXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXBELXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbXBELXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:23:12 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:43355 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbXBELXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:23:11 -0500
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 06:23:11 EST
Date: Mon, 5 Feb 2007 12:08:29 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.19.2, 2.6.20 Kernel oops
Message-ID: <20070205110829.GC22820@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

playing with my java application that sends data into network I got the
following oops. I got also similar oops in interrupt handler but such
situation results in kernel panic so I'm unable to provide exact oops,
however, it also crashes in page_to_pfn.

kernel: [  222.002013] CPU 0
kernel: [  222.002014] Modules linked in: container fan button ac thermal processor myri10ge megaraid_sas serio_raw psmouse evdev
kernel: [  222.002020] Pid: 3234, comm: java Not tainted 2.6.20 #1
kernel: [  222.002021] RIP: 0010:[page_to_pfn+0/64] [page_to_pfn+0/64] page_to_pfn+0x0/0x40
kernel: [  222.002024] RSP: 0018:ffff81024ebf9ac0 EFLAGS: 00010246
kernel: [  222.002026] RAX: ffff8102574213c0 RBX: ffff810256f07800 RCX: ffff81022e5600c0
kernel: [  222.002027] RDX: 0000000000000740 RSI: 0000000000000000 RDI: 0000000000000000
kernel: [  222.002028] RBP: 0000000000000740 R08: 0000000000000002 R09: ffff8102536b9a40
kernel: [  222.002030] R10: 0000000000000007 R11: ffffffff80259650 R12: 0000000000000000
kernel: [  222.002031] R13: ffff810257422460 R14: 0000000000000002 R15: ffff81022e5600c0
kernel: [  222.002033] FS:  0000000041061950(0063) GS:ffffffff80649000(0000) knlGS:0000000000000000
kernel: [  222.002034] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: [  222.002036] CR2: 0000000000000000 CR3: 0000000251dbb000 CR4: 00000000000006e0
kernel: [  222.002037] Process java (pid: 3234, threadinfo ffff81024ebf8000, task ffff81024ebdc7a0)
kernel: [  222.002038] Stack:  ffffffff804c4f77 ffff810257422400 0000000000000002 ffff81024ebf9f28
kernel: [  222.002042]  fffffffffffff240 0000000000000740 ffff810257422460 0000000000000002
kernel: [  222.002044]  ffffffff804c3ba5 0000000000000010 ffff81022e5600c0 ffff8102536b9a40
kernel: [  222.002046] Call Trace:
kernel: [  222.002051] [ioat_dma_memcpy_buf_to_pg+71/224] ioat_dma_memcpy_buf_to_pg+0x47/0xe0
kernel: [  222.002053]  [dma_memcpy_to_iovec+613/768] dma_memcpy_to_iovec+0x265/0x300
kernel: [  222.002057] [dma_skb_copy_datagram_iovec+115/656] dma_skb_copy_datagram_iovec+0x73/0x290
kernel: [  222.002060]  [tcp_recvmsg+1764/3296] tcp_recvmsg+0x6e4/0xce0
kernel: [  222.002063]  [sock_common_recvmsg+48/80] sock_common_recvmsg+0x30/0x50
kernel: [  222.002065]  [sock_recvmsg+281/352] sock_recvmsg+0x119/0x160
kernel: [  222.002069]  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
kernel: [  222.002071]  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
kernel: [  222.002073]  [__handle_mm_fault+1741/2896] __handle_mm_fault+0x6cd/0xb50
kernel: [  222.002076]  [sys_recvfrom+250/400] sys_recvfrom+0xfa/0x190
kernel: [  222.002078]  [tty_ldisc_deref+100/128] tty_ldisc_deref+0x64/0x80
kernel: [  222.002080]  [tty_write+540/592] tty_write+0x21c/0x250
kernel: [  222.002083]  [system_call+126/131] system_call+0x7e/0x83
kernel: [  222.002084]
kernel: [  222.002085]
kernel: [  222.002085] Code: 48 8b 07 48 c1 e8 3a 48 8b 14 c5 80 b8 65 80 48 b8 b7 6d db
kernel: [  222.002092]  RSP <ffff81024ebf9ac0>


-- 
Luká¹ Hejtmánek
