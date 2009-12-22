Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZLVNFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZLVNFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZLVNFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:05:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZLVNFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:05:17 -0500
Message-ID: <4B30C3A0.909@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 21:03:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5]: trace_event: export HZ in timer's tracepoint format
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com>
In-Reply-To: <4B30C2D1.4030006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export HZ in timer's tracepoint, we can use it to get
TIMER/ITIMER_VIRTUAL/ITIMER_PROF exact latency and it's
suggested by Ingo

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 13ec15a..7749ae5 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -74,14 +74,17 @@ TRACE_EVENT(timer_expire_entry,
 	TP_STRUCT__entry(
 		__field( void *,	timer	)
 		__field( unsigned long,	now	)
+		__field( int,		hz	)
 	),
 
 	TP_fast_assign(
 		__entry->timer		= timer;
 		__entry->now		= jiffies;
+		__entry->hz		= HZ;
 	),
 
-	TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
+	TP_printk("timer=%p now=%lu HZ=%d", __entry->timer, __entry->now,
+		  __entry->hz)
 );
 
 /**
-- 
1.6.1.2


