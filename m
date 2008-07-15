Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYGONEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYGONEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGOND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:03:58 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58552 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbYGOND4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:03:56 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2008 17:43:52 +0300
Message-Id: <20080715144352.22301.80749.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS file system
X-OriginalArrivalTime: 15 Jul 2008 13:03:25.0375 (UTC) FILETIME=[2AD0C4F0:01C8E67B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull UBIFS from 'for_linus' branch of

git://git.infradead.org/~dedekind/ubifs-2.6.git for_linus

UBIFS has been in -mm tree for about 3 months and in -next tree for about 2
month. There were 3 LKML submission rounds:

http://marc.info/?l=linux-kernel&m=121180458401234&w=2

Please, refer the following URLs for UBIFS introduction (sorted in
brief->longer order):

1. First UBIFS submission:
	http://marc.info/?l=linux-kernel&m=120662475821992&w=2
2. Jonathan Corbet's article:
	http://lwn.net/Articles/276025/
3. Documentation and FAQ at the MTD web site:
	http://www.linux-mtd.infradead.org/doc/ubi.html
	http://www.linux-mtd.infradead.org/faq/ubi.html
4. UBIFS white-paper:
	http://www.linux-mtd.infradead.org/doc/ubifs_whitepaper.pdf

For the last 2 months we've been stabilizing UBIFS and its on-flash format
and we think it is production-ready and may be merged. We are going to
keep developing and maintain it.

We use UBIFS in Nokia and we also have several community users, e.g.:
http://lists.infradead.org/pipermail/linux-mtd/2008-May/021801.html

We have positive feed-backs, e.g.:
http://marc.info/?l=linux-kernel&m=120850960619411&w=2

There git-web for the branch we ask to pull is here:
http://git.infradead.org/users/dedekind/ubifs-2.6.git?a=shortlog;h=refs/heads/for_linus

$ git-shortlog v2.6.26..HEAD

Adrian Hunter (1):
      do_mounts: allow UBI root device name

Artem Bityutskiy (5):
      VFS: export sync_sb_inodes
      MAINTAINERS: add UBIFS section
      UBIFS: add brief documentation
      UBIFS: add new flash file system
      UBIFS: include to compilation

Hans Reiser (1):
      VFS: move inode_lock into sync_sb_inodes

$ git-log --stat -M v2.6.26..HEAD

commit 0d7eff873caaeac84de01a1acdca983d2c7ba3fe
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Mon Jul 14 19:08:38 2008 +0300

    UBIFS: include to compilation
    
    Add UBIFS to Makefile and Kbuild.
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
    Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

 fs/Kconfig        |    3 ++
 fs/Makefile       |    1 +
 fs/ubifs/Kconfig  |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/Makefile |    9 ++++++
 4 files changed, 85 insertions(+), 0 deletions(-)

commit 1e51764a3c2ac05a23a22b2a95ddee4d9bffb16d
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Mon Jul 14 19:08:37 2008 +0300

    UBIFS: add new flash file system
    
    This is a new flash file system. See
    http://www.linux-mtd.infradead.org/doc/ubifs.html
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
    Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

 fs/ubifs/budget.c      |  731 ++++++++++++
 fs/ubifs/commit.c      |  677 +++++++++++
 fs/ubifs/compress.c    |  253 +++++
 fs/ubifs/debug.c       | 2289 +++++++++++++++++++++++++++++++++++++
 fs/ubifs/debug.h       |  403 +++++++
 fs/ubifs/dir.c         | 1240 ++++++++++++++++++++
 fs/ubifs/file.c        | 1275 +++++++++++++++++++++
 fs/ubifs/find.c        |  975 ++++++++++++++++
 fs/ubifs/gc.c          |  773 +++++++++++++
 fs/ubifs/io.c          |  914 +++++++++++++++
 fs/ubifs/ioctl.c       |  204 ++++
 fs/ubifs/journal.c     | 1387 +++++++++++++++++++++++
 fs/ubifs/key.h         |  533 +++++++++
 fs/ubifs/log.c         |  805 +++++++++++++
 fs/ubifs/lprops.c      | 1357 ++++++++++++++++++++++
 fs/ubifs/lpt.c         | 2243 ++++++++++++++++++++++++++++++++++++
 fs/ubifs/lpt_commit.c  | 1648 +++++++++++++++++++++++++++
 fs/ubifs/master.c      |  387 +++++++
 fs/ubifs/misc.h        |  342 ++++++
 fs/ubifs/orphan.c      |  958 ++++++++++++++++
 fs/ubifs/recovery.c    | 1519 +++++++++++++++++++++++++
 fs/ubifs/replay.c      | 1075 ++++++++++++++++++
 fs/ubifs/sb.c          |  629 ++++++++++
 fs/ubifs/scan.c        |  362 ++++++
 fs/ubifs/shrinker.c    |  322 ++++++
 fs/ubifs/super.c       | 1951 ++++++++++++++++++++++++++++++++
 fs/ubifs/tnc.c         | 2956 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/tnc_commit.c  | 1103 ++++++++++++++++++
 fs/ubifs/tnc_misc.c    |  494 ++++++++
 fs/ubifs/ubifs-media.h |  745 ++++++++++++
 fs/ubifs/ubifs.h       | 1649 +++++++++++++++++++++++++++
 fs/ubifs/xattr.c       |  581 ++++++++++
 32 files changed, 32780 insertions(+), 0 deletions(-)

commit e56a99d5a42dcb91e622ae7a0289d8fb2ddabffb
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Mon Jul 14 19:08:34 2008 +0300

    UBIFS: add brief documentation
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
    Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

 Documentation/filesystems/ubifs.txt |  164 +++++++++++++++++++++++++++++++++++
 1 files changed, 164 insertions(+), 0 deletions(-)

commit 9527056630b68c94b94b94cd58c6cbb65e611fd1
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Mon Jul 14 17:58:44 2008 +0300

    MAINTAINERS: add UBIFS section
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

commit 2d62f488585405bc9108c47cb06957397cfd1059
Author: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date:   Thu Jan 31 17:25:00 2008 +0200

    do_mounts: allow UBI root device name
    
    Similarly to MTD devices, allow UBI devices.
    
    Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

 init/do_mounts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

commit 4ee6afd34409d296782a5b667d7991b1050e910a
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Wed May 7 21:01:30 2008 +0300

    VFS: export sync_sb_inodes
    
    This patch exports the 'sync_sb_inodes()' which is needed for
    UBIFS because it has to force write-back from time to time.
    Namely, the UBIFS budgeting subsystem forces write-back when
    its pessimistic callculations show that there is no free
    space on the media.
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

 fs/fs-writeback.c  |   11 +++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

commit ae8547b0a9e5d718ce272ddc48f91703a0f52a0b
Author: Hans Reiser <reiser@namesys.com>
Date:   Wed May 7 15:48:57 2008 +0300

    VFS: move inode_lock into sync_sb_inodes
    
    This patch makes 'sync_sb_inodes()' lock 'inode_lock', rather
    than expect that the caller will do this.
    
    This change was previously done by Hans Reiser <reiser@namesys.com>
    and sat in the -mm tree.
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

 fs/fs-writeback.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

======================================================================

The non-UBIFS patches are short and rather trivial, so we inline them. The UBIFS
patches are big, so we only provide stats.


>From 9527056630b68c94b94b94cd58c6cbb65e611fd1 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Mon, 14 Jul 2008 17:58:44 +0300
Subject: [PATCH] MAINTAINERS: add UBIFS section

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56a2f67..3882f9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2307,6 +2307,16 @@ L:       linux-mtd@lists.infradead.org
 W:     http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:     Maintained

+UBI FILE SYSTEM (UBIFS)
+P:     Artem Bityutskiy
+M:     dedekind@infradead.org
+P:     Adrian Hunter
+M:     ext-adrian.hunter@nokia.com
+L:     linux-mtd@lists.infradead.org
+T:     git git://git.infradead.org/~dedekind/ubifs-2.6.git
+W:     http://www.linux-mtd.infradead.org/doc/ubifs.html
+S:     Maintained
+
 JFS FILESYSTEM
 P:     Dave Kleikamp
 M:     shaggy@austin.ibm.com
--
1.5.4.1

>From 2d62f488585405bc9108c47cb06957397cfd1059 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Thu, 31 Jan 2008 17:25:00 +0200
Subject: [PATCH] do_mounts: allow UBI root device name

Similarly to MTD devices, allow UBI devices.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 init/do_mounts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 660c1e5..a1de1bf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -372,7 +372,8 @@ void __init prepare_namespace(void)

        if (saved_root_name[0]) {
                root_device_name = saved_root_name;
-               if (!strncmp(root_device_name, "mtd", 3)) {
+               if (!strncmp(root_device_name, "mtd", 3) ||
+                   !strncmp(root_device_name, "ubi", 3)) {
                        mount_block_root(root_device_name, root_mountflags);
                        goto out;
                }
--
1.5.4.1

>From 4ee6afd34409d296782a5b667d7991b1050e910a Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 7 May 2008 21:01:30 +0300
Subject: [PATCH] VFS: export sync_sb_inodes

This patch exports the 'sync_sb_inodes()' which is needed for
UBIFS because it has to force write-back from time to time.
Namely, the UBIFS budgeting subsystem forces write-back when
its pessimistic callculations show that there is no free
space on the media.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c  |   11 +++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 16519fe..25adfc3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -439,8 +439,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
@@ -526,6 +526,13 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
+EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
+
+static void sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
+{
+	generic_sync_sb_inodes(sb, wbc);
+}
 
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8e2762..f9d2aab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1729,6 +1729,8 @@ static inline void invalidate_remote_inode(struct inode *inode)
 extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
+extern void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
-- 
1.5.4.1

>From ae8547b0a9e5d718ce272ddc48f91703a0f52a0b Mon Sep 17 00:00:00 2001
From: Hans Reiser <reiser@namesys.com>
Date: Wed, 7 May 2008 15:48:57 +0300
Subject: [PATCH] VFS: move inode_lock into sync_sb_inodes

This patch makes 'sync_sb_inodes()' lock 'inode_lock', rather
than expect that the caller will do this.

This change was previously done by Hans Reiser <reiser@namesys.com>
and sat in the -mm tree.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ae45f77..16519fe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -424,8 +424,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -446,6 +444,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
+	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
@@ -524,6 +523,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
+	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
@@ -565,11 +565,8 @@ restart:
 			 * be unmounted by the time it is released.
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root) {
-					spin_lock(&inode_lock);
+				if (sb->s_root)
 					sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
-				}
 				up_read(&sb->s_umount);
 			}
 			spin_lock(&sb_lock);
@@ -607,9 +604,7 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
 	sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
 }
 
 /*
-- 
1.5.4.1
