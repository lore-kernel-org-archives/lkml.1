Return-Path: <linux-kernel-owner+w=401wt.eu-S934671AbXGWXRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbXGWXRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbXGWXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:17:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41083 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933955AbXGWXRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:17:14 -0400
Date: Mon, 23 Jul 2007 16:17:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <1185190711.8197.15.camel@twins>
Message-ID: <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>  <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Peter Zijlstra wrote:

> ---
> Daniel recently spotted that __GFP_ZERO is not (and has never been)
> part of GFP_LEVEL_MASK. I could not find a reason for this in the
> original patch: 3977971c7f09ce08ed1b8d7a67b2098eb732e4cd in the -bk
> tree.
> 
> This of course is in stark contradiction with the comment accompanying
> GFP_LEVEL_MASK.

NACK.

The effect that this patch will have is that __GFP_ZERO is passed through 
to the page allocator which will needlessly zero pages. GFP_LEVEL_MASK is 
used to filter out the flags that are to be passed to the page allocator. 
__GFP_ZERO is not passed on but handled by the slab allocators.


