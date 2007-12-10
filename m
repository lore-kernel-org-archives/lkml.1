Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXLJMf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXLJMf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXLJMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:35:51 -0500
Received: from brick.kernel.dk ([87.55.233.238]:26953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXLJMfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:35:50 -0500
Date: Mon, 10 Dec 2007 13:32:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210123244.GG5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100413.38077.phillips@phunq.net> <20071210121627.GF5008@kernel.dk> <200712100427.58288.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100427.58288.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 04:16, Jens Axboe wrote:
> > OK, let me get the neon out then. This has nothing to do with
> > throttling, I thought I made it clear that I get why you store the
> > origin queue in ->bi_queue. I'm concerned with the workings of
> > redirecting a bio. Previously we looked up the queue associated with
> > bio->bi_bdev inside the loop in __generic_make_request(), as is
> > REQUIRED to correctly locate a DIFFERENT queue if bio->bi_bdev has
> > been changed to point somewhere else.
> 
> Rhetoric aside, again.
> 
> We are only interested in throttling against the bio->bi_bdev that was 
> stored in the bio at the time of the call to generic_make_request, why 
> should we care about the redirected value?

Let me repeat - this has nothing to do with throttling! You are breaking
the bio redirection by killing that bdev_get_queue() in the
__generic_make_request().

I honestly don't know how to make this any clearer than I already did
above. Sleep on it.

-- 
Jens Axboe

