Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZKRIdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZKRIdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZKRIdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:33:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZKRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830427"
Message-Id: <20091118082846.530386547@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/12] ext4: remove unused parameter wbc from __ext4_journalled_writepage()
References: <20091118082648.140755818@intel.com>
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

--- linux.orig/fs/ext4/inode.c	2009-11-06 09:36:28.000000000 +0800
+++ linux/fs/ext4/inode.c	2009-11-06 09:52:22.000000000 +0800
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


