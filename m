Return-Path: <linux-kernel-owner+w=401wt.eu-S965239AbXAZQBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239AbXAZQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965708AbXAZQBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:01:21 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:58418 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965239AbXAZQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:01:20 -0500
Date: Fri, 26 Jan 2007 08:01:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <Pine.LNX.4.64.0701261334240.19245@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260756580.6141@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070126030753.03529e7a.akpm@osdl.org> <Pine.LNX.4.64.0701261334240.19245@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Mel Gorman wrote:

> I haven't thought about it much so I probably am missing something. The major
> difference I see is when only one zone is present. In that case, a number of
> loops presumably get optimised away and the behavior is very different
> (presumably better although you point out no figures exist to prove it). Where
> there are two or more zones, the code paths should be similar whether there
> are 2, 3 or 4 zones present.

The balancing of allocations between zones is becoming unnecessary. Also 
in a NUMA system we then have zone == node which allows for a series of 
simplifications.
 
> As the common platforms will always have more than one zone, it'll be heavily
> tested and I'm guessing that distros are always going to have to ship kernels
> with ZONE_DMA for the devices that require it. The only platform I see that
> may have problems at the moment is IA64 which looks like the only platform
> that can have one and only one zone. I am guessing that Christoph will catch
> problems here fairly quickly although a non-optional ZONE_MOVABLE would throw
> a spanner into the works somewhat.

There are 6 platforms that have only one zone. These are not major 
platforms. In order for major platforms to go to a single zone in general 
we would have to implement a generic mechanism to do an allocation where 
one can specify the memory boundaries. Many DMA engines have different
limitations from what ZONE_DMA and ZONE_DMA32 can provide. If such a 
scheme would be implemented then those would be able to utilize memory 
better and the amount of bounce buffers would be reduced.
