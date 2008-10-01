Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYJAQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYJAQMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJAQMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:12:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38238 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYJAQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:12:23 -0400
Message-Id: <20081001160425.419297059@polymtl.ca>
References: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 4/5] Markers : documentation fix teardown
Content-Disposition: inline; filename=markers-documentation-probe-teardown.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the need for a marker_synchronize_unregister() before the end of exit()
to make sure every probe callers have exited the non preemptible section and
thus are not executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: akpm@linux-foundation.org
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 Documentation/markers.txt |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/markers.txt	2008-07-31 09:11:13.000000000 -0400
+++ linux-2.6-lttng/Documentation/markers.txt	2008-07-31 09:20:57.000000000 -0400
@@ -50,10 +50,12 @@ Connecting a function (probe) to a marke
 to call) for the specific marker through marker_probe_register() and can be
 activated by calling marker_arm(). Marker deactivation can be done by calling
 marker_disarm() as many times as marker_arm() has been called. Removing a probe
-is done through marker_probe_unregister(); it will disarm the probe and make
-sure there is no caller left using the probe when it returns. Probe removal is
-preempt-safe because preemption is disabled around the probe call. See the
-"Probe example" section below for a sample probe module.
+is done through marker_probe_unregister(); it will disarm the probe.
+marker_synchronize_unregister() must be called before the end of the module exit
+function to make sure there is no caller left using the probe. This, and the
+fact that preemption is disabled around the probe call, make sure that probe
+removal and module unload are safe. See the "Probe example" section below for a
+sample probe module.
 
 The marker mechanism supports inserting multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions, and

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
