Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYKNXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYKNXAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYKNXAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:18 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52172 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224948.632083242@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 09/16] Tracepoint fix disable
Content-Disposition: inline; filename=tracepoint-fix-disable.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the probe array pointer to NULL when the tracepoint is disabled.
The probe array point not being NULL could generate a race condition where the
reader would dereference a freed pointer.

Impact: bugfix.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/tracepoint.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux.trees.git/kernel/tracepoint.c
===================================================================
--- linux.trees.git.orig/kernel/tracepoint.c	2008-11-14 17:39:52.000000000 -0500
+++ linux.trees.git/kernel/tracepoint.c	2008-11-14 17:39:56.000000000 -0500
@@ -262,6 +262,7 @@ static void set_tracepoint(struct tracep
 static void disable_tracepoint(struct tracepoint *elem)
 {
 	elem->state = 0;
+	rcu_assign_pointer(elem->funcs, NULL);
 }
 
 /**

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
