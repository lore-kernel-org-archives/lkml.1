Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZGCMSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZGCMSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZGCMR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:17:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:34311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZGCMRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:17:55 -0400
Subject: [PATCH 3/3 -tip] perf list: avoid replicating functions
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703093032.GI3902@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam>
	 <1246606736.2322.9.camel@jaswinder.satnam>  <20090703093032.GI3902@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 17:47:21 +0530
Message-Id: <1246623441.2322.36.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 11:30 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > > $ ./perf list shows vector events like :
> > > 
> > >   vec-adds OR add                          [Hardware vector event]
> > >   vec-muls OR multiply                     [Hardware vector event]
> > >   vec-divs OR divide                       [Hardware vector event]
> > >   vec-idle-cycles OR vec-empty-cycles      [Hardware vector event]
> > >   vec-stall-cycles OR vec-busy-cycles      [Hardware vector event]
> > >   vec-ops OR vec-operations                [Hardware vector event]
> 
> btw., why does this printout SHOUT the 'or'? It's certainly not an 
> important piece of information. Something like:
> 
>    vec-adds | add                          [Hardware vector event]
>    vec-muls | multiply                     [Hardware vector event]
>    vec-divs | divide                       [Hardware vector event]
>    vec-idle-cycles | vec-empty-cycles      [Hardware vector event]
>    vec-stall-cycles | vec-busy-cycles      [Hardware vector event]
>    vec-ops | vec-operations                [Hardware vector event]
> 
> looks better on all levels.
> 

I prepared this patch incrementally on : 
[PATCH 1/2 -tip] perf_counter: Add generalized hardware vectored co-processor support for AMD and Intel Corei7/Nehalem
[PATCH 2/2 -tip] perf_counter: Add generalized hardware interrupt support for AMD and Intel Corei7/Nehalem, Core2 and Atom

[PATCH 3/3] perf list: avoid replicating functions

vector and interrupt can use same function made for hardware and software generic events.

Also replaced 'OR' with '|'

$ ./perf list

List of pre-defined events (to be used in -e):

  cpu-cycles | cycles                      [Hardware event]
  instructions                             [Hardware event]
  cache-references                         [Hardware event]
  cache-misses                             [Hardware event]
  branch-instructions | branches           [Hardware event]
  branch-misses                            [Hardware event]
  bus-cycles                               [Hardware event]

  cpu-clock                                [Software event]
  task-clock                               [Software event]
  page-faults | faults                     [Software event]
  minor-faults                             [Software event]
  major-faults                             [Software event]
  context-switches | cs                    [Software event]
  cpu-migrations | migrations              [Software event]

  L1-d$-loads                              [Hardware cache event]
  L1-d$-load-misses                        [Hardware cache event]
  L1-d$-stores                             [Hardware cache event]
  L1-d$-store-misses                       [Hardware cache event]
  L1-d$-prefetches                         [Hardware cache event]
  L1-d$-prefetch-misses                    [Hardware cache event]
  L1-i$-loads                              [Hardware cache event]
  L1-i$-load-misses                        [Hardware cache event]
  L1-i$-prefetches                         [Hardware cache event]
  L1-i$-prefetch-misses                    [Hardware cache event]
  LLC-loads                                [Hardware cache event]
  LLC-load-misses                          [Hardware cache event]
  LLC-stores                               [Hardware cache event]
  LLC-store-misses                         [Hardware cache event]
  LLC-prefetches                           [Hardware cache event]
  LLC-prefetch-misses                      [Hardware cache event]
  dTLB-loads                               [Hardware cache event]
  dTLB-load-misses                         [Hardware cache event]
  dTLB-stores                              [Hardware cache event]
  dTLB-store-misses                        [Hardware cache event]
  dTLB-prefetches                          [Hardware cache event]
  dTLB-prefetch-misses                     [Hardware cache event]
  iTLB-loads                               [Hardware cache event]
  iTLB-load-misses                         [Hardware cache event]
  branch-loads                             [Hardware cache event]
  branch-load-misses                       [Hardware cache event]

  vec-adds | add                           [Hardware vector event]
  vec-muls | multiply                      [Hardware vector event]
  vec-divs | divide                        [Hardware vector event]
  vec-idle-cycles | vec-empty-cycles       [Hardware vector event]
  vec-stall-cycles | vec-busy-cycles       [Hardware vector event]
  vec-ops | vec-operations                 [Hardware vector event]

  interrupts | interrupt                   [Hardware interrupt event]
  int-mask-cycles | masked                 [Hardware interrupt event]
  int-pending-mask-cycles                  [Hardware interrupt event]

  rNNN                                     [Hardware raw event]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   83 +++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d085b8f..c2a7dc2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -494,46 +494,51 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 	return 0;
 }
 
-static const char * const event_type_descriptors[] = {
-	"",
+static const char *event_types[PERF_TYPE_MAX] = {
 	"Hardware event",
 	"Software event",
 	"Tracepoint event",
 	"Hardware cache event",
+	"Hardware raw event",
 	"Hardware vector event",
 	"Hardware interrupt event",
 };
 
-/*
- * Print the help text for the event symbols:
- */
-void print_events(void)
+static void print_desc(struct event_symbol *syms, unsigned int size)
 {
-	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, op, prev_type = -1;
+	unsigned int i, type, prev_type = -1;
 	char name[40];
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
-		type = syms->type + 1;
-		if (type > ARRAY_SIZE(event_type_descriptors))
-			type = 0;
-
-		if (type != prev_type)
+	for (i = 0; i < size; i++, syms++) {
+		type = syms->type;
+		if (type != prev_type) {
+			prev_type = type;
 			fprintf(stderr, "\n");
+		}
 
 		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+			sprintf(name, "%s | %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
-			event_type_descriptors[type]);
 
-		prev_type = type;
+		fprintf(stderr, "  %-40s [%s]\n", name, event_types[type]);
 	}
+}
+
+/*
+ * Print the help text for the event symbols:
+ */
+void print_events(void)
+{
+	unsigned int type, op, r;
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
 
+	/* List hardware and software event descriptors */
+	print_desc(event_symbols, ARRAY_SIZE(event_symbols));
+
+	/* List hardware cache event descriptors */
 	fprintf(stderr, "\n");
 	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
 		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
@@ -541,41 +546,23 @@ void print_events(void)
 			if (!is_cache_op_valid(type, op))
 				continue;
 
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+			for (r = 0; r < PERF_COUNT_HW_CACHE_RESULT_MAX; r++) {
 				fprintf(stderr, "  %-40s [%s]\n",
-					event_cache_name(type, op, i),
-					event_type_descriptors[4]);
+					event_cache_name(type, op, r),
+					event_types[PERF_TYPE_HW_CACHE]);
 			}
 		}
 	}
 
-	fprintf(stderr, "\n");
-	syms = vector_event_symbols;
-	type = syms->type;
-	for (i = 0; i < ARRAY_SIZE(vector_event_symbols); i++, syms++) {
-		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
-		else
-			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
-			event_type_descriptors[type]);
-	}
+	/* List hardware vectored co-processor event descriptors */
+	print_desc(vector_event_symbols, ARRAY_SIZE(vector_event_symbols));
 
-	fprintf(stderr, "\n");
-	syms = interrupt_event_symbols;
-	type = syms->type;
-	for (i = 0; i < ARRAY_SIZE(interrupt_event_symbols); i++, syms++) {
-		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
-		else
-			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
-			event_type_descriptors[type]);
-	}
+	/* List hardware interrupt event descriptors */
+	print_desc(interrupt_event_symbols, ARRAY_SIZE(interrupt_event_symbols));
 
+	/* List hardware raw event descriptors */
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
-		"rNNN");
+	fprintf(stderr, "  %-40s [%s]\n", "rNNN", event_types[PERF_TYPE_RAW]);
 	fprintf(stderr, "\n");
 
 	exit(129);
-- 
1.6.2.5



