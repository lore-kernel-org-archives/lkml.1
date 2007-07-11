Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXGKQqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXGKQqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXGKQqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:46:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXGKQqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:46:47 -0400
Date: Wed, 11 Jul 2007 09:46:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: -mm merge plans -- lumpy reclaim
Message-Id: <20070711094600.b2a525d5.akpm@linux-foundation.org>
In-Reply-To: <4694A427.7070708@shadowen.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<46937DA2.4040302@shadowen.org>
	<4694A427.7070708@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 10:34:31 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> [Seems a PEBKAC occured on the subject line, resending lest it become a
> victim of "oh thats spam".]
> 
> Andy Whitcroft wrote:
> > Andrew Morton wrote:
> > 
> > [...]
> >> lumpy-reclaim-v4.patch
> >> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> >> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> >>
> >>  Lumpy reclaim.  In a similar situation to Mel's patches.  Stuck due to
> >>  general lack or interest and effort.
> > 
> > The lumpy reclaim patches originally came out of work to support Mel's
> > anti-fragmentation work.  As such I think they have become somewhat
> > attached to those patches.  Whilst lumpy is most effective where
> > placement controls are in place as offered by Mel's work, we see benefit
> > from reduction in the "blunderbuss" effect when we reclaim at higher
> > orders.  While placement control is pretty much required for the very
> > highest orders such as huge page size, lower order allocations are
> > benefited in terms of lower collateral damage.
> > 
> > There are now a few areas other than huge page allocations which can
> > benefit.  Stacks are still order 1.  Jumbo frames want higher order
> > contiguous pages for there incoming hardware buffers.  SLUB is showing
> > performance benefits from moving to a higher allocation order.  All of
> > these should benefit from more aggressive targeted reclaim, indeed I
> > have been surprised just how often my test workloads trigger lumpy at
> > order 1 to get new stacks.
> > 
> > Truly representative work loads are hard to generate for some of these.
> >  Though we have heard some encouraging noises from those who can
> > reproduce these problems.

I'd expect that the main application for lumpy-reclaim is in keeping a pool
of order-2 (say) pages in reserve for GFP_ATOMIC allocators.  ie: jumbo
frames.

At present this relies upon the wakeup_kswapd(..., order) mechanism.

How effective is this at solving the jumbo frame problem?

(And do we still have a jumbo frame problem?  Reports seems to have subsided)
