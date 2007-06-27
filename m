Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbXF0TQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbXF0TQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXF0TQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:16:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:25011 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXF0TQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:16:39 -0400
Date: Wed, 27 Jun 2007 21:16:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: corentincj@iksaif.net
cc: sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oops on rmmod asus_acpi
Message-ID: <Pine.LNX.4.64.0706272113120.11120@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



	modprobe asus_acpi
	rmmod asus_acpi

is all that is needed to trigger an Oops in 2.6.22-rc6 (x86).
If you need more info, please let me know, thanks.

Note that the machine is not ASUS at all (vmware).
(But suse_factory loads asus_acpi anyway -wtf?!)


Jun 27 21:11:33 su1 kernel: WARNING: at /ws/linux-2.6.22/lib/kref.c:33 kref_get()
Jun 27 21:11:33 su1 kernel:  [<c01c5e75>] kref_get+0x34/0x3f
Jun 27 21:11:33 su1 kernel:  [<c01c52ef>] kobject_get+0xf/0x13
Jun 27 21:11:33 su1 kernel:  [<c0228885>] get_driver+0xe/0x14
Jun 27 21:11:33 su1 kernel:  [<c0228896>] driver_remove_file+0xb/0x25
Jun 27 21:11:33 su1 kernel:  [<c0227efd>] bus_remove_driver+0x17/0x75
Jun 27 21:11:33 su1 kernel:  [<c6a9f018>] asus_acpi_exit+0x18/0x28 [asus_acpi]
Jun 27 21:11:33 su1 kernel:  [<c013cebc>] sys_delete_module+0x1a0/0x1c8
Jun 27 21:11:33 su1 kernel:  [<c01494bd>] audit_syscall_entry+0x10d/0x137
Jun 27 21:11:33 su1 kernel:  [<c0107c18>] do_syscall_trace+0x13d/0x181
Jun 27 21:11:33 su1 kernel:  [<c0104d40>] syscall_call+0x7/0xb
Jun 27 21:11:33 su1 kernel:  =======================
Jun 27 21:11:33 su1 kernel: WARNING: at /ws/linux-2.6.22/lib/kref.c:33 kref_get()
Jun 27 21:11:33 su1 kernel:  [<c01c5e75>] kref_get+0x34/0x3f
Jun 27 21:11:33 su1 kernel:  [<c01c52ef>] kobject_get+0xf/0x13
Jun 27 21:11:33 su1 kernel:  [<c0228885>] get_driver+0xe/0x14
Jun 27 21:11:33 su1 kernel:  [<c0228896>] driver_remove_file+0xb/0x25
Jun 27 21:11:33 su1 kernel:  [<c0227f09>] bus_remove_driver+0x23/0x75
Jun 27 21:11:33 su1 kernel:  [<c6a9f018>] asus_acpi_exit+0x18/0x28 [asus_acpi]
Jun 27 21:11:33 su1 kernel:  [<c013cebc>] sys_delete_module+0x1a0/0x1c8
Jun 27 21:11:33 su1 kernel:  [<c01494bd>] audit_syscall_entry+0x10d/0x137
Jun 27 21:11:33 su1 kernel:  [<c0107c18>] do_syscall_trace+0x13d/0x181
Jun 27 21:11:33 su1 kernel:  [<c0104d40>] syscall_call+0x7/0xb
Jun 27 21:11:33 su1 kernel:  =======================
Jun 27 21:11:33 su1 kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
Jun 27 21:11:33 su1 kernel:  printing eip:
Jun 27 21:11:33 su1 kernel: c02ab74b
Jun 27 21:11:33 su1 kernel: *pde = 00000000
Jun 27 21:11:33 su1 kernel: Oops: 0000 [#1]
Jun 27 21:11:33 su1 kernel: SMP 
Jun 27 21:11:33 su1 kernel: Modules linked in: asus_acpi ipv6 nfs lockd nfs_acl sunrpc dock button battery ac dm_crypt loop dm_mod xt_hashlimit ip6_tables xt_u32 xt_conntrack xt_connlimit nf_conntrack nfnetlink x_tables rtc_cmos rtc_core rtc_lib pcnet32 mii i2c_piix4 i2c_core mptctl generic piix ide_core shpchp pci_hotplug intel_agp agpgart sg parport_pc lp parport sd_mod edd xfs fan mptspi mptscsih mptbase scsi_transport_spi ata_piix libata scsi_mod thermal processor
Jun 27 21:11:33 su1 kernel: CPU:    0
Jun 27 21:11:33 su1 kernel: EIP:    0060:[<c02ab74b>]    Not tainted VLI
Jun 27 21:11:33 su1 kernel: EFLAGS: 00010246   (2.6.22-rc6+ccj #11)
Jun 27 21:11:33 su1 kernel: EIP is at klist_del+0x9/0x31
Jun 27 21:11:33 su1 kernel: eax: 00000000   ebx: 00000000   ecx: c02fdc20   edx: 00000001
Jun 27 21:11:33 su1 kernel: esi: 00000000   edi: c6aa262c   ebp: c139c000   esp: c139df30
Jun 27 21:11:33 su1 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jun 27 21:11:33 su1 kernel: Process rmmod (pid: 3004, ti=c139c000 task=c5da0030 task.ti=c139c000)
Jun 27 21:11:33 su1 kernel: Stack: c6aa262c 00000000 c0341100 c02ab7c3 c6aa25d0 c0227f36 c6aa2d80 00000000 
Jun 27 21:11:33 su1 kernel:        00000880 c6a9f018 c013cebc 73757361 7063615f c2cf0069 00000000 c01494bd 
Jun 27 21:11:33 su1 kernel:        bfb59010 00000081 40000003 c5da0030 bfb5b858 00000880 00000000 c139dfb8 
Jun 27 21:11:33 su1 kernel: Call Trace:
Jun 27 21:11:33 su1 kernel:  [<c02ab7c3>] klist_remove+0x8/0x13
Jun 27 21:11:33 su1 kernel:  [<c0227f36>] bus_remove_driver+0x50/0x75
Jun 27 21:11:33 su1 kernel:  [<c6a9f018>] asus_acpi_exit+0x18/0x28 [asus_acpi]
Jun 27 21:11:33 su1 kernel:  [<c013cebc>] sys_delete_module+0x1a0/0x1c8
Jun 27 21:11:33 su1 kernel:  [<c01494bd>] audit_syscall_entry+0x10d/0x137
Jun 27 21:11:33 su1 kernel:  [<c0107c18>] do_syscall_trace+0x13d/0x181
Jun 27 21:11:33 su1 kernel:  [<c0104d40>] syscall_call+0x7/0xb
Jun 27 21:11:33 su1 kernel:  =======================
Jun 27 21:11:33 su1 kernel: Code: ff 8b 04 24 8b 16 89 46 08 b0 01 86 02 85 ed 74 08 85 ff 74 04 89 f8 ff d5 8b 04 24 5a 5b 5e 5f 5d c3 57 89 c7 56 53 8b 18 89 d8 <8b> 73 10 e8 d3 22 00 00 89 f8 e8 6f ff ff ff 83 f8 01 19 c0 f7 
Jun 27 21:11:33 su1 kernel: EIP: [<c02ab74b>] klist_del+0x9/0x31 SS:ESP 0068:c139df30


	Jan
-- 
