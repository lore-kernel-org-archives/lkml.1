Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbZHHLxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbZHHLxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZHHLxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:53:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZHHLxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:53:01 -0400
Date: Sat, 8 Aug 2009 11:51:36 GMT
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
Message-ID: <tip-d6bda845b99fbdfa2f88ac9f82d757297783b5d5@git.kernel.org>
Git-Commit-ID: d6bda845b99fbdfa2f88ac9f82d757297783b5d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 11:51:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6bda845b99fbdfa2f88ac9f82d757297783b5d5
Gitweb:     http://git.kernel.org/tip/d6bda845b99fbdfa2f88ac9f82d757297783b5d5
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 02:16:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 13:49:21 +0200

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
