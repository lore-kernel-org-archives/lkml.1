Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbZFOOWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbZFOOWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbZFOOW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:22:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:47407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbZFOOW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:22:26 -0400
Date: Mon, 15 Jun 2009 14:21:55 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       yong.y.wang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Fix 32-bit printf format
Message-ID: <tip-e2eae0f5605b90a0838608043c21050b08b6dd95@git.kernel.org>
Git-Commit-ID: e2eae0f5605b90a0838608043c21050b08b6dd95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 14:21:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2eae0f5605b90a0838608043c21050b08b6dd95
Gitweb:     http://git.kernel.org/tip/e2eae0f5605b90a0838608043c21050b08b6dd95
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Jun 2009 16:15:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 16:18:02 +0200

perf report: Fix 32-bit printf format

Yong Wang reported the following compiler warning:

 builtin-report.c: In function 'process_overflow_event':
 builtin-report.c:984: error: cast to pointer from integer of different size

Which happens because we try to print ->ips[] out with a limited
format, losing the high 32 bits. Print it out using %016Lx instead.

Reported-by: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1e2f5dd..f86bb07 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -982,7 +982,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 				chain->nr);
 
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %p\n", i, (void *)chain->ips[i]);
+				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
 		}
 		if (collapse_syscalls) {
 			/*
