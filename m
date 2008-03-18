Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYCSTfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYCSTfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYCST1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbYCST1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:27:31 -0400
Date: Tue, 18 Mar 2008 09:45:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 3/8] mm: rotate_reclaimable_page() cleanup
Message-Id: <20080318094541.7f19bfe4.akpm@linux-foundation.org>
In-Reply-To: <E1JbaQk-0005iw-67@pomaz-ex.szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	<20080317191944.208962764@szeredi.hu>
	<1205839896.8514.344.camel@twins>
	<E1JbaQk-0005iw-67@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 12:56:34 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > -int rotate_reclaimable_page(struct page *page)
> > > +void  rotate_reclaimable_page(struct page *page)
> > >  {
> > > -	struct pagevec *pvec;
> > > -	unsigned long flags;
> > > -
> > > -	if (PageLocked(page))
> > > -		return 1;
> > > -	if (PageDirty(page))
> > > -		return 1;
> > > -	if (PageActive(page))
> > > -		return 1;
> > > -	if (!PageLRU(page))
> > > -		return 1;
> > 
> > Might be me, but I find the above easier to read than

Me too, but (believe it or not) sometimes I will eschew comment ;)

> > > +	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
> > > +	    PageLRU(page)) {
> > >  
> 
> Matter of taste, returning from a middle of a function is generally to
> be avoided (unless not).

Avoiding multiple returns is more than a matter of taste: the practice is a
source of code bloat, resource leaks and locking errors.

But we do do it quite commonly at the start of the function when checking the
arguments, before the function has actually altered anything.


