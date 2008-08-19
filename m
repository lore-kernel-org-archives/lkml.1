Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYHSS1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYHSS1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYHSS1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:27:38 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:38948 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYHSS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=AVDYNntS6wydZjzWrrJF5OzbD8YRZonUEuVP79o3DbwdmhIeUQWlUpTqDO3n6w0I5M
         NvkUbWXP9mOGG5kv5TSKq3DYMpF+GX0d6mFXflvhaeWDoIG8c96WA8Ox5vsiHvJ6VDJq
         dnvzto9oexBtsxzhvJy31nJr2ZqiPaqE7ctBM=
Date: Tue, 19 Aug 2008 21:24:23 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       rdunlap@xenotime.net, mpm@selenic.com, tglx@linutronix.de,
       rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with
	_RET_IP_.
Message-ID: <20080819182423.GA5520@localhost>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB0D69.4090703@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:14:01PM -0500, Christoph Lameter wrote:
> Eduard - Gabriel Munteanu wrote:
> 
> >  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
> >  {
> > -	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
> > +	return slab_alloc(s, gfpflags, -1, (void *) _RET_IP_);
> >  }
> 
> Could you get rid of the casts by changing the type of parameter of slab_alloc()?

I just looked at it and it isn't a trivial change. slab_alloc() calls
other functions which expect a void ptr. Even if slab_alloc() were to
take an unsigned long and then cast it to a void ptr, other functions do
call slab_alloc() with void ptr arguments (so the casts would move
there).

I'd rather have this merged as it is and change things later, so that
kmemtrace gets some testing from Pekka and others. 

