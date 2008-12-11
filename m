Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYLKWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYLKWht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYLKWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:37:39 -0500
Received: from kumera.dghda.com ([80.68.90.171]:41247 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbYLKWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:37:38 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Thu, 11 Dec 2008 22:37:34 +0000
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, hch@infradead.org
Subject: [PATCH, v2] freevxfs: ensure link targets are NUL-terminated
Message-ID: <20081211223733.GF18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com> <1229022995-9898-7-git-send-email-duaneg@dghda.com> <1229022995-9898-8-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-8-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

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
"I never could learn to drink that blood and call it wine" - Bob Dylan
