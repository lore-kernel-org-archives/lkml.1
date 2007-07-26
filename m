Return-Path: <linux-kernel-owner+w=401wt.eu-S935941AbXGZSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935941AbXGZSCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935840AbXGZSB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:01:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48521 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbXGZSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:01:58 -0400
Subject: [PATCH] slub: add lock debugging check
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707261048220.2374@schroedinger.engr.sgi.com>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu> <1185441963.8197.67.camel@twins>
	 <1185442353.8197.71.camel@twins>
	 <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
	 <1185448275.8197.79.camel@twins>
	 <Pine.LNX.4.64.0707261048220.2374@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 20:01:38 +0200
Message-Id: <1185472898.15205.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo noticed that the SLUB code does include the lock debugging free
check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1656,6 +1656,7 @@ static void __always_inline slab_free(st
 	unsigned long flags;
 
 	local_irq_save(flags);
+	debug_check_no_locks_freed(object, s->objsize);
 	if (likely(page == s->cpu_slab[smp_processor_id()] &&
 						!SlabDebug(page))) {
 		object[page->offset] = page->lockless_freelist;


