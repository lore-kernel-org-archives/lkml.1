Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZBEKlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZBEKlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZBEKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:41:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41678 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBEKlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:41:40 -0500
Date: Thu, 5 Feb 2009 10:41:38 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: David Miller <davem@davemloft.net>
Cc: kamezawa.hiroyu@jp.fujitsu.com, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-ID: <20090205104138.GF26878@csn.ul.ie>
References: <20090204.222651.26527737.davem@davemloft.net> <20090205101023.GD26878@csn.ul.ie> <20090205.021429.170975463.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090205.021429.170975463.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 02:14:29AM -0800, David Miller wrote:
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Thu, 5 Feb 2009 10:10:23 +0000
> 
> > On Wed, Feb 04, 2009 at 10:26:51PM -0800, David Miller wrote:
> > > As a suggestion, it would have been a lot more pleasant if the code
> > > validated this requirement (in the !HOLES_IN_ZONE case) at boot time
> > > instead of after 2 hours of stress testing :-(
> > > 
> > 
> > Nice maybe, but we'd take a hit on pfn_valid_within() which goes from
> > being compiled-away on architectures that don't need it to being
> > a read of a shared cacheline and a branch.
> 
> I said at boot time Mel, not in the fast paths. 

pfn_valid_within() is not used in any critical paths, but it's used in
the page free path so it would be a hit there.

> Meaning, we'd
> check it after all the available ranges get registered and
> tossed into the free page lists.
> 

It's not a free-list problem, it's walkers of PFN ranges. Anyway, it's
not important to the current problem.

> Anyways, it appears we have a fix already, read the rest of
> the thread.
> 

Yes. Thanks Kamezawa Hiroyu for the fix.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
