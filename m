Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXLFCFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXLFCFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXLFCFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:05:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37891 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLFCFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:05:04 -0500
Message-Id: <20071206020440.081972291@polymtl.ca>
References: <20071206020246.417605824@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:02:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 04/11] Add INIT_ARRAY() to kernel.h
Content-Disposition: inline; filename=declare-array.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:04:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
--- linux-2.6-lttng.orig/include/linux/kernel.h	2007-11-13 09:25:29.000000000 -0500
+++ linux-2.6-lttng/include/linux/kernel.h	2007-11-13 09:45:38.000000000 -0500
@@ -421,4 +421,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#define INIT_ARRAY(type, val, len) ((type [len]) { [0 ... (len)-1] = (val) })
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
