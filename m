Return-Path: <linux-kernel-owner+w=401wt.eu-S935045AbZJOIwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935045AbZJOIwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934936AbZJOIwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:52:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:33882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934993AbZJOIwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:52:10 -0400
Date: Thu, 15 Oct 2009 08:50:54 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194400.330843045@goodmis.org>
References: <20091014194400.330843045@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle - and + in parsing trace print format
Message-ID: <tip-afdf1a404eed236d6f762ee44cc0f1dcc97206e0@git.kernel.org>
Git-Commit-ID: afdf1a404eed236d6f762ee44cc0f1dcc97206e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:51:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afdf1a404eed236d6f762ee44cc0f1dcc97206e0
Gitweb:     http://git.kernel.org/tip/afdf1a404eed236d6f762ee44cc0f1dcc97206e0
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:43 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:40 +0200

perf tools: Handle - and + in parsing trace print format

The opterators '-' and '+' are not handled in the trace print
format.

To do: '++' and '--'.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194400.330843045@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fde1a43..2d424ff 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2106,6 +2106,12 @@ static unsigned long long eval_num_arg(void *data, int size,
 				die("unknown op '%s'", arg->op.op);
 			val = left == right;
 			break;
+		case '-':
+			val = left - right;
+			break;
+		case '+':
+			val = left + right;
+			break;
 		default:
 			die("unknown op '%s'", arg->op.op);
 		}
