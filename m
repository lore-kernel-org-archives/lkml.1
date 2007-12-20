Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXLTCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXLTCLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 21:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbXLTCLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 21:11:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:61001 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXLTCLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 21:11:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,186,1196668800"; 
   d="scan'208";a="450888996"
Date: Wed, 19 Dec 2007 18:08:47 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071220020846.GA13464@linux-os.sc.intel.com>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219193255.GA2158@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 08:32:55PM +0100, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Aviod TLB flush IPIs during C3 states by voluntary leave_mm() before 
> > entering C3.
> > 
> > The performance impact of TLB flush on C3 should not be significant 
> > with respect to C3 wakeup latency. Also, CPUs tend to flush TLB in 
> > hardware while in C3 anyways.
> > 
> > On a 8 logical CPU system, running make -j2, the number of tlbflush 
> > IPIs goes down from 40 per second to ~ 0. Total number of interrupts 
> > during the run of this workload was ~1200 per second, which makes it 
> > ~3% savings in wakeups.
> > 
> > There was no measurable performance or power impact however.
> 
> thanks, applied to x86.git. Nice and elegant patch!
> 
> Btw., since the TLB flush state machine is really subtle and fragile, 
> could you try to run the following mmap stresstest i wrote some time 
> ago:
> 
>    http://redhat.com/~mingo/threaded-mmap-stresstest/
> 
> for a couple of hours. It runs nr_cpus threads which then do a "random 
> crazy mix" of mappings/unmappings/remappings of a 800 MB memory window. 
> The more sockets/cores, the crazier the TLB races get ;-)
> 

Ingo,

I ran this stress test on two systems (8 cores and 2 cores) for over
4 hours without any issues. There was more than 20% C3 time during the
run. So, this C3 tlbflush path must have been stressed well during the run.

And sorry about the patch not working on UP config. That was a silly oversight
on my part.

Thanks,
Venki
