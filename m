Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbZLPHO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbZLPHO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933747AbZLPHO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:14:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbZLPHOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:14:21 -0500
Subject: Re: [Next] CPU Hotplug test failures on powerpc
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org
In-Reply-To: <4B287242.5070002@in.ibm.com>
References: <4B2224C7.1020908@in.ibm.com> <1260786122.4165.142.camel@twins>
	 <4B261D7A.9040802@in.ibm.com>  <1260793182.4165.223.camel@twins>
	 <1260825420.2217.40.camel@pasglop>  <4B275A6B.9030200@in.ibm.com>
	 <1260873827.4165.362.camel@twins>  <4B279370.5050800@in.ibm.com>
	 <1260889402.4165.434.camel@twins>  <4B287242.5070002@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 08:14:07 +0100
Message-ID: <1260947647.8023.1273.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 11:08 +0530, Sachin Sant wrote:
> Peter Zijlstra wrote:
> > Could you try the below?
> >   
> No luck. Still the same issue. The mask values don't change.

Bugger, that patch did solve a similar problem for a patch I'm working
on.

Can you maybe add a print of the cpu_active_mask() in set_cpu_active()
using WARN() so we can see where it changes the mask, and why it things
its empty?

> > ---
> >  init/main.c |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> >
> > diff --git a/init/main.c b/init/main.c
> > index 4051d75..4be7de2 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -369,12 +369,6 @@ static void __init smp_init(void)
> >  {
> >  	unsigned int cpu;
> >  
> > -	/*
> > -	 * Set up the current CPU as possible to migrate to.
> > -	 * The other ones will be done by cpu_up/cpu_down()
> > -	 */
> > -	set_cpu_active(smp_processor_id(), true);
> > -
> >  	/* FIXME: This should be done in userspace --RR */
> >  	for_each_present_cpu(cpu) {
> >  		if (num_online_cpus() >= setup_max_cpus)
> > @@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
> >  	int cpu = smp_processor_id();
> >  	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
> >  	set_cpu_online(cpu, true);
> > +	set_cpu_active(cpu, true);
> >  	set_cpu_present(cpu, true);
> >  	set_cpu_possible(cpu, true);
> >  }
> >
> >
> >   
> 
> 


