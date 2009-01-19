Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZASR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZASR1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbZASR0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:26:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:59612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZASR0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:26:09 -0500
Message-ID: <4974B91F.8050507@suse.de>
Date: Tue, 20 Jan 2009 01:32:15 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/20] fs/cramfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes cramfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/cramfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a07338d..1cb64ac 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -318,6 +318,7 @@ out:
 static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type = CRAMFS_MAGIC;
 	buf->f_bsize = PAGE_CACHE_SIZE;
@@ -326,6 +327,8 @@ static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = 0;
 	buf->f_files = CRAMFS_SB(sb)->files;
 	buf->f_ffree = 0;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = CRAMFS_MAXPATHLEN;
 	return 0;
 }

-- 
Coly Li
SuSE Labs



