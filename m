Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZGFSAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZGFSAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZGFSAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:00:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37630 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZGFSAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:00:23 -0400
To: npiggin@suse.de
CC: linux-fsdevel@vger.kernel.org, hch@infradead.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20090706165438.GQ2714@wotan.suse.de> (message from Nick Piggin
	on Mon, 6 Jul 2009 18:54:38 +0200)
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
References: <20090706165438.GQ2714@wotan.suse.de>
Message-Id: <E1MNsU3-0002Lx-8T@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Jul 2009 20:00:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6/mm/truncate.c
> ===================================================================
> --- linux-2.6.orig/mm/truncate.c
> +++ linux-2.6/mm/truncate.c
> @@ -465,3 +465,79 @@ int invalidate_inode_pages2(struct addre
>  	return invalidate_inode_pages2_range(mapping, 0, -1);
>  }
>  EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
> +
> +/**
> + * truncate_pagecache - unmap mappings "freed" by truncate() syscall
> + * @inode: inode
> + * @old: old file offset
> + * @new: new file offset
> + *
> + * inode's new i_size must already be written before truncate_pagecache
> + * is called.
> + */
> +void truncate_pagecache(struct inode * inode, loff_t old, loff_t new)
> +{
> +	VM_BUG_ON(inode->i_size != new);

This is not true for fuse (and NFS?) as i_size isn't protected by
i_mutex during attribute revalidation, and so it can change during the
truncate.

Thanks,
Miklos
