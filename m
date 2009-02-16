Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZBPPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZBPPHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZBPPFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:05:25 -0500
Received: from cmpxchg.org ([85.214.51.133]:49295 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZBPPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:05:23 -0500
Message-Id: <20090216144726.156785892@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:34 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Chas Williams <chas@cmf.nrl.navy.mil>
Subject: [patch 8/8] atm: use kzfree()
References: <20090216142926.440561506@cmpxchg.org>
Content-Disposition: inline; filename=atm-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
---
 net/atm/mpoa_caches.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/net/atm/mpoa_caches.c
+++ b/net/atm/mpoa_caches.c
@@ -167,11 +167,8 @@ static int cache_hit(in_cache_entry *ent
 
 static void in_cache_put(in_cache_entry *entry)
 {
-	if (atomic_dec_and_test(&entry->use)) {
-		memset(entry, 0, sizeof(in_cache_entry));
-		kfree(entry);
-	}
-
+	if (atomic_dec_and_test(&entry->use))
+		kzfree(entry);
 	return;
 }
 
@@ -403,11 +400,8 @@ static eg_cache_entry *eg_cache_get_by_s
 
 static void eg_cache_put(eg_cache_entry *entry)
 {
-	if (atomic_dec_and_test(&entry->use)) {
-		memset(entry, 0, sizeof(eg_cache_entry));
-		kfree(entry);
-	}
-
+	if (atomic_dec_and_test(&entry->use))
+		kzfree(entry);
 	return;
 }
 


