Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXKZQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXKZQs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXKZQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52820 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbXKZQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:50 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Hugh Dickins <hugh@veritas.com>, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/16] Unionfs: minor cleanup in writepage
Date: Mon, 26 Nov 2007 11:43:59 -0500
Message-Id: <1196095453208-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 4918f77..1e10280 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -56,6 +56,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	copy_highpage(lower_page, page);
 	flush_dcache_page(lower_page);
 	SetPageUptodate(lower_page);
+	set_page_dirty(lower_page);
 
 	/*
 	 * Call lower writepage (expects locked page).  However, if we are
@@ -66,12 +67,11 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	 * success.
 	 */
 	if (wbc->for_reclaim) {
-		set_page_dirty(lower_page);
 		unlock_page(lower_page);
 		goto out_release;
 	}
+
 	BUG_ON(!lower_mapping->a_ops->writepage);
-	set_page_dirty(lower_page);
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
 	if (err < 0)
-- 
1.5.2.2

