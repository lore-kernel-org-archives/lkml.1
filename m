Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0CIKXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:23:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab0CIKXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:23:49 -0500
Date: Tue, 9 Mar 2010 21:23:45 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] page-allocator: Check zone pressure when batch of
 pages are freed
Message-ID: <20100309102345.GG8653@laptop>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
 <1268048904-19397-3-git-send-email-mel@csn.ul.ie>
 <20100309095342.GD8653@laptop>
 <20100309100835.GA4883@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309100835.GA4883@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:08:35AM +0000, Mel Gorman wrote:
> On Tue, Mar 09, 2010 at 08:53:42PM +1100, Nick Piggin wrote:
> > Cool, you found this doesn't hurt performance too much?
> > 
> 
> Nothing outside the noise was measured. I didn't profile it to be
> absolutly sure but I expect it's ok.

OK. Moving the waitqueue cacheline out of the fastpath footprint
and doing the flag thing might be a good idea?

 
> > Can't you remove the check from the reclaim code now? (The check
> > here should give a more timely wait anyway)
> > 
> 
> I'll try and see what the timing and total IO figures look like.

Well reclaim goes through free_pages_bulk anyway, doesn't it? So
I don't see why you would have to run any test.

 
> > This is good because it should eliminate most all cases of extra
> > waiting. I wonder if you've also thought of doing the check in the
> > allocation path too as we were discussing? (this would give a better
> > FIFO behaviour under memory pressure but I could easily agree it is not
> > worth the cost)
> > 
> 
> I *could* make the check but as I noted in the leader, there isn't
> really a good test case that determines if these changes are "good" or
> "bad". Removing congestion_wait() seems like an obvious win but other
> modifications that alter how and when processes wait are less obvious.

Fair enough. But we could be sure it increases fairness, which is a
good thing. So then we'd just have to check it against performance.

Your patches seem like a good idea regardless of this issue, don't get
me wrong.
