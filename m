Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYIDHUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYIDHUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYIDHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:19:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46271 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYIDHTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:19:51 -0400
Date: Thu, 4 Sep 2008 09:19:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: list corruption in next-20080903
Message-ID: <20080904071947.GW20055@kernel.dk>
References: <20080903153915.GB5604@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903153915.GB5604@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03 2008, Alexey Dobriyan wrote:
> Reproducible, happens during init scripts.
> 
> ------------[ cut here ]------------
> WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
> list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
> Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
> Pid: 4006, comm: bash Tainted: G        W 2.6.27-rc5-next-20080903 #2
> Call Trace:
>  [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
>  [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
>  [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
>  [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
>  [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
>  [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
>  [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
>  [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
>  [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
>  [<ffffffff803145d5>] __list_add+0x95/0xa0
>  [<ffffffff80301740>] blk_add_timer+0x50/0xd0
>  [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
>  [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
>  [<ffffffff802fda31>] ? generic_unplug_device+0x21/0x40
>  [<ffffffff802fda39>] generic_unplug_device+0x29/0x40
>  [<ffffffff802fb842>] blk_unplug+0x12/0x20
>  [<ffffffff802fb85d>] blk_backing_dev_unplug+0xd/0x10
>  [<ffffffff802b630e>] block_sync_page+0x3e/0x50
>  [<ffffffff80267ff9>] sync_page+0x39/0x60
>  [<ffffffff80269c29>] sync_page_killable+0x9/0x40
>  [<ffffffff8042e61e>] __wait_on_bit_lock+0x4e/0x80
>  [<ffffffff80269c20>] ? sync_page_killable+0x0/0x40
>  [<ffffffff80267f35>] __lock_page_killable+0x65/0x70
>  [<ffffffff802483a0>] ? wake_bit_function+0x0/0x30
>  [<ffffffff8026a018>] generic_file_aio_read+0x3b8/0x660
>  [<ffffffff802938b1>] do_sync_read+0xf1/0x130
>  [<ffffffff80248360>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff80256add>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff80430ef2>] ? _spin_unlock_irqrestore+0x42/0x80
>  [<ffffffff80294017>] vfs_read+0xa7/0xe0
>  [<ffffffff8029820a>] kernel_read+0x3a/0x60
>  [<ffffffff8029831c>] prepare_binprm+0xec/0x120
>  [<ffffffff80299467>] do_execve+0x197/0x280
>  [<ffffffff80209b69>] sys_execve+0x49/0x80
>  [<ffffffff8020bb2a>] stub_execve+0x6a/0xc0
> ---[ end trace 4eaa2a86a8e2da22 ]---

Thanks Alexey, I hit a problem with it yesterday as well. So it needs
more development before going into -next/-mm, I'll put it in a seperate
testing branch for now.

-- 
Jens Axboe

