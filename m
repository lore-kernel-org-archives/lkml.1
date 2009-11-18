Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZKRVIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZKRVIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbZKRVII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:08:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbZKRVIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:08:07 -0500
From: Josh Stone <jistone@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josh Stone <jistone@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing: Remove the stale include/trace/power.h
Date: Wed, 18 Nov 2009 13:06:55 -0800
Message-Id: <1258578415-14752-1-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6161352 moved the power tracing to include/trace/events/, but
left the old header behind.  No one is using the old header, and its
declarations are now incorrect, so it should be removed.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/trace/power.h |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)
 delete mode 100644 include/trace/power.h

diff --git a/include/trace/power.h b/include/trace/power.h
deleted file mode 100644
index ef20466..0000000
--- a/include/trace/power.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef _TRACE_POWER_H
-#define _TRACE_POWER_H
-
-#include <linux/ktime.h>
-#include <linux/tracepoint.h>
-
-enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
-};
-
-struct power_trace {
-	ktime_t			stamp;
-	ktime_t			end;
-	int			type;
-	int			state;
-};
-
-DECLARE_TRACE(power_start,
-	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
-	      TP_ARGS(it, type, state));
-
-DECLARE_TRACE(power_mark,
-	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
-	      TP_ARGS(it, type, state));
-
-DECLARE_TRACE(power_end,
-	TP_PROTO(struct power_trace *it),
-	      TP_ARGS(it));
-
-#endif /* _TRACE_POWER_H */
-- 
1.6.5.2

