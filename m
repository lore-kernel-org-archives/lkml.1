Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXHCA05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXHCA05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXHCA0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:26:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:54237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbXHCA0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:26:43 -0400
Date: Fri, 3 Aug 2007 02:26:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070803002639.GC14775@wotan.suse.de>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de> <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com> <20070802034201.GA32631@wotan.suse.de> <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:58:13PM -0700, Christoph Lameter wrote:
> On Thu, 2 Aug 2007, Nick Piggin wrote:
> 
> > > It does in the sense that slabs are allocated following policies. If you 
> > > want to place individual objects then you need to use kmalloc_node().
> > 
> > Is there no way to place objects via policy? At least kernel stack and page
> > tables on x86-64 should be covered by page allocator policy, so the patch
> > will still be useful.
> 
> Implementing policies on an object level introduces significant allocator 
> overhead. Tried to do it in SLAB which created a mess.
> 
> Add a (slow) kmalloc_policy? Strict Object round robin for interleave 
> right? It probably needs its own RR counter otherwise it disturbs the per 
> task page RR.

I guess interleave could be nice for other things, but for this, I
just want MPOL_BIND to work. The problem is that the pagetable copying
etc codepaths cover a lot of code and some of it (eg pagetable allocation)
is used for other paths as well.. so I was just hoping to do something
less intrusive for now if possible.


> For interleave kmalloc() does allocate the slabs round robin not the 
> objects.
