Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYBDTNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYBDTNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbYBDTN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:13:27 -0500
Received: from rtr.ca ([76.10.145.34]:4567 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYBDTN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:13:26 -0500
Message-ID: <47A763D4.5090606@rtr.ca>
Date: Mon, 04 Feb 2008 14:13:24 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Chris Rankin <rankincj@yahoo.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
References: <745427.71265.qm@web52907.mail.re2.yahoo.com> <200802030011.34086.gene.heskett@gmail.com> <20080203055807.GA25545@elte.hu> <200802030125.24663.gene.heskett@gmail.com>
In-Reply-To: <200802030125.24663.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Sunday 03 February 2008, Ingo Molnar wrote:
>> * Gene Heskett <gene.heskett@gmail.com> wrote:
>>> I believe its the same, but lemme paste it for sure, yes:
>>> [   26.339926] ENABLING IO-APIC IRQs
>>> [   26.340119] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
>>> [   26.350129] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>> [   26.350182] ...trying to set up timer (IRQ0) through the 8259A ... 
>>> failed. [   26.350185] ...trying to set up timer as Virtual Wire IRQ...
>>> failed. [   26.360186] ...trying to set up timer as ExtINT IRQ... works.
>>>
>>> The third line is the only line that makes it to the screen during the
>>> boot trace.
>>>
>>> Now, what does this tell us?
>> the question would be:
>>
>> - if you remove the acpi_use_timer_override boot flag
>> - and if you boot a kernel with this hack applied
>>
>> => do those weird PATA failures come back?
>>
>> If the failues do _not_ come back then the problem is somehow
>> affected/worked-around by the IO-APIC code that generates the above 4
>> lines. If the failures are still the same then the above 4 lines are
>> really just an uninteresting side-effect of the acpi_use_timer_override
>> flag - and the real side-effects (that fixes PATA on your box) are to be
>> found elsewhere.
>>
>> Sadly, the latter variant is the expected answer.
>>
>> 	Ingo
> 
> And at this point, I can't tell.  This reboot was from a cold start, without 
> the argument, and cold by long enough to make the rounds about the house and 
> pick up a beer, but not take my evening pillbox.  A minute cold, maybe 2 max.  
> The log is clean since except for a kudzu nag of some sort:
..

Just to muddy your observations:  it is quite possible that a cold (power-off)
reboot may be required to properly observe what happens here.

Cheers
