Return-Path: <linux-kernel-owner+w=401wt.eu-S1030796AbXCHWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796AbXCHWRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030799AbXCHWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:17:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51518 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030796AbXCHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:17:22 -0500
Message-ID: <45F08B71.50606@vmware.com>
Date: Thu, 08 Mar 2007 14:17:21 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <20070308211306.GA20934@elte.hu>
In-Reply-To: <20070308211306.GA20934@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> When we're about two weeks away from a product release and you are 
>> threatening to unmerge or block our code because we didn't create an 
>> abstract interrupt controller, we re-used the APIC and IO-APIC, this 
>> is uber rocket science. [...]
>>     
>
> see my mail to you below: you've been told about the clockevents problem 
> months ago, that you shouldnt hardwire PIT details and that you should 
> be registering a clockevents device. You cannot credibly claim that you 
> didnt know about this.
>   

I am claiming no such thing.  My claim is that nobody ever said, well 
unless you you clockevents, we're going to break your code, then nack 
any possible way to fix it, and now for spite, since you are in the 
kernel tree, we're going to nack any attempt to use clockevents.

It was our plan to convert to using clockevents all along.  It was never 
said that this was such a huge, showstopping issue, and so we didn't see 
any reason to change the timer code any further for 2.6.21, specifically 
because the integration with hrtimers caused so much pain and debugging 
for us.  Our code was working fine, then clocksources came along, and we 
had to change.  Then clockevents came along, had bugs of its own to work 
out, and caused a huge amount of grief and debugging for us.  So when we 
had something working, we drew the line and figured we could make the 
leap to CE in the next kernel.

>> We've been doing things this way, with public patches for over a year, 
>> and you've even been CC'd on some of the discussions. [...]
>>     
>
> i've specifically objected, numerous times - the result of which was 
> that when you submitted it to lkml you didnt Cc: me ;) The VMI crap went 
> in 'under the radar' via the x86_64 tree.
>
>   
>> [...]  So it is a little late to tell us - "redesign your hypervisor, 
>> or else.."
>>     
>
> Also, it was /you/ who claimed that paravirt_ops can take care of 
> whatever design change on the Linux side - that claim is apparently 
> history now and you are now claiming "there's a product on the road, we 
> cannot change the hypervisor ABI"? Should i cite that email of yours 
> too?
>   

Ingo, either you or Thomas have vetoed every attempt we have made to 
make our code operate with clockevents.  There are serious platform 
issues here that make this difficult, no matter how many nice, well 
designed, abstract, higher-level kernel interfaces we have to work with, 
we have to work around platform code which makes the wrong assumptions.

Citing already established facts doesn't do anything productive.  Can I 
please get some feedback on the design choices I have proposed for how 
to integrate VMI timer?

Thanks,

Zach
