Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZBWUK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZBWUK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZBWUKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:10:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZBWUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:10:10 -0500
Subject: Re: [PATCH] mm: gfp_to_alloc_flags()
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <20090223181713.GS6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235390103.4645.80.camel@laptop>  <20090223181713.GS6740@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:09:44 +0100
Message-Id: <1235419784.4645.704.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 18:17 +0000, Mel Gorman wrote:

> > 
> > -       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> > -                       && !in_interrupt()) {
> > -               if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> > 
> 
> At what point was this code deleted?

You moved it around a bit, but it ended up here:

> > -static inline int is_allocation_high_priority(struct task_struct *p,
> > -							gfp_t gfp_mask)
> > -{
> > -	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> > -			&& !in_interrupt())
> > -		if (!(gfp_mask & __GFP_NOMEMALLOC))
> > -			return 1;
> > -	return 0;
> > -}

