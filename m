Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXCFKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXCFKZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXCFKZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:25:00 -0500
Received: from main.gmane.org ([80.91.229.2]:38526 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221AbXCFKZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:25:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Subject: Re: [PATCH 3/3][RFC] Containers: Pagecache controller reclaim
Date: 06 Mar 2007 12:24:33 +0200
Message-ID: <5d4poyvfdq.fsf@Hurtta06k.keh.iki.fi>
References: <45ED251C.2010400@linux.vnet.ibm.com> <45ED266E.7040107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cs181108174.pp.htv.fi
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes
in gmane.linux.kernel,gmane.linux.kernel.mm:

> --- linux-2.6.20.orig/mm/pagecache_acct.c
> +++ linux-2.6.20/mm/pagecache_acct.c
> @@ -29,6 +29,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/div64.h>
>  #include <linux/pagecache_acct.h>
> +#include <linux/memcontrol.h>
> 
>  /*
>   * Convert unit from pages to kilobytes
> @@ -337,12 +338,20 @@ int pagecache_acct_cont_overlimit(struct
>  		return 0;
>  }
> 
> -extern unsigned long shrink_all_pagecache_memory(unsigned long nr_pages);
> +extern unsigned long shrink_container_memory(unsigned int memory_type,
> +				unsigned long nr_pages, void *container);
> 
>  int pagecache_acct_shrink_used(unsigned long nr_pages)
>  {
>  	unsigned long ret = 0;
>  	atomic_inc(&reclaim_count);
> +
> +	/* Don't call reclaim for each page above limit */
> +	if (nr_pages > NR_PAGES_RECLAIM_THRESHOLD) {
> +		ret += shrink_container_memory(
> +				RECLAIM_PAGECACHE_MEMORY, nr_pages, NULL);
> +	}
> +
>  	return 0;
>  }
> 

'ret' is not used ?

/ Kari Hurtta

