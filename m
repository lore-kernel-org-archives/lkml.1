Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYDAU7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYDAU7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbYDAU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:59:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50980 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758294AbYDAU7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:59:07 -0400
Message-Id: <20080401205637.230854375@sgi.com>
References: <20080401205531.986291575@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 13:55:38 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Dean Nelson <dcn@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 7/9] Locking rules for taking multiple mmap_sem locks.
Content-Disposition: inline; filename=xpmem_v003_lock-rule
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a lock ordering rule to avoid a potential deadlock when
multiple mmap_sems need to be locked.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---
 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-04-01 13:02:41.374608387 -0700
+++ linux-2.6/mm/filemap.c	2008-04-01 13:05:02.777015782 -0700
@@ -80,6 +80,9 @@ generic_file_direct_IO(int rw, struct ki
  *  ->i_mutex			(generic_file_buffered_write)
  *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
  *
+ *    When taking multiple mmap_sems, one should lock the lowest-addressed
+ *    one first proceeding on up to the highest-addressed one.
+ *
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
  *

-- 
