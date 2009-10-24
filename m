Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZJXBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZJXBH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZJXBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:07:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZJXBEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:49 -0400
Date: Sat, 24 Oct 2009 01:04:05 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1256153646-10097-1-git-send-email-acme@redhat.com>
References: <1256153646-10097-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf probe: Print debug messages using pr_*()
Message-ID: <tip-b7cb10e790fbd145296e771f789273a875c15719@git.kernel.org>
Git-Commit-ID: b7cb10e790fbd145296e771f789273a875c15719
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7cb10e790fbd145296e771f789273a875c15719
Gitweb:     http://git.kernel.org/tip/b7cb10e790fbd145296e771f789273a875c15719
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 21 Oct 2009 17:34:06 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 08:24:21 +0200

perf probe: Print debug messages using pr_*()

Use the new pr_{err,warning,debug,etc} printout methods, just
like in the kernel.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256153646-10097-1-git-send-email-acme@redhat.com>
[ Split this patch out, to keep perf/probes separate. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   20 ++++++++++----------
 tools/perf/util/probe-finder.c |   12 ++++++------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index b5ad86a..dcb406c 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -78,7 +78,7 @@ static int parse_probepoint(const struct option *opt __used,
 	if (!str)	/* The end of probe points */
 		return 0;
 
-	eprintf("probe-definition(%d): %s\n", session.nr_probe, str);
+	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);
 	if (++session.nr_probe == MAX_PROBES)
 		semantic_error("Too many probes");
 
@@ -103,7 +103,7 @@ static int parse_probepoint(const struct option *opt __used,
 				die("strndup");
 			if (++argc == MAX_PROBE_ARGS)
 				semantic_error("Too many arguments");
-			eprintf("argv[%d]=%s\n", argc, argv[argc - 1]);
+			pr_debug("argv[%d]=%s\n", argc, argv[argc - 1]);
 		}
 	} while (*str != '\0');
 	if (argc < 2)
@@ -133,7 +133,7 @@ static int parse_probepoint(const struct option *opt __used,
 		pp->line = atoi(ptr);
 		if (!pp->file || !pp->line)
 			semantic_error("Failed to parse line.");
-		eprintf("file:%s line:%d\n", pp->file, pp->line);
+		pr_debug("file:%s line:%d\n", pp->file, pp->line);
 	} else {
 		/* Function name */
 		ptr = strchr(arg, '+');
@@ -150,8 +150,8 @@ static int parse_probepoint(const struct option *opt __used,
 			pp->file = strdup(ptr);
 		}
 		pp->function = strdup(arg);
-		eprintf("symbol:%s file:%s offset:%d\n",
-		      pp->function, pp->file, pp->offset);
+		pr_debug("symbol:%s file:%s offset:%d\n",
+			 pp->function, pp->file, pp->offset);
 	}
 	free(argv[1]);
 	if (pp->file)
@@ -175,7 +175,7 @@ static int parse_probepoint(const struct option *opt __used,
 			session.need_dwarf = 1;
 		}
 
-	eprintf("%d arguments\n", pp->nr_args);
+	pr_debug("%d arguments\n", pp->nr_args);
 	return 0;
 }
 
@@ -188,7 +188,7 @@ static int open_default_vmlinux(void)
 
 	ret = uname(&uts);
 	if (ret) {
-		eprintf("uname() failed.\n");
+		pr_debug("uname() failed.\n");
 		return -errno;
 	}
 	session.release = uts.release;
@@ -196,12 +196,12 @@ static int open_default_vmlinux(void)
 		ret = snprintf(fname, MAX_PATH_LEN,
 			       default_search_path[i], session.release);
 		if (ret >= MAX_PATH_LEN || ret < 0) {
-			eprintf("Filename(%d,%s) is too long.\n", i,
+			pr_debug("Filename(%d,%s) is too long.\n", i,
 				uts.release);
 			errno = E2BIG;
 			return -E2BIG;
 		}
-		eprintf("try to open %s\n", fname);
+		pr_debug("try to open %s\n", fname);
 		fd = open(fname, O_RDONLY);
 		if (fd >= 0)
 			break;
@@ -341,7 +341,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		ret = find_probepoint(fd, pp);
 		if (ret <= 0)
 			die("No probe point found.\n");
-		eprintf("probe event %s found\n", session.events[j]);
+		pr_debug("probe event %s found\n", session.events[j]);
 	}
 	close(fd);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index be997ab..54e7071 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -136,7 +136,7 @@ static Dwarf_Unsigned die_get_fileno(Dwarf_Die cu_die, const char *fname)
 		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
 	}
 	if (found)
-		eprintf("found fno: %d\n", (int)found);
+		pr_debug("found fno: %d\n", (int)found);
 	return found;
 }
 
@@ -442,7 +442,7 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 		return ;
 	}
 
-	eprintf("Searching '%s' variable in context.\n", pf->var);
+	pr_debug("Searching '%s' variable in context.\n", pf->var);
 	/* Search child die for local variables and parameters. */
 	ret = search_die_from_children(sp_die, variable_callback, pf);
 	if (!ret)
@@ -552,7 +552,7 @@ static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
 
 		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
 		DIE_IF(ret != DW_DLV_OK);
-		eprintf("Probe point found: 0x%llx\n", addr);
+		pr_debug("Probe point found: 0x%llx\n", addr);
 		pf->addr = addr;
 		/* Search a real subprogram including this line, */
 		ret = search_die_from_children(cu_die, probeaddr_callback, pf);
@@ -583,8 +583,8 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 							  &pf->inl_offs,
 							  &__dw_error);
 				DIE_IF(ret != DW_DLV_OK);
-				eprintf("inline definition offset %lld\n",
-					pf->inl_offs);
+				pr_debug("inline definition offset %lld\n",
+					 pf->inl_offs);
 				return 0;
 			}
 			/* Get probe address */
@@ -599,7 +599,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 			/* Get probe address */
 			pf->addr = die_get_entrypc(dlink->die);
 			pf->addr += pp->offset;
-			eprintf("found inline addr: 0x%llx\n", pf->addr);
+			pr_debug("found inline addr: 0x%llx\n", pf->addr);
 			/* Inlined function. Get a real subprogram */
 			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
 				tag = 0;
