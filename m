Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZLFFTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZLFFTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 00:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZLFFTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 00:19:33 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60138 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZLFFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 00:19:32 -0500
Date: Sun, 6 Dec 2009 10:49:28 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Torsten Duwe <duwe@lst.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v10 PATCH 2/9]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20091206051928.GA18300@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091202095427.GA27251@linux.vnet.ibm.com>
 <20091202095705.GC27251@linux.vnet.ibm.com>
 <200912042320.01320.duwe@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200912042320.01320.duwe@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Torsten Duwe <duwe@lst.de> [2009-12-04 23:20:00]:

> On Wednesday 02 December 2009, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-12-02 15:24:27]:
> >
> > This patch cleans up drivers/cpuidle/cpuidle.c
> > Earlier cpuidle assumed pm_idle as the default idle loop. Break that
> > assumption and make it more generic.
> 
> Is there a problem with the old pm_idle? Couldn't it be integrated more 
> transparently, instead of replacing it this intrusively?
> 

Hi Torsten,

Peter objected to the idea of integrating this with the old pm_idle
because it has already caused a lot of problems on x86 and we wouldn't
want to be doing the same mistake on POWER. The discussion related to
that could be found here http://lkml.org/lkml/2009/8/26/233

> > --- linux.trees.git.orig/include/linux/cpuidle.h
> > +++ linux.trees.git/include/linux/cpuidle.h
> > @@ -41,7 +41,7 @@ struct cpuidle_state {
> >  	unsigned long long	usage;
> >  	unsigned long long	time; /* in US */
> >
> > -	int (*enter)	(struct cpuidle_device *dev,
> > +	void (*enter)	(struct cpuidle_device *dev,
> >  			 struct cpuidle_state *state);
> >  };
> 
> While it may be a good idea to move the residency calculation to one central 
> place, at least in theory a cpuidle_state->enter() function could have a 
> better method to determine its value.
>

This would mean a lot of code replication, which Pavel pointed out in
the previous iteration. So I moved the residency calculation to a
central place.

> Either way you're implicitly introducing an API change here, and you're at 
> least missing two functions on ARM and SuperH, respectively. Could you 
> separate this API change out, and not take it for granted in the other 
> patches?
>
> 	Torsten
