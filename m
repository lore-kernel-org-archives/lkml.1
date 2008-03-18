Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYCRL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYCRL4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYCRL4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:56:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47945 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYCRL4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:56:38 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1205839896.8514.344.camel@twins> (message from Peter Zijlstra on
	Tue, 18 Mar 2008 12:31:36 +0100)
Subject: Re: [patch 3/8] mm: rotate_reclaimable_page() cleanup
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191944.208962764@szeredi.hu> <1205839896.8514.344.camel@twins>
Message-Id: <E1JbaQk-0005iw-67@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 12:56:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -int rotate_reclaimable_page(struct page *page)
> > +void  rotate_reclaimable_page(struct page *page)
> >  {
> > -	struct pagevec *pvec;
> > -	unsigned long flags;
> > -
> > -	if (PageLocked(page))
> > -		return 1;
> > -	if (PageDirty(page))
> > -		return 1;
> > -	if (PageActive(page))
> > -		return 1;
> > -	if (!PageLRU(page))
> > -		return 1;
> 
> Might be me, but I find the above easier to read than
> 
> > +	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
> > +	    PageLRU(page)) {
> >  

Matter of taste, returning from a middle of a function is generally to
be avoided (unless not).  Anyway, this is just a side effect of the
main cleanup, so I think I'm entitled to choose the style I prefer ;)

Miklos
