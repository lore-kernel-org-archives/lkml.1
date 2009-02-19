Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZBSNP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZBSNP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZBSNPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:15:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49994 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZBSNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:15:37 -0500
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <2f11576a0902190451w294aa2fan29b61fa3619f459b@mail.gmail.com>
References: <20090218093858.8990.A69D9226@jp.fujitsu.com>
	 <1234944569.24030.20.camel@penberg-laptop>
	 <20090219085229.954A.A69D9226@jp.fujitsu.com>
	 <1235034967.29813.10.camel@penberg-laptop>
	 <2f11576a0902190451w294aa2fan29b61fa3619f459b@mail.gmail.com>
Date: Thu, 19 Feb 2009 15:15:34 +0200
Message-Id: <1235049334.29813.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 21:51 +0900, KOSAKI Motohiro wrote:
> 2009/2/19 Pekka Enberg <penberg@cs.helsinki.fi>:
> > On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
> >> > > In addition, if pekka patch (SLAB_LIMIT = 8K) run on ia64, 16K allocation
> >> > > always fallback to page allocator and using 64K (4 times memory consumption!).
> >> >
> >> > Yes, correct, but SLUB does that already by passing all allocations over
> >> > 4K to the page allocator.
> >>
> >> hmhm
> >> OK. my mail was pointless.
> >>
> >> but why? In my understanding, slab framework mainly exist for efficient
> >> sub-page allocation.
> >> the fallbacking of 4K allocation in 64K page-sized architecture seems
> >> inefficient.
> >
> > I don't think any of the slab allocators are known for memory
> > efficiency. That said, the original patch description sums up the
> > rationale for page allocator pass-through:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=aadb4bc4a1f9108c1d0fbd121827c936c2ed4217
> >
> > Interesting enough, there seems to be some performance gain from it as
> > well as seen by Mel Gorman's recent slab allocator benchmarks.
> 
> Honestly, I'm bit confusing.
> above url's patch use PAGE_SIZE, but not 4K nor architecture independent value.
> Your 4K mean PAGE_SIZE?

Yes, I mean PAGE_SIZE. 4K page sizes are hard-wired into my brain,
sorry :-)

