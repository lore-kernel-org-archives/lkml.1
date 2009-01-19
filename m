Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZASRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZASRbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZASR3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:29:07 -0500
Received: from mx1.suse.de ([195.135.220.2]:59721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbZASR3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:29:04 -0500
Message-ID: <4974B9CE.7020900@suse.de>
Date: Tue, 20 Jan 2009 01:35:10 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 13/20] fs/omfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes omfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 633e9dc..d79e808 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -262,14 +262,19 @@ static int omfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *s = dentry->d_sb;
 	struct omfs_sb_info *sbi = OMFS_SB(s);
+	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
+
 	buf->f_type = OMFS_MAGIC;
 	buf->f_bsize = sbi->s_blocksize;
 	buf->f_blocks = sbi->s_num_blocks;
 	buf->f_files = sbi->s_num_blocks;
 	buf->f_namelen = OMFS_NAMELEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	buf->f_bfree = buf->f_bavail = buf->f_ffree =
 		omfs_count_free(s);
+
 	return 0;
 }

-- 
Coly Li
SuSE Labs



