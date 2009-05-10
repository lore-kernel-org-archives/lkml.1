Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZEJGxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZEJGxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZEJGx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:53:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:34850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbZEJGxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:53:25 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090510063047.GD30778@elte.hu>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
	 <1241931753.4796.15.camel@localhost.localdomain>
	 <1241934795.4796.55.camel@localhost.localdomain>
	 <20090510063047.GD30778@elte.hu>
Content-Type: text/plain
Date: Sun, 10 May 2009 12:21:50 +0530
Message-Id: <1241938310.4796.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 08:30 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> > > should be replaced by
> > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> > > 
> > > All x86 cpus which support performance monitor should set this feature.
> > > 
> > 
> > Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2
> > 
> > But Performance monitor is almost supported by all Intel 
> > processors. I am adding few MSRs list for reference to see 
> > complete list please check arch/x86/kernel/cpu/cpu_debug.c
> 
> I think you are confusing two things:
> 
> - The 'architectural perfmon' CPU flag, enumerated in CPUID. (this 
>   is a relatively new CPUID flag that only Intel CPUs at around 
>   Core2 and later will report.)
> 
> - The concept of 'performance monitoring' - which has been present 
>   in various x86 CPUs starting at the original Pentium (P5) 15 years 
>   ago or so.
> 
> The X86_FEATURE_ARCH_PERFMON flag is for the architectural perfmon 
> CPUID feature. If you execute CPUID you'll get that from the CPU - 
> on Core2 and later Intel CPUs. You wont get it on AMD CPUs. You wont 
> get it on earlier Intel CPUs.
> 
> And since 'Architectural Performance Monitoring' is an Intel only 
> thing, it would not be correct to do as if AMD had the same thing. 
> AMD has something _similar_, but not quite the same.
> 

Thanks for clarification.

There is one more way to check performance monitor support for Intel by
using IA32_MISC_ENABLE MSR (0x1A0) bit 7 tells whether performance
monitoring is available or not.

But IA32_MISC_ENABLE MSR (0x1A0) is not available for Pentium and P6.

So better I will add new cpufeature for performance monitoring for x86:

X86_FEATURE_PERFMON : Performance monitor support

--
JSR



