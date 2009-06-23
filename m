Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZFWIvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZFWIvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFWIu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:50:58 -0400
Received: from mga06.intel.com ([134.134.136.21]:38468 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbZFWIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="424519176"
Date: Tue, 23 Jun 2009 16:34:20 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: eranian@gmail.com
Cc: Yong Wang <yong.y.wang@linux.intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: perf_counter Atom patch
Message-ID: <20090623083420.GB23534@ywang-moblin2.bj.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com> <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com> <20090623075959.GA23534@ywang-moblin2.bj.intel.com> <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:27:47AM +0200, stephane eranian wrote:
> Hi,
> 
> On Tue, Jun 23, 2009 at 9:59 AM, Yong Wang<yong.y.wang@linux.intel.com> wrote:
> > On Tue, Jun 23, 2009 at 09:45:03AM +0200, stephane eranian wrote:
> >>
> >> Unfortunately, I don't have a N270 to compare with your results.
> >> We need to verify whether or not N270 implements the fixed counters.
> >> Does it report architected perfmon v3 or v1?
> >>
> >
> > All Atom processors report perfmon v3 as specified in SDM. N270 is no
> > exception.
> >
> V3 does not set a minimal number of fixed counters, could be zero. But
> that seems
> odd. Let me ask around.
> 

The Atom spec update says CPUID.0AH.EDX should be 0x0503 in errata
section. I assume future offerings will more likely to add more new
counters in stead of remove existing ones. Correct me if I'm wrong;-)

> >> > The return value of CPUID(0xa) is indeed bogus, too and there is another quirk for that in
> >> > intel_pmu_init() in arch/x86/kernel/cpu/perf_counter.c
> >> >
> >> > x86_pmu.num_counters_fixed	= max((int)edx.split.num_counters_fixed, 3);
> >> >
> >> > Is this what you were talking about?
> >>
> >> Not quite, because with the max() you'd have a problem on Intel Core
> >> Duo/Solo processors
> >> as they do implement the first generation of architected perfmon and
> >> that one did not have
> >> fixed counters. So you'd have to special case family=6 model=14.
> >
> > That has been taken into account actually. Only perfmon v2 and above are
> > supported as you see in intel_pmu_init().
> >
> > 	if (version < 2)
> > 		return -ENODEV;
> >
> I assume this is a current limitation of the implementation. If you
> see version <  2
> you could simply consider having 0 fixed counters and everything else would work
> as expected. But there is a catch, unfortunately, in that there is erratum AE49
> which says that there is only one enable bit to control the two generic counters
> on Core Duo/Solo.
> 

Ideally we could consider having 0 fixed counters for Core Duo/Solo. But
like you said, the erratum you pointed out just complicates things much.

