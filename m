Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZIPNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZIPNkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZIPNk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZIPNk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:40:28 -0400
Subject: Re: [GIT] security / creds fixes
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090916130224.GA27519@elte.hu>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
	 <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
	 <20090916130224.GA27519@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 09:38:34 -0400
Message-Id: <1253108314.5213.109.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 15:02 +0200, Ingo Molnar wrote:
> i'm still getting crashes even with latest -git [0cb583f]:

This is something totally different, not quite sure since my system
doesn't reproduce it.  It's doesn't look like the problem I ran into
where SLUB couldn't call kmem_cache_destroy at all.  I'll build with
your config.  I have an idea, I assume this is an SMP machine?

-Eric

> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
> async_waiting @ 1
> async_continuing @ 1 after 0 usec
> debug: unmapping init memory ffffffff81f1e000..ffffffff81fb1000
> SELinux:  Disabled at runtime.
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
> PGD 0 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: 
> CPU 1 
> Modules linked in:
> Pid: 12, comm: khelper Not tainted 2.6.31-tip-05525-g0eeacc6-dirty #14819 System Product Name
> RIP: 0010:[<ffffffff81122537>]  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
> RSP: 0018:ffff88003f9258b0  EFLAGS: 00010086
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000078c0129e
> RDX: 0000000000000000 RSI: ffffffff8130b626 RDI: ffffffff81122528
> RBP: ffff88003f925900 R08: 0000000078c0129e R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000078c0129e R12: 0000000000000246
> R13: 0000000000008020 R14: ffff88003f8586d8 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff880002b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: ffffffff827bd420 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process khelper (pid: 12, threadinfo ffff88003f924000, task ffff88003f928000)
> Stack:
>  0000000000000246 0000802000000246 ffffffff8130b626 0000000000000001
> <0> 0000000078c0129e 0000000000000000 ffff88003f925a70 0000000000000002
> <0> 0000000000000001 0000000000000001 ffff88003f925960 ffffffff8130b626
> Call Trace:
>  [<ffffffff8130b626>] ? avc_alloc_node+0x36/0x273
>  [<ffffffff8130b626>] avc_alloc_node+0x36/0x273
>  [<ffffffff8130b545>] ? avc_latest_notif_update+0x7d/0x9e
>  [<ffffffff8130b8b4>] avc_insert+0x51/0x18d
>  [<ffffffff8130bcce>] avc_has_perm_noaudit+0x9d/0x128
>  [<ffffffff8130bf20>] avc_has_perm+0x45/0x88
>  [<ffffffff8130f99d>] current_has_perm+0x52/0x6d
>  [<ffffffff8130fbb2>] selinux_task_create+0x2f/0x45
>  [<ffffffff81303bf7>] security_task_create+0x29/0x3f
>  [<ffffffff8105c6ba>] copy_process+0x82/0xdf0
>  [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
>  [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
>  [<ffffffff8105d596>] do_fork+0x16e/0x382
>  [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
>  [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
>  [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
>  [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
>  [<ffffffff8100cdb2>] kernel_thread+0x82/0xe0
>  [<ffffffff81078b1f>] ? ____call_usermodehelper+0x0/0x139
>  [<ffffffff8100ce10>] ? child_rip+0x0/0x20
>  [<ffffffff81078aea>] ? __call_usermodehelper+0x65/0x9a
>  [<ffffffff8107a5c7>] run_workqueue+0x171/0x27e
>  [<ffffffff8107a573>] ? run_workqueue+0x11d/0x27e
>  [<ffffffff81078a85>] ? __call_usermodehelper+0x0/0x9a
>  [<ffffffff8107a7bc>] worker_thread+0xe8/0x10f
>  [<ffffffff810808e2>] ? autoremove_wake_function+0x0/0x63
>  [<ffffffff8107a6d4>] ? worker_thread+0x0/0x10f
>  [<ffffffff8108042e>] kthread+0x91/0x99
>  [<ffffffff8100ce1a>] child_rip+0xa/0x20
>  [<ffffffff8100c754>] ? restore_args+0x0/0x30
>  [<ffffffff8108039d>] ? kthread+0x0/0x99
>  [<ffffffff8100ce10>] ? child_rip+0x0/0x20
> Code: 0f 85 99 00 00 00 9c 58 66 66 90 66 90 49 89 c4 fa 66 66 90 66 66 90 e8 83 34 fb ff e8 d7 e9 26 00 48 98 49 8b 94 c6 10 01 00 00 <48> 8b 1a 44 8b 7a 18 48 85 db 74 0f 8b 42 14 48 8b 04 c3 ff 42 
> RIP  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
>  RSP <ffff88003f9258b0>
> CR2: 0000000000000000
> ---[ end trace 42f41a982344e606 ]---
> Kernel panic - not syncing: Fatal exception
> 
> config and full crashlog attached as well.
> 
> 	Ingo


