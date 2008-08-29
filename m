Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYH2IaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYH2IaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYH2I34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:29:56 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50364 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYH2I3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:29:55 -0400
Date: Fri, 29 Aug 2008 09:29:50 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: hugetlb.c make functions static, use NULL rather
	than 0
Message-ID: <20080829082950.GC3387@brain>
References: <1219445274.4493.10.camel@brick> <Pine.LNX.4.64.0808251023220.8672@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808251023220.8672@blonde.site>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:27:39AM +0100, Hugh Dickins wrote:
> On Fri, 22 Aug 2008, Harvey Harrison wrote:
> 
> > mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
> > mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
> > mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
> > mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?

Harvey are you using some additional compiler flags to get this, I am
pretty sure I checked for warnings during compilation before this lot
was merged.  Hmmm.

> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Yep this looks completely sane.  This appears to have been sucked up
into -mm already, but for completeness.

Acked-by: Andy Whitcroft <apw@shadowen.org>

> This all looks good to me, but guess you sent it my way because
> you mistook it for mm/hughtlb.c?  Cc'ed Andy, he's the man here!

Thanks for the heads up.

> Hugh
> 
> > ---
> >  mm/hugetlb.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 67a7119..b548a94 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -262,7 +262,7 @@ struct resv_map {
> >  	struct list_head regions;
> >  };
> >  
> > -struct resv_map *resv_map_alloc(void)
> > +static struct resv_map *resv_map_alloc(void)
> >  {
> >  	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
> >  	if (!resv_map)
> > @@ -274,7 +274,7 @@ struct resv_map *resv_map_alloc(void)
> >  	return resv_map;
> >  }
> >  
> > -void resv_map_release(struct kref *ref)
> > +static void resv_map_release(struct kref *ref)
> >  {
> >  	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
> >  
> > @@ -289,7 +289,7 @@ static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
> >  	if (!(vma->vm_flags & VM_SHARED))
> >  		return (struct resv_map *)(get_vma_private_data(vma) &
> >  							~HPAGE_RESV_MASK);
> > -	return 0;
> > +	return NULL;
> >  }
> >  
> >  static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
> > @@ -1747,7 +1747,7 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> >   * from other VMAs and let the children be SIGKILLed if they are faulting the
> >   * same region.
> >   */
> > -int unmap_ref_private(struct mm_struct *mm,
> > +static int unmap_ref_private(struct mm_struct *mm,
> >  					struct vm_area_struct *vma,
> >  					struct page *page,
> >  					unsigned long address)
> > -- 
> > 1.6.0.340.g84854
