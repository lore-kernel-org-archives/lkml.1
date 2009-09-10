Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZIJMel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZIJMel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZIJMel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:34:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57477 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZIJMek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:34:40 -0400
Date: Thu, 10 Sep 2009 13:34:46 +0100
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
Message-ID: <20090910123445.GC31153@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252570722.4876.23.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1252570722.4876.23.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 11:18:42AM +0300, Pekka Enberg wrote:
> On Wed, 2009-09-09 at 17:55 +0100, Mel Gorman wrote:
> > On Wed, Sep 09, 2009 at 05:59:30PM +0200, Frans Pop wrote:
> > > On Wednesday 09 September 2009, Mel Gorman wrote:
> > > > Franz, in the full dmesg was there any mention of "SLUB: Unable to
> > > > allocate memory on node"?
> > > 
> > > No, nothing at all. I double checked the kernel log, but it was completely 
> > > quiet in the hours before and after the messages I already posted.
> > > 
> > 
> > Ok, that in itself is unexpected.
> > 
> > Pekka, it looks from the stack trace that the failure is from
> > __alloc_skb and I am guessing the failure path is around here
> > 
> >         size = SKB_DATA_ALIGN(size);
> >         data = kmalloc_node_track_caller(size + sizeof(struct skb_shared_info),
> >                         gfp_mask, node);
> >         if (!data)
> >                 goto nodata;
> > 
> > Why would the SLUB out-of-memory message not appear? It's hardly
> > tripping up on printk_ratelimit() is it?
> 
> That's because it's a large allocation that's passed directly to the
> page allocator. See kmalloc_large_node(), for example.
> 

Pants. Is there any chance that could be fixed so that allocation
failures within SLUB get consistently reported?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
