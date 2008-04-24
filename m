Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbYDXPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbYDXPVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYDXPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56082 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648AbYDXPOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:46 -0400
Message-Id: <20080424151352.270935465@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 01/37] Stringify support commas
Content-Disposition: inline; filename=stringify-support-commas.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#define MYDEF a, b, c

__stringify(MYDEF) should be replaced by "a, b, c", but compilation fails
because the __stringify macro expects only one argument. Fix it by using
variable macro arguments in __stringify and __stringify_1.

Needed in my current NMI safe iret paravirt support work so I can expand
a macro containing assembly code into a string.

Since some architectures still use -traditional, which does not support macros
with variable arguments, keep the old stringify around. Test with __STDC__ to
see if -traditional is used.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
CC: Sam Ravnborg <sam@ravnborg.org>
---
 include/linux/stringify.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-lttng/include/linux/stringify.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/stringify.h	2008-04-22 14:16:21.000000000 -0400
+++ linux-2.6-lttng/include/linux/stringify.h	2008-04-22 14:19:26.000000000 -0400
@@ -6,7 +6,12 @@
  * converts to "bar".
  */
 
+#ifdef __STDC__
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
+#else	/* Support gcc -traditional, without commas. */
 #define __stringify_1(x)	#x
 #define __stringify(x)		__stringify_1(x)
+#endif
 
 #endif	/* !__LINUX_STRINGIFY_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
