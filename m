Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZBXEQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZBXEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZBXEQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:16:19 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:61073 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZBXEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:16:18 -0500
Date: Tue, 24 Feb 2009 04:16:20 +0000
From: Eric Buddington <ebuddington@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: BUG in 2.6.28.7, possibly yenta-related
Message-id: <20090224041620.GA20246@pool-96-236-122-218.spfdma.east.verizon.net>
Reply-to: ebuddington@wesleyan.edu
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
Organization: ECS Labs
X-Eric-conspiracy: there is no conspiracy
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux (none) 2.6.28.7 #1 Mon Feb 23 12:00:54 EST 2009 i686 unknown
On a PIII Armada M700 laptop

BUG occurred while running udevtrigger, which causes udevd to modprobe
a bunch.  Here's dmesg, showing the first two BUGs (I assume only the
first is really useful):

...agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0x50000000
piix4_smbus 0000:00:07.3: SMBus Host Controller at 0x4000, revision 0
maestro_radio 0000:00:08.0: found PCI INT A -> IRQ 11
maestro_radio 0000:00:08.0: sharing IRQ 11 with 0000:00:09.0
maestro_radio 0000:00:08.0: sharing IRQ 11 with 0000:00:09.1
Error: Driver 'pcspkr' is already registered, aborting...
maestro_radio: probe of 0000:00:08.0 failed with error -5
yenta_cardbus 0000:00:04.1: CardBus bridge found [0e11:b113]
yenta_cardbus 0000:00:04.1: Using CSCINT to route CSC interrupts to PCI
yenta_cardbus 0000:00:04.1: Routing CardBus interrupts to PCI
yenta_cardbus 0000:00:04.1: TI: mfunc 0x00000000, devctl 0x64
BUG: unable to handle kernel paging request at 40646461
IP: [<c0165026>] kmem_cache_alloc+0x38/0x91
*pde = 00000000 
Oops: 0000 [#1] 
last sysfs file: /sys/devices/virtual/tty/ptyd9/uevent
Modules linked in: rtc_cmos radio_maestro eepro100 i2c_piix4 rtc_core rtc_lib pc
spkr intel_agp yenta_socket(+) rsrc_nonstatic videodev v4l1_compat agpgart uhci_
hcd pcmcia_core i2c_core serio_raw shpchp e100 pci_hotplug

hcd pcmcia_core i2c_core serio_raw shpchp e100 pci_hotplug

Pid: 6, comm: khelper Not tainted (2.6.28.7 #1) Armada    M700                  
           
EIP: 0060:[<c0165026>] EFLAGS: 00010002 CPU: 0
EIP is at kmem_cache_alloc+0x38/0x91
EAX: 00000000 EBX: 00000286 ECX: c0108243 EDX: 40646461
ESI: 000000d0 EDI: c06f9eb4 EBP: 00000200 ESP: cf824e98
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process khelper (pid: 6, ti=cf824000 task=cf81d1d0 task.ti=cf824000)
Stack:
 c82371e0 cf81d55c c823756c cf81d1d0 c0108243 c82371e0 00000000 c82371e0
 c9efa000 00000000 cf81d1d0 c011d504 fffffff4 7fffffff 00000000 cf824f48
 00000000 00804111 00000000 00000001 cf824f48 00000000 00000000 00804111
Call Trace:
 [<c0108243>] arch_dup_task_struct+0x30/0x81
 [<c011d504>] copy_process+0xa4/0xdec
 [<c011e307>] do_fork+0xbb/0x1f8
 [<c01024bd>] kernel_thread+0x7d/0x85
 [<c0129c4b>] ____call_usermodehelper+0x0/0xed
 [<c0129c4b>] ____call_usermodehelper+0x0/0xed
 [<c0104508>] kernel_thread_helper+0x0/0x10
 [<c0129c00>] __call_usermodehelper+0x0/0x4b
 [<c0129c30>] __call_usermodehelper+0x30/0x4b
 [<c012a0a8>] run_workqueue+0x74/0xec
 [<c012a3af>] worker_thread+0x0/0xb8
 [<c012a45c>] worker_thread+0xad/0xb8
 [<c012cbc5>] autoremove_wake_function+0x0/0x2d
 [<c012a3af>] worker_thread+0x0/0xb8
 [<c012c80f>] kthread+0x36/0x5a
 [<c012c7d9>] kthread+0x0/0x5a
 [<c010450f>] kernel_thread_helper+0x7/0x10
Code: 58 90 8d b4 26 00 00 00 00 89 c3 fa 90 8d b4 26 00 00 00 00 90 8b 97 80 00
 00 00 8b af 90 00 00 00 85 d2 74 11 8b 87 8c 00 00 00 <8b> 04 82 89 87 80 00 00
 00 eb 18 8d 87 80 00 00 00 89 f2 50 89 
EIP: [<c0165026>] kmem_cache_alloc+0x38/0x91 SS:ESP 0068:cf824e98
---[ end trace 26c2f9cbe4289a12 ]---
BUG: unable to handle kernel paging request at 40646461
IP: [<c01658ba>] __kmalloc_track_caller+0x6f/0xcb
*pde = 00000000 
Oops: 0000 [#2] 
last sysfs file: /sys/devices/virtual/tty/ptyd9/uevent
Modules linked in: snd_rawmidi(+) rtc_cmos radio_maestro eepro100 i2c_piix4 rtc_
core rtc_lib pcspkr intel_agp yenta_socket(+) rsrc_nonstatic videodev v4l1_compa
t agpgart uhci_hcd pcmcia_core i2c_core serio_raw shpchp e100 pci_hotplug

Pid: 6735, comm: modprobe Tainted: G      D    (2.6.28.7 #1) Armada    M700     
                        
EIP: 0060:[<c01658ba>] EFLAGS: 00010002 CPU: 0
EIP is at __kmalloc_track_caller+0x6f/0xcb
EAX: 00000000 EBX: c06f9eb4 ECX: 000000d0 EDX: 40646461
ESI: 000000d0 EDI: 00000282 EBP: c029f84f ESP: c9586e3c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 6735, ti=c9586000 task=cf81f570 task.ti=c9586000)
Stack:
 00000200 cf8a1c00 00000080 000000d0 c06f9aa8 c04036f4 00000000 00000018
 00000000 c989b000 d0853848 c029f84f ffffffff 00000000 c8249e80 c05f47bf
 cf805398 cf808c80 c069f0e4 c01384dd d0853800 d0853848 00000000 d0853800
Call Trace:
 [<c04036f4>] __alloc_skb+0x49/0xf6
 [<c029f84f>] kobject_uevent_env+0x1e7/0x2f2
 [<c01384dd>] module_add_modinfo_attrs+0x61/0x7c
 [<c013854c>] mod_sysfs_setup+0x54/0x77
 [<c01399a4>] load_module+0x1059/0x140f
 [<c015069e>] vma_prio_tree_insert+0x17/0x7d
 [<c0139d99>] sys_init_module+0x3f/0x176
 [<c0103856>] syscall_call+0x7/0xb
 [<c04b0000>] mesh_mgmt_ies_add+0x8d/0x174
Code: b4 26 00 00 00 00 89 c7 fa 90 8d b4 26 00 00 00 00 90 8b 83 90 00 00 00 89
 04 24 8b 93 80 00 00 00 85 d2 74 11 8b 83 8c 00 00 00 <8b> 04 82 89 83 80 00 00
 00 eb 18 8d 83 80 00 00 00 83 c9 ff 50 
EIP: [<c01658ba>] __kmalloc_track_caller+0x6f/0xcb SS:ESP 0068:c9586e3c
---[ end trace 26c2f9cbe4289a12 ]---
BUG: unable to handle kernel paging request at 40646461
...
