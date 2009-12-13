Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZLNA0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZLNA0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZLMX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbZLMX5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:20 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, torvalds@linux-foundation.org,
       matthew@wil.cx, viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: [PATCH 1/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:09 +0100
Message-Id: <118defc93a30d15895a4864f647c2eaf0732907a.1260662994.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a057f48..3d3d6af 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -566,41 +566,41 @@ typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
 		unsigned long, unsigned long);
 
 struct address_space_operations {
-	int (*writepage)(struct page *page, struct writeback_control *wbc);
-	int (*readpage)(struct file *, struct page *);
-	void (*sync_page)(struct page *);
+	int (* const writepage)(struct page *page, struct writeback_control *wbc);
+	int (* const readpage)(struct file *, struct page *);
+	void (* const sync_page)(struct page *);
 
 	/* Write back some dirty pages from this mapping. */
-	int (*writepages)(struct address_space *, struct writeback_control *);
+	int (* const writepages)(struct address_space *, struct writeback_control *);
 
 	/* Set a page dirty.  Return true if this dirtied it */
-	int (*set_page_dirty)(struct page *page);
+	int (* const set_page_dirty)(struct page *page);
 
-	int (*readpages)(struct file *filp, struct address_space *mapping,
+	int (* const readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 
-	int (*write_begin)(struct file *, struct address_space *mapping,
+	int (* const write_begin)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata);
-	int (*write_end)(struct file *, struct address_space *mapping,
+	int (* const write_end)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
 
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
-	sector_t (*bmap)(struct address_space *, sector_t);
-	void (*invalidatepage) (struct page *, unsigned long);
-	int (*releasepage) (struct page *, gfp_t);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
+	sector_t (* const bmap)(struct address_space *, sector_t);
+	void (* const invalidatepage) (struct page *, unsigned long);
+	int (* const releasepage) (struct page *, gfp_t);
+	ssize_t (* const direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
-	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
+	int (* const get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/* migrate the contents of a page to the specified target */
-	int (*migratepage) (struct address_space *,
+	int (* const migratepage) (struct address_space *,
 			struct page *, struct page *);
-	int (*launder_page) (struct page *);
-	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
+	int (* const launder_page) (struct page *);
+	int (* const is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
-	int (*error_remove_page)(struct address_space *, struct page *);
+	int (* const error_remove_page)(struct address_space *, struct page *);
 };
 
 /*
-- 
1.6.5.3

