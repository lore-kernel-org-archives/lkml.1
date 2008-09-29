Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYI2PKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYI2PKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYI2PKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:10:37 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:33953 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751483AbYI2PKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:10:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL+L4EhMQWq+/2dsb2JhbACBYrowgWc
Date: Mon, 29 Sep 2008 11:10:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Markers : documentation fix teardown
Message-ID: <20080929151034.GG11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:09:49 up 116 days, 19:50,  9 users,  load average: 0.30, 0.56,
	0.48
User-Agent: Mutt/1.5.16 (2007-06-11)
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
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
