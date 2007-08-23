Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXHWMIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXHWMIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbXHWMIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:08:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:55713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344AbXHWMIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:08:31 -0400
Date: Thu, 23 Aug 2007 14:08:28 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water
	marks
Message-ID: <20070823120819.GO13915@v2.random>
References: <20070820215040.937296148@sgi.com> <1187692586.6114.211.camel@twins> <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com> <1187730812.5463.12.camel@lappy> <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com> <1187734144.5463.35.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187734144.5463.35.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 12:09:03AM +0200, Peter Zijlstra wrote:
> Strictly speaking:
> 
> if:
> 
>  page = alloc_page(gfp);
> 
> fails but:
> 
>  obj = kmem_cache_alloc(s, gfp);
> 
> succeeds then its a bug.

Why? this is like saying that if alloc_pages(order=1) fails but
alloc_pages(order=0) succeeds then it's a bug. Obviously it's not a
bug.

The only bug is if slab allocations <=4k fails despite
alloc_pages(order=0) would succeed.
