Return-Path: <linux-kernel-owner+w=401wt.eu-S935816AbZDIXqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbZDIXqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbZDIXqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:46:42 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:31294 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbZDIXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:46:41 -0400
From: Andy Grover <andy.grover@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, npiggin@suse.de, akpm@linux-foundation.org
Subject: [PATCH 1/1] x86: Document get_user_pages_fast()
Date: Thu,  9 Apr 2009 16:45:29 -0700
Message-Id: <1239320729-3262-1-git-send-email-andy.grover@oracle.com>
X-Mailer: git-send-email 1.5.6.3
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49DE88A0.01D1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While better than get_user_pages(), the usage of gupf(),
especially the return values and the fact that it can
potentially only partially pin the range, warranted some
documentation.

Signed-off-by: Andy Grover <andy.grover@oracle.com>
---
 arch/x86/mm/gup.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index be54176..6340cef 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -219,6 +219,22 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ * 		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
-- 
1.5.6.3

