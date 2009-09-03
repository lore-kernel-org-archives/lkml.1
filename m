Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZICBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZICBld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZICBlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:41:11 -0400
Received: from mail.atheros.com ([12.36.123.2]:53916 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZICBlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:41:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] kmemleak: fix sparse warning over overshadowed flags
Date: Wed, 2 Sep 2009 18:40:58 -0700
Message-ID: <1251942059-21448-5-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 7bb1d48..09ddf9c 100644
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

