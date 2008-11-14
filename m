Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYKNXA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYKNXA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYKNXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52170 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224949.113799966@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 12/16] Tracepoint do not put arguments in name
Content-Disposition: inline; filename=tracepoint-do-not-put-argument-list-in-name.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's overkill, takes space. We have a global tracepoint registery in header
files anyway.

Impact: cleanup.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/tracepoint.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2008-11-14 17:26:11.000000000 -0500
+++ linux.trees.git/include/linux/tracepoint.h	2008-11-14 17:26:11.000000000 -0500
@@ -60,7 +60,7 @@ struct tracepoint {
 	{								\
 		static const char __tpstrtab_##name[]			\
 		__attribute__((section("__tracepoints_strings")))	\
-		= #name ":" #proto;					\
+		= #name;						\
 		static struct tracepoint __tracepoint_##name		\
 		__attribute__((section("__tracepoints"), aligned(8))) =	\
 		{ __tpstrtab_##name, 0, NULL };				\
@@ -70,13 +70,11 @@ struct tracepoint {
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_register(#name ":" #proto,	\
-			(void *)probe);					\
+		return tracepoint_probe_register(#name, (void *)probe);	\
 	}								\
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_unregister(#name ":" #proto,	\
-			(void *)probe);					\
+		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
 extern void tracepoint_update_probe_range(struct tracepoint *begin,

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
