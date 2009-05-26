Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZEZBwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZEZBwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZEZBv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:51:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:47099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZEZBv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:51:59 -0400
Message-ID: <4A1B4AEF.1000804@kernel.org>
Date: Mon, 25 May 2009 18:50:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de> <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain> <4A1AE5CC.1000209@cs.helsinki.fi> <alpine.LFD.2.01.0905251212250.3435@localhost.localdomain> <4A1AEDD6.90404@cs.helsinki.fi>
In-Reply-To: <4A1AEDD6.90404@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trying to put setup_percpu_areas() after mem_init/kmem_cache_init...

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=summary
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git

based on tip/master, on AMD 8 sockets, NUMA + SLUB.

got

[   49.962048] Freeing unused kernel memory: 2564k freed
INIT: [   49.984095] BUG: unable to handle kernel paging request at ffff888687090860
[   49.988020] IP: [<ffffffff81135249>] __slab_free+0x61/0x2ee
[   49.988020] PGD a067 PUD 0 
[   49.988020] Oops: 0002 [#1] SMP 
[   49.988020] last sysfs file: 
[   49.988020] CPU 0 
[   49.988020] Modules linked in:
[   49.988020] Pid: 1, comm: init Not tainted 2.6.30-rc7-tip-01641-g4c0d14e-dirty #285 Sun Fire X4600 M2
[   49.988020] RIP: 0010:[<ffffffff81135249>]  [<ffffffff81135249>] __slab_free+0x61/0x2ee
[   49.988020] RSP: 0018:ffff888021be5a08  EFLAGS: 00010046
[   49.988020] RAX: 00000000cccccccc RBX: ffffffff8251ce60 RCX: ffffffff81185e56
[   49.988020] RDX: 0000000000000000 RSI: ffffea0340d42110 RDI: ffffffff82247000
[   49.988020] RBP: ffff888021be5a58 R08: 00000000cccccccc R09: 0000000000000000
[   49.988020] R10: ffff885021be6200 R11: 000000002cce478a R12: ffffea0340d42110
[   49.988020] R13: ffff888020a2a200 R14: ffffffff82247000 R15: ffffffff82247000
[   49.988020] FS:  00000000006d1880(0063) GS:ffffc90000000000(0000) knlGS:0000000000000000
[   49.988020] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   49.988020] CR2: ffff888687090860 CR3: 0000001020576000 CR4: 00000000000006f0
[   49.988020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.988020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   49.988020] Process init (pid: 1, threadinfo ffff888021be4000, task ffff887021be8000)
[   49.988020] Stack:
[   49.988020]  ffff888021be5a58 cccccccc810ae203 ffffffff81185e56 000000002cce478a
[   49.988020]  000000002cce478a ffffffff8251ce60 ffffea0340d42110 ffff888020a2a200
[   49.988020]  0000000000000286 ffffffff82247000 ffff888021be5aa8 ffffffff8113603d
[   49.988020] Call Trace:
[   49.988020]  [<ffffffff81185e56>] ? free_proc_entry+0x79/0x94
[   49.988020]  [<ffffffff8113603d>] kfree+0x10c/0x14a
[   49.988020]  [<ffffffff81185e56>] ? free_proc_entry+0x79/0x94
[   49.988020]  [<ffffffff81185e56>] free_proc_entry+0x79/0x94
[   49.988020]  [<ffffffff81186094>] remove_proc_entry+0x223/0x249
[   49.988020]  [<ffffffff810524d5>] ? mask_IO_APIC_irq_desc+0x36/0x112
[   49.988020]  [<ffffffff81a8a887>] ? _spin_unlock_irqrestore+0x50/0x76
[   49.988020]  [<ffffffff810acd60>] ? trace_hardirqs_off+0x20/0x36
[   49.988020]  [<ffffffff81a8a887>] ? _spin_unlock_irqrestore+0x50/0x76
[   49.988020]  [<ffffffff810add3b>] ? mark_held_locks+0x60/0x96
[   49.988020]  [<ffffffff81a8a88e>] ? _spin_unlock_irqrestore+0x57/0x76
[   49.988020]  [<ffffffff810ae065>] ? trace_hardirqs_on_caller+0x13b/0x17d
[   49.988020]  [<ffffffff810cef38>] unregister_handler_proc+0x46/0x61
[   49.988020]  [<ffffffff810cd36e>] __free_irq+0x135/0x191
[   49.988020]  [<ffffffff810cd3eb>] free_irq+0x21/0x3f
[   49.988020]  [<ffffffff814f3bee>] serial8250_shutdown+0x130/0x170
[   49.988020]  [<ffffffff814ef6c2>] uart_shutdown+0xd0/0x124
[   49.988020]  [<ffffffff814f0c41>] uart_close+0x14c/0x1f7
[   49.988020]  [<ffffffff814bbffa>] ? tty_fasync+0x11b/0x13e
[   49.988020]  [<ffffffff814befe7>] tty_release_dev+0x1d3/0x51c
[   49.988020]  [<ffffffff8113c5f2>] ? sys_close+0x45/0x112
[   49.988020]  [<ffffffff814bf35d>] tty_release+0x2d/0x4f
[   49.988020]  [<ffffffff8113fd24>] __fput+0xff/0x1d1
[   49.988020]  [<ffffffff8113fe26>] fput+0x30/0x46
[   49.988020]  [<ffffffff8113c58c>] filp_close+0x78/0x99
[   49.988020]  [<ffffffff81a8a8e7>] ? _spin_unlock+0x3a/0x55
[   49.988020]  [<ffffffff8113c66a>] sys_close+0xbd/0x112
[   49.988020]  [<ffffffff81034edb>] system_call_fastpath+0x16/0x1b
[   49.988020] Code: eb 09 f3 90 41 f6 04 24 01 75 f7 f0 41 0f ba 2c 24 00 19 c0 85 c0 75 ec 41 f6 04 24 02 0f 85 ae 00 00 00 8b 45 bc 49 8b 54 24 50 <49> 89 54 c5 00 41 8b 44 24 0c 4d 89 6c 24 50 8d 48 ff 49 8b 04 
[   49.988020] RIP  [<ffffffff81135249>] __slab_free+0x61/0x2ee
[   49.988020]  RSP <ffff888021be5a08>
[   49.988020] CR2: ffff888687090860
[   49.988020] ---[ end trace 4dde5b4c04e715b6 ]---
