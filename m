Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbZFMOtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbZFMOtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZFMOtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:49:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:49014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbZFMOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:49:21 -0400
Date: Sat, 13 Jun 2009 14:48:45 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1244844682-12928-2-git-send-email-fweisbec@gmail.com>
References: <1244844682-12928-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf annotate: Print a sorted summary of annotated overhead lines
Message-ID: <tip-971738f3669092dd247eaf89658f2685180492a0@git.kernel.org>
Git-Commit-ID: 971738f3669092dd247eaf89658f2685180492a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:48:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  971738f3669092dd247eaf89658f2685180492a0
Gitweb:     http://git.kernel.org/tip/971738f3669092dd247eaf89658f2685180492a0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 13 Jun 2009 00:11:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 12:58:23 +0200

perf annotate: Print a sorted summary of annotated overhead lines

It's can be very annoying to scroll down perf annotated output
until we find relevant overhead.

Using the -l option, you can now have a small summary sorted per
overhead in the beginning of the output.

Example:

./perf annotate -l -k ../../vmlinux -s __lock_acquire

Sorted summary for file ../../vmlinux
----------------------------------------------

   12.04 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653
    4.61 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1740
    3.77 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1775
    3.56 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653
    2.93 /home/fweisbec/linux/linux-2.6-tip/arch/x86/include/asm/irqflags.h:15
    2.83 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2545
    2.30 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2594
    2.20 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2388
    2.20 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
    2.09 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
    2.09 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:138
    1.88 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2548
    1.47 /home/fweisbec/linux/linux-2.6-tip/arch/x86/include/asm/irqflags.h:15
    1.36 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2594
    1.36 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
    1.26 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1654
    1.26 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653
    1.15 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2592
    1.15 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1740
    1.15 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1740

[...]

Only overhead over 0.5% are summarized.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1244844682-12928-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |  111 +++++++++++++++++++++++++++++++++--------
 1 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6a08da4..7a5b278 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,6 +25,10 @@
 #define SHOW_USER	2
 #define SHOW_HV		4
 
+#define MIN_GREEN		0.5
+#define MIN_RED		5.0
+
+
 static char		const *input_name = "perf.data";
 static char		*vmlinux = "vmlinux";
 
@@ -88,6 +92,7 @@ typedef union event_union {
 
 
 struct sym_ext {
+	struct rb_node	node;
 	double		percent;
 	char		*path;
 };
@@ -1038,6 +1043,24 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static char *get_color(double percent)
+{
+	char *color = PERF_COLOR_NORMAL;
+
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = PERF_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = PERF_COLOR_GREEN;
+	}
+	return color;
+}
+
 static int
 parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 {
@@ -1086,7 +1109,7 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 		const char *path = NULL;
 		unsigned int hits = 0;
 		double percent = 0.0;
-		char *color = PERF_COLOR_NORMAL;
+		char *color;
 		struct sym_ext *sym_ext = sym->priv;
 
 		offset = line_ip - start;
@@ -1099,17 +1122,7 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
-		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
-		 */
-		if (percent >= 5.0)
-			color = PERF_COLOR_RED;
-		else {
-			if (percent > 0.5)
-				color = PERF_COLOR_GREEN;
-		}
+		color = get_color(percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -1138,6 +1151,28 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 	return 0;
 }
 
+static struct rb_root root_sym_ext;
+
+static void insert_source_line(struct sym_ext *sym_ext)
+{
+	struct sym_ext *iter;
+	struct rb_node **p = &root_sym_ext.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct sym_ext, node);
+
+		if (sym_ext->percent > iter->percent)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&sym_ext->node, parent, p);
+	rb_insert_color(&sym_ext->node, &root_sym_ext);
+}
+
 static void free_source_line(struct symbol *sym, int len)
 {
 	struct sym_ext *sym_ext = sym->priv;
@@ -1151,6 +1186,7 @@ static void free_source_line(struct symbol *sym, int len)
 	free(sym_ext);
 
 	sym->priv = NULL;
+	root_sym_ext = RB_ROOT;
 }
 
 /* Get the filename:line for the colored entries */
@@ -1193,12 +1229,42 @@ static void get_source_line(struct symbol *sym, __u64 start, int len)
 			goto next;
 
 		strcpy(sym_ext[i].path, path);
+		insert_source_line(&sym_ext[i]);
 
 	next:
 		pclose(fp);
 	}
 }
 
+static void print_summary(char *filename)
+{
+	struct sym_ext *sym_ext;
+	struct rb_node *node;
+
+	printf("\nSorted summary for file %s\n", filename);
+	printf("----------------------------------------------\n\n");
+
+	if (RB_EMPTY_ROOT(&root_sym_ext)) {
+		printf(" Nothing higher than %1.1f%%\n", MIN_GREEN);
+		return;
+	}
+
+	node = rb_first(&root_sym_ext);
+	while (node) {
+		double percent;
+		char *color;
+		char *path;
+
+		sym_ext = rb_entry(node, struct sym_ext, node);
+		percent = sym_ext->percent;
+		color = get_color(percent);
+		path = sym_ext->path;
+
+		color_fprintf(stdout, color, " %7.2f %s", percent, path);
+		node = rb_next(node);
+	}
+}
+
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
 	char *filename = dso->name;
@@ -1211,13 +1277,6 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	if (dso == kernel_dso)
 		filename = vmlinux;
 
-	printf("\n------------------------------------------------\n");
-	printf(" Percent |	Source code & Disassembly of %s\n", filename);
-	printf("------------------------------------------------\n");
-
-	if (verbose >= 2)
-		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
-
 	start = sym->obj_start;
 	if (!start)
 		start = sym->start;
@@ -1225,8 +1284,17 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	end = start + sym->end - sym->start + 1;
 	len = sym->end - sym->start;
 
-	if (print_line)
+	if (print_line) {
 		get_source_line(sym, start, len);
+		print_summary(filename);
+	}
+
+	printf("\n\n------------------------------------------------\n");
+	printf(" Percent |	Source code & Disassembly of %s\n", filename);
+	printf("------------------------------------------------\n");
+
+	if (verbose >= 2)
+		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
 
 	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (__u64)start, (__u64)end, filename);
 
@@ -1243,7 +1311,8 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	}
 
 	pclose(file);
-	free_source_line(sym, len);
+	if (print_line)
+		free_source_line(sym, len);
 }
 
 static void find_annotations(void)
