Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZEKKPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZEKKPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbZEKKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:50840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbZEKKNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:34 -0400
Date: Mon, 11 May 2009 10:12:53 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18951.48285.270311.981806@drongo.ozlabs.ibm.com>
References: <18951.48285.270311.981806@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: call atomic64_set for counter->count
Message-ID: <tip-615a3f1e055ac9b0ae74e1f935a12ea2cfe2a2ad@git.kernel.org>
Git-Commit-ID: 615a3f1e055ac9b0ae74e1f935a12ea2cfe2a2ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:12:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  615a3f1e055ac9b0ae74e1f935a12ea2cfe2a2ad
Gitweb:     http://git.kernel.org/tip/615a3f1e055ac9b0ae74e1f935a12ea2cfe2a2ad
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 11 May 2009 15:50:21 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 12:10:54 +0200

perf_counter: call atomic64_set for counter->count

A compile warning triggered because we are calling
atomic_set(&counter->count). But since counter->count
is an atomic64_t, we have to use atomic64_set.

So the count can be set short, resulting in the reset ioctl
only resetting the low word.

[ Impact: clear counter properly during the reset ioctl ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18951.48285.270311.981806@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7373b96..5ea0240 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1281,7 +1281,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 static void perf_counter_reset(struct perf_counter *counter)
 {
 	(void)perf_counter_read(counter);
-	atomic_set(&counter->count, 0);
+	atomic64_set(&counter->count, 0);
 	perf_counter_update_userpage(counter);
 }
 
