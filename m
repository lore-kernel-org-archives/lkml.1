Return-Path: <linux-kernel-owner+w=401wt.eu-S934972AbZJOIuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbZJOIuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934941AbZJOIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:50:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:52443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934940AbZJOIuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:50:01 -0400
Date: Thu, 15 Oct 2009 08:48:40 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194357.807434040@goodmis.org>
References: <20091014194357.807434040@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle trace parsing of < and >
Message-ID: <tip-298ebc3ef2a6c569b3eb51651f04e26aecbf8a1d@git.kernel.org>
Git-Commit-ID: 298ebc3ef2a6c569b3eb51651f04e26aecbf8a1d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:48:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  298ebc3ef2a6c569b3eb51651f04e26aecbf8a1d
Gitweb:     http://git.kernel.org/tip/298ebc3ef2a6c569b3eb51651f04e26aecbf8a1d
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:34 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:35 +0200

perf tools: Handle trace parsing of < and >

The code to handle the '<' and '>' ops was all in place, but
they were not in the switch statement to consider them as valid
ops.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194357.807434040@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 2b75ec2..3e643f5 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1170,6 +1170,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "*") == 0 ||
 		   strcmp(token, "^") == 0 ||
 		   strcmp(token, "/") == 0 ||
+		   strcmp(token, "<") == 0 ||
+		   strcmp(token, ">") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
