Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXIZNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXIZNht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXIZNhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:37:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59669 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXIZNhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:37:40 -0400
Message-ID: <46FA609F.60702@fr.ibm.com>
Date: Wed, 26 Sep 2007 15:37:35 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use KMEM_CACHE macro to create the nsproxy cache
References: <46FA5D0F.2090604@openvz.org>
In-Reply-To: <46FA5D0F.2090604@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> The blessed way for standard caches is to use it.
> Besides, this may give this cache a better alignment.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

yes of course. thanks. 

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

> ---
> 
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index ee68964..31351cc 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -222,8 +222,7 @@ void exit_task_namespaces(struct task_st
> 
>  static int __init nsproxy_cache_init(void)
>  {
> -	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
> -					   0, SLAB_PANIC, NULL);
> +	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
>  	return 0;
>  }
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 

