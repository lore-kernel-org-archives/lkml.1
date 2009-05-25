Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZEYIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZEYIEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZEYIEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZEYIEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:04:20 -0400
Date: Mon, 25 May 2009 08:03:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: increase limits, fix
Message-ID: <tip-85a9f9200226ddffc2ea50dae6a8df04c033ecd4@git.kernel.org>
Git-Commit-ID: 85a9f9200226ddffc2ea50dae6a8df04c033ecd4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 08:03:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85a9f9200226ddffc2ea50dae6a8df04c033ecd4
Gitweb:     http://git.kernel.org/tip/85a9f9200226ddffc2ea50dae6a8df04c033ecd4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 25 May 2009 09:59:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 09:59:50 +0200

perf_counter tools: increase limits, fix

NR_CPUS and NR_COUNTERS goes up quadratic ... 1024x4096 was far
too ambitious upper limit - go for 256x256 which is still plenty.

[ Impact: reduce perf tool memory consumption ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/perf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/perf.h b/Documentation/perf_counter/perf.h
index a517683..5a2520b 100644
--- a/Documentation/perf_counter/perf.h
+++ b/Documentation/perf_counter/perf.h
@@ -61,8 +61,8 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
 		       group_fd, flags);
 }
 
-#define MAX_COUNTERS			1024
-#define MAX_NR_CPUS			4096
+#define MAX_COUNTERS			256
+#define MAX_NR_CPUS			256
 
 #define EID(type, id) (((__u64)(type) << PERF_COUNTER_TYPE_SHIFT) | (id))
 
