Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYFBRwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYFBRwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYFBRw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:52:29 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57567 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbYFBRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:52:28 -0400
Date: Mon, 2 Jun 2008 23:24:00 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080602175400.GN5504@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org> <483C059B.9040301@linux.vnet.ibm.com> <20080531212709.GA6757@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080531212709.GA6757@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2008-05-31 23:27:10]:

> Hi!
> 
> > > without knowing anything else than this, then yes that would be a
> > > logical conclusion: the most likely cause would be because your cpu is
> > > memory bound. In fact, you could then scale down your cpu
> > > frequency/voltage to be lower, and save some power without losing
> > > performance. 
> > > It's a weird workload though, its probably a time based thing where you
> > > alternate between idle and fully memory bound loads.
> > > 
> > > (which is another case where your patches would then expose idle time
> > > even though your cpu is fully utilized for the 50% of the time it's
> > > running)
> > 
> > We expect the end user to see 50% as scaled utilization and 100% as normal
> > utilization. We don't intend to remove tsk->utime and tsk->stime. Our patches
> > intend to provide the data and not impose what control action should be taken.
> 
> Aha, ok, forget about my regression comments.
> 
> Still, what you want to do seems hard. What if cpu is running at max
> frequency but memory is not? What if cpu and memory is running at max
> frequency but frontside bus is not?

uh... you made the scope of the problem bigger :)
If we take into consideration various system parameters like memory,
fsb that we can control to save power, then this scaling factor is not
accurate.

> You want some give_me_bogomips( cpu freq, mem freq, fsb freq ) function,
> but that depends on workload, so it is impossible to do...

Isn't this a good problem to solve :)

Lets start adding parameters in steps to make the scaled statistics
accurate.  We want to start with cpu and see if we can provide
a reasonable solution.

Workload variation is outside the scope since we are estimating how
much cpu was provided to the application or workload. The fact that
the workload could not utilise them effectively is not an accounting
problem.  Accounting the exact cpu resource that an application used
is a performance feedback problem which can potentially be derived
from accounting.

--Vaidy
