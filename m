Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYGCTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYGCTLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYGCTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:11:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:45070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYGCTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=E8daScu7SFFiyX4JAY9+VjZhY63436dbmBTx1lUS0ITuxpYrKD9W4+lQ3W7ET4s4vN
         Tb90D1u7ZeMGQoomsETsRxgVz+QqwWPYkbEoYXBpBUC69joAS5yffRynK/z9Af4DGQ1W
         W+fnF27szCyoxohE+/JzHSZQKGMkqOf6MfF/w=
Date: Fri, 4 Jul 2008 00:40:32 +0530
From: Rabin Vincent <rabin@rab.in>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] slab: rename slab_destroy_objs
Message-ID: <20080703191032.GA24878@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of destructors, slab_destroy_objs no longer actually
destroys any objects, making the kernel doc incorrect and the function
name misleading.

In keeping with the other debug functions, rename it to
slab_destroy_debugcheck and drop the kernel doc.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 mm/slab.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 046607f..b4aa4c8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1901,15 +1901,7 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
 #endif
 
 #if DEBUG
-/**
- * slab_destroy_objs - destroy a slab and its objects
- * @cachep: cache pointer being destroyed
- * @slabp: slab pointer being destroyed
- *
- * Call the registered destructor for each object in a slab that is being
- * destroyed.
- */
-static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
+static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slabp)
 {
 	int i;
 	for (i = 0; i < cachep->num; i++) {
@@ -1938,7 +1930,7 @@ static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
 	}
 }
 #else
-static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
+static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slabp)
 {
 }
 #endif
@@ -1956,7 +1948,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 {
 	void *addr = slabp->s_mem - slabp->colouroff;
 
-	slab_destroy_objs(cachep, slabp);
+	slab_destroy_debugcheck(cachep, slabp);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slab_rcu *slab_rcu;
 
-- 
1.5.6

