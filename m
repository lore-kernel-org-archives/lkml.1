Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbZJFOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbZJFOmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbZJFOmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:42:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38714 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbZJFOmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:42:02 -0400
Message-Id: <20091006144040.716440112@polymtl.ca>
References: <20091006143727.868480435@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 10:37:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/4] markers call_rcu usage: initialize rcu_head structures
Content-Disposition: inline; filename=marker-fix-rcu.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  6 Oct 2009 14:40:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu_head structures before passing them to call_rcu() to eliminate
false positives in DEBUG_RCU_HEAD.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: akpm@linux-foundation.org
---
 kernel/marker.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2009-10-06 09:16:32.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2009-10-06 09:22:07.000000000 -0400
@@ -451,6 +451,7 @@ static struct marker_entry *add_marker(c
 	e->format_allocated = 0;
 	e->refcount = 0;
 	e->rcu_pending = 0;
+	INIT_RCU_HEAD(&e->rcu);
 	hlist_add_head(&e->hlist, head);
 	return e;
 }

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
