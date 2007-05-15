Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXEOMlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXEOMlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXEOMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:40:58 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:56337 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXEOMk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:40:57 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: swap prefetch more improvements
Date: Tue, 15 May 2007 22:43:57 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ck@vds.kolivas.org
References: <200705141050.55038.kernel@kolivas.org> <20070514150032.d3ef6bb1.akpm@linux-foundation.org> <1179223081.6810.133.camel@twins>
In-Reply-To: <1179223081.6810.133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705152243.57871.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 19:58, Peter Zijlstra wrote:
> On Mon, 2007-05-14 at 15:00 -0700, Andrew Morton wrote:
> > On Mon, 14 May 2007 10:50:54 +1000
> >
> > Con Kolivas <kernel@kolivas.org> wrote:
> > > akpm, please queue on top of "mm: swap prefetch improvements"
> > >
> > > ---
> > > Failed radix_tree_insert wasn't being handled leaving stale kmem.
> > >
> > > The list should be iterated over in the reverse order when prefetching.
> > >
> > > Make the yield within kprefetchd stronger through the use of
> > > cond_resched.
> >
> > hm.
> >
> > > -		might_sleep();
> > > -		if (!prefetch_suitable())
> > > +		/* Yield to anything else running */
> > > +		if (cond_resched() || !prefetch_suitable())
> > >  			goto out_unlocked;
> >
> > So if cond_resched() happened to schedule away, we terminate this
> > swap-tricking attempt.  It's not possible to determine the reasons for
> > this from the code or from the changelog (==bad).
> >
> > How come?
>
> I think Con meant need_resched(). That would indicate someone else wants
> to use the CPU and and has higher priority than kprefetchd.

It may well be that need_resched is what I was trying to do... I don't need it 
to do the resched and _then_ break out of swap prefetch.

-- 
-ck
