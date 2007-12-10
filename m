Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXLJLoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXLJLoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXLJLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:44:30 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21197 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbXLJLo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:44:29 -0500
Date: Mon, 10 Dec 2007 12:41:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210114123.GE5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <20071210104749.GC5008@kernel.dk> <200712100323.48535.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100323.48535.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 02:47, Jens Axboe wrote:
> > Ehm, this patch is so broken it's not even funny - did you even
> > compile? You would have noticed the warning on request_queue_t,
> > surely. The big problem is the last hunk here though, how would that
> > work on stacked devices? Clue: ->bi_bdev is not const, it can change
> > after a call to ->make_request_fn().
> 
> Such paranoia.  Yes, the patch was compiled.   Yes, the warning was 
> slipped through.  No, it is not substantive, and in fact was removed 
> from another branch of our tree already.
> 
> Ignoring the rhetoric, apparently you missed the line:
> 
> +       if (q && q->metric && !bio->bi_queue) {
> 
> The prevents any reference ti bi_bdev after the intial call to 
> generic_make_request.  Thanks to Evgeniy for pointing out the need for 
> this measure on the last go round.

Which saves the initial target, for ease of accounting at end io time -
that's not the point. What happens when ->make_request_fn() changes
bio->bi_bdev and returns 1, causing another iteration of the
__generic_make_request() loop? 'q' is no longer the valid target,
bdev_get_queue(bio->bi_bdev) is.

> "So broken" is a gross exaggeration.  Substantive comments welcome.

Or you could try and make an effort to understand the comment instead of
just glancing over it.

-- 
Jens Axboe

