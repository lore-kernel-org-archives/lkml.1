Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYGERyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYGERyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYGERip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:45 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33107 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756029AbYGERge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 19/52] ext4: Make ext4_ext_find_extent fills ext_path completely
Date: Sat,  5 Jul 2008 13:35:45 -0400
Message-Id: <1215279378-30504-20-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-19-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>

When pos=0 or depth, the fields of ext4_ext_path is are not
completely filled.  This patch also removes some unnecessary code.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc17ed7..3e966da 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		alloc = 1;
 	}
 	path[0].p_hdr = eh;
+	path[0].p_bh = NULL;
 
 	i = depth;
 	/* walk through the tree */
@@ -552,12 +553,14 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	}
 
 	path[ppos].p_depth = i;
-	path[ppos].p_hdr = eh;
 	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
+	/* if not an empty leaf */
+	if (path[ppos].p_ext)
+		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
 
 	ext4_ext_show_path(inode, path);
 
-- 
1.5.6.rc3.1.g36b7.dirty

