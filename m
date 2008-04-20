Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYDTSdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYDTSdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYDTSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:32:59 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:42610 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbYDTSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:32:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAJcnC0hMROPA/2dsb2JhbACBUKc+
Date: Sun, 20 Apr 2008 14:32:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Stringify support commas
Message-ID: <20080420183256.GA11350@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:29:51 up 51 days, 14:40,  3 users,  load average: 0.43, 0.36,
	0.31
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
