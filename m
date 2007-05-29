Return-Path: <linux-kernel-owner+w=401wt.eu-S1765623AbXE2Ut0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765623AbXE2Ut0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXE2UtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:49:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:7341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbXE2UtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="250887327"
Date: Tue, 29 May 2007 13:45:57 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, colpatch@us.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070529204557.GB3693@linux-os.sc.intel.com>
References: <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46561E67.3030207@bigpond.net.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 04:23:19PM -0700, Peter Williams wrote:
> Siddha, Suresh B wrote:
> > On Thu, May 24, 2007 at 12:43:58AM -0700, Peter Williams wrote:
> > >
> > > Further testing indicates that CONFIG_SCHED_MC is not implicated and
> > > it's CONFIG_SCHED_SMT that's causing the problem.  This rules out the
> > > code in find_busiest_group() as it is common to both macros.
> > >
> > > I think this makes the scheduling domain parameter values the most
> > > likely cause of the problem.  I'm not very familiar with this code so
> > > I've added those who've modified this code in the last year or
> > > so to the
> > > address of this e-mail.
> >
> > What platform is this? I remember you mentioned its a 2 cpu box. Is it
> > dual core or dual package or one with HT?
> 
> It's a single CPU HT box i.e. 2 virtual CPUs.  "cat /proc/cpuinfo"
> produces:

Peter, I tried on a similar box and couldn't reproduce this problem
with x86_64 2.6.22-rc3 kernel and using defconfig(has SCHED_SMT turned on).
I am using top and just the spinners.  I don't have gkrellm running, is that
required to reproduce the issue?

I tried number of times and also in runlevels 3,5(with top running
in a xterm incase of runlevel 5).

In runlevel 5, occasionally for one refresh screen of top, I see three
spinners on one cpu and one spinner on other(with X or someother app
also on the cpu with one spinner). But it balances nicely for the
immd next refresh of the top screen.

I tried with various refresh rates of top too.. Do you see the issue
at runlevel 3 too?

thanks,
suresh
