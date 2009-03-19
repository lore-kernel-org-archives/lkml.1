Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbZCSSSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbZCSSSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZCSSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:18:28 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:55473 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZCSSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:18:27 -0400
Date: Thu, 19 Mar 2009 14:15:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <20090319181116.GA24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903191413560.17408@qirst.com>
References: <20090318135222.GA4629@csn.ul.ie> <alpine.DEB.1.10.0903181011210.7901@qirst.com> <20090318153508.GA24462@csn.ul.ie> <alpine.DEB.1.10.0903181300540.15570@qirst.com> <20090318181717.GC24462@csn.ul.ie> <alpine.DEB.1.10.0903181507120.10154@qirst.com>
 <20090318194604.GD24462@csn.ul.ie> <20090319090456.fb11e23c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0903191105090.8100@qirst.com> <alpine.DEB.1.10.0903191251310.24152@qirst.com> <20090319181116.GA24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Mel Gorman wrote:

> I ran into exactly that problem and ended up shoving the table into
> page_alloc.c but then there is no benefits from having the table statically
> declared because there is no constant folding.

Right. The table must be defined in the .h file. Just a matter of figuring
out how to convince the compiler/linker to do the right thing.

> > +	if (__builtin_constant_p(zone))
> > +		BUILD_BUG_ON(zone == BAD_ZONE);
> > +#ifdef CONFIG_DEBUG_VM
> > +	else
> > +		BUG_ON(zone == BAD_ZONE);
> >  #endif
>
> That could be made a bit prettier with
>
> 	if (__builtin_constant_p(zone))
> 		BUILD_BUG_ON(zone == BAD_ZONE);
> 	VM_BUG_ON(zone == BAD_ZONE);

VM_BUG_ON is not available here. It has to be that ugly.
