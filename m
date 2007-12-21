Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbXLUB7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbXLUB7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXLUB6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:58:16 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35518 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbXLUB6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:58:14 -0500
Message-Id: <20071221015727.347457170@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 15/24] Add text_poke and sync_core to powerpc
Content-Disposition: inline; filename=add-text-poke-to-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Needed on architectures where we must surround live instruction modification
  with "WP flag disable".
- Turns into a memcpy on powerpc since there is no WP flag activated for
  instruction pages (yet..).
- Add empty sync_core to powerpc so it can be used in architecture independent
  code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>
CC: Paul Mackerras <paulus@samba.org>
---
 include/asm-powerpc/cacheflush.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-powerpc/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/cacheflush.h	2007-11-19 12:05:50.000000000 -0500
+++ linux-2.6-lttng/include/asm-powerpc/cacheflush.h	2007-11-19 13:27:36.000000000 -0500
@@ -63,7 +63,9 @@ extern void flush_dcache_phys_range(unsi
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-
+#define text_poke	memcpy
+#define text_poke_early	text_poke
+#define sync_core()
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /* internal debugging function */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
