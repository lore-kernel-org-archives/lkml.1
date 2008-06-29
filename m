Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbYF2SXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbYF2SXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYF2SXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 14:23:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbYF2SXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 14:23:08 -0400
Date: Sun, 29 Jun 2008 20:23:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] block: GFP_ATOMIC is __GFP_HIGH
Message-ID: <20080629182304.GG20826@kernel.dk>
References: <Pine.LNX.4.64.0806290052350.18327@blonde.site> <20080629043827.135f39d7@linux360.ro> <Pine.LNX.4.64.0806290700160.7279@blonde.site> <20080629171528.5590b78b@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629171528.5590b78b@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29 2008, Eduard - Gabriel Munteanu wrote:
> On Sun, 29 Jun 2008 07:16:49 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > but it is not
> > accidental that GFP_ATOMIC includes __GFP_HIGH - it's precisely when
> > we're atomic that we need access to those extra reserves; and where
> > we don't actually want them then we do say GFP_NOWAIT not GFP_ATOMIC.
> 
> I would expect GFP_ATOMIC just prevents sleeping, while it _could_ fail
> (in theory) unless it is allowed to touch the emergency pools.
> 
> Actually, in many/most atomic contexts bail-out paths are possible for
> allocation failures. And many/most of these atomic contexts have no
> special reason to require emergency memory. Think about the usual
> allocations enclosed within spinlocks.

I have to agree with Eduard here - GFP_ATOMIC means "don't block"
primarily, whether it has a given priority or not is something you would
have to look up. So it's more readable with the __GFP_HIGH manually
added.

> > I expect the gfp flags will change in the future; but unless I missed
> > somewhere, amongst all the places which specify GFP_ATOMIC throughout
> > the kernel, this is the only one which ors in __GFP_HIGH too.  I don't
> > believe it expected access to extra extra reserves!  So I thought we'd
> > do best to remove the anomaly.
> 
> Yes, it seems this is the only place where this occurs.
> 
> Although I did not read all the code and resolved its implications, it
> seems like it actually needs something like __GFP_NOFAIL (?) instead of
> __GFP_HIGH. The slab itself is created with SLAB_PANIC.

It's not a big deal, it'll recover fine.

-- 
Jens Axboe

