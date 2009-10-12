Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZJLJVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZJLJVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZJLJVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:21:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbZJLJVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:21:49 -0400
Date: Mon, 12 Oct 2009 11:19:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012091954.GA31171@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012080511.GA22607@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> here's a new crash i havent seen before:
> 
> modprobe used greatest stack depth: 3416 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
> IP: [<ffffffff812e9ccb>] uart_close+0x2a/0x1e4
> PGD 774b8067 PUD 774b6067 PMD 0 
> Oops: 0000 [#1] DEBUG_PAGEALLOC
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 1107, comm: hwclock Not tainted 2.6.32-rc3-tip #8181 System Product Name
> RIP: 0010:[<ffffffff812e9ccb>]  [<ffffffff812e9ccb>] uart_close+0x2a/0x1e4
> RSP: 0018:ffff88007754fb88  EFLAGS: 00010246
> RAX: ffffffff812e9ca1 RBX: ffff8800774bcc80 RCX: 0000000000000000
> RDX: ffff88007b320900 RSI: ffff8800774bcc80 RDI: ffff88007b3bb000
> RBP: ffff88007754fbb8 R08: ffff88007754fab8 R09: ffffffff8103f397
> R10: 0000000000000246 R11: ffffffff812c1981 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff88007b3bb000 R15: 0000000000000000
> FS:  00007f7a51c4c6f0(0000) GS:ffffffff81b38000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000240 CR3: 00000000774c2000 CR4: 00000000000026f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process hwclock (pid: 1107, threadinfo ffff88007754e000, task ffff88007a4e8000)
> Stack:
>  ffff88007754fbb8 ffff88007b3bb000 0000000000000000 00000000fffffffa
> <0> 0000000000000000 0000000000000000 ffff88007754fc98 ffffffff812c3976
> <0> ffff88007754fbf8 0000000000000246 ffff88007b338150 ffff88007b338000
> Call Trace:
>  [<ffffffff812c3976>] tty_release_dev+0x1ca/0x4d8
>  [<ffffffff817718fe>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81773725>] ? _spin_unlock+0x2b/0x2f
>  [<ffffffff812c4235>] tty_open+0x33f/0x41d
>  [<ffffffff81117245>] chrdev_open+0x179/0x19a
>  [<ffffffff8111285a>] __dentry_open+0x1cf/0x2f9
>  [<ffffffff811170cc>] ? chrdev_open+0x0/0x19a
>  [<ffffffff811137e4>] nameidata_to_filp+0x45/0x56
>  [<ffffffff811200fa>] do_filp_open+0x58a/0xa39
>  [<ffffffff81094f37>] ? __lock_acquire+0x8f5/0x95a
>  [<ffffffff8103f3d6>] ? native_sched_clock+0x3b/0x52
>  [<ffffffff811294b8>] ? alloc_fd+0x110/0x11f
>  [<ffffffff81773725>] ? _spin_unlock+0x2b/0x2f
>  [<ffffffff811294b8>] ? alloc_fd+0x110/0x11f
>  [<ffffffff81112598>] do_sys_open+0x62/0x109
>  [<ffffffff81112672>] sys_open+0x20/0x22
>  [<ffffffff81038dff>] system_call_fastpath+0x16/0x1b
> Code: c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 f6 05 9d 2e 55 01 08 4c 8b af 28 04 00 00 49 89 fe 48 89 f3 <4d> 8b bd 40 02 00 00 74 16 f6 05 87 2e 55 01 40 74 0d 80 3d 33 
> RIP  [<ffffffff812e9ccb>] uart_close+0x2a/0x1e4
>  RSP <ffff88007754fb88>
> CR2: 0000000000000240
> ---[ end trace 16e4ef47b9d6effc ]---
> sky2 eth0: enabling interface
> 
> Note, i have your fix below applied in tip:out-of-tree - it might be the 
> source of this bug? (If yes then this isnt an .32-rc4 problem.)
> 
> ---------------------->
> From 3fafdd6fb57253362575d61e8e2a5c915ccb62fb Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 1 Oct 2009 17:05:18 -0700
> Subject: [PATCH] tty: Fix "WARNING: at drivers/char/tty_io.c:1267"

i've reverted this and the crash is still there:

Call Trace:
 [<ffffffff812c3ece>] tty_release_dev+0x1ca/0x4d8
 [<ffffffff81772e5e>] ? mutex_unlock+0xe/0x10
 [<ffffffff81774cd5>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff812c478d>] tty_open+0x33f/0x41d
 [<ffffffff811174a1>] chrdev_open+0x179/0x19a
 [<ffffffff81112a8a>] __dentry_open+0x1cf/0x2f9
 [<ffffffff81117328>] ? chrdev_open+0x0/0x19a
 [<ffffffff81113a14>] nameidata_to_filp+0x45/0x56
 [<ffffffff8112035a>] do_filp_open+0x58a/0xa39
 [<ffffffff8103f3ce>] ? native_sched_clock+0x3b/0x52
 [<ffffffff8103f38f>] ? sched_clock+0x17/0x1b
 [<ffffffff8108c06e>] ? cpu_clock+0x41/0x5b
 [<ffffffff8112971c>] ? alloc_fd+0x110/0x11f
 [<ffffffff81774cd5>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8112971c>] ? alloc_fd+0x110/0x11f
 [<ffffffff811127c8>] do_sys_open+0x62/0x109
 [<ffffffff811128a2>] sys_open+0x20/0x22
 [<ffffffff81038dff>] system_call_fastpath+0x16/0x1b
Code: c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 
00 f6 05 31 29 55 01 08 4c 8b af 28 04 00 00 49 89 fe 48 89 f3 <4d> 8b 
bd 40 02 00 00 74 16 f6 05 1b 29 55 01 40 74 0d 80 3d e7   
RIP  [<ffffffff812ea237>] uart_close+0x2a/0x1e4
 RSP <ffff88007709bb88>
CR2: 0000000000000240
---[ end trace 7a94f79b2992f19c ]---

	Ingo
