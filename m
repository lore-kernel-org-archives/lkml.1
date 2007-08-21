Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXHUUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXHUUzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXHUUzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:55:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51292 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbXHUUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:55:33 -0400
Date: Tue, 21 Aug 2007 13:55:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 5/7] Laundry handling for direct reclaim
In-Reply-To: <20070821150650.GL11329@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708211354010.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <20070820215316.994224842@sgi.com>
 <20070821150650.GL11329@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mel Gorman wrote:

> > @@ -1156,6 +1156,7 @@ unsigned long try_to_free_pages(struct z
> >  		.swappiness = vm_swappiness,
> >  		.order = order,
> >  	};
> > +	LIST_HEAD(laundry);
> 
> Why is the laundry not made part of the scan_control?

That is one possibility. The other is to treat laundry as a lru type list 
under zone->lru_lock. This would allow the writeback process (whichever 
that is) to be independent of the producer of the laundry. Dirty pages 
could be isolated from an atomic context.
