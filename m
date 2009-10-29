Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZJ2Hok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZJ2Hok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZJ2Hoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:44:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57861 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZJ2Hoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:44:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE947D3.5070500@jp.fujitsu.com>
Date: Thu, 29 Oct 2009 16:44:19 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com> <20091027082720.GT10727@kernel.dk> <4AE7E164.80408@jp.fujitsu.com> <20091028092324.GB10727@kernel.dk>
In-Reply-To: <20091028092324.GB10727@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Oct 28 2009, Kenji Kaneshige wrote:
>> Jens Axboe wrote:
>>> On Tue, Oct 27 2009, Kenji Kaneshige wrote:
>>>> Jens Axboe wrote:
>>>>> On Tue, Oct 20 2009, Alex Chiang wrote:
>>>>>> * Jens Axboe <jens.axboe@oracle.com>:
>>>>>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>>>>>> acpiphp: Slot [1] registered
>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>>>>>> acpiphp: Slot [2] registered
>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>>>>>> acpiphp: Slot [6] registered
>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>>>>>> acpiphp: Slot [7] registered
>>>>>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>>>>>> acpiphp_glue: Total 4 slots
>>>>>>>> You mentioned in another mail that you echoed 1 into the various
>>>>>>>> slots' power files.
>>>>>>>>
>>>>>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>>>>>
>>>>>>>> If so, there should be debug output when you try and turn them
>>>>>>>> on.
>>>>>>> It produces:
>>>>>>>
>>>>>>> acpiphp: enable_slot - physical_slot = 1
>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>> acpiphp: enable_slot - physical_slot = 2
>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>> acpiphp: enable_slot - physical_slot = 6
>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>> acpiphp: enable_slot - physical_slot = 7
>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>> Hm, so for some reason, firmware on your machine is telling us
>>>>>> that it doesn't think cards are present and/or enabled.
>>>>>>
>>>>>> Unfortunately, I don't know why your firmware would be saying
>>>>>> that. We could add some more debug printks to see what firmware
>>>>>> thinks about your system... Or we could just wait and see what
>>>>>> happens after you get your hardware replaced.
>>>>> New board, the exact same thing happens.
>>>>>
>>>>>>> I have a card in one of the slots only this time.
>>>>>>>
>>>>>>>> Also, quick dummy check, you are trying to power on populated
>>>>>>>> slots, right? :)
>>>>>>> Yes :-)
>>>>>>>
>>>>>>>> Can you send the output of lspci -vv? And I like the output of
>>>>>>>> lspci -vt as well... Both before and after loading acpiphp
>>>>>>>> please.
>>>>>>> Send privately.
>>>>>> No difference in before and after. Odd.
>>>>>>
>>>>>> If you want to poke us again after your hardware swap, please do
>>>>>> so. Sorry for being not so helpful. :-/
>>>>> Poke :-)
>>>>>
>>>>> One more thing I tried was pushing the power button on the slot
>>>>> manually. With acpiphp, I get the same messages as above. Using pciehp,
>>>>> I get the same power fault bit interrupt storm. So no difference from
>>>>> using the sysfs interface or doing it on the box side, doesn't work
>>>>> either way.
>>>>>
>>>> I'd like to confirm power fault interrupt storm, just in case.
>>>> Could you get /proc/interrupts information after power fault
>>>> problem happens and send it to me?
>>> The box pretty much hangs when I try to power on a slot with pciehp, so
>>> it's not easy to do... It doesn't hang with acpiphp, but doesn't work
>>> either (see previous reply to Alex).
>>>
>> Could you try the attached debugging patch? With this patch, power
>> fault interrupt would be disabled after 100 power fault detected (
>> I hope so). You can get /proc/interrupts after that.
> 
> Here is the output of doing the power on with that patch applied.
> 
> pciehp 0000:00:05.0:pcie04: enable_slot: physical_slot = 1
> pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 77b
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
> pciehp 0000:00:05.0:pcie04: pciehp_power_on_slot: SLOTCTRL a8 write cmd 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
> pciehp 0000:00:05.0:pcie04: pciehp_green_led_blink: SLOTCTRL a8 write cmd 200
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: Power fault interrupt received
> pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
> pciehp 0000:00:05.0:pcie04: Power fault bit 0 set
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
> pciehp 0000:00:05.0:pcie04: Data Link Layer Link Active not set in 1000 msec
> pciehp 0000:00:05.0:pcie04: pciehp_check_link_status: lnk_status = 1001
> pciehp 0000:00:05.0:pcie04: Link Training Error occurs 
> pciehp 0000:00:05.0:pcie04: Failed to check link status
> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
> pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
> pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
> pciehp 0000:00:05.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
> pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
> pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
> pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 779
> pciehp 0000:00:05.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 779
> 

>From the console log, it seems that my debug patch worked as I expected
(power fault event interrupts ware disabled after 100 power fault event).
But for some reasons, /proc/interrupts indicates only 5 interrupts of
pciehp. Just in case, did you get /proc/interrupts after doing power on?

Thanks,
Kenji Kaneshige



