Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZAVAdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZAVAdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZAVAdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:33:14 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:55136 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZAVAdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:33:13 -0500
Date: Wed, 21 Jan 2009 19:19:08 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090119054730.GA22584@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0901211914140.18367@qirst.com>
References: <20090114114707.GA24673@wotan.suse.de> <84144f020901140544v56b856a4w80756b90f5b59f26@mail.gmail.com> <20090114142200.GB25401@wotan.suse.de> <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com> <20090114150900.GC25401@wotan.suse.de>
 <Pine.LNX.4.64.0901141158090.26507@quilx.com> <20090115060330.GB17810@wotan.suse.de> <Pine.LNX.4.64.0901151320250.26467@quilx.com> <20090116031940.GL17810@wotan.suse.de> <Pine.LNX.4.64.0901161500080.27283@quilx.com> <20090119054730.GA22584@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Nick Piggin wrote:

> The thing IMO you forget with all these doomsday scenarios about SGI's peta
> scale systems is that no matter what you do, you can't avoid the fact that
> computing is about locality. Even if you totally take the TLB out of the
> equation, you still have the small detail of other caches. Code that jumps
> all over that 1024 TB of memory with no locality is going to suck regardless
> of what the kernel ever does, due to physical limitations of hardware.

Typically we traverse lists of objects that are in the same slab cache.

> > Sorry not at all. SLAB and SLQB queue objects from different pages in the
> > same queue.
>
> The last sentence is what I was replying to. Ie. "simplification of
> numa handling" does not follow from the SLUB implementation of per-page
> freelists.

If all objects are from the same page then you need not check
the NUMA locality of any object on that queue.

> > As I sad it pins a single page in the per cpu page and uses that in a way
> > that you call a queue and I call a freelist.
>
> And you found you have to increase the size of your pages because you
> need bigger queues. (must we argue semantics? it is a list of free
> objects)

Right. That may be the case and its a similar tuning to what SLAB does.

> > SLAB and SLUB can have large quantities of objects in their queues that
> > each can keep a single page out of circulation if its the last
> > object in that page. This is per queue thing and you have at least two
>
> And if that were a problem, SLQB can easily be runtime tuned to keep no
> objects in its object lists. But as I said, queueing is good, so why
> would anybody want to get rid of it?

Queing is sometimes good....

> Again, this doesn't really go anywhere while we disagree on the
> fundamental goodliness of queueing. This is just describing the
> implementation.

I am not sure that you understand the fine points of queuing in slub. I am
not a fundamentalist: Queues are good if used the right way and as you say
SLUB has "queues" designed in a particular fashion that solves issus that
we had with SLAB queues.


