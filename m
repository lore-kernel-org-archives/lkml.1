Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZHYIBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZHYIBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZHYIBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:01:03 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:27720 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbZHYIBB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:01:01 -0400
X-SpamScore: -8
X-BigFish: VPS-8(z1857r34a4j8deiz1432R98dN936eM4015La594izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOXA9F-01-1QT-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 10:00:20 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/15] sched: Check for sched_mn_power_savings when
	doing load balancing
Message-ID: <20090825080020.GD20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134104.GY29327@alberich.amd.com> <1251126220.7538.273.camel@twins> <20090824154013.GM6474@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090824154013.GM6474@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 08:00:20.0598 (UTC) FILETIME=[178E8160:01CA255A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 09:10:13PM +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-08-24 17:03:40]:
> 
> > On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> > > The patch adds support for POWERSAVINGS_BALANCE_BASIC for MN domain
> > > level. Currently POWERSAVINGS_BALANCE_WAKEUP is not used for MN domain.
> > > 
> > > (I have to admit that so far I don't have the correct understanding
> > > what's the benefit of POWERSAVINGS_BALANCE_WAKEUP (when an deticated
> > > wakeup CPU is used) in contrast to POWERSAVINGS_BALANCE_BASIC.  I also
> > > have not found an example that would demonstrate the difference
> > > between those two powersaving levels.)
> > 
> > blame svaidy for not writing enough comments ;-)
> 
> I am here to explain ;)
> 
> > iirc it moves tasks to sched_mv_preferred_wakeup_cpu instead of waking
> > an idle cpu, this leaves idle cpus idle longer at the cost of creating
> > overload on other cpus.
> 
> Yes, as Peter said, the POWERSAVINGS_BALANCE_WAKEUP biases task
> wakeups to sched_mc_preferred_wakeup_cpu which has been nominated from
> previous load balance loops.
> 
> Task wakeup biasing of sched_mc=2 works for most workloads like
> kernbench and other sleeping tasks that come in and out of runqueue.
> The default sched_mc=1 will work only for jobs running much longer
> than the loadbalance interval or almost 100% CPU intensive job where

Ok, one of my tests was using 100% CPU intensive jobs and for those
the sched_mc=1 or sched_mn=1 level was sufficient to show the effect
of loadbalancing.

> the load balancer can take time to identify the load pattern and
> initiate a task migrate.

> The wakeup biasing (sched_mc=2) will help move bursty jobs faster and
> statistically pack them in single package and save power.

That means that wakeup biasing will also make sense for the MN domain.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


