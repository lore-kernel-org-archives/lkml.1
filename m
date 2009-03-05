Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZCEKtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZCEKtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZCEKtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:49:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:45245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZCEKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:49:05 -0500
Date: Thu, 5 Mar 2009 10:48:32 GMT
From: David Rientjes <rientjes@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
Subject: [tip:core/locking] lockdep: initialize lockdep debugging statistics
Message-ID: <tip-742bbc4022d117bccf9c8a86c8e500dfa97e2f70@git.kernel.org>
Git-Commit-ID: 742bbc4022d117bccf9c8a86c8e500dfa97e2f70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 10:48:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  742bbc4022d117bccf9c8a86c8e500dfa97e2f70
Gitweb:     http://git.kernel.org/tip/742bbc4022d117bccf9c8a86c8e500dfa97e2f70
Author:     "David Rientjes" <rientjes@google.com>
AuthorDate: Thu, 5 Mar 2009 02:29:06 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 11:46:00 +0100

lockdep: initialize lockdep debugging statistics

Impact: cleanup

The CONFIG_DEBUG_LOCKDEP statistics need to be initialized with
ATOMIC_INIT(0) since they are of type atomic_t.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 9a1e2bc..3f7ff12 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -416,23 +416,23 @@ static struct stack_trace lockdep_init_trace = {
 /*
  * Various lockdep statistics:
  */
-atomic_t chain_lookup_hits;
-atomic_t chain_lookup_misses;
-atomic_t hardirqs_on_events;
-atomic_t hardirqs_off_events;
-atomic_t redundant_hardirqs_on;
-atomic_t redundant_hardirqs_off;
-atomic_t softirqs_on_events;
-atomic_t softirqs_off_events;
-atomic_t redundant_softirqs_on;
-atomic_t redundant_softirqs_off;
-atomic_t nr_unused_locks;
-atomic_t nr_cyclic_checks;
-atomic_t nr_cyclic_check_recursions;
-atomic_t nr_find_usage_forwards_checks;
-atomic_t nr_find_usage_forwards_recursions;
-atomic_t nr_find_usage_backwards_checks;
-atomic_t nr_find_usage_backwards_recursions;
+atomic_t chain_lookup_hits = ATOMIC_INIT(0);
+atomic_t chain_lookup_misses = ATOMIC_INIT(0);
+atomic_t hardirqs_on_events = ATOMIC_INIT(0);
+atomic_t hardirqs_off_events = ATOMIC_INIT(0);
+atomic_t redundant_hardirqs_on = ATOMIC_INIT(0);
+atomic_t redundant_hardirqs_off = ATOMIC_INIT(0);
+atomic_t softirqs_on_events = ATOMIC_INIT(0);
+atomic_t softirqs_off_events = ATOMIC_INIT(0);
+atomic_t redundant_softirqs_on = ATOMIC_INIT(0);
+atomic_t redundant_softirqs_off = ATOMIC_INIT(0);
+atomic_t nr_unused_locks = ATOMIC_INIT(0);
+atomic_t nr_cyclic_checks = ATOMIC_INIT(0);
+atomic_t nr_cyclic_check_recursions = ATOMIC_INIT(0);
+atomic_t nr_find_usage_forwards_checks = ATOMIC_INIT(0);
+atomic_t nr_find_usage_forwards_recursions = ATOMIC_INIT(0);
+atomic_t nr_find_usage_backwards_checks = ATOMIC_INIT(0);
+atomic_t nr_find_usage_backwards_recursions = ATOMIC_INIT(0);
 #endif
 
 /*
