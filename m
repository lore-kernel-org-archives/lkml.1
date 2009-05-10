Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZEJFzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZEJFzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 01:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZEJFzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 01:55:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:38293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZEJFzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 01:55:31 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1241931753.4796.15.camel@localhost.localdomain>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
	 <1241931753.4796.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 10 May 2009 11:23:15 +0530
Message-Id: <1241934795.4796.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sun, 2009-05-10 at 10:32 +0530, Jaswinder Singh Rajput wrote:
> Hello Robert,
> 
> On Wed, 2009-04-29 at 13:03 +0000, tip-bot for Robert Richter wrote:
> > Commit-ID:  da1a776be1ac7f78bb30ececbec4c1383163b079
> > Gitweb:     http://git.kernel.org/tip/da1a776be1ac7f78bb30ececbec4c1383163b079
> > Author:     Robert Richter <robert.richter@amd.com>
> > AuthorDate: Wed, 29 Apr 2009 12:46:58 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 29 Apr 2009 14:51:00 +0200
> > 
> > perf_counter, x86: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus
> > 
> > X86_FEATURE_ARCH_PERFMON is an Intel hardware feature that does not
> > work on AMD CPUs. The flag is now only used in Intel specific code
> > (especially initialization).
> > 
> 
> I think X86_FEATURE_ARCH_PERFMON should be for all x86 cpus which
> support performance monitor.
> 
> #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> should be replaced by
> #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> 
> All x86 cpus which support performance monitor should set this feature.
> 

Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2

But Performance monitor is almost supported by all Intel processors. I
am adding few MSRs list for reference to see complete list please check
arch/x86/kernel/cpu/cpu_debug.c

I am planning to enable cpufeature to below processors to access
performance monitor MSRs for cpu_debug.c

Should I use X86_FEATURE_ARCH_PERFMON or make a new one like
X86_FEATURE_PMC.

If I use X86_FEATURE_ARCH_PERFMON then I need to add one more check for 
arch/x86/kernel/cpu/perf_counter.c because perf_counter.c only supports
latest processors (Intel >= Core2, AMD >= K7).

what you think, what is the better approach.

few x86 Performance Monitor MSRs
--------------------------------

Intel:
-----
Petium	:	0x11-0x13

P6	:	0xC1-0xC2
		0x186-0x187

Core	:	0xC1-0xC4
		0x186-0x187

P4/Xeon	:	0x186-0x189
		0x300-0x311
		0x360-0x371

Xeon MP	:	0x186-0x189
		0x300-0x311
		0x360-0x371

ATOM	:	0xC1-0xC2
		0x186-0x187
		0x309-0x30B
		0x345
		0x38D-0x390

Core 2	:	0xC1-0xC2
		0x186-0x187
		0x309-0x30B
		0x345
		0x38D-0x390

Nehalem	:	0xC1-0xC4
		0x186-0x189
		0x1A6
		0x301
		0x309-0x30B
		0x345
		0x38D-0x396

AMD:
---

>= K6	:	0xC0010000-0xC0010007


