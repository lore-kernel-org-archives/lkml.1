Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYJIVF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYJIVF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYJIVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:05:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYJIVFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:05:10 -0400
Message-ID: <48EE71A9.2010907@redhat.com>
Date: Thu, 09 Oct 2008 17:03:37 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alok kataria <alokkataria1@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jeff Hansen <x@jeffhansen.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akataria@vmware.com
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
References: <Pine.LNX.4.64.0810071640110.25661@ren>	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>	 <alpine.LFD.2.00.0810090910510.3237@apollo>	 <48EE4FC4.7070902@redhat.com>	 <alpine.LFD.2.00.0810092118100.3271@apollo>	 <Pine.LNX.4.64.0810091344250.24851@ren>	 <alpine.LFD.2.00.0810092152410.3271@apollo> <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
In-Reply-To: <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok kataria wrote:
> On Thu, Oct 9, 2008 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Thu, 9 Oct 2008, Jeff Hansen wrote:
>>
>>> OK, so are we all agreed that something like clocksource_trust=tsc would be
>>> the best?
>> No, it's per affected device: tsc=trust or tsc=stable or whatever
>> unintuitive name we want to come up. And it is a modification to TSC
>> not to the clocksource layer.
> 
> Yep, this is cool. I too have a patch in my local tree which does a
> similar thing i have a tsc_reliable flag which is set right now only
> when we are running under a VMware hypervisor.
> Along with marking the no_verify flag for TSC, this patch of mine also
> skips the TSC synchornization checks.
> 
>         The TSC synchronization loop which is run whenever a new cpu is
> brought up is not actually needed on systems which are known to have a
> reliable TSC. TSC between 2 cpus can be off by a marginal value on such
> systems and thats okay for timekeeping, since we do check for tsc going
> back in read_tsc.
> 
> Can this reasoning be included and synchronization skipped for all
> these systems with reliable aka trustworthy TSC's  ?

In general, no.  Not all hardware/hypervisors behave this way, even when the TSC 
is otherwise stable once synchronized.

-- Chris
