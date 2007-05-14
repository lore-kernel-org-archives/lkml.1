Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbXENUFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbXENUFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXENUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:05:42 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:40871 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754130AbXENUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:05:41 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20070514124451.c868c4c0.akpm@linux-foundation.org>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
	 <20070514161224.GC11115@waste.org>
	 <20070514124451.c868c4c0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 22:05:29 +0200
Message-Id: <1179173129.2942.52.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 12:44 -0700, Andrew Morton wrote:
> On Mon, 14 May 2007 11:12:24 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > If I understand this correctly:
> > 
> > privileged thread                      unprivileged greedy process
> > kmem_cache_alloc(...)
> >    adds new slab page from lowmem pool
> > do_io()
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        ...
> >                                           eats it all
> > kmem_cache_alloc(...) -> ENOMEM
> >    who ate my donuts?!
> 
> Yes, that's my understanding also.
> 
> I can see why it's a problem in theory, but I don't think Peter has yet
> revealed to us why it's a problem in practice.  I got all excited when
> Christoph asked "I am not sure what the point of all of this is.", but
> Peter cunningly avoided answering that ;)
> 
> What observed problem is being fixed here?

I'm moving towards swapping over networked storage. Admittedly a new
feature.

Like with pretty much all other swap solutions; there is the fundamental
vm deadlock: freeing memory requires memory. Current block devices get
around that by using mempools. This works well.

However with network traffic mempools are not easily usable; the network
stack uses kmalloc. By using reserve based allocation we can keep
operating in a similar matter.



