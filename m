Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbYEHAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbYEHAEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYEHAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:04:11 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:39326 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYEHAEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:04:08 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200805080004.m48045SQ008561@clem.clem-digital.net>
Subject: 2.6.25-git14-2.6.26-rc1-git5 boot warning at blkdev.h
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Wed, 7 May 2008 20:04:05 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi. Have been getting the following during boot since 25-git14.

 hda: hda1 hda2 hda3 hda4
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7890/91 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi 0:0:0:0: Direct-Access     QUANTUM  ATLAS IV 9 WLS   0808 PQ: 0 ANSI: 3
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x112/0x130()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc1-git5 #1
 [<c011e0ef>] warn_on_slowpath+0x5f/0x90
 [<c0222811>] vgacon_scroll+0x101/0x1d0
 [<c023afb8>] scrup+0xe8/0x100
 [<c0133fb7>] atomic_notifier_call_chain+0x17/0x20
 [<c023afed>] notify_update+0x1d/0x30
 [<c023b254>] vt_console_print+0x1e4/0x2c0
 [<c023b070>] vt_console_print+0x0/0x2c0
 [<c011e527>] __call_console_drivers+0x67/0x80
 [<c0133d61>] up+0x11/0x40
 [<c01fb6f9>] init_tag_map+0x59/0xc0
 [<c01fb862>] __blk_queue_init_tags+0x32/0x60
 [<c01fba72>] blk_queue_init_tags+0x112/0x130
 [<c028a5b2>] ahc_platform_set_tags+0x1b2/0x1f0
 [<c028a702>] ahc_linux_slave_configure+0x112/0x180
 [<c02719a9>] scsi_probe_and_add_lun+0x6f9/0x9b0
 [<c0271eda>] __scsi_scan_target+0xda/0x5e0
 [<c0206bd9>] idr_get_empty_slot+0xf9/0x290
 [<c0206f3e>] idr_get_new_above_int+0x3e/0x50
 [<c019bc90>] xlate_proc_name+0x30/0x80
 [<c0206f5a>] idr_get_new+0xa/0x30
 [<c019bf14>] proc_register+0x94/0x150
 [<c0272467>] scsi_scan_channel+0x87/0xa0
 [<c0272557>] scsi_scan_host_selected+0xd7/0x110
 [<c02725fb>] do_scsi_scan_host+0x6b/0x70
 [<c028c04d>] ahc_linux_register_host+0x2dd/0x410
 [<c028ce22>] ahc_linux_pci_dev_probe+0x172/0x1e0
 [<c01a3504>] sysfs_addrm_finish+0x14/0x1b0
 [<c01a3263>] sysfs_add_one+0x43/0xa0
 [<c01a406a>] sysfs_create_link+0x8a/0xf0
 [<c0217730>] pci_match_device+0x10/0xa0
 [<c028ccb0>] ahc_linux_pci_dev_probe+0x0/0x1e0
 [<c02178b6>] pci_device_probe+0x56/0x80
 [<c024df28>] driver_probe_device+0x88/0x180
 [<c024e08c>] __driver_attach+0x6c/0x70
 [<c024d6ba>] bus_for_each_dev+0x3a/0x60
 [<c024dda6>] driver_attach+0x16/0x20
 [<c024e020>] __driver_attach+0x0/0x70
 [<c024dafc>] bus_add_driver+0xac/0x230
 [<c02175d0>] pci_device_shutdown+0x0/0x20
 [<c0217800>] pci_device_remove+0x0/0x40
 [<c024e29d>] driver_register+0x4d/0x120
 [<c024e8a9>] class_register+0x149/0x150
 [<c0217add>] __pci_register_driver+0x3d/0x80
 [<c03ffa72>] ahc_linux_init+0x52/0x60
 [<c03e9810>] kernel_init+0x120/0x290
 [<c011a3e6>] schedule_tail+0x16/0x50
 [<c0102dd6>] ret_from_fork+0x6/0x1c
 [<c03e96f0>] kernel_init+0x0/0x290
 [<c03e96f0>] kernel_init+0x0/0x290
 [<c0103a87>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace bb58b84907300548 ]---
scsi0:A:0:0: Tagged Queuing enabled.  Depth 8
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: wide asynchronous
scsi target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
scsi target0:0:0: Domain Validation skipping write tests
scsi target0:0:0: Ending Domain Validation
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0

-- 
Pete Clements 
