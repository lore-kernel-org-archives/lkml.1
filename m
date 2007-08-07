Return-Path: <linux-kernel-owner+w=401wt.eu-S934025AbXHGDWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbXHGDWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 23:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbXHGDWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 23:22:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:23716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbXHGDWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 23:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,227,1183359600"; 
   d="scan'208";a="114430519"
Subject: unable to handle kernel NULL pointer dereference in
	qla2x00_read_nvram_data
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 07 Aug 2007 11:21:52 +0800
Message-Id: <1186456912.4688.209.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Did someone see the same issue? My machine has a qla fiber card.

This error is triggered because parameter buf of qla2x00_read_nvram_data
is 0.

--yanmin

**********************Console log************************


scsi 0:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0
ANSI: 2
 target0:0:8: asynchronous
 target0:0:8: Beginning Domain Validation
 target0:0:8: Ending Domain Validation
ACPI: PCI Interrupt 0000:04:02.1[B] -> GSI 17 (level, low) -> IRQ 18
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz,
512 SCBs
Adaptec aacraid driver 1.1-5[2449]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 16 (level, low) -> IRQ 16
qla2xxx 0000:05:01.0: Found an ISP2312, irq 16, iobase 0xf8862000
qla2xxx 0000:05:01.0: Configuring PCI space...
qla2xxx 0000:05:01.0: Configure NVRAM parameters...
BUG: unable to handle kernel NULL pointer dereference at virtual address
00000000
 printing eip:
c04347db
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in:
CPU:    5
EIP:    0060:[<c04347db>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23-rc2 #1)
EIP is at qla2x00_read_nvram_data+0x25/0x56
eax: 00005349   ebx: 00000000   ecx: 042d8138   edx: 0000007d
esi: f7d9a34c   edi: 00000001   ebp: 00000001   esp: f7e85d98
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=f7e84000 task=f7e82000 task.ti=f7e84000)
Stack: 00000000 c04347b6 00000000 f7d9a34c 00000000 c0425737 00000100
00000008 
       f7dc0000 00000000 00000000 00000024 f7d9a34c f7d9a34c f7d9a34c
c39cc000 
       c398b13c f7d9a34c f7d9a34c f8862000 c0423db8 c06cbd17 c06ca4b9
c398b13c    
Call Trace:

 [<c04347b6>] qla2x00_read_nvram_data+0x0/0x56

 [<c0425737>] qla2x00_nvram_config+0x7e/0x765

 [<c0423db8>] qla2x00_initialize_adapter+0x113/0x226

 [<c04208e1>] qla2x00_probe_one+0x8ea/0xcb9

 [<c01aa54b>] sysfs_ilookup_test+0x0/0xd

 [<c0181acf>] ifind+0x8c/0x93

 [<c01aa54b>] sysfs_ilookup_test+0x0/0xd

 [<c01aba78>] sysfs_create_link+0xf1/0x149

 [<c02d7252>] pci_match_device+0x84/0xa4

 [<c02d72be>] pci_device_probe+0x36/0x57

 [<c034fc17>] driver_probe_device+0xe1/0x15f

 [<c034fd3b>] __driver_attach+0x0/0xab

 [<c034fdae>] __driver_attach+0x73/0xab

 [<c034f174>] bus_for_each_dev+0x37/0x59

 [<c034fa6f>] driver_attach+0x16/0x18

 [<c034fd3b>] __driver_attach+0x0/0xab

 [<c034f45e>] bus_add_driver+0x6d/0x170

 [<c02d73fa>] __pci_register_driver+0x53/0x7f

 [<c07df181>] qla2x00_module_init+0xd4/0xfe

 [<c07be477>] kernel_init+0x14d/0x2af

 [<c05a39ad>] _spin_unlock_irq+0x5/0x7
 [<c0124469>] schedule_tail+0x37/0x91
 [<c0104d32>] 
