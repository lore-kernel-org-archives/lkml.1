Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZDGV5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZDGV5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZDGV53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:57:29 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37674 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383AbZDGV50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xcv2UAxeMqe/oa4QNW7F9MVTYOlNy6iI/XFBU+WutcvYRG5dwr/6oHUYC+DoymmO+p
         JrmuFaJEiS6UlT6A0to16saqpI3CstZH8Udij8lHPYrD+Eph1r5CdvJpTcebHFNgRb7H
         tDXNFGGd0Op/TCUJAkg1otQTmmDLlcM1afJv8=
Date: Tue, 7 Apr 2009 23:57:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090407215721.GA6252@nowhere>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <a4423d670904071434w6a687568hc6f2a380a8b32661@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904071434w6a687568hc6f2a380a8b32661@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:34:07AM +0400, Alexander Beregalov wrote:
> Hi Frederic
> 
> I've applied your patch.
> This is UP system.
> This warning seems related to your patch.
> 
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-10247-g8e2c4f2-dirty #2
> -------------------------------------------------------
> udevadm/1239 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c0173f52>] might_fault+0x52/0xa0
> 
> but task is already holding lock:
>  (sysfs_mutex){+.+.+.}, at: [<c01ccd36>] sysfs_readdir+0x56/0x200


Ah, I've never hit it. I'm not sure this is related to my patch
but it could be.
Could you send me your config?

Thanks,
Frederic.


> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 (sysfs_mutex){+.+.+.}:
>        [<c014fb2a>] __lock_acquire+0xd1a/0x1160
>        [<c014ffe4>] lock_acquire+0x74/0x90
>        [<c0448d70>] __mutex_lock_common+0x50/0x430
>        [<c0449203>] mutex_lock_nested+0x33/0x40
>        [<c01cd17c>] sysfs_addrm_start+0x2c/0xc0
>        [<c01cdd30>] create_dir+0x40/0x80
>        [<c01cdd9b>] sysfs_create_dir+0x2b/0x50
>        [<c02c3121>] kobject_add_internal+0xc1/0x220
>        [<c02c3351>] kobject_add_varg+0x31/0x50
>        [<c02c33cc>] kobject_add+0x2c/0x60
>        [<c0337a52>] device_add+0xe2/0x540
>        [<c01cac02>] add_partition+0x112/0x210
>        [<c01cb2ef>] rescan_partitions+0x23f/0x320
>        [<c01b0f13>] __blkdev_get+0x153/0x330
>        [<c01b10fa>] blkdev_get+0xa/0x10
>        [<c01caaca>] register_disk+0x10a/0x130
>        [<c02bd5c9>] add_disk+0x109/0x170
>        [<c034e85a>] sd_probe_async+0x19a/0x280
>        [<c0143900>] async_thread+0xd0/0x230
>        [<c013d86a>] kthread+0x3a/0x70
>        [<c0103677>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
> 
> -> #2 (&bdev->bd_mutex){+.+.+.}:
>        [<c014fb2a>] __lock_acquire+0xd1a/0x1160
>        [<c014ffe4>] lock_acquire+0x74/0x90
>        [<c0448d70>] __mutex_lock_common+0x50/0x430
>        [<c0449203>] mutex_lock_nested+0x33/0x40
>        [<c01b0df3>] __blkdev_get+0x33/0x330
>        [<c01b10fa>] blkdev_get+0xa/0x10
>        [<c01b1261>] open_by_devnum+0x21/0x50
>        [<c01fed2e>] journal_init+0x22e/0x19a0
>        [<c01ea881>] reiserfs_fill_super+0x3a1/0x1050
>        [<c018d053>] get_sb_bdev+0x133/0x160
>        [<c01e8b21>] get_super_block+0x21/0x30
>        [<c018bd7a>] vfs_kern_mount+0x3a/0xa0
>        [<c018be39>] do_kern_mount+0x39/0xd0
>        [<c01a2063>] do_mount+0x3a3/0x790
>        [<c01a24d9>] sys_mount+0x89/0xc0
>        [<c06fac3d>] mount_block_root+0xd0/0x261
>        [<c06fae27>] mount_root+0x59/0x5f
>        [<c06faf1c>] prepare_namespace+0xef/0x171
>        [<c06fa4e3>] kernel_init+0xd5/0xee
>        [<c0103677>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
> 
> -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
>        [<c014fb2a>] __lock_acquire+0xd1a/0x1160
>        [<c014ffe4>] lock_acquire+0x74/0x90
>        [<c0448d70>] __mutex_lock_common+0x50/0x430
>        [<c0449203>] mutex_lock_nested+0x33/0x40
>        [<c020375e>] reiserfs_write_lock+0x1e/0x30
>        [<c01df2e6>] reiserfs_get_block+0x66/0x14f0
>        [<c01b32f0>] do_mpage_readpage+0x340/0x490
>        [<c01b352e>] mpage_readpages+0x9e/0xe0
>        [<c01dc729>] reiserfs_readpages+0x19/0x20
>        [<c01696ff>] __do_page_cache_readahead+0x13f/0x200
>        [<c016980e>] do_page_cache_readahead+0x4e/0x70
>        [<c0162caf>] filemap_fault+0x30f/0x430
>        [<c0175f6d>] __do_fault+0x3d/0x360
>        [<c0176aa0>] handle_mm_fault+0x100/0x590
>        [<c011aff1>] do_page_fault+0x121/0x280
>        [<c044b40a>] error_code+0x6a/0x70
>        [<c01bf810>] load_elf_binary+0x9d0/0x19f0
>        [<c018fde3>] search_binary_handler+0x163/0x2f0
>        [<c019018d>] do_execve+0x21d/0x2b0
>        [<c01016de>] sys_execve+0x3e/0x70
>        [<c0102ec9>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&mm->mmap_sem){++++++}:
>        [<c014fbde>] __lock_acquire+0xdce/0x1160
>        [<c014ffe4>] lock_acquire+0x74/0x90
>        [<c0173f83>] might_fault+0x83/0xa0
>        [<c02ca436>] copy_to_user+0x36/0x130
>        [<c0197b24>] filldir64+0xa4/0xf0
>        [<c01ccdf6>] sysfs_readdir+0x116/0x200
>        [<c0197d9e>] vfs_readdir+0x7e/0xa0
>        [<c0197e29>] sys_getdents64+0x69/0xb0
>        [<c0102e48>] sysenter_do_call+0x12/0x36
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by udevadm/1239:
>  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c0197d6f>] vfs_readdir+0x4f/0xa0
>  #1:  (sysfs_mutex){+.+.+.}, at: [<c01ccd36>] sysfs_readdir+0x56/0x200
> 
> stack backtrace:
> Pid: 1239, comm: udevadm Not tainted 2.6.29-10247-g8e2c4f2-dirty #2
> Call Trace:
>  [<c0447c92>] ? printk+0x18/0x1e
>  [<c014db5c>] print_circular_bug_tail+0x8c/0xe0
>  [<c014fbde>] __lock_acquire+0xdce/0x1160
>  [<c014bb1d>] ? put_lock_stats+0xd/0x30
>  [<c014ffe4>] lock_acquire+0x74/0x90
>  [<c0173f52>] ? might_fault+0x52/0xa0
>  [<c0173f83>] might_fault+0x83/0xa0
>  [<c0173f52>] ? might_fault+0x52/0xa0
>  [<c02ca436>] copy_to_user+0x36/0x130
>  [<c0197b24>] filldir64+0xa4/0xf0
>  [<c01ccdf6>] sysfs_readdir+0x116/0x200
>  [<c0197a80>] ? filldir64+0x0/0xf0
>  [<c0197d9e>] vfs_readdir+0x7e/0xa0
>  [<c0197a80>] ? filldir64+0x0/0xf0
>  [<c0197e29>] sys_getdents64+0x69/0xb0
>  [<c0102e48>] sysenter_do_call+0x12/0x36

