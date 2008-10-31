Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYJaRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYJaRJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYJaRJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:09:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:46612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYJaRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,523,1220252400"; 
   d="scan'208";a="354529936"
Date: Fri, 31 Oct 2008 10:09:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: sched domains oddness.
Message-ID: <20081031170928.GB10468@linux-os.sc.intel.com>
References: <20081031162443.GA29885@redhat.com> <1225471911.7803.1596.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225471911.7803.1596.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 09:51:51AM -0700, Peter Zijlstra wrote:
> On Fri, 2008-10-31 at 12:24 -0400, Dave Jones wrote:
> > The attached dmesg comes from my dual core laptop running 2.6.27
> > What's up with all the sched domains transitions at the bottom?
> > This was just a boot up from power off, no suspend/resume or anything funky.
> 
> > CPU0 attaching NULL sched-domain.
> > CPU1 attaching NULL sched-domain.
> > CPU0 attaching sched-domain:
> >  domain 0: span 0-1 level MC
> >   groups: 0 1
> >   domain 1: span 0-1 level NODE
> >    groups: 0-1
> > CPU1 attaching sched-domain:
> >  domain 0: span 0-1 level MC
> >   groups: 1 0
> >   domain 1: span 0-1 level NODE
> >    groups: 0-1
> 
> 3x
> 
> looks like someone is triggering rebuild_sched_domains(), is something
> poking cpusetfs files or flipping between sched_mc settings?

I remember someone mentioning that some distro's started setting
sched_mc_power_savings to '1' by default during boot. On a dual-core
laptop, this will not give any advantage.

I have to fix the code to not export this tunable, when we have only
socket in the system.

Dave, Is your distro also setting this tunable blindly during boot :(

thanks,
suresh
