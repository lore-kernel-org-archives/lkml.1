Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZHMApm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZHMApm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZHMApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:45:41 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:27990 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZHMApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:45:40 -0400
Date: Wed, 12 Aug 2009 20:45:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Dipankar Sarma <dipankar@in.ibm.com>
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
In-reply-to: <20090812195753.GA14649@in.ibm.com>
Message-id: <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
 <20090806015855.GA20596@sli10-desk.sh.intel.com>
 <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl>
 <20090810081941.GA18649@elf.ucw.cz>
 <1249950137.11545.38184.camel@localhost.localdomain>
 <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Dipankar Sarma wrote:

> On Wed, Aug 12, 2009 at 01:58:06PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > May be having (to pick a number) 3 possible offline states for all
> > > platforms with one for halt equivalent and one for deepest possible that
> > > CPU can handle and one for deepest possible that platform likes for
> > > C-states may make sense. Will keeps things simpler in terms of usage
> > > expectations and possibly reduce the misuse oppurtubity?
> > 
> > Maybe just going to the deepest offline state automatically is the
> > easiest option?

I agree with Pavel and PeterZ on this.

> In a native system, I think we should the platform-specific code
> export what makes sense. That may be just the lowest possible
> state only. Or may be more than one.

For x86, it is 1 state.

> In a virtualized system, we would want to do at least the following -

Are you talking about Linux as a para-virtualized guest here?

> 1. An offline configuration state where the hypervisor can
> take the cpu back and allocate it to another VM.

The hypervisor gets control no matter what idle state
the guest enters, yes?

> 2. A low-power state where the guest indicates it doesn't need the
> CPU (and can be put in low power state) but doesn't want to give up 
> its allocated cpu share. IOW, no visible configuration changes.
> 
> So, in any case we would probably want more than one states.

How are #1 and #2 different when the hypervisor
gets control in all idle states?  I assert that
they are the same, and thus 1 state will suffice.

> > cpu hotplug/unplug should be rare-enough operation that the latencies
> > do not really matter, right?
> 
> As of now, from the platform perspective, I don't think low-power
> state latencies matter in this code path.

Yay, something we all agree on.

> The only thing that might
> have any relevance is electrical power-off technology and whether
> there may be any h/w specific issues restricting its use.
> I don't know that there will be any, but it may not be a good idea to prevent
> platforms from requiring the use of multiple "offline" states.

Can you give an example of such restrictions? (I can't)

I do not advocate integrating features into the kernel
if they can not be tested and it is uncear that they are needed.
Keep it simple.  Add complexity only when it is clear that you must.

thanks,
Len Brown, Intel Open Source Technology Center.
