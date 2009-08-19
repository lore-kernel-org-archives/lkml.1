Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZHSQFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZHSQFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZHSQEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:55928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZHSQEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:46 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 04/17] pohmelfs: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
Date: Wed, 19 Aug 2009 18:04:31 +0200
Message-Id: <1250697884-22288-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new helper __generic_file_aio_write(). Since the fs takes care of syncing
by itself afterwards, there are no more changes needed.

CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/pohmelfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 7b60579..17801a5 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -921,7 +921,7 @@ ssize_t pohmelfs_write(struct file *file, const char __user *buf,
 	if (ret)
 		goto err_out_unlock;
 
-	ret = generic_file_aio_write_nolock(&kiocb, &iov, 1, pos);
+	ret = __generic_file_aio_write(&kiocb, &iov, 1, &kiocb.ki_pos);
 	*ppos = kiocb.ki_pos;
 
 	mutex_unlock(&inode->i_mutex);
-- 
1.6.0.2

