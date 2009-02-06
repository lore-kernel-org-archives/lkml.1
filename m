Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZBFEeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZBFEeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 23:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZBFEe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 23:34:27 -0500
Received: from ozlabs.org ([203.10.76.45]:53151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZBFEe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 23:34:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18827.48582.613391.869829@cargo.ozlabs.ibm.com>
Date: Fri, 6 Feb 2009 15:34:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Prevent oopses from per-cpu software
	counters
In-Reply-To: <20090205142229.GB28443@elte.hu>
References: <18826.28805.120988.303819@drongo.ozlabs.ibm.com>
	<20090205142229.GB28443@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> So how about fixing these sw counts to properly work as percpu counters too? 

OK, so for page faults it looks like I want to look at

	get_cpu_var(vm_event_states).event[PGFAULT]

to get the per-cpu page fault count, as long as
CONFIG_VM_EVENT_COUNTERS is set.

It looks like the scheduler doesn't keep per-cpu counts of context
switches or task migrations, or if it does I couldn't find them.  We
could do stuff in perf_counter_task_sched_in/out to implement per-cpu
context switch and migration counters by adding up the delta values
for each task that gets scheduled onto the cpu.  Or we could add
explicit per-cpu counters for these things in the scheduler.

What do you think?

Paul.
