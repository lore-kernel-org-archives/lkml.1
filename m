Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXA1REw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXA1REw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXA1REw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:04:52 -0500
Received: from dvhart.com ([64.146.134.43]:42185 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbXA1REv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:04:51 -0500
Message-ID: <45BCD7A0.2040908@mbligh.org>
Date: Sun, 28 Jan 2007 09:04:32 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Jens Axboe <axboe@suse.de>
Subject: Re: 2.6.20-rc6-mm1
References: <20070127234928.64d8e437.akpm@osdl.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - It seems that people have been busy creating the need for this.  I had to
>   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
>   errors.  And a number of patches were dropped due to no-compile or to
>   runtime errors.  Heaven knows how many runtime bugs were added.

What looks to me like it might be another cfq problem? Not confied to
XFS this time.

http://test.kernel.org/abat/68514/debug/console.log


RIP: 0010:[<ffffffff80321d34>]  [<ffffffff80321d34>] 
cfq_dispatch_requests+0xaf/0x48c
RSP: 0018:ffff81003465d9e8  EFLAGS: 00010002
RAX: ffff81003ebac200 RBX: 0000000000000000 RCX: ffff81003eed5200
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffffff
RBP: ffff81003eed5200 R08: ffffffff8031a363 R09: 0000000000002000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00002affc43a86f0(0000) GS:ffff81003ee37cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000055555556d026 CR3: 00000000346c7000 CR4: 00000000000006e0
Process smartd (pid: 1943, threadinfo ffff81003465c000, task 
ffff81003bccc040)
Stack:  0000000000000044 ffff81003e1cb4c0 ffff81003e1ea5e0 ffff81003e1cb4c0
  0000000000000000 ffff81003eed5800 ffff81003e1cb4c0 ffffffff803174ed
  ffff81003e1ea5e0 ffffffff80317e3d 00000000000000d0 0000000000000002
Call Trace:
  [<ffffffff803174ed>] elv_drain_elevator+0x16/0x5d
  [<ffffffff80317e3d>] elv_insert+0x4b/0x158
  [<ffffffff8031a43d>] blk_execute_rq_nowait+0x6d/0x89
  [<ffffffff8031a512>] blk_execute_rq+0xb9/0xe1
  [<ffffffff802aa72f>] bio_phys_segments+0xf/0x15
  [<ffffffff8031e4db>] sg_io+0x217/0x328
  [<ffffffff8045eeb8>] sock_def_readable+0x18/0x6c
  [<ffffffff8031ea68>] scsi_cmd_ioctl+0x1bd/0x391
  [<ffffffff803df122>] sd_ioctl+0x93/0xc1
  [<ffffffff8031c9d8>] blkdev_driver_ioctl+0x5d/0x72
  [<ffffffff8031d025>] blkdev_ioctl+0x638/0x693
  [<ffffffff804c65f3>] _spin_lock_irqsave+0x9/0xe
  [<ffffffff8032707c>] __up_read+0x13/0x8a
  [<ffffffff804c863d>] do_page_fault+0x45e/0x7b3
  [<ffffffff8045fdaf>] skb_dequeue+0x48/0x50
  [<ffffffff802ab382>] block_ioctl+0x1b/0x1f
  [<ffffffff80294105>] do_ioctl+0x21/0x6b
  [<ffffffff802943b5>] vfs_ioctl+0x266/0x27f
  [<ffffffff80294427>] sys_ioctl+0x59/0x7a
  [<ffffffff80209bae>] system_call+0x7e/0x83
