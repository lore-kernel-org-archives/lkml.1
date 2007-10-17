Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXJQSlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXJQSlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXJQSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:40:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16502 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXJQSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:40:54 -0400
Date: Wed, 17 Oct 2007 20:40:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017184049.GV15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org> <20071017180042.GP15552@kernel.dk> <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710171119250.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171119250.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Linus Torvalds wrote:
> > 
> > So I think your change to use "sg_next()" only when you actually need a 
> > next pointer is the correct one after all.
> 
> That still leaves the initialization issue. The link pointers need to all 
> be initialized at SG allocation time (and not just the last one for the 
> case where it's a linked entry).
> 
> And if you initialize them at allocation time, does an allocation ever get 
> re-used without being free'd in between (if it does, you do indeed need to 
> initialize the non-link pointers each time - but I don't see it being the 
> case, so ..)

The links will not change, so reuse should actually be OK. The reuse
cannot be larger than the original would hold, but that would be a bug
without chaining as well of course.

WRT reuse, if we end up requeuing a request, than we will go through the
whole thing again. I don't think Ingo is hitting that either, though.

-- 
Jens Axboe

