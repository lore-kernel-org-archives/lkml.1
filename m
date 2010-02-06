Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0BFH0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 02:26:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48447 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0BFH0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 02:26:37 -0500
Date: Sat, 6 Feb 2010 08:26:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, submit@firstfloor.org,
       linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [2/4] SLAB: Set up the l3 lists for the memory of freshly added memory
Message-ID: <20100206072636.GO29555@one.firstfloor.org>
References: <201002031039.710275915@firstfloor.org> <20100203213913.D5CD4B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051316300.2376@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002051316300.2376@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 01:17:56PM -0800, David Rientjes wrote:
> > +static int slab_memory_callback(struct notifier_block *self,
> > +				unsigned long action, void *arg)
> > +{
> > +	struct memory_notify *mn = (struct memory_notify *)arg;
> 
> No cast necessary.

It's standard practice to cast void *.

> >  void __init kmem_cache_init_late(void)
> >  {
> >  	struct kmem_cache *cachep;
> > @@ -1583,6 +1598,8 @@ void __init kmem_cache_init_late(void)
> >  	 */
> >  	register_cpu_notifier(&cpucache_notifier);
> >  
> > +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> 
> Only needed for CONFIG_NUMA.

Ok.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
