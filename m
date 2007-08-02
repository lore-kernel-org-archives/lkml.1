Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbXHBT6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbXHBT6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXHBT6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:58:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754512AbXHBT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:58:14 -0400
Date: Thu, 2 Aug 2007 12:58:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
In-Reply-To: <20070802034201.GA32631@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de>
 <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
 <20070802034201.GA32631@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Nick Piggin wrote:

> > It does in the sense that slabs are allocated following policies. If you 
> > want to place individual objects then you need to use kmalloc_node().
> 
> Is there no way to place objects via policy? At least kernel stack and page
> tables on x86-64 should be covered by page allocator policy, so the patch
> will still be useful.

Implementing policies on an object level introduces significant allocator 
overhead. Tried to do it in SLAB which created a mess.

Add a (slow) kmalloc_policy? Strict Object round robin for interleave 
right? It probably needs its own RR counter otherwise it disturbs the per 
task page RR.

For interleave kmalloc() does allocate the slabs round robin not the 
objects.
