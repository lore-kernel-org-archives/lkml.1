Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZEJGbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZEJGbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZEJGbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:31:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57543 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZEJGbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:31:22 -0400
Date: Sun, 10 May 2009 08:30:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
	X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <20090510063047.GD30778@elte.hu>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com> <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org> <1241931753.4796.15.camel@localhost.localdomain> <1241934795.4796.55.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241934795.4796.55.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> > should be replaced by
> > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> > 
> > All x86 cpus which support performance monitor should set this feature.
> > 
> 
> Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2
> 
> But Performance monitor is almost supported by all Intel 
> processors. I am adding few MSRs list for reference to see 
> complete list please check arch/x86/kernel/cpu/cpu_debug.c

I think you are confusing two things:

- The 'architectural perfmon' CPU flag, enumerated in CPUID. (this 
  is a relatively new CPUID flag that only Intel CPUs at around 
  Core2 and later will report.)

- The concept of 'performance monitoring' - which has been present 
  in various x86 CPUs starting at the original Pentium (P5) 15 years 
  ago or so.

The X86_FEATURE_ARCH_PERFMON flag is for the architectural perfmon 
CPUID feature. If you execute CPUID you'll get that from the CPU - 
on Core2 and later Intel CPUs. You wont get it on AMD CPUs. You wont 
get it on earlier Intel CPUs.

And since 'Architectural Performance Monitoring' is an Intel only 
thing, it would not be correct to do as if AMD had the same thing. 
AMD has something _similar_, but not quite the same.

So, the patch from Robert cleans up that area.

( The patch might still be buggy in other ways, but you need to 
  understand its intent and mechanism before being able to argue 
  about other bugs. )

And you need to understand the difference between 'hardware' CPU 
feature flags, provided by the CPUID instruction, and 'software' CPU 
feature flags defined by Linux (for the reason of abstracting out 
certain types of functionality).

	Ingo
