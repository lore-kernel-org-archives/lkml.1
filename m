Return-Path: <linux-kernel-owner+w=401wt.eu-S1767213AbXEBSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767213AbXEBSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767223AbXEBSxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:53:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48966 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767211AbXEBSxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:53:04 -0400
Date: Wed, 2 May 2007 11:53:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070502114233.30143b0b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705021144110.1119@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705020955550.32271@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021903320.20615@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021124040.646@schroedinger.engr.sgi.com>
 <20070502114233.30143b0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Andrew Morton wrote:

> > This is a sensitive piece of the kernel as you say and we better allow the 
> > running of two allocator for some time to make sure that it behaves in all 
> > load situations. The design is fundamentally different so its performance 
> > characteristics may diverge significantly and perhaps there will be corner 
> > cases for each where they do the best job.
> 
> eek.  We'd need to fix those corner cases then.  Our endgame
> here really must be rm mm/slab.c.

First we need to discover them and I doubt that mm covers much more than 
development loads. I hope we can get to a point where we have SLUB be 
the primarily allocator soon but I would expect various performance issues 
to show up.

On the other hand: I am pretty sure that SLUB can replace SLOB completely 
given SLOBs limitations and SLUBs more efficient use of space. SLOB needs 
8 bytes of overhead. SLUB needs none. We may just have to #ifdef out the 
debugging support to make the code be of similar size to SLOB too. SLOB is 
a general problem because its features are not compatible to SLAB. F.e. it 
does not support DESTROY_BY_RCU and does not do reclaim the right way etc 
etc. SLUB may turn out to be the ideal embedded slab allocator.
