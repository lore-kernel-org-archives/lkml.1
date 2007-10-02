Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbXJCBmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbXJCBmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbXJCBmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:42:43 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:33144 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753130AbXJCBmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:42:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OGWCZfXKuA30BA6jZip7IIG3WyaR/4w3BhVywMD+8+c2w9I1uR+Sm+sAx/w/+nwj90ZRSUD2GJHVEhnQEUtSvDEsPY3yLnEuqAE2I7Ywxc/pCM18ex8OTDqOnCVKAIlcAle7GWx7XJf4ezSbONlc85KdekL6xaPxdOCpbUtP/5c=  ;
X-YMail-OSG: mInxwREVM1nClYIFzyjeICY7dFLYt8sFiwg1maOtRLRhRbB1dH9HqJxrC3hMNGuwoqQARFDwIw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: kswapd min order, slub max order [was Re: -mm merge plans for 2.6.24]
Date: Tue, 2 Oct 2007 19:10:58 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chritoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <Pine.LNX.4.64.0710021646420.4916@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0710021646420.4916@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021910.58983.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 02:06, Hugh Dickins wrote:
> On Mon, 1 Oct 2007, Andrew Morton wrote:
> > #
> > # slub && antifrag
> > #
> > have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> > only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocation
> >s.patch slub-exploit-page-mobility-to-increase-allocation-order.patch
> > slub-reduce-antifrag-max-order.patch
> >
> >   I think this stuff is in the "mm stuff we don't want to merge"
> > category. If so, I really should have dropped it ages ago.
>
> I agree.  I spent a while last week bisecting down to see why my heavily
> swapping loads take 30%-60% longer with -mm than mainline, and it was
> here that they went bad.  Trying to keep higher orders free is costly.

Yeah, no there's no way we'd merge that.


> On the other hand, hasn't SLUB efficiency been built on the expectation
> that higher orders can be used?  And it would be a twisted shame for
> high performance to be held back by some idiot's swapping load.

IMO it's a bad idea to create all these dependencies like this.

If SLUB can get _more_ performance out of using higher order allocations,
then fine. If it is starting off at a disadvantage at the same order, then it
that should be fixed first, right?

