Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZB0JSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZB0JSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZB0JRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:17:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:40294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZB0JRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:17:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,275,1233561600"; 
   d="scan'208";a="493569259"
Subject: iozone regression with 2.6.29-rc6
From: Lin Ming <ming.m.lin@intel.com>
To: npiggin@suse.de, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 17:13:59 +0800
Message-Id: <1235726039.11610.243.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bisect locates below commits,

commit 1cf6e7d83bf334cc5916137862c920a97aabc018
Author: Nick Piggin <npiggin@suse.de>
Date:   Wed Feb 18 14:48:18 2009 -0800

    mm: task dirty accounting fix

    YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
    cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).

    Additionally, there is some inconsistency about when task_dirty_inc is
    called.  It is used for dirty balancing, however it even gets called for
    __set_page_dirty_no_writeback.

    So rather than increment it in a set_page_dirty wrapper, move it down to
    exactly where the dirty page accounting stats are incremented.

    Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


below data in parenthesis is the result after above commit reverted, for example,
-10% (+2%) means,
iozone has ~10% regression with 2.6.29-rc6 compared with 2.6.29-rc5.
and
iozone has ~2% improvement with 2.6.29-rc6-revert-1cf6e7d compared with 2.6.29-rc5.


			4P dual-core HT	 	2P qual-core  	2P qual-core HT
			tulsa		   	stockley	Nehalem
			--------------------------------------------------------
iozone-rewrite		-10% (+2%)		-8% (0%)	-10% (-7%)
iozone-rand-write	-50% (0%)		-20% (+10%)
iozone-read					-13% (0%)
iozone-write					-28% (-1%)
iozone-reread							-5% (-1%)
iozone-mmap-read						-7% (+2%)
iozone-mmap-reread						-7% (+2%)
iozone-mmap-rand-read						-7% (+3%)
iozone-mmap-rand-write						-5% (0%)

Lin Ming

