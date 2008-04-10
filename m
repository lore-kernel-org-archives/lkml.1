Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYDJKZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYDJKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYDJKZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:25:14 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:37046 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYDJKZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:25:12 -0400
Message-ID: <47FDEAFA.10407@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2008 15:54:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next: Tree for April 10 - kernel panic while loading
 ata driver on powermac
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
loading the ATA driver.

[    3.704000] Faulting instruction address: 0xc0000000000222a8
[    3.704000] Oops: Kernel access of bad area, sig: 11 [#1]
[    3.704000] SMP NR_CPUS=32 NUMA PowerMac
[    3.704000] Modules linked in:
[    3.704000] NIP: c0000000000222a8 LR: c00000000021cd10 CTR: 0000000000000100
[    3.704000] REGS: c0000002760db070 TRAP: 0300   Not tainted  (2.6.25-rc8-next-20080410-autokern1)
[    3.704000] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 44000042  XER: 20000000
[    3.704000] DAR: a0001000822fa000, DSISR: 0000000040000000
[    3.704000] TASK = c0000002760d7100[1] 'swapper' THREAD: c0000002760d8000 CPU: 0
[    3.704000] GPR00: 0000000000000100 c0000002760db2f0 c000000000498310 a0001000822fa000 
[    3.704000] GPR04: c000000274806a00 0000000000000100 0000000000000201 c00000000000fed4 
[    3.704000] GPR08: c0000002760daf20 c0000000003ee0d8 c0000000004f1428 0000000000000000 
[    3.704000] GPR12: 0000000000000000 c0000000003fa700 0000000000000000 0000000000000000 
[    3.704000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
[    3.704000] GPR20: 0000000000000001 0000000000000027 0000000000000027 0000000000000000 
[    3.704000] GPR24: c0000000004f1400 0000000000000000 0000000000000201 c0000000004f1490 
[    3.704000] GPR28: a0001000822fa000 0000000000000200 c00000000044cf50 c000000274806a00 
[    3.704000] NIP [c0000000000222a8] ._insw_ns+0x10/0x30
[    3.704000] LR [c00000000021cd10] .ata_input_data+0x1f4/0x264
[    3.704000] Call Trace:
[    3.704000] [c0000002760db2f0] [c0000002760d7100] 0xc0000002760d7100 (unreliable)
[    3.704000] [c0000002760db3b0] [c00000000021fc34] .try_to_identify+0x298/0x690
[    3.704000] [c0000002760db470] [c000000000220168] .do_probe+0x13c/0x2f0
[    3.704000] [c0000002760db510] [c00000000022059c] .ide_probe_port+0x280/0x670
[    3.704000] [c0000002760db5e0] [c000000000220d84] .ide_device_add_all+0x2f8/0x670
[    3.704000] [c0000002760db690] [c000000000221160] .ide_device_add+0x64/0x74
[    3.704000] [c0000002760db720] [c0000000002f7e14] 0xc0000000002f7e14
[    3.704000] [c0000002760db810] [c0000000002f8028] 0xc0000000002f8028
[    3.704000] [c0000002760db930] [c00000000019241c] .pci_device_probe+0x10c/0x184
[    3.704000] [c0000002760db9e0] [c0000000002068ac] .driver_probe_device+0x120/0x1e4
[    3.704000] [c0000002760dba70] [c0000000002069d0] .__driver_attach+0x60/0xa4
[    3.704000] [c0000002760dbb00] [c0000000002050e8] .bus_for_each_dev+0x7c/0xcc
[    3.704000] [c0000002760dbbb0] [c000000000206388] .driver_attach+0x28/0x40
[    3.704000] [c0000002760dbc30] [c000000000206154] .bus_add_driver+0xd4/0x274
[    3.704000] [c0000002760dbcd0] [c000000000206f04] .driver_register+0x90/0x14c
[    3.704000] [c0000002760dbd70] [c000000000191c80] .__pci_register_driver+0x68/0xc8
[    3.704000] [c0000002760dbe10] [c0000000003ccfb8] .pmac_ide_probe+0x48/0x94
[    3.704000] [c0000002760dbea0] [c0000000003a3bf4] .kernel_init+0x1e4/0x3a4
[    3.704000] [c0000002760dbf90] [c000000000022648] .kernel_thread+0x4c/0x68
[    3.704000] Instruction dump:
[    3.704000] 88030000 7c0006ac 98040000 38840001 4200fff0 0c000000 4c00012c 4e800020 
[    3.704000] 7ca02b79 7c0903a6 4c810020 7c0004ac <a0030000> 7c0006ac b0040000 38840002 
[    3.704000] ---[ end trace 0c3e1cc71183fc17 ]---
[    3.704000] Kernel panic - not syncing: Attempted to kill init!
[    3.704000] Call Trace:
[    3.704000] [c0000002760dac20] [c000000000010474] .show_stack+0x74/0x1ac (unreliable)
[    3.704000] [c0000002760dacd0] [c000000000051d38] .panic+0x80/0x194
[    3.704000] [c0000002760dae20] [c000000000056e60] .do_exit+0x98/0x74c
[    3.704000] [c0000002760daee0] [c000000000020680] .die+0x1c8/0x1cc
[    3.704000] [c0000002760daf80] [c000000000027a50] .bad_page_fault+0xb8/0xd4
[    3.704000] [c0000002760db000] [c000000000004f98] handle_page_fault+0x3c/0x5c
[    3.704000] --- Exception: 300 at ._insw_ns+0x10/0x30
[    3.704000]     LR = .ata_input_data+0x1f4/0x264
[    3.704000] [c0000002760db2f0] [c0000002760d7100] 0xc0000002760d7100 (unreliable)
[    3.704000] [c0000002760db3b0] [c00000000021fc34] .try_to_identify+0x298/0x690
[    3.704000] [c0000002760db470] [c000000000220168] .do_probe+0x13c/0x2f0
[    3.704000] [c0000002760db510] [c00000000022059c] .ide_probe_port+0x280/0x670
[    3.704000] [c0000002760db5e0] [c000000000220d84] .ide_device_add_all+0x2f8/0x670
[    3.704000] [c0000002760db690] [c000000000221160] .ide_device_add+0x64/0x74
[    3.704000] [c0000002760db720] [c0000000002f7e14] 0xc0000000002f7e14
[    3.704000] [c0000002760db810] [c0000000002f8028] 0xc0000000002f8028
[    3.704000] [c0000002760db930] [c00000000019241c] .pci_device_probe+0x10c/0x184
[    3.704000] [c0000002760db9e0] [c0000000002068ac] .driver_probe_device+0x120/0x1e4
[    3.704000] [c0000002760dba70] [c0000000002069d0] .__driver_attach+0x60/0xa4
[    3.704000] [c0000002760dbb00] [c0000000002050e8] .bus_for_each_dev+0x7c/0xcc
[    3.704000] [c0000002760dbbb0] [c000000000206388] .driver_attach+0x28/0x40
[    3.704000] [c0000002760dbc30] [c000000000206154] .bus_add_driver+0xd4/0x274
[    3.704000] [c0000002760dbcd0] [c000000000206f04] .driver_register+0x90/0x14c
[    3.704000] [c0000002760dbd70] [c000000000191c80] .__pci_register_driver+0x68/0xc8
[    3.704000] [c0000002760dbe10] [c0000000003ccfb8] .pmac_ide_probe+0x48/0x94
[    3.704000] [c0000002760dbea0] [c0000000003a3bf4] .kernel_init+0x1e4/0x3a4
[    3.704000] [c0000002760dbf90] [c000000000022648] .kernel_thread+0x4c/0x68


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
