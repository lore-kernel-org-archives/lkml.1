Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZLDWGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZLDWGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbZLDWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:06:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbZLDWGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:06:19 -0500
Message-ID: <4B198849.1060909@gmail.com>
Date: Fri, 04 Dec 2009 23:08:09 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 02/31] Constify struct address_space_operations for 2.6.32
 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Constify struct address_space_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..1a55cac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -565,41 +565,41 @@ typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
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

