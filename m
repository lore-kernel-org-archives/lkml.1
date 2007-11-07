Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXKGSey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXKGSey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXKGSep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:34:45 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59705 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbXKGSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:34:44 -0500
Date: Wed, 7 Nov 2007 10:34:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Weiner <hannes-kernel@saeurebad.de>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 12/23] SLUB: Trigger defragmentation from memory reclaim
In-Reply-To: <20071107092822.GC6243@cataract>
Message-ID: <Pine.LNX.4.64.0711071032460.9857@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011229.423714790@sgi.com>
 <20071107092822.GC6243@cataract>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Johannes Weiner wrote:

> > @@ -210,6 +218,8 @@ unsigned long shrink_slab(unsigned long
> >                 shrinker->nr += total_scan;
> >         }
> >         up_read(&shrinker_rwsem);
> > +       if (gfp_mask & __GFP_FS)
> > +               kmem_cache_defrag(zone ? zone_to_nid(zone) : -1);
> >         return ret;
> >  }
> 
> What about the objects that kmem_cache_defrag() releases?  Shouldn't
> they be counted too?
> 
>      ret += kmem_cache_defrag(...)
> 
> Or am I overseeing something here?

kmem_cache_defrag returns the number of pages that were released by defrag 
actions.

shrink_slab returns the number of objects released by the shrinkers. 
kmem_cache_defrag has no way of knowing how many objects where released by 
the kick methods. The kick method may have chosen to reallocate the 
object.


