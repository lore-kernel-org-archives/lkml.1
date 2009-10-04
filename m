Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZJDLwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZJDLwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 07:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZJDLwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 07:52:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48642 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZJDLwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 07:52:03 -0400
Message-ID: <4AC88C31.1040802@cs.helsinki.fi>
Date: Sun, 04 Oct 2009 14:51:13 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slqb: remove unnecessary conditional in kmem_cache_create
References: <alpine.DEB.1.00.0909292141550.3686@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909292141550.3686@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> kmem_cache_open() panics when a SLAB_PANIC cache cannot be opened because
> it has early callers using the flag that do not go through
> kmem_cache_create().
> 
> If kmem_cache_open() fails for a SLAB_PANIC cache, it would have panicked
> the machine.  Thus, checking for this flag in kmem_cache_create() is
> unnecessary in the error patch since it is always clear.

Yes, but there are other error cases in kmem_cache_create() that "goto 
err" for which we do need to check for SLAB_PANIC.

> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/slqb.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -3077,9 +3077,6 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  
>  err:
>  	up_write(&slqb_lock);
> -	if (flags & SLAB_PANIC)
> -		panic("%s: failed to create slab `%s'\n", __func__, name);
> -
>  	return NULL;
>  }
>  EXPORT_SYMBOL(kmem_cache_create);

