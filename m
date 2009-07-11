Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZGKWAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZGKWAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZGKWAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:00:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:40789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZGKWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TwpkbiVqZ8pgRMCOHoW/BeVhPHZ0I3Yk7BusXy3Mn5MlBCq+4V8lzE/zwLozE/du0+
         dVCSX7b+GsA0/SqtbClM2CIqok62ZOUDETfPp1Q6ybVXhPGglIVr/2zsTZnG+WR/G4bG
         pPXxIdYW6vQLqKXesCSUmgGAWHqYI+bHGCvKI=
Date: Sun, 12 Jul 2009 02:00:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [rfc -tip] lib,rb-tree - introduce rb_for_each helper
Message-ID: <20090711220009.GA16028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perftools already use a number of opencoded
for() iterators over rbtree. The patch introduce
rb_for_each helper for this purpose.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

The real conversion for this macro usage should be
done later.

Also I think having rb_for_each_entry for being used
with container_of inbetween could be convinient as
well.

Anyway if we don't need such a helper -- just drop
the patch.

 include/linux/rbtree.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.git/include/linux/rbtree.h
=====================================================================
--- linux-2.6.git.orig/include/linux/rbtree.h
+++ linux-2.6.git/include/linux/rbtree.h
@@ -145,6 +145,9 @@ extern struct rb_node *rb_prev(const str
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
 
+#define rb_for_each(nd, root) \
+	for (nd = rb_first((root)); nd; nd = rb_next(nd))
+
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
 extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
 			    struct rb_root *root);
