Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZKBF2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZKBF2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 00:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZKBF2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 00:28:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZKBF23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 00:28:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AEE6DDE.3080106@jp.fujitsu.com>
Date: Mon, 02 Nov 2009 14:27:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com> <20091027082720.GT10727@kernel.dk> <4AE7E164.80408@jp.fujitsu.com> <20091028092324.GB10727@kernel.dk> <4AE947D3.5070500@jp.fujitsu.com> <20091029085824.GC10727@kernel.dk> <4AE95EFA.7000009@jp.fujitsu.com> <20091029092453.GD10727@kernel.dk>
In-Reply-To: <20091029092453.GD10727@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000209010401060901040208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000209010401060901040208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Thu, Oct 29 2009, Kenji Kaneshige wrote:
>> Jens Axboe wrote:
>>> On Thu, Oct 29 2009, Kenji Kaneshige wrote:
>>>> Jens Axboe wrote:
>>>>> On Wed, Oct 28 2009, Kenji Kaneshige wrote:
>>>>>> Jens Axboe wrote:
>>>>>>> On Tue, Oct 27 2009, Kenji Kaneshige wrote:
>>>>>>>> Jens Axboe wrote:
>>>>>>>>> On Tue, Oct 20 2009, Alex Chiang wrote:
>>>>>>>>>> * Jens Axboe <jens.axboe@oracle.com>:
>>>>>>>>>>> On Tue, Oct 13 2009, Alex Chiang wrote:
>>>>>>>>>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
>>>>>>>>>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
>>>>>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
>>>>>>>>>>>>> acpiphp: Slot [1] registered
>>>>>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
>>>>>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
>>>>>>>>>>>>> acpiphp: Slot [2] registered
>>>>>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
>>>>>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
>>>>>>>>>>>>> acpiphp: Slot [6] registered
>>>>>>>>>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
>>>>>>>>>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
>>>>>>>>>>>>> acpiphp: Slot [7] registered
>>>>>>>>>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
>>>>>>>>>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
>>>>>>>>>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
>>>>>>>>>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
>>>>>>>>>>>>> acpiphp_glue: Total 4 slots
>>>>>>>>>>>> You mentioned in another mail that you echoed 1 into the various
>>>>>>>>>>>> slots' power files.
>>>>>>>>>>>>
>>>>>>>>>>>> Did you do that after modprobing acpiphp with debug=1?
>>>>>>>>>>>>
>>>>>>>>>>>> If so, there should be debug output when you try and turn them
>>>>>>>>>>>> on.
>>>>>>>>>>> It produces:
>>>>>>>>>>>
>>>>>>>>>>> acpiphp: enable_slot - physical_slot = 1
>>>>>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>>>>>> acpiphp: enable_slot - physical_slot = 2
>>>>>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>>>>>> acpiphp: enable_slot - physical_slot = 6
>>>>>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>>>>>> acpiphp: enable_slot - physical_slot = 7
>>>>>>>>>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
>>>>>>>>>> Hm, so for some reason, firmware on your machine is telling us
>>>>>>>>>> that it doesn't think cards are present and/or enabled.
>>>>>>>>>>
>>>>>>>>>> Unfortunately, I don't know why your firmware would be saying
>>>>>>>>>> that. We could add some more debug printks to see what firmware
>>>>>>>>>> thinks about your system... Or we could just wait and see what
>>>>>>>>>> happens after you get your hardware replaced.
>>>>>>>>> New board, the exact same thing happens.
>>>>>>>>>
>>>>>>>>>>> I have a card in one of the slots only this time.
>>>>>>>>>>>
>>>>>>>>>>>> Also, quick dummy check, you are trying to power on populated
>>>>>>>>>>>> slots, right? :)
>>>>>>>>>>> Yes :-)
>>>>>>>>>>>
>>>>>>>>>>>> Can you send the output of lspci -vv? And I like the output of
>>>>>>>>>>>> lspci -vt as well... Both before and after loading acpiphp
>>>>>>>>>>>> please.
>>>>>>>>>>> Send privately.
>>>>>>>>>> No difference in before and after. Odd.
>>>>>>>>>>
>>>>>>>>>> If you want to poke us again after your hardware swap, please do
>>>>>>>>>> so. Sorry for being not so helpful. :-/
>>>>>>>>> Poke :-)
>>>>>>>>>
>>>>>>>>> One more thing I tried was pushing the power button on the slot
>>>>>>>>> manually. With acpiphp, I get the same messages as above. Using pciehp,
>>>>>>>>> I get the same power fault bit interrupt storm. So no difference from
>>>>>>>>> using the sysfs interface or doing it on the box side, doesn't work
>>>>>>>>> either way.
>>>>>>>>>
>>>>>>>> I'd like to confirm power fault interrupt storm, just in case.
>>>>>>>> Could you get /proc/interrupts information after power fault
>>>>>>>> problem happens and send it to me?
>>>>>>> The box pretty much hangs when I try to power on a slot with pciehp, so
>>>>>>> it's not easy to do... It doesn't hang with acpiphp, but doesn't work
>>>>>>> either (see previous reply to Alex).
>>>>>>>
>>>>>> Could you try the attached debugging patch? With this patch, power
>>>>>> fault interrupt would be disabled after 100 power fault detected (
>>>>>> I hope so). You can get /proc/interrupts after that.
>>>>> Here is the output of doing the power on with that patch applied.
>>>>>
>>>>> pciehp 0000:00:05.0:pcie04: enable_slot: physical_slot = 1
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 77b
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_power_on_slot: SLOTCTRL a8 write cmd 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 10
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_green_led_blink: SLOTCTRL a8 write cmd 200
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: Power fault interrupt received
>>>>> pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
>>>>> pciehp 0000:00:05.0:pcie04: Power fault bit 0 set
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>>>>> pciehp 0000:00:05.0:pcie04: Data Link Layer Link Active not set in 1000 msec
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_check_link_status: lnk_status = 1001
>>>>> pciehp 0000:00:05.0:pcie04: Link Training Error occurs pciehp  
>>>>> 0000:00:05.0:pcie04: Failed to check link status
>>>>> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
>>>>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 12
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
>>>>> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_green_led_off: SLOTCTRL a8 write cmd 300
>>>>> pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd 40
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 779
>>>>> pciehp 0000:00:05.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 779
>>>>>
>>>> From the console log, it seems that my debug patch worked as I expected
>>>> (power fault event interrupts ware disabled after 100 power fault event).
>>>> But for some reasons, /proc/interrupts indicates only 5 interrupts of
>>>> pciehp. Just in case, did you get /proc/interrupts after doing power on?
>>> Nope, it was captured post the power on attempt and the above log dump.
>>>
>> Can I confirm that? (sorry for my poor English skill)
>>
>> The /proc/interrupt was captured *before* the power on attempt and the log.
>> Correct?
> 
> No, the /proc/interrupt output was captured AFTER the power on attempt
> and the log capture shown above.
> 

Thank you very much for confirmation.

The pciehp driver has a code that calls interrupt service routine
internally. So I would like to confirm if "pcie_isr: intr_loc 2"
message storm is caused by interrupts, not by internal loop.
Unfortunately, I could not confirm it from /proc/interrupts.

According the current handle_edge_irq() implementation, there seems
some cases interrupts are not counted up in /proc/interrups (I think
it could happen when next interrupts comes while first interrupt is
being handled). In addition, what I did in the debug patch was just
disabling power fault interrupts by touching hardware register, and
it actually worked just fine. So "pcie_isr: intr_loc 2" storm should
be caused by power fault interrupt storm.

I made a two patches to prevent pciehp problems happining on your
machine. Could you try those patches one by one? 

- pciehp-fix-power-fault-interrupt-storm-problem.patch
  This patch is against 2.6.32-rc5. This is for fixing the power
  fault interrupt storm problem. Could you check if interrupt
  storm doesn't happen with this patch?

- pci-hotplug-fix-oshp-evaluation.patch
  This patch is against 2.6.32-rc5. This is for fixing the slot
  mis-detection problem. According to the debug information you
  sent me before, your system seems to expect that at least slot
  1 and slot 2 are NOT handled by pciehp. With this patch, those
  slot will not be detected by pciehp.

In both testing, could you use pciehp_debug option, and send me
the console log?

Thanks,
Kenji Kaneshige


--------------000209010401060901040208
Content-Type: text/plain;
 name="pciehp-fix-power-fault-interrupt-storm-problem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="pciehp-fix-power-fault-interrupt-storm-problem.patch"

Enabling power fault detected event notification in current pciehp
might cause power fault interrupt storm on some machines. On those
machines. On those machines, power fault detected bit in the slot
status register was set again immediately when it is cleared in the
interrupt service routine, and next power fault detected interrupt was
notified again. Therefore, disable power fault detected event
notification for now.

This patch also removes unnecessary handling for power fault cleared
event because this event is not supported by PCIe spec.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/pciehp_ctrl.c |   35 ++++++++++-------------------------
 drivers/pci/hotplug/pciehp_hpc.c  |   26 +++++++++++---------------
 2 files changed, 21 insertions(+), 40 deletions(-)

Index: 20091026/drivers/pci/hotplug/pciehp_ctrl.c
===================================================================
--- 20091026.orig/drivers/pci/hotplug/pciehp_ctrl.c
+++ 20091026/drivers/pci/hotplug/pciehp_ctrl.c
@@ -142,23 +142,9 @@ u8 pciehp_handle_power_fault(struct slot
 
 	/* power fault */
 	ctrl_dbg(ctrl, "Power fault interrupt received\n");
-
-	if (!pciehp_query_power_fault(p_slot)) {
-		/*
-		 * power fault Cleared
-		 */
-		ctrl_info(ctrl, "Power fault cleared on Slot(%s)\n",
-			  slot_name(p_slot));
-		event_type = INT_POWER_FAULT_CLEAR;
-	} else {
-		/*
-		 *   power fault
-		 */
-		ctrl_info(ctrl, "Power fault on Slot(%s)\n", slot_name(p_slot));
-		event_type = INT_POWER_FAULT;
-		ctrl_info(ctrl, "Power fault bit %x set\n", 0);
-	}
-
+	ctrl_err(ctrl, "Power fault on slot %s\n", slot_name(p_slot));
+	event_type = INT_POWER_FAULT;
+	ctrl_info(ctrl, "Power fault bit %x set\n", 0);
 	queue_interrupt_event(p_slot, event_type);
 
 	return 1;
@@ -220,18 +206,17 @@ static int board_added(struct slot *p_sl
 	if (PWR_LED(ctrl))
 		pciehp_green_led_blink(p_slot);
 
+	/* Check for a power fault */
+	if (ctrl->power_fault_detected || pciehp_query_power_fault(p_slot)) {
+		ctrl_err(ctrl, "Power fault on slot %s\n", slot_name(p_slot));
+		retval = -EIO;
+		goto err_exit;
+	}
+
 	/* Check link training status */
 	retval = pciehp_check_link_status(ctrl);
 	if (retval) {
 		ctrl_err(ctrl, "Failed to check link status\n");
-		set_slot_off(ctrl, p_slot);
-		return retval;
-	}
-
-	/* Check for a power fault */
-	if (pciehp_query_power_fault(p_slot)) {
-		ctrl_dbg(ctrl, "Power fault detected\n");
-		retval = -EIO;
 		goto err_exit;
 	}
 
Index: 20091026/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- 20091026.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ 20091026/drivers/pci/hotplug/pciehp_hpc.c
@@ -514,15 +514,10 @@ int pciehp_power_on_slot(struct slot * s
 			return retval;
 		}
 	}
+	ctrl->power_fault_detected = 0;
 
 	slot_cmd = POWER_ON;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
-	if (!pciehp_poll_mode) {
-		/* Enable power fault detection turned off at power off time */
-		slot_cmd |= PCI_EXP_SLTCTL_PFDE;
-		cmd_mask |= PCI_EXP_SLTCTL_PFDE;
-	}
-
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
 	if (retval) {
 		ctrl_err(ctrl, "Write %x command failed!\n", slot_cmd);
@@ -531,7 +526,6 @@ int pciehp_power_on_slot(struct slot * s
 	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n",
 		 __func__, ctrl->cap_base + PCI_EXP_SLTCTL, slot_cmd);
 
-	ctrl->power_fault_detected = 0;
 	return retval;
 }
 
@@ -586,12 +580,6 @@ int pciehp_power_off_slot(struct slot * 
 
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
-	if (!pciehp_poll_mode) {
-		/* Disable power fault detection */
-		slot_cmd &= ~PCI_EXP_SLTCTL_PFDE;
-		cmd_mask |= PCI_EXP_SLTCTL_PFDE;
-	}
-
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
 	if (retval) {
 		ctrl_err(ctrl, "Write command failed!\n");
@@ -840,11 +828,19 @@ int pcie_enable_notification(struct cont
 {
 	u16 cmd, mask;
 
+	/*
+	 * TBD: Power fault detected software notification support.
+	 *
+	 * Power fault detected software notification is not enabled
+	 * now, because it caused power fault detected interrupt storm
+	 * on some machines. On those machines, power fault detected
+	 * bit in the slot status register was set again immediately
+	 * when it is cleared in the interrupt service routine, and
+	 * next power fault detected interrupt was notified again.
+	 */
 	cmd = PCI_EXP_SLTCTL_PDCE;
 	if (ATTN_BUTTN(ctrl))
 		cmd |= PCI_EXP_SLTCTL_ABPE;
-	if (POWER_CTRL(ctrl))
-		cmd |= PCI_EXP_SLTCTL_PFDE;
 	if (MRL_SENS(ctrl))
 		cmd |= PCI_EXP_SLTCTL_MRLSCE;
 	if (!pciehp_poll_mode)

--------------000209010401060901040208
Content-Type: text/plain;
 name="pci-hotplug-fix-oshp-evaluation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pci-hotplug-fix-oshp-evaluation.patch"

If firmware doesn't grant over native hotplug control through ACPI
_OSC method, we must not evaluate OSHP.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/acpi_pcihp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: 20091026/drivers/pci/hotplug/acpi_pcihp.c
===================================================================
--- 20091026.orig/drivers/pci/hotplug/acpi_pcihp.c
+++ 20091026/drivers/pci/hotplug/acpi_pcihp.c
@@ -362,6 +362,8 @@ int acpi_get_hp_hw_control_from_firmware
 		status = acpi_pci_osc_control_set(handle, flags);
 		if (ACPI_SUCCESS(status))
 			goto got_one;
+		if (status == AE_SUPPORT)
+			goto no_control;
 		kfree(string.pointer);
 		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
 	}
@@ -394,10 +396,9 @@ int acpi_get_hp_hw_control_from_firmware
 		if (ACPI_FAILURE(status))
 			break;
 	}
-
+no_control:
 	dbg("Cannot get control of hotplug hardware for pci %s\n",
 	    pci_name(pdev));
-
 	kfree(string.pointer);
 	return -ENODEV;
 got_one:

--------------000209010401060901040208--

