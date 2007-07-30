Return-Path: <linux-kernel-owner+w=401wt.eu-S967783AbXG3SdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967783AbXG3SdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXG3SdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:33:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965646AbXG3SdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:33:13 -0400
Date: Mon, 30 Jul 2007 11:27:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Grant Wilson" <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.23-rc1-mm1
Message-Id: <20070730112720.cdc6a8c4.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0707300258k4ee5ed93yadd9e87af45b9330@mail.gmail.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<20070729164946.0b86a414@the-diner.swandive.local>
	<a8e1da0707300258k4ee5ed93yadd9e87af45b9330@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 09:58:34 +0000
"Dave Young" <hidave.darkstar@gmail.com> wrote:

> > Hi,
> > I get an oops when trying to mount an ISO file using the loopback device.
> > If I revert the patch 'loop-use-unlocked_ioctl.patch' the mount works.
> >
> > Here's the oops:
> >
> > [   85.697033] Unable to handle kernel NULL pointer dereference at 0000000000000100 RIP:
> > [   85.702528]  [<ffffffff80477885>] lo_ioctl+0x25/0xaa0
> > [   85.710066] PGD 73fd067 PUD 735b067 PMD 0
> > [   85.714221] Oops: 0000 [1] PREEMPT SMP
> > [   85.718117] CPU 1
> > [   85.720159] Modules linked in:
> > [   85.723242] Pid: 3976, comm: mount Not tainted 2.6.23-rc1-mm1 #4
> > [   85.729247] RIP: 0010:[<ffffffff80477885>]  [<ffffffff80477885>] lo_ioctl+0x25/0xaa0
> > [   85.737011] RSP: 0018:ffff8100076a3708  EFLAGS: 00010282
> > [   85.742326] RAX: ffffffff80477860 RBX: 00000000fffffdfd RCX: 0000000000005310
> > [   85.749459] RDX: ffff8100076a3b58 RSI: 0000000000005310 RDI: 0000000000000000
> > [   85.756591] RBP: ffff8100076a3908 R08: ffff8100076a3b58 R09: ffff81000649da80
> > [   85.763723] R10: 0000000000000000 R11: 2222222222222222 R12: 0000000000005310
> > [   85.770856] R13: ffff8100076a3b58 R14: 0000000000005310 R15: 0000000000000000
> > [   85.777988] FS:  00002b4fab3a0e20(0000) GS:ffff810004017180(0000) knlGS:0000000000000000
> > [   85.786081] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   85.791829] CR2: 0000000000000100 CR3: 00000000073d7000 CR4: 00000000000006e0
> > [   85.798970] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   85.806102] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   85.813235] Process mount (pid: 3976, threadinfo ffff8100076a2000, task ffff8100062f66d0)
> > [   85.821413] Stack:  0000000200000001 ffff8100062f6e90 ffff8100062f6e90 000000000013638a
> > [   85.829533]  ffffffff80a78ef0 0000000000000000 ffff8100076a37b8 ffffffff8025c690
> > [   85.837020]  ffff8100062f66d0 ffff8100062f6e58 0000000200000001 0000000000000000
> > [   85.844308] Call Trace:
> > [   85.846961]  [<ffffffff8025c690>] __lock_acquire+0x3d0/0x1170
> > [   85.852715]  [<ffffffff8025baee>] mark_held_locks+0x3e/0x80
> > [   85.858290]  [<ffffffff8064ff0a>] __mutex_lock_slowpath+0x1ca/0x330
> > [   85.864565]  [<ffffffff8025baee>] mark_held_locks+0x3e/0x80
> > [   85.870139]  [<ffffffff8064fd39>] mutex_unlock+0x9/0x10
> > [   85.875366]  [<ffffffff8064fc69>] __mutex_unlock_slowpath+0xd9/0x1a0
> > [   85.881720]  [<ffffffff8025bcca>] trace_hardirqs_on+0xda/0x180
> > [   85.887555]  [<ffffffff8064fd39>] mutex_unlock+0x9/0x10
> > [   85.892782]  [<ffffffff802c3ba1>] do_open+0x231/0x320
> > [   85.897839]  [<ffffffff803b7113>] blkdev_driver_ioctl+0x43/0x90
> > [   85.903758]  [<ffffffff803b7429>] blkdev_ioctl+0x2c9/0x780
> > [   85.909247]  [<ffffffff8065149d>] trace_hardirqs_on_thunk+0x35/0x37
> > [   85.915522]  [<ffffffff8020c320>] restore_args+0x0/0x30
> > [   85.920751]  [<ffffffff802c2d60>] kill_bdev+0x0/0x40
> > [   85.925718]  [<ffffffff802c4084>] ioctl_by_bdev+0x34/0x50
> > [   85.931119]  [<ffffffff80336019>] isofs_fill_super+0x969/0xaf0
> > [   85.936954]  [<ffffffff80299b9c>] sget+0x3c/0x3f0
> > [   85.941662]  [<ffffffff80299760>] test_bdev_super+0x0/0x20
> > [   85.947150]  [<ffffffff80651fc0>] _spin_unlock+0x30/0x60
> > [   85.952464]  [<ffffffff80299760>] test_bdev_super+0x0/0x20
> > [   85.957951]  [<ffffffff80299f4a>] sget+0x3ea/0x3f0
> > [   85.962747]  [<ffffffff803c662f>] strlcpy+0x4f/0x70
> > [   85.967628]  [<ffffffff8029aa9c>] get_sb_bdev+0x15c/0x190
> > [   85.973029]  [<ffffffff803356b0>] isofs_fill_super+0x0/0xaf0
> > [   85.978693]  [<ffffffff80334fb3>] isofs_get_sb+0x13/0x20
> > [   85.984006]  [<ffffffff8029a4c8>] vfs_kern_mount+0x58/0xc0
> > [   85.989494]  [<ffffffff802b2366>] do_mount+0x206/0x850
> > [   85.994635]  [<ffffffff8027b891>] __mod_zone_page_state+0x21/0x90
> > [   86.000729]  [<ffffffff80273160>] rmqueue_bulk+0x90/0xb0
> > [   86.006043]  [<ffffffff80651fc0>] _spin_unlock+0x30/0x60
> > [   86.011358]  [<ffffffff80273160>] rmqueue_bulk+0x90/0xb0
> > [   86.016673]  [<ffffffff80274425>] get_page_from_freelist+0x395/0x500
> > [   86.023026]  [<ffffffff8025bcca>] trace_hardirqs_on+0xda/0x180
> > [   86.028860]  [<ffffffff802742b3>] get_page_from_freelist+0x223/0x500
> > [   86.035213]  [<ffffffff80274639>] __alloc_pages+0x59/0x3a0
> > [   86.040702]  [<ffffffff80246d68>] sigprocmask+0x38/0xf0
> > [   86.045929]  [<ffffffff802940e8>] kmem_cache_alloc+0x98/0xd0
> > [   86.051590]  [<ffffffff80274a00>] __get_free_pages+0x80/0x90
> > [   86.057251]  [<ffffffff802b2a44>] sys_mount+0x94/0xf0
> > [   86.062305]  [<ffffffff8065149d>] trace_hardirqs_on_thunk+0x35/0x37
> > [   86.068572]  [<ffffffff8020bd7e>] system_call+0x7e/0x83
> > [   86.073799]
> > [   86.075296] INFO: lockdep is turned off.
> > [   86.079226]
> > [   86.079227] Code: 48 8b 87 00 01 00 00 49 89 d6 48 8b 18 48 8b 83 10 03 00 00
> > [   86.088306] RIP  [<ffffffff80477885>] lo_ioctl+0x25/0xaa0
> > [   86.093734]  RSP <ffff8100076a3708>
> > [   86.097231] CR2: 0000000000000100
> >
> 
> Hi, andrew,
> I debugged this problem. The oops is caused by NUll file pointer.
> 
> I change the unlocked_ioctl to ioctl  in fops.  print some debug info :
>  [   51.018272] hidave ### cmd : get_status
> [   51.018281] hidave ### cmd : 19459 inode : c2024b9c file : c2e89c00
> [   51.052419] hidave ### cmd : set_fd
> [   51.052426] hidave ### cmd : 19456 inode : c2024b9c file : c2e89100
> [   51.052494] hidave ### cmd : set_status64
> [   51.052500] hidave ### cmd : 19460 inode : c2024b9c file : c2e89100
> [   51.125241] hidave ### cmd : unknown
> >>(The 21264 cmd is a cdrom ioctl command.)
> [   51.125248] hidave ### cmd : 21264 inode : c2024b9c file : 00000000
> >>if use ioctl interface the inode is transfered, but in the
> unlocked_ioctl interface only  the file pointer is transfered, so NULL
> caused the panic.
> 
> PS: I noticed the fs/block_dev.c: line 1374:
> res = blkdev_ioctl(bdev->bd_inode, NULL, cmd, arg);
> 
> So, just changeback  from unlocked_ioctl to ioctl, the lock_kernel
> remove is still ok.

ho hum, crap.  Yes, ioctl_by_bdev() doesn't have a file* and so it makes
unlocked_ioctl() rather tricky.  We could cook up a `struct file' on the
stack (we do that in various places), but that sucks.

Christoph, have you any clever suggestions?

Thanks.


From: Andrew Morton <akpm@linux-foundation.org>

The last lock_kernel() has disappeared from loop.c.  Switch it over to using
unlocked_ioctl.

Cc: Diego Woitasen <diego@woitasen.com.ar>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/block/loop.c~loop-use-unlocked_ioctl drivers/block/loop.c
--- a/drivers/block/loop.c~loop-use-unlocked_ioctl
+++ a/drivers/block/loop.c
@@ -1124,12 +1124,14 @@ loop_get_status64(struct loop_device *lo
 	return err;
 }
 
-static int lo_ioctl(struct inode * inode, struct file * file,
-	unsigned int cmd, unsigned long arg)
+static long lo_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
+	struct inode *inode;
+	struct loop_device *lo;
 	int err;
 
+	inode = file->f_mapping->host;
+	lo = inode->i_bdev->bd_disk->private_data;
 	mutex_lock(&lo->lo_ctl_mutex);
 	switch (cmd) {
 	case LOOP_SET_FD:
@@ -1304,7 +1306,7 @@ static long lo_compat_ioctl(struct file 
 		arg = (unsigned long) compat_ptr(arg);
 	case LOOP_SET_FD:
 	case LOOP_CHANGE_FD:
-		err = lo_ioctl(inode, file, cmd, arg);
+		err = lo_ioctl(file, cmd, arg);
 		break;
 	default:
 		err = -ENOIOCTLCMD;
@@ -1340,7 +1342,7 @@ static struct block_device_operations lo
 	.owner =	THIS_MODULE,
 	.open =		lo_open,
 	.release =	lo_release,
-	.ioctl =	lo_ioctl,
+	.unlocked_ioctl = lo_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	lo_compat_ioctl,
 #endif
_

