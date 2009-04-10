Return-Path: <linux-kernel-owner+w=401wt.eu-S937595AbZDJAqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937595AbZDJAqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZDJAqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:46:22 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:45217 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZDJAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:46:21 -0400
From: Andy Grover <andy.grover@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, npiggin@suse.de, akpm@linux-foundation.org
Subject: [PATCH 1/1] Document get_user_pages_fast()
Date: Thu,  9 Apr 2009 17:44:43 -0700
Message-Id: <1239324283-4279-1-git-send-email-andy.grover@oracle.com>
X-Mailer: git-send-email 1.5.6.3
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49DE9683.019B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While better than get_user_pages(), the usage of gupf(),
especially the return values and the fact that it can
potentially only partially pin the range, warranted some
documentation.

Signed-off-by: Andy Grover <andy.grover@oracle.com>
---
 mm/util.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 2599e83..55bef16 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -223,6 +223,22 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 }
 #endif
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
 int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
-- 
1.5.6.3

