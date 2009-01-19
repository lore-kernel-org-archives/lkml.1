Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbZASRd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbZASRd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZASR3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:29:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:59756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbZASR3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:29:48 -0500
Message-ID: <4974B9FA.3010100@suse.de>
Date: Tue, 20 Jan 2009 01:35:54 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/20] fs/romfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes romfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/romfs/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 98a232f..9d84e3c 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -186,11 +186,17 @@ outnobh:
 static int
 romfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
+	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+
 	buf->f_type = ROMFS_MAGIC;
 	buf->f_bsize = ROMBSIZE;
 	buf->f_bfree = buf->f_bavail = buf->f_ffree;
 	buf->f_blocks = (romfs_maxsize(dentry->d_sb)+ROMBSIZE-1)>>ROMBSBITS;
 	buf->f_namelen = ROMFS_MAXFN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }

-- 
Coly Li
SuSE Labs


