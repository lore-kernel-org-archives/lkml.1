Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYACIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYACIxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYACIxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:53:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45461 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbYACIxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:53:06 -0500
Date: Thu, 3 Jan 2008 09:52:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
Message-ID: <20080103085239.GA10813@elte.hu>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> <1199314218.4497.109.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199314218.4497.109.camel@cinder.waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> > Which means that SLOB could also trivially implement the same thing, 
> > with no new #ifdef'fery or other crud.
> 
> Except SLOB's emulation of slabs is so thin, it doesn't have the 
> relevant information. We have a very small struct kmem_cache, which I 
> suppose could contain a counter. But we don't have anything like the 
> kmalloc slabs, so you'd only be getting half the picture anyway. The 
> output of slabtop would simply be misleading because there are no 
> underlying "slabs" in the first place.

i think SLOB/embedded is sufficiently special that a "no /proc/slabinfo" 
restriction is perfectly supportable. (for instance it's only selectable 
if CONFIG_EMBEDDED=y) If a SLOB user has any memory allocation problems 
it's worth going to the bigger allocators anyway, to get all the 
debugging goodies.

btw., do you think it would be worth/possible to have build mode for 
SLUB that is acceptably close to the memory efficiency of SLOB? (and 
hence work towards unifying all the 3 allocators into SLUB in essence)

right now we are far away from it - SLUB has an order of magnitude 
larger .o than SLOB, even on UP. I'm wondering why that is so - SLUB's 
data structures _are_ quite compact and could in theory be used in a 
SLOB-alike way. Perhaps one problem is that much of SLUB's debugging 
code is always built in?

	Ingo
