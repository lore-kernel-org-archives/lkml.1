Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZFDIvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZFDIvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZFDItW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19384 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbZFDItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:15 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 01/17] VFS: introduce helpers for manipulation s_dirty flag
Date: Thu,  4 Jun 2009 13:41:38 +0300
Message-Id: <1244112114-23144-2-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:35.0486 (UTC) FILETIME=[3F2BDBE0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
'mark_sb_clean()', and 'sb_is_dirty()'. The helpers simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these helpers instead of manipulating
'sb->s_dirt' directly. And the further plan is to stop the
periodic write-back when there is no dirt.

This patch is just a preparation. No functional changes yet.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73242c3..2d67017 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1782,6 +1782,23 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
+/*
+ * Note, VFS does not provide any protection for the super block clean/dirty
+ * state. File-systems should take care of this.
+ */
+static inline void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void mark_sb_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int sb_is_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.6.0.6

