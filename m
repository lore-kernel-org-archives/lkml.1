Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZBCM3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZBCM3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZBCM3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:29:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42172 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZBCM3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:29:04 -0500
Date: Tue, 3 Feb 2009 13:28:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
Message-ID: <20090203122847.GG19979@elte.hu>
References: <200901301729.30284.borntraeger@de.ibm.com> <200902021323.44015.borntraeger@de.ibm.com> <1233619023.16238.12.camel@vayu> <200902030948.13519.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902030948.13519.borntraeger@de.ibm.com>
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Tuesday 03 February 2009 00:57:03 schrieb Suresh Siddha:
> > Does this patch fix the issue? Thanks.
> 
> I fixed up a compile error. (See below). After that, the patch does indeed fix 
> the problem.
> 
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 96439a4..8a0419b 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4026,19 +4026,24 @@ int select_nohz_load_balancer(int stop_tick)
> >  	int cpu = smp_processor_id();
> >
> >  	if (stop_tick) {
> > -		cpumask_set_cpu(cpu, nohz.cpu_mask);
> >  		cpu_rq(cpu)->in_nohz_recently = 1;
> >
> > -		/*
> > -		 * If we are going offline and still the leader, give up!
> > -		 */
> > -		if (!cpu_active(cpu) &&
> > -		    atomic_read(&nohz.load_balancer) == cpu) {
> > +		if (!cpu_active(cpu) {
> 
> That does not compile...I used the following:
> 		if (!cpu_active(cpu)) {

Could you please resubmit an updated patch?

	Ingo
