Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZKQRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZKQRTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZKQRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:19:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:40392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbZKQRTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:19:46 -0500
Date: Tue, 17 Nov 2009 17:18:51 GMT
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tony.luck@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, tony.luck@intel.com, mingo@elte.hu
In-Reply-To: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
References: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add ia64 support for tools/perf/
Message-ID: <tip-5960a8b22f5015d6e36b2a095c47bc27e8e685c8@git.kernel.org>
Git-Commit-ID: 5960a8b22f5015d6e36b2a095c47bc27e8e685c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5960a8b22f5015d6e36b2a095c47bc27e8e685c8
Gitweb:     http://git.kernel.org/tip/5960a8b22f5015d6e36b2a095c47bc27e8e685c8
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Tue, 17 Nov 2009 09:05:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 18:14:24 +0100

perf tools: Add ia64 support for tools/perf/

Compiler on ia64 rejects the "-m64" option.
Add arch specific pieces to perf.h

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    8 +++++---
 tools/perf/perf.h   |    6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b356987..53e663a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -166,10 +166,12 @@ ifdef NO_64BIT
   MBITS := -m32
 else
   #
-  # If we're on a 64-bit kernel, use -m64:
+  # If we're on a 64-bit kernel (except ia64), use -m64:
   #
-  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-    MBITS := -m64
+  ifneq ($(uname_M),ia64)
+    ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+      MBITS := -m64
+    endif
   endif
 endif
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 216bdb2..454d5d5 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -53,6 +53,12 @@
 #define cpu_relax()	asm volatile("" ::: "memory")
 #endif
 
+#ifdef __ia64__
+#include "../../arch/ia64/include/asm/unistd.h"
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
