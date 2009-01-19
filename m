Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZASR3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZASR3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZASR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:27:47 -0500
Received: from mail.suse.de ([195.135.220.2]:59678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZASR1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:27:46 -0500
Message-ID: <4974B980.1000101@suse.de>
Date: Tue, 20 Jan 2009 01:33:52 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/20] fs/hfsplus: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hfsplus return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/hfsplus/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index eb74531..f2a6402 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -223,6 +223,7 @@ static void hfsplus_put_super(struct super_block *sb)
 static int hfsplus_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type = HFSPLUS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -231,6 +232,8 @@ static int hfsplus_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = 0xFFFFFFFF;
 	buf->f_ffree = 0xFFFFFFFF - HFSPLUS_SB(sb).next_cnid;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = HFSPLUS_MAX_STRLEN;

 	return 0;

-- 
Coly Li
SuSE Labs



