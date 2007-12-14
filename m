Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbXLNDf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbXLNDf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXLNDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:35:48 -0500
Received: from [60.23.248.87] ([60.23.248.87]:37187 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbXLNDfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:35:48 -0500
From: Qi Yong <qiyong@fc-cn.com>
Organization: FCD
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] set_page_refcounted VM_BUG_ON fix
Date: Fri, 14 Dec 2007 11:36:10 +0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141136.10481.qiyong@fc-cn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The current PageTail semantic is that a PageTail page is first a PageCompound page.
So remove the redundant PageCompound test in set_page_refcounted().

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
---
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
diff --git a/mm/internal.h b/mm/internal.h
index 953f941..79797db 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,7 +24,7 @@ static inline void set_page_count(struct page *page, int v)
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && PageTail(page));
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }

-- 
Qi Yong
