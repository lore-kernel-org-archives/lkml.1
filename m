Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZHPR46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZHPR46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 13:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZHPR45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 13:56:57 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35661 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbZHPR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 13:56:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lLJMhrwylJ5ZL4VlpxoIlRDJVuGrUtVYsJj/7YnRL/B3mtEIbrmyhlKp69QoY2KYrl
         Yg3iz6hHcSOyEvTSiE6oIEVReWtw8OxFwNXdt1Zl2Ho45eNbQkfWqTJsN3mA8+H/+SM7
         OGWCEkuLf427G7Mtj+yZgyQSGs9cBj9l1W/DE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Put the show mode into the event headers files
Date: Sun, 16 Aug 2009 19:56:54 +0200
Message-Id: <1250445414-29237-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
References: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate and report share the same flags to filter events
considering their context (kernel, user, hypervisor).

Both tools have their own definitions of these flags. Factorize
them in the event headers file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
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
-- 
1.6.2.3

