Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXC1OwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXC1OwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXC1OwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:52:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXC1OwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:52:13 -0400
Message-ID: <460A80E6.9040003@redhat.com>
Date: Wed, 28 Mar 2007 10:51:18 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Lalancette <clalance@redhat.com>, John Hawkes <hawkes@sgi.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than
 touching it
References: <20070327214919.800272641@goop.org> <20070327215828.085422178@goop.org> <460A6EC0.4020701@redhat.com> <460A7F57.9020006@goop.org>
In-Reply-To: <460A7F57.9020006@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> Prarit Bhargava wrote:
>   
>> I don't like the idea of having touch_softlockup_watchdog exported
>> with your new code -- we still have two methods of effecting the
>> softlockup watchdog and that's confusing and its going to cause
>> serious problems down the road.
>>     
>
> It's legacy.  There are a few places where it wasn't obvious to me how
> to replace the touch_softlockup_watchdog, so I left them for now.  But
> ideally I think they should all go away.
>
>   
>> Is there a reason that you're pushing the enable/disable?  All the
>> cases called out seem to be just fine with calls to either effect that
>> CPU's softlockup watchdog or doing all CPU's softlockup watchdogs.
>>     
>
> Doing all CPUs is meaningless to me.  How does that make sense?  It
>   

You don't have to do them all -- you could do one with (as in my 
previous patch -- which I'm not married to BTW ;) )

touch_cpu_softlockup_watchdog()

and all with

touch_softlockup_watchdog()

> Zach has reported seeing spurious softlockup messages on idle machines
> running under a hypervisor.  And there was also the discussion about how
> to deal with a flash update system in which all CPUs are taken over by
> the bios for a long period of time, which was causing softlockup to
> trigger.  It seemed to me that these could all be dealt with in much the
> same way, and that disable/enable semantics for dealing with
> long-running timer holdoffs is more natural than trying to work out how
> to periodically touch the watchdog timer.
>
>   
But wouldn't a call to touch_[cpu_]softlockup_watchdog at the end of the 
flash update fix the problem?  And ditto for all other areas of the 
kernel where we know we're holding off scheduling?

P.


>     J
>   
