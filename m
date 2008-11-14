Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYKNXB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYKNXB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKNXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:21 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52182 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224948.952135969@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 11/16] Tracepoint Use Unregister Return Value
Content-Disposition: inline; filename=tracepoint-use-unregister-return-value.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unregistering a tracepoint can fail. Return the error value.

Impact: bugfix.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/tracepoint.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h	2008-09-19 22:40:43.000000000 -0400
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-09-19 23:03:20.000000000 -0400
@@ -73,9 +73,9 @@ struct tracepoint {
 		return tracepoint_probe_register(#name ":" #proto,	\
 			(void *)probe);					\
 	}								\
-	static inline void unregister_trace_##name(void (*probe)(proto))\
+	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
-		tracepoint_probe_unregister(#name ":" #proto,		\
+		return tracepoint_probe_unregister(#name ":" #proto,	\
 			(void *)probe);					\
 	}
 
@@ -92,8 +92,10 @@ extern void tracepoint_update_probe_rang
 	{								\
 		return -ENOSYS;						\
 	}								\
-	static inline void unregister_trace_##name(void (*probe)(proto))\
-	{ }
+	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}
 
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
