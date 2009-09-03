Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZICFgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZICFgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZICFfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZICFfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 4/5] kmemleak: fix sparse warning over overshadowed flags
Date: Thu,  3 Sep 2009 01:35:39 -0400
Message-Id: <1251956140-5499-5-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes this sparse warning:
mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
mm/kmemleak.c:448:23: originally declared here

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 58c07b1..24e7a84 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -509,14 +509,14 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	 * random memory blocks.
 	 */
 	if (node != &object->tree_node) {
-		unsigned long flags;
+		unsigned long flags_object;
 
 		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
 			      "(already existing)\n", ptr);
 		object = lookup_object(ptr, 1);
-		spin_lock_irqsave(&object->lock, flags);
+		spin_lock_irqsave(&object->lock, flags_object);
 		dump_object_info(object);
-		spin_unlock_irqrestore(&object->lock, flags);
+		spin_unlock_irqrestore(&object->lock, flags_object);
 
 		goto out;
 	}
-- 
1.6.3.3

