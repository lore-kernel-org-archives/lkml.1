Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZFQR26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZFQR26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbZFQR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:28:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758997AbZFQR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:27 -0400
Date: Wed, 17 Jun 2009 17:27:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Replace isprint() with issane()
Message-ID: <tip-5aa75a0fd4bc6402899e06fdb853cab024d65055@git.kernel.org>
Git-Commit-ID: 5aa75a0fd4bc6402899e06fdb853cab024d65055
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 17:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5aa75a0fd4bc6402899e06fdb853cab024d65055
Gitweb:     http://git.kernel.org/tip/5aa75a0fd4bc6402899e06fdb853cab024d65055
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 15 Jun 2009 20:11:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 19:23:53 +0200

perf_counter tools: Replace isprint() with issane()

The Git utils came with a ctype replacement that doesn't provide
isprint(). Add a replacement.

Solves a build bug on certain distros.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/util.h      |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cd74b2e..707f60c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1266,7 +1266,7 @@ static void trace_event(event_t *event)
 			for (j = 0; j < 15-(i & 15); j++)
 				cdprintf("   ");
 			for (j = 0; j < (i & 15); j++) {
-				if (isprint(raw_event[i-15+j]))
+				if (issane(raw_event[i-15+j]))
 					cdprintf("%c", raw_event[i-15+j]);
 				else
 					cdprintf(".");
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 76590a1..ce9b514 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -343,6 +343,7 @@ extern unsigned char sane_ctype[256];
 #define isdigit(x) sane_istest(x,GIT_DIGIT)
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
+#define issane(x)  sane_istest(x,GIT_SPACE | GIT_DIGIT | GIT_ALPHA | GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define is_glob_special(x) sane_istest(x,GIT_GLOB_SPECIAL)
 #define is_regex_special(x) sane_istest(x,GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
