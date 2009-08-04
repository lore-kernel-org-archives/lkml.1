Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbZHDQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbZHDQWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbZHDQWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:22:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860AbZHDQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:22:31 -0400
Date: Tue, 4 Aug 2009 16:21:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Provide default bfd_demangle() function in case it's not around
Message-ID: <tip-08b6cb88eeb51fe267cb3847ba663a9558fe73cd@git.kernel.org>
Git-Commit-ID: 08b6cb88eeb51fe267cb3847ba663a9558fe73cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 16:21:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08b6cb88eeb51fe267cb3847ba663a9558fe73cd
Gitweb:     http://git.kernel.org/tip/08b6cb88eeb51fe267cb3847ba663a9558fe73cd
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 4 Aug 2009 13:27:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 18:19:33 +0200

perf_counter tools: Provide default bfd_demangle() function in case it's not around

Provide weak alias (which does nothing) in case the system does not
offer one.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b4fe057..7bd5128 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -8,6 +8,17 @@
 #include <elf.h>
 #include <bfd.h>
 
+/*
+ * Weak wrapper in case a library version is not available:
+ */
+extern char * __attribute__((weak)) bfd_demangle (bfd *, const char *, int);
+
+char * __attribute__((weak))
+ bfd_demangle (bfd *bfd __used, const char *name __used, int flags __used)
+{
+	return NULL;
+}
+
 const char *sym_hist_filter;
 
 #ifndef DMGL_PARAMS
