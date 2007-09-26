Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXIZNkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXIZNkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXIZNjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:39:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50873 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbXIZNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:39:52 -0400
Date: Wed, 26 Sep 2007 08:39:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use KMEM_CACHE macro to create the nsproxy cache
Message-ID: <20070926133929.GA4793@sergelap.austin.ibm.com>
References: <46FA5D0F.2090604@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA5D0F.2090604@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> The blessed way for standard caches is to use it.
> Besides, this may give this cache a better alignment.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

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
