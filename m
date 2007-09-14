Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbXINRxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbXINRxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXINRw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:52:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58565 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752510AbXINRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:52:56 -0400
Date: Fri, 14 Sep 2007 10:52:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709140651.30735.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709141048320.15813@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709120407.48344.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
 <200709140651.30735.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Nick Piggin wrote:

> > > [*] ok, this isn't quite true because if you can actually put a hard
> > > limit on unmovable allocations then anti-frag will fundamentally help --
> > > get back to me on that when you get patches to move most of the obvious 
> > > ones.
> >
> > We have this hard limit using ZONE_MOVABLE in 2.6.23.
> 
> So we're back to 2nd class support.

2nd class support for me means a feature that is not enabled by default 
but that can be enabled in order to increase performance. The 2nd class 
support is there because we are not yet sure about the maturity of the 
memory allocation methods.

 
> > Reserve pools as handled (by the not yet available) large page pool
> > patches (which again has altogether another purpose) are not a limit. The
> > reserve pools are used to provide a mininum of higher order pages that is
> > not broken down in order to insure that a mininum number of the desired
> > order of pages is even available in your worst case scenario. Mainly I
> > think that is needed during the period when memory defragmentation is
> > still under development.
> 
> fsblock doesn't need any of those hacks, of course.

Nor does mine for the low orders that we are considering. For order > 
MAX_ORDER this is unavoidable since the page allocator cannot manage such 
large pages. It can be used for lower order if there are issues (that I 
have not seen yet).

