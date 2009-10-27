Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZJ0Ig3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZJ0Ig3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZJ0Ig3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:36:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35314 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZJ0Ig1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:36:27 -0400
Date: Tue, 27 Oct 2009 09:36:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027083631.GV10727@kernel.dk>
References: <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <4AE693D9.3070100@jp.fujitsu.com> <20091027082720.GT10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027082720.GT10727@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Jens Axboe wrote:
> On Tue, Oct 27 2009, Kenji Kaneshige wrote:
> > Jens Axboe wrote:
> >> On Tue, Oct 20 2009, Alex Chiang wrote:
> >>> * Jens Axboe <jens.axboe@oracle.com>:
> >>>> On Tue, Oct 13 2009, Alex Chiang wrote:
> >>>>>>> Can you modprobe acpiphp with debug=1? And send the output?
> >>>>>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> >>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
> >>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
> >>>>>> acpiphp: Slot [1] registered
> >>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
> >>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
> >>>>>> acpiphp: Slot [2] registered
> >>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
> >>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
> >>>>>> acpiphp: Slot [6] registered
> >>>>>> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
> >>>>>> acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
> >>>>>> acpiphp: Slot [7] registered
> >>>>>> acpiphp_glue: Bus 0000:87 has 1 slot
> >>>>>> acpiphp_glue: Bus 0000:84 has 1 slot
> >>>>>> acpiphp_glue: Bus 0000:0b has 1 slot
> >>>>>> acpiphp_glue: Bus 0000:08 has 1 slot
> >>>>>> acpiphp_glue: Total 4 slots
> >>>>> You mentioned in another mail that you echoed 1 into the various
> >>>>> slots' power files.
> >>>>>
> >>>>> Did you do that after modprobing acpiphp with debug=1?
> >>>>>
> >>>>> If so, there should be debug output when you try and turn them
> >>>>> on.
> >>>> It produces:
> >>>>
> >>>> acpiphp: enable_slot - physical_slot = 1
> >>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> >>>> acpiphp: enable_slot - physical_slot = 2
> >>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> >>>> acpiphp: enable_slot - physical_slot = 6
> >>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> >>>> acpiphp: enable_slot - physical_slot = 7
> >>>> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> >>> Hm, so for some reason, firmware on your machine is telling us
> >>> that it doesn't think cards are present and/or enabled.
> >>>
> >>> Unfortunately, I don't know why your firmware would be saying
> >>> that. We could add some more debug printks to see what firmware
> >>> thinks about your system... Or we could just wait and see what
> >>> happens after you get your hardware replaced.
> >>
> >> New board, the exact same thing happens.
> >>
> >>>> I have a card in one of the slots only this time.
> >>>>
> >>>>> Also, quick dummy check, you are trying to power on populated
> >>>>> slots, right? :)
> >>>> Yes :-)
> >>>>
> >>>>> Can you send the output of lspci -vv? And I like the output of
> >>>>> lspci -vt as well... Both before and after loading acpiphp
> >>>>> please.
> >>>> Send privately.
> >>> No difference in before and after. Odd.
> >>>
> >>> If you want to poke us again after your hardware swap, please do
> >>> so. Sorry for being not so helpful. :-/
> >>
> >> Poke :-)
> >>
> >> One more thing I tried was pushing the power button on the slot
> >> manually. With acpiphp, I get the same messages as above. Using pciehp,
> >> I get the same power fault bit interrupt storm. So no difference from
> >> using the sysfs interface or doing it on the box side, doesn't work
> >> either way.
> >>
> >
> > I'd like to confirm power fault interrupt storm, just in case.
> > Could you get /proc/interrupts information after power fault
> > problem happens and send it to me?
> 
> The box pretty much hangs when I try to power on a slot with pciehp, so
> it's not easy to do... It doesn't hang with acpiphp, but doesn't work
> either (see previous reply to Alex).

Ditto new debug info, in case it is of any assistance. Loading pciehp
with pciehp_debug=1.

acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
pciehp 0000:00:05.0:pcie04: Hotplug Controller:
pciehp 0000:00:05.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:05.0 IRQ 75
pciehp 0000:00:05.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:05.0:pcie04:   Device ID            : 0x340c
pciehp 0000:00:05.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:00:05.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:00:05.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:00:05.0:pcie04:   PCI resource [7]     : 0x1000@0x1000
pciehp 0000:00:05.0:pcie04:   PCI resource [8]     : 0x200000@0x91a00000
pciehp 0000:00:05.0:pcie04:   PCI resource [9]     : 0x200000@0x91c00000
pciehp 0000:00:05.0:pcie04: Slot Capabilities      : 0x0008005b
pciehp 0000:00:05.0:pcie04:   Physical Slot Number : 1
pciehp 0000:00:05.0:pcie04:   Attention Button     : yes
pciehp 0000:00:05.0:pcie04:   Power Controller     : yes
pciehp 0000:00:05.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:05.0:pcie04:   Attention Indicator  : yes
pciehp 0000:00:05.0:pcie04:   Power Indicator      : yes
pciehp 0000:00:05.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:00:05.0:pcie04:   EMI Present          :  no
pciehp 0000:00:05.0:pcie04:   Command Completed    : yes
pciehp 0000:00:05.0:pcie04: Slot Status            : 0x0040
pciehp 0000:00:05.0:pcie04: Slot Control           : 0x07c0
pciehp 0000:00:05.0:pcie04: Link Active Reporting supported
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
pciehp 0000:00:05.0:pcie04: Registering domain:bus:dev=0000:08:00 sun=1
pciehp 0000:00:05.0:pcie04: get_power_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:00:05.0:pcie04: get_attention_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:00:05.0:pcie04: get_latch_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: get_adapter_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
pciehp 0000:00:07.0:pcie04: Hotplug Controller:
pciehp 0000:00:07.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:07.0 IRQ 76
pciehp 0000:00:07.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:07.0:pcie04:   Device ID            : 0x340e
pciehp 0000:00:07.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:00:07.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:00:07.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:00:07.0:pcie04:   PCI resource [7]     : 0x1000@0x2000
pciehp 0000:00:07.0:pcie04:   PCI resource [8]     : 0x200000@0x91e00000
pciehp 0000:00:07.0:pcie04:   PCI resource [9]     : 0x200000@0x92000000
pciehp 0000:00:07.0:pcie04: Slot Capabilities      : 0x0010005b
pciehp 0000:00:07.0:pcie04:   Physical Slot Number : 2
pciehp 0000:00:07.0:pcie04:   Attention Button     : yes
pciehp 0000:00:07.0:pcie04:   Power Controller     : yes
pciehp 0000:00:07.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:07.0:pcie04:   Attention Indicator  : yes
pciehp 0000:00:07.0:pcie04:   Power Indicator      : yes
pciehp 0000:00:07.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:00:07.0:pcie04:   EMI Present          :  no
pciehp 0000:00:07.0:pcie04:   Command Completed    : yes
pciehp 0000:00:07.0:pcie04: Slot Status            : 0x0000
pciehp 0000:00:07.0:pcie04: Slot Control           : 0x07c0
pciehp 0000:00:07.0:pcie04: Link Active Reporting supported
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:00:07.0:pcie04: Registering domain:bus:dev=0000:0b:00 sun=2
pciehp 0000:00:07.0:pcie04: get_power_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:00:07.0:pcie04: get_attention_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:00:07.0:pcie04: get_latch_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: get_adapter_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
pciehp 0000:80:07.0:pcie04: Hotplug Controller:
pciehp 0000:80:07.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:80:07.0 IRQ 84
pciehp 0000:80:07.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:80:07.0:pcie04:   Device ID            : 0x340e
pciehp 0000:80:07.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:80:07.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:80:07.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:80:07.0:pcie04:   PCI resource [7]     : 0x1000@0x8000
pciehp 0000:80:07.0:pcie04:   PCI resource [8]     : 0x200000@0x92700000
pciehp 0000:80:07.0:pcie04:   PCI resource [9]     : 0x200000@0x92900000
pciehp 0000:80:07.0:pcie04: Slot Capabilities      : 0x0030005b
pciehp 0000:80:07.0:pcie04:   Physical Slot Number : 6
pciehp 0000:80:07.0:pcie04:   Attention Button     : yes
pciehp 0000:80:07.0:pcie04:   Power Controller     : yes
pciehp 0000:80:07.0:pcie04:   MRL Sensor           :  no
pciehp 0000:80:07.0:pcie04:   Attention Indicator  : yes
pciehp 0000:80:07.0:pcie04:   Power Indicator      : yes
pciehp 0000:80:07.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:80:07.0:pcie04:   EMI Present          :  no
pciehp 0000:80:07.0:pcie04:   Command Completed    : yes
pciehp 0000:80:07.0:pcie04: Slot Status            : 0x0040
pciehp 0000:80:07.0:pcie04: Slot Control           : 0x0740
pciehp 0000:80:07.0:pcie04: Link Active Reporting supported
pciehp 0000:80:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:80:07.0:pcie04: Registering domain:bus:dev=0000:84:00 sun=6
pciehp 0000:80:07.0:pcie04: get_power_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 740
pciehp 0000:80:07.0:pcie04: get_attention_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 740
pciehp 0000:80:07.0:pcie04: get_latch_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: get_adapter_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
pciehp 0000:80:09.0:pcie04: Hotplug Controller:
pciehp 0000:80:09.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:80:09.0 IRQ 85
pciehp 0000:80:09.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:80:09.0:pcie04:   Device ID            : 0x3410
pciehp 0000:80:09.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:80:09.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:80:09.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:80:09.0:pcie04:   PCI resource [7]     : 0x1000@0x9000
pciehp 0000:80:09.0:pcie04:   PCI resource [8]     : 0x200000@0x92b00000
pciehp 0000:80:09.0:pcie04:   PCI resource [9]     : 0x200000@0x92d00000
pciehp 0000:80:09.0:pcie04: Slot Capabilities      : 0x0038005b
pciehp 0000:80:09.0:pcie04:   Physical Slot Number : 7
pciehp 0000:80:09.0:pcie04:   Attention Button     : yes
pciehp 0000:80:09.0:pcie04:   Power Controller     : yes
pciehp 0000:80:09.0:pcie04:   MRL Sensor           :  no
pciehp 0000:80:09.0:pcie04:   Attention Indicator  : yes
pciehp 0000:80:09.0:pcie04:   Power Indicator      : yes
pciehp 0000:80:09.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:80:09.0:pcie04:   EMI Present          :  no
pciehp 0000:80:09.0:pcie04:   Command Completed    : yes
pciehp 0000:80:09.0:pcie04: Slot Status            : 0x0000
pciehp 0000:80:09.0:pcie04: Slot Control           : 0x07c0
pciehp 0000:80:09.0:pcie04: Link Active Reporting supported
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
pciehp 0000:80:09.0:pcie04: Registering domain:bus:dev=0000:87:00 sun=7
pciehp 0000:80:09.0:pcie04: get_power_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:80:09.0:pcie04: get_attention_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:80:09.0:pcie04: get_latch_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: get_adapter_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
pciehp: pcie_port_service_register = 0
pciehp: PCI Express Hot Plug Controller Driver version: 0.4

-- 
Jens Axboe

