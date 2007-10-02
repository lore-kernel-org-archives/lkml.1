Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXJBQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXJBQHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXJBQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:07:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:19569 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbXJBQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:07:07 -0400
Date: Tue, 2 Oct 2007 17:06:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chritoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: kswapd min order, slub max order [was Re: -mm merge plans for 2.6.24]
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710021646420.4916@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andrew Morton wrote:
> #
> # slub && antifrag
> #
> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> slub-exploit-page-mobility-to-increase-allocation-order.patch
> slub-reduce-antifrag-max-order.patch
> 
>   I think this stuff is in the "mm stuff we don't want to merge" category. 
>   If so, I really should have dropped it ages ago.

I agree.  I spent a while last week bisecting down to see why my heavily
swapping loads take 30%-60% longer with -mm than mainline, and it was
here that they went bad.  Trying to keep higher orders free is costly.

On the other hand, hasn't SLUB efficiency been built on the expectation
that higher orders can be used?  And it would be a twisted shame for
high performance to be held back by some idiot's swapping load.

Hugh
