Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZFULWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZFULWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZFULWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:22:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZFULWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:22:09 -0400
Date: Sun, 21 Jun 2009 13:22:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: mm/hugetlbpage.c fix style problems
Message-ID: <20090621112201.GA13435@elte.hu>
References: <1245582881.3052.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245582881.3052.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> Impact : cleanup
> 
> Fix :
> 
> WARNING: Use #include <linux/mman.h> instead of <asm/mman.h>
> WARNING: line over 80 characters
> ERROR: code indent should use tabs where possible X 10
> ERROR: do not use assignment in if condition
> ERROR: return is not a function, parentheses are not required
> 
> total: 12 errors, 2 warnings
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/mm/hugetlbpage.c |   33 ++++++++++++++++++---------------
>  1 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index f46c340..978fc5f 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -12,7 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/sysctl.h>
> -#include <asm/mman.h>
> +#include <linux/mman.h>
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/pgalloc.h>
> @@ -93,7 +93,8 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
>  
>  	spin_lock(&mm->page_table_lock);
>  	if (pud_none(*pud))
> -		pud_populate(mm, pud, (pmd_t *)((unsigned long)spte & PAGE_MASK));
> +		pud_populate(mm, pud,
> +			     (pmd_t *)((unsigned long)spte & PAGE_MASK));

this change is not an improvement.

>  	else
>  		put_page(virt_to_page(spte));
>  	spin_unlock(&mm->page_table_lock);
> @@ -269,11 +270,11 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
>  	struct vm_area_struct *vma;
>  	unsigned long start_addr;
>  
> -	if (len > mm->cached_hole_size) {
> -	        start_addr = mm->free_area_cache;
> -	} else {
> -	        start_addr = TASK_UNMAPPED_BASE;
> -	        mm->cached_hole_size = 0;
> +	if (len > mm->cached_hole_size)
> +		start_addr = mm->free_area_cache;
> +	else {
> +		start_addr = TASK_UNMAPPED_BASE;
> +		mm->cached_hole_size = 0;
>  	}
>  

this change is not an improvement either.

Plus at a first glance that file has a couple of other problems as 
well beyond trivial style issue:

 - dead code which should be removed

 - a 64-bit only boot option that should probably be extended to 
   32-bit as well

 - insanely long function names with local scope, causing ugly 
   linebreaks

and more style issues as well:

 - various inconsistent capitalizations in comment blocks

 - some other small details as well

Lets try to do a genuinely big and comprehensive forward step that 
addresses all these issues (and any other issues that are in that 
file), ok?

	Ingo
