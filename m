Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbXE2SjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbXE2SjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXE2Sh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:37:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43733 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXE2ShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:37:24 -0400
Message-Id: <20070529183709.943985314@polymtl.ca>
References: <20070529183356.192838687@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:34:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 7/9] Conditional Calls - Documentation
Content-Disposition: inline; filename=conditional-calls-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/condcall.txt |   60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

Index: linux-2.6-lttng/Documentation/condcall.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/condcall.txt	2007-05-17 01:55:05.000000000 -0400
@@ -0,0 +1,60 @@
+		        Using the Conditional Calls
+
+			    Mathieu Desnoyers
+
+
+This document introduces Conditional Calls and their use.
+
+* Purpose of conditional calls
+
+A conditional call is used to compile into the kernel a function call that is
+disabled at compile-time. Then, at runtime, it can be enabled dynamically. As
+explained below, the opposite can also be done.
+
+
+* Usage
+
+In order to use the macro cond_call, you should include linux/condcall.h.
+
+#include <linux/condcall.h>
+
+Add, in your code :
+
+ret = cond_call(examplecondcall, myfunc(a, b));
+
+Where :
+- examplecondcall is the conditional call identifier
+- myfunc(a, b) is a call to myfunc with valid parameters.
+- "ret" is, optionally, the variable in which the return value of myfunc() must
+  be put. If the conditional call is disabled, ret will be set to 0 casted to
+  the type of the return value of myfunc().
+
+Use cond_call_arm("examplecondcall") to activate the conditional call.
+
+Use cond_call_disarm("examplecondcall") to deactivate the conditional call.
+
+Use cond_call_query("examplecondcall") to query the conditional call state.
+
+The cond_call mechanism supports inserting multiple instances of the same
+cond_call. Conditional calls can be put in inline functions, inlined static
+functions, and unrolled loops.
+
+
+* Optimization for a given architecture
+
+One can implement optimized conditional calls for a given architecture by
+replacing asm-$ARCH/condcall.h.
+
+The CF_* flags can be used to control the type of conditional call. See the
+include/linux/condcall.h header for the list of flags. They can be specified as
+the first parameter of the _cond_call() macro, as in the following example,
+which declares a cond_call enabled statically (which can be disabled/reenabled
+dynamically)
+
+ret = _cond_call(CF_DEFAULT | CF_STATIC_ENABLE, examplecondcall, myfunc(a, b));
+
+Another example of flag usage is to declare a cond_call that always uses the
+generic version of the cond_calls. It can be useful to use this when cond_calls
+are placed in kernel code presenting particular reentrancy challenges.
+
+ret = _cond_call(CF_DEFAULT & ~CF_OPTIMIZED, examplecondcall, myfunc(a, b));

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
