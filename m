Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZASRao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZASRao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZASR2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:28:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:49904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbZASR2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:28:15 -0500
Message-ID: <4974B99B.7030405@suse.de>
Date: Tue, 20 Jan 2009 01:34:19 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/20] fs/isofs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes isofs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/isofs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6147ec3..8e17431 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -923,6 +923,7 @@ out_freesbi:
 static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type = ISOFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -932,6 +933,8 @@ static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = 0;
 	buf->f_files = ISOFS_SB(sb)->s_ninodes;
 	buf->f_ffree = 0;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = NAME_MAX;
 	return 0;
 }

-- 
Coly Li
SuSE Labs



