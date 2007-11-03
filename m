Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbXKCUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbXKCUD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbXKCUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:03:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:39162 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbXKCUDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:03:47 -0400
Date: Sat, 3 Nov 2007 20:03:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slub: fix Objects count
In-Reply-To: <Pine.LNX.4.64.0711031226131.5695@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711031954080.17078@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031125090.5395@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031904470.14407@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031226131.5695@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Christoph Lameter wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> 
> > I was afraid you might say something like that.
> > Perhaps it'll be a patch I need to use in my own builds.
> > Though I'd have thought others would want that accuracy too.
> > Didn't SLAB give it?  (The "r*gr*ss**n" word!)
> 
> Slab also only counts objects that are not in the queues. See free_block() 
> f.e.

I'll take your word for it, and apologize for my slur on slub!
(Slub has a great deal to admire in it, I should say.)

> 
> We could improve the situation by flushing all cpu slabs before counts are 
> determined.
> 
> Which can be done manually. Run
> 
> 	slabinfo -s
> 
> and then look at the numbers.

Mmm, I'd been doing slabinfo -v sometimes.  These are fine in some
situations, but it's always better when the observer can avoid
interfering with the observed.  Impossible, we know, but...

Also, many caches too quickly re-equip themselves
with cpu slabs which again obscure the numbers.

> > > Adds to much overhead to the fast paths
> > 
> > You've come to that conclusion very quickly!
> 
> I have just spend a few weeks optimizing the fast and slow paths and there 
> is some additional overhead that I am still trying to eliminate.
> 
> > Any numbers to back it up?
> 
> The performance in the fast paths depends on updating only a single word
> for an allocation. Adding another counter makes that impossible.

Gosh, that's a tighter corner than any I've been in.

> 
> See the recent post on SLUB regression on SMP.

I'll have to read up on that, thanks for the pointer.

Hugh
