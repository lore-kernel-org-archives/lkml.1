Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZEJLWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZEJLWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 07:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZEJLWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 07:22:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:32291 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbZEJLWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 07:22:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,323,1239001200"; 
   d="scan'208";a="141180733"
Date: Sun, 10 May 2009 19:21:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class  citizen
Message-ID: <20090510112149.GA8633@localhost>
References: <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090508230045.5346bd32@lxorguk.ukuu.org.uk> <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com> <20090510092053.GA7651@localhost> <2f11576a0905100229m2c5e6a67md555191dc8c374ae@mail.gmail.com> <20090510100335.GC7651@localhost> <2f11576a0905100315j2c810e96mc29b84647dc565c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0905100315j2c810e96mc29b84647dc565c2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 06:15:02PM +0800, KOSAKI Motohiro wrote:
> >> >> >> The patch seems reasonable but the changelog and the (non-existent)
> >> >> >> design documentation could do with a touch-up.
> >> >> >
> >> >> > Is it right that I as a user can do things like mmap my database
> >> >> > PROT_EXEC to get better database numbers by making other
> >> >> > stuff swap first ?
> >> >> >
> >> >> > You seem to be giving everyone a "nice my process up" hack.
> >> >>
> >> >> How about this?
> >> >
> >> > Why it deserves more tricks? PROT_EXEC pages are rare.
> >> > If user space is to abuse PROT_EXEC, let them be for it ;-)
> >>
> >> yes, typicall rare.
> >> tha problem is, user program _can_ use PROT_EXEC for get higher priority
> >> ahthough non-executable memory.
> >
> > - abuses should be rare
> > - large scale abuses will be even more rare,
> > - the resulted vmscan overheads are the *expected* side effect
> > - the side effects are still safe
> 
> Who expect?
> The fact is, application developer decide to use PROT_EXEC, but side-effect
> cause end-user, not application developer.
> 
> In general, side-effect attack mistaked guy, it's no problem. They can
> do it their own risk.
> but We know application developer and administrator are often different person.
> 
> 
> > So if that's what they want, let them have it to their heart's content.
> >
> > You know it's normal for many users/apps to care only about the result.
> > When they want something but cannot get it from the smarter version of
> > PROT_EXEC heuristics, they will go on to devise more complicated tricks.
> >
> > In the end both sides loose.
> >
> > If the abused case is important enough, then let's introduce a feature
> > to explicitly prioritize the pages. But let's leave the PROT_EXEC case
> > simple.
> 
> No.
> explicit priotize mechanism don't solve problem anyway. application
> developer don't know end-user environment.
> they can't mark proper page priority.

So it's simply wrong for an application to prioritize itself and is
not fair gaming and hence should be blamed. I doubt any application
aimed for a wide audience will do this insane hack. But specific
targeted applications are more likely to do all tricks which fits
their needs&environment, and likely they are doing so for good reasons
and are aware of the consequences.
