Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZBEGm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZBEGm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZBEGmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:42:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34786 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZBEGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:42:42 -0500
Message-ID: <498A8A52.9030606@jp.fujitsu.com>
Date: Thu, 05 Feb 2009 15:42:26 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
CC: ebiederm@xmission.com, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       achiang@hp.com, djwong@us.ibm.com, xyzzy@speakeasy.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com>   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>   <49879508.4090801@jp.fujitsu.com>   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl> <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl> <49892CDE.9040305@jp.fujitsu.com> <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl> <498A2C90.2000208@jp.fujitsu.com> <BAY111-W332E2827777D42F10C311E88C00@phx.gbl>
In-Reply-To: <BAY111-W332E2827777D42F10C311E88C00@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the information. From the information, I understood
both acpiphp and pciehp handles the same slot, and failed powering
on the slot because those drivers detected adapter card didn't
present or MRL opened. But I still don't know why. Could you send
the following addtional information?

(1) The whole 'lspci -vvv' output after booting the system with
    your device inserted (not hot-plugging). Please do it as a
    root user. And please also tell me which entry is corresponding
    to your device in the output.

(2) Try hot-plugging with pciehp again with the following steps
    and give me the result.

    1. # /sbin/modprobe pciehp pciehp_debug
    2. # pr -f /sys/bus/pci/slots/96/*
    3. Insert the adapter card.
    4. # echo 1 > /sys/bus/pci/slots/96/lock
    5. wait for at least 1 second.
    6. # pr -f /sys/bus/pci/slots/96/*
    7. # echo 1 > /sys/bus/pci/slots/96/power
    8. # pr -f /sys/bus/pci/slots/96/*
    9. check if your device is added

Thanks,
Kenji Kaneshige


Krishna Kothapalli wrote:
> 
> 
> Tried  echo power with pciehp, acpiphp. Aslo included dmidecode output. Not much luck yet. Thanks much.
> 
> 
>> Kenji Kaneshige
>> Could you try below after inserting the device?
>>  With pciehp:
>>    # echo 1> /sys/bus/pci/slots/96/power
>> With acpiphp:
>>    # echo 1> /sys/bus/pci/slots/2/power
> 
> with pciehp
> ----------------
> # uname -a
> Linux localhost.localdomain 2.6.28.3 #1 SMP Tue Feb 3 16:51:23 PST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> #/sbin/modprobe pciehp pciehp_debug
> [root@localhost test]# dmesg | grep pciehp
> pciehp 0000:00:09.0:pcie02: Hotplug Controller:
> pciehp 0000:00:09.0:pcie02:   Seg/Bus/Dev/Func/IRQ : 0000:00:09.0 IRQ 2295
> pciehp 0000:00:09.0:pcie02:   Vendor ID            : 0x8086
> pciehp 0000:00:09.0:pcie02:   Device ID            : 0x3410
> pciehp 0000:00:09.0:pcie02:   Subsystem ID         : 0x0000
> pciehp 0000:00:09.0:pcie02:   Subsystem Vendor ID  : 0x0000
> pciehp 0000:00:09.0:pcie02:   PCIe Cap offset      : 0x90
> pciehp 0000:00:09.0:pcie02: Slot Capabilities      : 0x0302005f
> pciehp 0000:00:09.0:pcie02:   Physical Slot Number : 96
> pciehp 0000:00:09.0:pcie02:   Attention Button     : yes
> pciehp 0000:00:09.0:pcie02:   Power Controller     : yes
> pciehp 0000:00:09.0:pcie02:   MRL Sensor           : yes
> pciehp 0000:00:09.0:pcie02:   Attention Indicator  : yes
> pciehp 0000:00:09.0:pcie02:   Power Indicator      : yes
> pciehp 0000:00:09.0:pcie02:   Hot-Plug Surprise    :  no
> pciehp 0000:00:09.0:pcie02:   EMI Present          : yes
> pciehp 0000:00:09.0:pcie02:   Command Completed    : yes
> pciehp 0000:00:09.0:pcie02: Slot Status            : 0x0020
> pciehp 0000:00:09.0:pcie02: Slot Control           : 0x078f
> pciehp 0000:00:09.0:pcie02: Link Active Reporting supported
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: Registering domain:bus:dev=0000:09:00 hp_slot=0 sun=60 slot_device_offset=0
> pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7bf
> pciehp 0000:00:09.0:pcie02: get_attention_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_get_attention_status: SLOTCTRL a8, value read 7bf
> pciehp 0000:00:09.0:pcie02: get_latch_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: get_adapter_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: slot->hp_slot 0
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: SLOTCTRL a8 write cmd 400
> pciehp 0000:00:09.0:pcie02: service driver pciehp loaded
> pciehp: pcie_port_service_register = 0
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> 
> #insmod mvumi.ko
> # ls -lRt /sys/bus/pci/slots
> /sys/bus/pci/slots:
> total 0
> drwxr-xr-x 2 root root 0 2009-02-04 17:08 96
> 
> /sys/bus/pci/slots/96:
> total 0
> -r--r--r-- 1 root root 4096 2009-02-04 17:10 adapter
> -r--r--r-- 1 root root 4096 2009-02-04 17:10 address
> -rw-r--r-- 1 root root 4096 2009-02-04 17:10 attention
> -r--r--r-- 1 root root 4096 2009-02-04 17:10 cur_bus_speed
> -r--r--r-- 1 root root 4096 2009-02-04 17:10 latch
> -rw-r--r-- 1 root root 4096 2009-02-04 17:10 lock
> -r--r--r-- 1 root root 4096 2009-02-04 17:10 max_bus_speed
> -rw-r--r-- 1 root root 4096 2009-02-04 17:10 power
> [root@localhost linux-2.0.4.9]# 
> 
> 
> -- HOT plug the PCI Express card (some out put in dmesg!!)
> 
> pciehp 0000:00:09.0:pcie02: enable_slot: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: Latch open on slot(96)
> pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7b1
> pciehp 0000:00:09.0:pcie02: enable_slot: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: Latch open on slot(96)
> pciehp 0000:00:09.0:pcie02: enable_slot: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: No adapter on slot(96)
> 
> [root@localhost linux-2.0.4.9]# lspci | wc
>     105    1284    9203 <-- same 105 devices as before
> 
> # echo 1> /sys/bus/pci/slots/96/power
> bash: echo: write error: No such device
> 
> [root@localhost linux-2.0.4.9]# lsmod | grep pciehp
> pciehp                 42780  0 
> [root@localhost linux-2.0.4.9]# 
> 
> #/sbin/rmmod pciehp
> 
> #dmesg | grep pciehp
> ....
> pciehp: unload_pciehpd()
> pciehp 0000:00:09.0:pcie02: unloading service driver pciehp
> pciehp 0000:00:09.0:pcie02: release_slot: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: pcie_isr: intr_loc 8
> pciehp 0000:00:09.0:pcie02: Presence/Notify input change
> pciehp 0000:00:09.0:pcie02: Card not present on Slot(àt'?)
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4 unloaded
> 
> 
> # ls -lt /sys/bus/pci/slots
> total 0
> #
> 
> -- Remove PCI express card from the slot
> 
> with modprobe  pciehp pciehp_force=1  pciehp_debug
> ------------------------------------------------------
> 
>> Mark Lord
>> Does it behave better with the pciehp_force=1 option?
>>   modprobe  pciehp pciehp_force=1
> 
> # modprobe  pciehp pciehp_force=1
> pciehp 0000:00:09.0:pcie02: Bypassing BIOS check for pciehp use on 0000:00:09.0
> pciehp 0000:00:09.0:pcie02: Link Active Reporting supported
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: Registering domain:bus:dev=0000:09:00 hp_slot=0 sun=60 slot_device_offset=0
> pci_create_slot: created pci_slot on 0000:09:00
> pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7bf
> pciehp 0000:00:09.0:pcie02: get_attention_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_get_attention_status: SLOTCTRL a8, value read 7bf
> pciehp 0000:00:09.0:pcie02: get_latch_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: get_adapter_status: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: slot->hp_slot 0
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: SLOTCTRL a8 write cmd 400
> pciehp 0000:00:09.0:pcie02: service driver pciehp loaded
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> 
> -- Insert PCI express card
> 
> # lspci | wc
>     105    1284    9203 <-- number of devices did not increase
> 
> # ls -lRtr /sys/bus/pci/slots
> /sys/bus/pci/slots:
> total 0
> drwxr-xr-x 2 root root 0 2009-02-04 17:27 96
> 
> /sys/bus/pci/slots/96:
> total 0
> -rw-r--r-- 1 root root 4096 2009-02-04 17:31 power
> -r--r--r-- 1 root root 4096 2009-02-04 17:31 max_bus_speed
> -rw-r--r-- 1 root root 4096 2009-02-04 17:31 lock
> -r--r--r-- 1 root root 4096 2009-02-04 17:31 latch
> -r--r--r-- 1 root root 4096 2009-02-04 17:31 cur_bus_speed
> -rw-r--r-- 1 root root 4096 2009-02-04 17:31 attention
> -r--r--r-- 1 root root 4096 2009-02-04 17:31 address
> -r--r--r-- 1 root root 4096 2009-02-04 17:31 adapter
> [root@localhost linux-2.0.4.9]# 
> 
> # echo 1> /sys/bus/pci/slots/96/power 
> bash: echo: write error: No such device
> 
> -- remove PCI express card
> 
> 
> # /sbin/rmmod pciehp
> pciehp 0000:00:09.0:pcie02: enable_slot: physical_slot = 96
> pciehp 0000:00:09.0:pcie02: No adapter on slot(96)
> pciehp 0000:00:09.0:pcie02: unloading service driver pciehp
> pciehp 0000:00:09.0:pcie02: release_slot: physical_slot = 96
> pci_destroy_slot: dec refcount to 0 on 0000:09:00
> pci_slot_release: releasing pci_slot on 9:0
> pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4 unloaded
> 
> with acpiphp
> -------------
> 
> # lsmod | grep pciehp
> 
> # /sbin/modprobe acpiphp debug
> 
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:09.0
> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:09:00
> pci_create_slot: created pci_slot on 0000:09:00
> acpiphp: Slot [2] registered
> acpiphp_glue: Bus 0000:09 has 1 slot
> acpiphp_glue: Total 1 slots
> 
> # ls -lRt /sys/bus/pci/slots
> /sys/bus/pci/slots:
> total 0
> drwxr-xr-x 2 root root 0 2009-02-04 17:37 2
> 
> /sys/bus/pci/slots/2:
> total 0
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 adapter
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 address
> -rw-r--r-- 1 root root 4096 2009-02-04 17:38 attention
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 latch
> -rw-r--r-- 1 root root 4096 2009-02-04 17:38 power
> 
> -- Insert PCI express card in the slot
> 
> # ls -lRt /sys/bus/pci/slots
> /sys/bus/pci/slots:
> total 0
> drwxr-xr-x 2 root root 0 2009-02-04 17:37 2
> 
> /sys/bus/pci/slots/2:
> total 0
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 adapter
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 address
> -rw-r--r-- 1 root root 4096 2009-02-04 17:38 attention
> -r--r--r-- 1 root root 4096 2009-02-04 17:38 latch
> -rw-r--r-- 1 root root 4096 2009-02-04 17:38 power
> # 
> 
> -- Insert PCI express card in the slot
> 
> # echo 1> /sys/bus/pci/slots/2/power
> #
> acpiphp: enable_slot - physical_slot = 2
> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> 
> # lspci | wc
>     105    1284    9203 <- same 105 
> 
> 
> 
> dmidecode
> --------------
>> Alex Chiang 
>> Did we ever get a dmidecode from this machine?
> 
> 
> [root@localhost test]# /usr/sbin/dmidecode
> # dmidecode 2.9
> SMBIOS 2.4 present.
> 65 structures occupying 2483 bytes.
> Table at 0x3F6A3000.
> 
> Handle 0x0000, DMI type 0, 24 bytes
> BIOS Information
>     Vendor: INTEL
>     Version: Txx047_CRB
>     Release Date: Not Specified
>     Address: 0xF0000
>     Runtime Size: 64 kB
>     ROM Size: 4096 kB
>     Characteristics:
>         PCI is supported
>         PNP is supported
>         BIOS is upgradeable
>         BIOS shadowing is allowed
>         Boot from CD is supported
>         Selectable boot is supported
>         EDD is supported
>         3.5"/2.88 MB floppy services are supported (int 13h)
>         Print screen service is supported (int 5h)
>         8042 keyboard services are supported (int 9h)
>         Serial services are supported (int 14h)
>         CGA/mono video services are supported (int 10h)
>         ACPI is supported
>         USB legacy is supported
>         LS-120 boot is supported
>         ATAPI Zip drive boot is supported
>         Function key-initiated network boot is supported
>         Targeted content distribution is supported
>     BIOS Revision: 24.22
>     Firmware Revision: 0.0
> 
> Handle 0x0001, DMI type 8, 9 bytes
> Port Connector Information
>     Internal Reference Designator: J2H1
>     Internal Connector Type: On Board IDE
>     External Reference Designator: OnBoard Secondary IDE
>     External Connector Type: None
>     Port Type: Other
> 
> Handle 0x0002, DMI type 13, 22 bytes
> BIOS Language Information
>     Installable Languages: 2
>         English
>         
>     Currently Installed Language: English
> 
> Handle 0x0003, DMI type 12, 5 bytes
> System Configuration Options
>     Option 1: J1D4:1-2,5-6,9-10Default;2-3CMOS clr,6-7Pswd clr,10-11Recovery
> 
> Handle 0x0004, DMI type 16, 15 bytes
> Physical Memory Array
>     Location: System Board Or Motherboard
>     Use: System Memory
>     Error Correction Type: Single-bit ECC
>     Maximum Capacity: 192 GB
>     Error Information Handle: Not Provided
>     Number Of Devices: 18
> 
> Handle 0x0005, DMI type 19, 15 bytes
> Memory Array Mapped Address
>     Starting Address: 0x00000000000
>     Ending Address: 0x0003FFFFFFF
>     Range Size: 1 GB
>     Physical Array Handle: 0x0004
>     Partition Width: 0
> 
> Handle 0x0006, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J2MY
>     Bank Locator: BRANCH 0 CHANNEL 0 DIMM 0
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0007, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J1MY
>     Bank Locator: BRANCH 0 CHANNEL 0 DIMM 1
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0008, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J5MY
>     Bank Locator: BRANCH 0 CHANNEL 1 DIMM 0
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0009, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J3MY
>     Bank Locator: BRANCH 0 CHANNEL 1 DIMM 1
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000A, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J6MY
>     Bank Locator: BRANCH 1 CHANNEL 0 DIMM 0
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000B, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: J4MY
>     Bank Locator: BRANCH 1 CHANNEL 0 DIMM 1
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000C, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000D, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000E, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J2MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x000F, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J1MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0010, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J5MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0011, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J3MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0012, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J6MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0013, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: J4MY
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0014, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0015, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0016, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0017, DMI type 17, 27 bytes
> Memory Device
>     Array Handle: 0x0004
>     Error Information Handle: Not Provided
>     Total Width: Unknown
>     Data Width: Unknown
>     Size: No Module Installed
>     Form Factor: DIMM
>     Set: None
>     Locator: Not Specified
>     Bank Locator: Not Specified
>     Type: DDR2
>     Type Detail: Synchronous
>     Speed: 800 MHz (1.2 ns)
>     Manufacturer: NO DIMM
>     Serial Number: NO DIMM
>     Asset Tag: NO DIMM
>     Part Number: NO DIMM
> 
> Handle 0x0018, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2001 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x001C
>     L2 Cache Handle: 0x001B
>     L3 Cache Handle: 0x0019
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x0019, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x001A, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x001B, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x001C, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x001D, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2003 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x0021
>     L2 Cache Handle: 0x0020
>     L3 Cache Handle: 0x001E
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x001E, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x001F, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x0020, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x0021, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x0022, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2002 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x0026
>     L2 Cache Handle: 0x0025
>     L3 Cache Handle: 0x0023
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x0023, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x0024, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x0025, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x0026, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x0027, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2036 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x002B
>     L2 Cache Handle: 0x002A
>     L3 Cache Handle: 0x0028
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x0028, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x0029, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x002A, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x002B, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x002C, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2001 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x0030
>     L2 Cache Handle: 0x002F
>     L3 Cache Handle: 0x002D
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x002D, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x002E, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x002F, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x0030, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x0031, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2027 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x0035
>     L2 Cache Handle: 0x0034
>     L3 Cache Handle: 0x0032
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x0032, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x0033, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x0034, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x0035, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x0036, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2001 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x003A
>     L2 Cache Handle: 0x0039
>     L3 Cache Handle: 0x0037
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x0037, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x0038, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x0039, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x003A, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0x003B, DMI type 4, 35 bytes
> Processor Information
>     Socket Designation: Not Specified
>     Type: Central Processor
>     Family: Xeon
>     Manufacturer: Not Specified
>     ID: A4 06 01 00 FF FB EB BF
>     Signature: Type 0, Family 6, Model 26, Stepping 4
>     Flags:
>         FPU (Floating-point unit on-chip)
>         VME (Virtual mode extension)
>         DE (Debugging extension)
>         PSE (Page size extension)
>         TSC (Time stamp counter)
>         MSR (Model specific registers)
>         PAE (Physical address extension)
>         MCE (Machine check exception)
>         CX8 (CMPXCHG8 instruction supported)
>         APIC (On-chip APIC hardware supported)
>         SEP (Fast system call)
>         MTRR (Memory type range registers)
>         PGE (Page global enable)
>         MCA (Machine check architecture)
>         CMOV (Conditional move instruction supported)
>         PAT (Page attribute table)
>         PSE-36 (36-bit page size extension)
>         CLFSH (CLFLUSH instruction supported)
>         DS (Debug store)
>         ACPI (ACPI supported)
>         MMX (MMX technology supported)
>         FXSR (Fast floating-point save and restore)
>         SSE (Streaming SIMD extensions)
>         SSE2 (Streaming SIMD extensions 2)
>         SS (Self-snoop)
>         HTT (Hyper-threading technology)
>         TM (Thermal monitor supported)
>         PBE (Pending break enabled)
>     Version: Not Specified
>     Voltage: 1.2 V
>     External Clock: Unknown
>     Max Speed: 4000 MHz
>     Current Speed: 2052 MHz
>     Status: Populated, Enabled
>     Upgrade: ZIF Socket
>     L1 Cache Handle: 0x003F
>     L2 Cache Handle: 0x003E
>     L3 Cache Handle: 0x003C
>     Serial Number: Not Specified
>     Asset Tag: Not Specified
>     Part Number: Not Specified
> 
> Handle 0x003C, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 3
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 8192 KB
>     Maximum Size: 8192 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 16-way Set-associative
> 
> Handle 0x003D, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Data
>     Associativity: 8-way Set-associative
> 
> Handle 0x003E, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 2
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 256 KB
>     Maximum Size: 256 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Unified
>     Associativity: 8-way Set-associative
> 
> Handle 0x003F, DMI type 7, 19 bytes
> Cache Information
>     Socket Designation: Not Specified
>     Configuration: Enabled, Not Socketed, Level 1
>     Operational Mode: Write Back
>     Location: Internal
>     Installed Size: 32 KB
>     Maximum Size: 32 KB
>     Supported SRAM Types:
>         Asynchronous
>     Installed SRAM Type: Asynchronous
>     Speed: Unknown
>     Error Correction Type: Single-bit ECC
>     System Type: Instruction
>     Associativity: 4-way Set-associative
> 
> Handle 0xFEFF, DMI type 127, 4 bytes
> End Of Table
> 
> 
> _________________________________________________________________
> Windows Live™: Keep your life in sync. 
> http://windowslive.com/explore?ocid=TXT_TAGLM_WL_t1_allup_explore_022009
> 


