Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZLSA17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZLSA17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZLSA1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:27:01 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40057 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZLSAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:25:59 -0500
Message-Id: <20091218222654.130833708@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:29 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 12/16] Add percpu cmpxchg operations
Content-Disposition: inline; filename=percpu_add_cmpxchg_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are needed for the ringbuffer logic.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-12-18 15:00:53.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-12-18 15:06:09.000000000 -0600
@@ -201,6 +201,9 @@ do {							\
 #define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define __this_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
+#define __this_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
+#define __this_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -226,6 +229,9 @@ do {							\
 #define this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define this_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define this_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 
 #define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
@@ -245,6 +251,9 @@ do {							\
 #define irqsafe_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define irqsafe_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define irqsafe_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
@@ -259,6 +268,7 @@ do {							\
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define __this_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -268,6 +278,7 @@ do {							\
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 
 #define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_inc_8(pcp)		percpu_var_op("inc", (pcp))
@@ -275,6 +286,7 @@ do {							\
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 
 #endif
 

-- 
