Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXJWMzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXJWMzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXJWMyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:54:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25339 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXJWMyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:54:53 -0400
Date: Tue, 23 Oct 2007 14:53:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel NULL pointer dereference in blk_rq_map_sg with
	v2.6.23-6815-g0895e91
Message-ID: <20071023125326.GX5059@kernel.dk>
References: <20071023124637.GJ7918@iucha.net> <20071023125016.GK7918@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023125016.GK7918@iucha.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Florin Iucha wrote:
> On Tue, Oct 23, 2007 at 07:46:37AM -0500, Florin Iucha wrote:
> > [   60.656136] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> > [   60.656143]  [<ffffffff80375553>] blk_rq_map_sg+0x10d/0x17c
> > [   60.656151] PGD 4640067 PUD 46d4067 PMD 0 
> > [   60.656154] Oops: 0000 [1] SMP 
> > [   60.656157] CPU 1 
> > ...
> 
> There was a DVD in the drive.  After the OOPS, I cannot eject it
> via the button, and the "eject" command is stuck in "D" state:
> 
> [  436.308282] eject         D ffffffff80571760     0  5336   5324
> [  436.308285]  ffff810007c35d08 0000000000000082 0000000000000000 ffff810007c35ca8
> [  436.308288]  ffff810006fb15f0 ffff810003062000 ffff810006fb17f8 0000000122222222
> [  436.308292]  0000000000000003 ffff8100057e1070 0000000000000000 0000000000000000
> [  436.308295] Call Trace:
> [  436.308301]  [<ffffffff80559137>] __mutex_lock_slowpath+0x133/0x23c
> [  436.308306]  [<ffffffff80559259>] mutex_lock+0x19/0x1d
> [  436.308309]  [<ffffffff802a35a0>] do_open+0x74/0x2d1
> [  436.308313]  [<ffffffff802a3a02>] blkdev_open+0x0/0x69
> [  436.308315]  [<ffffffff802a3a39>] blkdev_open+0x37/0x69
> [  436.308319]  [<ffffffff8027d68e>] __dentry_open+0xe6/0x1bd
> [  436.308323]  [<ffffffff8027d7fd>] nameidata_to_filp+0x2d/0x3f
> [  436.308326]  [<ffffffff8027d848>] do_filp_open+0x39/0x4b
> [  436.308330]  [<ffffffff8055a16d>] _spin_unlock+0x9/0xb
> [  436.308333]  [<ffffffff8027d58d>] get_unused_fd_flags+0x113/0x121
> [  436.308337]  [<ffffffff8027d8ab>] do_sys_open+0x51/0xd9
> [  436.308341]  [<ffffffff8027d95c>] sys_open+0x1b/0x1d
> [  436.308343]  [<ffffffff8020b77e>] system_call+0x7e/0x83

That's expected, the queue is hosed at that point.

-- 
Jens Axboe

