Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0BGEOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 23:14:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:54229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0BGEOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 23:14:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="593779365"
Message-Id: <20100207041013.891441102@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 12:10:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] 512K readahead size with thrashing safe readahead
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

It seems there are no strong objections against the 512KB readahead size.
(Or, anyone would prefer an 1MB readahead? Chris Mason picked a 4MB size
 for btrfs after all.)

So would you include the patchset for wider tests in -mm? I reordered the
patchset a bit: the first 2 patches are good candidates for 2.6.34, while
the others may need longer tests.

Changes since RFC:
- move the lenthy intro text to individual patch changelogs
- treat get_capacity()==0 as uninitilized value (Thanks to Vivek Goyal)
- increase readahead size limit for small devices (Thanks to Jens Axboe)
- add fio test results by Vivek Goyal

	[PATCH 01/11] readahead: limit readahead size for small devices
	[PATCH 02/11] readahead: retain inactive lru pages to be accessed soon

	[PATCH 03/11] readahead: bump up the default readahead size
	[PATCH 04/11] readahead: introduce {MAX|MIN}_READAHEAD_PAGES macros for ease of use
	[PATCH 05/11] readahead: replace ra->mmap_miss with ra->ra_flags
	[PATCH 06/11] readahead: thrashing safe context readahead
	[PATCH 07/11] readahead: record readahead patterns
	[PATCH 08/11] readahead: add tracing event
	[PATCH 09/11] readahead: add /debug/readahead/stats
	[PATCH 10/11] readahead: dont do start-of-file readahead after lseek()
	[PATCH 11/11] radixtree: speed up next/prev hole search

Thanks,
Fengguang

