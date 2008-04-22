Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbYDVSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbYDVSWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYDVSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:22:04 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:49693 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbYDVSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:22:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAB/KDUhMROPA/2dsb2JhbACBUqth
Date: Tue, 22 Apr 2008 14:21:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Stringify support commas v2
Message-ID: <20080422182150.GA14658@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:20:10 up 53 days, 14:31,  5 users,  load average: 0.55, 0.36,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
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
