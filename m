Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZJ0I1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZJ0I1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbZJ0I1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:27:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37039 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbZJ0I1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:27:16 -0400
Date: Tue, 27 Oct 2009 09:27:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027082720.GT10727@kernel.dk>
References: <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE693D9.3070100@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Kenji Kaneshige wrote:
> Jens Axboe wrote:
>> On Tue, Oct 20 2009, Alex Chiang wrote:
>>> * Jens Axboe <jens.axboe@oracle.com>:
>>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>>> acpiphp: Slot [1] registered
>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>>> acpiphp: Slot [2] registered
>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>>> acpiphp: Slot [6] registered
>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>>> acpiphp: Slot [7] registered
>>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>>> acpiphp_glue: Total 4 slots
>>>>> You mentioned in another mail that you echoed 1 into the various
>>>>> slots' power files.
>>>>>
>>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>>
>>>>> If so, there should be debug output when you try and turn them
>>>>> on.
>>>> It produces:
>>>>
>>>> acpiphp: enable_slot - physical_slot = 1
>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>> acpiphp: enable_slot - physical_slot = 2
>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>> acpiphp: enable_slot - physical_slot = 6
>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>> acpiphp: enable_slot - physical_slot = 7
>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>> Hm, so for some reason, firmware on your machine is telling us
>>> that it doesn't think cards are present and/or enabled.
>>>
>>> Unfortunately, I don't know why your firmware would be saying
>>> that. We could add some more debug printks to see what firmware
>>> thinks about your system... Or we could just wait and see what
>>> happens after you get your hardware replaced.
>>
>> New board, the exact same thing happens.
>>
>>>> I have a card in one of the slots only this time.
>>>>
>>>>> Also, quick dummy check, you are trying to power on populated
>>>>> slots, right? :)
>>>> Yes :-)
>>>>
>>>>> Can you send the output of lspci -vv? And I like the output of
>>>>> lspci -vt as well... Both before and after loading acpiphp
>>>>> please.
>>>> Send privately.
>>> No difference in before and after. Odd.
>>>
>>> If you want to poke us again after your hardware swap, please do
>>> so. Sorry for being not so helpful. :-/
>>
>> Poke :-)
>>
>> One more thing I tried was pushing the power button on the slot
>> manually. With acpiphp, I get the same messages as above. Using pciehp,
>> I get the same power fault bit interrupt storm. So no difference from
>> using the sysfs interface or doing it on the box side, doesn't work
>> either way.
>>
>
> I'd like to confirm power fault interrupt storm, just in case.
> Could you get /proc/interrupts information after power fault
> problem happens and send it to me?

The box pretty much hangs when I try to power on a slot with pciehp, so
it's not easy to do... It doesn't hang with acpiphp, but doesn't work
either (see previous reply to Alex).

-- 
Jens Axboe

