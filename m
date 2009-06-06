Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZFFStg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZFFStg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 14:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFFSt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 14:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:34360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZFFSt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 14:49:26 -0400
Date: Sat, 6 Jun 2009 18:48:45 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Warning fixes on 32-bit
Message-ID: <tip-7d37a0cbd68c875fa984fa97bcf5c7f4b7950b6d@git.kernel.org>
Git-Commit-ID: 7d37a0cbd68c875fa984fa97bcf5c7f4b7950b6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 18:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d37a0cbd68c875fa984fa97bcf5c7f4b7950b6d
Gitweb:     http://git.kernel.org/tip/7d37a0cbd68c875fa984fa97bcf5c7f4b7950b6d
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 6 Jun 2009 20:36:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 20:46:19 +0200

perf_counter tools: Warning fixes on 32-bit

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/util/symbol.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 116a397..4a3c279 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -668,9 +668,9 @@ static void hist_hit(struct hist_entry *he, uint64_t ip)
 
 	if (verbose >= 3)
 		printf("%p %s: count++ [ip: %p, %08Lx] => %Ld\n",
-			(void *)he->sym->start,
+			(void *)(unsigned long)he->sym->start,
 			he->sym->name,
-			(void *)ip, ip - he->sym->start,
+			(void *)(unsigned long)ip, ip - he->sym->start,
 			sym->hist[offset]);
 }
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 23f4f7b..253821d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -21,7 +21,7 @@ static struct symbol *symbol__new(uint64_t start, uint64_t len,
 
 	if (verbose >= 2)
 		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
-			(__u64)start, len, name, self->hist, (void *)obj_start);
+			(__u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
 
 	self->obj_start= obj_start;
 	self->hist = NULL;
