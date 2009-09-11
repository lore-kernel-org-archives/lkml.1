Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZIKBZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZIKBZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZIKBZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:25:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54610 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZIKBZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:25:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH][mmotm][BUGFIX] kcore use registered physmem information ia64-fix (Was Re: mmotm 2009-09-03-16-35 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20090910115859.c2291eb8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090910103850.9CCF.A69D9226@jp.fujitsu.com> <20090910115859.c2291eb8.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090911102351.DB5F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 11 Sep 2009 10:25:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I confirmed this one fixes the issue.

mmotm-2009-09-09 + this patch booted successful on my box.

	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Andrew, could you please pick it up?



> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> kcore-use-registerd-physmem-information.patch registers physmem information
> based on ioresource. Then, this addition is unnecessary.
> 
> Why panic:
>   At boot, rebuilding kclist for physmem, all KCORE_RAM entries are kfreed.
>   Because this ramaining one entires kclist of KCORE_RAM in kernel data area
>   to ther list, this causes panic in kclist rebuilding which calls kfree().
> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  arch/ia64/mm/init.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: mmotm-2.6.31-Sep3/arch/ia64/mm/init.c
> ===================================================================
> --- mmotm-2.6.31-Sep3.orig/arch/ia64/mm/init.c
> +++ mmotm-2.6.31-Sep3/arch/ia64/mm/init.c
> @@ -617,7 +617,6 @@ mem_init (void)
>  	long reserved_pages, codesize, datasize, initsize;
>  	pg_data_t *pgdat;
>  	int i;
> -	static struct kcore_list kcore_mem;
>  
>  	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
>  	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
> @@ -639,8 +638,6 @@ mem_init (void)
>  
>  	high_memory = __va(max_low_pfn * PAGE_SIZE);
>  
> -	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
> -
>  	for_each_online_pgdat(pgdat)
>  		if (pgdat->bdata->node_bootmem_map)
>  			totalram_pages += free_all_bootmem_node(pgdat);
> 



