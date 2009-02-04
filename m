Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZBDSRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZBDSRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZBDSRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:17:22 -0500
Received: from bay0-omc2-s10.bay0.hotmail.com ([65.54.246.146]:51698 "EHLO
	bay0-omc2-s10.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbZBDSRV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:17:21 -0500
Message-ID: <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
X-Originating-IP: [171.70.247.34]
From: Krishna Kothapalli <krishna_sunitha@hotmail.com>
To: <kaneshige.kenji@jp.fujitsu.com>
CC: <ebiederm@xmission.com>, <linux-pci@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <achiang@hp.com>, <djwong@us.ibm.com>,
       <xyzzy@speakeasy.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Q: state of pci express hotplug
Date: Wed, 4 Feb 2009 13:17:20 -0500
Importance: Normal
In-Reply-To: <49892CDE.9040305@jp.fujitsu.com>
References: <m1fxj06js8.fsf@fess.ebiederm.org>
 <4986581F.7060704@jp.fujitsu.com>
   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
   <49879508.4090801@jp.fujitsu.com>
   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl>
 <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl>
 <49892CDE.9040305@jp.fujitsu.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Feb 2009 18:17:20.0276 (UTC) FILETIME=[D18F9540:01C986F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Kenji Kaneshige wrote:
>
> Thank you for sending the information. I understood your
> hotplug slot can be handled by acpiphp or pciehp.
> More majordomo info at http://vger.kernel.org/majordomo-info.html

Tested this with 2.6.28.3 and details below:

>Could you give me the following additional information?
>o My understanding about the problem is:
>  - Bad IRQ happen when you hot-add the device,

   I don't see bad IRQ stack trace anymore, based on the steps you suggested. May be this is because I did not have hotplug driverloaded (and diff kernel build config) ?
  
>  - and the device is not found in the lspci output

   YES

>  - and the device didn't show up under sysfs
>  Am I correct?

   YES
 
> o Details about the steps to reproduce the problem.

  - boot the box with 2.6.28.3
  -   # /sbin/modprobe pciehp pciehp_debug
  - lspci 
  - Insert the PCI express card on the hot swap slot and wait for 2 mins
  - lspci <-- this does not show the PCI express device 
  (The same device shows up in lspci and sysfs during cold boot ) 

> o Does the problem happen with both acpiphp and pciehp?

   That is correct.

> o The pciehp's debug output. We can get this as follows.
  # /sbin/modprobe pciehp pciehp_debug
  # dmesg | grep pciehp 
pciehp 0000:00:09.0:pcie02: Hotplug Controller:
pciehp 0000:00:09.0:pcie02:   Seg/Bus/Dev/Func/IRQ : 0000:00:09.0 IRQ 2295
pciehp 0000:00:09.0:pcie02:   Vendor ID            : 0x8086
pciehp 0000:00:09.0:pcie02:   Device ID            : 0x3410
pciehp 0000:00:09.0:pcie02:   Subsystem ID         : 0x0000
pciehp 0000:00:09.0:pcie02:   Subsystem Vendor ID  : 0x0000
pciehp 0000:00:09.0:pcie02:   PCIe Cap offset      : 0x90
pciehp 0000:00:09.0:pcie02: Slot Capabilities      : 0x0302005f
pciehp 0000:00:09.0:pcie02:   Physical Slot Number : 96
pciehp 0000:00:09.0:pcie02:   Attention Button     : yes
pciehp 0000:00:09.0:pcie02:   Power Controller     : yes
pciehp 0000:00:09.0:pcie02:   MRL Sensor           : yes
pciehp 0000:00:09.0:pcie02:   Attention Indicator  : yes
pciehp 0000:00:09.0:pcie02:   Power Indicator      : yes
pciehp 0000:00:09.0:pcie02:   Hot-Plug Surprise    :  no
pciehp 0000:00:09.0:pcie02:   EMI Present          : yes
pciehp 0000:00:09.0:pcie02:   Command Completed    : yes
pciehp 0000:00:09.0:pcie02: Slot Status            : 0x0020
pciehp 0000:00:09.0:pcie02: Slot Control           : 0x078f
pciehp 0000:00:09.0:pcie02: Link Active Reporting supported
pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
pciehp 0000:00:09.0:pcie02: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
pciehp 0000:00:09.0:pcie02: Registering domain:bus:dev=0000:09:00 hp_slot=0 sun=60 slot_device_offset=0
pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7bf
pciehp 0000:00:09.0:pcie02: get_attention_status: physical_slot = 96
pciehp 0000:00:09.0:pcie02: hpc_get_attention_status: SLOTCTRL a8, value read 7bf
pciehp 0000:00:09.0:pcie02: get_latch_status: physical_slot = 96
pciehp 0000:00:09.0:pcie02: get_adapter_status: physical_slot = 96
pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: slot->hp_slot 0
pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
pciehp 0000:00:09.0:pcie02: hpc_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:00:09.0:pcie02: service driver pciehp loaded
pciehp: pcie_port_service_register = 0
pciehp: PCI Express Hot Plug Controller Driver version: 0.4

-- Hot plug PCI express card and wait for 2 mins
-- no additional out put from dmesg

[root@localhost test]# /sbin/rmmod pciehp 
[root@localhost test]# dmesg | grep pciehp
-- Additional  output from dmesg  after pciehp is unloaded ( but the express card is still present in the slot):-
pciehp: unload_pciehpd()
pciehp 0000:00:09.0:pcie02: unloading service driver pciehp
pciehp 0000:00:09.0:pcie02: release_slot: physical_slot = 96
pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
pciehp 0000:00:09.0:pcie02: pcie_isr: intr_loc 8
pciehp 0000:00:09.0:pcie02: Presence/Notify input change
pciehp 0000:00:09.0:pcie02: Card present on Slot(øu'?)

-- removed the PCI express card from the slot

[root@localhost test]# ls -lt /sys/bus/pci/slots
total 0
[root@localhost test]#  /sbin/modprobe acpiphp debug
[root@localhost test]# dmesg | grep acpiphp
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:09.0
acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:09:00
acpiphp: Slot [2] registered
acpiphp_glue: Bus 0000:09 has 1 slot
acpiphp_glue: Total 1 slots
[root@localhost test]# 
[root@localhost test]# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-04 09:59 2
---  Insert PCI express card in the slot
[root@localhost test]# dmesg | grep acpiphp
[root@localhost test]# lspci | wc
    105    1284    9203
[root@localhost test]# ls -lt /sys/bus/pci/slots/2/
total 0
-r--r--r-- 1 root root 4096 2009-02-04 10:01 adapter
-r--r--r-- 1 root root 4096 2009-02-04 10:01 address
-rw-r--r-- 1 root root 4096 2009-02-04 10:01 attention
-r--r--r-- 1 root root 4096 2009-02-04 10:01 latch
-rw-r--r-- 1 root root 4096 2009-02-04 10:01 power
[root@localhost test]# 
[root@localhost test]# /sbin/rmmod acpiphp
[root@localhost test]# dmesg | grep acpiphp
acpiphp: Slot [2] unregistered
acpiphp: release_slot - physical_slot = 2
[root@localhost test]# 



_________________________________________________________________
Windows Live™: Keep your life in sync. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t1_allup_howitworks_022009