Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZHME7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZHME7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZHME7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:59:38 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:49908 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZHME7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:59:38 -0400
Date: Thu, 13 Aug 2009 10:29:31 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090813045931.GB14649@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 08:45:18PM -0400, Len Brown wrote:
> On Thu, 13 Aug 2009, Dipankar Sarma wrote:
> > In a native system, I think we should the platform-specific code
> > export what makes sense. That may be just the lowest possible
> > state only. Or may be more than one.
> 
> For x86, it is 1 state.

Native x86, yes. For virtualized systems, that may not be the
case depending on how the hypervisor behaves.

> > In a virtualized system, we would want to do at least the following -
> 
> Are you talking about Linux as a para-virtualized guest here?
> 
> > 1. An offline configuration state where the hypervisor can
> > take the cpu back and allocate it to another VM.
> 
> The hypervisor gets control no matter what idle state
> the guest enters, yes?

The hypervisor may get control, but what they do may depend
on that the guest OS wished/hinted for - config change or just
shutdown unused cpu if possible for a while.

> > 2. A low-power state where the guest indicates it doesn't need the
> > CPU (and can be put in low power state) but doesn't want to give up 
> > its allocated cpu share. IOW, no visible configuration changes.
> > 
> > So, in any case we would probably want more than one states.
> 
> How are #1 and #2 different when the hypervisor
> gets control in all idle states?  I assert that
> they are the same, and thus 1 state will suffice.

It depends on the hypervisor implementation. On pseries (powerpc)
hypervisor, for example, they are different. By offlining a vcpu
(and in turn shutting a cpu), you will actually create a configuration
change in the VM that is visible to other systems management tools
which may not be what the system administrator wanted. Ideally,
we would like to distinguish between these two states.

Hope that suffices as an example.

Thanks
Dipankar
