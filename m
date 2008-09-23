Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYIWTrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYIWTrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYIWTq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:46:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46657 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYIWTq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:46:58 -0400
Date: Tue, 23 Sep 2008 20:46:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Message-ID: <20080923194655.GA25542@csn.ul.ie>
References: <20080922162152.GB7716@csn.ul.ie> <1222102098.8533.62.camel@nimitz> <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/09/08 21:15), KOSAKI Motohiro didst pronounce:
> > > The corollary is that someone running with a 64K base page kernel may be
> > > surprised that the pagesize is always 4K. However I'll check if there is
> > > a simple way of checking out if the MMU size differs from PAGE_SIZE.
> > 
> > Sure.  If it isn't easy, the best thing to do is probably just to
> > document the "interesting" behavior.
> 
> Dave, please let me know getpagesize() function return to 4k or 64k on ppc64.
> I think the PageSize line of the /proc/pid/smap and getpagesize() result should be matched.
> 
> otherwise, enduser may be confused.
> 

To distinguish between the two, I now report the kernel pagesize and the
mmu pagesize like so

KernelPageSize:       64 kB
MMUPageSize:           4 kB

This is running a kernel with a 64K base pagesize on a PPC970MP which
does not support 64K hardware pagesizes.

Does this make sense?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
