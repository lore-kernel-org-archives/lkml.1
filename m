Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZAGKPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZAGKPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZAGKOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:14:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48225 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZAGKOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:14:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] GFS2: Fix typo in gfs_page_mkwrite()
Date: Wed,  7 Jan 2009 09:16:24 +0000
Message-Id: <1231319784-18695-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1231319784-18695-3-git-send-email-swhiteho@redhat.com>
References: <1231319784-18695-1-git-send-email-swhiteho@redhat.com>
 <1231319784-18695-2-git-send-email-swhiteho@redhat.com>
 <1231319784-18695-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

There is a typo in gfs2_page_mkwrite()

gfs2_write_alloc_required() expects pos to be the offset in bytes. However,
instead of the page index being shifted by by PAGE_CACHE_SHIFT, it was shifted
by (PAGE_CACHE_SIZE - inode->i_blkbits).  This patch simply shifts the page
index by the proper amount.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 289c5f5..93fe41b 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -342,7 +342,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned long last_index;
-	u64 pos = page->index << (PAGE_CACHE_SIZE - inode->i_blkbits);
+	u64 pos = page->index << PAGE_CACHE_SHIFT;
 	unsigned int data_blocks, ind_blocks, rblocks;
 	int alloc_required = 0;
 	struct gfs2_holder gh;
-- 
1.6.0.3

