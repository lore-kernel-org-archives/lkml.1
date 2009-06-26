Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZFZMj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZFZMj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbZFZMi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:38:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920AbZFZMi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:38:57 -0400
Subject: Re: [PATCH -tip] perf_counter tools: add support to set of
 multiple events in one short
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090626122553.GB10850@elte.hu>
References: <1245963764.10962.2.camel@hpdv5.satnam>
	 <1245968914.10962.12.camel@hpdv5.satnam>
	 <1246018957.2976.1.camel@hpdv5.satnam>  <20090626122553.GB10850@elte.hu>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 18:08:28 +0530
Message-Id: <1246019908.2976.7.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 14:25 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Fri, 2009-06-26 at 03:58 +0530, Jaswinder Singh Rajput wrote:
> > > On Fri, 2009-06-26 at 02:32 +0530, Jaswinder Singh Rajput wrote:
> > > > Add support for HARDWARE and SOFTWARE events :
> > > >  perf stat -e all-sw-events
> > > >  perf stat -e sw-events
> > > >  perf stat -e all-hw-events
> > > >  perf stat -e hw-events
> > > > 
> > > > On AMD box :
> > > > 
> > > > ./perf stat -e hw-events -e all-sw-events -- ls -lR > /dev/null
> > > > 
> > > >  Performance counter stats for 'ls -lR':
> > > > 
> > > >         9977353  cycles               #    557.193 M/sec  (scaled from 21.81%)
> > > >         4244800  instructions         #      0.425 IPC    (scaled from 27.51%)
> > > >         2953188  cache-references     #    164.923 M/sec  (scaled from 89.10%)
> > > >           72469  cache-misses         #      4.047 M/sec  (scaled from 89.13%)
> > > >          775760  branches             #     43.323 M/sec  (scaled from 89.10%)
> > > >           57814  branch-misses        #      3.229 M/sec  (scaled from 83.34%)
> > > >   <not counted>  bus-cycles
> > > >       17.970985  cpu-clock-msecs
> > > >       17.906460  task-clock-msecs     #      0.955 CPUs
> > > >             386  page-faults          #      0.022 M/sec
> > > >             386  minor-faults         #      0.022 M/sec
> > > >               0  major-faults         #      0.000 M/sec
> > > >               4  context-switches     #      0.000 M/sec
> > > >               1  CPU-migrations       #      0.000 M/sec
> > > > 
> > > >     0.018750671  seconds time elapsed.
> > > > 
> > > > Reported-by : Ingo Molnar <mingo@elte.hu>
> > > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > > ---
> > > >  tools/perf/util/parse-events.c |   66 ++++++++++++++++++++++++++++++++++++++-
> > > >  1 files changed, 64 insertions(+), 2 deletions(-)
> > > 
> > > Please treat :
> > >  [PATCH -tip] perf_counter tools: add support to set of multiple events in one short
> > > as 
> > >  [PATCH 1/2-tip] perf_counter tools: add support to set of multiple events in one short
> > > 
> > > And here is 2/2 :
> > > 
> > > [PATCH 2/2 -tip] perf_counter tools: Add support for all CACHE events
> > > 
> > > Add support for all CACHE events :
> > >  perf stat -e all-cache-events
> > >  perf stat -e cache-events
> > > 
> > > On AMD box (<not-counted> events are not available for AMD):
> > > 
> > > ./perf stat -e all-cache-events -- ls -lR /usr/include/ > /dev/null
> > > 
> > >  Performance counter stats for 'ls -lR /usr/include/':
> > > 
> > >       246370884  L1-d$-loads           (scaled from 23.55%)
> > >         1074018  L1-d$-load-misses     (scaled from 23.38%)
> > >          150708  L1-d$-stores          (scaled from 23.57%)
> > >   <not counted>  L1-d$-store-misses
> > >          428804  L1-d$-prefetches      (scaled from 23.47%)
> > >          314446  L1-d$-prefetch-misses  (scaled from 23.42%)
> > >       252626137  L1-i$-loads           (scaled from 23.24%)
> > >         3985110  L1-i$-load-misses     (scaled from 23.24%)
> > >           93754  L1-i$-prefetches      (scaled from 23.34%)
> > >   <not counted>  L1-i$-prefetch-misses
> > >         5202314  LLC-loads             (scaled from 23.34%)
> > >          525467  LLC-load-misses       (scaled from 23.25%)
> > >         5220558  LLC-stores            (scaled from 23.21%)
> > >   <not counted>  LLC-store-misses
> > >   <not counted>  LLC-prefetches
> > >   <not counted>  LLC-prefetch-misses
> > >       251954203  dTLB-loads            (scaled from 23.70%)
> > >         5297550  dTLB-load-misses      (scaled from 23.96%)
> > >   <not counted>  dTLB-stores
> > >   <not counted>  dTLB-store-misses
> > >   <not counted>  dTLB-prefetches
> > >   <not counted>  dTLB-prefetch-misses
> > >       248561524  iTLB-loads            (scaled from 24.15%)
> > >            4693  iTLB-load-misses      (scaled from 24.18%)
> > >       106992392  branch-loads          (scaled from 23.67%)
> > >         5239561  branch-load-misses    (scaled from 23.43%)
> > > 
> > >     0.395946903  seconds time elapsed.
> > > 
> > > Reported-by: Ingo Molnar <mingo@elte.hu>
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++++++++++++++---
> > >  1 files changed, 65 insertions(+), 5 deletions(-)
> > > 
> > 
> > 
> > If this looks OK then can I send following patches.
> 
> Would be nice to do the 'scaled' cleanup too that i suggested in the 
> other thread, plus size things so that there's no such lines:
> 
>           428804  L1-d$-prefetches      (scaled from 23.47%)
>           314446  L1-d$-prefetch-misses  (scaled from 23.42%)
> 
> if that's done then it would be nice to have a series submitted to 
> lkml with numbered patches and a 0/3 (or so) mail summarizing the 
> changes, and with each patch having code and commit log quality that 
> you can stand behind and which needs no modification from the 
> maintainers.
> 

In the mean time I also wrote another patch.

Please let me know which option is better then I will make it 4/4 :

Subject: [PATCH] perf stat: use set_multiple_events() to select default
events

Select SOFTWARE and HARDWARE events, if no event is selected.
this avoids replicating same arrays and reduce book-keeping

OR

[PATCH] perf stat: fix default attrs and nr_counters

memcpy(attrs, default_attrs, sizeof(attrs)) is only required
if no event is selected and only need to copy sizeof(default_attrs)

and set nr_counters as ARRAY_SIZE(default_attrs) in place of hardcoded value

Also make default_attrs table small and simple

Complete patches :

Subject: [PATCH] perf stat: use set_multiple_events() to select default events

Select SOFTWARE and HARDWARE events, if no event is selected.
this avoids replicating same arrays and reduce book-keeping

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c      |   58 ++++++++++++++++++---------------------
 tools/perf/util/parse-events.c |    2 +-
 tools/perf/util/parse-events.h |    2 +
 3 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8420ec5..ca68bb5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -4,23 +4,28 @@
  * Builtin stat command: Give a precise performance counters summary
  * overview about any workload, CPU or specific PID.
  *
- * Sample output:
+ * Sample output on AMD box (bus-cycles event is not available for AMD)
 
-   $ perf stat ~/hackbench 10
-   Time: 0.104
+ #./perf stat -- ls -lR /usr/include/ > /dev/null 
 
-    Performance counter stats for '/home/mingo/hackbench':
+ Performance counter stats for 'ls -lR /usr/include/':
 
-       1255.538611  task clock ticks     #      10.143 CPU utilization factor
-             54011  context switches     #       0.043 M/sec
-               385  CPU migrations       #       0.000 M/sec
-             17755  pagefaults           #       0.014 M/sec
-        3808323185  CPU cycles           #    3033.219 M/sec
-        1575111190  instructions         #    1254.530 M/sec
-          17367895  cache references     #      13.833 M/sec
-           7674421  cache misses         #       6.112 M/sec
+    1912.810168  cpu-clock-msecs
+    1903.386989  task-clock-msecs     #      0.362 CPUs 
+            440  page-faults          #      0.000 M/sec
+            440  minor-faults         #      0.000 M/sec
+              0  major-faults         #      0.000 M/sec
+           1876  context-switches     #      0.001 M/sec
+              1  CPU-migrations       #      0.000 M/sec
+      972932473  cycles               #    511.159 M/sec  (scaled from 31.42%)
+      588142134  instructions         #      0.605 IPC    (scaled from 30.98%)
+      287837533  cache-references     #    151.224 M/sec  (scaled from 83.54%)
+        7667661  cache-misses         #      4.028 M/sec  (scaled from 84.13%)
+       75792456  branches             #     39.820 M/sec  (scaled from 85.04%)
+        4457813  branch-misses        #      2.342 M/sec  (scaled from 84.89%)
+  <not counted>  bus-cycles
 
-    Wall-clock time elapsed:   123.786620 msecs
+    5.257401849  seconds time elapsed.
 
  *
  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
@@ -32,6 +37,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh Rajput <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -45,20 +51,6 @@
 #include <sys/prctl.h>
 #include <math.h>
 
-static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
-
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
-
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
-
-};
-
 #define MAX_RUN			100
 
 static int			system_wide			=  0;
@@ -468,16 +460,20 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	memcpy(attrs, default_attrs, sizeof(attrs));
-
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0 || run_count > MAX_RUN)
 		usage_with_options(stat_usage, options);
 
-	if (!nr_counters)
-		nr_counters = 8;
+	/*
+	 * By default select SOFTWARE and HARDWARE events,
+	 * if no event is selected
+	 */
+	if (!nr_counters) {
+		set_multiple_events(PERF_TYPE_SOFTWARE);
+		set_multiple_events(PERF_TYPE_HARDWARE);
+	}
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c1cd93e..eea71c5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -296,7 +296,7 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 	return 0;
 }
 
-static int set_multiple_events(unsigned int type)
+int set_multiple_events(unsigned int type)
 {
 	struct perf_counter_attr attr;
 	int i;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e3d5529..ca44465 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -9,6 +9,8 @@ extern struct perf_counter_attr attrs[MAX_COUNTERS];
 
 extern char *event_name(int ctr);
 
+extern int set_multiple_events(unsigned int type);
+
 extern int parse_events(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
-- 
1.6.0.6

OR

Subject: [PATCH] perf stat: fix default attrs and nr_counters

memcpy(attrs, default_attrs, sizeof(attrs)) is only required
if no event is selected and only need to copy sizeof(default_attrs)

and set nr_counters as ARRAY_SIZE(default_attrs) in place of hardcoded value

Also make default_attrs table small and simple

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8420ec5..e2b24f4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -32,6 +32,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh Rajput <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -45,17 +46,20 @@
 #include <sys/prctl.h>
 #include <math.h>
 
-static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
+static struct perf_counter_attr default_attrs[] = {
 
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
+  { CSW(TASK_CLOCK),						},
+  { CSW(CONTEXT_SWITCHES),					},
+  { CSW(CPU_MIGRATIONS),					},
+  { CSW(PAGE_FAULTS),						},
+
+  { CHW(CPU_CYCLES),						},
+  { CHW(INSTRUCTIONS),						},
+  { CHW(CACHE_REFERENCES),					},
+  { CHW(CACHE_MISSES),						},
 
 };
 
@@ -468,16 +472,17 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	memcpy(attrs, default_attrs, sizeof(attrs));
-
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0 || run_count > MAX_RUN)
 		usage_with_options(stat_usage, options);
 
-	if (!nr_counters)
-		nr_counters = 8;
+	/* Set default attrs if no event is selected */
+	if (!nr_counters) {
+		memcpy(attrs, default_attrs, sizeof(default_attrs));
+		nr_counters = ARRAY_SIZE(default_attrs);
+	}
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
-- 
1.6.0.6



