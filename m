Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbZASRct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbZASRct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbZASR3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:29:20 -0500
Received: from mx1.suse.de ([195.135.220.2]:59728 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbZASR3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:29:18 -0500
Message-ID: <4974B9DC.9060305@suse.de>
Date: Tue, 20 Jan 2009 01:35:24 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Anders Larsen <al@alarsen.net>
Subject: [PATCH 14/20] fs/qnx4: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes qnx4 file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Anders Larsen <al@alarsen.net>
---
 fs/qnx4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 2aad104..fe1f0f3 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -282,6 +282,7 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	lock_kernel();

@@ -291,6 +292,8 @@ static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree   = qnx4_count_free_blocks(sb);
 	buf->f_bavail  = buf->f_bfree;
 	buf->f_namelen = QNX4_NAME_MAX;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	unlock_kernel();


-- 
Coly Li
SuSE Labs


