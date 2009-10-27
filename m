Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZJ0GcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZJ0GcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZJ0GcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:32:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57373 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZJ0GcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:32:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE693D9.3070100@jp.fujitsu.com>
Date: Tue, 27 Oct 2009 15:31:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012120620.GG9228@kernel.dk> <20091012145254.GA1517@kroah.com> <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk>
In-Reply-To: <20091026105419.GA10727@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Oct 20 2009, Alex Chiang wrote:
>> * Jens Axboe <jens.axboe@oracle.com>:
>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>> acpiphp: Slot [1] registered
>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>> acpiphp: Slot [2] registered
>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>> acpiphp: Slot [6] registered
>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>> acpiphp: Slot [7] registered
>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>> acpiphp_glue: Total 4 slots
>>>> You mentioned in another mail that you echoed 1 into the various
>>>> slots' power files.
>>>>
>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>
>>>> If so, there should be debug output when you try and turn them
>>>> on.
>>> It produces:
>>>
>>> acpiphp: enable_slot - physical_slot = 1
>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>> acpiphp: enable_slot - physical_slot = 2
>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>> acpiphp: enable_slot - physical_slot = 6
>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>> acpiphp: enable_slot - physical_slot = 7
>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>> Hm, so for some reason, firmware on your machine is telling us
>> that it doesn't think cards are present and/or enabled.
>>
>> Unfortunately, I don't know why your firmware would be saying
>> that. We could add some more debug printks to see what firmware
>> thinks about your system... Or we could just wait and see what
>> happens after you get your hardware replaced.
> 
> New board, the exact same thing happens.
> 
>>> I have a card in one of the slots only this time.
>>>
>>>> Also, quick dummy check, you are trying to power on populated
>>>> slots, right? :)
>>> Yes :-)
>>>
>>>> Can you send the output of lspci -vv? And I like the output of
>>>> lspci -vt as well... Both before and after loading acpiphp
>>>> please.
>>> Send privately.
>> No difference in before and after. Odd.
>>
>> If you want to poke us again after your hardware swap, please do
>> so. Sorry for being not so helpful. :-/
> 
> Poke :-)
> 
> One more thing I tried was pushing the power button on the slot
> manually. With acpiphp, I get the same messages as above. Using pciehp,
> I get the same power fault bit interrupt storm. So no difference from
> using the sysfs interface or doing it on the box side, doesn't work
> either way.
> 

I'd like to confirm power fault interrupt storm, just in case.
Could you get /proc/interrupts information after power fault
problem happens and send it to me?

Thanks,
Kenji Kaneshige



