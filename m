Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbXIRVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbXIRVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbXIRVoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:44:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58146 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXIRVoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:44:17 -0400
Message-Id: <20070918210735.808225635@polymtl.ca>
References: <20070918210601.028313546@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:06:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 04/11] Add INIT_ARRAY() to kernel.h
Content-Disposition: inline; filename=declare-array.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:44:13 +0000
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
--- linux-2.6-lttng.orig/include/linux/kernel.h	2007-09-18 10:09:15.000000000 -0400
+++ linux-2.6-lttng/include/linux/kernel.h	2007-09-18 13:12:34.000000000 -0400
@@ -400,4 +400,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#define INIT_ARRAY(type, val, len) ((type [len]){ [0 ... (len)-1] = (val) })
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
