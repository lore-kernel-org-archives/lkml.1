Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbXLBInw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbXLBInw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 03:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXLBInn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 03:43:43 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55279 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXLBInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 03:43:43 -0500
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add EXPORT_SYMBOL(ksize);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 2 Dec 2007 17:43:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---
 mm/slab.c |    1 +
 mm/slob.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6-mm.orig/mm/slab.c
+++ linux-2.6-mm/mm/slab.c
@@ -4479,3 +4479,4 @@ size_t ksize(const void *objp)
 
 	return obj_size(virt_to_cache(objp));
 }
+EXPORT_SYMBOL(ksize);
--- linux-2.6-mm.orig/mm/slob.c
+++ linux-2.6-mm/mm/slob.c
@@ -495,6 +495,7 @@ size_t ksize(const void *block)
 	else
 		return sp->page.private;
 }
+EXPORT_SYMBOL(ksize);
 
 struct kmem_cache {
 	unsigned int size, align;
