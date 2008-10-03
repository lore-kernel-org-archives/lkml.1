Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYJCPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYJCPxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYJCPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:52:57 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:46901 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047AbYJCPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:52:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAGPa5UhMQWq+/2dsb2JhbACBcbpBgWg
Date: Fri, 3 Oct 2008 11:52:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Markers synchronize unregister static inline
Message-ID: <20081003155254.GB1607@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150513.GC11245@Krystal> <20081002235650.43ca075c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081002235650.43ca075c.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:51:11 up 120 days, 20:31,  8 users,  load average: 0.14, 0.42,
	0.84
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn marker synchronize unregister into a static inline. There is no reason to
keep it as a macro over a static inline.

Ingo, can you pull this into -tip on top of the previous "Markers
synchronize unregister" patch ?

Thanks,

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/marker.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-10-03 11:31:21.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-10-03 11:34:37.000000000 -0400
@@ -14,6 +14,7 @@
 
 #include <linux/immediate.h>
 #include <linux/types.h>
+#include <linux/rcupdate.h>
 
 struct module;
 struct task_struct;
@@ -218,7 +219,10 @@ extern void *marker_get_private_data(con
  * unregistration and the end of module exit to make sure there is no caller
  * executing a probe when it is freed.
  */
-#define marker_synchronize_unregister() synchronize_sched()
+static inline void marker_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
 
 struct marker_iter {
 	struct module *module;
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
