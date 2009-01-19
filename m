Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZASRfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZASRfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZASRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:31:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:50040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759899AbZASRbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:31:04 -0500
Message-ID: <4974BA45.6070601@suse.de>
Date: Tue, 20 Jan 2009 01:37:09 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH 20/20] fs/ufs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes ufs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/ufs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e65212d..a98cab7 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1257,6 +1257,7 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ufs_super_block_first *usb1;
 	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	lock_kernel();

@@ -1279,6 +1280,8 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		? (buf->f_bfree - (((long)buf->f_blocks / 100) * uspi->s_minfree)) : 0;
 	buf->f_files = uspi->s_ncg * uspi->s_ipg;
 	buf->f_namelen = UFS_MAXNAMLEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	unlock_kernel();


-- 
Coly Li
SuSE Labs



