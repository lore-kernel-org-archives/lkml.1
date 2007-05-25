Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbXEYSXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbXEYSXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763353AbXEYSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:23:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48584 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbXEYSXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:23:47 -0400
Subject: Re: [patch] i386, numaq: enable TSCs again
From: john stultz <johnstul@us.ibm.com>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, William Lee Irwin III <wli@holomorphy.com>,
       Andi Kleen <andi@firstfloor.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1180116978.14844.69.camel@localhost.localdomain>
References: <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
	 <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu>
	 <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu>
	 <20070525075446.GA20140@elte.hu> <20070525080827.GA22399@elte.hu>
	 <20070525081944.GZ31925@holomorphy.com> <20070525083153.GA27236@elte.hu>
	 <20070525083813.GA19966@holomorphy.com>  <20070525084115.GA29077@elte.hu>
	 <1180116978.14844.69.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 25 May 2007 11:23:26 -0700
Message-Id: <1180117406.6345.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 11:16 -0700, Dave Hansen wrote:
> On Fri, 2007-05-25 at 10:41 +0200, Ingo Molnar wrote:
> > * William Lee Irwin III <wli@holomorphy.com> wrote:
> > > > yes, that's what i meant under 'slightly async'. Some AMD CPUs are 
> > > > like that too and sched_clock() now handles that fine. So we should 
> > > > try my patch.
> > > 
> > > Sorry, then. I took slight to mean something else. In any event I was 
> > > only quantifying things. I've no opinion whatsoever on the impact of 
> > > the code on NUMA-Q, only some recall of its operating characteristics.
> > 
> > there's no need to apologize at all! Thanks for reminding us about the 
> > time-scale and nature of the TSC drift on NUMAQ. I was worried that 
> > maybe the TSC was totally unusable for some reason - but that's 
> > fortunately not the case. So we now have one quirk less, hopefully :-)
> 
> Last I remember, it was totally useless for timekeeping, but was useful
> for cpu-local time measurements.
> 
> John, it's still useless for time, right?  Does sched_clock() really fix
> it?

Yea, on multi-node NUMAQ the TSC shouldn't be used for timekeeping.

However it should be fine for sched_clock(), or other cpu-local
measurements as the TSCs are constant (no cpufreq, no deep sleep
states).

-john

