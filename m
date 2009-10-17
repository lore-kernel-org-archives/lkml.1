Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZJQKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZJQKG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZJQKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:06:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZJQKGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:06:49 -0400
Date: Sat, 17 Oct 2009 10:06:25 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000810.16556.38013.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000810.16556.38013.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf: Use eprintf() for debug messages in perf-probe
Message-ID: <tip-89c69c0eee7515cdc217f4278de43547284b3458@git.kernel.org>
Git-Commit-ID: 89c69c0eee7515cdc217f4278de43547284b3458
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:06:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89c69c0eee7515cdc217f4278de43547284b3458
Gitweb:     http://git.kernel.org/tip/89c69c0eee7515cdc217f4278de43547284b3458
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:08:10 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:54:00 +0200

perf: Use eprintf() for debug messages in perf-probe

Replace debug() macro with eprintf() and add -v option for
showing those messages in perf-probe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000810.16556.38013.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   23 ++++++++++++++---------
 tools/perf/util/probe-finder.c |   12 +++++++-----
 tools/perf/util/probe-finder.h |    7 -------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a1467d1..b5ad86a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -35,6 +35,8 @@
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
+#include "util/event.h"
+#include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
@@ -76,7 +78,7 @@ static int parse_probepoint(const struct option *opt __used,
 	if (!str)	/* The end of probe points */
 		return 0;
 
-	debug("Probe-define(%d): %s\n", session.nr_probe, str);
+	eprintf("probe-definition(%d): %s\n", session.nr_probe, str);
 	if (++session.nr_probe == MAX_PROBES)
 		semantic_error("Too many probes");
 
@@ -101,7 +103,7 @@ static int parse_probepoint(const struct option *opt __used,
 				die("strndup");
 			if (++argc == MAX_PROBE_ARGS)
 				semantic_error("Too many arguments");
-			debug("argv[%d]=%s\n", argc, argv[argc - 1]);
+			eprintf("argv[%d]=%s\n", argc, argv[argc - 1]);
 		}
 	} while (*str != '\0');
 	if (argc < 2)
@@ -131,7 +133,7 @@ static int parse_probepoint(const struct option *opt __used,
 		pp->line = atoi(ptr);
 		if (!pp->file || !pp->line)
 			semantic_error("Failed to parse line.");
-		debug("file:%s line:%d\n", pp->file, pp->line);
+		eprintf("file:%s line:%d\n", pp->file, pp->line);
 	} else {
 		/* Function name */
 		ptr = strchr(arg, '+');
@@ -148,7 +150,7 @@ static int parse_probepoint(const struct option *opt __used,
 			pp->file = strdup(ptr);
 		}
 		pp->function = strdup(arg);
-		debug("symbol:%s file:%s offset:%d\n",
+		eprintf("symbol:%s file:%s offset:%d\n",
 		      pp->function, pp->file, pp->offset);
 	}
 	free(argv[1]);
@@ -173,7 +175,7 @@ static int parse_probepoint(const struct option *opt __used,
 			session.need_dwarf = 1;
 		}
 
-	debug("%d arguments\n", pp->nr_args);
+	eprintf("%d arguments\n", pp->nr_args);
 	return 0;
 }
 
@@ -186,7 +188,7 @@ static int open_default_vmlinux(void)
 
 	ret = uname(&uts);
 	if (ret) {
-		debug("uname() failed.\n");
+		eprintf("uname() failed.\n");
 		return -errno;
 	}
 	session.release = uts.release;
@@ -194,11 +196,12 @@ static int open_default_vmlinux(void)
 		ret = snprintf(fname, MAX_PATH_LEN,
 			       default_search_path[i], session.release);
 		if (ret >= MAX_PATH_LEN || ret < 0) {
-			debug("Filename(%d,%s) is too long.\n", i, uts.release);
+			eprintf("Filename(%d,%s) is too long.\n", i,
+				uts.release);
 			errno = E2BIG;
 			return -E2BIG;
 		}
-		debug("try to open %s\n", fname);
+		eprintf("try to open %s\n", fname);
 		fd = open(fname, O_RDONLY);
 		if (fd >= 0)
 			break;
@@ -213,6 +216,8 @@ static const char * const probe_usage[] = {
 };
 
 static const struct option options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show parsed arguments, etc)"),
 #ifndef NO_LIBDWARF
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
@@ -336,7 +341,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		ret = find_probepoint(fd, pp);
 		if (ret <= 0)
 			die("No probe point found.\n");
-		debug("probe event %s found\n", session.events[j]);
+		eprintf("probe event %s found\n", session.events[j]);
 	}
 	close(fd);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 338fdb9..db24c91 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -32,6 +32,8 @@
 #include <stdarg.h>
 #include <ctype.h>
 
+#include "event.h"
+#include "debug.h"
 #include "util.h"
 #include "probe-finder.h"
 
@@ -134,7 +136,7 @@ static Dwarf_Unsigned die_get_fileno(Dwarf_Die cu_die, const char *fname)
 		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
 	}
 	if (found)
-		debug("found fno: %d\n", (int)found);
+		eprintf("found fno: %d\n", (int)found);
 	return found;
 }
 
@@ -440,7 +442,7 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 		return ;
 	}
 
-	debug("Searching '%s' variable in context.\n", pf->var);
+	eprintf("Searching '%s' variable in context.\n", pf->var);
 	/* Search child die for local variables and parameters. */
 	ret = search_die_from_children(sp_die, variable_callback, pf);
 	if (!ret)
@@ -550,7 +552,7 @@ static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
 
 		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
 		ERR_IF(ret != DW_DLV_OK);
-		debug("Probe point found: 0x%llx\n", addr);
+		eprintf("Probe point found: 0x%llx\n", addr);
 		pf->addr = addr;
 		/* Search a real subprogram including this line, */
 		ret = search_die_from_children(cu_die, probeaddr_callback, pf);
@@ -581,7 +583,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 							  &pf->inl_offs,
 							  &__dw_error);
 				ERR_IF(ret != DW_DLV_OK);
-				debug("inline definition offset %lld\n",
+				eprintf("inline definition offset %lld\n",
 					pf->inl_offs);
 				return 0;
 			}
@@ -597,7 +599,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 			/* Get probe address */
 			pf->addr = die_get_entrypc(dlink->die);
 			pf->addr += pp->offset;
-			debug("found inline addr: 0x%llx\n", pf->addr);
+			eprintf("found inline addr: 0x%llx\n", pf->addr);
 			/* Inlined function. Get a real subprogram */
 			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
 				tag = 0;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 306810c..6a7cb0c 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -4,13 +4,6 @@
 #define _stringify(n)	#n
 #define stringify(n)	_stringify(n)
 
-#ifdef DEBUG
-#define debug(fmt ...)	\
-	fprintf(stderr, "DBG(" __FILE__ ":" stringify(__LINE__) "): " fmt)
-#else
-#define debug(fmt ...)	do {} while (0)
-#endif
-
 #define ERR_IF(cnd)	\
 	do { if (cnd) {	\
 		fprintf(stderr, "Error (" __FILE__ ":" stringify(__LINE__) \
