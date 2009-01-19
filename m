Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbZASRdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbZASRdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbZASR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:29:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:59751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038AbZASR3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:29:33 -0500
Message-ID: <4974B9EB.7060401@suse.de>
Date: Tue, 20 Jan 2009 01:35:39 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [PATCH 15/20] fs/reiserfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes reiserfs3 return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index f3c820b..c14fcd0 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1883,7 +1883,9 @@ error:

 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_namelen = (REISERFS_MAX_NAME(s->s_blocksize));
 	buf->f_bfree = sb_free_blocks(rs);
@@ -1892,6 +1894,9 @@ static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	/* changed to accommodate gcc folks. */
 	buf->f_type = REISERFS_SUPER_MAGIC;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }

-- 
Coly Li
SuSE Labs


