Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbXHUVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbXHUVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXHUVAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:00:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51667 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752898AbXHUVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:00:29 -0400
Date: Tue, 21 Aug 2007 14:00:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 5/7] Laundry handling for direct reclaim
In-Reply-To: <20070821151907.GM11329@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708211359340.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <20070820215316.994224842@sgi.com>
 <20070821151907.GM11329@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mel Gorman wrote:

> > +		nr_reclaimed += shrink_zones(priority, zones, &sc, &laundry);
> >  		shrink_slab(sc.nr_scanned, gfp_mask, lru_pages);
> >  		if (reclaim_state) {
> >  			nr_reclaimed += reclaim_state->reclaimed_slab;
> >  			reclaim_state->reclaimed_slab = 0;
> >  		}
> > +
> >  		total_scanned += sc.nr_scanned;
> > +
> 
> Could this not isolate a load of dirty pages on the laundry list and then
> shortly later go to sleep in congestion_wait() ? It would appear that with
> writeout deferred that the going to sleep is going to do nothing to help
> the situation.

Yep that seems to be the problem that Peter saw. We need to throttle 
later.
