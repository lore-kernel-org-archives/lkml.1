Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXGHIUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXGHIUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGHIUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:20:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbXGHIUg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:20:36 -0400
Date: Sun, 8 Jul 2007 01:20:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1-cfs-v19 Unable to handle kernel NULL pointer
 dereference (reproducable)
Message-Id: <20070708012016.455ce8d5.akpm@linux-foundation.org>
In-Reply-To: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007 07:14:52 +0200 Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> Just got this oops while I was updating my system:
> 
> Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP:
>  [<ffffffff802861b6>] vfs_permission+0x6/0x10
> PGD 120f9067 PUD 4f5ec067 PMD 0
> Oops: 0000 [1] SMP
> CPU 0
> Pid: 14067, comm: touch Not tainted 2.6.22-rc6-mm1-cfs-v19 #7
> RIP: 0010:[<ffffffff802861b6>]  [<ffffffff802861b6>] vfs_permission+0x6/0x10
> RSP: 0018:ffff8100083a7e20  EFLAGS: 00010293
> RAX: 0000000000000296 RBX: 0000000000000000 RCX: ffff81001cb6ee00
> RDX: ffff8100083a7e28 RSI: 0000000000000002 RDI: ffff8100083a7e28
> RBP: 00000000fffffff3 R08: 0000000000000002 R09: 00002b70e16872b8
> R10: 0000000000000000 R11: 0000000000000246 R12: ffff81001cb6ee00
> R13: ffff81006396e828 R14: ffff81000c35da28 R15: 0000000000000002
> FS:  00002b70e23fbd10(0000) GS:ffffffff8061b000(0000) knlGS:00000000f6ca96c0
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000002a6 CR3: 000000001ca29000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process touch (pid: 14067, threadinfo ffff8100083a6000, task ffff81001c589620)
> Stack:  ffffffff802a15e0 0000000000000296 ffffffff8021d9c0 00000000000001b6
>  ffff81001cb6ee00 ffff81006396e828 0000000000000000 00002b70e1d66850
>  0000000000000004 ffff8100083a7f58 ffff81001c589620 0000000000000000
> Call Trace:
>  [<ffffffff802a15e0>] do_utimes+0x230/0x250
>  [<ffffffff8021d9c0>] do_page_fault+0x420/0x8a0
>  [<ffffffff8027ca8a>] do_filp_open+0x3a/0x50
>  [<ffffffff802a1707>] sys_utimensat+0x37/0xe0
>  [<ffffffff8051bb8d>] error_exit+0x0/0x84
>  [<ffffffff8020bc5e>] system_call+0x7e/0x83
> 
> 
> Code: 48 8b 78 10 e9 d1 fd ff ff 90 53 48 89 fb 48 8d bf b4 00 00
> RIP  [<ffffffff802861b6>] vfs_permission+0x6/0x10
>  RSP <ffff8100083a7e20>
> CR2: 00000000000002a6
> 
> I was running the »paludis« package manager: 
> 
> make[1]: Leaving directory `/var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/contrib'
> >>> Done src_compile
> >>> Skipping src_test (SKIP_FUNCTIONS)
> >>> Starting builtin_saveenv
> >>> Done builtin_saveenv
> >>> Completed ebuild phases loadenv unpack compile test saveenv
> >>> Running ebuild phases loadenv install saveenv as root:root...
> >>> Starting builtin_loadenv
> >>> Done builtin_loadenv
> >>> Starting src_install
> touch src/.depend # to prevent unecessary warnings
> make: *** [dep] Killed

ug.  nd.dentry.d_inode (as set up by do_utimes()) is garbage.  I don't know
what could have caused that.


> Running "touch  /var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/src/.depend" 
> triggers this oops.

What type of filesystem is at /var/tmp?

Is it repeatable after a reboot?


