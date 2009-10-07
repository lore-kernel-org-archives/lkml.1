Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZJGIAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZJGIAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZJGIAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZJGIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971117"
Message-Id: <20091007074901.484264566@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/45] ext4: remove unused parameter wbc from __ext4_journalled_writepage()
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-ext4-remove-wbc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Theodore Ts'o <tytso@mit.edu> 
CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/fs/ext4/inode.c	2009-10-06 23:31:41.000000000 +0800
+++ linux/fs/ext4/inode.c	2009-10-06 23:31:54.000000000 +0800
@@ -2599,7 +2599,6 @@ static int bput_one(handle_t *handle, st
 }
 
 static int __ext4_journalled_writepage(struct page *page,
-				       struct writeback_control *wbc,
 				       unsigned int len)
 {
 	struct address_space *mapping = page->mapping;
@@ -2757,7 +2756,7 @@ static int ext4_writepage(struct page *p
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		return __ext4_journalled_writepage(page, wbc, len);
+		return __ext4_journalled_writepage(page, len);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))


