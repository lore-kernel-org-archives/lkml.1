Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYEGAkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYEGAkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYEGAkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:40:37 -0400
Received: from ozlabs.org ([203.10.76.45]:45641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYEGAkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:40:36 -0400
To: <clameter@sgi.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 07 May 2008 10:38:55 +1000
Subject: [PATCH] slub: Fix atomic usage in any_slab_objects()
Message-Id: <20080507004035.58041DDE03@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any_slab_objects() does an atomic_read on an atomic_long_t, this
fixes it to use atomic_long_read instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-work.orig/mm/slub.c	2008-05-07 10:37:04.000000000 +1000
+++ linux-work/mm/slub.c	2008-05-07 10:37:05.000000000 +1000
@@ -3762,7 +3762,7 @@ static int any_slab_objects(struct kmem_
 		if (!n)
 			continue;
 
-		if (atomic_read(&n->total_objects))
+		if (atomic_long_read(&n->total_objects))
 			return 1;
 	}
 	return 0;
