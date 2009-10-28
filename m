Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZJ1GPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZJ1GPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZJ1GPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:15:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbZJ1GPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:15:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE7E164.80408@jp.fujitsu.com>
Date: Wed, 28 Oct 2009 15:15:00 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com> <20091027082720.GT10727@kernel.dk>
In-Reply-To: <20091027082720.GT10727@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------030504090803000402000700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030504090803000402000700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Tue, Oct 27 2009, Kenji Kaneshige wrote:
>> Jens Axboe wrote:
>>> On Tue, Oct 20 2009, Alex Chiang wrote:
>>>> * Jens Axboe <jens.axboe@oracle.com>:
>>>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>>>> acpiphp: Slot [1] registered
>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>>>> acpiphp: Slot [2] registered
>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>>>> acpiphp: Slot [6] registered
>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>>>> acpiphp: Slot [7] registered
>>>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>>>> acpiphp_glue: Total 4 slots
>>>>>> You mentioned in another mail that you echoed 1 into the various
>>>>>> slots' power files.
>>>>>>
>>>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>>>
>>>>>> If so, there should be debug output when you try and turn them
>>>>>> on.
>>>>> It produces:
>>>>>
>>>>> acpiphp: enable_slot - physical_slot = 1
>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>> acpiphp: enable_slot - physical_slot = 2
>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>> acpiphp: enable_slot - physical_slot = 6
>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>> acpiphp: enable_slot - physical_slot = 7
>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>> Hm, so for some reason, firmware on your machine is telling us
>>>> that it doesn't think cards are present and/or enabled.
>>>>
>>>> Unfortunately, I don't know why your firmware would be saying
>>>> that. We could add some more debug printks to see what firmware
>>>> thinks about your system... Or we could just wait and see what
>>>> happens after you get your hardware replaced.
>>> New board, the exact same thing happens.
>>>
>>>>> I have a card in one of the slots only this time.
>>>>>
>>>>>> Also, quick dummy check, you are trying to power on populated
>>>>>> slots, right? :)
>>>>> Yes :-)
>>>>>
>>>>>> Can you send the output of lspci -vv? And I like the output of
>>>>>> lspci -vt as well... Both before and after loading acpiphp
>>>>>> please.
>>>>> Send privately.
>>>> No difference in before and after. Odd.
>>>>
>>>> If you want to poke us again after your hardware swap, please do
>>>> so. Sorry for being not so helpful. :-/
>>> Poke :-)
>>>
>>> One more thing I tried was pushing the power button on the slot
>>> manually. With acpiphp, I get the same messages as above. Using pciehp,
>>> I get the same power fault bit interrupt storm. So no difference from
>>> using the sysfs interface or doing it on the box side, doesn't work
>>> either way.
>>>
>> I'd like to confirm power fault interrupt storm, just in case.
>> Could you get /proc/interrupts information after power fault
>> problem happens and send it to me?
> 
> The box pretty much hangs when I try to power on a slot with pciehp, so
> it's not easy to do... It doesn't hang with acpiphp, but doesn't work
> either (see previous reply to Alex).
> 

Could you try the attached debugging patch? With this patch, power
fault interrupt would be disabled after 100 power fault detected (
I hope so). You can get /proc/interrupts after that.

Thanks,
Kenji Kaneshige



--------------030504090803000402000700
Content-Type: text/plain;
 name="pciehp-power-fault-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pciehp-power-fault-debug.patch"

---
 drivers/pci/hotplug/pciehp_hpc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 20091026/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- 20091026.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ 20091026/drivers/pci/hotplug/pciehp_hpc.c
@@ -612,6 +612,7 @@ static irqreturn_t pcie_isr(int irq, voi
 	struct controller *ctrl = (struct controller *)dev_id;
 	struct slot *slot = ctrl->slot;
 	u16 detected, intr_loc;
+	static int nr_power_faults = 0;
 
 	/*
 	 * In order to guarantee that all interrupt events are
@@ -664,6 +665,13 @@ static irqreturn_t pcie_isr(int irq, voi
 	if (intr_loc & PCI_EXP_SLTSTA_PDC)
 		pciehp_handle_presence_change(slot);
 
+	if ((intr_loc & PCI_EXP_SLTSTA_PFD) && (++nr_power_faults > 100)) {
+		u16 reg16;
+		pciehp_readw(ctrl, PCI_EXP_SLTCTL, &reg16);
+		reg16 &= ~PCI_EXP_SLTCTL_PFDE;
+		pciehp_writew(ctrl, PCI_EXP_SLTCTL, reg16);
+	}
+
 	/* Check Power Fault Detected */
 	if ((intr_loc & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
 		ctrl->power_fault_detected = 1;

--------------030504090803000402000700--

