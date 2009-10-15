Return-Path: <linux-kernel-owner+w=401wt.eu-S935037AbZJOIvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037AbZJOIvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934984AbZJOIvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:51:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:33862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934997AbZJOIvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:51:46 -0400
Date: Thu, 15 Oct 2009 08:50:24 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194359.790221427@goodmis.org>
References: <20091014194359.790221427@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle both versions of ftrace output
Message-ID: <tip-0d1da915c76838c9ee7af7cdefbcb2bae9424161@git.kernel.org>
Git-Commit-ID: 0d1da915c76838c9ee7af7cdefbcb2bae9424161
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:50:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d1da915c76838c9ee7af7cdefbcb2bae9424161
Gitweb:     http://git.kernel.org/tip/0d1da915c76838c9ee7af7cdefbcb2bae9424161
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:41 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:39 +0200

perf tools: Handle both versions of ftrace output

The ftrace output events can have either arguments or no
arguments. The parser needs to be able to handle both.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194359.790221427@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 93a82fe..c174765 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1819,7 +1819,7 @@ static int event_read_print(struct event *event)
 	if (ret < 0)
 		return -1;
 
-	return 0;
+	return ret;
 
  fail:
 	free_token(token);
@@ -3088,6 +3088,9 @@ int parse_ftrace_file(char *buf, unsigned long size)
 	if (ret < 0)
 		die("failed to read ftrace event print fmt");
 
+	/* New ftrace handles args */
+	if (ret > 0)
+		return 0;
 	/*
 	 * The arguments for ftrace files are parsed by the fields.
 	 * Set up the fields as their arguments.
