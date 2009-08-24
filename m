Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZHXPqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZHXPqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZHXPqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:46:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:36945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZHXPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:46:02 -0400
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
 control MN domain sched policy
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <20090824153229.GL6474@dirshya.in.ibm.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins>
	 <20090824153229.GL6474@dirshya.in.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:45:14 +0200
Message-Id: <1251128714.7538.308.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 21:02 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-08-24 16:56:18]:
> 
> > On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > ---
> > 
> > > +#ifdef CONFIG_SCHED_MN
> > > +	if (!err && mc_capable())
> > > +		err = sysfs_create_file(&cls->kset.kobj,
> > > +					&attr_sched_mn_power_savings.attr);
> > > +#endif
> > 
> > *sigh* another crappy sysfs file
> > 
> > Guys, can't we come up with anything better than sched_*_power_saving=n?
> > 
> > This configuration space is _way_ too large, and now it gets even
> > crazier.
> 
> Hi Peter and Andreas,
> 
> Actually we had sched_power_savings and related simplifications, but
> that did not really simplify the interface.

Well, I prefer a single sched_power knob that either goes on or off.

A user really isn't interested in exploring a 3^3 configuration space
{PERF, POWER, POWER-WAKE-BALANCE} x {SMT, MC, MN} in order to find what
works best.

> As for this mulit-node MN stuff, Gautham had posted a better solution
> to propagate the sched_mc flags without need for new sysfs file and
> related changes.
> 
> Please take a look at: http://lkml.org/lkml/2009/3/31/137 and
> http://lkml.org/lkml/2009/3/31/142 which actually degenerates the
> domain.

Ah, right, that got lost in my inbox :/ Let me go read those too.

> However Andreas's requirement seem to indicate multiple nodes within
> a single socket.  I did not yet completely understand that topology.
> Some for of smart degeneration may save an additional tunable here.

Yes, apparently AMD is going to put multiple nodes in a single socket,
not sure how they do that, Andreas do these chips have multiple memory
busses?

I was thinking chips were pin constrained and wouldn't add a whole
second memory interface to the package, but what do I know...


