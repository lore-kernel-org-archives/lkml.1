Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZCMNC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZCMNC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZCMNBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:01:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:53978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbZCMNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:01:32 -0400
Date: Fri, 13 Mar 2009 13:00:57 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.288765724@chello.nl>
References: <20090313112301.288765724@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: use list_move_tail()
Message-ID: <tip-0bc8915410d0819ffb7e6c724df683896e208b46@git.kernel.org>
Git-Commit-ID: 0bc8915410d0819ffb7e6c724df683896e208b46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:00:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bc8915410d0819ffb7e6c724df683896e208b46
Gitweb:     http://git.kernel.org/tip/0bc8915410d0819ffb7e6c724df683896e208b46
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:29 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:59:08 +0100

perf_counter: use list_move_tail()

Instead of del/add use a move list-op.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.288765724@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b2e8389..0fe22c9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -89,8 +89,7 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	list_for_each_entry_safe(sibling, tmp,
 				 &counter->sibling_list, list_entry) {
 
-		list_del_init(&sibling->list_entry);
-		list_add_tail(&sibling->list_entry, &ctx->counter_list);
+		list_move_tail(&sibling->list_entry, &ctx->counter_list);
 		sibling->group_leader = sibling;
 	}
 }
@@ -959,8 +958,7 @@ static void rotate_ctx(struct perf_counter_context *ctx)
 	 */
 	perf_flags = hw_perf_save_disable();
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		list_del(&counter->list_entry);
-		list_add_tail(&counter->list_entry, &ctx->counter_list);
+		list_move_tail(&counter->list_entry, &ctx->counter_list);
 		break;
 	}
 	hw_perf_restore(perf_flags);
