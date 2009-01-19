Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbZASRds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbZASRds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZASRaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:30:06 -0500
Received: from mx1.suse.de ([195.135.220.2]:59764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbZASRaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:30:03 -0500
Message-ID: <4974BA08.4070809@suse.de>
Date: Tue, 20 Jan 2009 01:36:08 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [PATCH 17/20] fs/squashfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes squashfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 071df5b..0a65d16 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -301,6 +301,7 @@ failure:
 static int squashfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct squashfs_sb_info *msblk = dentry->d_sb->s_fs_info;
+	u64 id = huge_encode_dev(dentry->d_sb->s_bdev->bd_dev);

 	TRACE("Entered squashfs_statfs\n");

@@ -311,6 +312,8 @@ static int squashfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = msblk->inodes;
 	buf->f_ffree = 0;
 	buf->f_namelen = SQUASHFS_NAME_LEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	return 0;
 }

-- 
Coly Li
SuSE Labs


