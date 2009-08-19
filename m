Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZHSQGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZHSQGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZHSQF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:05:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:55956 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZHSQEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:48 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com
Subject: [PATCH 14/17] xfs: Use new syncing helper
Date: Wed, 19 Aug 2009 18:04:41 +0200
Message-Id: <1250697884-22288-15-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new generic_write_sync() helper from xfs_write().

CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7078974..aeb5a39 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -817,7 +817,7 @@ write_retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+		error2 = generic_write_sync(file, pos, ret);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
-- 
1.6.0.2

