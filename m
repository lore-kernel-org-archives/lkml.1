Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYDDWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYDDWdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYDDWbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:31:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50185 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752397AbYDDWbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:31:33 -0400
Message-Id: <20080404223132.971442620@sgi.com>
References: <20080404223048.374852899@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 15:30:56 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Dean Nelson <dcn@sgi.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 08/10] xpmem: Locking rules for taking multiple mmap_sem locks.
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
