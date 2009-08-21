Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZHUR1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZHUR1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbZHUR1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:27:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712AbZHURYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 14/17] pohmelfs: Use new syncing helper
Date: Fri, 21 Aug 2009 19:24:04 +0200
Message-Id: <1250875447-15622-15-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new generic_write_sync() helper instead of sync_page_range().

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/pohmelfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 17801a5..a2e5eed 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -927,10 +927,10 @@ ssize_t pohmelfs_write(struct file *file, const char __user *buf,
 	mutex_unlock(&inode->i_mutex);
 	WARN_ON(ret < 0);
 
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if (ret > 0) {
 		ssize_t err;
 
-		err = sync_page_range(inode, mapping, pos, ret);
+		err = generic_write_sync(file, pos, ret);
 		if (err < 0)
 			ret = err;
 		WARN_ON(ret < 0);
-- 
1.6.0.2

