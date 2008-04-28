Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbYD1Dv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbYD1Dv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763669AbYD1Duw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:50:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57916 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762445AbYD1Duv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:50:51 -0400
Message-Id: <20080428035006.819701531@polymtl.ca>
References: <20080428033415.303000651@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 27 Apr 2008 23:34:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/2] Markers - use imv_cond jump liveliness
Content-Disposition: inline; filename=markers-use-imv-jump-liveliness.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 28 Apr 2008 03:50:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the imv_cond_ed() macros to mark the end of ZF and eax liveliness for
imv_cond.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/marker.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-sched-devel/include/linux/marker.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/marker.h	2008-04-25 13:46:14.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/marker.h	2008-04-25 13:47:11.000000000 -0400
@@ -76,10 +76,13 @@ struct marker {
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
 		if (!generic) {						\
-			if (unlikely(imv_cond(__mark_##name.state)))	\
+			if (unlikely(imv_cond(__mark_##name.state))) {	\
+				imv_cond_end();				\
 				(*__mark_##name.call)			\
 					(&__mark_##name, call_private,	\
 					## args);			\
+			} else						\
+				imv_cond_end();				\
 		} else {						\
 			if (unlikely(_imv_read(__mark_##name.state)))	\
 				(*__mark_##name.call)			\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
