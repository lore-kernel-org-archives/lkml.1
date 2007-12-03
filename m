Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXLCVg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXLCVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXLCVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:36:10 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48832 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752540AbXLCVgH (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:36:07 -0500
Date: Tue, 4 Dec 2007 08:35:58 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: neilb@suse.de
Subject: Regression - 2.6.24-rc3 - umem nvram card driver oops
Message-ID: <20071203213558.GP115527101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

I just upgraded an ia64 (Altix, 16k page size) test box to 2.6.24-rc3
from 2.6.23 and I get it panicing on boot in the umem driver.

[   55.499300] v2.3 : Micro Memory(tm) PCI memory board block driver
[   55.519331] ACPI: Unable to derive IRQ for device 0006:00:01.0
[   55.528294] ACPI: PCI Interrupt 0006:00:01.0[A]: no GSI
[   55.529214] umem 0006:00:01.0: Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))
[   55.530968] umem 0006:00:01.0: CSR 0xc00000080da00000 -> 0xc00000080da00000 (0x100)
[   55.552881] umem 0006:00:01.0: Size 1048576 KB, Battery 1 Disabled (FAILURE), Battery 2 Disabled (FAILURE)
[   55.559064] umem 0006:00:01.0: Window size 16777216 bytes, IRQ 64
[   55.560131] umem 0006:00:01.0: memory already initialized
[   55.561501]  umema:<1>Unable to handle kernel NULL pointer dereference (address 000000000000002a)
[   55.580231] swapper[0]: Oops 8813272891392 [1]
[   55.581096] Modules linked in: umem qla2xxx
[   55.582022]
[   55.582023] Pid: 0, CPU 0, comm:              swapper
[   55.608663] psr : 0000101008026018 ifs : 8000000000000b9c ip  : [<a0000002046e1ce0>]    Not tainted
[   55.610226] ip is at process_page+0x1c0/0x760 [umem]
[   55.611107] unat: 0000000000000000 pfs : 0000000000000b9c rsc : 0000000000000003
[   55.660528] rnat: e0000030023e5e40 bsps: e000003002563000 pr  : a56911155aa696a5
[   55.661866] ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
[   55.663204] csd : 0000000000000000 ssd : 0000000000000000
[   55.712930] b0  : a0000002046e1b70 b6  : a0000002046e1b20 b7  : a00000010008d300
[   55.714267] f6  : 1003e0000060100000000 f7  : 1003e0000000000400000
[   55.715395] f8  : 1003e0000000000180400 f9  : 1003e0000000080000000
[   55.816292] f10 : 1003e0000000000000400 f11 : 1003e0000000000049919
[   55.817422] r1  : a0000002046ebe80 r2  : a0000002046f7640 r3  : 0000000000000040
[   55.818747] r8  : 0000000000000000 r9  : 0000000000000000 r10 : 0000000000000000
[   55.866550] r11 : 0000000000000003 r12 : a000000100bfbbb0 r13 : a000000100bf4000
[   55.867886] r14 : 000000000000002a r15 : 0000000000000000 r16 : 0000000000000003
[   55.894776] r17 : a0000002046e5630 r18 : 0000000000000000 r19 : 0000000000000003
[   55.896113] r20 : e00000398c980030 r21 : e000003988381f40 r22 : 0000000000000000
[   55.897450] r23 : 0000000000000001 r24 : 0000000000000001 r25 : e000003988381f28
[   55.927571] r26 : 0000000000000001 r27 : 0000000000000000 r28 : 0000000000040000
[   55.928734] r29 : 00000000cf0c01d0 r30 : e00000398c980038 r31 : 0000000000000000
[   55.930075]
[   55.930077] Call Trace:
[   56.031008]  [<a000000100015e00>] show_stack+0x80/0xa0
[   56.031010]                                 sp=a000000100bfb780 bsp=a000000100bf5238
[   56.033460]  [<a0000001000166f0>] show_regs+0x870/0x8a0
[   56.033462]                                 sp=a000000100bfb950 bsp=a000000100bf51d8
[   56.093627]  [<a00000010003e830>] die+0x210/0x3a0
[   56.093629]                                 sp=a000000100bfb950 bsp=a000000100bf5190
[   56.213913]  [<a00000010006eca0>] ia64_do_page_fault+0x9c0/0xb00
[   56.213915]                                 sp=a000000100bfb950 bsp=a000000100bf5138
[   56.231427]  [<a00000010000b640>] ia64_leave_kernel+0x0/0x280
[   56.231429]                                 sp=a000000100bfb9e0 bsp=a000000100bf5138
[   56.278001]  [<a0000002046e1ce0>] process_page+0x1c0/0x760 [umem]
[   56.278004]                                 sp=a000000100bfbbb0 bsp=a000000100bf5058
[   56.280476]  [<a0000001000dab30>] tasklet_action+0x270/0x360
[   56.280478]                                 sp=a000000100bfbbb0 bsp=a000000100bf5018
[   56.370160]  [<a0000001000d9a60>] __do_softirq+0x200/0x240
[   56.370162]                                 sp=a000000100bfbbb0 bsp=a000000100bf4f80
[   56.476607]  [<a0000001000d9b10>] do_softirq+0x70/0xc0
[   56.476609]                                 sp=a000000100bfbbb0 bsp=a000000100bf4f20
[   56.478889]  [<a0000001000d9be0>] irq_exit+0x80/0xc0
[   56.478891]                                 sp=a000000100bfbbb0 bsp=a000000100bf4f08
[   56.529780]  [<a000000100012b90>] ia64_handle_irq+0x1b0/0x3c0
[   56.529782]                                 sp=a000000100bfbbb0 bsp=a000000100bf4e98
[   56.636341]  [<a00000010000b640>] ia64_leave_kernel+0x0/0x280
[   56.636343]                                 sp=a000000100bfbbb0 bsp=a000000100bf4e98
[   56.638823]  [<a000000100017140>] default_idle+0x1a0/0x1c0
[   56.638825]                                 sp=a000000100bfbd80 bsp=a000000100bf4e30
[   56.689924]  [<a000000100015a70>] cpu_idle+0x210/0x440
[   56.689926]                                 sp=a000000100bfbe20 bsp=a000000100bf4db8
[   56.796362]  [<a000000100928850>] rest_init+0x110/0x140
[   56.796364]                                 sp=a000000100bfbe20 bsp=a000000100bf4da0
[   56.798668]  [<a000000100b49d20>] start_kernel+0x7c0/0x880
[   56.798670]                                 sp=a000000100bfbe20 bsp=a000000100bf4d28
[   56.850239]  [<a000000100930670>] __kprobes_text_end+0x6d0/0x6f0
[   56.850241]                                 sp=a000000100bfbe30 bsp=a000000100bf4c40

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
