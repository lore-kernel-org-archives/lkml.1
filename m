Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZH0Mrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZH0Mrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZH0Mrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:47:36 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:2996 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZH0Mrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:47:35 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z1857r34a4j8deiz1432R98dN4015La594izz1202hzzz32i203h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KP1CUX-02-8GA-02
X-M-MSG: 
Date: Thu, 27 Aug 2009 14:47:12 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Gautham R Shenoy <ego@in.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090827124712.GC13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com> <20090826093043.GA22064@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090826093043.GA22064@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Aug 2009 12:47:12.0934 (UTC) FILETIME=[7FBC0C60:01CA2714]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 03:00:43PM +0530, Gautham R Shenoy wrote:
> Hi Andreas,
> 
> On Thu, Aug 20, 2009 at 03:39:14PM +0200, Andreas Herrmann wrote:
> > @@ -9208,6 +9229,11 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
> >  		err = sysfs_create_file(&cls->kset.kobj,
> >  					&attr_sched_mc_power_savings.attr);
> >  #endif
> > +#ifdef CONFIG_SCHED_MN
> > +	if (!err && mc_capable())
> > +		err = sysfs_create_file(&cls->kset.kobj,
> > +					&attr_sched_mn_power_savings.attr);
> > +#endif
> 
> This would create the sysfs tunable even on systems which are
> mc_capable() but don't have multi-nodes on a package, no ?

Yes, that is a bug. I should have introduced mn_capable() to
create this file only if really required.


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


