Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYG2UKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYG2UKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbYG2UJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:09:21 -0400
Received: from xenotime.net ([66.160.160.81]:46374 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759469AbYG2UJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:09:19 -0400
Date: Tue, 29 Jul 2008 13:05:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       balbir@linux.vnet.ibm.com
Subject: [PATCH 5/5] docsrc: fix getdelays printk formats
Message-ID: <121736191553@xenotime.net>
In-Reply-To: <12173619152424@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printf format type warnings (seen on alpha & ia64):

Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 6 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 7 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 8 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 9 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 12 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 13 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 16 has type '__u64'
Documentation/accounting/getdelays.c:206: warning: format '%15llu' expects type 'long long unsigned int', but argument 17 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15llu' expects type 'long long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15llu' expects type 'long long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c:221: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type '__u64'
Documentation/accounting/getdelays.c:236: warning: 'cmd_type' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/accounting/getdelays.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- linux-next-20080729.orig/Documentation/accounting/getdelays.c
+++ linux-next-20080729/Documentation/accounting/getdelays.c
@@ -201,13 +201,19 @@ void print_delayacct(struct taskstats *t
 	       "RECLAIM  %12s%15s\n"
 	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
-	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
-	       t->cpu_delay_total,
+	       (unsigned long long)t->cpu_count,
+	       (unsigned long long)t->cpu_run_real_total,
+	       (unsigned long long)t->cpu_run_virtual_total,
+	       (unsigned long long)t->cpu_delay_total,
 	       "count", "delay total",
-	       t->blkio_count, t->blkio_delay_total,
-	       "count", "delay total", t->swapin_count, t->swapin_delay_total,
+	       (unsigned long long)t->blkio_count,
+	       (unsigned long long)t->blkio_delay_total,
 	       "count", "delay total",
-	       t->freepages_count, t->freepages_delay_total);
+	       (unsigned long long)t->swapin_count,
+	       (unsigned long long)t->swapin_delay_total,
+	       "count", "delay total",
+	       (unsigned long long)t->freepages_count,
+	       (unsigned long long)t->freepages_delay_total);
 }
 
 void task_context_switch_counts(struct taskstats *t)
@@ -215,14 +221,17 @@ void task_context_switch_counts(struct t
 	printf("\n\nTask   %15s%15s\n"
 	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
-	       t->nvcsw, t->nivcsw);
+	       (unsigned long long)t->nvcsw, (unsigned long long)t->nivcsw);
 }
 
 void print_cgroupstats(struct cgroupstats *c)
 {
 	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
-		"uninterruptible %llu\n", c->nr_sleeping, c->nr_io_wait,
-		c->nr_running, c->nr_stopped, c->nr_uninterruptible);
+		"uninterruptible %llu\n", (unsigned long long)c->nr_sleeping,
+		(unsigned long long)c->nr_io_wait,
+		(unsigned long long)c->nr_running,
+		(unsigned long long)c->nr_stopped,
+		(unsigned long long)c->nr_uninterruptible);
 }
 
 


-- 

