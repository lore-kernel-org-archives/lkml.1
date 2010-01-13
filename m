Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138Ab0AMNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab0AMNBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292Ab0AMNBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:01:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0AMNBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:01:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
Date: Wed, 13 Jan 2010 11:01:11 -0200
Message-Id: <1263387673-15231-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Similar to list_for_each_entry, helps reducing boilerplate in many
places and makes rbtrees closer to list.h macros.

First conversion will be in the tools/perf.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/rbtree.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 9c29541..044b150 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -158,4 +158,16 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+/**
+ * rb_for_each_entry - iterate over rbtree of given type
+ * @pos:	the type * to hold the current entry being traversed
+ * @node:	the rb_node to hold the current entry being traversed
+ * @root:	the root for your tree.
+ * @member:	the name of the rb_node within the struct.
+ */
+#define rb_for_each_entry(pos, node, root, member)			\
+	for (node = rb_first(root);					\
+	     node && (pos = rb_entry(node, typeof(*pos), member));	\
+	     node = rb_next(node))
+
 #endif	/* _LINUX_RBTREE_H */
-- 
1.6.2.5

