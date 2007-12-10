Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXLJLYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXLJLYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXLJLXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:23:53 -0500
Received: from phunq.net ([64.81.85.152]:60899 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbXLJLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:23:52 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 03:23:48 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <20071210104749.GC5008@kernel.dk>
In-Reply-To: <20071210104749.GC5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100323.48535.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 02:47, Jens Axboe wrote:
> Ehm, this patch is so broken it's not even funny - did you even
> compile? You would have noticed the warning on request_queue_t,
> surely. The big problem is the last hunk here though, how would that
> work on stacked devices? Clue: ->bi_bdev is not const, it can change
> after a call to ->make_request_fn().

Such paranoia.  Yes, the patch was compiled.   Yes, the warning was 
slipped through.  No, it is not substantive, and in fact was removed 
from another branch of our tree already.

Ignoring the rhetoric, apparently you missed the line:

+       if (q && q->metric && !bio->bi_queue) {

The prevents any reference ti bi_bdev after the intial call to 
generic_make_request.  Thanks to Evgeniy for pointing out the need for 
this measure on the last go round.

"So broken" is a gross exaggeration.  Substantive comments welcome.

Daniel
