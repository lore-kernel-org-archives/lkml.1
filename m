Return-Path: <linux-kernel-owner+w=401wt.eu-S935909AbXGMIRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909AbXGMIRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762265AbXGMIR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:17:29 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10829 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762235AbXGMIR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:17:28 -0400
Message-ID: <4697357A.10605@sw.ru>
Date: Fri, 13 Jul 2007 12:19:06 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: trivial@kernel.org, Denis <cr_quan@163.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to remove
 some following zero initializations.
References: <1184290905.5475.5.camel@tux.homenetwork>
In-Reply-To: <1184290905.5475.5.camel@tux.homenetwork>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't look worth zeroing half of the struct
when it is initialized to non-zeros then.

Denis Cheng wrote:
>>From 4d87e14b67890f06885a76b5792ca034de2e9d06 Mon Sep 17 00:00:00 2001
> From: Denis Cheng <crquan@gmail.com>
> Date: Thu, 12 Jul 2007 11:53:58 +0800
> Subject: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to
> remove some following zero initializations.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/dcache.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 0e73aa0..8c559b2 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -898,7 +898,7 @@ struct dentry *d_alloc(struct dentry * parent, const
> struct qstr *name)
>  	struct dentry *dentry;
>  	char *dname;
>  
> -	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL); 
> +	dentry = kmem_cache_zalloc(dentry_cache, GFP_KERNEL); 
>  	if (!dentry)
>  		return NULL;
>  
> @@ -921,15 +921,7 @@ struct dentry *d_alloc(struct dentry * parent,
> const struct qstr *name)
>  	atomic_set(&dentry->d_count, 1);
>  	dentry->d_flags = DCACHE_UNHASHED;
>  	spin_lock_init(&dentry->d_lock);
> -	dentry->d_inode = NULL;
> -	dentry->d_parent = NULL;
> -	dentry->d_sb = NULL;
> -	dentry->d_op = NULL;
> -	dentry->d_fsdata = NULL;
> -	dentry->d_mounted = 0;
> -#ifdef CONFIG_PROFILING
> -	dentry->d_cookie = NULL;
> -#endif
> +
>  	INIT_HLIST_NODE(&dentry->d_hash);
>  	INIT_LIST_HEAD(&dentry->d_lru);
>  	INIT_LIST_HEAD(&dentry->d_subdirs);

