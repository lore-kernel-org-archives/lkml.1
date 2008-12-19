Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYLSUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYLSUur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYLSUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:50 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35316 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYLSUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:47 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, v5] freevxfs: ensure fast symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:17 +0000
Message-Id: <1229719638-6982-10-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-9-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
 <1229719638-6982-5-git-send-email-duaneg@dghda.com>
 <1229719638-6982-6-git-send-email-duaneg@dghda.com>
 <1229719638-6982-7-git-send-email-duaneg@dghda.com>
 <1229719638-6982-8-git-send-email-duaneg@dghda.com>
 <1229719638-6982-9-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Unchanged from v4.

 fs/freevxfs/vxfs_inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 9f3f2ce..03a6ea5 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -325,8 +325,10 @@ vxfs_iget(struct super_block *sbp, ino_t ino)
 		if (!VXFS_ISIMMED(vip)) {
 			ip->i_op = &page_symlink_inode_operations;
 			ip->i_mapping->a_ops = &vxfs_aops;
-		} else
+		} else {
 			ip->i_op = &vxfs_immed_symlink_iops;
+			vip->vii_immed.vi_immed[ip->i_size] = '\0';
+		}
 	} else
 		init_special_inode(ip, ip->i_mode, old_decode_dev(vip->vii_rdev));
 
-- 
1.6.0.4

