Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbZE0LMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbZE0LMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbZE0LL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:11:59 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49375 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbZE0LL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:11:57 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:11 +0300
Message-Id: <20090527130511.4913.59300.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/19] VFS: introduce helpers for manipulation s_dirty flag
X-OriginalArrivalTime: 27 May 2009 11:11:10.0291 (UTC) FILETIME=[D6ED8230:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] VFS: introduce helpers for manipulation s_dirty flag

This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
'mark_sb_clean()', and 'sb_is_dirty()'. The helpers simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these helpers instead of manipulating
'sb->s_dirt' directly. And the further plan is to stop the
periodic write-back when there is no dirt.

This patch is just a preparation. No functional changes yet.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 include/linux/fs.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73242c3..437939c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1782,6 +1782,19 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
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

