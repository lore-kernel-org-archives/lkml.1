Return-Path: <linux-kernel-owner+w=401wt.eu-S1946358AbXBQBZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946358AbXBQBZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946360AbXBQBZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:25:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946358AbXBQBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:25:05 -0500
Date: Fri, 16 Feb 2007 17:24:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: olof@lixom.net (Olof Johansson)
Cc: trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
Message-Id: <20070216172442.fd75d8d8.akpm@linux-foundation.org>
In-Reply-To: <20070216170532.GA4895@lixom.net>
References: <20070216170532.GA4895@lixom.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 11:05:32 -0600
olof@lixom.net (Olof Johansson) wrote:

> Seems like req_lock is never initialized. CONFIG_DEBUG_SPINLOCK reported:
> 
> BUG: spinlock bad magic on CPU#0, mount/1073
>  lock: c00000007fdca108, .magic: 00000000, .owner: /24576, .owner_cpu: 0
> Call Trace:
> [C00000007E913750] [C0000000000107B4] .show_stack+0x54/0x1f0 (unreliable)
> [C00000007E913800] [C0000000001D2234] .spin_bug+0xa4/0x120
> [C00000007E913890] [C0000000001D247C] ._raw_spin_lock+0xdc/0x1d0
> [C00000007E913930] [C0000000004DF990] ._spin_lock+0x10/0x30
> [C00000007E9139B0] [C00000000017623C] .nfs_sync_mapping_wait+0xac/0x310
> [C00000007E913AA0] [C000000000176F18] .nfs_sync_mapping_range+0x98/0x110
> [C00000007E913B80] [C00000000016CAA0] .nfs_getattr+0x40/0xf0
> [C00000007E913C20] [C0000000000BE668] .vfs_getattr+0x38/0x70
> [C00000007E913CA0] [C0000000000BF05C] .vfs_fstat+0x3c/0x70
> [C00000007E913D30] [C0000000000BF0B8] .sys_fstat64+0x28/0x60
> [C00000007E913E30] [C000000000008608] syscall_exit+0x0/0x40
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> ---
> 
> Trond, is your MAINTAINERS entry up to date? Seems like you mostly post
> from @netapp.com these days.
> 
> 
> Index: linux-2.6/fs/nfs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/inode.c
> +++ linux-2.6/fs/nfs/inode.c
> @@ -1123,6 +1123,7 @@ struct inode *nfs_alloc_inode(struct sup
>  	nfsi->flags = 0UL;
>  	nfsi->cache_validity = 0UL;
>  	nfsi->cache_change_attribute = jiffies;
> +	nfsi->req_lock = SPIN_LOCK_UNLOCKED;
>  #ifdef CONFIG_NFS_V3_ACL
>  	nfsi->acl_access = ERR_PTR(-EAGAIN);
>  	nfsi->acl_default = ERR_PTR(-EAGAIN);

req_lock is initialsied in fs/nfs/inode.c:init_once().

What kernel version were you using?
