Return-Path: <linux-kernel-owner+w=401wt.eu-S1030739AbXCSXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030739AbXCSXcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030742AbXCSXcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:32:18 -0400
Received: from hermes.domdv.de ([193.102.202.1]:4591 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030739AbXCSXcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:32:17 -0400
Message-ID: <45FF1D7D.1090702@domdv.de>
Date: Tue, 20 Mar 2007 00:32:13 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This changes kmem_cache_free() to deal with NULL objects passed to it. The 
> current behavior is inconsistent with kfree() so there are callers 
> passing NULL to kmem_cache_free().
> 
> Andreas, can you please confirm this fixes the oops you reported on 
> linux-scsi?
> 

Didn't test this as Mike Christie pointed me to a working fix for the st
driver.

> Cc: Andreas Steinmetz <ast@domdv.de>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slab.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: 2.6/mm/slab.c
> ===================================================================
> --- 2.6.orig/mm/slab.c	2007-03-19 10:18:52.000000000 +0200
> +++ 2.6/mm/slab.c	2007-03-19 10:19:42.000000000 +0200
> @@ -3741,6 +3741,8 @@ EXPORT_SYMBOL(__kmalloc);
>   * @cachep: The cache the allocation was from.
>   * @objp: The previously allocated object.
>   *
> + * If @objp is NULL, no operation is performed.
> + *
>   * Free an object which was previously allocated from this
>   * cache.
>   */
> @@ -3748,6 +3750,9 @@ void kmem_cache_free(struct kmem_cache *
>  {
>  	unsigned long flags;
>  
> +	if (unlikely(!objp))
> +		return;
> +
>  	BUG_ON(virt_to_cache(objp) != cachep);
>  
>  	local_irq_save(flags);


-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
