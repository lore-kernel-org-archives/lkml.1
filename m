Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZASRen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZASRen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZASRau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:30:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:59779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbZASRat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:30:49 -0500
Message-ID: <4974BA37.2070105@suse.de>
Date: Tue, 20 Jan 2009 01:36:55 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH 19/20] fs/udf: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes udf return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..192d4f2 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2086,6 +2086,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb = dentry->d_sb;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDescImpUse *lvidiu;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	if (sbi->s_lvid_bh != NULL)
 		lvidiu = udf_sb_lvidiu(sbi);
@@ -2101,8 +2102,9 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 					  le32_to_cpu(lvidiu->numDirs)) : 0)
 			+ buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
-	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN - 2;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	return 0;
 }
-- 
Coly Li
SuSE Labs



