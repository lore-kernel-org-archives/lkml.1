Return-Path: <linux-kernel-owner+w=401wt.eu-S1764513AbZFQGmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764513AbZFQGmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFQGmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:42:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48690 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZFQGmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:42:36 -0400
Date: Wed, 17 Jun 2009 09:42:38 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: [PATCH] s390: remove DEBUG_MALLOC
Message-ID: <Pine.LNX.4.64.0906170941340.29445@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The kernel now has kmemleak and kmemtrace so there's no reason to keep
this ugly s390 hack around. I am not sure how it's supposed to work on
SMP anyway as it uses a global variable to temporarily store the return 
value of all kmalloc() calls:

  void *b;

  #define kmalloc(x...) (PRINT_INFO(" kmalloc %p\n",b=kmalloc(x)),b)

Cc: <linux-s390@vger.kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/s390/include/asm/debug.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index 9450ce6..31ed568 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -248,14 +248,5 @@ int debug_unregister_view(debug_info_t* id, struct debug_view* view);
 #define PRINT_FATAL(x...) printk ( KERN_DEBUG PRINTK_HEADER x )
 #endif				/* DASD_DEBUG */
 
-#undef DEBUG_MALLOC
-#ifdef DEBUG_MALLOC
-void *b;
-#define kmalloc(x...) (PRINT_INFO(" kmalloc %p\n",b=kmalloc(x)),b)
-#define kfree(x) PRINT_INFO(" kfree %p\n",x);kfree(x)
-#define get_zeroed_page(x...) (PRINT_INFO(" gfp %p\n",b=get_zeroed_page(x)),b)
-#define __get_free_pages(x...) (PRINT_INFO(" gfps %p\n",b=__get_free_pages(x)),b)
-#endif				/* DEBUG_MALLOC */
-
 #endif				/* __KERNEL__ */
 #endif				/* DEBUG_H */
-- 
1.5.6.3

