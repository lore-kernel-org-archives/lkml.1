Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXEOJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXEOJ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759141AbXEOJ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:58:14 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:47355 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759122AbXEOJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:58:14 -0400
Subject: Re: [PATCH] mm: swap prefetch more improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ck@vds.kolivas.org
In-Reply-To: <20070514150032.d3ef6bb1.akpm@linux-foundation.org>
References: <200705141050.55038.kernel@kolivas.org>
	 <20070514150032.d3ef6bb1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 May 2007 11:58:01 +0200
Message-Id: <1179223081.6810.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:00 -0700, Andrew Morton wrote:
> On Mon, 14 May 2007 10:50:54 +1000
> Con Kolivas <kernel@kolivas.org> wrote:
> 
> > akpm, please queue on top of "mm: swap prefetch improvements"
> > 
> > ---
> > Failed radix_tree_insert wasn't being handled leaving stale kmem.
> > 
> > The list should be iterated over in the reverse order when prefetching.
> > 
> > Make the yield within kprefetchd stronger through the use of cond_resched.
> 
> hm.
> 
> > 
> > -		might_sleep();
> > -		if (!prefetch_suitable())
> > +		/* Yield to anything else running */
> > +		if (cond_resched() || !prefetch_suitable())
> >  			goto out_unlocked;
> 
> So if cond_resched() happened to schedule away, we terminate this
> swap-tricking attempt.  It's not possible to determine the reasons for this
> from the code or from the changelog (==bad).
> 
> How come?

I think Con meant need_resched(). That would indicate someone else wants
to use the CPU and and has higher priority than kprefetchd.



