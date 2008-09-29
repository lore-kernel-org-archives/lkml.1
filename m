Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYI2PKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYI2PKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYI2PKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:10:15 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:48066 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYI2PKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:10:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL+L4EhMQWq+/2dsb2JhbACBYrowgWc
Date: Mon, 29 Sep 2008 11:05:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH] Markers : marker_synchronize_unregister()
Message-ID: <20080929150513.GC11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:04:08 up 116 days, 19:44,  9 users,  load average: 0.34, 0.36,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create marker_synchronize_unregister() which must be called before the end of
exit() to make sure every probe callers have exited the non preemptible section
and thus are not executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: akpm@linux-foundation.org
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 include/linux/marker.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-07-31 09:12:52.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-07-31 09:19:31.000000000 -0400
@@ -142,4 +142,11 @@ extern int marker_probe_unregister_priva
 extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
 	int num);
 
+/*
+ * marker_synchronize_unregister must be called between the last marker probe
+ * unregistration and the end of module exit to make sure there is no caller
+ * executing a probe when it is freed.
+ */
+#define marker_synchronize_unregister() synchronize_sched()
+
 #endif
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
