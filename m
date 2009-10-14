Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZJNTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZJNTqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZJNTqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:47 -0400
Received: from [71.74.56.122] ([71.74.56.122]:54347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759150AbZJNTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:44 -0400
Message-Id: <20091014194400.330843045@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 12/13] [PATCH 12/13] perf tools: handle - and + in parsing trace print format
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0012-perf-tools-handle-and-in-parsing-trace-print-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The opterators '-' and '+' are not handled in the trace print format.

To do: '++' and '--'.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/Makefile                 |    2 +-
 tools/perf/util/trace-event-parse.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 495eb6d..1172aa7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -194,7 +194,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d3b0b2a..b8edc9d 100644
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
-- 
1.6.3.3


