Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0CLJKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:10:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59070 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab0CLJKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:10:14 -0500
Date: Fri, 12 Mar 2010 09:09:56 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone
	pressure
Message-ID: <20100312090956.GA18274@csn.ul.ie>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <20100311154124.e1e23900.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100311154124.e1e23900.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 03:41:24PM -0800, Andrew Morton wrote:
> On Mon,  8 Mar 2010 11:48:20 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Under memory pressure, the page allocator and kswapd can go to sleep using
> > congestion_wait(). In two of these cases, it may not be the appropriate
> > action as congestion may not be the problem.
> 
> clear_bdi_congested() is called each time a write completes and the
> queue is below the congestion threshold.
> 

Where you appear to get a kicking is if you want on "congestion" but no
writes are involved. In that case you potentially sleep for the whole timeout
waiting on an event that is not going to occur.

> So if the page allocator or kswapd call congestion_wait() against a
> non-congested queue, they'll wake up on the very next write completion.
> 
> Hence the above-quoted claim seems to me to be a significant mis-analysis and
> perhaps explains why the patchset didn't seem to help anything?
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
