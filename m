Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYL2ULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYL2ULT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYL2ULK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:11:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:30910 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYL2ULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nN0ZRG7VvQkx16GcFVMkCn+D1yFIScZN9TkI5BYLT7o4zQe4KjepwrN0vUEXn+wEY0
         RCg7hx9uUowgmLUJALkkZowlISxEvHLU241tIbZj5C/JHe9QOaH50Qg69YwRWNCNfM94
         dveEFYwOH7zSZHbjrbSwTilpFyxQz1Igv0jvY=
Date: Mon, 29 Dec 2008 22:11:29 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20081229201129.GA5386@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro> <4dcbaab558466e1cd0be66f3b66c7c5d2a0c532b.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <1230558236.6078.13.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230558236.6078.13.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 03:43:56PM +0200, Pekka Enberg wrote:
> Hi Eduard,
> 
> On Mon, 2008-12-29 at 03:40 +0200, Eduard - Gabriel Munteanu wrote:
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 1fcb32b..74d405d 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3624,8 +3624,9 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
> >  {
> >  	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
> >  
> > -	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> > -			     obj_size(cachep), cachep->buffer_size, flags);
> > +	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> > +			      obj_size(cachep), cachep->buffer_size,
> > +			      flags, -1);
> 
> One minor nit: I'd prefer we call these trace_kmem_cache_alloc(),
> trace_kmalloc(), and so on. The trace_kmemtrace prefix doesn't really
> make much sense to me.

Sure, I'll also move the KMEMTRACE_TYPE_* enum to mm/kmemtrace.c.

