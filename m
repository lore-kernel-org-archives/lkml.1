Return-Path: <linux-kernel-owner+w=401wt.eu-S935052AbYBBUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052AbYBBUmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934932AbYBBUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:42:07 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41236 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934525AbYBBUmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:42:04 -0500
Message-Id: <20080202204023.356380064@polymtl.ca>
References: <20080202203722.628843686@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:37:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, hch@infradead.org,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 3/3] Kprobes - declare kprobe_mutex static
Content-Disposition: inline; filename=kprobes-declare-kprobes-mutex-static.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:40:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it will not be used by other kernel objects, it makes sense to declare it
static.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: hch@infradead.org
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-08-19 09:09:15.000000000 -0400
+++ linux-2.6-lttng/kernel/kprobes.c	2007-08-19 17:18:07.000000000 -0400
@@ -68,7 +68,7 @@ static struct hlist_head kretprobe_inst_
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobe_enabled;
 
-DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
+static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
