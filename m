Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYHNFNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYHNFNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 01:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYHNFNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 01:13:01 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22887 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbYHNFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 01:13:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=h7Z3OgdkVA4XoB_V72AA:9 a=2ei8HwA_1jBDnKlyOj4A:7 a=mTTYVa-XT1Y1nwPnsVg5r0LTHosA:4 a=MSl-tDqOz04A:10 a=E5wGEk8WwowA:10 a=WmXjW0szwuoA:10
Message-ID: <48A3BED6.3070207@shaw.ca>
Date: Wed, 13 Aug 2008 23:12:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Milan Plzik <milan.plzik@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: Timer unstability on when using C2 and deeper sleep states (Dell
 Latitude XT)
References: <fa.BPxGhvxOK2Rcn4TTNlAMe2XzVYk@ifi.uio.no> <fa.s5pgfnYl3W8cOu+PDLbvAcv4X9c@ifi.uio.no> <fa.2qnH5HZa4bnjN4HRRidEAUj5jxk@ifi.uio.no> <fa.b1y/njcuV4QYZ2xTsVkHQ55Ni7Y@ifi.uio.no>
In-Reply-To: <fa.b1y/njcuV4QYZ2xTsVkHQ55Ni7Y@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Plzik wrote:
> On St, 2008-08-13 at 22:17 +0200, Andi Kleen wrote:
>> Milan Plzik <milan.plzik@gmail.com> writes:
>>
>>>   I apologize for replying on my own mail (and also for top-posting, but
>>> this information is global update, not exactly fitting any of topics
>>> mentioned below).
>>>
>>>   After playing for a longer while I found out that the system ends
>>> sometimes in state where, in order to do anything useful, I need to
>>> press keys on keyboard. 
>> This usually means it is using the wrong timer in a deeper idle state.
>> Some idle states cannot be woken up by e.g. the APIC timer and then
>> you get that effect: you only make progress when you wake up the 
>> CPU in some other way like pressing a key. Then on wake up the
>> timers get processed.
>>
>> This is usually a bug in the kernel timer selection. It should be chosing
>> a timer that always wakes up from the deepest idle state used.
> 
>   Last days I also considered this option; I tried all possible timers (hpet, tsc, acpi_pm), but their behavior is the same. 'jiffies' timer works correctly, but that one doesn't seem to put CPU to deeper sleeps, so we can't deduce any information from that. 
> 
>   I've seen some workaround in drivers/acpi/processor_idle.c, which seems to check the ARCH_APICTIMER_STOPS_ON_C3 macro, but it's enabled at compilation time, so the code is used by kernel... .

That changes the clock interpolation source, but it doesn't change the 
timer interrupt source though, which is quite possibly what you're 
losing. Have you tried nolapictimer kernel option (or nolapic, which is 
the bigger hammer)?
