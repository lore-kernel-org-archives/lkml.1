Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbXEXOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbXEXOxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXEXOxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:53:34 -0400
Received: from palrel10.hp.com ([156.153.255.245]:49314 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXEXOxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:53:33 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 10:53:33 EDT
Date: Thu, 24 May 2007 09:43:05 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com
Cc: chase.maupin@hp.com, akpm@linux-foundation.org
Subject: msi_free_irqs
Message-ID: <20070524144305.GA10024@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm hitting the following Oops on 2.6.22-rc2 when unloading the cciss driver.

Completed flushing cache on controller 2
BUG: unable to handle kernel paging request at virtual address f889a00c
 printing eip:
c01e744f
*pdpt = 0000000000003001
*pde = 0000000037e09067
*pte = 0000000000000000
Oops: 0002 [#1]
SMP 
Modules linked in: ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc loop dm_multipath button battery asus_acpi ac uhci_hcd ehci_hcd rng_core tg3 floppy sg dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod ata_piix libata cciss mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod
CPU:    2
EIP:    0060:[<c01e744f>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc1plain-gd3a36fb8-dirty #2)
EIP is at msi_free_irqs+0x81/0xbe
eax: f889a000   ebx: f7662ac0   ecx: f7fff280   edx: c18bdeb8
esi: f7c4b800   edi: f7c4bc48   ebp: 00000002   esp: f5a53e98
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 5283, ti=f5a53000 task=f7372550 task.ti=f5a53000)
Stack: 00000004 f88bb094 f76ecbd8 f88b2d1c f88b4cb8 00000002 00000000 00000000 
       00000000 00000000 f88bb094 c03100e1 00000001 f7c4b800 00000000 f7c4b800 
       f88bb094 f7c4b848 f88bb094 c01e30ab c01e3093 c01e3093 f7c4b848 c024ab3a 
Call Trace:
 [<f88b2d1c>] cciss_remove_one+0x145/0x229 [cciss]
 [<c03100e1>] mutex_lock+0x19/0x29
 [<c01e30ab>] pci_device_remove+0x18/0x39
 [<c01e3093>] pci_device_remove+0x0/0x39
 [<c01e3093>] pci_device_remove+0x0/0x39
 [<c024ab3a>] __device_release_driver+0x72/0x91
 [<c024ac4b>] driver_detach+0xa6/0xe7
 [<c024a2fd>] bus_remove_driver+0x29/0x47
 [<c01e32da>] pci_unregister_driver+0xd/0x17
 [<f88b330f>] cciss_cleanup+0xf/0x51 [cciss]
 [<c0137dab>] sys_delete_module+0x115/0x13a
 [<c01546f4>] remove_vma_list+0x40/0x4a
 [<c01030a2>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 00 39 c2 74 5d 0f b6 03 24 1f 3c 11 75 24 8d 86 54 04 00 00 39 43 0c 75 08 8b 43 14 e8 1c e1 f2 ff 0f b7 43 02 c1 e0 04 03 43 14 <c7> 40 0c 01 00 00 00 8d 4b 0c 8b 43 0c 8b 51 04 89 50 04 89 02 
EIP: [<c01e744f>] msi_free_irqs+0x81/0xbe SS:ESP 0068:f5a53e98
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
 [<c011ab8b>] __might_sleep+0xa7/0xad
 [<c01302cc>] down_read+0x14/0x29
 [<c013bca7>] acct_collect+0x35/0x12e
 [<c011f903>] do_exit+0x198/0x37e
 [<c010439b>] die+0x1c4/0x1cc
 [<c0312454>] do_page_fault+0x5b9/0x69c
 [<c0156fed>] unmap_vm_area+0xad/0xd4
 [<c01108c3>] flush_tlb_all+0x1b/0x1f
 [<c0311e9b>] do_page_fault+0x0/0x69c
 [<c0310ba2>] error_code+0x72/0x78
 [<c01e744f>] msi_free_irqs+0x81/0xbe
 [<f88b2d1c>] cciss_remove_one+0x145/0x229 [cciss]
 [<c03100e1>] mutex_lock+0x19/0x29
 [<c01e30ab>] pci_device_remove+0x18/0x39
 [<c01e3093>] pci_device_remove+0x0/0x39
 [<c01e3093>] pci_device_remove+0x0/0x39
 [<c024ab3a>] __device_release_driver+0x72/0x91
 [<c024ac4b>] driver_detach+0xa6/0xe7
 [<c024a2fd>] bus_remove_driver+0x29/0x47
 [<c01e32da>] pci_unregister_driver+0xd/0x17
 [<f88b330f>] cciss_cleanup+0xf/0x51 [cciss]
 [<c0137dab>] sys_delete_module+0x115/0x13a
 [<c01546f4>] remove_vma_list+0x40/0x4a
 [<c01030a2>] sysenter_past_esp+0x5f/0x85
 =======================

It looks like its going south in drivers/pci/msi.c in msi_free_irqs. When did this
change appear? I'm Googling and can't find when this was actually added, just some
activity for Sparc64.

Any help is appreciated.

Thanks,
mikem

