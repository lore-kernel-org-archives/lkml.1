Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZLBIVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZLBIVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZLBIVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:21:47 -0500
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:63891 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZLBIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:21:47 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, catalin.marinas@arm.com,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH 1/2] slab, kmemleak, minor, stop calling kmemleak_erase() unconditionally
Date: Wed,  2 Dec 2009 16:55:49 +0900
Message-Id: <1259740550-10394-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the gotten object is NULL (probably due to ENOMEM),
kmemleak_erase() is unnecessary here, It just sets NULL to where already
is NULL.
Add a condition.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 mm/slab.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..4e61449 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3109,7 +3109,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
 	 * treat the array pointers as a reference to the object.
 	 */
-	kmemleak_erase(&ac->entry[ac->avail]);
+	if (objp)
+		kmemleak_erase(&ac->entry[ac->avail]);
 	return objp;
 }
 
-- 
1.6.1.284.g5dc13

