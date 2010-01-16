Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0APQAh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390Ab0APQAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:00:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44216 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab0APQA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:00:28 -0500
Date: Sat, 16 Jan 2010 17:00:26 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 9/9] fs/ecryptfs: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161700100.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable lower_dentry is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ecryptfs/file.c                  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 1744f17..7bf1031 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -158,9 +158,9 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	struct dentry *ecryptfs_dentry = file->f_path.dentry;
 	/* Private value of ecryptfs_dentry allocated in
 	 * ecryptfs_lookup() */
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
+	struct dentry *lower_dentry;
 	struct ecryptfs_file_info *file_info;
 
 	mount_crypt_stat = &ecryptfs_superblock_to_private(
