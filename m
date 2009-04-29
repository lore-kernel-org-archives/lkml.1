Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZD2SKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZD2SKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZD2SKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:10:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:8570 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZD2SKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,267,1239001200"; 
   d="scan'208";a="137377491"
Subject: Re: Mainline kernel OLTP performance update
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1241027196.20099.42.camel@think.oraclecorp.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	 <20090429002930.b786348b.akpm@linux-foundation.org>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63F45@azsmsx501.amr.corp.intel.com>
	 <20090429090706.bc5f462f.akpm@linux-foundation.org>
	 <1241022336.8021.573.camel@laptop>
	 <1241027196.20099.42.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 11:06:53 -0700
Message-Id: <1241028413.4529.9247.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 10:46 -0700, Chris Mason wrote:
> On Wed, 2009-04-29 at 18:25 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-04-29 at 09:07 -0700, Andrew Morton wrote:
> > > On Wed, 29 Apr 2009 08:48:19 -0700 "Styner, Douglas W" <douglas.w.styner@intel.com> wrote:
> > > 
> > > > >-----Original Message-----
> > > > >From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > > >Sent: Wednesday, April 29, 2009 12:30 AM
> > > > >To: Styner, Douglas W
> > > > >Cc: linux-kernel@vger.kernel.org; Tripathi, Sharad C;
> > > > >arjan@linux.intel.com; Wilcox, Matthew R; Kleen, Andi; Siddha, Suresh B;
> > > > >Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F; Nelson,
> > > > >Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan, Rajalakshmi; Garg,
> > > > >Anil K; Chilukuri, Harita; chris.mason@oracle.com
> > > > >Subject: Re: Mainline kernel OLTP performance update
> > > > >
> > > > >On Tue, 28 Apr 2009 10:08:22 -0700 "Styner, Douglas W"
> > > > ><douglas.w.styner@intel.com> wrote:
> > > > >
> > > > >> Summary: Measured the mainline kernel from kernel.org (2.6.30-rc3).
> > > > >>
> > > > >> The regression for 2.6.30-rc3 against the baseline, 2.6.24.2 is 1.91%.
> > > > >Oprofile reports 71.1626% user, 28.8295% system.
> > > > >>
> > > > >> Linux OLTP Performance summary
> > > > >> Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%
> > > > >iowait%
> > > > >> 2.6.24.2                1.000   22106   43709   75      24      0       0
> > > > >> 2.6.30-rc3              0.981   30645   43027   75      25      0       0
> > > > >
> > > > >The main difference there is the interrupt frequency.  Do we know which
> > > > >interrupt source(s) caused this?
> > > >
> > > > Our analysis of the interrupts shows that rescheduling interrupts are
> > > > up 2.2x from 2.6.24.2 --> 2.6.30-rc3.  Qla2xxx interrupts are roughly
> > > > the same.
> > > 
> > > (top-posting repaired)
> > > 
> > > OK, thanks.  Seems odd that the rescheduling interrupt rate increased
> > > while the context-switch rate actually fell a couple of percent.
> > > 
> > > This came up a few weeks ago and iirc Peter was mainly involved, and I
> > > don't believe that anything conclusive ended up happening.  Peter,
> > > could you please remind us of (and summarise) the story here?
> > 
> > I've had several reports about the resched-ipi going in overdrive, but
> > nobody bothered to bisect it, nor have I yet done so -- no clear ideas
> > on why it is doing so.
> > 
> > I'll put it somewhere higher on the todo list.
> > 
> 
> One cause of them in the past was the ondemand cpufreq module.  It got
> fixed up for my laptop workload at least starting w/2.6.29, but it might
> make sense to try without ondemand if you're running it.
> 

Output of
# grep . /sys/devices/system/cpu/cpu0/cpufreq/*
can tell us whether P-state software coordination is the reason behind
excessive resched IPIs. Look for ondemand being the current_governor and
affected_cpus containing more than one CPU in it.

Thanks,
Venki

