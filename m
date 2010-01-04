Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240Ab0ADPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0ADPZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833Ab0ADPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:25:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:59574 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0ADPZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:25:10 -0500
Date: Tue, 05 Jan 2010 00:25:03 +0900 (JST)
Message-Id: <20100105.002503.06945854.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.33
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 05 Jan 2010 00:25:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab a few nilfs2 fixes, containing only style fixes and a change
of mailing list address.

Thanks!
Ryusuke Konishi
--
The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
  Linus Torvalds (1):
        Linux 2.6.33-rc2

Jiro SEKIBA (1):
      nilfs2: trivial coding style fix

Ryusuke Konishi (1):
      nilfs2: update mailing list address

Tobias Klauser (1):
      nilfs2: Storage class should be before const qualifier

 Documentation/filesystems/nilfs2.txt |    2 +-
 MAINTAINERS                          |    2 +-
 fs/nilfs2/bmap.c                     |    4 ++--
 fs/nilfs2/cpfile.c                   |   31 ++++++++++++++++++-------------
 fs/nilfs2/direct.c                   |   17 +++++++++--------
 fs/nilfs2/ioctl.c                    |    2 +-
 6 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 4949fca..839efd8 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -28,7 +28,7 @@ described in the man pages included in the package.
 Project web page:    http://www.nilfs.org/en/
 Download page:       http://www.nilfs.org/en/download.html
 Git tree web page:   http://www.nilfs.org/git/
-NILFS mailing lists: http://www.nilfs.org/mailman/listinfo/users
+List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
 =======
diff --git a/MAINTAINERS b/MAINTAINERS
index 66f5f7d..0121c61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3882,7 +3882,7 @@ F:	drivers/net/ni5010.*
 
 NILFS2 FILESYSTEM
 M:	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
-L:	users@nilfs.org
+L:	linux-nilfs@vger.kernel.org
 W:	http://www.nilfs.org/en/
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index f4a14ea..effdbdb 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -417,8 +417,8 @@ __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
 
 	key = page_index(bh->b_page) << (PAGE_CACHE_SHIFT -
 					 bmap->b_inode->i_blkbits);
-	for (pbh = page_buffers(bh->b_page); pbh != bh;
-	     pbh = pbh->b_this_page, key++);
+	for (pbh = page_buffers(bh->b_page); pbh != bh; pbh = pbh->b_this_page)
+		key++;
 
 	return key;
 }
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index d5ad54e..1873781 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -328,19 +328,24 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 			tnicps += nicps;
 			nilfs_mdt_mark_buffer_dirty(cp_bh);
 			nilfs_mdt_mark_dirty(cpfile);
-			if (!nilfs_cpfile_is_in_first(cpfile, cno) &&
-			    (count = nilfs_cpfile_block_sub_valid_checkpoints(
-				    cpfile, cp_bh, kaddr, nicps)) == 0) {
-				/* make hole */
-				kunmap_atomic(kaddr, KM_USER0);
-				brelse(cp_bh);
-				ret = nilfs_cpfile_delete_checkpoint_block(
-					cpfile, cno);
-				if (ret == 0)
-					continue;
-				printk(KERN_ERR "%s: cannot delete block\n",
-				       __func__);
-				break;
+			if (!nilfs_cpfile_is_in_first(cpfile, cno)) {
+				count =
+				  nilfs_cpfile_block_sub_valid_checkpoints(
+						cpfile, cp_bh, kaddr, nicps);
+				if (count == 0) {
+					/* make hole */
+					kunmap_atomic(kaddr, KM_USER0);
+					brelse(cp_bh);
+					ret =
+					  nilfs_cpfile_delete_checkpoint_block(
+								   cpfile, cno);
+					if (ret == 0)
+						continue;
+					printk(KERN_ERR
+					       "%s: cannot delete block\n",
+					       __func__);
+					break;
+				}
 			}
 		}
 
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index d369ac7..236753d 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -51,11 +51,11 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
 	struct nilfs_direct *direct;
 	__u64 ptr;
 
-	direct = (struct nilfs_direct *)bmap;
-	if ((key > NILFS_DIRECT_KEY_MAX) ||
-	    (level != 1) ||	/* XXX: use macro for level 1 */
-	    ((ptr = nilfs_direct_get_ptr(direct, key)) ==
-	     NILFS_BMAP_INVALID_PTR))
+	direct = (struct nilfs_direct *)bmap;  /* XXX: use macro for level 1 */
+	if (key > NILFS_DIRECT_KEY_MAX || level != 1)
+		return -ENOENT;
+	ptr = nilfs_direct_get_ptr(direct, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
 	if (ptrp != NULL)
@@ -73,9 +73,10 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *bmap,
 	sector_t blocknr;
 	int ret, cnt;
 
-	if (key > NILFS_DIRECT_KEY_MAX ||
-	    (ptr = nilfs_direct_get_ptr(direct, key)) ==
-	    NILFS_BMAP_INVALID_PTR)
+	if (key > NILFS_DIRECT_KEY_MAX)
+		return -ENOENT;
+	ptr = nilfs_direct_get_ptr(direct, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
 	if (NILFS_BMAP_USE_VBN(bmap)) {
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f6af760..d6b2b83 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -480,7 +480,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
 {
 	struct nilfs_argv argv[5];
-	const static size_t argsz[5] = {
+	static const size_t argsz[5] = {
 		sizeof(struct nilfs_vdesc),
 		sizeof(struct nilfs_period),
 		sizeof(__u64),
