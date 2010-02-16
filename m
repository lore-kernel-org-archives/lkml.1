Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0BPOFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:05:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab0BPOFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:05:15 -0500
Date: Wed, 17 Feb 2010 01:04:47 +1100
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of
 freshly added memory v2
Message-ID: <20100216140447.GN5723@laptop>
References: <20100211953.850854588@firstfloor.org>
 <20100211205403.05A8EB1978@basil.firstfloor.org>
 <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com>
 <20100215060655.GH5723@laptop>
 <alpine.DEB.2.00.1002151344020.26927@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002151344020.26927@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 01:47:29PM -0800, David Rientjes wrote:
> On Mon, 15 Feb 2010, Nick Piggin wrote:
> 
> > > > @@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
> > > >  	 */
> > > >  	register_cpu_notifier(&cpucache_notifier);
> > > >  
> > > > +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> > > > +
> > > 
> > > Only needed for CONFIG_NUMA, but there's no side-effects for UMA kernels 
> > > since status_change_nid will always be -1.
> > 
> > Compiler doesn't know that, though.
> > 
> 
> Right, setting up a memory hotplug callback for UMA kernels here isn't 
> necessary although slab_node_prepare() would have to be defined 
> unconditionally.  I made this suggestion in my review of the patchset's 
> initial version but it was left unchanged, so I'd rather see it included 
> than otherwise stall out.  This could always be enclosed in
> #ifdef CONFIG_NUMA later just like the callback in slub does.

It's not such a big burden to annotate critical core code with such
things. Otherwise someone else ends up eventually doing it.
