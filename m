Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbZDQBCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbZDQBCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbZDQBCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:02:07 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44314 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759176AbZDQBCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:02:06 -0400
Message-Id: <20090417003932.020200762@polymtl.ca>
References: <20090417003755.276959950@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 20:37:58 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [patch 3/3] tracepoints : remove rcupdate.h dependency
Content-Disposition: inline; filename=tracepoints-remove-rcu-header-dependency.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 17 Apr 2009 01:01:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the slimmer rcupdate_types.h instead of the fat rcupdate.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>
---
 include/linux/tracepoint.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2009-04-16 20:32:27.000000000 -0400
+++ linux.trees.git/include/linux/tracepoint.h	2009-04-16 20:36:16.000000000 -0400
@@ -15,7 +15,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_types.h>
 
 struct module;
 struct tracepoint;
@@ -150,11 +150,11 @@ extern int tracepoint_get_iter_range(str
  * tracepoint_synchronize_unregister must be called between the last tracepoint
  * probe unregistration and the end of module exit to make sure there is no
  * caller executing a probe when it is freed.
+ * Using a define rather than a static inline to make sure tracepoint.h does not
+ * depend on rcupdate.h. rcupdate.h must be included whenever
+ * tracepoint_synchronize_unregister() is used.
  */
-static inline void tracepoint_synchronize_unregister(void)
-{
-	synchronize_sched();
-}
+#define tracepoint_synchronize_unregister() synchronize_sched()
 
 #define PARAMS(args...) args
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
