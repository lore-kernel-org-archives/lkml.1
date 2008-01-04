Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYADCnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYADCnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYADCnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:43:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39073 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYADCnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:43:06 -0500
Date: Fri, 4 Jan 2008 03:45:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
Message-ID: <20080104024506.GA4665@one.firstfloor.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> <1199314218.4497.109.camel@cinder.waste.org> <20080103085239.GA10813@elte.hu> <1199378818.8274.25.camel@cinder.waste.org> <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still have trouble to see that SLOB still has much to offer. An embedded 
> allocator that in many cases has more allocation overhead than the default 
> one? Ok you still have advantages if allocations are rounded up to the 
> next power of two for a kmalloc and because of the combining of different 
> types of allocations in a single slab if there are an overall small number 
> of allocations. If one would create a custom slab for the worst problems 
> there then this may also go away.

I suspect it would be a good idea anyways to reevaluate the power of two
slabs. Perhaps a better distribution can be found based on some profiling?
I did profile kmalloc using a systemtap script some time ago but don't
remember the results exactly, but iirc it looked like it could be improved.

A long time ago i also had some code to let the network stack give hints
about its MMUs to slab to create fitting slabs for packets. But that
was never really pushed forward because it turned out it didn't help
much for the most common 1.5K MTU -- always only two packets fit into
a page.

-Andi
> 
