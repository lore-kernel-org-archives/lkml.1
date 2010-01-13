Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689Ab0AMKgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0AMKgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634Ab0AMKgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:34662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab0AMKgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:16 -0500
Date: Wed, 13 Jan 2010 10:34:29 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100105224703.19431.42475.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224703.19431.42475.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove newline from die()
Message-ID: <tip-bbaa46fac6d1c652bfa6282420d36a44bdc53b64@git.kernel.org>
Git-Commit-ID: bbaa46fac6d1c652bfa6282420d36a44bdc53b64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:34:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbaa46fac6d1c652bfa6282420d36a44bdc53b64
Gitweb:     http://git.kernel.org/tip/bbaa46fac6d1c652bfa6282420d36a44bdc53b64
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:47:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:13 +0100

perf probe: Remove newline from die()

Remove newline from die(), because it is automatically added.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20100105224703.19431.42475.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 4b852c0..6402798 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -402,11 +402,11 @@ static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
 	} else if (op == DW_OP_regx) {
 		regn = loc->lr_number;
 	} else
-		die("Dwarf_OP %d is not supported.\n", op);
+		die("Dwarf_OP %d is not supported.", op);
 
 	regs = get_arch_regstr(regn);
 	if (!regs)
-		die("%lld exceeds max register number.\n", regn);
+		die("%lld exceeds max register number.", regn);
 
 	if (deref)
 		ret = snprintf(pf->buf, pf->len,
@@ -438,7 +438,7 @@ static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
 	return ;
 error:
 	die("Failed to find the location of %s at this address.\n"
-	    " Perhaps, it has been optimized out.\n", pf->var);
+	    " Perhaps, it has been optimized out.", pf->var);
 }
 
 static int variable_callback(struct die_link *dlink, void *data)
@@ -476,7 +476,7 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 	/* Search child die for local variables and parameters. */
 	ret = search_die_from_children(sp_die, variable_callback, pf);
 	if (!ret)
-		die("Failed to find '%s' in this function.\n", pf->var);
+		die("Failed to find '%s' in this function.", pf->var);
 }
 
 /* Get a frame base on the address */
@@ -602,7 +602,7 @@ static void find_by_line(struct probe_finder *pf)
 		ret = search_die_from_children(pf->cu_die,
 					       probeaddr_callback, pf);
 		if (ret == 0)
-			die("Probe point is not found in subprograms.\n");
+			die("Probe point is not found in subprograms.");
 		/* Continuing, because target line might be inlined. */
 	}
 	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
@@ -661,7 +661,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 				    !die_inlined_subprogram(lk->die))
 					goto found;
 			}
-			die("Failed to find real subprogram.\n");
+			die("Failed to find real subprogram.");
 found:
 			/* Get offset from subprogram */
 			ret = die_within_subprogram(lk->die, pf->addr, &offs);
