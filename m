Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZLIJxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZLIJxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZLIJxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:53:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:45003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbZLIJxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:53:10 -0500
Date: Wed, 9 Dec 2009 09:52:40 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B1F19DC.90204@cn.fujitsu.com>
References: <4B1F19DC.90204@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Cleanup for cpu_clock_perf_event_update()
Message-ID: <tip-ec89a06fd4e12301f11ab039ee07d2353a18addc@git.kernel.org>
Git-Commit-ID: ec89a06fd4e12301f11ab039ee07d2353a18addc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec89a06fd4e12301f11ab039ee07d2353a18addc
Gitweb:     http://git.kernel.org/tip/ec89a06fd4e12301f11ab039ee07d2353a18addc
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 9 Dec 2009 11:30:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 09:56:27 +0100

perf_event: Cleanup for cpu_clock_perf_event_update()

Using atomic64_xchg() instead of atomic64_read() and
atomic64_set().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B1F19DC.90204@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 77641ae..94e1b28 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4079,8 +4079,7 @@ static void cpu_clock_perf_event_update(struct perf_event *event)
 	u64 now;
 
 	now = cpu_clock(cpu);
-	prev = atomic64_read(&event->hw.prev_count);
-	atomic64_set(&event->hw.prev_count, now);
+	prev = atomic64_xchg(&event->hw.prev_count, now);
 	atomic64_add(now - prev, &event->count);
 }
 
