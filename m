Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYE0NSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYE0NSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYE0NSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:18:23 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52392 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYE0NSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:18:22 -0400
Date: Tue, 27 May 2008 18:49:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527131926.GB5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org> <483C059B.9040301@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <483C059B.9040301@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[sniped]

> >> 3. How do I answer the following problem
> >>
> >> My CPU utilization is 50% at all frequencies (since utilization is
> >> time based), does it mean that frequency scaling does not impact my
> >> workload?
> > 
> > without knowing anything else than this, then yes that would be a
> > logical conclusion: the most likely cause would be because your cpu is
> > memory bound. In fact, you could then scale down your cpu
> > frequency/voltage to be lower, and save some power without losing
> > performance. 
> > It's a weird workload though, its probably a time based thing where you
> > alternate between idle and fully memory bound loads.
> > 
> > (which is another case where your patches would then expose idle time
> > even though your cpu is fully utilized for the 50% of the time it's
> > running)
> 
> We expect the end user to see 50% as scaled utilization and 100% as normal
> utilization. We don't intend to remove tsk->utime and tsk->stime. Our patches
> intend to provide the data and not impose what control action should be taken.

Hi Arjan,

As Balbir mentioned, we are not changing the idle time calculations.
The meaning of current utime and stime are preserved and they are
relative to current CPU capacity.

We are just adding a new metric (which already exist in taskstats) to
provide more utilisation data for higher level management software to
take decisions.

At any time we will have both the traditional utilisation value
relative to current CPU capacity, and scaled utilisation that is
relative to maximum CPU capacity.

--Vaidy
