Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZH1Lwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZH1Lwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZH1Lwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:52:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:51301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZH1Lwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:52:37 -0400
Date: Fri, 28 Aug 2009 11:51:57 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counters: Increase paranoia level
Message-ID: <tip-6bb56347f5162d1a7cb1dc461023360781ecd4c0@git.kernel.org>
Git-Commit-ID: 6bb56347f5162d1a7cb1dc461023360781ecd4c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 11:51:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bb56347f5162d1a7cb1dc461023360781ecd4c0
Gitweb:     http://git.kernel.org/tip/6bb56347f5162d1a7cb1dc461023360781ecd4c0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 28 Aug 2009 13:44:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Aug 2009 13:44:53 +0200

perf_counters: Increase paranoia level

Per-cpu counters are an ASLR information leak as they show
the execution other tasks do. Increase the paranoia level
to 1, which disallows per-cpu counters. (they still allow
counting/profiling of own tasks - and admin can profile
everything.)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f274e19..7d4bb83 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -50,7 +50,7 @@ static atomic_t nr_task_counters __read_mostly;
  *  1 - disallow cpu counters to unpriv
  *  2 - disallow kernel profiling to unpriv
  */
-int sysctl_perf_counter_paranoid __read_mostly;
+int sysctl_perf_counter_paranoid __read_mostly = 1;
 
 static inline bool perf_paranoid_cpu(void)
 {
