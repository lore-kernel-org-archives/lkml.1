Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZLGHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZLGHKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZLGHK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:10:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:58294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbZLGHK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:10:28 -0500
Date: Mon, 7 Dec 2009 07:09:45 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, tzanussi@gmail.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, acme@ghostprotocols.net, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, acme@ghostprotocols.net, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260153712.6564.4.camel@tropicana>
References: <1260153712.6564.4.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Fix compile error when libperl not installed
Message-ID: <tip-3a9a0beba2913edaae39ff8b4645fee10c3acf37@git.kernel.org>
Git-Commit-ID: 3a9a0beba2913edaae39ff8b4645fee10c3acf37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a9a0beba2913edaae39ff8b4645fee10c3acf37
Gitweb:     http://git.kernel.org/tip/3a9a0beba2913edaae39ff8b4645fee10c3acf37
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sun, 6 Dec 2009 20:41:52 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 06:31:37 +0100

perf trace/scripting: Fix compile error when libperl not installed

When I added the xs callbacks into perf, I forgot to re-check
the no-libperl case. This patch fixes the undefined reference
error for that.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1260153712.6564.4.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-perl.c |    3 ---
 tools/perf/util/trace-event-perl.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 51e833f..59564b2 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -32,9 +32,6 @@
 
 void xs_init(pTHX);
 
-void boot_Perf__Trace__Context(pTHX_ CV *cv);
-void boot_DynaLoader(pTHX_ CV *cv);
-
 void xs_init(pTHX)
 {
 	const char *file = __FILE__;
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 8fe0d86..e88fb26 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -34,9 +34,13 @@ typedef int INTERP;
 #define dXSUB_SYS
 #define pTHX_
 static inline void newXS(const char *a, void *b, const char *c) {}
+static void boot_Perf__Trace__Context(pTHX_ CV *cv) {}
+static void boot_DynaLoader(pTHX_ CV *cv) {}
 #else
 #include <EXTERN.h>
 #include <perl.h>
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
