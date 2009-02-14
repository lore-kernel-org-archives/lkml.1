Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZBNOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZBNOrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 09:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBNOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 09:47:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZBNOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 09:47:05 -0500
Subject: [PATCH 2.5/2] generic-smp: remove cfd rcu_head
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090212223750.384627915@chello.nl>
References: <20090212223200.979433820@chello.nl>
	 <20090212223750.384627915@chello.nl>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 15:46:47 +0100
Message-Id: <1234622807.4698.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: generic-smp: remove cfd rcu_head
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Feb 14 15:41:24 CET 2009

Since we no longer use call_rcu() on call_function_data, we can remove the
rcu_head structure from it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -39,10 +39,7 @@ struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	union {
-		struct rcu_head rcu_head;
-		unsigned int stamp;
-	};
+	unsigned int stamp;
 	struct cpumask cpumask;
 };
 


