Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbXEQTlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbXEQTlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXEQTk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:40:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437AbXEQTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:40:56 -0400
Date: Thu, 17 May 2007 12:38:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] Mark page cache pages as __GFP_PAGECACHE instead of
 __GFP_MOVABLE
Message-Id: <20070517123854.6cea6338.akpm@linux-foundation.org>
In-Reply-To: <20070517101203.3113.81852.sendpatchset@skynet.skynet.ie>
References: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
	<20070517101203.3113.81852.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 11:12:03 +0100 (IST)
Mel Gorman <mel@csn.ul.ie> wrote:

> --- linux-2.6.22-rc1-mm1-025_gfphighuser/fs/buffer.c	2007-05-16 22:55:50.000000000 +0100
> +++ linux-2.6.22-rc1-mm1-030_pagecache_mark/fs/buffer.c	2007-05-16 23:07:30.000000000 +0100
> @@ -1009,7 +1009,7 @@ grow_dev_page(struct block_device *bdev,
>  	struct buffer_head *bh;
>  
>  	page = find_or_create_page(inode->i_mapping, index,
> -					GFP_NOFS|__GFP_RECLAIMABLE);
> +					GFP_NOFS_PAGECACHE);
>  	if (!page)
>  		return NULL;
>  

I ended up with

        page = find_or_create_page(inode->i_mapping, index,
                (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);

here.
