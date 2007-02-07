Return-Path: <linux-kernel-owner+w=401wt.eu-S1161421AbXBGUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161421AbXBGUke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161431AbXBGUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:40:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34106 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161421AbXBGUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:40:33 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] Define the shmem_inode_info flags directly
Date: Wed, 07 Feb 2007 12:40:30 -0800
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, agl@us.ibm.com
Message-Id: <20070207204030.30615.77294.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew: This is a pretty basic and obvious cleanup IMO.  How about a ride in
-mm?

Defining flags in terms of other flags is always confusing.  Give them literal
values instead of defining them in terms of VM_flags.  While we're at it, move
them to a header file in preparation for the introduction of a
SHMEM_HUGETLB flag.

Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 include/linux/shmem_fs.h |    4 ++++
 mm/shmem.c               |    4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index f3c5189..3ea0b6e 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -8,6 +8,10 @@
 
 #define SHMEM_NR_DIRECT 16
 
+/* These info->flags are used to handle pagein/truncate races efficiently */
+#define SHMEM_PAGEIN	0x00000001
+#define SHMEM_TRUNCATE	0x00000002
+
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned long		flags;
diff --git a/mm/shmem.c b/mm/shmem.c
index 70da7a0..a9bdb0d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -66,10 +66,6 @@
 
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
 
-/* info->flags needs VM_flags to handle pagein/truncate races efficiently */
-#define SHMEM_PAGEIN	 VM_READ
-#define SHMEM_TRUNCATE	 VM_WRITE
-
 /* Definition to limit shmem_truncate's steps between cond_rescheds */
 #define LATENCY_LIMIT	 64
 
