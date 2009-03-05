Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZCETPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZCETPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZCETPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:15:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:57651 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbZCETPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:15:16 -0500
Message-ID: <49B02498.9080300@kernel.org>
Date: Thu, 05 Mar 2009 11:14:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/17] x86: rename after_init_bootmem to after_bootmem
 in mm/init_32.c
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi>
In-Reply-To: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Impact: cleanup
> 
> This patch renames after_init_bootmem to after_bootmem in mm/init_32.c to
> reduce the diff to the 64-bit version of of init_memory_mapping().

not sure,
after_init_bootmem seems bootmem could be used.
after_bootmem seems bootmem are freed already.

YH

> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/mm/init_32.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 559715b..cc5c399 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -63,7 +63,7 @@ static unsigned long __initdata table_start;
>  static unsigned long __meminitdata table_end;
>  static unsigned long __meminitdata table_top;
>  
> -static int __initdata after_init_bootmem;
> +int after_bootmem;
>  
>  int direct_gbpages;
>  
> @@ -92,7 +92,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
>  
>  #ifdef CONFIG_X86_PAE
>  	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
> -		if (after_init_bootmem)
> +		if (after_bootmem)
>  			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
>  		else
>  			pmd_table = (pmd_t *)alloc_low_page();
> @@ -119,7 +119,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
>  	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
>  		pte_t *page_table = NULL;
>  
> -		if (after_init_bootmem) {
> +		if (after_bootmem) {
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
>  #endif
> @@ -158,7 +158,7 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
>  		pte_t *newpte;
>  		int i;
>  
> -		BUG_ON(after_init_bootmem);
> +		BUG_ON(after_bootmem);
>  		newpte = alloc_low_page();
>  		for (i = 0; i < PTRS_PER_PTE; i++)
>  			set_pte(newpte + i, pte[i]);
> @@ -831,7 +831,7 @@ void __init setup_bootmem_allocator(void)
>  	bootmap = setup_node_bootmem(0, 0, max_low_pfn, bootmap);
>  #endif
>  
> -	after_init_bootmem = 1;
> +	after_bootmem = 1;
>  }
>  
>  static void __init find_early_table_space(unsigned long end, int use_pse,
> @@ -1037,7 +1037,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	 * memory mapped. Unfortunately this is done currently before the
>  	 * nodes are discovered.
>  	 */
> -	if (!after_init_bootmem)
> +	if (!after_bootmem)
>  		find_early_table_space(end, use_pse, use_gbpages);
>  
>  	for (i = 0; i < nr_range; i++)
> @@ -1052,11 +1052,11 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  
>  	__flush_tlb_all();
>  
> -	if (!after_init_bootmem)
> +	if (!after_bootmem)
>  		reserve_early(table_start << PAGE_SHIFT,
>  				 table_end << PAGE_SHIFT, "PGTABLE");
>  
> -	if (!after_init_bootmem)
> +	if (!after_bootmem)
>  		early_memtest(start, end);
>  
>  	return end >> PAGE_SHIFT;

