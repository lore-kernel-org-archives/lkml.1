Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYJAQMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYJAQMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYJAQMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:12:23 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38227 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYJAQMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:12:22 -0400
Message-Id: <20081001160425.105054982@polymtl.ca>
References: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 2/5] Markers : marker_synchronize_unregister()
Content-Disposition: inline; filename=markers-synchronize_marker_unregister.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create marker_synchronize_unregister() which must be called before the end of
exit() to make sure every probe callers have exited the non preemptible section
and thus are not executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: akpm@linux-foundation.org
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 include/linux/marker.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-07-31 09:12:52.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-07-31 09:19:31.000000000 -0400
@@ -142,4 +142,11 @@ extern int marker_probe_unregister_priva
 extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
 	int num);
 
+/*
+ * marker_synchronize_unregister must be called between the last marker probe
+ * unregistration and the end of module exit to make sure there is no caller
+ * executing a probe when it is freed.
+ */
+#define marker_synchronize_unregister() synchronize_sched()
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
