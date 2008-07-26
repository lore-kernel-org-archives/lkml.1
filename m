Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYGZQV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYGZQV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYGZQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:21:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:10820 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYGZQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=rQ6eTEq7VL7qwPa9t/uOZvrYKfrxoc69SpX8Kno1HVutWjLP8opJ9vJhg1ifEwBMAq
         sElwsRTIRUh5sYwhz2+oZVgBYTw2CCMaLK1u/ne2Mh2jYiPmmwO9pKjXWNW2b3fqE4m0
         07Vh0Ol/jUHYnun3ZVV1YXRMU7iLqzkg6JDqA=
From: Andrea Righi <righi.andrea@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 1/1] hugetlb: remove unused variable warning
Date: Sat, 26 Jul 2008 18:21:17 +0200
Message-Id: <1217089277-29626-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the following warning when CONFIG_HUGETLB_PAGE is not set:

	ipc/shm.c: In function ‘shm_get_stat’:
	ipc/shm.c:565: warning: unused variable ‘h’

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/hugetlb.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9a71d4c..6881313 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -273,7 +273,10 @@ struct hstate {};
 #define huge_page_mask(h) PAGE_MASK
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
-#define pages_per_huge_page(h) 1
+static inline unsigned int pages_per_huge_page(struct hstate *h)
+{
+        return 1;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
-- 
1.5.4.3

