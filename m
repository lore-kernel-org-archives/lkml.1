Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZFET71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZFET71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZFET7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:59:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38279 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753420AbZFET7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:59:07 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191852.015043974@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:28 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 09/11] X86 optimized this_cpu operations
Content-Disposition: inline; filename=this_cpu_x86_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically the existing percpu ops can be used. However, we do not pass a
reference to a percpu variable in. Instead an address of a percpu variable
is provided.

Both preempt, the non preempt and the irqsafe operations generate the same code.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-06-04 13:38:01.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-06-04 14:21:22.000000000 -0500
@@ -140,6 +140,28 @@ do {							\
 #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
 #define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
 
+#define __this_cpu_read(pcp)		percpu_from_op("mov", pcp)
+#define __this_cpu_write(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define __this_cpu_add(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_sub(pcp, val)	percpu_to_op("sub", (pcp), val)
+#define __this_cpu_and(pcp, val)	percpu_to_op("and", (pcp), val)
+#define __this_cpu_or(pcp, val)		percpu_to_op("or", (pcp), val)
+#define __this_cpu_xor(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#define this_cpu_read(pcp)		percpu_from_op("mov", (pcp))
+#define this_cpu_write(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define this_cpu_add(pcp, val)		percpu_to_op("add", (pcp), val)
+#define this_cpu_sub(pcp, val)		percpu_to_op("sub", (pcp), val)
+#define this_cpu_and(pcp, val)		percpu_to_op("and", (pcp), val)
+#define this_cpu_or(pcp, val)		percpu_to_op("or", (pcp), val)
+#define this_cpu_xor(pcp, val)		percpu_to_op("xor", (pcp), val)
+
+#define irqsafe_cpu_add(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_sub(pcp, val)	percpu_to_op("sub", (pcp), val)
+#define irqsafe_cpu_and(pcp, val)	percpu_to_op("and", (pcp), val)
+#define irqsafe_cpu_or(pcp, val)	percpu_to_op("or", (pcp), val)
+#define irqsafe_cpu_xor(pcp, val)	percpu_to_op("xor", (pcp), val)
+
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\
 ({									\

-- 
