Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXLQSNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXLQSNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbXLQSNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:13:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:45110 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753733AbXLQSNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:13:12 -0500
Date: Mon, 17 Dec 2007 19:13:11 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Convert some variables to pgoff_t
Message-ID: <20071217181311.GE25521@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  while doing some other work I spotted that a few variables should be
pgoff_t while they are declared as unsigned long. Attached patch should fix
that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Convert variables containing page indexes to pgoff_t.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/mm/filemap.c b/mm/filemap.c
index 188cf5f..ae2f868 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1294,7 +1294,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	struct page *page;
-	unsigned long size;
+	pgoff_t size;
 	int did_readaround = 0;
 	int ret = 0;
 
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 32132f3..590a178 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -55,7 +55,8 @@ do_xip_mapping_read(struct address_space *mapping,
 		    read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index, end_index, offset;
+	pgoff_t index, end_index;
+	unsigned long offset;
 	loff_t isize;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
