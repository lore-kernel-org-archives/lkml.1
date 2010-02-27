Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580Ab0B0SZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:25:49 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42978 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030556Ab0B0SZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rdSV7fsZwgAuCvxhgpZiqwf3N0tyOQnXly/xF9GKTml5m7CRm30bZjCjmLvgfjV7Nz
         LHG0YpdJpZQ8OedLEDa0oP984kf2SevBoSBJL/ShKgHFrTvuuXbMJfA+KcHsv9dCnClz
         nSZRAv/9yiDdWWrCyPMXt25De+ntDXxX3ZpHo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/5] perf: Remove pointless breakpoint union
Date: Sat, 27 Feb 2010 19:25:32 +0100
Message-Id: <1267295133-6320-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
References: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pointless union in the breakpoint field of hw_perf_event.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_event.h |    5 ++---
 lib/Kconfig.debug          |    8 +++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7b18b4f..04f06b4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -487,9 +487,8 @@ struct hw_perf_event {
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-		union { /* breakpoint */
-			struct arch_hw_breakpoint	info;
-		};
+		/* breakpoint */
+		struct arch_hw_breakpoint	info;
 #endif
 	};
 	atomic64_t			prev_count;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 65f964e..4dc24cc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -520,11 +520,13 @@ config LOCK_STAT
 
 	 For more details, see Documentation/lockstat.txt
 
-	 You can analyze lock events with "perf lock", subcommand of perf.
-	 If you want to use "perf lock", you need to turn on CONFIG_EVENT_TRACING.
+	 This also enables lock events required by "perf lock",
+	 subcommand of perf.
+	 If you want to use "perf lock", you also need to turn on
+	 CONFIG_EVENT_TRACING.
 
 	 CONFIG_LOCK_STAT defines "contended" and "acquired" lock events.
- 	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
+	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
 
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
-- 
1.6.2.3

