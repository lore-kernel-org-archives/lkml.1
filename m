Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZHRJQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZHRJQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZHRJQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:16:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZHRJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:16:15 -0400
Date: Tue, 18 Aug 2009 09:15:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf tools: Remove obsolete defines
Message-ID: <tip-1f18345bdfd489fde1085bc85839d5d3645cf511@git.kernel.org>
Git-Commit-ID: 1f18345bdfd489fde1085bc85839d5d3645cf511
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 09:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f18345bdfd489fde1085bc85839d5d3645cf511
Gitweb:     http://git.kernel.org/tip/1f18345bdfd489fde1085bc85839d5d3645cf511
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 18 Aug 2009 10:59:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 11:00:05 +0200

perf tools: Remove obsolete defines

The _XOPEN_SOURCE* defines are not really needed on Linux and
it's not like we'll port this to AIX ;-)

The define also broke the build with gcc 4.4.1:

 CC util/trace-event-parse.o
 In file included from util/trace-event-parse.c:32:
 util/util.h:43:1: error: "_XOPEN_SOURCE" redefined

So remove them.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/util.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index d61a6f0..15004d2 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,10 +39,6 @@
 /* Approximation of the length of the decimal representation of this type. */
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
-#if !defined(__APPLE__) && !defined(__FreeBSD__)  && !defined(__USLC__) && !defined(_M_UNIX)
-#define _XOPEN_SOURCE 600 /* glibc2 and AIX 5.3L need 500, OpenBSD needs 600 for S_ISLNK() */
-#define _XOPEN_SOURCE_EXTENDED 1 /* AIX 5.3L needs this */
-#endif
 #define _ALL_SOURCE 1
 #define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
