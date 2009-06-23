Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZFWIQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZFWIQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFWIQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:16:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:28741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZFWIQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="527017220"
Date: Tue, 23 Jun 2009 15:59:59 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: eranian@gmail.com
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: perf_counter Atom patch
Message-ID: <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com> <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:45:03AM +0200, stephane eranian wrote:
>
> Unfortunately, I don't have a N270 to compare with your results.
> We need to verify whether or not N270 implements the fixed counters.
> Does it report architected perfmon v3 or v1?
> 

All Atom processors report perfmon v3 as specified in SDM. N270 is no
exception.

> > The return value of CPUID(0xa) is indeed bogus, too and there is another quirk for that in
> > intel_pmu_init() in arch/x86/kernel/cpu/perf_counter.c
> >
> > x86_pmu.num_counters_fixed ?? ?? ??= max((int)edx.split.num_counters_fixed, 3);
> >
> > Is this what you were talking about?
> 
> Not quite, because with the max() you'd have a problem on Intel Core
> Duo/Solo processors
> as they do implement the first generation of architected perfmon and
> that one did not have
> fixed counters. So you'd have to special case family=6 model=14.

That has been taken into account actually. Only perfmon v2 and above are
supported as you see in intel_pmu_init().

	if (version < 2)
		return -ENODEV;

