Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbXHCAwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbXHCAwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXHCAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:52:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50260 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753827AbXHCAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:52:29 -0400
Date: Thu, 2 Aug 2007 17:52:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
In-Reply-To: <20070803002639.GC14775@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0708021748110.13312@schroedinger.engr.sgi.com>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de>
 <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
 <20070802034201.GA32631@wotan.suse.de> <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com>
 <20070803002639.GC14775@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Nick Piggin wrote:

> > Add a (slow) kmalloc_policy? Strict Object round robin for interleave 
> > right? It probably needs its own RR counter otherwise it disturbs the per 
> > task page RR.
> 
> I guess interleave could be nice for other things, but for this, I
> just want MPOL_BIND to work. The problem is that the pagetable copying
> etc codepaths cover a lot of code and some of it (eg pagetable allocation)
> is used for other paths as well.. so I was just hoping to do something
> less intrusive for now if possible.

Ok. So MPOL_BIND on a single node. We would have to save the current 
memory policy on the stack and then restore it later. Then you would need 
a special call anyways.

Or is there some way to execute the code on the target cpu? That may be 
the easiest solution.
