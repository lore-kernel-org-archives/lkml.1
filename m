Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbYBVUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbYBVUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYBVUNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:13:10 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56111 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760909AbYBVUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:13:08 -0500
Message-ID: <47BF2C73.4030308@cs.helsinki.fi>
Date: Fri, 22 Feb 2008 22:11:31 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: clameter@sgi.com, mpm@selenic.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6 patch] mm/slub.c: remove unneeded NULL check
References: <20080219224922.GO31955@cs181133002.pp.htv.fi> <6f8gTuy3.1203515564.2078250.penberg@cs.helsinki.fi> <20080222195905.GM1409@cs181133002.pp.htv.fi>
In-Reply-To: <20080222195905.GM1409@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> There's no reason for checking c->freelist for being NULL here (and we'd 
> anyway Oops below if it was).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> dae2a3c60f258f3ad2522b85d79b735a89d702f0 diff --git a/mm/slub.c b/mm/slub.c
> index 74c65af..072e0a6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1404,8 +1404,7 @@ static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
>  	struct page *page = c->page;
>  	int tail = 1;
>  
> -	if (c->freelist)
> -		stat(c, DEACTIVATE_REMOTE_FREES);
> +	stat(c, DEACTIVATE_REMOTE_FREES);
>  	/*
>  	 * Merge cpu freelist into freelist. Typically we get here
>  	 * because both freelists are empty. So this is unlikely

Christoph, please apply.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
