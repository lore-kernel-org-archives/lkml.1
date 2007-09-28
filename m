Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXI1Sxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXI1Sxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXI1Sxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:53:37 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:48267 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXI1Sxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:53:37 -0400
Date: Fri, 28 Sep 2007 19:53:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] hugetlb: Fix clear_user_highpage arguments
Message-ID: <20070928185335.GA10976@linux-mips.org>
References: <20070928163545.GA5933@linux-mips.org> <20070928114526.3398c462.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928114526.3398c462.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:45:26AM -0700, Andrew Morton wrote:

> 
> > The virtual address space argument of clear_user_highpage is supposed to
> > be the virtual address where the page being cleared will eventually be
> > mapped. This allows architectures with virtually indexed caches a few
> > clever tricks.  That sort of trick falls over in painful ways if the
> > virtual address argument is wrong.
> 
> yeah, but only if you're using a weird CPU architecture ;)

I guess once I convinced your employer that weird CPU architectures
deliver more punch for the watt they stop being so weird ;-)

> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 84c795e..eab8c42 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -42,7 +42,7 @@ static void clear_huge_page(struct page *page, unsigned long addr)
> >  	might_sleep();
> >  	for (i = 0; i < (HPAGE_SIZE/PAGE_SIZE); i++) {
> >  		cond_resched();
> > -		clear_user_highpage(page + i, addr);
> > +		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
> >  	}
> >  }
> >  
> 
> I'll add this to the 2.6.23 queue.  Is it needed in 2.6.22.x?

It's totally theoretical atm, MIPS doesn't support hugetlb and I'm not
even working on it.  I just happened to spot the issue.

  Ralf
