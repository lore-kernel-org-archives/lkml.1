Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXGTLoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXGTLoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXGTLoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:44:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:40199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXGTLoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:44:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Use wbinvd() macro instead of raw inline assembly in .c files
Date: Fri, 20 Jul 2007 13:43:59 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Muli Ben-Yehuda <muli@il.ibm.com>
References: <1184885740.16311.19.camel@t60>
In-Reply-To: <1184885740.16311.19.camel@t60>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201343.59962.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 00:55:40 Glauber de Oliveira Costa wrote:
> This patch uses the already-existant wbinvd() macro to replace
> raw assembly to perform this very same task in some .c files
>     
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
> index f61fb8e..afbb951 100644
> --- a/arch/x86_64/kernel/tce.c
> +++ b/arch/x86_64/kernel/tce.c
> @@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
>  	if (cpu_has_clflush)
>  		asm volatile("clflush (%0)" :: "r" (tceaddr));
>  	else
> -		asm volatile("wbinvd":::"memory");
> +		wbinvd();

I guess it can be just removed there. I don' think there are any calgary 
machines without clflush

>  }
>  
>  void tce_build(struct iommu_table *tbl, unsigned long index,
> diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
> index 9148f4a..0a75790 100644
> --- a/arch/x86_64/mm/pageattr.c
> +++ b/arch/x86_64/mm/pageattr.c
> @@ -77,7 +77,7 @@ static void flush_kernel_map(void *arg)
>  	   much cheaper than WBINVD. Disable clflush for now because
>  	   the high level code is not ready yet */
>  	if (1 || !cpu_has_clflush)
> -		asm volatile("wbinvd" ::: "memory");
> +		wbinvd();
>  	else list_for_each_entry(pg, l, lru) {
>  		void *adr = page_address(pg);
>  		if (cpu_has_clflush)
> 

This code has changed recently in the queue. Please resubmit later.

-Andi


> 


