Return-Path: <linux-kernel-owner+w=401wt.eu-S1764594AbXGNTwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764594AbXGNTwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXGNTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:52:44 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:37437 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760876AbXGNTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:52:43 -0400
Date: Sat, 14 Jul 2007 15:52:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [PATCH] Kprobes - Declare kprobe_mutex static
Message-ID: <20070714195241.GN6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714104914.GB7358@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:51:44 up 7 days,  9:56,  2 users,  load average: 0.32, 0.26, 0.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes - Declare kprobe_mutex static

Since it will not be used by other kernel objects, it makes sense to declare it
static.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-14 15:49:17.000000000 -0400
+++ linux-2.6-lttng/kernel/kprobes.c	2007-07-14 15:49:27.000000000 -0400
@@ -69,7 +69,7 @@ static atomic_t kprobe_count;
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
