Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZASRbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZASRbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbZASR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:28:29 -0500
Received: from ns1.suse.de ([195.135.220.2]:59693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393AbZASR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:28:28 -0500
Message-ID: <4974B9A9.10305@suse.de>
Date: Tue, 20 Jan 2009 01:34:33 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes jfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
---
 fs/jfs/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index b37d1f7..7969c2f 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -143,8 +143,10 @@ static void jfs_destroy_inode(struct inode *inode)

 static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct jfs_sb_info *sbi = JFS_SBI(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	s64 maxinodes;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 	struct inomap *imap = JFS_IP(sbi->ipimap)->i_imap;

 	jfs_info("In jfs_statfs");
@@ -168,6 +170,8 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = maxinodes;
 	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
 				    atomic_read(&imap->im_numfree));
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	buf->f_namelen = JFS_NAME_MAX;
 	return 0;

-- 
Coly Li
SuSE Labs



