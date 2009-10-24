Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZJXBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZJXBIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZJXBI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:08:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:51716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbZJXBEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:42 -0400
Date: Sat, 24 Oct 2009 01:03:55 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091020232033.984323261@goodmis.org>
References: <1255590330.8392.446.camel@twins>,
	<20091020232033.984323261@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Add 'make DEBUG=1' to remove the -O6 cflag
Message-ID: <tip-60d526f7fa6246b8e32d5b45610d625a5608d988@git.kernel.org>
Git-Commit-ID: 60d526f7fa6246b8e32d5b45610d625a5608d988
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60d526f7fa6246b8e32d5b45610d625a5608d988
Gitweb:     http://git.kernel.org/tip/60d526f7fa6246b8e32d5b45610d625a5608d988
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 20 Oct 2009 19:19:34 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 13:39:57 +0200

perf tools: Add 'make DEBUG=1' to remove the -O6 cflag

When using gdb to debug perf, it is practically impossible to
use when perf is compiled with -O6. For developers, this patch
adds the DEBUG feature to the make command line so that a
developer can easily remove the optimization flag.

LKML-Reference: <1255590330.8392.446.camel@twins>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091020232033.984323261@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64c6b7b..65e6e52 100644
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
