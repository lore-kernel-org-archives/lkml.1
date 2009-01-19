Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZASReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZASReP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbZASRag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:30:36 -0500
Received: from mx1.suse.de ([195.135.220.2]:59776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510AbZASRaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:30:35 -0500
Message-ID: <4974BA28.5040204@suse.de>
Date: Tue, 20 Jan 2009 01:36:40 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 18/20] fs/sysv: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sysv file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/sysv/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 3d81bf5..da20b48 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -90,6 +90,7 @@ static int sysv_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type = sb->s_magic;
 	buf->f_bsize = sb->s_blocksize;
@@ -98,6 +99,8 @@ static int sysv_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = sbi->s_ninodes;
 	buf->f_ffree = sysv_count_free_inodes(sb);
 	buf->f_namelen = SYSV_NAMELEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	return 0;
 }

-- 
Coly Li
SuSE Labs


