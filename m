Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYADWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYADWbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYADWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:31:13 -0500
Received: from waste.org ([66.93.16.53]:45023 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbYADWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:31:13 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801041321490.12189@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801041223250.11479@schroedinger.engr.sgi.com>
	 <1199480150.3821.23.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801041321490.12189@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 16:30:18 -0600
Message-Id: <1199485818.3821.46.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-04 at 13:36 -0800, Christoph Lameter wrote:
> Ok. So lets try a worst case scenario. If we do a 128 byte kmalloc
> then we 
> can allocate the following number of object from one 4k slab
> 
> SLUB 32	    (all memory of the 4k page is used for 128 byte objects)
> SLAB 29/30  (management structure occupies first two/three objects)
> SLOB 30(?)  (Alignment results in object being 136 byte of effective size,
> 		we have 16 bytes leftover that could be used for a
> 		very small allocation. Right?)

Don't know how you got to 136, the minimum alignment is 4 on x86. But I
already said in my last email that SLUB would win for the special case
of power of two allocations. But as long as we're looking at worst
cases, let's consider an alloc of 257 bytes..

SLUB  8 (1016 bytes wasted)
SLOB 15 (105 bytes wasted, with 136 bytes still usable)

Can we be done with this now, please?

-- 
Mathematics is the supreme nostalgia of our time.

