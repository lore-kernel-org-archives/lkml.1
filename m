Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYGaBNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYGaBNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYGaBMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:12:46 -0400
Received: from waste.org ([66.93.16.53]:54520 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbYGaBMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:12:45 -0400
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
In-Reply-To: <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 20:09:43 -0500
Message-Id: <1217466583.18911.226.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-30 at 15:00 -0700, Linus Torvalds wrote:
> 
> On Thu, 31 Jul 2008, Pekka J Enberg wrote:
> > 
> > Subject: [PATCH] binalloc: best-fit allocation with binning
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Shoot me now. 
> 
> > As suggested by Linus,
> 
> I'm happy to hear that the thing worked, but I'm not sure how happy I 
> should be about yet _another_ allocator. Will it ever end?

I think you can relax: the logical limit is probably two. We want an
allocator that is both optimally fast and scalable on one end and
optimally space-efficient on the other end and we're unlikely to find
one allocator that is simultaneously both. But I don't think there's
much call for things in the middle of the spectrum.

So if this new one (which I haven't looked at yet) beats SLOB in space
usage and simplicity, I'll be happy to see it replace SLOB.

Finally getting rid of SLAB is a much trickier proposition because SLUB
still loses in a few important corner cases.

-- 
Mathematics is the supreme nostalgia of our time.

