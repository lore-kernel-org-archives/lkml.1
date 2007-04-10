Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXDJXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXDJXYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDJXYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:24:34 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:40492 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXDJXYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:24:33 -0400
Date: Tue, 10 Apr 2007 19:24:32 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-non-opt-arch-alpha-arm26-doc-flags
Message-ID: <20070410232432.GF7092@Krystal>
References: <20070410231126.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410231126.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:22:48 up 67 days, 13:30,  6 users,  load average: 1.52, 1.52, 1.90
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add alpha marker.h, add arm26 marker.h,  use the new MF_* bitmask for
asm-generic/marker.h. Document asm-generic/marker.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- /dev/null
+++ b/include/asm-alpha/marker.h
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ * 
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
--- /dev/null
+++ b/include/asm-arm26/marker.h
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ * 
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
--- a/include/asm-generic/marker.h
+++ b/include/asm-generic/marker.h
@@ -13,11 +13,18 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
+/* Default flags, used by MARK() */
+#define MF_DEFAULT			(MF_LOCKDEP | MF_PRINTK)
 
+/* Fallback on the generic markers, since no optimized version is available */
 #define MARK_OPTIMIZED			MARK_GENERIC
 #define _MARK				MARK_GENERIC
-#define MARK(format, args...)		_MARK(_MF_DEFAULT, format, ## args)
+
+/* Marker with default behavior */
+#define MARK(format, args...)		_MARK(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
 
 #define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
 		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
