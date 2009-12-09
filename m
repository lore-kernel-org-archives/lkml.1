Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZLIDcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZLIDcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 22:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZLIDcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 22:32:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbZLIDcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 22:32:12 -0500
Message-ID: <4B1F19DC.90204@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 11:30:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf_event: cleanup for cpu_clock_perf_event_update()
References: <4B1F194D.7080306@cn.fujitsu.com> <4B1F19A8.5040805@cn.fujitsu.com>
In-Reply-To: <4B1F19A8.5040805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using atomic64_xchg() instead of atomic64_read() and atomic64_set().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 592b293..8f46012 100644
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
 
-- 
1.6.1.2


