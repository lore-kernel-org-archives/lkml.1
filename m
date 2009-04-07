Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZDGMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZDGMFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZDGMAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:23410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485AbZDGMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748654"
Message-Id: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 00/14] filemap and readahead fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is a set of fixes and cleanups for filemap and readahead.
They are for 2.6.29-rc8-mm1 and have been carefully tested.

filemap VM_FAULT_RETRY fixes
----------------------------
        [PATCH 01/14] mm: fix find_lock_page_retry() return value parsing
        [PATCH 02/14] mm: fix major/minor fault accounting on retried fault
        [PATCH 03/14] mm: remove FAULT_FLAG_RETRY dead code
        [PATCH 04/14] mm: reduce duplicate page fault code
        [PATCH 05/14] readahead: account mmap_miss for VM_FAULT_RETRY

readahead fixes
---------------
minor cleanups:
        [PATCH 06/14] readahead: move max_sane_readahead() calls into force_page_cache_readahead()
        [PATCH 07/14] readahead: apply max_sane_readahead() limit in ondemand_readahead()
        [PATCH 08/14] readahead: remove one unnecessary radix tree lookup

behavior changes necessary for the following mmap readahead:
        [PATCH 09/14] readahead: increase interleaved readahead size
        [PATCH 10/14] readahead: remove sync/async readahead call dependency

mmap readaround/readahead
-------------------------
major cleanups from Linus:
(the cleanups automatically fix a PGMAJFAULT accounting bug in VM_RAND_READ case)
        [PATCH 11/14] readahead: clean up and simplify the code for filemap page fault readahead

and my further steps:
        [PATCH 12/14] readahead: sequential mmap readahead
        [PATCH 13/14] readahead: enforce full readahead size on async mmap readahead
        [PATCH 14/14] readahead: record mmap read-around states in file_ra_state

Thanks,
Fengguang
-- 

