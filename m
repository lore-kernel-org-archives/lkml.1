Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZHFEfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZHFEfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZHFEfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:35:09 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56843 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZHFEfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:35:07 -0400
Date: Thu, 6 Aug 2009 10:03:51 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090806043351.GC14333@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
 <20090806015855.GA20596@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090806015855.GA20596@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shaohua Li <shaohua.li@intel.com> [2009-08-06 09:58:55]:

> Hi,
> 
> On Wed, Aug 05, 2009 at 10:25:53PM +0800, Gautham R Shenoy wrote:
> > In this patch-series, we propose to extend the CPU-Hotplug infrastructure
> > and allow the system administrator to choose the desired state the CPU should
> > go to when it is offlined. We think this approach addresses the concerns about
> > determinism as well as transparency, since CPU-Hotplug already provides
> > notification mechanism which the userspace can listen to for any change
> > in the configuration and correspondingly readjust any previously set
> > cpu-affinities.
> Peter dislikes any approach (including cpuhotplug) which breaks userspace policy,
> even userspace can get a notification.

Hi Shaohua,

Notification to userspace and an opportunity to react to the situation
is certainly better to manage as compared to under-the-cover reduction
in capacity.

We are already doing something to this effect in virtualized guests
where VCPU entitlement and assignment can be changed by the hypervisor
based on resource constraints.  This framework with notification and
determinism will help manage cpu capacity better.

I agree with Peter that scheduler approach is better, but it is not
deterministic.  This is simpler and cleaner alternative to keep the
complexity in userspace and provide only framework to control/notify
kernel.
 
> > Also, approaches such as [1] can make use of this
> > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > when it is offlined, thereby providing the system administrator a rope to hang
> > himself with should he feel the need to do so.
> I didn't see the reason why administrator needs to know which state offline cpu
> should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> C-state is already preferred.

Yes that is what we would expect, but the deepest sleep state may be
restricted by BIOS or other system level parameters.  This was the
main objection to Venki's deepest sleep state for offline cpus patch.
There could be higher level policy that restricts the deepest level
C-states for various reasons.  This framework is to provide an
opportunity to adhere to the policy with userspace inputs.  This
framework also helps to choose different states in a virtualized
system.

--Vaidy

