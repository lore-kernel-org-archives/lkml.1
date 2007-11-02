Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXKBWOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXKBWOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXKBWN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:13:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48689 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbXKBWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:13:56 -0400
Date: Fri, 2 Nov 2007 17:11:04 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ecryptfs-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] eCryptfs: Cast page->index to loff_t instead of off_t
Message-ID: <20071102221104.GE30487@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

page->index should be cast to loff_t instead of off_t.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ecryptfs/read_write.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 2150edf..6b7474a 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -87,7 +87,7 @@ int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
 	loff_t offset;
 	int rc;
 
-	offset = ((((off_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
+	offset = ((((loff_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
 		  + offset_in_page);
 	virt = kmap(page_for_lower);
 	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
-- 
1.5.1.6

