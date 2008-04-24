Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYDXPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYDXPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbYDXPOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56052 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbYDXPOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:42 -0400
Message-Id: <20080424151406.160144705@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 31/37] Markers use imv jump
Content-Disposition: inline; filename=markers-use-imv-jump.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let markers use the heavily optimized imv_cond() version of immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-04-16 00:16:52.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-04-16 00:17:12.000000000 -0400
@@ -76,7 +76,7 @@ struct marker {
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
 		if (!generic) {						\
-			if (unlikely(imv_read(__mark_##name.state)))	\
+			if (unlikely(imv_cond(__mark_##name.state)))	\
 				(*__mark_##name.call)			\
 					(&__mark_##name, call_private,	\
 					## args);			\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
