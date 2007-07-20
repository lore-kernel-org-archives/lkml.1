Return-Path: <linux-kernel-owner+w=401wt.eu-S935815AbXGTPSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935815AbXGTPSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935585AbXGTPSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:18:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38152 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935569AbXGTPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:18:07 -0400
Date: Fri, 20 Jul 2007 16:18:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: [PATCH] fix gfp_t annotations for slub
Message-ID: <20070720151806.GJ21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Since we have use like ~SLUB_DMA, we ought to have the type
set right in both cases.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 07f7e4c..124270d 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -160,7 +160,7 @@ static inline struct kmem_cache *kmalloc_slab(size_t size)
 #define SLUB_DMA __GFP_DMA
 #else
 /* Disable DMA functionality */
-#define SLUB_DMA 0
+#define SLUB_DMA (__force gfp_t)0
 #endif
 
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);

