Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXCNDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXCNDw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 23:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXCNDw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 23:52:29 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:36483 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbXCNDw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 23:52:27 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Date: Tue, 13 Mar 2007 21:52:09 -0600
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703132152.10136.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, I'm seeing the following oops with 2.6.21-rc3-mm1 (and -mm2)
on the HP rx2600 and an Intel Tiger (both ia64 boxes).

I haven't investigated this other than to determine that it
does not occur with 2.6.21-rc3 or 2.6.20-rc3-mm1, and the
instruction at move_freepages+0x10 is a load of the value
pointed to by the third argument (end_page).


Linux version 2.6.21-rc3-mm1 (helgaas@tiger) (gcc version 4.0.3 (Debian 4.0.3-1)) #2 SMP Tue Mar 13 16:16:22 MST 2007
...
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030, FwRev=01032300h, Ports=1, MaxQ=255, IRQ=53
scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP04 PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
Unable to handle kernel paging request at virtual address a0007fffc7580000
swapper[1]: Oops 8813272891392 [1]
Modules linked in:

Pid: 1, CPU 1, comm:              swapper
psr : 00001010085a2010 ifs : 800000000000040b ip  : [<a0000001000fe5d0>]    Not 
tainted
ip is at move_freepages+0x10/0x340
unat: 0000000000000000 pfs : 000000000000030a rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 000000000000a581
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a74433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000fea10 b6  : a0000001005ad980 b7  : a00000010000bb20
f6  : 1003e0000000000000000 f7  : 1003ed37a6f4de9bd37a7
f8  : 1003e0000000000000000 f9  : 1003e0000000194a0cb8b
f10 : 1003e70658ddf530a940d f11 : 1003e0000000000000000
r1  : a000000100dfe280 r2  : 0000000000000000 r3  : 0000000000000000
r8  : 0000000000000000 r9  : 0000000000004000 r10 : ffffffffffff0000
r11 : 0000000000020000 r12 : e00000406004fc10 r13 : e000004060048000
r14 : 0000000000010000 r15 : 000000000001c000 r16 : 0000000000040000
r17 : 0000000000000400 r18 : a0007fffc7200000 r19 : 0000000000004000
r20 : ffffffffffff4000 r21 : 00002fffffff4000 r22 : ffffd00000000000
r23 : 000000005fff4000 r24 : 00002fffa0000000 r25 : 0000000063180000
r26 : 000000000318c000 r27 : 0000000000c5c000 r28 : 00000000000c4000
r29 : 0000000000080000 r30 : 000000000003fc00 r31 : 00000000000e0000

Call Trace:
 [<a000000100014840>] show_stack+0x40/0xa0
                                sp=e00000406004f7c0 bsp=e0000040600496f8
 [<a000000100015120>] show_regs+0x880/0x8a0
                                sp=e00000406004f990 bsp=e0000040600496a0
 [<a0000001000387c0>] die+0x1c0/0x2c0
                                sp=e00000406004f990 bsp=e000004060049658
 [<a00000010005e1e0>] ia64_do_page_fault+0x820/0x9c0
                                sp=e00000406004f9b0 bsp=e000004060049608
 [<a00000010000c320>] ia64_leave_kernel+0x0/0x270
                                sp=e00000406004fa40 bsp=e000004060049608
 [<a0000001000fe5d0>] move_freepages+0x10/0x340
                                sp=e00000406004fc10 bsp=e0000040600495a8
 [<a0000001000fea10>] move_freepages_block+0x110/0x140
                                sp=e00000406004fc10 bsp=e000004060049578
 [<a0000001000fef20>] __rmqueue+0x4e0/0x7e0
                                sp=e00000406004fc10 bsp=e000004060049518
 [<a0000001000ff270>] rmqueue_bulk+0x50/0x120
                                sp=e00000406004fc10 bsp=e0000040600494d0
 [<a0000001000ff7a0>] get_page_from_freelist+0x460/0xd40
                                sp=e00000406004fc10 bsp=e000004060049420
 [<a0000001001016e0>] __alloc_pages+0xa0/0x580
                                sp=e00000406004fc10 bsp=e0000040600493a8
 [<a000000100147df0>] kmem_getpages+0x150/0x3a0
                                sp=e00000406004fc20 bsp=e000004060049370
 [<a00000010014b200>] cache_grow+0x1e0/0x640
                                sp=e00000406004fc30 bsp=e000004060049308
 [<a00000010014baf0>] cache_alloc_refill+0x490/0x580
                                sp=e00000406004fc30 bsp=e0000040600492a0
 [<a00000010014ca80>] kmem_cache_alloc+0x120/0x1e0
                                sp=e00000406004fc30 bsp=e000004060049270
 [<a0000001005af6f0>] sd_revalidate_disk+0x90/0x1c20
                                sp=e00000406004fc30 bsp=e0000040600491f0
 [<a0000001005b1d20>] sd_probe+0x6c0/0x7c0
                                sp=e00000406004fc70 bsp=e000004060049198
 [<a0000001004c3650>] driver_probe_device+0x230/0x360
                                sp=e00000406004fc80 bsp=e000004060049160
 [<a0000001004c37b0>] __device_attach+0x30/0x60
                                sp=e00000406004fc80 bsp=e000004060049138
 [<a0000001004c1480>] bus_for_each_drv+0x80/0x120
                                sp=e00000406004fc80 bsp=e000004060049100
 [<a0000001004c3f50>] device_attach+0x190/0x200
                                sp=e00000406004fca0 bsp=e0000040600490c8
 [<a0000001004c1660>] bus_attach_device+0x80/0x160
                                sp=e00000406004fca0 bsp=e000004060049090
 [<a0000001004be7e0>] device_add+0x940/0xf60
                                sp=e00000406004fca0 bsp=e000004060049028
 [<a00000010057daa0>] scsi_sysfs_add_sdev+0x60/0x520
                                sp=e00000406004fca0 bsp=e000004060048fd8
 [<a000000100578e20>] scsi_probe_and_add_lun+0x1000/0x1200
                                sp=e00000406004fca0 bsp=e000004060048f68
 [<a000000100579bf0>] __scsi_scan_target+0x150/0xae0
                                sp=e00000406004fcd0 bsp=e000004060048f10
 [<a00000010057a5e0>] scsi_scan_channel+0x60/0xe0
                                sp=e00000406004fd30 bsp=e000004060048ed0
 [<a00000010057a790>] scsi_scan_host_selected+0x130/0x200
                                sp=e00000406004fd30 bsp=e000004060048e88
 [<a00000010057a9d0>] do_scsi_scan_host+0x170/0x1a0
                                sp=e00000406004fd30 bsp=e000004060048e60
 [<a00000010057acd0>] scsi_scan_host+0x2d0/0x320
                                sp=e00000406004fd30 bsp=e000004060048e18
 [<a0000001005ca2c0>] mptspi_probe+0x680/0x6e0
                                sp=e00000406004fd30 bsp=e000004060048dc8
 [<a0000001003fdd10>] pci_device_probe+0x270/0x3a0
                                sp=e00000406004fd30 bsp=e000004060048d88
 [<a0000001004c3650>] driver_probe_device+0x230/0x360
                                sp=e00000406004fd80 bsp=e000004060048d50
 [<a0000001004c3a40>] __driver_attach+0x100/0x1a0
                                sp=e00000406004fd80 bsp=e000004060048d20
 [<a0000001004c1260>] bus_for_each_dev+0x80/0x100
                                sp=e00000406004fd80 bsp=e000004060048ce8
 [<a0000001004c3060>] driver_attach+0x40/0x60
                                sp=e00000406004fda0 bsp=e000004060048cc8
 [<a0000001004c2130>] bus_add_driver+0xf0/0x3a0
                                sp=e00000406004fda0 bsp=e000004060048c88
 [<a0000001004c4540>] driver_register+0x160/0x180
                                sp=e00000406004fda0 bsp=e000004060048c68
 [<a0000001003fce80>] __pci_register_driver+0xc0/0x140
                                sp=e00000406004fda0 bsp=e000004060048c30
 [<a00000010090c840>] mptspi_init+0x180/0x1c0
                                sp=e00000406004fdb0 bsp=e000004060048c10
 [<a0000001008d5580>] init+0x420/0x6c0
                                sp=e00000406004fdb0 bsp=e000004060048bd8
 [<a0000001000134d0>] kernel_thread_helper+0xd0/0x100
                                sp=e00000406004fe30 bsp=e000004060048bb0
 [<a0000001000094c0>] start_kernel_thread+0x20/0x40
                                sp=e00000406004fe30 bsp=e000004060048bb0
