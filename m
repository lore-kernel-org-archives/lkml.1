Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0BOVrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:47:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0BOVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:47:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SCTtA8koHZRoiu1HIJXQ/ou5xPAJhHviQRXiKvPj9utLUmXmMyGxJy7I+CH5tX7bM
	EIvWAWi0QMaUMLHNoMnCA==
Date: Mon, 15 Feb 2010 13:47:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory v2
In-Reply-To: <20100215060655.GH5723@laptop>
Message-ID: <alpine.DEB.2.00.1002151344020.26927@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205403.05A8EB1978@basil.firstfloor.org> <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com> <20100215060655.GH5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, Nick Piggin wrote:

> > > @@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
> > >  	 */
> > >  	register_cpu_notifier(&cpucache_notifier);
> > >  
> > > +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> > > +
> > 
> > Only needed for CONFIG_NUMA, but there's no side-effects for UMA kernels 
> > since status_change_nid will always be -1.
> 
> Compiler doesn't know that, though.
> 

Right, setting up a memory hotplug callback for UMA kernels here isn't 
necessary although slab_node_prepare() would have to be defined 
unconditionally.  I made this suggestion in my review of the patchset's 
initial version but it was left unchanged, so I'd rather see it included 
than otherwise stall out.  This could always be enclosed in
#ifdef CONFIG_NUMA later just like the callback in slub does.
