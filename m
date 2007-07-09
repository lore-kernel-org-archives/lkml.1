Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXGIQG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXGIQG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXGIQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:06:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48831 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753915AbXGIQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:06:48 -0400
Date: Mon, 9 Jul 2007 09:06:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <4691A415.6040208@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Nick Piggin wrote:

> > A reason for retaining slob would be that it has some O(n) memory saving
> > due to better packing, etc.  Indeed that was the reason for merging it in
> > the first place.  If slob no longer retains that advantage (wrt slub) then
> > we no longer need it.
> 
> SLOB contains several significant O(1) and also O(n) memory savings that
> are so far impossible-by-design for SLUB. They are: slab external
> fragmentation is significantly reduced; kmalloc internal fragmentation is
> significantly reduced; order of magnitude smaller kmem_cache data type;
> order of magnitude less code...

Well that is only true for kmalloc objects < PAGE_SIZE and to some extend 
offset by the need to keep per object data in SLUB. But yes the power of 
two caches are a necessary design feature of SLAB/SLUB that allows O(1) 
operations of kmalloc slabs which in turns causes memory wastage because 
of rounding of the alloc to the next power of two. SLUB has less wastage
there than SLAB since it can fit power of two object tightly into a slab 
instead of having to place additional control information there like SLAB.

O(n) memory savings? What is that?
