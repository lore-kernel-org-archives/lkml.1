Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZBDFvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZBDFvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZBDFvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:51:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39293 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZBDFvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:51:40 -0500
Message-ID: <49892CDE.9040305@jp.fujitsu.com>
Date: Wed, 04 Feb 2009 14:51:26 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
CC: ebiederm@xmission.com, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       achiang@hp.com, djwong@us.ibm.com, xyzzy@speakeasy.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com>   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>   <49879508.4090801@jp.fujitsu.com>   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl> <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl>
In-Reply-To: <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for sending the information. I understood your
hotplug slot can be handled by acpiphp or pciehp.

Could you give me the following additional information?

o My understanding about the problem is:
  - Bad IRQ happen when you hot-add the device,
  - and the device is not found in the lspci output
  - and the device didn't show up under sysfs
  Am I correct?

o Details about the steps to reproduce the problem.

o Does the problem happen with both acpiphp and pciehp?

o The pciehp's debug output. We can get this as follows.

  # /sbin/modprobe pciehp pciehp_debug
  # dmesg | grep pciehp

Thanks,
Kenji Kaneshige



Krishna Kothapalli wrote:
>> Kenji Kaneshige wrote:
>> (1) Build all your hotplug drivers as kernel modules.
>> (2) Modprobe hotplug drivers one by one, and check which drivers add
>> directories under /sys/bus/pci/slots. Before trying the next driver,
>> please rmmod the previous driver, because there are hotplug slots
>> that can be managed by the several drivers. Note that you don't need
>> to try fakephp this time.
>>
>  
> Thanks much for the exact steps. Here are the results (with 2.6.25 and 2.6.28.3 ). Pls let me know if you want me to run them on a different branch or other steps.
>  
> with 2.6.25-14
> -------------------
> 
> Built the kernel with these options:-
>  
> CONFIG_HOTPLUG_PCI=y
> CONFIG_HOTPLUG_PCI_FAKE=m
> CONFIG_HOTPLUG_PCI_ACPI=m
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=m
>  
> # uname -a
> Linux localhost.localdomain 2.6.25-14.fc9.x86_64.kkhp #4 SMP Tue Feb 3 11:12:07 PST 2009 x86_64 x86_64 x86_64 GNU/Linux
>  
>  
> [root@localhost linux-2.6.25.x86_64]#ls -lt /sys/bus/pci/slots
> total 0
> [root@localhost linux-2.6.25.x86_64]# /sbin/modprobe acpiphp
> [root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
> total 0
> drwxr-xr-x 2 root root 0 2009-02-03 11:32 2
> [root@localhost linux-2.6.25.x86_64]# /sbin/rmmod acpiphp
> [root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
> total 0
> [root@localhost linux-2.6.25.x86_64]# /sbin/modprobe pciehp
> [root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
> total 0
> drwxr-xr-x 2 root root 0 2009-02-03 11:33 0009_0096
> [root@localhost linux-2.6.25.x86_64]# /sbin/rmmod pciehp
> [root@localhost linux-2.6.25.x86_64]# /sbin/modprobe shpchp
> [root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
> total 0
> 
> with 2.6.28.3
> ---------------
> 
> build with options
> CONFIG_HOTPLUG_PCI=y
> CONFIG_HOTPLUG_PCI_FAKE=m
> CONFIG_HOTPLUG_PCI_ACPI=m
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=m
> 
> 
> # uname -a
> Linux localhost.localdomain 2.6.28.3 #1 SMP Tue Feb 3 16:51:23 PST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> #ls -lt /sys/bus/pci/slots
> total 0
> # /sbin/modprobe acpiphp
> # ls -lt /sys/bus/pci/slots
> total 0
> drwxr-xr-x 2 root root 0 2009-02-03 18:15 2
> 
> ## /var/log/messages contains following messages
> Feb  3 18:15:06 localhost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> Feb  3 18:15:06 localhost kernel: acpiphp: Slot [2] registered
> 
> # /sbin/rmmod acpiphp
> # ls -lt /sys/bus/pci/slots
> total 0
> # /sbin/modprobe pciehp
> # ls -lt /sys/bus/pci/slots
> total 0
> drwxr-xr-x 2 root root 0 2009-02-03 18:19 96
> 
> /var/log/messages:-
> Feb  3 18:19:35 localhost kernel: pciehp 0000:00:09.0:pcie02: Link Active Reporting supported
> Feb  3 18:19:36 localhost kernel: pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> Feb  3 18:19:36 localhost kernel: pciehp 0000:00:09.0:pcie02: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: Registering domain:bus:dev=0000:09:00 hp_slot=0 sun=60 slot_device_offset=0
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7bf
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_attention_status: physical_slot = 96
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: hpc_get_attention_status: SLOTCTRL a8, value read 7bf
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_latch_status: physical_slot = 96
> Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_adapter_status: physical_slot = 96
> Feb  3 18:19:37 localhost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> 
> # /sbin/rmmod pciehp
> # /sbin/modprobe shpchp
> # ls -lt /sys/bus/pci/slots
> total 0
> /var/log/messages:-
> Feb  3 18:21:05 localhost kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> 
> # /sbin/rmmod shpchp
> # 
> 
> 
> [root@localhost linux-2.6.25.x86_64]# /sbin/rmmod shpchp
> [root@localhost linux-2.6.25.x86_64]# 
>  
>  
> 
> Thanks,
> Krishna
>  
> _________________________________________________________________
> Windows Live™ Hotmail®…more than just e-mail. 
> http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t2_hm_justgotbetter_howitworks_012009--
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


