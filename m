Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYJCTBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYJCTBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYJCTBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:01:35 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:54148 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbYJCTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:01:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAC4D5khMQWq+/2dsb2JhbACBcbsvgWg
Date: Fri, 3 Oct 2008 15:01:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Tracepoints synchronize unregister static inline
Message-ID: <20081003190133.GA12685@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:59:39 up 120 days, 23:40,  9 users,  load average: 0.22, 0.27,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, could you pull the following patch into -tip ?

Thanks,

Mathieu

Turn tracepoint synchronize unregister into a static inline. There is no reason
to keep it as a macro over a static inline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/tracepoint.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h	2008-10-03 14:50:53.000000000 -0400
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-10-03 14:51:44.000000000 -0400
@@ -153,6 +153,9 @@ extern int tracepoint_get_iter_range(str
  * probe unregistration and the end of module exit to make sure there is no
  * caller executing a probe when it is freed.
  */
-#define tracepoint_synchronize_unregister() synchronize_sched()
+static inline void tracepoint_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
 
 #endif
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
