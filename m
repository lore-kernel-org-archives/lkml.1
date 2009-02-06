Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZBFGfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZBFGfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZBFGfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:35:37 -0500
Received: from mga10.intel.com ([192.55.52.92]:3056 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbZBFGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:35:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,390,1231142400"; 
   d="scan'208";a="663360325"
Subject: Re: [PATCH] perf_counter: Prevent oopses from per-cpu software
	counters
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18827.48582.613391.869829@cargo.ozlabs.ibm.com>
References: <18826.28805.120988.303819@drongo.ozlabs.ibm.com>
	 <20090205142229.GB28443@elte.hu>
	 <18827.48582.613391.869829@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Feb 2009 14:35:25 +0800
Message-Id: <1233902125.2604.328.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 15:34 +1100, Paul Mackerras wrote:
> Ingo Molnar writes:
> 
> > So how about fixing these sw counts to properly work as percpu counters too? 
> 
> OK, so for page faults it looks like I want to look at
> 
> 	get_cpu_var(vm_event_states).event[PGFAULT]
> 
> to get the per-cpu page fault count, as long as
> CONFIG_VM_EVENT_COUNTERS is set.
> 
> It looks like the scheduler doesn't keep per-cpu counts of context
> switches
rq->sched_switch or sched_count? ﻿sched_switch is defined, but not used. They
all depends on CONFIG_SCHEDSTATS=y.

>  or task migrations, or if it does I couldn't find them.  We
> could do stuff in perf_counter_task_sched_in/out to implement per-cpu
> context switch and migration counters by adding up the delta values
> for each task that gets scheduled onto the cpu.  Or we could add
> explicit per-cpu counters for these things in the scheduler.
> 
> What do you think?
> 
> Paul.

