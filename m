Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbYEHSqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbYEHSqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbYEHSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:46:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:36297 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804AbYEHSqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="244015350"
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
In-Reply-To: <200805082039.01316.rjw@sisk.pl>
References: <200805031151.44287.prakash@punnoor.de>
	 <18462.46639.578272.994939@notabene.brown> <20080505190159.GA329@kernel.dk>
	 <200805082039.01316.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 08 May 2008 11:46:19 -0700
Message-Id: <1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 11:39 -0700, Rafael J. Wysocki wrote:
> I get a similar warning with RAID1 on one of my test boxes:
> 
> WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:443 blk_remove_plug+0x85/0xa0()
> Modules linked in: raid456 async_xor async_memcpy async_tx xor raid0 ehci_hcd ohci_hcd sd_mod edd raid1 ext3 jbd fan sata_uli pata_ali thermal processor
> Pid: 2159, comm: md1_raid1 Not tainted 2.6.26-rc1 #158
> 
> Call Trace:
>  [<ffffffff80238bbf>] warn_on_slowpath+0x5f/0x80
>  [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
>  [<ffffffff80348f55>] blk_remove_plug+0x85/0xa0
>  [<ffffffffa004df64>] :raid1:flush_pending_writes+0x44/0xb0
>  [<ffffffffa004e649>] :raid1:raid1d+0x59/0xfe0
>  [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
>  [<ffffffff8025dc4f>] ? trace_hardirqs_on+0xbf/0x150
>  [<ffffffff8043ea8c>] md_thread+0x3c/0x110
>  [<ffffffff8024f6a0>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff8043ea50>] ? md_thread+0x0/0x110
>  [<ffffffff8024f23d>] kthread+0x4d/0x80
>  [<ffffffff8020c548>] child_rip+0xa/0x12
>  [<ffffffff8020bc5f>] ? restore_args+0x0/0x30
>  [<ffffffff8024f1f0>] ? kthread+0x0/0x80
>  [<ffffffff8020c53e>] ? child_rip+0x0/0x12
> 
> ---[ end trace 05d4e0844c61f45d ]---
> 
> This is the WARN_ON_ONCE(!queue_is_locked(q)) in queue_flag_clear(),
> apparently.

Yes, it triggers on all RAID levels.  The patch in this message:

http://marc.info/?l=linux-raid&m=121001065404056&w=2
> 
...fixes the raid 0/1/10/5/6 cases, but I am still trying to isolate an
issue (potentially unrelated) with linear arrays.

--
Dan

