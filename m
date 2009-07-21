Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZGUQUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZGUQUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZGUQUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:20:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41695 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbZGUQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:20:39 -0400
Date: Tue, 21 Jul 2009 12:20:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Message-Id: <cover.1248190728.git.jbaron@redhat.com>
Subject: [PATCH 0/2] perf_counter: add tracepoint support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

The following two patches build on Peter's initial tracepoint perf counter work.
The first patch, adds 'perf list' and 'perf stat' support to the perf tool. Thus,
we can specify tracepoint events as: '-e subsystem:event_name'. The second patch
looks for the debugfs filesystem in /proc/mounts, but also allows the user to
specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'

Below, I show the output of 'perf list', and 'perf stat' for a tbench run.

thanks,

-Jason


#perf list

List of pre-defined events (to be used in -e):

  cpu-cycles OR cycles                     [Hardware event]
  instructions                             [Hardware event]
  cache-references                         [Hardware event]
  cache-misses                             [Hardware event]
  branch-instructions OR branches          [Hardware event]
  branch-misses                            [Hardware event]
  bus-cycles                               [Hardware event]

  cpu-clock                                [Software event]
  task-clock                               [Software event]
  page-faults OR faults                    [Software event]
  minor-faults                             [Software event]
  major-faults                             [Software event]
  context-switches OR cs                   [Software event]
  cpu-migrations OR migrations             [Software event]

  L1-dcache-loads                          [Hardware cache event]
  L1-dcache-load-misses                    [Hardware cache event]
  L1-dcache-stores                         [Hardware cache event]
  L1-dcache-store-misses                   [Hardware cache event]
  L1-dcache-prefetches                     [Hardware cache event]
  L1-dcache-prefetch-misses                [Hardware cache event]
  L1-icache-loads                          [Hardware cache event]
  L1-icache-load-misses                    [Hardware cache event]
  L1-icache-prefetches                     [Hardware cache event]
  L1-icache-prefetch-misses                [Hardware cache event]
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

  rNNN                                     [raw hardware event descriptor]

  skb:kfree_skb                            [Tracepoint event]
  block:block_rq_abort                     [Tracepoint event]
  block:block_rq_insert                    [Tracepoint event]
  block:block_rq_issue                     [Tracepoint event]
  block:block_rq_requeue                   [Tracepoint event]
  block:block_rq_complete                  [Tracepoint event]
  block:block_bio_bounce                   [Tracepoint event]
  block:block_bio_complete                 [Tracepoint event]
  block:block_bio_backmerge                [Tracepoint event]
  block:block_bio_frontmerge               [Tracepoint event]
  block:block_bio_queue                    [Tracepoint event]
  block:block_getrq                        [Tracepoint event]
  block:block_sleeprq                      [Tracepoint event]
  block:block_plug                         [Tracepoint event]
  block:block_unplug_timer                 [Tracepoint event]
  block:block_unplug_io                    [Tracepoint event]
  block:block_split                        [Tracepoint event]
  block:block_remap                        [Tracepoint event]
  kmem:kmalloc                             [Tracepoint event]
  kmem:kmem_cache_alloc                    [Tracepoint event]
  kmem:kmalloc_node                        [Tracepoint event]
  kmem:kmem_cache_alloc_node               [Tracepoint event]
  kmem:kfree                               [Tracepoint event]
  kmem:kmem_cache_free                     [Tracepoint event]
  ftrace:kmem_free                         [Tracepoint event]
  ftrace:kmem_alloc                        [Tracepoint event]
  ftrace:power                             [Tracepoint event]
  ftrace:hw_branch                         [Tracepoint event]
  ftrace:branch                            [Tracepoint event]
  ftrace:print                             [Tracepoint event]
  ftrace:bprint                            [Tracepoint event]
  ftrace:user_stack                        [Tracepoint event]
  ftrace:kernel_stack                      [Tracepoint event]
  ftrace:special                           [Tracepoint event]
  ftrace:context_switch                    [Tracepoint event]
  ftrace:wakeup                            [Tracepoint event]
  ftrace:funcgraph_exit                    [Tracepoint event]
  ftrace:funcgraph_entry                   [Tracepoint event]
  ftrace:function                          [Tracepoint event]
  workqueue:workqueue_insertion            [Tracepoint event]
  workqueue:workqueue_execution            [Tracepoint event]
  workqueue:workqueue_creation             [Tracepoint event]
  workqueue:workqueue_destruction          [Tracepoint event]
  irq:irq_handler_entry                    [Tracepoint event]
  irq:irq_handler_exit                     [Tracepoint event]
  irq:softirq_entry                        [Tracepoint event]
  irq:softirq_exit                         [Tracepoint event]
  sched:sched_kthread_stop                 [Tracepoint event]
  sched:sched_kthread_stop_ret             [Tracepoint event]
  sched:sched_wait_task                    [Tracepoint event]
  sched:sched_wakeup                       [Tracepoint event]
  sched:sched_wakeup_new                   [Tracepoint event]
  sched:sched_switch                       [Tracepoint event]
  sched:sched_migrate_task                 [Tracepoint event]
  sched:sched_process_free                 [Tracepoint event]
  sched:sched_process_exit                 [Tracepoint event]
  sched:sched_process_wait                 [Tracepoint event]
  sched:sched_process_fork                 [Tracepoint event]
  sched:sched_signal_send                  [Tracepoint event]




#  perf stat  -a -e sched:sched_switch -e sched:sched_wakeup -e irq:irq_handler_entry
tbench 4

 Performance counter stats for 'tbench 4':

      194658693  sched:sched_switch
       97479295  sched:sched_wakeup
           9122  irq:irq_handler_entry

  720.171439729  seconds time elapsed


  -add support for tracepoints to the perf tool
  -add detection for debugfs mount directory

 tools/perf/perf.c              |   58 +++++++++++++-
 tools/perf/util/cache.h        |    1 +
 tools/perf/util/parse-events.c |  176 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h |    3 +
 tools/perf/util/string.h       |    3 +
 tools/perf/util/util.h         |    2 +
 6 files changed, 241 insertions(+), 2 deletions(-)

