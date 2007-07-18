Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbXGRQDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbXGRQDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbXGRQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:03:24 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:48575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbXGRQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:03:22 -0400
Subject: [RFC] fix slub krealloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 17:42:11 +0200
Message-Id: <1184773331.4002.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ef2ad80c7d255ed0449eda947c2d700635b7e0f5 breaks
krealloc(NULL, ...) badly, it BUG_ON()s.

This patch fixes it but the fix should probably be in mm/util.c because
the documentation says that krealloc(NULL, x, gfp) is equivalent to
kmalloc(x, gfp) and that's not true any more even after this patch when
you do krealloc(NULL, 0, gfp)

johannes

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/mm/slub.c	2007-07-18 16:25:11.809440194 +0200
+++ wireless-dev/mm/slub.c	2007-07-18 16:25:22.809440194 +0200
@@ -2394,7 +2394,7 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (object == ZERO_SIZE_PTR)
+	if (object == ZERO_SIZE_PTR || !object)
 		return 0;
 
 	page = get_object_page(object);


