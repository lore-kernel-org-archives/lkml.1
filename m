Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXIQTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXIQTVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXIQTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:21:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57419 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbXIQTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:21:34 -0400
Message-Id: <20070917184209.189393785@polymtl.ca>
References: <20070917184031.211525416@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 14:40:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 04/11] Add INIT_ARRAY() to kernel.h
Content-Disposition: inline; filename=declare-array.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 17 Sep 2007 19:21:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add initialization of an array, which needs brackets that would pollute kernel
code, to kernel.h. It is used to declare arguments passed as function parameters
such as:
text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kernel.h	2007-09-11 15:37:44.000000000 -0400
+++ linux-2.6-lttng/include/linux/kernel.h	2007-09-11 16:02:24.000000000 -0400
@@ -387,4 +387,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#define INIT_ARRAY(type, val, len) ((type [len]){ [0 ... (len)-1] = (val) })
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
