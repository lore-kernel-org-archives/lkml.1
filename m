Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZJ1JXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZJ1JXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZJ1JXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:23:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44780 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbZJ1JXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:23:21 -0400
Date: Wed, 28 Oct 2009 10:23:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091028092324.GB10727@kernel.dk>
References: <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com> <20091027082720.GT10727@kernel.dk> <4AE7E164.80408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <4AE7E164.80408@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 28 2009, Kenji Kaneshige wrote:
> Jens Axboe wrote:
>> On Tue, Oct 27 2009, Kenji Kaneshige wrote:
>>> Jens Axboe wrote:
>>>> On Tue, Oct 20 2009, Alex Chiang wrote:
>>>>> * Jens Axboe <jens.axboe@oracle.com>:
>>>>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>>>>> acpiphp: Slot [1] registered
>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>>>>> acpiphp: Slot [2] registered
>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>>>>> acpiphp: Slot [6] registered
>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>>>>> acpiphp: Slot [7] registered
>>>>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>>>>> acpiphp_glue: Total 4 slots
>>>>>>> You mentioned in another mail that you echoed 1 into the various
>>>>>>> slots' power files.
>>>>>>>
>>>>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>>>>
>>>>>>> If so, there should be debug output when you try and turn them
>>>>>>> on.
>>>>>> It produces:
>>>>>>
>>>>>> acpiphp: enable_slot - physical_slot = 1
>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>> acpiphp: enable_slot - physical_slot = 2
>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>> acpiphp: enable_slot - physical_slot = 6
>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>> acpiphp: enable_slot - physical_slot = 7
>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>> Hm, so for some reason, firmware on your machine is telling us
>>>>> that it doesn't think cards are present and/or enabled.
>>>>>
>>>>> Unfortunately, I don't know why your firmware would be saying
>>>>> that. We could add some more debug printks to see what firmware
>>>>> thinks about your system... Or we could just wait and see what
>>>>> happens after you get your hardware replaced.
>>>> New board, the exact same thing happens.
>>>>
>>>>>> I have a card in one of the slots only this time.
>>>>>>
>>>>>>> Also, quick dummy check, you are trying to power on populated
>>>>>>> slots, right? :)
>>>>>> Yes :-)
>>>>>>
>>>>>>> Can you send the output of lspci -vv? And I like the output of
>>>>>>> lspci -vt as well... Both before and after loading acpiphp
>>>>>>> please.
>>>>>> Send privately.
>>>>> No difference in before and after. Odd.
>>>>>
>>>>> If you want to poke us again after your hardware swap, please do
>>>>> so. Sorry for being not so helpful. :-/
>>>> Poke :-)
>>>>
>>>> One more thing I tried was pushing the power button on the slot
>>>> manually. With acpiphp, I get the same messages as above. Using pciehp,
>>>> I get the same power fault bit interrupt storm. So no difference from
>>>> using the sysfs interface or doing it on the box side, doesn't work
>>>> either way.
>>>>
>>> I'd like to confirm power fault interrupt storm, just in case.
>>> Could you get /proc/interrupts information after power fault
>>> problem happens and send it to me?
>>
>> The box pretty much hangs when I try to power on a slot with pciehp, so
>> it's not easy to do... It doesn't hang with acpiphp, but doesn't work
>> either (see previous reply to Alex).
>>
>
> Could you try the attached debugging patch? With this patch, power
> fault interrupt would be disabled after 100 power fault detected (
> I hope so). You can get /proc/interrupts after that.

Here is the output of doing the power on with that patch applied.

pciehp 0000:00:05.0:pcie04: enable_slot: physical_slot = 1
pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 77b
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
pciehp 0000:00:05.0:pcie04: pciehp_power_on_slot: SLOTCTRL a8 write cmd 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
pciehp 0000:00:05.0:pcie04: pciehp_green_led_blink: SLOTCTRL a8 write cmd 200
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: Power fault interrupt received
pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
pciehp 0000:00:05.0:pcie04: Power fault bit 0 set
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
pciehp 0000:00:05.0:pcie04: Data Link Layer Link Active not set in 1000 msec
pciehp 0000:00:05.0:pcie04: pciehp_check_link_status: lnk_status = 1001
pciehp 0000:00:05.0:pcie04: Link Training Error occurs 
pciehp 0000:00:05.0:pcie04: Failed to check link status
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
pciehp 0000:00:05.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 779
pciehp 0000:00:05.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 779

-- 
Jens Axboe


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=interrupts

            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11      CPU12      CPU13      CPU14      CPU15      CPU16      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23      CPU24      CPU25      CPU26      CPU27      CPU28      CPU29      CPU30      CPU31      CPU32      CPU33      CPU34      CPU35      CPU36      CPU37      CPU38      CPU39      CPU40      CPU41      CPU42      CPU43      CPU44      CPU45      CPU46      CPU47      CPU48      CPU49      CPU50      CPU51      CPU52      CPU53      CPU54      CPU55      CPU56      CPU57      CPU58      CPU59      CPU60      CPU61      CPU62      CPU63      
   0:        398          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      timer
   9:          2          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
  16:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb1
  18:        294          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb4, uhci_hcd:usb8
  19:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb7
  21:         48          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
  23:          2          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb5, ehci_hcd:usb6
  24:       2678      12250          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   megasas
  75:          5          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      pciehp
  76:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      pciehp
  84:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      pciehp
  85:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      pciehp
  86:         60          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      ahci
  87:         32          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-tx-0
  88:         29          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0        531          0       1348          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-tx-1
  89:         29          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-tx-2
  90:         67          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          2          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-tx-3
  91:        181          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          5         33          0          0         27          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-rx-0
  92:       1038          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0        799          0       1552          0        148          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-rx-1
  93:        169          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0        148          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-rx-2
  94:         25          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0         62          0          0          0        110          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-rx-3
  95:          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0
 NMI:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Non-maskable interrupts
 LOC:      41427      31601      18530      20254      13942      14884       9672       9172      12495       9142       8580       8844      11468       8168       8284       7810      10967       7621       7423       7300       9554       7097       6929       6997       8874       6663       6457       6487       9016       6396       6155       6532      18224       8574       7290      10847       6309       5434       5204       4898       6007       4701       4340       4204       4739       4241       3805       3698       3929       3496       3261       3078       3194       2847       2747       3162       3692       2296       2189       2317       4592       2367       1740       3375   Local timer interrupts
 SPU:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Spurious interrupts
 PMI:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Performance monitoring interrupts
 PND:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Performance pending work
 RES:        471         43         94         67         40          4          3          2         40          3          1          5          9          2          1          4          1          1          0          1          2          0          5          5          2          0          1          0          1          5          0         23       2489         16          9         60         29          1          5         23          9          5          1          1          4          1          2          1         12          4          8          2          1          1          2          4        118          1          1          1         64         32          0        187   Rescheduling interrupts
 CAL:       5162        434       1897       3862        133        133        133        133        132        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        131        133        133        133        133        133        133         93        102        133        133        133        132        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        133        132        133        133        133        132        133        133        111   Function call interrupts
 TLB:        218         79         78        135         56         29         19         17         40         32         10          6         11         10          6          4         11         15          5          5          9          5          7          6         12          2          6          4         12         14          2         49        789         98         48        152         49         20         18         24         40         32          5          7         48          8          4          1         34         10          3          1         31          8          1          9         19          3          6          9         28          6          4         14   TLB shootdowns
 TRM:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Machine check exceptions
 MCP:          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3          3   Machine check polls
 ERR:          0
 MIS:          0

--ghzN8eJ9Qlbqn3iT--
