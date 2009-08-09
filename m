Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZHILKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZHILKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZHILKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:10:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:43803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZHILKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:10:16 -0400
Date: Sun, 9 Aug 2009 11:09:46 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249690585-9145-2-git-send-email-fweisbec@gmail.com>
References: <1249690585-9145-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: callchain: Fix spurious 'perf report' warnings: ignore empty callchains
Message-ID: <tip-b0efe213f84f7fd5ccfe07053e3d9fb827b7c188@git.kernel.org>
Git-Commit-ID: b0efe213f84f7fd5ccfe07053e3d9fb827b7c188
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0efe213f84f7fd5ccfe07053e3d9fb827b7c188
Gitweb:     http://git.kernel.org/tip/b0efe213f84f7fd5ccfe07053e3d9fb827b7c188
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 02:16:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:41 +0200

perf tools: callchain: Fix spurious 'perf report' warnings: ignore empty callchains

When the callchain tree comes to insert an empty backtrace, it
raises a spurious warning about the fact we are inserting an
empty. This is spurious because the radix tree assumes it did
something wrong to reach this state. But it didn't, we just met
an empty callchain that has to be ignored.

This happens occasionally with certain types of call-chain
recordings. If it happens it's a big nuisance as perf report
output starts with thousands of warning lines.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1249690585-9145-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 98c5627..a8e67aa 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -336,5 +336,7 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms)
 {
+	if (!chain->nr)
+		return;
 	__append_chain_children(root, chain, syms, 0);
 }
