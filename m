Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXC1ONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXC1ONs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXC1ONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:13:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbXC1ONr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:13:47 -0400
Message-ID: <460A77F0.7030901@redhat.com>
Date: Wed, 28 Mar 2007 10:13:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       John Hawkes <hawkes@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than
 touching it
References: <20070327214919.800272641@goop.org> <200703281550.04224.ak@suse.de> <460A74EF.6000700@redhat.com> <200703281609.04956.ak@suse.de>
In-Reply-To: <200703281609.04956.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> On Wednesday 28 March 2007 16:00, Prarit Bhargava wrote:
>   
>>>> touch_nmi_watchdog is attempting to tickle _all_ CPUs softlockup watchdogs.
>>>>     
>>>>         
>>> It is supposed to only touch the current CPU, just like it only touches
>>> the NMI watchdog on the current CPU.
>>>
>>>   
>>>       
>> Andi,
>>
>> (sorry for the cut-and-paste). 
>>
>> touch_nmi_watchdogs sets EACH CPUs alert_counter to 0.
>>     
>
> You're right. Sorry for the confusion.  
>
> But just touching the current CPU would make much more sense. After all
> the caller doesn't know anything about the state of other CPUs. Perhaps it would be best
> to just change that and keep the softlockup semantics.
>   
Yeah -- you're probably right, and besides that we're not seeing a crazy 
# of softlockup messages after touch_nmi_watchdogs calls.

My original comments regarding the code still stand though -- we 
shouldn't have multiple methods of playing with the softlockup watchdog.

P.

> -Andi
>   
