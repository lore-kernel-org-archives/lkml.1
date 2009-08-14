Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZHNLag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZHNLag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZHNLae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:30:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38740 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZHNLab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:30:31 -0400
Date: Fri, 14 Aug 2009 13:30:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Len Brown <lenb@kernel.org>,
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
Message-ID: <20090814113021.GL32418@elf.ucw.cz>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain> <20090813045931.GB14649@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813045931.GB14649@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 2. A low-power state where the guest indicates it doesn't need the
> > > CPU (and can be put in low power state) but doesn't want to give up 
> > > its allocated cpu share. IOW, no visible configuration changes.
> > > 
> > > So, in any case we would probably want more than one states.
> > 
> > How are #1 and #2 different when the hypervisor
> > gets control in all idle states?  I assert that
> > they are the same, and thus 1 state will suffice.
> 
> It depends on the hypervisor implementation. On pseries (powerpc)
> hypervisor, for example, they are different. By offlining a vcpu
> (and in turn shutting a cpu), you will actually create a configuration
> change in the VM that is visible to other systems management tools
> which may not be what the system administrator wanted. Ideally,
> we would like to distinguish between these two states.
> 
> Hope that suffices as an example.

So... you have something like "physically pulling out hotplug cpu" on
powerpc.

But maybe it is useful to take already offline cpus (from linux side),
and make that visible to hypervisor, too.

So maybe something like "echo 1 > /sys/devices/system/cpu/cpu1/unplug"
would be more useful for hypervisor case?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
