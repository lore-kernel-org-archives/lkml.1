Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYHYJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYHYJ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYHYJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:28:22 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50788 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYHYJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:28:21 -0400
Date: Mon, 25 Aug 2008 10:27:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: hugetlb.c make functions static, use NULL rather
 than 0
In-Reply-To: <1219445274.4493.10.camel@brick>
Message-ID: <Pine.LNX.4.64.0808251023220.8672@blonde.site>
References: <1219445274.4493.10.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Harvey Harrison wrote:

> mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
> mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
> mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
> mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

This all looks good to me, but guess you sent it my way because
you mistook it for mm/hughtlb.c?  Cc'ed Andy, he's the man here!

Hugh

> ---
>  mm/hugetlb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 67a7119..b548a94 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -262,7 +262,7 @@ struct resv_map {
>  	struct list_head regions;
>  };
>  
> -struct resv_map *resv_map_alloc(void)
> +static struct resv_map *resv_map_alloc(void)
>  {
>  	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
>  	if (!resv_map)
> @@ -274,7 +274,7 @@ struct resv_map *resv_map_alloc(void)
>  	return resv_map;
>  }
>  
> -void resv_map_release(struct kref *ref)
> +static void resv_map_release(struct kref *ref)
>  {
>  	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
>  
> @@ -289,7 +289,7 @@ static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
>  	if (!(vma->vm_flags & VM_SHARED))
>  		return (struct resv_map *)(get_vma_private_data(vma) &
>  							~HPAGE_RESV_MASK);
> -	return 0;
> +	return NULL;
>  }
>  
>  static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
> @@ -1747,7 +1747,7 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>   * from other VMAs and let the children be SIGKILLed if they are faulting the
>   * same region.
>   */
> -int unmap_ref_private(struct mm_struct *mm,
> +static int unmap_ref_private(struct mm_struct *mm,
>  					struct vm_area_struct *vma,
>  					struct page *page,
>  					unsigned long address)
> -- 
> 1.6.0.340.g84854
