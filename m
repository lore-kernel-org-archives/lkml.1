Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYKRBF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYKRBF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYKRBFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:05:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:53824 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYKRBF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:05:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,621,1220252400"; 
   d="scan'208";a="640335643"
Date: Mon, 17 Nov 2008 17:05:28 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081118010528.GA22044@linux-os.sc.intel.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com> <492208BE.2000001@zytor.com> <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com> <492209C8.7040602@zytor.com> <20081118004918.GA19416@linux-os.sc.intel.com> <492211C5.7090302@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492211C5.7090302@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 04:52:21PM -0800, H. Peter Anvin wrote:
> Venki Pallipadi wrote:
> > On Mon, Nov 17, 2008 at 04:18:16PM -0800, H. Peter Anvin wrote:
> >> Pallipadi, Venkatesh wrote:
> >>> All C-states higher than C1.
> >>>
> >> Including C2?  If so, the TSC is unusable since C2 can be invoked
> >> asynchronously by the chipset.
> >>
> >
> > No. Not on Intel CPUs atleast. On Intel CPUs, we enter C-states only on
> > hlt or mwait.  C1 is always C1 or C1E, where TSC always runs.
> > C2, C3, ... implementation vary depending on processor and TSC may or may
> > not run. This 0x80000007 feature bit basically says TSC is going to run
> > during any C-state.
> >
> 
> I was under the impression that C2 was invoked by the chipset on a
> thermal condition, at least on older (P3-era) processors.  Is that no
> longer true?  If what you say is above (HLT and MWAIT only), then *was*
> it ever true?

I should also add io port based C-state to HLT and MWAIT. But, that again is
OS initiated.

I don't know of C2 invocation in thermal condition. Thermal condition, all
CPUs that I know of (P3 and beyond), use either clock modulation or frequency
changes. And on some such CPUs, where TSC runs at constant freq during such
modulation/freq change, we set CONSTANT_TSC bit based on model number check.
So, on CPUs earlier than those, we cannot use TSC or we have to scale TSC
based on freq. This patch shouldn't have any impact for those CPUs.

Thanks,
Venki


