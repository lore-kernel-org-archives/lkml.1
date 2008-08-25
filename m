Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYHYRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYHYRew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYHYRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:34:45 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34380 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYHYReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:34:44 -0400
Subject: Re: [BUG] cpufreq: constant cpu_khz
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       davej <davej@codemonkey.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080825123926.GC8663@elte.hu>
References: <1219646032.20732.10.camel@twins>
	 <1219664106.8515.50.camel@twins>  <20080825123926.GC8663@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 25 Aug 2008 10:34:35 -0700
Message-Id: <1219685675.1979.5.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 05:39 -0700, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > I noticed that my sched_clock() was slow on a number of machine, so
> > > I started looking at cpufreq.
> >
> > The below seems to fix the problem for me, but I don't have enough
> > clue to know if its the correct fix, please advise.
> 
> > -     set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
> > +     set_cyc2ns_scale(tsc_khz, freq->cpu);
> 
> hm, that too is due to the tsc.c unification - Alok Cc:-ed. Applied your
> fix to x86/urgent.
> 

Yes the fix is correct, tsc_khz can change in the loop above.
Looking at tsc_64.c before the integration, that too had this bug but
32bit was good. So this is the right fix.

Thanks,
Alok


>         Ingo

