Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbXIYXqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbXIYXqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXIYXnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36412 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566AbXIYXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:53 -0400
Message-Id: <20070925234252.900513799@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:20 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [16/17] Allow virtual fallback for buffer_heads
Content-Disposition: inline; filename=vcompound_buffer_head
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is in particular useful for large I/Os because it will allow > 100
allocs from the SLUB fast path without having to go to the page allocator.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-09-18 15:44:37.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-09-18 15:44:51.000000000 -0700
@@ -3008,7 +3008,8 @@ void __init buffer_init(void)
 	int nrpages;
 
 	bh_cachep = KMEM_CACHE(buffer_head,
-			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|
+			SLAB_VFALLBACK);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL

-- 
