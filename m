Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXEUTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXEUTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXEUTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:03:07 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16995 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759AbXEUTDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:03:05 -0400
Date: Mon, 21 May 2007 21:00:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070521190043.GA4705@kernel.dk>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com> <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Christoph Lameter wrote:
> On Mon, 21 May 2007, Hugh Dickins wrote:
> 
> > On Mon, 21 May 2007, Christoph Lameter wrote:
> > > On Mon, 21 May 2007, Hugh Dickins wrote:
> > > 
> > > > Yes, sounded the same to me too: I couldn't reproduce it or see anything
> > > > wrong in the code back then.  But Srihari's info about CONFIG_DEBUG_SLUB
> > > > off has helped a lot: I was then able to reproduce it on my x86_64, and
> > > > after a lot of staring at the code, the problem became obvious...
> > > 
> > > Right. The #ifdef CONFIG_SLUB_DEBUG is at the wrong location. The best fix
> > > is to moving the #ifdef otherwise the size is still wrong for the 
> > > ctor case.
> > 
> > ? My patch did handle the ctor case.
> 
> True. I was thinking about just checking the problem case that we had 
> here.
> 
> > > SLUB Debug: Fix object size calculation
> > > 
> > > The object size calculation is wrong if !CONFIG_SLUB_DEBUG because
> > > the #ifdef CONFIG_SLUB_DEBUG is now switching off the size adjustments
> > > for DESTROY_BY_RCU and ctor.
> > > 
> > > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > 
> > Yes, I think that should do it too.  The reason behind my repeating
> > the block was to handle the case where SLAB_POISON is passed to
> > kmem_cache_create, but CONFIG_SLUB_DEBUG is off.  But apparently
> > that case would hit the BUG_ON(flags & ~CREATE_MASK), therefore
> > your patch is simpler and better.  Quite a maze.
> 
> Would you ack my patch? I do not want to repeat the block.

I can test whatever you want tomorrow morning, it was 100% repeatable
here. So which one, your patch or Hughs?

-- 
Jens Axboe

