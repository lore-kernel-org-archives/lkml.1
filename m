Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210Ab0ALK6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0ALK6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110Ab0ALK6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:58:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:60162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ALK6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:58:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf tools: Move QUIET_STDERR def to before first use
Date: Tue, 12 Jan 2010 08:58:29 -0200
Message-Id: <1263293910-8484-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

QUIET_STDERR is used when detecting if -fstack-protector-all can be used.

Noticed while building the perf tools on a Debian PARISC64 machine.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7c84642..4e4acb6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -250,6 +250,12 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(V), 2)
+	QUIET_STDERR = ">/dev/null"
+else
+	QUIET_STDERR = ">/dev/null 2>&1"
+endif
+
 ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null "$(QUIET_STDERR)" && echo y"), y)
   CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
@@ -452,11 +458,6 @@ BUILTIN_OBJS += builtin-kmem.o
 
 PERFLIBS = $(LIB_FILE)
 
-ifeq ($(V), 2)
-	QUIET_STDERR = ">/dev/null"
-else
-	QUIET_STDERR = ">/dev/null 2>&1"
-endif
 #
 # Platform specific tweaks
 #
-- 
1.6.5

