Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbXJBRjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbXJBRjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbXJBRjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:39:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53666 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbXJBRjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:39:00 -0400
Subject: Re: kswapd min order, slub max order [was Re: -mm merge plans for
	2.6.24]
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chritoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710021646420.4916@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0710021646420.4916@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 19:38:53 +0100
Message-Id: <1191350333.2708.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 17:06 +0100, Hugh Dickins wrote:
> On Mon, 1 Oct 2007, Andrew Morton wrote:
> > #
> > # slub && antifrag
> > #
> > have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> > only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> > slub-exploit-page-mobility-to-increase-allocation-order.patch
> > slub-reduce-antifrag-max-order.patch
> > 
> >   I think this stuff is in the "mm stuff we don't want to merge" category. 
> >   If so, I really should have dropped it ages ago.
> 
> I agree.  I spent a while last week bisecting down to see why my heavily
> swapping loads take 30%-60% longer with -mm than mainline, and it was
> here that they went bad.  Trying to keep higher orders free is costly.
> 

Very interesting. I had agreed with these patches being pulled but it
was simply on the grounds that there was no agreement it was the right
thing to do. It was best to have mainline and -mm behave the same from a
fragmentation perspective and revisit this idea from scratch. That it
affects swapping loads is news so thanks for that.

> On the other hand, hasn't SLUB efficiency been built on the expectation
> that higher orders can be used?  And it would be a twisted shame for
> high performance to be held back by some idiot's swapping load.
> 

My belief is that SLUB can still use the higher orders if configured to
do so at boot-time. The loss of these patches means it won't try and do
it automatically. Christoph will chime in I'm sure.

-- 
Mel Gorman

