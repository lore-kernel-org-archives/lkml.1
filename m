Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZD0Dwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZD0Dwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 23:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZD0Dwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 23:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZD0Dwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 23:52:43 -0400
Date: Mon, 27 Apr 2009 05:52:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090427035216.GD10087@elte.hu>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> Test results for ebizzy 8 threads at various sched_mc settings has 
> been summarised with relative values below. The test platform is 
> dual socket quad core x86 system (pre-Nehalem).
> 
> --------------------------------------------------------
> sched_mc	No Cores	Performance	AvgPower	
> 		used		Records/sec	(Watts)
> --------------------------------------------------------
> 0		8		1.00x		1.00y
> 1		8		1.02x		1.01y
> 2		8		0.83x		1.01y
> 3		7		0.86x		0.97y
> 4		6		0.76x		0.92y
> 5		4		0.72x		0.82y
> --------------------------------------------------------

Looks like we want the kernel default to be sched_mc=1 ?

Regarding the values for 2...5 - is the AvgPower column time 
normalized or workload normalized?

If it's time normalized then it appears there's no power win here at 
all: we'd be better off by throttling the workload directly (by 
injecting sleeps or something like that), right?

	Ingo
