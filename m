Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZBDCcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZBDCcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZBDCcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:32:45 -0500
Received: from bay0-omc2-s36.bay0.hotmail.com ([65.54.246.172]:11880 "EHLO
	bay0-omc2-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbZBDCco convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:32:44 -0500
Message-ID: <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl>
X-Originating-IP: [171.70.247.31]
From: Krishna Kothapalli <krishna_sunitha@hotmail.com>
To: <kaneshige.kenji@jp.fujitsu.com>
CC: <ebiederm@xmission.com>, <linux-pci@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <achiang@hp.com>, <djwong@us.ibm.com>,
       <xyzzy@speakeasy.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Q: state of pci express hotplug
Date: Tue, 3 Feb 2009 21:32:43 -0500
Importance: Normal
In-Reply-To: <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl>
References: <m1fxj06js8.fsf@fess.ebiederm.org>
 <4986581F.7060704@jp.fujitsu.com>
   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
   <49879508.4090801@jp.fujitsu.com>  
 <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Feb 2009 02:32:43.0279 (UTC) FILETIME=[DB7029F0:01C98670]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Kenji Kaneshige wrote:
> (1) Build all your hotplug drivers as kernel modules.
> (2) Modprobe hotplug drivers one by one, and check which drivers add
> directories under /sys/bus/pci/slots. Before trying the next driver,
> please rmmod the previous driver, because there are hotplug slots
> that can be managed by the several drivers. Note that you don't need
> to try fakephp this time.
>
 
Thanks much for the exact steps. Here are the results (with 2.6.25 and 2.6.28.3 ). Pls let me know if you want me to run them on a different branch or other steps.
 
with 2.6.25-14
-------------------

Built the kernel with these options:-
 
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
 
# uname -a
Linux localhost.localdomain 2.6.25-14.fc9.x86_64.kkhp #4 SMP Tue Feb 3 11:12:07 PST 2009 x86_64 x86_64 x86_64 GNU/Linux
 
 
[root@localhost linux-2.6.25.x86_64]#ls -lt /sys/bus/pci/slots
total 0
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe acpiphp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 11:32 2
[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod acpiphp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe pciehp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 11:33 0009_0096
[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod pciehp
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe shpchp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0

with 2.6.28.3
---------------

build with options
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m


# uname -a
Linux localhost.localdomain 2.6.28.3 #1 SMP Tue Feb 3 16:51:23 PST 2009 x86_64 x86_64 x86_64 GNU/Linux


#ls -lt /sys/bus/pci/slots
total 0
# /sbin/modprobe acpiphp
# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 18:15 2

## /var/log/messages contains following messages
Feb  3 18:15:06 localhost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Feb  3 18:15:06 localhost kernel: acpiphp: Slot [2] registered

# /sbin/rmmod acpiphp
# ls -lt /sys/bus/pci/slots
total 0
# /sbin/modprobe pciehp
# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 18:19 96

/var/log/messages:-
Feb  3 18:19:35 localhost kernel: pciehp 0000:00:09.0:pcie02: Link Active Reporting supported
Feb  3 18:19:36 localhost kernel: pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
Feb  3 18:19:36 localhost kernel: pciehp 0000:00:09.0:pcie02: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: Command not completed in 1000 msec
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: Registering domain:bus:dev=0000:09:00 hp_slot=0 sun=60 slot_device_offset=0
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_power_status: physical_slot = 96
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: hpc_get_power_status: SLOTCTRL a8 value read 7bf
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_attention_status: physical_slot = 96
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: hpc_get_attention_status: SLOTCTRL a8, value read 7bf
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_latch_status: physical_slot = 96
Feb  3 18:19:37 localhost kernel: pciehp 0000:00:09.0:pcie02: get_adapter_status: physical_slot = 96
Feb  3 18:19:37 localhost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4

# /sbin/rmmod pciehp
# /sbin/modprobe shpchp
# ls -lt /sys/bus/pci/slots
total 0
/var/log/messages:-
Feb  3 18:21:05 localhost kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4

# /sbin/rmmod shpchp
# 


[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod shpchp
[root@localhost linux-2.6.25.x86_64]# 
 
 

Thanks,
Krishna
 
_________________________________________________________________
Windows Live™ Hotmail®…more than just e-mail. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t2_hm_justgotbetter_howitworks_012009