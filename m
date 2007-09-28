Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXI1Nql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXI1Nql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXI1Nqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:46:34 -0400
Received: from rtr.ca ([76.10.145.34]:2055 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXI1Nqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:46:34 -0400
Message-ID: <46FD05B8.2040302@rtr.ca>
Date: Fri, 28 Sep 2007 09:46:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
Subject: Re: Problems with SMP & ACPI powering off
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl> <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl>
In-Reply-To: <200709281544.30497.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 28 September 2007 15:22, Mark Lord wrote:
>> Rafael J. Wysocki wrote:
>>> On Friday, 28 September 2007 06:57, Len Brown wrote:
>>>> On Thursday 27 September 2007 18:00, Rafael J. Wysocki wrote:
>>>>> On Thursday, 27 September 2007 23:29, Mark Lord wrote:
>>>>>> Question:  do we disable all CPUs except 0 when doing ACPI power off?
>>>>> No, but we should.
>>>> We used to.
>>>> It is absolutely mandatory -- else it confuses the BIOS on some boards
>>>> b/c it isn't expecting SMM to get entered from other than cpu0.
>>> Can we use the CPU hotplug for that, like in the suspend/hibernation case?
>> Well, so far it's working:  about ten poweroffs since I patched it,
>> and no issues with any of them.  Prior to that, it seemed like about
>> one in five poweroffs wouldn't (power off).
>>
>> It'll take a lot more testing to confirm, though.
>>
>> What can I call to determine if more than one CPU is enabled, anyway?
>>
>> Here's the hack I'm using here, very situation (2 cores) specific,
>> and it still has some printk's leftover with a sleep so I have time
>> to read them before the lights go out.  :)
> 
> Well, we have disable_nonboot_cpus() that we use for suspend and that is
> supposed to be general.
> 
> The question is when to call it.

How about from the obvious candidate: kernel/sys.c::kernel_power_off() ?

I'll rework my hack into a proper patch there,
repost it here, and test with it for another day or two.

-ml
