Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZHPS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZHPS0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZHPS0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:26:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51717 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZHPS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:26:40 -0400
Date: Sun, 16 Aug 2009 23:56:29 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
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
Message-ID: <20090816182629.GA31027@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain> <20090813045931.GB14649@in.ibm.com> <20090814113021.GL32418@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814113021.GL32418@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 01:30:21PM +0200, Pavel Machek wrote:
> > 
> > It depends on the hypervisor implementation. On pseries (powerpc)
> > hypervisor, for example, they are different. By offlining a vcpu
> > (and in turn shutting a cpu), you will actually create a configuration
> > change in the VM that is visible to other systems management tools
> > which may not be what the system administrator wanted. Ideally,
> > we would like to distinguish between these two states.
> > 
> > Hope that suffices as an example.
> 
> So... you have something like "physically pulling out hotplug cpu" on
> powerpc.

If any system can do physical unplug, then it should do "offline"
with configuration changes reflected in the hypervisor and
other system configuration software.

> But maybe it is useful to take already offline cpus (from linux side),
> and make that visible to hypervisor, too.
> 
> So maybe something like "echo 1 > /sys/devices/system/cpu/cpu1/unplug"
> would be more useful for hypervisor case?

On pseries, we do an RTAS call ("stop-cpu") which effectively permantently
de-allocates it from the VM hands over the control to hypervisor. The
hypervisors may do whatever it wants including allocating it to
another VM. Once gone, the original VM may not get it back depending
on the situation.

The point I am making is that we may not always want to *release*
the CPU to hypervisor and induce a configuration change. That needs
to be reflected by extending the existing user interface - hence
the proposal for - /sys/devices/system/cpu/cpu<#>/state and
/sys/devices/system/cpu/cpu<#>/available_states. It allows
ceding to hypervisor without de-allocating. It is a minor
extension of the existing interface keeping backwards compatibility
and platforms can allow what make sense.

Thanks
Dipankar
