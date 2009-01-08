Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZAHPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZAHPis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZAHPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:38:40 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40215 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZAHPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:38:39 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Thu, 08 Jan 2009 19:38:07 +0200
Message-Id: <20090108173807.2387.93418.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/2] JFFS2: remove junk prototypes
X-OriginalArrivalTime: 08 Jan 2009 15:38:31.0802 (UTC) FILETIME=[28FE95A0:01C971A7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] JFFS2: remove junk prototypes

'rb_prev()', 'rb_next()' and 'rb_replace_node()' are declared in
include/linux/rbtree.h, no need for JFFS2 to re-declare them. I
believe these are left-overs from the old days when the common
RB tree code did not have those call and JFFS2 had private
implementation.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/jffs2/nodelist.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/nodelist.h b/fs/jffs2/nodelist.h
index 1750445..507ed6e 100644
--- a/fs/jffs2/nodelist.h
+++ b/fs/jffs2/nodelist.h
@@ -366,9 +366,6 @@ void jffs2_free_ino_caches(struct jffs2_sb_info *c);
 void jffs2_free_raw_node_refs(struct jffs2_sb_info *c);
 struct jffs2_node_frag *jffs2_lookup_node_frag(struct rb_root *fragtree, uint32_t offset);
 void jffs2_kill_fragtree(struct rb_root *root, struct jffs2_sb_info *c_delete);
-struct rb_node *rb_next(struct rb_node *);
-struct rb_node *rb_prev(struct rb_node *);
-void rb_replace_node(struct rb_node *victim, struct rb_node *new, struct rb_root *root);
 int jffs2_add_full_dnode_to_inode(struct jffs2_sb_info *c, struct jffs2_inode_info *f, struct jffs2_full_dnode *fn);
 uint32_t jffs2_truncate_fragtree (struct jffs2_sb_info *c, struct rb_root *list, uint32_t size);
 struct jffs2_raw_node_ref *jffs2_link_node_ref(struct jffs2_sb_info *c,
-- 
1.6.0.6

