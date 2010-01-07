Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515Ab0AGWgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0AGWgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396Ab0AGWgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:36:42 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46493 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0AGWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:36:37 -0500
Message-Id: <20100107223548.809596875@quilx.com>
References: <20100107223524.760517016@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jan 2010 16:35:27 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V2 3/3] Eliminate local_cmpxchg
Content-Disposition: inline; filename=remove_cmpxchg_local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmpxchg_local is the same as local_cmpxchg.
Keep cmpxchg_local and change the 3 occurrences of local_cmpxchg to cmpxchg_local.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/alpha/include/asm/local.h   |    3 ---
 arch/m32r/include/asm/local.h    |    2 --
 arch/mips/include/asm/local.h    |    3 ---
 arch/powerpc/include/asm/local.h |    3 ---
 arch/x86/include/asm/local.h     |    3 ---
 include/asm-generic/local.h      |    2 --
 kernel/trace/ring_buffer.c       |    6 +++---
 7 files changed, 3 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/local.h	2010-01-07 15:27:50.000000000 -0600
+++ linux-2.6/arch/alpha/include/asm/local.h	2010-01-07 15:27:56.000000000 -0600
@@ -25,7 +25,4 @@ static __inline__ long local_add_return(
 #define local_add(i,l)	local_add_return((i),(l))
 #define local_sub(i,l)	local_add_return(-(i),(l))
 
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local((l), (o), (n)))
-
 #endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/arch/m32r/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/local.h	2010-01-07 15:27:33.000000000 -0600
+++ linux-2.6/arch/m32r/include/asm/local.h	2010-01-07 15:27:39.000000000 -0600
@@ -80,8 +80,6 @@ static inline long local_add_return(long
  */
 #define local_dec(l) ((void)local_add_return(-1, (l))
 
-#define local_cmpxchg(l, o, n) (cmpxchg_local((l), (o), (n)))
-
 static inline void local_clear_mask(unsigned long  mask, local_t *addr)
 {
 	unsigned long flags;
Index: linux-2.6/arch/mips/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/local.h	2010-01-07 15:27:21.000000000 -0600
+++ linux-2.6/arch/mips/include/asm/local.h	2010-01-07 15:27:27.000000000 -0600
@@ -57,7 +57,4 @@ static __inline__ long local_add_return(
 #define local_inc(l)	local_add_return(-1, (l))
 #define local_dec(l)	local_add_return(-1, (l))
 
-#define local_cmpxchg(l, o, n) \
-	((long)cmpxchg_local((l), (o), (n)))
-
 #endif /* _ARCH_MIPS_LOCAL_H */
Index: linux-2.6/arch/powerpc/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/local.h	2010-01-07 15:27:00.000000000 -0600
+++ linux-2.6/arch/powerpc/include/asm/local.h	2010-01-07 15:27:04.000000000 -0600
@@ -26,7 +26,4 @@ static __inline__ long local_add_return(
 #define local_inc(l)	local_add_return(-1, (l))
 #define local_dec(l)	local_add_return(-1, (l))
 
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local((l), (o), (n)))
-
 #endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/arch/x86/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/local.h	2010-01-07 15:26:36.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/local.h	2010-01-07 15:26:45.000000000 -0600
@@ -65,7 +65,4 @@ no_xadd: /* Legacy 386 processor */
 #endif
 }
 
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local((l), (o), (n)))
-
 #endif /* _ASM_X86_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2010-01-07 15:28:09.000000000 -0600
+++ linux-2.6/include/asm-generic/local.h	2010-01-07 15:28:39.000000000 -0600
@@ -53,6 +53,4 @@ static inline unsigned long __add_return
 #define local_add(i,l)	local_add_return((i), (l))
 #define local_sub(i,l)	local_add_return(-(i), (l))
 
-#define local_cmpxchg(l, o, n) cmpxchg_local((l), (o), (n))
-
 #endif /* _ASM_GENERIC_LOCAL_i */
Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c	2010-01-07 15:25:38.000000000 -0600
+++ linux-2.6/kernel/trace/ring_buffer.c	2010-01-07 15:26:14.000000000 -0600
@@ -853,8 +853,8 @@ static int rb_tail_page_update(struct ri
 		 * cmpxchg to only update if an interrupt did not already
 		 * do it for us. If the cmpxchg fails, we don't care.
 		 */
-		(void)local_cmpxchg(&next_page->write, old_write, val);
-		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
+		(void)cmpxchg_local(&next_page->write, old_write, val);
+		(void)cmpxchg_local(&next_page->entries, old_entries, eval);
 
 		/*
 		 * No need to worry about races with clearing out the commit.
@@ -1952,7 +1952,7 @@ rb_try_to_discard(struct ring_buffer_per
 		 */
 		old_index += write_mask;
 		new_index += write_mask;
-		index = local_cmpxchg(&bpage->write, old_index, new_index);
+		index = cmpxchg_local(&bpage->write, old_index, new_index);
 		if (index == old_index)
 			return 1;
 	}

-- 
