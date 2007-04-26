Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXDZKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXDZKG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXDZKG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:06:56 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:33022 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXDZKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:06:55 -0400
Date: Thu, 26 Apr 2007 11:06:52 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426100652.GB27620@skynet.ie>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/04/07 23:46), Christoph Lameter didst pronounce:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> > Yeah. IMO anti-fragmentation and defragmentation is the hack, and we
> > should stay away from higher order allocations whenever possible.
> 
> Right and we need to create series of other approaches that we then label 
> "non-hack" to replace it. 
> 

To date, there hasn't been a credible alternative to dealing with
fragmentation. Breaking the 1:1 virtual:physical mapping and defragmenting
would incur a serious performance hit.

> > Hardware is built to handle many small pages efficintly, and I don't
> > understand how it could be an SGI-only issue. Sure, you may have an
> > order of magnitude or more memory than anyone else, but even my lowly
> > desktop _already_ has orders of magnitude more pages than it has TLB
> > entries or cache -- if a workload is cache-nice for me, it probably
> > will be on a 1TB machine as well, and if it is bad for the 1TB machine,
> > it is also bad on mine.
> 
> There have been numbers of people that have argued the same point. Just 
> because we have developed a way of thinking to defend our traditional 4k 
> values does not make them right.
> 
> > If this is instead an issue of io path or reclaim efficiency, then it
> > would be really nice to see numbers... but I don't think making these
> > fundamental paths more complex and slower is a nice way to fix it
> > (larger PAGE_SIZE would be, though).
> 
> The code paths can stay the same. You can switch CONFIG_LARGE pages off
> if you do not want it and it is as it was.
> 

It may not even need that that much effort. The most stressful use of the
high order allocation paths here require the creation of a filesystem and
is a deliberate action by the user.

> If you would have a look the patches: The code is significantly cleanup 
> and easier to read.

It is easier to read all right and may be worth doing anyway.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
