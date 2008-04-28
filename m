Return-Path: <linux-kernel-owner+w=401wt.eu-S937416AbYD1UgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937416AbYD1UgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbYD1UgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:36:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53897 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765503AbYD1UgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:36:06 -0400
Subject: 2.6.25-git12 sysfs panic
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linuxppc-dev@ozlabs.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 13:36:10 -0700
Message-Id: <1209414970.23575.17.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Ran into this sysfs oops while booting 2.6.25-git12.
ipr issue ?

Thanks,
Badari

ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
ipr 0000:d0:01.0: Found IOA with IRQ: 119
ipr 0000:d0:01.0: Starting IOA initialization sequence.
ipr 0000:d0:01.0: Adapter firmware version: 020A005E
ipr 0000:d0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
sysfs: duplicate filename 'state' can not be created
------------[ cut here ]------------
Badness at fs/sysfs/dir.c:425
NIP: c00000000013b668 LR: c00000000013b664 CTR: 800000000013f270
REGS: c0000000700db240 TRAP: 0700   Not tainted  (2.6.25-git12)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 22002024  XER: 00000006
TASK = c0000000700d7980[1] 'swapper' THREAD: c0000000700d8000 CPU: 0
GPR00: c00000000013b664 c0000000700db4c0 c000000000792970 0000000000000038 
GPR04: 0000000000000001 0000000000000001 0000000000000000 0000000000000001 
GPR08: c0000000007bd60c c0000000006c2c58 0000000000003ac3 c0000000007bd608 
GPR12: 0000000000004000 c0000000007b3300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 d000080080080000 c0000000006b40d0 c00000006e07a708 
GPR20: c00000006e07a650 c00000006e07a000 c0000000703241a8 c000000070324000 
GPR24: c000000070324070 c000000070324000 c00000006e07a3b0 c00000006e07a170 
GPR28: 0000000000000000 c0000000700db5c0 c0000000007115c0 c00000006e07e370 
NIP [c00000000013b668] .sysfs_add_one+0x50/0xec
LR [c00000000013b664] .sysfs_add_one+0x4c/0xec
Call Trace:
[c0000000700db4c0] [c00000000013b664] .sysfs_add_one+0x4c/0xec (unreliable)
[c0000000700db550] [c00000000013ade4] .sysfs_add_file_mode+0x70/0xe0
[c0000000700db600] [c00000000038b408] .device_create_file+0x20/0x3c
[c0000000700db680] [c0000000003e2a50] .scsi_sysfs_add_host+0x54/0xc4
[c0000000700db710] [c0000000003d72b0] .scsi_add_host+0x1d4/0x264
[c0000000700db7b0] [c000000000537ef8] 0xc000000000537ef8
[c0000000700db920] [c00000000033b9a4] .pci_device_probe+0x100/0x170
[c0000000700db9e0] [c00000000038e67c] .driver_probe_device+0x118/0x1f8
[c0000000700dba70] [c00000000038e7c4] .__driver_attach+0x68/0xac
[c0000000700dbb00] [c00000000038db3c] .bus_for_each_dev+0x80/0xd0
[c0000000700dbbb0] [c00000000038e3c8] .driver_attach+0x28/0x40
[c0000000700dbc30] [c00000000038d058] .bus_add_driver+0xf4/0x2dc
[c0000000700dbce0] [c00000000038ea54] .driver_register+0x90/0x170
[c0000000700dbd80] [c00000000033bd4c] .__pci_register_driver+0x5c/0xcc
[c0000000700dbe10] [c0000000006675cc] .ipr_init+0x38/0x50
[c0000000700dbe90] [c000000000639414] .kernel_init+0x21c/0x3f8
[c0000000700dbf90] [c000000000023f84] .kernel_thread+0x4c/0x68
Instruction dump:
f821ff71 60000000 60000000 e8630000 e8840018 4bfffdc1 2fa30000 41be0020 
e89f0018 e87e8020 4bf1d2f5 60000000 <0fe00000> 3860ffef 48000078 e93d0000 
ipr: probe of 0000:d0:01.0 failed with error -17


