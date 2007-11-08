Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbXKHTAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbXKHTAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761299AbXKHTAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:00:35 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:40505 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761609AbXKHTAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:00:34 -0500
Date: Thu, 8 Nov 2007 11:00:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 12/23] SLUB: Trigger defragmentation from memory reclaim
In-Reply-To: <20071108151249.GE2591@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081059420.8954@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011229.423714790@sgi.com>
 <20071108151249.GE2591@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> >  	up_read(&shrinker_rwsem);
> > +	if (gfp_mask & __GFP_FS)
> > +		kmem_cache_defrag(zone ? zone_to_nid(zone) : -1);
> 
> Does this make an assumption that only filesystem-related slabs may be
> targetted for reclaim? What if there is a slab that can free its objects
> without ever caring about a filesystem?

Correct. Currently only filesystem related slabs support slab defragy.
