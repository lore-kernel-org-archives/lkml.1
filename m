Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0BYKH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:07:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0BYKHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:07:23 -0500
Date: Thu, 25 Feb 2010 10:06:38 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-2-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Fix supported language listing option
Message-ID: <tip-f526d68b6ce9ba7a2bd94e663e240a022524c58a@git.kernel.org>
Git-Commit-ID: f526d68b6ce9ba7a2bd94e663e240a022524c58a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f526d68b6ce9ba7a2bd94e663e240a022524c58a
Gitweb:     http://git.kernel.org/tip/f526d68b6ce9ba7a2bd94e663e240a022524c58a
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:52 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 23 Feb 2010 20:34:42 +0100

perf/scripts: Fix supported language listing option

'perf trace -s list' prints a list of the supported scripting
languages.  One problem with it is that it falls through and prints
the trace as well.  The use of 'list' for this also makes it easy to
confuse with 'perf trace -l', used for listing available scripts.  So
change 'perf trace -s list' to 'perf trace -s lang' and fixes the
fall-through problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Documentation/perf-trace.txt |    4 +++-
 tools/perf/builtin-trace.c              |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 60e5900..c00a76f 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -45,9 +45,11 @@ OPTIONS
 --list=::
         Display a list of available trace scripts.
 
--s::
+-s ['lang']::
 --script=::
         Process trace data with the given script ([lang]:script[.ext]).
+	If the string 'lang' is specified in place of a script name, a
+        list of supported languages will be displayed instead.
 
 -g::
 --gen-script=::
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0b65779..d5d20c3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -219,9 +219,9 @@ static int parse_scriptname(const struct option *opt __used,
 	const char *script, *ext;
 	int len;
 
-	if (strcmp(str, "list") == 0) {
+	if (strcmp(str, "lang") == 0) {
 		list_available_languages();
-		return 0;
+		exit(0);
 	}
 
 	script = strchr(str, ':');
