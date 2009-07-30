Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZG3SgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZG3SgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZG3SgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:36:11 -0400
Received: from lazybastard.de ([212.112.238.170]:53025 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZG3SgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:36:10 -0400
Date: Thu, 30 Jul 2009 20:35:59 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Julia Lawall <julia@diku.dk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: Add kmalloc NULL tests
Message-ID: <20090730183558.GA11763@logfs.org>
References: <Pine.LNX.4.64.0907301608350.8734@ask.diku.dk> <20090730153658.GA22986@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090730153658.GA22986@cmpxchg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 July 2009 17:36:58 +0200, Johannes Weiner wrote:
> On Thu, Jul 30, 2009 at 04:10:22PM +0200, Julia Lawall wrote:
> 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 7b5d4de..972e427 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -1502,6 +1502,7 @@ void __init kmem_cache_init(void)
> >  
> >  		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
> >  
> > +		BUG_ON(!ptr);
> >  		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
> >  		memcpy(ptr, cpu_cache_get(&cache_cache),
> >  		       sizeof(struct arraycache_init));
> 
> This does not change the end result when the allocation fails: you get
> a stacktrace and a kernel panic.  Leaving it as is saves a line of
> code.

According to http://lwn.net/Articles/342420/, there may be a subtle
difference.

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
