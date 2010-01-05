Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920Ab0AEWlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0AEWlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251Ab0AEWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0AEWlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:41:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/8] [CLEANUP] perf probe: Remove newline from die()
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Date: Tue, 05 Jan 2010 17:47:03 -0500
Message-ID: <20100105224703.19431.42475.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove newline from die(), because it is automatically added.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
