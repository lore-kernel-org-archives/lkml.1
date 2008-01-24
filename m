Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYAXUei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYAXUei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYAXUdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:33:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58074 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbYAXUdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:33:52 -0500
Message-Id: <20080124203335.082459062@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 07/26] Add INIT_ARRAY() to kernel.h
Content-Disposition: inline; filename=declare-array.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:36 +0000
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

Index: linux-2.6-lttng.mm/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/linux/kernel.h	2008-01-24 14:10:54.000000000 -0500
+++ linux-2.6-lttng.mm/include/linux/kernel.h	2008-01-24 14:23:06.000000000 -0500
@@ -423,4 +423,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#define INIT_ARRAY(type, val, len) ((type [len]) { [0 ... (len)-1] = (val) })
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
