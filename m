Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZKWHDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZKWHDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZKWHDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:03:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:51928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZKWHDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:03:07 -0500
Date: Mon, 23 Nov 2009 07:02:31 GMT
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, mst@redhat.com,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, mst@redhat.com, a.p.zijlstra@chello.nl,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091122121335.GA24254@redhat.com>
References: <20091122121335.GA24254@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use default compiler mode by default
Message-ID: <tip-81516c5fc83a13a1d12f466aa7e14f5fd62a63ce@git.kernel.org>
Git-Commit-ID: 81516c5fc83a13a1d12f466aa7e14f5fd62a63ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81516c5fc83a13a1d12f466aa7e14f5fd62a63ce
Gitweb:     http://git.kernel.org/tip/81516c5fc83a13a1d12f466aa7e14f5fd62a63ce
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 22 Nov 2009 14:13:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 07:55:57 +0100

perf: Use default compiler mode by default

gcc with no flags typically is a sane default for systems to
use, and looking at the running kernel is probably broken for
cross-builds anyway, so let's not do this.  Add EXTRA_CFLAGS so
that users can override default gcc mode if they want to.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091122121335.GA24254@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fce4c3f..3ef6621 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -148,6 +148,8 @@ all::
 # broken, or spawning external process is slower than built-in grep perf has).
 #
 # Define LDFLAGS=-static to build a static binary.
+#
+# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
@@ -160,22 +162,6 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-#
-# Add -m32 for cross-builds:
-#
-ifdef NO_64BIT
-  MBITS := -m32
-else
-  #
-  # If we're on a 64-bit kernel (except ia64), use -m64:
-  #
-  ifneq ($(uname_M),ia64)
-    ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-      MBITS := -m64
-    endif
-  endif
-endif
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -212,7 +198,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
