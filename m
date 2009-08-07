Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZHGBC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZHGBC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZHGBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:02:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:34878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZHGBC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,337,1246863600"; 
   d="scan'208";a="714639547"
Date: Fri, 7 Aug 2009 09:02:56 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>, "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090807010256.GA21904@sli10-desk.sh.intel.com>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090806134844.GA19146@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806134844.GA19146@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 09:48:44PM +0800, Gautham R Shenoy wrote:
> Hi Shaohua,
> 
> On Thu, Aug 06, 2009 at 09:58:55AM +0800, Shaohua Li wrote:
> > Hi,
> > 
> > On Wed, Aug 05, 2009 at 10:25:53PM +0800, Gautham R Shenoy wrote:
> > > In this patch-series, we propose to extend the CPU-Hotplug infrastructure
> > > and allow the system administrator to choose the desired state the CPU should
> > > go to when it is offlined. We think this approach addresses the concerns about
> > > determinism as well as transparency, since CPU-Hotplug already provides
> > > notification mechanism which the userspace can listen to for any change
> > > in the configuration and correspondingly readjust any previously set
> > > cpu-affinities.
> > Peter dislikes any approach (including cpuhotplug) which breaks userspace policy,
> > even userspace can get a notification.
> 
> I think Peter's problem was more to do with the kernel offlining the CPUs
> behind the scenes, right ?
> 
> We don't do that in this patch series. The option to offline the CPUs is
> very much with the admin. The patch-series only provides the interface
> that helps the admin choose the state the CPU must reside in when it
> goes offline.
but the goal is to use cpu offline to save power, right? So we still have
Peter's problem.
 
> > > Also, approaches such as [1] can make use of this
> > > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > > when it is offlined, thereby providing the system administrator a rope to hang
> > > himself with should he feel the need to do so.
> > I didn't see the reason why administrator needs to know which state offline cpu
> > should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> > C-state is already preferred.
> 
> We can still provide a sane default value based on what states are
> available and what the BIOS limits us to. Thus we can still use the
> idle-state-offline patch that Venki posted sometime ago, right ?
My original concern about Venki's patch is the C-state limition, but Venki
thought if CPU has the limition, CPU should disable specific C-state, so this
isn't a problem. I had no objection about the infrastructure itself, but just
wonder why we need it.

Thanks,
Shaohua
