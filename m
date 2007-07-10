Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbXGJXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbXGJXNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGJXNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:13:09 -0400
Received: from waste.org ([66.93.16.53]:58996 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbXGJXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:13:08 -0400
Date: Tue, 10 Jul 2007 18:12:26 -0500
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
Message-ID: <20070710231226.GW11115@waste.org>
References: <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com> <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com> <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com> <469330AD.5070107@yahoo.com.au> <Pine.LNX.4.64.0707101503110.5490@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101503110.5490@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 03:09:06PM -0700, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> > But last time this discussion came up, IIRC you ended up handwaving
> > about all the ways in which SLOB was broken but didn't actually come
> > up with any real problems. Matt seemed willing to add those counters
> > or whatever it was if/when doing so solved a real problem. And remember
> > that SLOB doesn't have to have feature parity with SLUB, so long as it
> > implements the slab API such that the kernel *works*.
> 
> No it does not have to have feature parity. And yes we identified areas in 
> which SLOB may cause problems due to not implementing things (f.e. 
> suspend resume).

Please remind me what these things are. Suspend and hibernate work
fine here.

> The counters are still missing and thus core development 
> cannot rely on those being there.

None of the VM makes real use of the SLAB counters. Nor will they ever
make real use of them because the counters are not usefully defined.
In other words, reclaimable is a lie. If SLAB claims there's 1M of
reclaimable memory, the actual amount may more often than not be zero
because we already tried to shrink the SLAB.

As I've said before, if you come up with a real use for these numbers,
I will sacrifice the appropriate number of puppies to support it in
SLOB. But I'd rather not crush any puppies here prematurely.

-- 
Mathematics is the supreme nostalgia of our time.
