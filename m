Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYJIXik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYJIXik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJIXib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:38:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYJIXib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:38:31 -0400
Message-ID: <48EE959D.7090706@redhat.com>
Date: Thu, 09 Oct 2008 19:37:01 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Hansen <x@jeffhansen.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
References: <Pine.LNX.4.64.0810071640110.25661@ren>	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>	 <alpine.LFD.2.00.0810090910510.3237@apollo>	 <48EE4FC4.7070902@redhat.com>	 <alpine.LFD.2.00.0810092118100.3271@apollo>	 <Pine.LNX.4.64.0810091344250.24851@ren>	 <alpine.LFD.2.00.0810092152410.3271@apollo>	 <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>	 <48EE71A9.2010907@redhat.com> <1223589220.32639.24.camel@alok-dev1>	 <48EE8AB2.5000302@redhat.com> <1223594575.32639.58.camel@alok-dev1>
In-Reply-To: <1223594575.32639.58.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> On Thu, 2008-10-09 at 15:50 -0700, Chris Snook wrote:
>> Alok Kataria wrote:
>>> On Thu, 2008-10-09 at 14:03 -0700, Chris Snook wrote:
>>>
>>> I agree that in general this should be no, but since this is a
>>> commandline variable it will be normally set for only those systems
>>> which have only TSC as a option or know that the TSC is reliable.
>>> wouldn't doing this be ok for such systems ?
>> Hardware doesn't deliberately do any TSC synchronization, though you might get
>> it by accident in some configurations.  A VMware guest gets it for free thanks
>> to the hypervisor doing it in software, but we need to run the check when we're
>> booting on bare metal. 
> 
> The TSC sync algorithm right now expects that TSC are perfectly in sync
> between cpus.
> But, the hardware doesn't deliberately do any synchronization, so we can
> have situations where TSC was (accidently ? )off by a marginal value
> during boot and as a result we mark TSC as unstable and don't use it as
> a clocksource at all. For systems like the ones Jeff is using wouldn't
> that be a problem. IOW, even though the TSC was *marginally* off during
> bootup it should still be used as a clocksource, since you have no other
> option, no ? 

You seem to be conflating position and rate.  When we mark TSC as stable, we're 
saying it will always advance at a known rate on all CPUs, but this says nothing 
about the relative positions on the different CPUs.  That skew can be huge on 
some hardware, not just marginal, so we still need to synchronize them at boot 
time, even though we don't need to (and can't, in this case) verify stability 
with another continuous clock source.

-- Chris
