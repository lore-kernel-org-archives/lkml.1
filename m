Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZCEKbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZCEKbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZCEKah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:30:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZCEKag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:30:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bLfwXDZ45SHbKCdbS9Jv0V0a3Bu4em9eHAvY5/W78gG47l5lXkjowTyjbOjrw4HO4
	4PzFYCa+TdUYWejLj+jvQ==
Date: Thu, 5 Mar 2009 02:29:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/2] lockdep: initialize lockdep debugging statistics
In-Reply-To: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_DEBUG_LOCKDEP statistics need to be initialized with
ATOMIC_INIT(0) since they are of type atomic_t.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/lockdep.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -413,23 +413,23 @@ static struct stack_trace lockdep_init_trace = {
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
