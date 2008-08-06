Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYHFNtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYHFNtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYHFNtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:49:11 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:21340 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYHFNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:49:09 -0400
Subject: Re: [PATCH] hugetlb: call arch_prepare_hugepage() for surplus pages
From: gerald_IMAP <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, nacc@us.ibm.com, agl@us.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080805133216.cc5c14cf.akpm@linux-foundation.org>
References: <1217950147.5032.15.camel@localhost.localdomain>
	 <20080805133216.cc5c14cf.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 15:48:50 +0200
Message-Id: <1218030530.7764.18.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 13:32 -0700, Andrew Morton wrote:
> > ---
> > 
> >  mm/hugetlb.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > Index: linux/mm/hugetlb.c
> > ===================================================================
> > --- linux.orig/mm/hugetlb.c
> > +++ linux/mm/hugetlb.c
> > @@ -565,7 +565,7 @@ static struct page *alloc_fresh_huge_pag
> >  		huge_page_order(h));
> >  	if (page) {
> >  		if (arch_prepare_hugepage(page)) {
> > -			__free_pages(page, HUGETLB_PAGE_ORDER);
> > +			__free_pages(page, huge_page_order(h));
> 
> As Nick pointed out, this is an unrelated bugfix.  I changelogged it. 
> Really it should have been two patches.

Ok, thanks. I didn't see it as a bugfix because it doesn't make any
difference on s390, and nobody else is using arch_prepare_hugepage()
so far. But of course this may change, so I should have made two
patches.

> afaict the second fix is needed in 2.6.26.x (but not 2.6.25.x), but
> this patch is not applicable to 2.6.26.x.
> 
> So if you want this fix to be backported into 2.6.26.x, please send a
> suitable version of it to stable@kernel.org.

Right, this was missing from the beginning. It affects s390 only,
so I'll check if we need a backport.

Thanks,
Gerald


