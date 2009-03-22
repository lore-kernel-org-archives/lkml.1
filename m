Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZCVGu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZCVGu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 02:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZCVGuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 02:50:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:51506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZCVGuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 02:50:10 -0400
Subject: Re: [tree] Performance Counters for Linux, v7
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090321161021.GA9826@elte.hu>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
	 <20090321055252.eb0673ea.akpm@linux-foundation.org>
	 <20090321155442.GB6356@elte.hu>  <20090321161021.GA9826@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Mar 2009 12:18:58 +0530
Message-Id: <1237704538.29643.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 17:10 +0100, Ingo Molnar wrote:

> There's also been lots of updates to the userspace tools (kerneltop 
> and perfstat):
> 
>    http://redhat.com/~mingo/perfcounters/kerneltop.c
>    http://redhat.com/~mingo/perfcounters/perfstat.c
> 

If possible, can we also prepare git tree for these userspace tools by
this way we can also look on logs and check incremental changes
otherwise we leads to:

[jaswinder@hpdv5 20090321]$ cc -O2 -g -lrt -Wall -W -o perfstat perfstat.c
perfstat.c:57:40: error: include/linux/perf_counter.h: No such file or directory
perfstat.c:83: warning: ‘struct perf_counter_hw_event’ declared inside parameter list
perfstat.c:83: warning: its scope is only this definition or declaration, which is probably not what you want
perfstat.c:127: error: ‘PERF_TYPE_SOFTWARE’ undeclared here (not in a function)
perfstat.c:127: error: ‘PERF_COUNT_TASK_CLOCK’ undeclared here (not in a function)
perfstat.c:128: error: ‘PERF_COUNT_CPU_MIGRATIONS’ undeclared here (not in a function)
perfstat.c:129: error: ‘PERF_COUNT_CONTEXT_SWITCHES’ undeclared here (not in a function)
perfstat.c:130: error: ‘PERF_COUNT_PAGE_FAULTS’ undeclared here (not in a function)
perfstat.c:131: error: ‘PERF_TYPE_HARDWARE’ undeclared here (not in a function)
perfstat.c:131: error: ‘PERF_COUNT_CPU_CYCLES’ undeclared here (not in a function)
perfstat.c:132: error: ‘PERF_COUNT_INSTRUCTIONS’ undeclared here (not in a function)
perfstat.c:133: error: ‘PERF_COUNT_CACHE_REFERENCES’ undeclared here (not in a function)
perfstat.c:134: error: ‘PERF_COUNT_CACHE_MISSES’ undeclared here (not in a function)
perfstat.c: In function ‘type_valid’:
perfstat.c:164: error: ‘PERF_HW_EVENTS_MAX’ undeclared (first use in this function)
perfstat.c:164: error: (Each undeclared identifier is reported only once
perfstat.c:164: error: for each function it appears in.)
perfstat.c:166: error: ‘PERF_SW_EVENTS_MAX’ undeclared (first use in this function)
perfstat.c:167: error: ‘PERF_TYPE_TRACEPOINT’ undeclared (first use in this function)
perfstat.c: In function ‘event_name’:
perfstat.c:194: error: ‘PERF_TYPE_TRACEPOINT’ undeclared (first use in this function)
perfstat.c: In function ‘create_counter’:
perfstat.c:286: error: storage size of ‘hw_event’ isn’t known
perfstat.c:290: error: ‘PERF_RECORD_SIMPLE’ undeclared (first use in this function)
perfstat.c:286: warning: unused variable ‘hw_event’
perfstat.c: In function ‘main’:
perfstat.c:385: error: ‘PERF_COUNT_CPU_CLOCK’ undeclared (first use in this function)
[jaswinder@hpdv5 20090321]$ 
[jaswinder@hpdv5 20090321]$ cc -O2 -g -lrt -Wall -W -o perfstat perfstat.c -I/home/jaswinder/jaswinder-git/linux-2.6-tip
[jaswinder@hpdv5 20090321]$ ./perfstat -e 1 -e 3 -e 5 ls -lR /usr/include/
Usage: perfstat [<events...>] <cmd...>

PerfStat Options (up to 64 event types can be specified):

 -e EID       --event_id=EID       # event type ID
                                   0: CPU cycles
                                   1: instructions
                                   2: cache accesses
                                   3: cache misses
                                   4: branch instructions
                                   5: branch prediction misses
                                   6: bus cycles

 -s                                # system-wide collection

 -c <cmd..>   --command=<cmd..>    # command+arguments to be timed.

[jaswinder@hpdv5 20090321]$ ./perfstat -e 0,1,2 -c ls
Usage: perfstat [<events...>] <cmd...>

PerfStat Options (up to 64 event types can be specified):

 -e EID       --event_id=EID       # event type ID
                                   0: CPU cycles
                                   1: instructions
                                   2: cache accesses
                                   3: cache misses
                                   4: branch instructions
                                   5: branch prediction misses
                                   6: bus cycles

 -s                                # system-wide collection

 -c <cmd..>   --command=<cmd..>    # command+arguments to be timed.

[jaswinder@hpdv5 20090321]$

Thanks,

--
JSR

