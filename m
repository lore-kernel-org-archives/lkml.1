Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZGAKz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZGAKz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZGAKzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:55:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:33545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZGAKzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:55:44 -0400
Date: Wed, 1 Jul 2009 10:55:00 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Add more warnings and fix/annotate them
Message-ID: <tip-f37a291c527c954df4da568de718ebb36b8261c0@git.kernel.org>
Git-Commit-ID: f37a291c527c954df4da568de718ebb36b8261c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 10:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f37a291c527c954df4da568de718ebb36b8261c0
Gitweb:     http://git.kernel.org/tip/f37a291c527c954df4da568de718ebb36b8261c0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 1 Jul 2009 12:37:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 12:49:48 +0200

perf_counter tools: Add more warnings and fix/annotate them

Enable -Wextra. This found a few real bugs plus a number
of signed/unsigned type mismatches/uncleanlinesses. It
also required a few annotations

All things considered it was still worth it so lets try with
this enabled for now.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile             |    2 +-
 tools/perf/builtin-annotate.c   |   12 +++++-----
 tools/perf/builtin-help.c       |    6 +++-
 tools/perf/builtin-list.c       |    2 +-
 tools/perf/builtin-record.c     |    4 +-
 tools/perf/builtin-report.c     |   22 +++++++++---------
 tools/perf/builtin-stat.c       |   18 ++++++++------
 tools/perf/builtin-top.c        |    8 +++---
 tools/perf/perf.c               |    5 +---
 tools/perf/perf.h               |    2 +
 tools/perf/util/alias.c         |    2 +-
 tools/perf/util/cache.h         |    1 +
 tools/perf/util/callchain.c     |   15 ++++++------
 tools/perf/util/callchain.h     |   10 ++++----
 tools/perf/util/color.c         |   10 ++++++--
 tools/perf/util/config.c        |   18 ++++++++------
 tools/perf/util/exec_cmd.c      |    5 +++-
 tools/perf/util/help.c          |   26 ++++++++++++---------
 tools/perf/util/help.h          |    6 ++--
 tools/perf/util/parse-events.c  |    2 +-
 tools/perf/util/parse-options.c |    2 +-
 tools/perf/util/parse-options.h |   25 ++++++++++-----------
 tools/perf/util/quote.c         |   46 +++++++++++++++++++++-----------------
 tools/perf/util/quote.h         |    2 +-
 tools/perf/util/strbuf.c        |   13 ++++++-----
 tools/perf/util/strbuf.h        |   10 ++++----
 tools/perf/util/wrapper.c       |    5 ++-
 27 files changed, 151 insertions(+), 128 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f572c90..eddf076 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -164,7 +164,7 @@ endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 722c0f5..6cba70d 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -160,7 +160,7 @@ static void dsos__fprintf(FILE *fp)
 
 static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
-	return dso__find_symbol(kernel_dso, ip);
+	return dso__find_symbol(dso, ip);
 }
 
 static int load_kernel(void)
@@ -203,7 +203,7 @@ static u64 map__map_ip(struct map *map, u64 ip)
 	return ip - map->start + map->pgoff;
 }
 
-static u64 vdso__map_ip(struct map *map, u64 ip)
+static u64 vdso__map_ip(struct map *map __used, u64 ip)
 {
 	return ip;
 }
@@ -600,7 +600,7 @@ static LIST_HEAD(hist_entry__sort_list);
 
 static int sort_dimension__add(char *tok)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
@@ -1069,7 +1069,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
-	u64 line_ip;
+	s64 line_ip;
 	int ret;
 	char *c;
 
@@ -1428,7 +1428,7 @@ more:
 
 	head += size;
 
-	if (offset + head < stat.st_size)
+	if (offset + head < (unsigned long)stat.st_size)
 		goto more;
 
 	rc = EXIT_SUCCESS;
@@ -1492,7 +1492,7 @@ static void setup_sorting(void)
 	free(str);
 }
 
-int cmd_annotate(int argc, const char **argv, const char *prefix)
+int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
 
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 0f32dc3..2599d86 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -3,6 +3,7 @@
  *
  * Builtin help command
  */
+#include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
@@ -277,7 +278,7 @@ static struct cmdnames main_cmds, other_cmds;
 
 void list_common_cmds_help(void)
 {
-	int i, longest = 0;
+	unsigned int i, longest = 0;
 
 	for (i = 0; i < ARRAY_SIZE(common_cmds); i++) {
 		if (longest < strlen(common_cmds[i].name))
@@ -415,9 +416,10 @@ static void show_html_page(const char *perf_cmd)
 	open_html(page_path.buf);
 }
 
-int cmd_help(int argc, const char **argv, const char *prefix)
+int cmd_help(int argc, const char **argv, const char *prefix __used)
 {
 	const char *alias;
+
 	load_command_list("perf-", &main_cmds, &other_cmds);
 
 	perf_config(perf_help_config, NULL);
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index fe60e37..f990fa8 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -13,7 +13,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
-int cmd_list(int argc, const char **argv, const char *prefix)
+int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
 {
 	print_events();
 	return 0;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d18546f..4ef78a5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -294,7 +294,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
 		struct mmap_event mmap_ev = {
-			.header.type = PERF_EVENT_MMAP,
+			.header = { .type = PERF_EVENT_MMAP },
 		};
 		int n;
 		size_t size;
@@ -650,7 +650,7 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_record(int argc, const char **argv, const char *prefix)
+int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7d2b49a..007363d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -177,7 +177,7 @@ static void dsos__fprintf(FILE *fp)
 
 static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
-	return dso__find_symbol(kernel_dso, ip);
+	return dso__find_symbol(dso, ip);
 }
 
 static int load_kernel(void)
@@ -239,7 +239,7 @@ static u64 map__map_ip(struct map *map, u64 ip)
 	return ip - map->start + map->pgoff;
 }
 
-static u64 vdso__map_ip(struct map *map, u64 ip)
+static u64 vdso__map_ip(struct map *map __used, u64 ip)
 {
 	return ip;
 }
@@ -712,7 +712,7 @@ static LIST_HEAD(hist_entry__sort_list);
 
 static int sort_dimension__add(char *tok)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
@@ -801,7 +801,7 @@ callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
 			ret += fprintf(fp, "                %s\n", chain->sym->name);
 		else
 			ret += fprintf(fp, "                %p\n",
-					(void *)chain->ip);
+					(void *)(long)chain->ip);
 	}
 
 	return ret;
@@ -938,12 +938,12 @@ static int call__match(struct symbol *sym)
 }
 
 static struct symbol **
-resolve_callchain(struct thread *thread, struct map *map,
+resolve_callchain(struct thread *thread, struct map *map __used,
 		    struct ip_callchain *chain, struct hist_entry *entry)
 {
-	int i;
-	struct symbol **syms;
 	u64 context = PERF_CONTEXT_MAX;
+	struct symbol **syms;
+	unsigned int i;
 
 	if (callchain) {
 		syms = calloc(chain->nr, sizeof(*syms));
@@ -1183,7 +1183,7 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 
 	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int i;
+		unsigned int i;
 
 		if (exclude_other && (se == &sort_parent))
 			continue;
@@ -1271,7 +1271,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(long long)period);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		int i;
+		unsigned int i;
 
 		chain = (void *)more_data;
 
@@ -1667,7 +1667,7 @@ more:
 	if (offset + head >= header->data_offset + header->data_size)
 		goto done;
 
-	if (offset + head < stat.st_size)
+	if (offset + head < (unsigned long)stat.st_size)
 		goto more;
 
 done:
@@ -1756,7 +1756,7 @@ static void setup_list(struct strlist **list, const char *list_str,
 	}
 }
 
-int cmd_report(int argc, const char **argv, const char *prefix)
+int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e03524..095a90e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,7 +64,7 @@ static struct perf_counter_attr default_attrs[] = {
 
 static int			system_wide			=  0;
 static int			verbose				=  0;
-static int			nr_cpus				=  0;
+static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
@@ -108,7 +108,8 @@ static void create_perf_stat_counter(int counter, int pid)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
-		int cpu;
+		unsigned int cpu;
+
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
 			if (fd[cpu][counter] < 0 && verbose)
@@ -150,8 +151,8 @@ static inline int nsec_counter(int counter)
 static void read_counter(int counter)
 {
 	u64 *count, single_count[3];
-	ssize_t res;
-	int cpu, nv;
+	unsigned int cpu;
+	size_t res, nv;
 	int scaled;
 
 	count = event_res[run_idx][counter];
@@ -165,6 +166,7 @@ static void read_counter(int counter)
 
 		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
 		assert(res == nv * sizeof(u64));
+
 		close(fd[cpu][counter]);
 		fd[cpu][counter] = -1;
 
@@ -200,7 +202,7 @@ static void read_counter(int counter)
 		runtime_cycles[run_idx] = count[0];
 }
 
-static int run_perf_stat(int argc, const char **argv)
+static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
 	int status = 0;
@@ -390,7 +392,7 @@ static void calc_avg(void)
 				event_res_avg[j]+1, event_res[i][j]+1);
 			update_avg("counter/2", j,
 				event_res_avg[j]+2, event_res[i][j]+2);
-			if (event_scaled[i][j] != -1)
+			if (event_scaled[i][j] != (u64)-1)
 				update_avg("scaled", j,
 					event_scaled_avg + j, event_scaled[i]+j);
 			else
@@ -510,7 +512,7 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_stat(int argc, const char **argv, const char *prefix)
+int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	int status;
 
@@ -528,7 +530,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
+	assert((int)nr_cpus >= 0);
 
 	/*
 	 * We dont want to block the signals - that would cause
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0506cd6..5f5e7df 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -269,7 +269,7 @@ static void print_sym_table(void)
 	}
 }
 
-static void *display_thread(void *arg)
+static void *display_thread(void *arg __used)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 	int delay_msecs = delay_secs * 1000;
@@ -287,7 +287,7 @@ static void *display_thread(void *arg)
 }
 
 /* Tag samples to be skipped. */
-char *skip_symbols[] = {
+static const char *skip_symbols[] = {
 	"default_idle",
 	"cpu_idle",
 	"enter_idle",
@@ -426,7 +426,7 @@ static void process_event(u64 ip, int counter, int user)
 struct mmap_data {
 	int			counter;
 	void			*base;
-	unsigned int		mask;
+	int			mask;
 	unsigned int		prev;
 };
 
@@ -705,7 +705,7 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_top(int argc, const char **argv, const char *prefix)
+int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 4eb7259..c565678 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -229,9 +229,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 		use_pager = 1;
 	commit_pager_choice();
 
-	if (p->option & NEED_WORK_TREE)
-		/* setup_work_tree() */;
-
 	status = p->fn(argc, argv, prefix);
 	if (status)
 		return status & 0xff;
@@ -266,7 +263,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
 	};
-	int i;
+	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
 
 	if (sizeof(ext) > 1) {
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ce39419..27887c9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -52,6 +52,8 @@ static inline unsigned long long rdclock(void)
 #define __user
 #define asmlinkage
 
+#define __used		__attribute__((__unused__))
+
 #define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index 9b3dd2b..b8144e8 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -3,7 +3,7 @@
 static const char *alias_key;
 static char *alias_val;
 
-static int alias_lookup_cb(const char *k, const char *v, void *cb)
+static int alias_lookup_cb(const char *k, const char *v, void *cb __used)
 {
 	if (!prefixcmp(k, "alias.") && !strcmp(k+6, alias_key)) {
 		if (!v)
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 393d614..161d5f4 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -3,6 +3,7 @@
 
 #include "util.h"
 #include "strbuf.h"
+#include "../perf.h"
 
 #define PERF_DIR_ENVIRONMENT "PERF_DIR"
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 440db12..3dceabd 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -92,7 +92,7 @@ static void
 fill_node(struct callchain_node *node, struct ip_callchain *chain,
 	  int start, struct symbol **syms)
 {
-	int i;
+	unsigned int i;
 
 	for (i = start; i < chain->nr; i++) {
 		struct callchain_list *call;
@@ -135,7 +135,7 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 {
 	struct callchain_node *new;
 	struct list_head *old_tail;
-	int idx_total = idx_parents + idx_local;
+	unsigned int idx_total = idx_parents + idx_local;
 
 	/* split */
 	new = create_child(parent, true);
@@ -164,17 +164,18 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-	       int start, struct symbol **syms);
+	       unsigned int start, struct symbol **syms);
 
 static void
 __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
-			struct symbol **syms, int start)
+			struct symbol **syms, unsigned int start)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	list_for_each_entry(rnode, &root->children, brothers) {
-		int ret = __append_chain(rnode, chain, start, syms);
+		unsigned int ret = __append_chain(rnode, chain, start, syms);
+
 		if (!ret)
 			return;
 	}
@@ -184,10 +185,10 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-	       int start, struct symbol **syms)
+	       unsigned int start, struct symbol **syms)
 {
 	struct callchain_list *cnode;
-	int i = start;
+	unsigned int i = start;
 	bool found = false;
 
 	/*
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index c942daa..251d99e 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -10,15 +10,15 @@
 struct callchain_node {
 	struct callchain_node	*parent;
 	struct list_head	brothers;
-	struct list_head 	children;
-	struct list_head 	val;
+	struct list_head	children;
+	struct list_head	val;
 	struct rb_node		rb_node;
-	int			val_nr;
-	int			hit;
+	unsigned int		val_nr;
+	u64			hit;
 };
 
 struct callchain_list {
-	unsigned long		ip;
+	u64			ip;
 	struct symbol		*sym;
 	struct list_head	list;
 };
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 9a8c20c..26f8231 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -11,7 +11,8 @@ static int parse_color(const char *name, int len)
 	};
 	char *end;
 	int i;
-	for (i = 0; i < ARRAY_SIZE(color_names); i++) {
+
+	for (i = 0; i < (int)ARRAY_SIZE(color_names); i++) {
 		const char *str = color_names[i];
 		if (!strncasecmp(name, str, len) && !str[len])
 			return i - 1;
@@ -28,7 +29,8 @@ static int parse_attr(const char *name, int len)
 	static const char * const attr_names[] = {
 		"bold", "dim", "ul", "blink", "reverse"
 	};
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
 		const char *str = attr_names[i];
 		if (!strncasecmp(name, str, len) && !str[len])
@@ -222,10 +224,12 @@ int color_fwrite_lines(FILE *fp, const char *color,
 {
 	if (!*color)
 		return fwrite(buf, count, 1, fp) != 1;
+
 	while (count) {
 		char *p = memchr(buf, '\n', count);
+
 		if (p != buf && (fputs(color, fp) < 0 ||
-				fwrite(buf, p ? p - buf : count, 1, fp) != 1 ||
+				fwrite(buf, p ? (size_t)(p - buf) : count, 1, fp) != 1 ||
 				fputs(PERF_COLOR_RESET, fp) < 0))
 			return -1;
 		if (!p)
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 3dd13fa..780df54 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -47,10 +47,12 @@ static int get_next_char(void)
 static char *parse_value(void)
 {
 	static char value[1024];
-	int quote = 0, comment = 0, len = 0, space = 0;
+	int quote = 0, comment = 0, space = 0;
+	size_t len = 0;
 
 	for (;;) {
 		int c = get_next_char();
+
 		if (len >= sizeof(value) - 1)
 			return NULL;
 		if (c == '\n') {
@@ -353,13 +355,13 @@ int perf_config_string(const char **dest, const char *var, const char *value)
 	return 0;
 }
 
-static int perf_default_core_config(const char *var, const char *value)
+static int perf_default_core_config(const char *var __used, const char *value __used)
 {
 	/* Add other config variables here and to Documentation/config.txt. */
 	return 0;
 }
 
-int perf_default_config(const char *var, const char *value, void *dummy)
+int perf_default_config(const char *var, const char *value, void *dummy __used)
 {
 	if (!prefixcmp(var, "core."))
 		return perf_default_core_config(var, value);
@@ -471,10 +473,10 @@ static int matches(const char* key, const char* value)
 		  !regexec(store.value_regex, value, 0, NULL, 0)));
 }
 
-static int store_aux(const char* key, const char* value, void *cb)
+static int store_aux(const char* key, const char* value, void *cb __used)
 {
+	int section_len;
 	const char *ep;
-	size_t section_len;
 
 	switch (store.state) {
 	case KEY_SEEN:
@@ -551,7 +553,7 @@ static int store_write_section(int fd, const char* key)
 		strbuf_addf(&sb, "[%.*s]\n", store.baselen, key);
 	}
 
-	success = write_in_full(fd, sb.buf, sb.len) == sb.len;
+	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
 	strbuf_release(&sb);
 
 	return success;
@@ -599,7 +601,7 @@ static int store_write_pair(int fd, const char* key, const char* value)
 		}
 	strbuf_addf(&sb, "%s\n", quote);
 
-	success = write_in_full(fd, sb.buf, sb.len) == sb.len;
+	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
 	strbuf_release(&sb);
 
 	return success;
@@ -741,7 +743,7 @@ int perf_config_set_multivar(const char* key, const char* value,
 	} else {
 		struct stat st;
 		char* contents;
-		size_t contents_sz, copy_begin, copy_end;
+		ssize_t contents_sz, copy_begin, copy_end;
 		int i, new_line = 0;
 
 		if (value_regex == NULL)
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index d392922..34a3528 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -1,6 +1,9 @@
 #include "cache.h"
 #include "exec_cmd.h"
 #include "quote.h"
+
+#include <string.h>
+
 #define MAX_ARGS	32
 
 extern char **environ;
@@ -51,7 +54,7 @@ const char *perf_extract_argv0_path(const char *argv0)
 		slash--;
 
 	if (slash >= argv0) {
-		argv0_path = strndup(argv0, slash - argv0);
+		argv0_path = xstrndup(argv0, slash - argv0);
 		return slash + 1;
 	}
 
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 17a00e0..fbb0097 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -26,7 +26,7 @@ static int term_columns(void)
 	return 80;
 }
 
-void add_cmdname(struct cmdnames *cmds, const char *name, int len)
+void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
 	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
 
@@ -40,7 +40,8 @@ void add_cmdname(struct cmdnames *cmds, const char *name, int len)
 
 static void clean_cmdnames(struct cmdnames *cmds)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < cmds->cnt; ++i)
 		free(cmds->names[i]);
 	free(cmds->names);
@@ -57,7 +58,7 @@ static int cmdname_compare(const void *a_, const void *b_)
 
 static void uniq(struct cmdnames *cmds)
 {
-	int i, j;
+	unsigned int i, j;
 
 	if (!cmds->cnt)
 		return;
@@ -71,7 +72,7 @@ static void uniq(struct cmdnames *cmds)
 
 void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 {
-	int ci, cj, ei;
+	size_t ci, cj, ei;
 	int cmp;
 
 	ci = cj = ei = 0;
@@ -106,8 +107,9 @@ static void pretty_print_string_list(struct cmdnames *cmds, int longest)
 		printf("  ");
 
 		for (j = 0; j < cols; j++) {
-			int n = j * rows + i;
-			int size = space;
+			unsigned int n = j * rows + i;
+			unsigned int size = space;
+
 			if (n >= cmds->cnt)
 				break;
 			if (j == cols-1 || n + rows >= cmds->cnt)
@@ -208,7 +210,7 @@ void load_command_list(const char *prefix,
 void list_commands(const char *title, struct cmdnames *main_cmds,
 		   struct cmdnames *other_cmds)
 {
-	int i, longest = 0;
+	unsigned int i, longest = 0;
 
 	for (i = 0; i < main_cmds->cnt; i++)
 		if (longest < main_cmds->names[i]->len)
@@ -239,7 +241,8 @@ void list_commands(const char *title, struct cmdnames *main_cmds,
 
 int is_in_cmdlist(struct cmdnames *c, const char *s)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < c->cnt; i++)
 		if (!strcmp(s, c->names[i]->name))
 			return 1;
@@ -271,7 +274,8 @@ static int levenshtein_compare(const void *p1, const void *p2)
 
 static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 {
-	int i;
+	unsigned int i;
+
 	ALLOC_GROW(cmds->names, cmds->cnt + old->cnt, cmds->alloc);
 
 	for (i = 0; i < old->cnt; i++)
@@ -283,7 +287,7 @@ static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 
 const char *help_unknown_cmd(const char *cmd)
 {
-	int i, n = 0, best_similarity = 0;
+	unsigned int i, n = 0, best_similarity = 0;
 	struct cmdnames main_cmds, other_cmds;
 
 	memset(&main_cmds, 0, sizeof(main_cmds));
@@ -345,7 +349,7 @@ const char *help_unknown_cmd(const char *cmd)
 	exit(1);
 }
 
-int cmd_version(int argc, const char **argv, const char *prefix)
+int cmd_version(int argc __used, const char **argv __used, const char *prefix __used)
 {
 	printf("perf version %s\n", perf_version_string);
 	return 0;
diff --git a/tools/perf/util/help.h b/tools/perf/util/help.h
index 56bc154..7128783 100644
--- a/tools/perf/util/help.h
+++ b/tools/perf/util/help.h
@@ -2,8 +2,8 @@
 #define HELP_H
 
 struct cmdnames {
-	int alloc;
-	int cnt;
+	size_t alloc;
+	size_t cnt;
 	struct cmdname {
 		size_t len; /* also used for similarity index in help.c */
 		char name[FLEX_ARRAY];
@@ -19,7 +19,7 @@ static inline void mput_char(char c, unsigned int num)
 void load_command_list(const char *prefix,
 		struct cmdnames *main_cmds,
 		struct cmdnames *other_cmds);
-void add_cmdname(struct cmdnames *cmds, const char *name, int len);
+void add_cmdname(struct cmdnames *cmds, const char *name, size_t len);
 /* Here we require that excludes is a sorted list. */
 void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes);
 int is_in_cmdlist(struct cmdnames *c, const char *s);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e6b83a3..aed7090 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -385,7 +385,7 @@ static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 	return 1;
 }
 
-int parse_events(const struct option *opt, const char *str, int unset)
+int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
 
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index b3affb1..9a897b7 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -485,7 +485,7 @@ int parse_options_usage(const char * const *usagestr,
 }
 
 
-int parse_opt_verbosity_cb(const struct option *opt, const char *arg,
+int parse_opt_verbosity_cb(const struct option *opt, const char *arg __used,
 			   int unset)
 {
 	int *target = opt->value;
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index a1039a6..15c8aba 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -90,21 +90,20 @@ struct option {
 	intptr_t defval;
 };
 
-#define OPT_END()                   { OPTION_END }
-#define OPT_ARGUMENT(l, h)          { OPTION_ARGUMENT, 0, (l), NULL, NULL, (h) }
-#define OPT_GROUP(h)                { OPTION_GROUP, 0, NULL, NULL, NULL, (h) }
-#define OPT_BIT(s, l, v, h, b)      { OPTION_BIT, (s), (l), (v), NULL, (h), 0, NULL, (b) }
-#define OPT_BOOLEAN(s, l, v, h)     { OPTION_BOOLEAN, (s), (l), (v), NULL, (h) }
-#define OPT_SET_INT(s, l, v, h, i)  { OPTION_SET_INT, (s), (l), (v), NULL, (h), 0, NULL, (i) }
-#define OPT_SET_PTR(s, l, v, h, p)  { OPTION_SET_PTR, (s), (l), (v), NULL, (h), 0, NULL, (p) }
-#define OPT_INTEGER(s, l, v, h)     { OPTION_INTEGER, (s), (l), (v), NULL, (h) }
-#define OPT_LONG(s, l, v, h)        { OPTION_LONG, (s), (l), (v), NULL, (h) }
-#define OPT_STRING(s, l, v, a, h)   { OPTION_STRING,  (s), (l), (v), (a), (h) }
+#define OPT_END()                   { .type = OPTION_END }
+#define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
+#define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
+#define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (b) }
+#define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
+#define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
+#define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
-	{ OPTION_CALLBACK, (s), (l), (v), "time",(h), 0, \
-	  parse_opt_approxidate_cb }
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
-	{ OPTION_CALLBACK, (s), (l), (v), (a), (h), 0, (f) }
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index f18c521..c6e5dc0 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -162,12 +162,16 @@ static inline int sq_must_quote(char c)
 	return sq_lookup[(unsigned char)c] + quote_path_fully > 0;
 }
 
-/* returns the longest prefix not needing a quote up to maxlen if positive.
-   This stops at the first \0 because it's marked as a character needing an
-   escape */
-static size_t next_quote_pos(const char *s, ssize_t maxlen)
+/*
+ * Returns the longest prefix not needing a quote up to maxlen if
+ * positive.
+ * This stops at the first \0 because it's marked as a character
+ * needing an escape.
+ */
+static ssize_t next_quote_pos(const char *s, ssize_t maxlen)
 {
-	size_t len;
+	ssize_t len;
+
 	if (maxlen < 0) {
 		for (len = 0; !sq_must_quote(s[len]); len++);
 	} else {
@@ -192,22 +196,22 @@ static size_t next_quote_pos(const char *s, ssize_t maxlen)
 static size_t quote_c_style_counted(const char *name, ssize_t maxlen,
                                     struct strbuf *sb, FILE *fp, int no_dq)
 {
-#undef EMIT
-#define EMIT(c)                                 \
-	do {                                        \
-		if (sb) strbuf_addch(sb, (c));          \
-		if (fp) fputc((c), fp);                 \
-		count++;                                \
+#define EMIT(c)							\
+	do {							\
+		if (sb) strbuf_addch(sb, (c));			\
+		if (fp) fputc((c), fp);				\
+		count++;					\
 	} while (0)
-#define EMITBUF(s, l)                           \
-	do {                                        \
-		int __ret;				\
-		if (sb) strbuf_add(sb, (s), (l));       \
-		if (fp) __ret = fwrite((s), (l), 1, fp);        \
-		count += (l);                           \
+
+#define EMITBUF(s, l)						\
+	do {							\
+		int __ret;					\
+		if (sb) strbuf_add(sb, (s), (l));		\
+		if (fp) __ret = fwrite((s), (l), 1, fp);	\
+		count += (l);					\
 	} while (0)
 
-	size_t len, count = 0;
+	ssize_t len, count = 0;
 	const char *p = name;
 
 	for (;;) {
@@ -273,8 +277,8 @@ void write_name_quoted(const char *name, FILE *fp, int terminator)
 	fputc(terminator, fp);
 }
 
-extern void write_name_quotedpfx(const char *pfx, size_t pfxlen,
-                                 const char *name, FILE *fp, int terminator)
+void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
+			  const char *name, FILE *fp, int terminator)
 {
 	int needquote = 0;
 
@@ -306,7 +310,7 @@ char *quote_path_relative(const char *in, int len,
 		len = strlen(in);
 
 	/* "../" prefix itself does not need quoting, but "in" might. */
-	needquote = next_quote_pos(in, len) < len;
+	needquote = (next_quote_pos(in, len) < len);
 	strbuf_setlen(out, 0);
 	strbuf_grow(out, len);
 
diff --git a/tools/perf/util/quote.h b/tools/perf/util/quote.h
index 5dfad89..a5454a1 100644
--- a/tools/perf/util/quote.h
+++ b/tools/perf/util/quote.h
@@ -53,7 +53,7 @@ extern size_t quote_c_style(const char *name, struct strbuf *, FILE *, int no_dq
 extern void quote_two_c_style(struct strbuf *, const char *, const char *, int);
 
 extern void write_name_quoted(const char *name, FILE *, int terminator);
-extern void write_name_quotedpfx(const char *pfx, size_t pfxlen,
+extern void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
                                  const char *name, FILE *, int terminator);
 
 /* quote path as relative to the given prefix */
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 464e7ca..5249d5a 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -16,7 +16,7 @@ int prefixcmp(const char *str, const char *prefix)
  */
 char strbuf_slopbuf[1];
 
-void strbuf_init(struct strbuf *sb, size_t hint)
+void strbuf_init(struct strbuf *sb, ssize_t hint)
 {
 	sb->alloc = sb->len = 0;
 	sb->buf = strbuf_slopbuf;
@@ -92,7 +92,8 @@ void strbuf_ltrim(struct strbuf *sb)
 
 void strbuf_tolower(struct strbuf *sb)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < sb->len; i++)
 		sb->buf[i] = tolower(sb->buf[i]);
 }
@@ -264,7 +265,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
 	return res;
 }
 
-ssize_t strbuf_read(struct strbuf *sb, int fd, size_t hint)
+ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 {
 	size_t oldlen = sb->len;
 	size_t oldalloc = sb->alloc;
@@ -293,7 +294,7 @@ ssize_t strbuf_read(struct strbuf *sb, int fd, size_t hint)
 
 #define STRBUF_MAXLINK (2*PATH_MAX)
 
-int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint)
+int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint)
 {
 	size_t oldalloc = sb->alloc;
 
@@ -301,7 +302,7 @@ int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint)
 		hint = 32;
 
 	while (hint < STRBUF_MAXLINK) {
-		int len;
+		ssize_t len;
 
 		strbuf_grow(sb, hint);
 		len = readlink(path, sb->buf, hint);
@@ -343,7 +344,7 @@ int strbuf_getline(struct strbuf *sb, FILE *fp, int term)
 	return 0;
 }
 
-int strbuf_read_file(struct strbuf *sb, const char *path, size_t hint)
+int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint)
 {
 	int fd, len;
 
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
index 9ee908a..d2aa86c 100644
--- a/tools/perf/util/strbuf.h
+++ b/tools/perf/util/strbuf.h
@@ -50,7 +50,7 @@ struct strbuf {
 #define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
 
 /*----- strbuf life cycle -----*/
-extern void strbuf_init(struct strbuf *, size_t);
+extern void strbuf_init(struct strbuf *buf, ssize_t hint);
 extern void strbuf_release(struct strbuf *);
 extern char *strbuf_detach(struct strbuf *, size_t *);
 extern void strbuf_attach(struct strbuf *, void *, size_t, size_t);
@@ -61,7 +61,7 @@ static inline void strbuf_swap(struct strbuf *a, struct strbuf *b) {
 }
 
 /*----- strbuf size related -----*/
-static inline size_t strbuf_avail(const struct strbuf *sb) {
+static inline ssize_t strbuf_avail(const struct strbuf *sb) {
 	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
 }
 
@@ -122,9 +122,9 @@ extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
 
 extern size_t strbuf_fread(struct strbuf *, size_t, FILE *);
 /* XXX: if read fails, any partial read is undone */
-extern ssize_t strbuf_read(struct strbuf *, int fd, size_t hint);
-extern int strbuf_read_file(struct strbuf *sb, const char *path, size_t hint);
-extern int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint);
+extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
+extern int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint);
+extern int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint);
 
 extern int strbuf_getline(struct strbuf *, FILE *, int);
 
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 6350d65..4574ac2 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -7,7 +7,7 @@
  * There's no pack memory to release - but stay close to the Git
  * version so wrap this away:
  */
-static inline void release_pack_memory(size_t size, int flag)
+static inline void release_pack_memory(size_t size __used, int flag __used)
 {
 }
 
@@ -59,7 +59,8 @@ void *xmemdupz(const void *data, size_t len)
 char *xstrndup(const char *str, size_t len)
 {
 	char *p = memchr(str, '\0', len);
-	return xmemdupz(str, p ? p - str : len);
+
+	return xmemdupz(str, p ? (size_t)(p - str) : len);
 }
 
 void *xrealloc(void *ptr, size_t size)
