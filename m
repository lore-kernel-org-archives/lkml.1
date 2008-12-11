Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYLKPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYLKPkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLKPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:39:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50870 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbYLKPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:39:51 -0500
Date: Thu, 11 Dec 2008 15:39:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into
	pcp
Message-ID: <20081211153947.GA27315@csn.ul.ie>
References: <Pine.LNX.4.64.0811071244330.5387@quilx.com> <20081205154006.GA19366@csn.ul.ie> <20081207172115.53E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081207172115.53E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 05:22:48PM +0900, KOSAKI Motohiro wrote:
> > 
> > ====== CUT HERE ======
> > From: Mel Gorman <mel@csn.ul.ie>
> > Subject: [RFC] Split per-cpu list into one-list-per-migrate-type
> > 
> > Currently the per-cpu page allocator searches the PCP list for pages of the
> > correct migrate-type to reduce the possibility of pages being inappropriate
> > placed from a fragmentation perspective. This search is potentially expensive
> > in a fast-path and undesirable. Splitting the per-cpu list into multiple lists
> > increases the size of a per-cpu structure and this was potentially a major
> > problem at the time the search was introduced. These problem has been
> > mitigated as now only the necessary number of structures is allocated for the
> > running system.
> > 
> > This patch replaces a list search in the per-cpu allocator with one list
> > per migrate type that should be in use by the per-cpu allocator - namely
> > unmovable, reclaimable and movable.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Great.
> 
> this patch works well on my box too.
> and my review didn't find any bug.
> 
> very thanks.
> 
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 

Thanks very much for the review. I guess in principal I should stick
with this patch then and go with another revision so. Are there any
concerns about the increase in size of a per-cpu structure or are we
confident that it'll be kept to a minimum with the cpu_alloc stuff?

Similarly, are there suggestions on how to prove more conclusively that
this is a performance win? I saw between 1% and 2% on tbench on some
machines but not all so preferably we'd be more confident. Intuitively,
the patch makes sense that it would be faster to me but I'd prove it for
sure if possible.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
