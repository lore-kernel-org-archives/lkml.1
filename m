Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbZKXQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbZKXQz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932859AbZKXQz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:55:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:57964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbZKXQzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:55:25 -0500
Date: Tue, 24 Nov 2009 16:54:37 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       acme@ghostprotocols.net, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <19211.24287.453183.78836@cargo.ozlabs.ibm.com>
References: <19211.24287.453183.78836@cargo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix compilation on powerpc
Message-ID: <tip-ee3d250446f1c1be4eceab48f3a23794d9a6564c@git.kernel.org>
Git-Commit-ID: ee3d250446f1c1be4eceab48f3a23794d9a6564c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee3d250446f1c1be4eceab48f3a23794d9a6564c
Gitweb:     http://git.kernel.org/tip/ee3d250446f1c1be4eceab48f3a23794d9a6564c
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 24 Nov 2009 15:19:43 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 08:35:10 +0100

perf tools: Fix compilation on powerpc

Currently, perf fails to compile on powerpc with this error:

     CC util/header.o
 In file included from util/../perf.h:17,
                  from util/header.c:9:
 util/../../../arch/powerpc/include/asm/unistd.h:360:27: error:
 linux/linkage.h: No such file or directory make: ***
 [util/header.o] Error 1

The reason is that we still have a #define __KERNEL__ in effect
at the point where <asm/unistd.h> gets included, which means we
get extra stuff that we don't need or want.

This fixes the problem by undefining __KERNEL__ once we have
included the file for which we need __KERNEL__ defined.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <19211.24287.453183.78836@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/include/linux/bitops.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index ace57c3..8d63116 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -7,6 +7,8 @@
 #define CONFIG_GENERIC_FIND_FIRST_BIT
 #include "../../../../include/linux/bitops.h"
 
+#undef __KERNEL__
+
 static inline void set_bit(int nr, unsigned long *addr)
 {
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
