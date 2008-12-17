Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752700AbYLQTed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYLQTed (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYLQTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:34:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:46521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYLQTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:34:16 -0500
Date: Wed, 17 Dec 2008 11:34:14 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Joel Becker <joel.becker@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] Ocfs2 fixes
Message-ID: <20081217193414.GD8791@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/ocfs2_fs.h |    8 +++++++-
 fs/ocfs2/xattr.c    |    4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

Joel Becker (1):
      ocfs2: Add JBD2 compat feature bit.

Tao Ma (1):
      ocfs2: Always update xattr search when creating bucket.

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 5f180cf..5e0c0d0 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -86,7 +86,8 @@
 #define OCFS2_CLEAR_INCOMPAT_FEATURE(sb,mask)			\
 	OCFS2_SB(sb)->s_feature_incompat &= ~(mask)
 
-#define OCFS2_FEATURE_COMPAT_SUPP	OCFS2_FEATURE_COMPAT_BACKUP_SB
+#define OCFS2_FEATURE_COMPAT_SUPP	(OCFS2_FEATURE_COMPAT_BACKUP_SB	\
+					 | OCFS2_FEATURE_COMPAT_JBD2_SB)
 #define OCFS2_FEATURE_INCOMPAT_SUPP	(OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT \
 					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
 					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
@@ -153,6 +154,11 @@
 #define OCFS2_FEATURE_COMPAT_BACKUP_SB		0x0001
 
 /*
+ * The filesystem will correctly handle journal feature bits.
+ */
+#define OCFS2_FEATURE_COMPAT_JBD2_SB		0x0002
+
+/*
  * Unwritten extents support.
  */
 #define OCFS2_FEATURE_RO_COMPAT_UNWRITTEN	0x0001
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 054e2ef..74d7367 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2645,9 +2645,9 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 				return ret;
 			}
 
-			i = xs->here - old_xh->xh_entries;
-			xs->here = &xs->header->xh_entries[i];
 		}
+		i = xs->here - old_xh->xh_entries;
+		xs->here = &xs->header->xh_entries[i];
 	}
 
 	return ret;
