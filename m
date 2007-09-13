Return-Path: <linux-kernel-owner+w=401wt.eu-S1765154AbXIMGEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765154AbXIMGEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXIMGEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:04:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:21348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbXIMGEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,248,1186383600"; 
   d="scan'208";a="293908772"
Date: Wed, 12 Sep 2007 23:04:33 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Message-ID: <20070913060432.GB6078@linux-os.sc.intel.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com> <200709110117.57387.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 01:19:30PM -0700, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> 
> > The impression I got at vm meeting was that SLUB was good to go :(
> 
> Its not? I have had Intel test this thoroughly and they assured me that it 
> is up to SLAB.

Christoph, Not sure if you are referring to me or not here. But our
tests(atleast on with the database workloads) approx 1.5 months or so back
showed that on ia64 slub was on par with slab and on x86_64, slub was 9% down.
And after changing the slub min order and max order, slub perf on x86_64 is
down approx 3.5% or so compared to slab.

While I don't rule out large sized allocations like PAGE_SIZE, I am mostly
certain that the critical allocations in this workload are not PAGE_SIZE
based.  Mostly they are in the range less than 300-500 bytes or so.

Any changes in the recent slub which takes the pressure away from the page
allocator especially for smaller page sized architectures? If so, we can
redo some of the experiments. Looking at this thread, it doesn't sound like?

thanks,
suresh
