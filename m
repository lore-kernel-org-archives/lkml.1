Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZC3SZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZC3SZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZC3SQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:16:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZC3SPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:19 -0400
Message-Id: <20090330181009.831291133@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 05/35 error-handling] reiserfs: make some warnings informational
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-reiserfs_info.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In several places, reiserfs_warning is used when there is no warning, just
 a notice. This patch changes some of them to indicate that the message
 is merely informational.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 fs/reiserfs/bitmap.c |    6 +++---
 fs/reiserfs/super.c  |   14 ++++++--------
 fs/reiserfs/xattr.c  |   10 ++++------
 3 files changed, 13 insertions(+), 17 deletions(-)

--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -40,8 +40,8 @@
 
 #define SET_OPTION(optname) \
    do { \
-        reiserfs_warning(s, "reiserfs: option \"%s\" is set", #optname); \
-        set_bit(_ALLOC_ ## optname , &SB_ALLOC_OPTS(s)); \
+	reiserfs_info(s, "block allocator option \"%s\" is set", #optname); \
+	set_bit(_ALLOC_ ## optname , &SB_ALLOC_OPTS(s)); \
     } while(0)
 #define TEST_OPTION(optname, s) \
     test_bit(_ALLOC_ ## optname , &SB_ALLOC_OPTS(s))
@@ -636,7 +636,7 @@ int reiserfs_parse_alloc_options(struct
 		return 1;
 	}
 
-	reiserfs_warning(s, "allocator options = [%08x]\n", SB_ALLOC_OPTS(s));
+	reiserfs_info(s, "allocator options = [%08x]\n", SB_ALLOC_OPTS(s));
 	return 0;
 }
 
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1380,13 +1380,11 @@ static int read_super_block(struct super
 		/* magic is of non-standard journal filesystem, look at s_version to
 		   find which format is in use */
 		if (sb_version(rs) == REISERFS_VERSION_2)
-			reiserfs_warning(s,
-					 "read_super_block: found reiserfs format \"3.6\""
-					 " with non-standard journal");
+			reiserfs_info(s, "found reiserfs format \"3.6\""
+				      " with non-standard journal\n");
 		else if (sb_version(rs) == REISERFS_VERSION_1)
-			reiserfs_warning(s,
-					 "read_super_block: found reiserfs format \"3.5\""
-					 " with non-standard journal");
+			reiserfs_info(s, "found reiserfs format \"3.5\""
+				      " with non-standard journal\n");
 		else {
 			reiserfs_warning(s,
 					 "sh-2012: read_super_block: found unknown "
@@ -1465,8 +1463,8 @@ static __u32 find_hash_out(struct super_
 			if (reiserfs_rupasov_hash(s)) {
 				hash = YURA_HASH;
 			}
-			reiserfs_warning(s, "FS seems to be empty, autodetect "
-					 "is using the default hash");
+			reiserfs_info(s, "FS seems to be empty, autodetect "
+					 "is using the default hash\n");
 			break;
 		}
 		r5hash = GET_HASH_VALUE(r5_hash(de.de_name, de.de_namelen));
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -1182,12 +1182,10 @@ int reiserfs_xattr_init(struct super_blo
 				}
 
 				if (dentry && dentry->d_inode)
-					reiserfs_warning(s,
-							 "Created %s on %s - reserved for "
-							 "xattr storage.",
-							 PRIVROOT_NAME,
-							 reiserfs_bdevname
-							 (inode->i_sb));
+					reiserfs_info(s, "Created %s - "
+						      "reserved for xattr "
+						      "storage.\n",
+						      PRIVROOT_NAME);
 			} else if (!dentry->d_inode) {
 				dput(dentry);
 				dentry = NULL;


