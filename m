Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZCSTo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZCSTo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbZCSTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:10 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/10] tracepoint perf counter events and new ABI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the event tracer to provide id files:

[root@opteron ~]# for i in /debug/tracing/events/irq/*/id; do echo `cat $i` - $i; done
28 - /debug/tracing/events/irq/irq_handler_entry/id
29 - /debug/tracing/events/irq/irq_handler_exit/id
27 - /debug/tracing/events/irq/softirq_entry/id
26 - /debug/tracing/events/irq/softirq_exit/id

These can then be used in profiling as:

[root@opteron linux-2.6]# ~/perfstat -e 2:28 make O=native-build/ -j4 lib
...

 Performance counter stats for 'make':

   18280.657602  task clock ticks     (msecs)

            465  tp: 28               (events)

 Wall-clock time elapsed: 11265.199196 msecs

Showing that we had 465 irq_handler_entry events during that workload.

-- 

