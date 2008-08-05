Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYHEQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYHEQ2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYHEQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:28:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53848 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYHEQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:28:05 -0400
Date: Tue, 5 Aug 2008 17:28:00 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-ID: <20080805162800.GJ20243@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com> <20080730014308.2a447e71.akpm@linux-foundation.org> <20080730172317.GA14138@csn.ul.ie> <20080730103407.b110afc2.akpm@linux-foundation.org> <20080730193010.GB14138@csn.ul.ie> <20080730130709.eb541475.akpm@linux-foundation.org> <20080731103137.GD1704@csn.ul.ie> <1217884211.20260.144.camel@nimitz> <20080805111147.GD20243@csn.ul.ie> <1217952748.10907.18.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1217952748.10907.18.camel@nimitz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/08/08 09:12), Dave Hansen didst pronounce:
> On Tue, 2008-08-05 at 12:11 +0100, Mel Gorman wrote:
> > See, that's great until you start dealing with MAP_SHARED|MAP_ANONYMOUS.
> > To get that right between children, you end up something very fs-like
> > when the child needs to fault in a page that is already populated by the
> > parent. I strongly suspect we end up back at hugetlbfs backing it :/
> 
> Yeah, but the case I'm worried about is plain anonymous.  We already
> have the fs to back SHARED|ANONYMOUS, and they're not really
> anonymous. :)
> 
> This patch *really* needs anonymous pages, and it kinda shoehorns them
> in with the filesystem.  Stacks aren't shared at all, so this is a
> perfect example of where we can forget the fs, right?
> 

Ok sure, you could do direct inserts for MAP_PRIVATE as conceptually it
suits this patch.  However, I don't see what you gain. By reusing hugetlbfs,
we get things like proper reservations which we can do for MAP_PRIVATE these
days. Again, we could call that sort of thing directly if the reservation
layer was split out separate from hugetlbfs but I still don't see the gain
for all that churn.

What am I missing?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
