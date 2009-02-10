Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZBJW1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZBJW1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZBJW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:27:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50330 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbZBJW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:27:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Feb 2009 23:27:32 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] hugetlbfs: fix build failure with !CONFIG_HUGETLBFS
To: Chris Clayton <chris2553@googlemail.com>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <c6b1100b0902101353q2c5ad750t2a901de97dc5fe5@mail.gmail.com>
Message-ID: <tkrat.a79dcd647f8ae43e@s5r6.in-berlin.de>
References: <c6b1100b0902101353q2c5ad750t2a901de97dc5fe5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression due to 5a6fe125950676015f5108fb71b2a67441755003,
"Do not account for the address space used by hugetlbfs using VM_ACCOUNT"
which added an argument to the function hugetlb_file_setup() but not to
the macro hugetlb_file_setup().

Reported-by: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/hugetlb.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index af09660..03be7f2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -159,9 +159,9 @@ static inline void set_file_hugepages(struct file *file)
 }
 #else /* !CONFIG_HUGETLBFS */
 
-#define is_file_hugepages(file)		0
-#define set_file_hugepages(file)	BUG()
-#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
+#define is_file_hugepages(file)			0
+#define set_file_hugepages(file)		BUG()
+#define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
-- 
1.6.0.6


-- 
Stefan Richter
-=====-==--= --=- -=-=-
http://arcgraph.de/sr/

