Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZENO7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZENO7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZENO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:59:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36805 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:59:34 -0400
Date: Thu, 14 May 2009 20:28:29 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
Message-ID: <20090514145045.GH4853@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org> <1242226927.26820.30.camel@twins> <20090513151054.GY19296@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090513151054.GY19296@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-05-13 17:10:54]:

> > > Yes that's fine and common, but you actually need to save power for this,
> > > which throttling doesn't do.
> > > 
> > > My understanding this work is a extension of the existing
> > > sched_mc_power_savings features that tries to be optionally more 
> > > aggressive to keep complete package idle so that package level
> > > power saving kicks in.
> > > 
> > > I'm just requesting that they don't call that throttling.
> > 
> > Ah no, this work differs in that regard in that it actually 'generates'
> > idle time, instead of optimizing idle time.
> 
> That is what i meant with "more aggressive to keep complete packages idle"
> above.

Hi Andi,

There is a difference in the framework as Peter has mentioned, we are
trying to create idle times by forcefully reducing work.  From an
end-user point of view, this can be seen as a logical extension of
sched_mc_power_savings... v1 of the RFC extends the framework.

However Ingo suggested that the knob is not intuitive and hence I have
tried to switch to a percentage knob sched_max_capacity_pct.

I am interested in an easy, simple and intuitive framework to evacuate
cores which may imply forcefully reducing (throttling) work.
 
> > Therefore it takes actual cpu time away from real work, which is
> > throttling. Granted, one could call it limiting or similar, but
> > throttling is a correct name.
> 
> That will be always ongoing confusion with the existing established
> term. 
> 
> If you really need to call it throttling use "scheduler throttling"
> or something like that, but a different word would be better.

I think 'scheduler throttling' is good so that we avoid the term 'CPU
throttling' or core throttling.  I had named this cpu evacuation or
core evacuation just to avoid confusion with hardware throttling.

--Vaidy
