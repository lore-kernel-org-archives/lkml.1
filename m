Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbZD2Wp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbZD2Wp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbZD2Wla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:41:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39195 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763043AbZD2Wl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:41:28 -0400
Date: Wed, 29 Apr 2009 17:41:24 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] More eCryptfs fixes for 2.6.30-rc3
Message-ID: <20090429224121.GA25005@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus - Please pull a couple more 2.6.30-rc3 eCryptfs bug fixes from:

        git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

to get these changes:

Randy Dunlap (1):
	ecryptfs: fix printk format warning

Tyler Hicks (1):
	eCryptfs: Fix min function comparison warning

fs/ecryptfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 93bc0f8..2f0945d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -667,7 +667,7 @@ ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 	lower_buf = kmalloc(lower_bufsiz, GFP_KERNEL);
 	if (lower_buf == NULL) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__, lower_bufsiz);
+		       "kmalloc [%zd] bytes\n", __func__, lower_bufsiz);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -690,7 +690,7 @@ ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 		}
 		/* Check for bufsiz <= 0 done in sys_readlinkat() */
 		rc = copy_to_user(buf, plaintext_name,
-				  min((unsigned) bufsiz, plaintext_name_size));
+				  min((size_t) bufsiz, plaintext_name_size));
 		if (rc)
 			rc = -EFAULT;
 		else
