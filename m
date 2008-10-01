Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYJAQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYJAQNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYJAQM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:12:26 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38245 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbYJAQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:12:25 -0400
Message-Id: <20081001160425.263709609@polymtl.ca>
References: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 3/5] Markers : probe example fix teardown
Content-Disposition: inline; filename=markers-probe-example-fix-teardown.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a marker_synchronize_unregister() before the end of exit() to make sure
every probe callers have exited the non preemptible section and thus are not
executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: akpm@linux-foundation.org
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 samples/markers/probe-example.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/probe-example.c	2008-07-31 09:11:13.000000000 -0400
+++ linux-2.6-lttng/samples/markers/probe-example.c	2008-07-31 09:18:54.000000000 -0400
@@ -81,6 +81,7 @@ static void __exit probe_fini(void)
 			probe_array[i].probe_func, &probe_array[i]);
 	printk(KERN_INFO "Number of event b : %u\n",
 			atomic_read(&eventb_count));
+	marker_synchronize_unregister();
 }
 
 module_init(probe_init);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
