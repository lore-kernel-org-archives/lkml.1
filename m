Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXGTOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXGTOtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765900AbXGTOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:49:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49490 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbXGTOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:49:25 -0400
Message-Id: <200707201449.l6KEnIYw020517@owlet.beaverton.ibm.com>
To: Nick Piggin <npiggin@suse.de>
cc: Joachim Deguara <joachim.deguara@amd.com>,
       lkml List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation update sched-stat.txt 
In-reply-to: Your message of "Fri, 20 Jul 2007 09:25:22 +0200."
             <20070720072522.GB27772@wotan.suse.de> 
Date: Fri, 20 Jul 2007 07:49:18 -0700
From: Rick Lindsley <ricklind@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I noticed the version updated without the docs a while ago, and
I've had it on my list for a time to update the docs. Thanks for
actually providing the patch!

I will update the table on the website with a new column for v14.  I
think v13 occurred in (and was removed from) the -mm tree at one point
during some interim scheduler changes.

There was a paper presented at OLS suggesting that under some loads,
schedstats could impose a performance penalty due to the cache hits
incurred by accruing the statistics. In light of the changes in v12/v14,
and the issues raised by that paper, it is probably worthwhile to review
schedstats for usefulness.  Is it still useful and, perhaps more to the
point, is it still measuring the right stuff?  Should counters be added
or deleted?  (That discussion should be separate from this patch.)

Rick

Acked-by: Rick Lindsley <ricklind@us.ibm.com>
    
Index: kernel/Documentation/sched-stats.txt
===================================================================
--- kernel.orig/Documentation/sched-stats.txt
+++ kernel/Documentation/sched-stats.txt
@@ -1,10 +1,11 @@
-Version 10 of schedstats includes support for sched_domains, which
-hit the mainline kernel in 2.6.7.  Some counters make more sense to be
-per-runqueue; other to be per-domain.  Note that domains (and their 
associated
-information) will only be pertinent and available on machines utilizing
-CONFIG_SMP.
+Version 14 of schedstats includes support for sched_domains, which hit the
+mainline kernel in 2.6.20 although it is identical to the stats from version
+12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
+release).  Some counters make more sense to be per-runqueue; other to be
+per-domain.  Note that domains (and their associated information) will only
+be pertinent and available on machines utilizing CONFIG_SMP.
 
-In version 10 of schedstat, there is at least one level of domain
+In version 14 of schedstat, there is at least one level of domain
 statistics for each cpu listed, and there may well be more than one
 domain.  Domains have no particular names in this implementation, but
 the highest numbered one typically arbitrates balancing across all the
@@ -27,7 +28,7 @@ to write their own scripts, the fields a
 
 CPU statistics
 --------------
-cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 
27 28
+cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12
 
 NOTE: In the sched_yield() statistics, the active queue is considered empty
     if it has only one process in it, since obviously the process calling
@@ -39,48 +40,20 @@ First four fields are sched_yield() stat
      3) # of times just the expired queue was empty
      4) # of times sched_yield() was called
 
-Next four are schedule() statistics:
-     5) # of times the active queue had at least one other process on it
-     6) # of times we switched to the expired queue and reused it
-     7) # of times schedule() was called
-     8) # of times schedule() left the processor idle
-
-Next four are active_load_balance() statistics:
-     9) # of times active_load_balance() was called
-    10) # of times active_load_balance() caused this cpu to gain a task
-    11) # of times active_load_balance() caused this cpu to lose a task
-    12) # of times active_load_balance() tried to move a task and failed
-
-Next three are try_to_wake_up() statistics:
-    13) # of times try_to_wake_up() was called
-    14) # of times try_to_wake_up() successfully moved the awakening task
-    15) # of times try_to_wake_up() attempted to move the awakening task
-
-Next two are wake_up_new_task() statistics:
-    16) # of times wake_up_new_task() was called
-    17) # of times wake_up_new_task() successfully moved the new task
+Next three are schedule() statistics:
+     5) # of times we switched to the expired queue and reused it
+     6) # of times schedule() was called
+     7) # of times schedule() left the processor idle
 
-Next one is a sched_migrate_task() statistic:
-    18) # of times sched_migrate_task() was called
-
-Next one is a sched_balance_exec() statistic:
-    19) # of times sched_balance_exec() was called
+Next two are try_to_wake_up() statistics:
+     8) # of times try_to_wake_up() was called
+     9) # of times try_to_wake_up() was called to wake up the local cpu
 
 Next three are statistics describing scheduling latency:
-    20) sum of all time spent running by tasks on this processor (in ms)
-    21) sum of all time spent waiting to run by tasks on this processor (in 
ms)
-    22) # of tasks (not necessarily unique) given to the processor
-
-The last six are statistics dealing with pull_task():
-    23) # of times pull_task() moved a task to this cpu when newly idle
-    24) # of times pull_task() stole a task from this cpu when another cpu
-	was newly idle
-    25) # of times pull_task() moved a task to this cpu when idle
-    26) # of times pull_task() stole a task from this cpu when another cpu
-	was idle
-    27) # of times pull_task() moved a task to this cpu when busy
-    28) # of times pull_task() stole a task from this cpu when another cpu
-	was busy
+    10) sum of all time spent running by tasks on this processor (in jiffies)
+    11) sum of all time spent waiting to run by tasks on this processor (in
+        jiffies)
+    12) # of timeslices run on this cpu
 
 
 Domain statistics
@@ -89,65 +62,95 @@ One of these is produced per domain for 
 CONFIG_SMP is not defined, *no* domains are utilized and these lines
 will not appear in the output.)
 
-domain<N> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
+domain<N> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
23 24 25 26 27 28 29 30 31 32 33 34 35 36
 
 The first field is a bit mask indicating what cpus this domain operates over.
 
-The next fifteen are a variety of load_balance() statistics:
-
-     1) # of times in this domain load_balance() was called when the cpu
-	was idle
-     2) # of times in this domain load_balance() was called when the cpu
-	was busy
-     3) # of times in this domain load_balance() was called when the cpu
-	was just becoming idle
-     4) # of times in this domain load_balance() tried to move one or more
-	tasks and failed, when the cpu was idle
-     5) # of times in this domain load_balance() tried to move one or more
-	tasks and failed, when the cpu was busy
-     6) # of times in this domain load_balance() tried to move one or more
-	tasks and failed, when the cpu was just becoming idle
-     7) sum of imbalances discovered (if any) with each call to
-	load_balance() in this domain when the cpu was idle
-     8) sum of imbalances discovered (if any) with each call to
-	load_balance() in this domain when the cpu was busy
-     9) sum of imbalances discovered (if any) with each call to
-	load_balance() in this domain when the cpu was just becoming idle
-    10) # of times in this domain load_balance() was called but did not find
-	a busier queue while the cpu was idle
-    11) # of times in this domain load_balance() was called but did not find
-	a busier queue while the cpu was busy
-    12) # of times in this domain load_balance() was called but did not find
-	a busier queue while the cpu was just becoming idle
-    13) # of times in this domain a busier queue was found while the cpu was
-	idle but no busier group was found
-    14) # of times in this domain a busier queue was found while the cpu was
-	busy but no busier group was found
-    15) # of times in this domain a busier queue was found while the cpu was
-	just becoming idle but no busier group was found
-
-Next two are sched_balance_exec() statistics:
-    17) # of times in this domain sched_balance_exec() successfully pushed
-	a task to a new cpu
-    18) # of times in this domain sched_balance_exec() tried but failed to
-	push a task to a new cpu
-
-Next two are try_to_wake_up() statistics:
-    19) # of times in this domain try_to_wake_up() tried to move a task based
-	on affinity and cache warmth
-    20) # of times in this domain try_to_wake_up() tried to move a task based
-	on load balancing
+The next 24 are a variety of load_balance() statistics in grouped into types
+of idleness (idle, busy, and newly idle):
 
+     1) # of times in this domain load_balance() was called when the
+        cpu was idle
+     2) # of times in this domain load_balance() checked but found
+        the load did not require balancing when the cpu was idle
+     3) # of times in this domain load_balance() tried to move one or
+        more tasks and failed, when the cpu was idle
+     4) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was idle
+     5) # of times in this domain pull_task() was called when the cpu
+        was idle
+     6) # of times in this domain pull_task() was called even though
+        the target task was cache-hot when idle
+     7) # of times in this domain load_balance() was called but did
+        not find a busier queue while the cpu was idle
+     8) # of times in this domain a busier queue was found while the
+        cpu was idle but no busier group was found
+
+     9) # of times in this domain load_balance() was called when the
+        cpu was busy
+    10) # of times in this domain load_balance() checked but found the
+        load did not require balancing when busy
+    11) # of times in this domain load_balance() tried to move one or
+        more tasks and failed, when the cpu was busy
+    12) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was busy
+    13) # of times in this domain pull_task() was called when busy
+    14) # of times in this domain pull_task() was called even though the
+        target task was cache-hot when busy
+    15) # of times in this domain load_balance() was called but did not
+        find a busier queue while the cpu was busy
+    16) # of times in this domain a busier queue was found while the cpu
+        was busy but no busier group was found
+
+    17) # of times in this domain load_balance() was called when the
+        cpu was just becoming idle
+    18) # of times in this domain load_balance() checked but found the
+        load did not require balancing when the cpu was just becoming idle
+    19) # of times in this domain load_balance() tried to move one or more
+        tasks and failed, when the cpu was just becoming idle
+    20) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was just becoming idle
+    21) # of times in this domain pull_task() was called when newly idle
+    22) # of times in this domain pull_task() was called even though the
+        target task was cache-hot when just becoming idle
+    23) # of times in this domain load_balance() was called but did not
+        find a busier queue while the cpu was just becoming idle
+    24) # of times in this domain a busier queue was found while the cpu
+        was just becoming idle but no busier group was found
+
+   Next three are active_load_balance() statistics:
+    25) # of times active_load_balance() was called
+    26) # of times active_load_balance() tried to move a task and failed
+    27) # of times active_load_balance() successfully moved a task
+
+   Next three are sched_balance_exec() statistics:
+    28) sbe_cnt is not used
+    29) sbe_balanced is not used
+    30) sbe_pushed is not used
+
+   Next three are sched_balance_fork() statistics:
+    31) sbf_cnt is not used
+    32) sbf_balanced is not used
+    33) sbf_pushed is not used
+
+   Next three are try_to_wake_up() statistics:
+    34) # of times in this domain try_to_wake_up() awoke a task that
+        last ran on a different cpu in this domain
+    35) # of times in this domain try_to_wake_up() moved a task to the
+        waking cpu because it was cache-cold on its own cpu anyway
+    36) # of times in this domain try_to_wake_up() started passive balancing
 
 /proc/<pid>/schedstat
 ----------------
 schedstats also adds a new /proc/<pid/schedstat file to include some of
 the same information on a per-process level.  There are three fields in
-this file correlating to fields 20, 21, and 22 in the CPU fields, but
-they only apply for that process.
+this file correlating for that process to:
+     1) time spent on the cpu
+     2) time spent waiting on a runqueue
+     3) # of timeslices run on this cpu
 
 A program could be easily written to make use of these extra fields to
 report on how well a particular process or set of processes is faring
 under the scheduler's policies.  A simple version of such a program is
 available at
-    http://eaglet.rain.com/rick/linux/schedstat/v10/latency.c
+    http://eaglet.rain.com/rick/linux/schedstat/v12/latency.c
