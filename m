Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbXIXV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbXIXV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbXIXV2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:28:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:56612 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXIXV2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:28:35 -0400
Subject: Re: x86_64: potential critical issue with quicklists and page
	table pages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, asit.k.mallick@intel.com
In-Reply-To: <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
	 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 07:27:45 +1000
Message-Id: <1190669265.6886.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-21 at 12:21 -0700, Linus Torvalds wrote:

> Yeah, and the whole thing seems totally bogus. It totally depends on 
> mmu_gather doing everything right (which very much includes the dependency 
> on mmu gathering disabling preempt).
> 
> For exmaple, if we were to go back to the original small tlb_gather with a 
> simple quicklist on the stack, rather than the per-cpu datastructure, the 
> quicklists would immediately break horribly - simply because they are 
> incorrectly now depending on the internal semantics of that tlb-gather.
> 
> As it is, the quicklists try to be something separate, but by virtue of 
> being separate, they will always be buggy.
> 
> The only way to fix it would be to integrate the quicklist stuff *with* 
> the mmu_gather stuff, so that these kinds of implementation issues are 
> explicitly shown in the relationship, instead of havign two "independent" 
> pieces of code where one piece very subtly depends on the exact 
> implementation of the other.

I've been mostly offline since KS (since a bit before in fact), so I
missed some of those discussions but so that you know, I'm toying a bit
with mmu gather and page table accessors at the moment, and one of the
things I've been contemplating is just that ... integrating a quicklist
in the gather to handle just that (and possibly other issues that have
been overlooked on some archs).

I'd suggest just reverting the patch for now (well, I see from the
commit list that you did just that) and I'll try to come up with
something better.

Christoph, I'd be happy if you didn't start butchering mmu_gather just
right now since I'm doing just that and it will collide all over the
place :-) Or if you want something specific done, please throw
ideas/patches at me and I'll integrate that in my serie.

Cheers,
Ben.


