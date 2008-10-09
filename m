Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYJIXXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYJIXXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJIXW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:22:56 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54767 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYJIXW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:22:56 -0400
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Chris Snook <csnook@redhat.com>
Cc: Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Hansen <x@jeffhansen.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <48EE8AB2.5000302@redhat.com>
References: <Pine.LNX.4.64.0810071640110.25661@ren>
	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>
	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>
	 <alpine.LFD.2.00.0810090910510.3237@apollo>	 <48EE4FC4.7070902@redhat.com>
	 <alpine.LFD.2.00.0810092118100.3271@apollo>
	 <Pine.LNX.4.64.0810091344250.24851@ren>
	 <alpine.LFD.2.00.0810092152410.3271@apollo>
	 <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
	 <48EE71A9.2010907@redhat.com> <1223589220.32639.24.camel@alok-dev1>
	 <48EE8AB2.5000302@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 09 Oct 2008 16:22:55 -0700
Message-Id: <1223594575.32639.58.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:50 -0700, Chris Snook wrote:
> Alok Kataria wrote:
> > On Thu, 2008-10-09 at 14:03 -0700, Chris Snook wrote:
> >
> > I agree that in general this should be no, but since this is a
> > commandline variable it will be normally set for only those systems
> > which have only TSC as a option or know that the TSC is reliable.
> > wouldn't doing this be ok for such systems ?
> 
> Hardware doesn't deliberately do any TSC synchronization, though you might get
> it by accident in some configurations.  A VMware guest gets it for free thanks
> to the hypervisor doing it in software, but we need to run the check when we're
> booting on bare metal. 

The TSC sync algorithm right now expects that TSC are perfectly in sync
between cpus.
But, the hardware doesn't deliberately do any synchronization, so we can
have situations where TSC was (accidently ? )off by a marginal value
during boot and as a result we mark TSC as unstable and don't use it as
a clocksource at all. For systems like the ones Jeff is using wouldn't
that be a problem. IOW, even though the TSC was *marginally* off during
bootup it should still be used as a clocksource, since you have no other
option, no ? 

>  Jeff's patch enables the feature with as little risk as
> possible.  TSC sync is pretty cheap, so it's not worth it to add a more
> dangerous special case just for guests of certain hypervisors.

I am not saying that we should go ahead and disable TSC sync for all
cases, we can very well do that just when running on a particular type
of system. The point here is to understand what should we do in a case
like above, on physical hardware.

Thanks,
Alok

> -- Chris

