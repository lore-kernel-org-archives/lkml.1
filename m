Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbYBRNE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbYBRNE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbYBRNDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:03:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760326AbYBRNDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:03:04 -0500
Date: Mon, 18 Feb 2008 05:01:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [2.6 patch] fs/drop_caches.c: make 2 functions static
Message-Id: <20080218050147.17f5ee0b.akpm@linux-foundation.org>
In-Reply-To: <20080217081746.GI3848@cs181133002.pp.htv.fi>
References: <20080217081746.GI3848@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:17:46 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the following needlessly global functions static:
> - drop_pagecache()
> - drop_slab()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  fs/drop_caches.c   |    4 ++--
>  include/linux/mm.h |    2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> 32191754eb7aed31406850a082565bc428268a08 diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..e2c6b65 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -25,7 +25,7 @@ static void drop_pagecache_sb(struct super_block *sb)
>  	spin_unlock(&inode_lock);
>  }
>  
> -void drop_pagecache(void)
> +static void drop_pagecache(void)
>  {
>  	struct super_block *sb;
>  
> @@ -45,7 +45,7 @@ restart:
>  	spin_unlock(&sb_lock);
>  }
>  
> -void drop_slab(void)
> +static void drop_slab(void)
>  {
>  	int nr_objects;
>  

This was originally done because Neil said that he planned to use these in
nfsd.  I guess that didn't happen, and an additional patch would be needed
here anyway to do the module exports.  So....  zap.
