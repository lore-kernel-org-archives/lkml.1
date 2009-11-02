Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZKBKJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZKBKJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZKBKHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:47298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Bob Copeland <me@bobcopeland.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       linux-karma-devel@lists.sourceforge.net
Subject: [PATCH 21/27] BKL: Remove BKL from omfs
Date: Mon,  2 Nov 2009 11:05:01 +0100
Message-Id: <1257156307-24175-22-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/omfs/inode.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index ddfbb22..f3b7c15 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -416,15 +416,11 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sector_t start;
 	int ret = -EINVAL;
 
-	lock_kernel();
-
 	save_mount_options(sb, (char *) data);
 
 	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sb->s_fs_info = sbi;
 
@@ -529,7 +525,6 @@ out_brelse_bh2:
 out_brelse_bh:
 	brelse(bh);
 end:
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

