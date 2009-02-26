Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZBZPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZBZPpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBZPpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:45:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZBZPpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:45:46 -0500
Date: Thu, 26 Feb 2009 16:45:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, tglx@linutronix.de, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arun@linux.vnet.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090226154526.GD352@elte.hu>
References: <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com> <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com> <20090223103814.GB8817@dirshya.in.ibm.com> <20090223110725.GB17312@elte.hu> <20090226085831.GA28397@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226085831.GA28397@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dipankar Sarma <dipankar@in.ibm.com> wrote:

> On Mon, Feb 23, 2009 at 12:07:25PM +0100, Ingo Molnar wrote:
> > 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > * Identify set of idle CPUs (CPU package) from which timers 
> > >   can be removed
> > > * Identify a semi-idle or idle CPU package to which the timers
> > >   can be moved
> > > * Decide when to start moving timers as the system has large
> > >   number of idle CPUs
> > > * Decide when to stop migrating as system becomes less idle
> > >   and utilisation increases
> > > 
> > > Guiding all of the above decisions from user space may not be 
> > > fast enough.
> > 
> > Exactly.
> 
> That is true for power management. However there are other 
> situations where we may need targeted avoidance of timers. 
> Certain type of applications - HPC for example - prefer 
> avoidance of jitters due to periodic timers. It would be good 
> to be able to say "avoid these CPUs for timers" while they are 
> being used for HPC tasks.

Yes - but that kind of policy should be coupled and expressed 
via cpusets. /proc based irq_affinity is just a limited, 
inflexible hack. All things IRQ partitioning should be handled 
via cpusets - perhaps via the 'system sets' idea from Peter?

	Ingo
