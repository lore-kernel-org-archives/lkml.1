Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZKKHt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZKKHt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZKKHtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:49:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:48298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbZKKHtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:49:24 -0500
Date: Wed, 11 Nov 2009 07:48:37 GMT
From: tip-bot for Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, ink@jurassic.park.msu.ru,
       tglx@linutronix.de, rth@twiddle.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
       mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <20091111074302.GA3728@omega>
References: <20091111074302.GA3728@omega>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Test -fstack-protector-all compiler option for inclusion in CFLAGS
Message-ID: <tip-5d7bdab75cd56d2bdc0986ae5546be3b09fea70a@git.kernel.org>
Git-Commit-ID: 5d7bdab75cd56d2bdc0986ae5546be3b09fea70a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d7bdab75cd56d2bdc0986ae5546be3b09fea70a
Gitweb:     http://git.kernel.org/tip/5d7bdab75cd56d2bdc0986ae5546be3b09fea70a
Author:     Michael Cree <mcree@orcon.net.nz>
AuthorDate: Wed, 11 Nov 2009 20:43:03 +1300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 08:46:45 +0100

perf tools: Test -fstack-protector-all compiler option for inclusion in CFLAGS

Some architectures (e.g. Alpha) do not support the
-fstack-protector-all compiler option and the use of the option
with -Werror causes the compiler to abort and the build fails.

Test that the compiler supports -fstack-protector-all before
inclusion in CFLAGS.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091111074302.GA3728@omega>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b9509b1..e6d4272 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -207,7 +207,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -259,6 +259,9 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null >/dev/null 2>&1 && echo y"), y)
+  CFLAGS := $(CFLAGS) -fstack-protector-all
+endif
 
 
 ### --- END CONFIGURATION SECTION ---
