Return-Path: <linux-kernel-owner+w=401wt.eu-S1767109AbXDTOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767109AbXDTOht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767114AbXDTOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:37:49 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:34822 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767109AbXDTOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:37:48 -0400
Date: Fri, 20 Apr 2007 15:37:46 +0100
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420143746.GC16878@skynet.ie>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <200704192111.52395.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200704192111.52395.ak@suse.de>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/04/07 21:11), Andi Kleen didst pronounce:
> > We likely need actual defragmentation support.
> 
> To be honest it looks quite pointless before this is solved. So far it is
> not even clear if it is feasible to solve it.
> 

I've written a proposal in an OLS paper on how such a mechanism would work
based on the existing page migration feature.  However, it depends heavily
on grouping pages by mobility to work because without it, a defragmentation
mechanism will be ineffective. I was holding off posting a RFC until I saw
how fragmentation avoidance got on in the next merge window and find the
time to prototype it.

Without going into unnecessary detail, the end result of a compaction run is
that all movable pages are at the end of the zone and all unmovable pages
are at the start with contiguous free space in the middle. Grouping pages
by mobility as it is biases the location of non-movable pages towards the
lower PFNs. Assuming it had a reasonable level of success, even high-order
ramfs pages that were unmovable should work out.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
