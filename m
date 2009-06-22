Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbZFVUvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbZFVUvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFVUvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:51:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZFVUvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:51:07 -0400
Subject: [PATCH -tip] perf_counter tool: builtin-stat add more events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 02:20:23 +0530
Message-Id: <1245703823.6167.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added more events not it looks like on AMD box :

./perf stat -- ls -lR  > /dev/null

 Performance counter stats for 'ls -lR':

     2507744774  cycles                                      #   2085.473 M/sec  (scaled from 13.28%)
     1515534968  instructions                                #      0.604 IPC    (scaled from 13.28%)
      783181797  cache-references                            #    651.304 M/sec  (scaled from 36.36%)
       18089523  cache-misses                                #     15.043 M/sec  (scaled from 36.37%)
      195550613  branches                                    #    162.622 M/sec  (scaled from 36.29%)
       14623394  branch-misses                               #     12.161 M/sec  (scaled from 36.29%)
  <not counted>  bus-cycles          
    1203.182949  cpu-clock-msecs                            
    1202.482671  task-clock-msecs                            #      0.990 CPUs 
            454  page-faults                                 #      0.000 M/sec
            454  minor-faults                                #      0.000 M/sec
              0  major-faults                                #      0.000 M/sec
            133  context-switches                            #      0.000 M/sec
              1  CPU-migrations                              #      0.000 M/sec
      744421154  L1-data-Cache-Load-Referencees              #    619.070 M/sec  (scaled from 13.20%)
        5220656  L1-data-Cache-Load-Misses                   #      4.342 M/sec  (scaled from 13.28%)
         438576  L1-data-Cache-Store-Referencees             #      0.365 M/sec  (scaled from 13.36%)
  <not counted>  L1-data-Cache-Store-Misses
        1976596  L1-data-Cache-Prefetch-Referencees          #      1.644 M/sec  (scaled from 13.44%)
        1644021  L1-data-Cache-Prefetch-Misses               #      1.367 M/sec  (scaled from 13.52%)
      764273224  L1-instruction-Cache-Load-Referencees       #    635.579 M/sec  (scaled from 13.53%)
       17242789  L1-instruction-Cache-Load-Misses            #     14.339 M/sec  (scaled from 13.53%)
  <not counted>  L1-instruction-Cache-Store-Referencees
  <not counted>  L1-instruction-Cache-Store-Misses
         372621  L1-instruction-Cache-Prefetch-Referencees   #      0.310 M/sec  (scaled from 13.53%)
  <not counted>  L1-instruction-Cache-Prefetch-Misses
       22844109  L2-Cache-Load-Referencees                   #     18.997 M/sec  (scaled from 13.53%)
        2235733  L2-Cache-Load-Misses                        #      1.859 M/sec  (scaled from 13.53%)
       23949920  L2-Cache-Store-Referencees                  #     19.917 M/sec  (scaled from 13.46%)
  <not counted>  L2-Cache-Store-Misses
  <not counted>  L2-Cache-Prefetch-Referencees
  <not counted>  L2-Cache-Prefetch-Misses
      732364670  Data-TLB-Cache-Load-Referencees             #    609.044 M/sec  (scaled from 13.45%)
       16516548  Data-TLB-Cache-Load-Misses                  #     13.735 M/sec  (scaled from 13.42%)
  <not counted>  Data-TLB-Cache-Store-Referencees
  <not counted>  Data-TLB-Cache-Store-Misses
  <not counted>  Data-TLB-Cache-Prefetch-Referencees
  <not counted>  Data-TLB-Cache-Prefetch-Misses
      766865920  Instruction-TLB-Cache-Load-Referencees      #    637.736 M/sec  (scaled from 13.42%)
          19981  Instruction-TLB-Cache-Load-Misses           #      0.017 M/sec  (scaled from 13.40%)
  <not counted>  Instruction-TLB-Cache-Store-Referencees
  <not counted>  Instruction-TLB-Cache-Store-Misses
  <not counted>  Instruction-TLB-Cache-Prefetch-Referencees
  <not counted>  Instruction-TLB-Cache-Prefetch-Misses
      308272002  Branch-Cache-Load-Referencees               #    256.363 M/sec  (scaled from 13.33%)
       19226358  Branch-Cache-Load-Misses                    #     15.989 M/sec  (scaled from 13.28%)
  <not counted>  Branch-Cache-Store-Referencees
  <not counted>  Branch-Cache-Store-Misses
  <not counted>  Branch-Cache-Prefetch-Referencees
  <not counted>  Branch-Cache-Prefetch-Misses

    1.214877275  seconds time elapsed.


Fix alignment, style problems and remove dead code

Increase limit for event_name() display

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |  111 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 84 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6d3eeac..a8b31f8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -32,6 +32,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -45,32 +46,94 @@
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
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
+#define CHCACHE(x, y, z)						\
+.type = PERF_TYPE_HW_CACHE,						\
+.config = (PERF_COUNT_HW_CACHE_##x | (PERF_COUNT_HW_CACHE_OP_##y << 8) |\
+	   (PERF_COUNT_HW_CACHE_RESULT_##z << 16))
+
+static struct perf_counter_attr default_attrs[] = {
+
+/* Generalized Hardware events				*/
+  { CHW(CPU_CYCLES)					},
+  { CHW(INSTRUCTIONS)					},
+  { CHW(CACHE_REFERENCES)				},
+  { CHW(CACHE_MISSES)					},
+  { CHW(BRANCH_INSTRUCTIONS)				},
+  { CHW(BRANCH_MISSES)					},
+  { CHW(BUS_CYCLES)					},
+
+/* Generalized Software events				*/
+  { CSW(CPU_CLOCK)					},
+  { CSW(TASK_CLOCK)					},
+  { CSW(PAGE_FAULTS)					},
+  { CSW(PAGE_FAULTS_MIN)				},
+  { CSW(PAGE_FAULTS_MAJ)				},
+  { CSW(CONTEXT_SWITCHES)				},
+  { CSW(CPU_MIGRATIONS)					},
+
+/* Generalized Hardware cache counters events		*/
+  { CHCACHE(L1D,	READ,		ACCESS)		},
+  { CHCACHE(L1D,	READ,		MISS)		},
+  { CHCACHE(L1D,	WRITE,		ACCESS)		},
+  { CHCACHE(L1D,	WRITE,		MISS)		},
+  { CHCACHE(L1D,	PREFETCH,	ACCESS)         },
+  { CHCACHE(L1D,	PREFETCH,	MISS)		},
+
+  { CHCACHE(L1I,	READ,		ACCESS)		},
+  { CHCACHE(L1I,	READ,		MISS)		},
+  { CHCACHE(L1I,	WRITE,		ACCESS)		},
+  { CHCACHE(L1I,	WRITE,		MISS)		},
+  { CHCACHE(L1I,	PREFETCH,	ACCESS)         },
+  { CHCACHE(L1I,	PREFETCH,	MISS)		},
+
+  { CHCACHE(LL,		READ,		ACCESS)		},
+  { CHCACHE(LL,		READ,		MISS)		},
+  { CHCACHE(LL,		WRITE,		ACCESS)		},
+  { CHCACHE(LL,		WRITE,		MISS)		},
+  { CHCACHE(LL,		PREFETCH,	ACCESS)         },
+  { CHCACHE(LL,		PREFETCH,	MISS)		},
+
+  { CHCACHE(DTLB,	READ,		ACCESS)		},
+  { CHCACHE(DTLB,	READ,		MISS)		},
+  { CHCACHE(DTLB,	WRITE,		ACCESS)		},
+  { CHCACHE(DTLB,	WRITE,		MISS)		},
+  { CHCACHE(DTLB,	PREFETCH,	ACCESS)         },
+  { CHCACHE(DTLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(ITLB,	READ,		ACCESS)		},
+  { CHCACHE(ITLB,	READ,		MISS)		},
+  { CHCACHE(ITLB,	WRITE,		ACCESS)		},
+  { CHCACHE(ITLB,	WRITE,		MISS)		},
+  { CHCACHE(ITLB,	PREFETCH,	ACCESS)         },
+  { CHCACHE(ITLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(BPU,	READ,		ACCESS)		},
+  { CHCACHE(BPU,	READ,		MISS)		},
+  { CHCACHE(BPU,	WRITE,		ACCESS)		},
+  { CHCACHE(BPU,	WRITE,		MISS)		},
+  { CHCACHE(BPU,	PREFETCH,	ACCESS)         },
+  { CHCACHE(BPU,	PREFETCH,	MISS)		},
 
 };
 
-static int			system_wide			=  0;
-static int			inherit				=  1;
-static int			verbose				=  0;
+#define MAX_RUN 100
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static int			target_pid			= -1;
+static int			system_wide			=  0;
 static int			nr_cpus				=  0;
-static unsigned int		page_size;
+static int			verbose				=  0;
+static int			run_idx				=  0;
 
+static int			run_count			=  1;
+static int			target_pid			= -1;
+static int			inherit				=  1;
 static int			scale				=  1;
 
+static unsigned int		page_size;
+
 static const unsigned int default_count[] = {
 	1000000,
 	1000000,
@@ -80,17 +143,11 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
-#define MAX_RUN 100
 
-static int			run_count		=  1;
-static int			run_idx			=  0;
 
 static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
 static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
 
-//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
-
-
 static u64			runtime_nsecs[MAX_RUN];
 static u64			walltime_nsecs[MAX_RUN];
 static u64			runtime_cycles[MAX_RUN];
@@ -119,7 +176,7 @@ static void create_perf_stat_counter(int counter)
 
 	if (system_wide) {
 		int cpu;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
 			if (fd[cpu][counter] < 0 && verbose) {
 				printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[cpu][counter], strerror(errno));
@@ -168,7 +225,7 @@ static void read_counter(int counter)
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
-	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (fd[cpu][counter] < 0)
 			continue;
 
@@ -262,7 +319,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
-	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+	fprintf(stderr, " %14.6f  %-43s", msecs, event_name(counter));
 
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
@@ -276,7 +333,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 static void abs_printout(int counter, u64 *count, u64 *noise)
 {
-	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+	fprintf(stderr, " %14Ld  %-43s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
@@ -491,7 +548,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 		usage_with_options(stat_usage, options);
 
 	if (!nr_counters)
-		nr_counters = 8;
+		nr_counters = ARRAY_SIZE(default_attrs);
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
-- 
1.6.0.6



