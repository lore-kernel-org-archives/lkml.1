Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbZKSEoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbZKSEoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 23:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932572AbZKSEn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 23:43:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:35855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbZKSEnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 23:43:49 -0500
Date: Thu, 19 Nov 2009 04:43:08 GMT
From: tip-bot for Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, fche@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, jistone@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, fche@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, jistone@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258578415-14752-1-git-send-email-jistone@redhat.com>
References: <1258578415-14752-1-git-send-email-jistone@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove the stale include/trace/power.h
Message-ID: <tip-192dcf1d1775736627280a5dd4cb0f605b21857a@git.kernel.org>
Git-Commit-ID: 192dcf1d1775736627280a5dd4cb0f605b21857a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  192dcf1d1775736627280a5dd4cb0f605b21857a
Gitweb:     http://git.kernel.org/tip/192dcf1d1775736627280a5dd4cb0f605b21857a
Author:     Josh Stone <jistone@redhat.com>
AuthorDate: Wed, 18 Nov 2009 13:06:55 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Nov 2009 05:38:40 +0100

tracing: Remove the stale include/trace/power.h

Commit 6161352 moved the power tracing to include/trace/events/,
but left the old header behind.  No one is using the old header,
and its declarations are now incorrect, so it should be removed.

Signed-off-by: Josh Stone <jistone@redhat.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258578415-14752-1-git-send-email-jistone@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/power.h |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

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
