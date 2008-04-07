Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYDGV0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYDGV0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYDGV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:26:05 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36310 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYDGV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:26:04 -0400
Date: Mon, 7 Apr 2008 22:30:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <47FA8CB0.6070106@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0804072215300.2442@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy>
 <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi>
 <47FA8CB0.6070106@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Pekka Enberg wrote:
> Pekka Enberg wrote:
> > Although you weren't convinced by my arguments, I still have difficulties
> > understanding why this kind of bad behavior would be acceptable in an
> > embedded environment and why we don't need to fix it for the SLOB case as
> > well.

If we do decide that it's seriously bad behaviour, then of course
it should be fixed in SLOB also.  I just meant that the fact that
SLOB's been merging slabs too doesn't give me great confidence that
that's the right and safe thing to do: SLOB isn't our gold standard.

> > 
> > But you do bring up a good point of SLUB changing the behavior on OOM
> > situations for which SLAB_NOMERGE sounds like a good-enough stop-gap measure
> > for the short term. I would prefer some other fix even if it means getting
> > rid of slab merging competely (which would suck as it's very nice for making
> > memory footprint smaller).
> 
> I wonder if we can get away with a SLAB_IO flag that you can use to annotate
> caches that participate in writeout and the allocator could keep some spare
> pages around that can be handed out for them in case of OOM...

Well, the work of keeping spares around to be handed out in case of
OOM was done in 2.5 with mempools.  They seem to be working well
(until you try swapping over network as Peter is pursuing),
I don't think we need to duplicate that.

I've the uncomfortable feeling that I'm making a big fuss over this
behaviour on the one hand, but utterly failing to justify that fuss
on the other.  It seems to come down to me wanting fewer backtraces
in my logs: I'd better find stronger reasons than that if we're to
pursue this.

Hugh
