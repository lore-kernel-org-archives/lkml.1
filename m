Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbZIJM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbZIJM6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbZIJM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:58:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZIJM6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:58:36 -0400
Date: Thu, 10 Sep 2009 13:58:41 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090910125841.GD31153@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252570722.4876.23.camel@penberg-laptop> <20090910123445.GC31153@csn.ul.ie> <1252586376.4876.29.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1252586376.4876.29.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 03:39:36PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Thu, 2009-09-10 at 13:34 +0100, Mel Gorman wrote:
> > > That's because it's a large allocation that's passed directly to the
> > > page allocator. See kmalloc_large_node(), for example. 
> > 
> > Pants. Is there any chance that could be fixed so that allocation
> > failures within SLUB get consistently reported?
> 
> Did you have something specific in mind? I am not sure it's worth it,
> really.
> 
> The kmalloc_large() function is a static inline in
> include/linux/slub_def.h that gets inlined nicely to a get_order() +
> __get_free_pages() pair in the caller for production configs. I'm not
> sure what we should print either. There's no known "object size" or
> "buffer size" nor do we any of the variable order things or backing
> struct kmem_cache_nodes.
> 

All I had in mind really was to grab the size of the buffer that was
passed into kmalloc such as here;

void *__kmalloc(size_t size, gfp_t flags)
{
        struct kmem_cache *s;
        void *ret;

        if (unlikely(size > SLUB_MAX_SIZE))
                return kmalloc_large(size, flags);

and to have consistent reporting of slub-allocation failures but if you
reckon it's not worth it, I wouldn't push strongly on it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
