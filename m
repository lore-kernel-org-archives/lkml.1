Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZHYHwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZHYHwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZHYHwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:52:02 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:14480 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753970AbZHYHwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:52:01 -0400
X-SpamScore: -13
X-BigFish: VPS-13(z1857r34a4j8deiz1432R98dN936eM4015L148cMa594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOX9UD-02-4K3-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 09:50:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090825075055.GA15389@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins> <20090824153229.GL6474@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090824153229.GL6474@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 07:50:56.0681 (UTC) FILETIME=[C76F9990:01CA2558]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 09:02:29PM +0530, Vaidyanathan Srinivasan wrote:
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
> 
> As for this mulit-node MN stuff, Gautham had posted a better solution
> to propagate the sched_mc flags without need for new sysfs file and
> related changes.

For Magny-Cours it might be sufficient to just propagate the sched_mc
flags into the MN domain. But then the MC domain shouldn't use the
sched_mc power saving flag (for performance reasons). But I don't know
what other multi-node CPUs we will have in the future. So on an
abstract level power savings scheduling in sched_mc is not equal to
power savings scheduling on sched_mn.

> Please take a look at: http://lkml.org/lkml/2009/3/31/137 and
> http://lkml.org/lkml/2009/3/31/142 which actually degenerates the
> domain.
> 
> However Andreas's requirement seem to indicate multiple nodes within
> a single socket.  I did not yet completely understand that topology.
> Some for of smart degeneration may save an additional tunable here.

I doubt that a "form of smart degeneration" would help. You want to
have sched_groups for each internal node and you most likely always
want to do balancing between those two. But in case of power saving
scheduling you want to utilize an entire socket before you deploy
another socket. Hence I think, in the end, "smart degeneration" would
rather mean some sort of hackery which won't make the code easier.

> Thanks for pointing me to this patch.

Dito.
I'll have a look at your power savings simplifications asap.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


