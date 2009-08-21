Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZHUCWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZHUCWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZHUCWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:22:35 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:53795 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZHUCWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <20090820164818.6039c185@worthy.swandive.local>
References: <20090820164818.6039c185@worthy.swandive.local>
Date: Thu, 20 Aug 2009 22:22:34 -0400
Message-ID: <7e0fb38c0908201922r6f9598f9ja95623ea6cf11254@mail.gmail.com>
Subject: Re: 2.6.31-rc6: Oops in fsnotify
From: Eric Paris <eparis@parisplace.org>
To: Grant Wilson <grant.wilson@zen.co.uk>, aviro@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>, eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll take a close look in the morning.  I don't offhand see how this
is possible without calling vfs_unlink on a negative dentry (does that
even make sense?)

What was the filesystem you are dealing with?  Odd, very, odd (as with
all the problems people find in my notify code)

-Eric

On Thu, Aug 20, 2009 at 11:48 AM, Grant Wilson<grant.wilson@zen.co.uk> wrote:
> Hi,
> Hit this oops while web-surfing:
>
> [485211.962472] BUG: unable to handle kernel NULL pointer dereference at (null)
> [485211.962488] IP: [<ffffffff8111bf93>] fsnotify+0x93/0x150
> [485211.962503] PGD 120c58067 PUD 120c3c067 PMD 0
> [485211.962518] Oops: 0000 [#1] PREEMPT SMP
> [485211.962537] last sysfs file: /sys/devices/platform/coretemp.3/temp1_input
> [485211.962544] CPU 0
> [485211.962553] Modules linked in:
> [485211.962614] Pid: 4889, comm: konqueror Not tainted 2.6.31-rc6 #1 Maximus Formula
> [485211.962619] RIP: 0010:[<ffffffff8111bf93>]  [<ffffffff8111bf93>] fsnotify+0x93/0x150
> [485211.962628] RSP: 0018:ffff880120c89d88  EFLAGS: 00010246
> [485211.962633] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [485211.962638] RDX: ffff88012b8aadcc RSI: 0000000000000000 RDI: ffff88012b8aadc8
> [485211.962643] RBP: ffff880120c89df8 R08: 0000000000000000 R09: 0000000000000001
> [485211.962648] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000200
> [485211.962653] R13: 0000000008000200 R14: ffff8801286bf760 R15: 0000000000000000
> [485211.962658] FS:  00007f10fd749750(0000) GS:ffff88002f000000(0000) knlGS:0000000000000000
> [485211.962663] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [485211.962668] CR2: 0000000000000000 CR3: 0000000120c59000 CR4: 00000000000026f0
> [485211.962673] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [485211.962679] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [485211.962684] Process konqueror (pid: 4889, threadinfo ffff880120c88000, task ffff880120c80000)
> [485211.962689] Stack:
> [485211.962693]  ffff8801000000d0 0000000000000246 ffff880120c89dd8 0000000000000246
> [485211.962706] <0> ffff88004a0295e0 000000024a029508 0000000000000000 ffff8800634d3be0
> [485211.962723] <0> 0000000000000200 ffff88012278f800 ffff8801286bf760 ffff88004a029500
> [485211.962742] Call Trace:
> [485211.962749]  [<ffffffff8111c232>] __fsnotify_parent+0xb2/0x110
> [485211.962757]  [<ffffffff810fee4f>] d_delete+0xaf/0xe0
> [485211.962763]  [<ffffffff810f51e4>] vfs_unlink+0xe4/0xf0
> [485211.962770]  [<ffffffff810f75ab>] do_unlinkat+0x18b/0x1c0
> [485211.962778]  [<ffffffff8102e5fa>] ? sysret_check+0x2e/0x69
> [485211.962786]  [<ffffffff81095d6d>] ? trace_hardirqs_on_caller+0x14d/0x1a0
> [485211.962795]  [<ffffffff815849c6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [485211.962897]  [<ffffffff810f75f1>] sys_unlink+0x11/0x20
> [485211.962904]  [<ffffffff8102e5c2>] system_call_fastpath+0x16/0x1b
> [485211.962909] Code: f0 4c 8b 7d f8 c9 c3 90 48 c7 c7 60 b3 3f 82 e8 94 ce f6 ff 48 8b 1d 3d b5 6d 00 89 45 ac 48 c7 45 c8 00 00 00 00 eb 03 48 8b 1b <48> 8b 03 48 81 fb c0 74 7
> f 81 0f 18 08 74 36 44 85 63 10 74 e8
> [485211.963003] RIP  [<ffffffff8111bf93>] fsnotify+0x93/0x150
> [485211.963003]  RSP <ffff880120c89d88>
> [485211.963003] CR2: 0000000000000000
> [485211.964056] ---[ end trace 28e6054427343f5a ]---
>
> Current config available at http://swandive.no-ip.com/linux/config
>
> Cheers,
> Grant
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
