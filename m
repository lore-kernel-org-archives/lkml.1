Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0BYTct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:32:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:34062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab0BYTcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:32:31 -0500
Date: Thu, 25 Feb 2010 19:31:08 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       ananth@in.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133534.6725.52615.stgit@localhost6.localdomain6>
References: <20100225133534.6725.52615.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Rename probe finder functions
Message-ID: <tip-81cb8aa327b5923b38eccc795c8b7170be20b9ff@git.kernel.org>
Git-Commit-ID: 81cb8aa327b5923b38eccc795c8b7170be20b9ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:31:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81cb8aa327b5923b38eccc795c8b7170be20b9ff
Gitweb:     http://git.kernel.org/tip/81cb8aa327b5923b38eccc795c8b7170be20b9ff
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:35:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:28 +0100

perf probe: Rename probe finder functions

Rename *_probepoint to *_probe_point, for nothing
but a cosmetic reason.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133534.6725.52615.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |    2 +-
 tools/perf/util/probe-finder.c |   12 ++++++------
 tools/perf/util/probe-finder.h |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c7e14d0..c3e6119 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -314,7 +314,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			continue;
 
 		lseek(fd, SEEK_SET, 0);
-		ret = find_probepoint(fd, pp);
+		ret = find_probe_point(fd, pp);
 		if (ret > 0)
 			continue;
 		if (ret == 0) {	/* No error but failed to find probe point. */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3e10dbe..c819fd5 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -524,8 +524,8 @@ static void free_current_frame_base(struct probe_finder *pf)
 }
 
 /* Show a probe point to output buffer */
-static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
-			    struct probe_finder *pf)
+static void show_probe_point(Dwarf_Die sp_die, Dwarf_Signed offs,
+			     struct probe_finder *pf)
 {
 	struct probe_point *pp = pf->pp;
 	char *name;
@@ -585,7 +585,7 @@ static int probeaddr_callback(struct die_link *dlink, void *data)
 	/* Check the address is in this subprogram */
 	if (tag == DW_TAG_subprogram &&
 	    die_within_subprogram(dlink->die, pf->addr, &offs)) {
-		show_probepoint(dlink->die, offs, pf);
+		show_probe_point(dlink->die, offs, pf);
 		return 1;
 	}
 	return 0;
@@ -668,7 +668,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 			pf->addr = die_get_entrypc(dlink->die);
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			show_probepoint(dlink->die, pp->offset, pf);
+			show_probe_point(dlink->die, pp->offset, pf);
 			return 1; /* Exit; no same symbol in this CU. */
 		}
 	} else if (tag == DW_TAG_inlined_subroutine && pf->inl_offs) {
@@ -691,7 +691,7 @@ found:
 			/* Get offset from subprogram */
 			ret = die_within_subprogram(lk->die, pf->addr, &offs);
 			DIE_IF(!ret);
-			show_probepoint(lk->die, offs, pf);
+			show_probe_point(lk->die, offs, pf);
 			/* Continue to search */
 		}
 	}
@@ -704,7 +704,7 @@ static void find_probe_point_by_func(struct probe_finder *pf)
 }
 
 /* Find a probe point */
-int find_probepoint(int fd, struct probe_point *pp)
+int find_probe_point(int fd, struct probe_point *pp)
 {
 	Dwarf_Half addr_size = 0;
 	Dwarf_Unsigned next_cuh = 0;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 972b386..b2a2524 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -52,7 +52,7 @@ struct line_range {
 };
 
 #ifndef NO_LIBDWARF
-extern int find_probepoint(int fd, struct probe_point *pp);
+extern int find_probe_point(int fd, struct probe_point *pp);
 extern int find_line_range(int fd, struct line_range *lr);
 
 /* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
