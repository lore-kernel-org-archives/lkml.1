Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbZE3OkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbZE3OkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZE3OkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:40:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:38240 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZE3OkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:40:14 -0400
Date: Sat, 30 May 2009 23:39:39 +0900 (JST)
Message-Id: <20090530.233939.117907552.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 bugfix for 2.6.30-rc8?
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 30 May 2009 23:39:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The nilfs tree has one bugfix.  Please pull it from:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following change since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d
 Linus Torvalds (1):
      Linux 2.6.30-rc7

Ryusuke Konishi (1):
      nilfs2: fix bh leak in nilfs_cpfile_delete_checkpoints function

 fs/nilfs2/cpfile.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index e90b60d..300f1cd 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -311,7 +311,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 		if (ret < 0) {
 			if (ret != -ENOENT)
-				goto out_sem;
+				goto out_header;
 			/* skip hole */
 			ret = 0;
 			continue;
@@ -344,7 +344,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 					continue;
 				printk(KERN_ERR "%s: cannot delete block\n",
 				       __func__);
-				goto out_sem;
+				goto out_header;
 			}
 		}
 
@@ -361,6 +361,8 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		nilfs_mdt_mark_dirty(cpfile);
 		kunmap_atomic(kaddr, KM_USER0);
 	}
+
+ out_header:
 	brelse(header_bh);
 
  out_sem:
-- 

Thanks,
Ryusuke Konishi
