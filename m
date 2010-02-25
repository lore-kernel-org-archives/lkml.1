Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab0BYLTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:19:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:33997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759048Ab0BYLTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:19:13 -0500
Date: Thu, 25 Feb 2010 11:18:34 GMT
From: "tip-bot for Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       yanmin_zhang@linux.intel.com, davem@davemloft.net, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       yanmin_zhang@linux.intel.com, efault@gmx.de, davem@davemloft.net,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267066851.1726.9.camel@localhost>
References: <1267066851.1726.9.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Check the right return variable
Message-ID: <tip-37fe5fcb7a5b5235c8b71bf5469ce4c7246e3fab@git.kernel.org>
Git-Commit-ID: 37fe5fcb7a5b5235c8b71bf5469ce4c7246e3fab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 11:18:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37fe5fcb7a5b5235c8b71bf5469ce4c7246e3fab
Gitweb:     http://git.kernel.org/tip/37fe5fcb7a5b5235c8b71bf5469ce4c7246e3fab
Author:     Zhang, Yanmin <yanmin_zhang@linux.intel.com>
AuthorDate: Thu, 25 Feb 2010 11:00:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 12:15:24 +0100

perf symbols: Check the right return variable

In function dso__split_kallsyms(), curr_map saves the return value
of map__new2. So check it instead of var map after the call returns.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: <stable@kernel.org> # for .33.x
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1267066851.1726.9.camel@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ee9c37e..320b151 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -527,7 +527,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 				return -1;
 
 			curr_map = map__new2(pos->start, dso, map->type);
-			if (map == NULL) {
+			if (curr_map == NULL) {
 				dso__delete(dso);
 				return -1;
 			}
