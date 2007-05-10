Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXEJHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXEJHUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXEJHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:20:33 -0400
Received: from holomorphy.com ([66.93.40.71]:32768 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXEJHUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:20:33 -0400
Date: Thu, 10 May 2007 00:20:51 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ray Lee <ray-lk@madrabbit.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Message-ID: <20070510072051.GK19966@holomorphy.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705100928.34056.kernel@kolivas.org> <464261B5.6030809@yahoo.com.au> <200705101134.34350.kernel@kolivas.org> <46427BDB.30004@yahoo.com.au> <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com> <46429801.8030202@yahoo.com.au> <2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com> <4642C416.3000205@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642C416.3000205@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
>> Huh? You already stated one version of it above, namely updatedb. But

On Thu, May 10, 2007 at 05:04:54PM +1000, Nick Piggin wrote:
> So a swapping problem with updatedb should be unusual and we'd like to see
> if we can fix it without resorting to prefetching.
> I know the theory behind swap prefetching, and I'm not saying it doesn't
> work, so I'll snip the rest of that.

I've not run updatedb in years, so I have no idea what it does to a
modern kernel. It used to be an unholy terror of slab fragmentation
and displacing user memory. The case of streaming kernel metadata IO
is probably not quite as easy as streaming file IO.


Ray Lee wrote:
>> You said, effectively: "Use-once could be improved to deal with
>> updatedb". I said I've been reading emails from Rik and others talking
>> about that for four years now, and we're still talking about it. Were
>> it merely updatedb, I'd say us userspace folk should step up and
>> rewrite the damn thing to amortize its work. However, I and others
>> feel it's only an example -- glaring, obviously -- of a more pervasive
>> issue. A small issue, to be sure!, but an issue nevertheless.

On Thu, May 10, 2007 at 05:04:54PM +1000, Nick Piggin wrote:
> It isn't going to get fixed unless people complain about it. If you
> cover the use-once problem with swap prefetching, then it will never
> get fixed.

The policy people need to clean this up once and for all at some point.
clameter's targeted reclaim bits for slub look like a plausible tactic,
but are by no means comprehensive. Things need to attempt to eat their
own tails before eating everyone else alive. Maybe we need to take hits
on things such as badari's dd's to resolve the pathologies.


-- wli
