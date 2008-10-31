Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJaTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJaTIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJaTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:08:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYJaTId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:08:33 -0400
Date: Fri, 31 Oct 2008 15:08:20 -0400
From: Dave Jones <davej@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: sched domains oddness.
Message-ID: <20081031190820.GA14435@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20081031162443.GA29885@redhat.com> <1225471911.7803.1596.camel@twins> <20081031170928.GB10468@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031170928.GB10468@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:09:29AM -0700, Suresh Siddha wrote:
 > On Fri, Oct 31, 2008 at 09:51:51AM -0700, Peter Zijlstra wrote:
 > > On Fri, 2008-10-31 at 12:24 -0400, Dave Jones wrote:
 > > > The attached dmesg comes from my dual core laptop running 2.6.27
 > > > What's up with all the sched domains transitions at the bottom?
 > > > This was just a boot up from power off, no suspend/resume or anything funky.
 > > 
 > > > CPU0 attaching NULL sched-domain.
 > > > CPU1 attaching NULL sched-domain.
 > > > CPU0 attaching sched-domain:
 > > >  domain 0: span 0-1 level MC
 > > >   groups: 0 1
 > > >   domain 1: span 0-1 level NODE
 > > >    groups: 0-1
 > > > CPU1 attaching sched-domain:
 > > >  domain 0: span 0-1 level MC
 > > >   groups: 1 0
 > > >   domain 1: span 0-1 level NODE
 > > >    groups: 0-1
 > > 
 > > 3x
 > > 
 > > looks like someone is triggering rebuild_sched_domains(), is something
 > > poking cpusetfs files or flipping between sched_mc settings?
 > 
 > I remember someone mentioning that some distro's started setting
 > sched_mc_power_savings to '1' by default during boot. On a dual-core
 > laptop, this will not give any advantage.
 > 
 > I have to fix the code to not export this tunable, when we have only
 > socket in the system.
 > 
 > Dave, Is your distro also setting this tunable blindly during boot :(

So I found something (pm-utils) that seems to have mechanism for changing sched_mc
Though it's not obvious to me how this is getting invoked.
One question I have though is that to set this sensibly, it seems that
userspace is going to have to have understanding of how the topology is
layed out.  Given the kernel already knows, perhaps not making that
sysfs file present on systems where it doesn't make sense would be simpler ?

	Dave

-- 
http://www.codemonkey.org.uk
