Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZASR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZASR0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZASRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:25:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZASRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:25:39 -0500
Message-ID: <4974B901.9090606@suse.de>
Date: Tue, 20 Jan 2009 01:31:45 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 2/20] fs/affs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes affs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/affs/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index a19d64b..5ce695e 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -533,6 +533,7 @@ affs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	int		 free;
+	u64		 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	pr_debug("AFFS: statfs() partsize=%d, reserved=%d\n",AFFS_SB(sb)->s_partition_size,
 	     AFFS_SB(sb)->s_reserved);
@@ -543,6 +544,9 @@ affs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks  = AFFS_SB(sb)->s_partition_size - AFFS_SB(sb)->s_reserved;
 	buf->f_bfree   = free;
 	buf->f_bavail  = free;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+	buf->f_namelen = 30;
 	return 0;
 }


-- 
Coly Li
SuSE Labs



