Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZASR26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZASR26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZASR07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:26:59 -0500
Received: from mail.suse.de ([195.135.220.2]:59634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZASR06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:26:58 -0500
Message-ID: <4974B94D.60701@suse.de>
Date: Tue, 20 Jan 2009 01:33:01 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 7/20] fs/hfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index c8b5acf..a36bb74 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -82,6 +82,7 @@ static void hfs_put_super(struct super_block *sb)
 static int hfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type = HFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -90,6 +91,8 @@ static int hfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = HFS_SB(sb)->fs_ablocks;
 	buf->f_ffree = HFS_SB(sb)->free_ablocks;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = HFS_NAMELEN;

 	return 0;
-- 
Coly Li
SuSE Labs



