Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYL3VJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYL3VJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYL3VJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:09:41 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:34871 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYL3VJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bK+WhT7g9Y5FaR8KM8nv4Rfwctc4JP8mVWHkbbcPgq13x+NFnFVoReMwUyLzbEe+NI
         /CvILPn0LeYTZYeEug6KrYwipxVOfofdqpNQrRz8b7XIGI5IFhC4xlOdyRkHIA13Zs0e
         nD0hH5gd8mMe1nzEOEYCG3Y8ore3fLk/JiK+E=
Date: Tue, 30 Dec 2008 22:09:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230210934.GC6151@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu> <20081230141608.GA5722@nowhere> <20081230153752.GA2984@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230153752.GA2984@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 04:37:52PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Tue, Dec 30, 2008 at 09:16:00AM +0100, Ingo Molnar wrote:
> > > 
> > > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > 
> > > > Hi Frederic,
> > > > 
> > > > On Mon, 2008-12-29 at 23:09 +0100, Frederic Weisbecker wrote:
> > > > > Pekka, note that I would be pleased to add statistical tracing on
> > > > > this tracer, but I would need a hashtable, or an array, or a list, or whatever
> > > > > iterable to insert the data into the stat tracing api.
> > > > > 
> > > > > But I don't know your projects about this... whether you wanted to use a section
> > > > > or something else...
> > > > 
> > > > It really depends on what we're tracing. If we're interested in just the 
> > > > allocation hotspots, a section will do just fine. However, if we're 
> > > > tracing memory footprint, we need to take into store the object pointer 
> > > > returned from kmalloc() and kmem_cache_alloc() so we can update 
> > > > call-site statistics properly upon kfree().
> > > > 
> > > > So I suppose we need both, a section for per call-site statistics and a 
> > > > hash table for the object -> call-site mapping.
> > > 
> > > 1)
> > > 
> > > i think the call_site based tracking should be a built-in capability - the 
> > > branch tracer needs that too for example. That would also make it very 
> > > simple on the usage place: you wouldnt have to worry about sections in 
> > > slub.c/etc.
> > 
> > 
> > I think that too. Can we use sections here? The traced functions are not 
> > directly kmalloc/kmem_cache_alloc and to use a section which contains 
> > the per site allocation requests, such a thing is required (we can't 
> > build a section with per site allocations requests by using intermediate 
> > level allocation function I fear...).
> 
> i think initially this should be a fixed-size allocation array + hash as 
> well. (like lockdep uses) The number of allocation sites is even the most 
> extreme case at most a few thousand - and is typically at most a couple of 
> hundred.
> 
> 	Ingo

Why not. And if someone reports too much overruns, we could make the size of this
array an option for the kernel.

