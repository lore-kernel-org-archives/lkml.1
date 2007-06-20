Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbXFTSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbXFTSl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbXFTSbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54798 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757293AbXFTSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:11 -0400
Message-Id: <20070620183010.615392204@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:27 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [20/37] Fix PAGE SIZE assumption in miscellaneous places.
Content-Disposition: inline; filename=vps_kernel
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/container.c |    4 ++--
 kernel/futex.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: vps/kernel/futex.c
===================================================================
--- vps.orig/kernel/futex.c	2007-06-14 21:52:20.000000000 -0700
+++ vps/kernel/futex.c	2007-06-14 21:53:43.000000000 -0700
@@ -255,7 +255,7 @@ int get_futex_key(u32 __user *uaddr, str
 	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
 	if (err >= 0) {
 		key->shared.pgoff =
-			page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+			page->index << (compound_order(page) - PAGE_SHIFT);
 		put_page(page);
 		return 0;
 	}
Index: vps/kernel/container.c
===================================================================
--- vps.orig/kernel/container.c	2007-06-14 21:53:57.000000000 -0700
+++ vps/kernel/container.c	2007-06-14 21:54:13.000000000 -0700
@@ -840,8 +840,8 @@ static int container_fill_super(struct s
 	struct dentry *root;
 	struct containerfs_root *hroot = options;
 
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	sb->s_blocksize = PAGE_SIZE;
+	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = CONTAINER_SUPER_MAGIC;
 	sb->s_op = &container_ops;
 

-- 
