Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZDUQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZDUQBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZDUQBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:01:10 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41774 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZDUQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:01:08 -0400
Date: Tue, 21 Apr 2009 11:09:59 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/25] Use a pre-calculated value instead of num_online_nodes()
 in fast paths
In-Reply-To: <20090421090102.GI12713@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904211109450.19969@qirst.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-26-git-send-email-mel@csn.ul.ie> <1240301300.771.58.camel@penberg-laptop> <20090421090102.GI12713@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Mel Gorman wrote:

> On Tue, Apr 21, 2009 at 11:08:20AM +0300, Pekka Enberg wrote:
> > On Mon, 2009-04-20 at 23:20 +0100, Mel Gorman wrote:
> > > diff --git a/mm/slab.c b/mm/slab.c
> > > index 1c680e8..41d1343 100644
> > > --- a/mm/slab.c
> > > +++ b/mm/slab.c
> > > @@ -3579,7 +3579,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
> > >  	 * variable to skip the call, which is mostly likely to be present in
> > >  	 * the cache.
> > >  	 */
> > > -	if (numa_platform && cache_free_alien(cachep, objp))
> > > +	if (numa_platform > 1 && cache_free_alien(cachep, objp))
> > >  		return;
> >
> > This doesn't look right. I assume you meant "nr_online_nodes > 1" here?
> > If so, please go ahead and remove "numa_platform" completely.
> >
>
> It would need to be nr_possible_nodes which would be a separate patch to add
> the definition and then drop numa_platform. This change is wrong as part of
> this patch. I'll drop it. Thanks

nr_online_nodes would be okay as Pekka suggested.

