Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbXJAUuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbXJAUuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXJAUuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:50:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42521 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243AbXJAUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:50:45 -0400
Date: Mon, 1 Oct 2007 13:50:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <200709281514.48293.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <200709281514.48293.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Nick Piggin wrote:

> I thought it was slower. Have you fixed the performance regression?
> (OK, I read further down that you are still working on it but not confirmed
> yet...)

The problem is with the weird way of Intel testing and communication. 
Every 3-6 month or so they will tell you the system is X% up or down on 
arch Y (and they wont give you details because its somehow secret). And 
then there are conflicting statements by the two or so performance test 
departments. One of them repeatedly assured me that they do not see any 
regressions.

> OK, so long as it isn't going to depend on using higher order pages, that's
> fine. (if they help even further as an optional thing, that's fine too. You
> can turn them on your huge systems and not even bother about adding
> this vmap fallback -- you won't have me to nag you about these
> purely theoretical issues).

Well the vmap fallback is generally useful AFAICT. Higher order 
allocations are common on some of our platforms. Order 1 failures even 
affect essential things like stacks that have nothing to do with SLUB and 
the LBS patchset.


