Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYCZJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYCZJdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYCZJdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:33:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:41330 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706AbYCZJdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:33:22 -0400
Date: Wed, 26 Mar 2008 10:33:21 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, dgc@sgi.com, wfg@mail.ustc.edu.cn,
       linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Skip inodes without pages to free in
	drop_pagecache_sb()
Message-ID: <20080326093321.GB7835@duck.suse.cz>
References: <20080325181227.GE5125@duck.suse.cz> <20080325125354.5f2da108.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325125354.5f2da108.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jan Kara <jack@suse.cz>
CC: Fengguang Wu <wfg@mail.ustc.edu.cn>

---
 fs/drop_caches.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index f5aae26..7327a42 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -20,6 +20,8 @@ static void drop_pagecache_sb(struct super_block *sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
+		if (inode->i_mapping->nrpages == 0)
+			continue;
 		__iget(inode);
 		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
-- 
1.5.2.4

