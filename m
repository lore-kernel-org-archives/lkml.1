Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbXLJMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbXLJMNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbXLJMNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:13:41 -0500
Received: from phunq.net ([64.81.85.152]:60560 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751764AbXLJMNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:13:40 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 04:13:37 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100323.48535.phillips@phunq.net> <20071210114123.GE5008@kernel.dk>
In-Reply-To: <20071210114123.GE5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100413.38077.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 03:41, Jens Axboe wrote:
> On Mon, Dec 10 2007, Daniel Phillips wrote:
> > +       if (q && q->metric && !bio->bi_queue) {
> >
> > This prevents any reference to bi_bdev after the intial call to
> > generic_make_request.  Thanks to Evgeniy for pointing out the need
> > for this measure on the last go round.
>
> Which saves the initial target, for ease of accounting at end io time
> - that's not the point. What happens when ->make_request_fn() changes
> bio->bi_bdev and returns 1, causing another iteration of the
> __generic_make_request() loop? 'q' is no longer the valid target,
> bdev_get_queue(bio->bi_bdev) is.

What happens on the second iteration of a recursive submission loop is 
exactly nothing, as is right and proper.  The throttling has already 
been done, and all the state necessary to perform the unthrottle was 
recorded in the bio.  Everything seems to be in order there, and the 
algorithm does indeed perform its function as designed, though to be 
sure we have not tested it on -mm branch, only on mainline.

Regards,

Daniel
