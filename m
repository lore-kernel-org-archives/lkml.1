Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbZFKLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbZFKLcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZFKLcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:32:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45665 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZFKLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:32:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH for mmotm 0/5] introduce swap-backed-file-mapped count and fix vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611105259.GC7302@csn.ul.ie>
References: <20090611194141.6D5C.A69D9226@jp.fujitsu.com> <20090611105259.GC7302@csn.ul.ie>
Message-Id: <20090611200321.6D62.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 20:32:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 11, 2009 at 07:42:33PM +0900, KOSAKI Motohiro wrote:
> > > On Thu, Jun 11, 2009 at 07:25:09PM +0900, KOSAKI Motohiro wrote:
> > > > Recently, Wu Fengguang pointed out vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> > > > has underflow problem.
> > > > 
> > > 
> > > Can you drop this aspect of the patchset please? I'm doing a final test
> > > on the scan-avoidance heuristic that incorporates this patch and the
> > > underflow fix. Ram (the tester of the malloc()-stall) confirms the patch
> > > fixes his problem.
> > 
> > OK.
> > insted, I'll join to review your patch :)
> > 
> 
> Thanks. You should have it now. In particular, I'm interested in hearing you
> opinion about patch 1 of the series "Fix malloc() stall in zone_reclaim()
> and bring behaviour more in line with expectations V3" and if addresses;
> 
> 1. Does patch 1 address the problem that first led you to develop the patch
> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch?

Yes, thanks. my original issue is

1. mem-hog process eat all pages in one node of numa machine.
2. kswapd run and makes many swapcache. 
   it mean increasing NR_FILE_PAGES - NR_FILE_MAPPED.
3. any page allocation invoke zone reclaim, but the zone don't have
   any file-backed page at all.

distro kernel can reproduce easily, but mainline kernel can't so easy.
but I think root cause is remain. it is (NR_FILE_PAGES - NR_FILE_MAPPED)
calculation.


> 2. Do you think patch 1 should merge with and replace
> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch?

In my personal prefer, your patch seems to have very good description and
rewrite almost part of mine.
Thus replacing is better. Can you please make replacing patch?



> > > > This patch series introduce new vmstat of swap-backed-file-mapped and fix above
> > > > patch by it.
> > 
> 
> I don't think the patch above needs to be fixed by another counter. At
> least, once the underflow was fixed up, it handled the malloc-stall without
> additional counters. If we need to account swap-backed-file-mapped, we need
> another failure case that it addresses to be sure we're doing the right thing.

ok, I drop this.



