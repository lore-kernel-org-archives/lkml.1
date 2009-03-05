Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZCECiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZCECiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZCECiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:38:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:30997 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZCECiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:38:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 04 Mar 2009 21:37:43 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Minchan Kim <minchan.kim@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC] atomic highmem kmap page pinning
In-reply-to: <20090305080717.f7832c63.minchan.kim@barrios-desktop>
Message-id: <alpine.LFD.2.00.0903042129140.5511@xanadu.home>
References: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
 <20090304171429.c013013c.minchan.kim@barrios-desktop>
 <alpine.LFD.2.00.0903041101170.5511@xanadu.home>
 <20090305080717.f7832c63.minchan.kim@barrios-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Minchan Kim wrote:

> I thought kmap and dma_map_page usage was following.
> 
> kmap(page);
> ...
> dma_map_page(...)
>   invalidate_cache_line
> 
> kunmap(page);
> 
> In this case, how do pkmap_count value for the page passed to dma_map_page become 1 ?
> The caller have to make sure to complete dma_map_page before kunmap.


The caller doesn't have to call kmap() on pages it intends to use for 
DMA.

> Do I miss something ?

See above.

> > > As far as I understand, To make irq_disable to prevent this problem is 
> > > rather big cost.
> > 
> > How big?  Could you please elaborate on the significance of this cost?
> 
> I don't have a number. It depends on you for submitting this patch. 

My assertion is that the cost is negligible.  This is why I'm asking you 
why you think this is a big cost.


Nicolas
