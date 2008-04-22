Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbYDVRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbYDVRbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763254AbYDVR3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53782 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763103AbYDVR3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:07 -0400
Message-Id: <20080422172843.602304016@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org
Subject: [RFC patch 9/9] Stringify support commas
Content-Disposition: inline; filename=stringify-support-commas.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#define MYDEF a, b, c

__stringify(MYDEF) should be replaced by "a, b, c", but compilation fails
because the __stringify macro expects only one argument. Fix it by using
variable macro arguments in __stringify and __stringify_1.

Needed in my current NMI safe iret paravirt support work so I can expand
a macro containing assembly code into a string.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
---
 include/linux/stringify.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/linux/stringify.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/stringify.h	2008-04-20 14:25:12.000000000 -0400
+++ linux-2.6-lttng/include/linux/stringify.h	2008-04-20 14:25:33.000000000 -0400
@@ -6,7 +6,7 @@
  * converts to "bar".
  */
 
-#define __stringify_1(x)	#x
-#define __stringify(x)		__stringify_1(x)
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
 
 #endif	/* !__LINUX_STRINGIFY_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
