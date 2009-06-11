Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZFKKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZFKKxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbZFKKxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:53:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37776 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbZFKKw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:52:59 -0400
Date: Thu, 11 Jun 2009 11:53:00 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for mmotm 0/5] introduce swap-backed-file-mapped count
	and fix
	vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
Message-ID: <20090611105259.GC7302@csn.ul.ie>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com> <20090611103837.GB7302@csn.ul.ie> <20090611194141.6D5C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090611194141.6D5C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:42:33PM +0900, KOSAKI Motohiro wrote:
> > On Thu, Jun 11, 2009 at 07:25:09PM +0900, KOSAKI Motohiro wrote:
> > > Recently, Wu Fengguang pointed out vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> > > has underflow problem.
> > > 
> > 
> > Can you drop this aspect of the patchset please? I'm doing a final test
> > on the scan-avoidance heuristic that incorporates this patch and the
> > underflow fix. Ram (the tester of the malloc()-stall) confirms the patch
> > fixes his problem.
> 
> OK.
> insted, I'll join to review your patch :)
> 

Thanks. You should have it now. In particular, I'm interested in hearing you
opinion about patch 1 of the series "Fix malloc() stall in zone_reclaim()
and bring behaviour more in line with expectations V3" and if addresses;

1. Does patch 1 address the problem that first led you to develop the patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch?

2. Do you think patch 1 should merge with and replace
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch?

> > > This patch series introduce new vmstat of swap-backed-file-mapped and fix above
> > > patch by it.
> 

I don't think the patch above needs to be fixed by another counter. At
least, once the underflow was fixed up, it handled the malloc-stall without
additional counters. If we need to account swap-backed-file-mapped, we need
another failure case that it addresses to be sure we're doing the right thing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
