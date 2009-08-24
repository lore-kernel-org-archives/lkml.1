Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZHXPdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZHXPdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZHXPdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:33:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55772 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZHXPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:33:14 -0400
Date: Mon, 24 Aug 2009 21:02:29 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
 control MN domain sched policy
Message-ID: <20090824153229.GL6474@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090820131243.GO29327@alberich.amd.com>
 <20090820133914.GW29327@alberich.amd.com>
 <1251125778.7538.268.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251125778.7538.268.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-08-24 16:56:18]:

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
> 
> This configuration space is _way_ too large, and now it gets even
> crazier.

Hi Peter and Andreas,

Actually we had sched_power_savings and related simplifications, but
that did not really simplify the interface.

As for this mulit-node MN stuff, Gautham had posted a better solution
to propagate the sched_mc flags without need for new sysfs file and
related changes.

Please take a look at: http://lkml.org/lkml/2009/3/31/137 and
http://lkml.org/lkml/2009/3/31/142 which actually degenerates the
domain.

However Andreas's requirement seem to indicate multiple nodes within
a single socket.  I did not yet completely understand that topology.
Some for of smart degeneration may save an additional tunable here.

Thanks for pointing me to this patch.

--Vaidy
