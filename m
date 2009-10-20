Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZJTXUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZJTXUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZJTXUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:20:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZJTXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:20:30 -0400
Message-Id: <20091020232033.984323261@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 20 Oct 2009 19:19:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] [PATCH 1/2] perf tools: add make DEBUG=1 to remove the -O6 cflag
References: <20091020231933.203083200@goodmis.org>
Content-Disposition: inline; filename=0001-perf-tools-add-make-DEBUG-1-to-remove-the-O6-cflag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When using gdb to debug perf, it is practically impossible to use when
perf is compiled with -O6. For developers, this patch adds the DEBUG
feature to the make command line so that a developer can easily remove
the optimization flag.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1255590330.8392.446.camel@twins>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/Makefile |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index db89a6d..4eff0be 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -201,7 +201,14 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+ifeq ("$(origin DEBUG)", "command line")
+  PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+  CFLAGS_OPTIMIZE = -O6
+endif
+
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.6.3.3


