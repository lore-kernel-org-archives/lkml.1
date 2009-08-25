Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZHYGZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZHYGZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZHYGZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:25:01 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:34279 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205AbZHYGZA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:25:00 -0400
X-SpamScore: -2
X-BigFish: VPS-2(z1857r34a4j8deiz1432R98dN936eM13f4ja594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOX5TA-01-BNI-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 08:24:32 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090825062432.GB20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251125778.7538.268.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 06:24:33.0285 (UTC) FILETIME=[B5E42350:01CA254C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:56:18PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> 
> > +#ifdef CONFIG_SCHED_MN
> > +	if (!err && mc_capable())
> > +		err = sysfs_create_file(&cls->kset.kobj,
> > +					&attr_sched_mn_power_savings.attr);
> > +#endif
> 
> *sigh* another crappy sysfs file
> 
> Guys, can't we come up with anything better than sched_*_power_saving=n?

Thought this is a settled thing. At least there are already two
such parameters. So using the existing convention is an obvious
thing, no?
 
> This configuration space is _way_ too large, and now it gets even
> crazier.

I don't fully agree.

Having one control interface for each domain level is just one
approach. It gives the user full control of scheduling policies.
It just might have to be properly documented.

In another mail Vaidy mentioned that

  "at some point we wanted to change the interface to
   sched_power_savings=N and and set the flags according to system
   topology".

But how you'll decide at which domain level you have to do power
savings scheduling?

Using sched_mn_power_savings=1 is quite different from
sched_smt_power_savings=1. Probably, the most power you save if you
switch on power saving scheduling on each domain level. I.e. first
filling threads of one core, then filling all cores on one internal
node, then filling all internal nodes of one socket.

But for performance reasons a user might just want to use power
savings in the MN domain. How you'd allow the user to configure that
with just one interface? Passing the domain level to
sched_power_savings, e.g.  sched_power_savings=MC instead of the power
saving level?

Besides that, don't we have to keep the user-interface stable, i.e.
stick to sched_smt_power_savings and sched_mc_power_savings?


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


