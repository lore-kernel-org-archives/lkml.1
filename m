Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938Ab0ADWiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0ADWiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978Ab0ADWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:16 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46093 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0ADWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:04 -0500
Message-Id: <20100104223554.505463348@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:40 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 1/7] Remove cpu_local_xx macros
Content-Disposition: inline; filename=percpu_local_t_remove_cpu_alloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros have not been used for awhile now.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/alpha/include/asm/local.h   |   17 -----------------
 arch/m32r/include/asm/local.h    |   25 -------------------------
 arch/mips/include/asm/local.h    |   25 -------------------------
 arch/powerpc/include/asm/local.h |   25 -------------------------
 arch/x86/include/asm/local.h     |   37 -------------------------------------
 include/asm-generic/local.h      |   19 -------------------
 6 files changed, 148 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/arch/alpha/include/asm/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -98,21 +98,4 @@ static __inline__ long local_sub_return(
 #define __local_add(i,l)	((l)->a.counter+=(i))
 #define __local_sub(i,l)	((l)->a.counter-=(i))
 
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
 #endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/arch/m32r/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/arch/m32r/include/asm/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -338,29 +338,4 @@ static inline void local_set_mask(unsign
  * a variable, not an address.
  */
 
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non local way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* __M32R_LOCAL_H */
Index: linux-2.6/arch/mips/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/arch/mips/include/asm/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -193,29 +193,4 @@ static __inline__ long local_sub_return(
 #define __local_add(i, l)	((l)->a.counter+=(i))
 #define __local_sub(i, l)	((l)->a.counter-=(i))
 
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ARCH_MIPS_LOCAL_H */
Index: linux-2.6/arch/powerpc/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/arch/powerpc/include/asm/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -172,29 +172,4 @@ static __inline__ long local_dec_if_posi
 #define __local_add(i,l)	((l)->a.counter+=(i))
 #define __local_sub(i,l)	((l)->a.counter-=(i))
 
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/arch/x86/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -195,41 +195,4 @@ static inline long local_sub_return(long
 #define __local_add(i, l)	local_add((i), (l))
 #define __local_sub(i, l)	local_sub((i), (l))
 
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- *
- * X86_64: This could be done better if we moved the per cpu data directly
- * after GS.
- */
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)		\
-({					\
-	local_t res__;			\
-	preempt_disable(); 		\
-	res__ = (l);			\
-	preempt_enable();		\
-	res__;				\
-})
-#define cpu_local_wrap(l)		\
-({					\
-	preempt_disable();		\
-	(l);				\
-	preempt_enable();		\
-})					\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var((l))))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var((l)), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var((l))))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var((l))))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var((l))))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var((l))))
-
-#define __cpu_local_inc(l)	cpu_local_inc((l))
-#define __cpu_local_dec(l)	cpu_local_dec((l))
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
 #endif /* _ASM_X86_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2009-12-16 13:50:11.000000000 -0600
+++ linux-2.6/include/asm-generic/local.h	2009-12-18 14:19:17.000000000 -0600
@@ -52,23 +52,4 @@ typedef struct
 #define __local_add(i,l)	local_set((l), local_read(l) + (i))
 #define __local_sub(i,l)	local_set((l), local_read(l) - (i))
 
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable (eg. mystruct.foo), not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-/* Non-atomic increments, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well.
- */
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
 #endif /* _ASM_GENERIC_LOCAL_H */

-- 
