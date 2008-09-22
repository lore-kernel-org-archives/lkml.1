Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYIVQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYIVQRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYIVQRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:17:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36929 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYIVQRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:17:08 -0400
Date: Mon, 22 Sep 2008 17:17:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Message-ID: <20080922161705.GA7716@csn.ul.ie>
References: <1222047492-27622-1-git-send-email-mel@csn.ul.ie> <1222047492-27622-2-git-send-email-mel@csn.ul.ie> <20080922013053.39fd367a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080922013053.39fd367a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (22/09/08 01:30), Andrew Morton didst pronounce:
> On Mon, 22 Sep 2008 02:38:11 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +		   vma_page_size(vma) >> 10);
> >  
> >  	return ret;
> >  }
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 32e0ef0..0c83445 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -231,6 +231,19 @@ static inline unsigned long huge_page_size(struct hstate *h)
> >  	return (unsigned long)PAGE_SIZE << h->order;
> >  }
> >  
> > +static inline unsigned long vma_page_size(struct vm_area_struct *vma)
> > +{
> > +	struct hstate *hstate;
> > +
> > +	if (!is_vm_hugetlb_page(vma))
> > +		return PAGE_SIZE;
> > +
> > +	hstate = hstate_vma(vma);
> > +	VM_BUG_ON(!hstate);
> > +
> > +	return 1UL << (hstate->order + PAGE_SHIFT);
> > +}
> > +
> 
> CONFIG_HUGETLB_PAGE=n?
> 

Fails miserably.

> What did you hope to gain by inlining this?
> 

Inclusion with similar helper functions in the header but it's the wrong thing
to do in this case, obvious when pointed out. It's too large and called from
multiple places. I'll revise the patch

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
