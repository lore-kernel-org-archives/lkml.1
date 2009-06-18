Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbZFRMwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbZFRMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763501AbZFRMu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:50:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:38253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763180AbZFRMuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:50:55 -0400
Date: Thu, 18 Jun 2009 12:50:01 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
References: <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: tools: Makefile tweaks for 64-bit powerpc
Message-ID: <tip-e24a72c4d8f0b2c17783b3ba9c8931b537149423@git.kernel.org>
Git-Commit-ID: e24a72c4d8f0b2c17783b3ba9c8931b537149423
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:50:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e24a72c4d8f0b2c17783b3ba9c8931b537149423
Gitweb:     http://git.kernel.org/tip/e24a72c4d8f0b2c17783b3ba9c8931b537149423
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 17 Jun 2009 21:54:26 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 11:11:47 +0200

perf_counter: tools: Makefile tweaks for 64-bit powerpc

On 64-bit powerpc, perf needs to be built as a 64-bit executable.
This arranges to add the -m64 flag to CFLAGS if we are running on
a 64-bit machine, indicated by the result of uname -m ending in "64".
This means that we'll use -m64 on x86_64 machines as well.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
LKML-Reference: <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e8346f9..714db73 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,9 +157,14 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
+# If we're on a 64-bit kernel, use -m64
+ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+  M64 := -m64
+endif
+
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
+CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
