Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbZHPSBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbZHPSBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZHPSBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:01:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZHPSBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:01:35 -0400
Date: Sun, 16 Aug 2009 18:01:04 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250445414-29237-1-git-send-email-fweisbec@gmail.com>
References: <1250445414-29237-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Put the show mode into the event headers files
Message-ID: <tip-0f25bfc8d8b31a4ac8e4ff6cbc3911fb7092a4a7@git.kernel.org>
Git-Commit-ID: 0f25bfc8d8b31a4ac8e4ff6cbc3911fb7092a4a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 18:01:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f25bfc8d8b31a4ac8e4ff6cbc3911fb7092a4a7
Gitweb:     http://git.kernel.org/tip/0f25bfc8d8b31a4ac8e4ff6cbc3911fb7092a4a7
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 16 Aug 2009 19:56:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 19:59:13 +0200

perf tools: Put the show mode into the event headers files

Annotate and report share the same flags to filter events
considering their context (kernel, user, hypervisor).

Both tools have their own definitions of these flags. Factorize
them out into the event headers file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250445414-29237-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    4 ----
 tools/perf/builtin-report.c   |    4 ----
 tools/perf/util/event.h       |    6 ++++++
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 820e7cc..6d75151 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -22,10 +22,6 @@
 #include "util/parse-events.h"
 #include "util/thread.h"
 
-#define SHOW_KERNEL	1
-#define SHOW_USER	2
-#define SHOW_HV		4
-
 static char		const *input_name = "perf.data";
 
 static char		default_sort_order[] = "comm,symbol";
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e104ed3..05d52ff 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -27,10 +27,6 @@
 
 #include "util/thread.h"
 
-#define SHOW_KERNEL	1
-#define SHOW_USER	2
-#define SHOW_HV		4
-
 static char		const *input_name = "perf.data";
 
 static char		default_sort_order[] = "comm,dso,symbol";
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index fa7c50b..fa2d4e9 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -4,6 +4,12 @@
 #include "util.h"
 #include <linux/list.h>
 
+enum {
+	SHOW_KERNEL	= 1,
+	SHOW_USER	= 2,
+	SHOW_HV		= 4,
+};
+
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
  */
