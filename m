Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXGXWLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXGXWLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXGXWLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:11:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbXGXWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:11:16 -0400
Date: Tue, 24 Jul 2007 15:10:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
Message-Id: <20070724151046.d8fbb7da.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>
	<20070723112143.GB19437@skynet.ie>
	<1185190711.8197.15.camel@twins>
	<Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
	<1185256869.8197.27.camel@twins>
	<Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
	<1185261894.8197.33.camel@twins>
	<Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
	<20070724120751.401bcbcb@schroedinger.engr.sgi.com>
	<20070724122542.d4ac734a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 12:36:59 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 24 Jul 2007, Andrew Morton wrote:
> 
> > > __GFP_MOVABLE	The movability of a slab is determined by the
> > > 		options specified at kmem_cache_create time. If this is
> > > 		specified at kmalloc time then we will have some random
> > > 		slabs movable and others not. 
> > 
> > Yes, they seem inappropriate.  Especially the first two.
> 
> The third one would randomize __GFP_MOVABLE allocs from the page allocator 
> since one __GFP_MOVABLE alloc may allocate a slab that is then used for 
> !__GFP_MOVABLE allocs.
> 
> Maybe something like this? Note that we may get into some churn here 
> since slab allocations that any of these flags will BUG.
> 
> 
> 
> GFP_LEVEL_MASK: Remove __GFP_COLD, __GFP_COMP and __GFPMOVABLE
> 
> Add an explanation for the GFP_LEVEL_MASK and remove the flags
> that should not be passed through derived allocators.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

I think I'll duck this for now.  Otherwise I have a suspicion that I'll
be the first person to run it and I'm too old for such excitement.
