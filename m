Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0BDJ4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:56:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:52293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab0BDJ4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:56:39 -0500
Date: Thu, 4 Feb 2010 09:54:51 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, kirr@landau.phys.spbu.ru,
       efault@gmx.de, fweisbec@gmail.com, acme@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       acme@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1265265106.6364.5.camel@marge.simson.net>
References: <1265265106.6364.5.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix perf top module symbol annotation
Message-ID: <tip-57d818895f9d294ab9080e5a662675fdee943ff1@git.kernel.org>
Git-Commit-ID: 57d818895f9d294ab9080e5a662675fdee943ff1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:54:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57d818895f9d294ab9080e5a662675fdee943ff1
Gitweb:     http://git.kernel.org/tip/57d818895f9d294ab9080e5a662675fdee943ff1
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 4 Feb 2010 07:31:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:33:28 +0100

perf annotate: Fix perf top module symbol annotation

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1265265106.6364.5.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 83c09c8..e4156bc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -204,8 +204,8 @@ static void parse_source(struct sym_entry *syme)
 	sprintf(command,
 		"objdump --start-address=0x%016Lx "
 			 "--stop-address=0x%016Lx -dS %s",
-		map->unmap_ip(map, sym->start),
-		map->unmap_ip(map, sym->end), path);
+		map__rip_2objdump(map, sym->start),
+		map__rip_2objdump(map, sym->end), path);
 
 	file = popen(command, "r");
 	if (!file)
