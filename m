Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593Ab0A0I2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0A0I2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0A0I2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:11 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38170 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0A0I2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fb8y5z/V2R8xlmrvtxRcLuQomDXJXVrJ+uYQiD8ZKOyDX3UgaQuYYXBQDHVWPQ1/3z
         1pS+jcNqH9GICNm2fKCv+pfY9tz45jZC5bAwy1Gcy3yciJqRZEeq5pWnZBF9IIGkvyxQ
         oJ/An8dPf7LRRzS++CeIaHhSoC2bFnNMM0pGU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 01/12] perf trace/scripting: Fix supported language listing option
Date: Wed, 27 Jan 2010 02:27:52 -0600
Message-Id: <1264580883-15324-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf trace -s list' prints a list of the supported scripting
languages.  One problem with it is that it falls through and prints
the trace as well.  The use of 'list' for this also makes it easy to
confuse with 'perf trace -l', used for listing available scripts.  So
change 'perf trace -s list' to 'perf trace -s lang' and fixes the
fall-through problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
index 8e9cbfe..850d0aa 100644
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
1.6.4.GIT

