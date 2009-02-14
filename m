Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZBNOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZBNOq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 09:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZBNOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 09:46:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZBNOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 09:46:47 -0500
Subject: [PATCH 1.5/2] generic-smp: fix initial quiesent count.
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1234622474.4698.25.camel@laptop>
References: <20090212223200.979433820@chello.nl>
	 <20090212223750.295581470@chello.nl>  <1234622474.4698.25.camel@laptop>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 15:46:32 +0100
Message-Id: <1234622792.4698.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first compile, then send out...

---
Subject: generic-smp: fix initial quiesent count.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Feb 14 15:36:07 CET 2009

If we start with a quiesent sequence count of 0, we'll match the initial stamp
values of the cfd_data, and never make any progress.

To avoid getting stuck in this situation, start out with an increased quiesent
sequence count.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -27,6 +27,7 @@ static struct {
 } call_function __cacheline_aligned_in_smp = {
 	.queue = LIST_HEAD_INIT(call_function.queue),
 	.lock  = __SPIN_LOCK_UNLOCKED(call_function.lock),
+	.quiesent = 1,
 };
 
 enum {


