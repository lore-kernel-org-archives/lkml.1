Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXEYJVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXEYJVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXEYJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:21:29 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:44651 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXEYJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:21:28 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070525092126.17283.41581.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/5] Arbitrary grouping and statistics for grouping pages by mobility
Date: Fri, 25 May 2007 10:21:26 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The following patches address points brought up during review of the grouping
pages by mobility patches. The main aim of this patchset is to group pages
by an order other than MAX_ORDER-1 and provide some statistics but there
is also one bug fix at the start of the patchset.

Changelog since v2
o Patches acked by Christoph

Changelog since v1 of statistics and grouping by arbitrary order
o Fix a bug in move_freepages_block() calculations
o Make page_order available in internal.h for PageBuddy pages
o Rename fragavoidance to pagetypeinfo for both code and proc filename
o Renamr nr_pages_pageblock to pageblock_nr_pages for consistency
o Print out pageblock_nr_pages and pageblock_order in proc output
o Print out the orders in the header for /proc/pagetypeinfo
o The order being grouped at is no longer printed to the kernel log. The
  necessary information is available in /proc/pagetypeinfo
o Breakout page_order so that statistics do not require special knowledge
  of the buddy allocator

The first patch is a fix to move_freepages_block() where it calculates the
number of blocks used instead of the number of base pages which is what we
are really interested in. This is a bug fix.

The second patch moves page_order() to internal.h as it is needed by
the statistics patch later in the patchset. It is also needed by the
not-ready-for-posting-yet memory compaction prototype.

The third patch allows grouping by mobility at sizes other than
MAX_ORDER_NR_PAGES.  The size is based on the order of the system hugepage
where that is defined. When possible this is specified as a compile time
constant to help the optimiser. It does change the handling of hugepagesz
from __setup() to early_param() which needs looking at.

The fourth and fifth patches provide some statistics in relation to
fragmentation avoidance. The statistics patches are split as the second
set depend on information from PAGE_OWNER when it's available.
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
