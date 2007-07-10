Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbXGJIcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbXGJIcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbXGJIcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:32:42 -0400
Received: from waste.org ([66.93.16.53]:40614 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762637AbXGJIcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:32:41 -0400
Date: Tue, 10 Jul 2007 03:32:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070710083212.GG11115@waste.org>
References: <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com> <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com> <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 07:11:03PM -0700, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> > It is reasonable to expect some help from maintainers, but I notice you
> > didn't even CC the SLOB maintainer in the patch to remove SLOB! So maybe
> > if you tried working a bit closer with him you could get better results?
> 
> The maintainers last patch to SLOB was the initial submission of the 
> allocator. Then he acked subsequent patches. Most of the modifications to 
> SLOB are my work.

You're delusional.

http://www.kernel.org/hg/linux-2.6/annotate/tip/mm/slob.c

A grand total of 15 lines accounted to you, all of which are
completely trivial. Most of them are turning no-op macros into no-op
but non-inline functions. Not an improvement. Reverting that now on my
todo list, thanks for drawing my attention to it. The remainder is
just churn from your SLUB work.

While you're at it, note the lines from Dimitri, quickly fixing the
breakage you introduced.

Count many more lines from Nick, Pekka, and Akinobu making useful
changes. And note that all three of the real bugs fixed were fairly
hard to hit. It's unlikely that anyone would have ever hit the RCU
bug. The find_order bug only hit allocations of unlikely sizes like
8193 bytes. And SLAB_PANIC triggering is fairly unheard of, and simply
makes the kernel crash slightly sooner anyway.

The only remaining known bug is arguably a problem in nommu that SLOB
shouldn't be papering over.

That's pretty damn stable compared to the other allocators in the
kernel.

> Attempts to talk to the maintainer result in inventive explanations
> why SLOB does not have to conform to kernel standards.

Um.. would those be the same kernel standards you pulled out of your
ass to argue SLOB shouldn't exist?

-- 
Mathematics is the supreme nostalgia of our time.
