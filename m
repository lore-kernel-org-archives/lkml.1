Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZASR2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZASR2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZASR0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:26:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:59625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZASR0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:26:41 -0500
Message-ID: <4974B93F.8080909@suse.de>
Date: Tue, 20 Jan 2009 01:32:47 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 6/20] fs/fat: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes fat return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 6b74d09..c093b7f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -523,7 +523,9 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)

 static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	/* If the count of free cluster is still unknown, counts it here. */
 	if (sbi->free_clusters == -1 || !sbi->free_clus_valid) {
@@ -537,6 +539,8 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = sbi->max_cluster - FAT_START_ENT;
 	buf->f_bfree = sbi->free_clusters;
 	buf->f_bavail = sbi->free_clusters;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = sbi->options.isvfat ? 260 : 12;

 	return 0;
-- 
Coly Li
SuSE Labs



