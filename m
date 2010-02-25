Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0BYDmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:42:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906Ab0BYDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s/MMmqwlUjgEDYcZGIASfu6FqVW2jlwUG6nsoLOjg4FxmCnV8iGahBpZ2VwNOfGN3k
         u6H3XOlZXadQ8YKzP1CmQ02xcNPAfN4cucGSsQf8lziSvZGBJd0FNulDspSfMRfYP0Xi
         3du1Vdl3pB+xLkWXSfCAm0wLzWym6Q0nwaJlA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/10] perf/scripts: Fix supported language listing option
Date: Thu, 25 Feb 2010 04:42:32 +0100
Message-Id: <1267069361-10909-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

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
-- 
1.6.2.3

