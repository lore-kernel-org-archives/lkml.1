Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbZHUR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbZHUR2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbZHUR1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbZHURYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com
Subject: [PATCH 13/17] xfs: Convert sync_page_range() to simple fdatawrite_range()
Date: Fri, 21 Aug 2009 19:24:03 +0200
Message-Id: <1250875447-15622-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig says that it is enough for XFS to call
filemap_fdatawrite_range() instead of sync_page_range() because we do all the
waiting when forcing the log.

CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
CC: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7078974..a68053c 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -817,7 +817,7 @@ write_retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
-- 
1.6.0.2

