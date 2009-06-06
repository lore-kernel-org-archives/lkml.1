Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbZFFTZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbZFFTZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 15:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZFFTZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 15:25:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZFFTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 15:25:05 -0400
Date: Sat, 6 Jun 2009 19:24:31 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Initialize a stack variable before use
Message-ID: <tip-e9fbc9dc9214d6a9de7d62627be5414804fd7b9f@git.kernel.org>
Git-Commit-ID: e9fbc9dc9214d6a9de7d62627be5414804fd7b9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 19:24:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9fbc9dc9214d6a9de7d62627be5414804fd7b9f
Gitweb:     http://git.kernel.org/tip/e9fbc9dc9214d6a9de7d62627be5414804fd7b9f
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 6 Jun 2009 21:22:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 21:22:33 +0200

perf_counter tools: Initialize a stack variable before use

the "perf report" utility crashed in some circumstances
because the "sym" stack variable was not initialized before used
(as also proven by valgrind).

With this fix both the crash goes away and valgrind no longer complains.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 253821d..158588c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -457,6 +457,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
+	memset(&sym, 0, sizeof(sym));
+
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		uint64_t obj_start;
