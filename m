Return-Path: <linux-kernel-owner+w=401wt.eu-S1761165AbYDXPZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165AbYDXPZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYDXPPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:15:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56500 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760034AbYDXPPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:15:40 -0400
Message-Id: <20080424151359.033491101@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org
Subject: [patch 16/37] Add text_poke and sync_core to powerpc
Content-Disposition: inline; filename=add-text-poke-and-sync-core-to-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:59 +0000
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
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
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
