Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbXK3MeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbXK3MeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXK3MeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:34:14 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45459 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbXK3MeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:34:13 -0500
Date: Fri, 30 Nov 2007 14:34:11 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata4294967295: failed to start port (errno=-19)
In-Reply-To: <20071128200716.14eccfdd@the-village.bc.nu>
Message-ID: <Pine.SOC.4.64.0711301433130.13468@math.ut.ee>
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
 <20071128200716.14eccfdd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you stick a stack trace in at that point ? That would help diagnose
> it a great deal quicker.

Finally done - found out hard way that BUG() is too bad and 
dump_st5ack() suits me better.

libata version 3.00 loaded.
Pid: 661, comm: modprobe Not tainted 2.6.24-rc3 #3
 [<d48cac80>] ata_host_start+0xf0/0x140 [libata]
 [<d48d5f2e>] ata_pci_init_one+0xee/0x2a0 [libata]
 [<c01a6077>] sysfs_create_link+0x77/0x100
 [<d4825037>] pacpi_init_one+0x17/0x20 [pata_acpi]
 [<c01d64e6>] pci_device_probe+0x56/0x80
 [<c022dfd7>] driver_probe_device+0x87/0x190
 [<c02b2191>] klist_next+0x51/0xb0
 [<c022e216>] __driver_attach+0x76/0x80
 [<c022d3ea>] bus_for_each_dev+0x3a/0x60
 [<c022de56>] driver_attach+0x16/0x20
 [<c022e1a0>] __driver_attach+0x0/0x80
 [<c022d7ab>] bus_add_driver+0x8b/0x1e0
 [<c01d667c>] __pci_register_driver+0x4c/0x90
 [<c0139231>] sys_init_module+0x121/0x1550
 [<c014eabf>] vma_prio_tree_insert+0x1f/0x50
 [<d48d12f0>] ata_std_prereset+0x0/0x160 [libata]
 [<c0155648>] do_mmap_pgoff+0x298/0x320
 [<c0104086>] syscall_call+0x7/0xb
 [<c02b0000>] packet_setsockopt+0xf0/0x3b0
 =======================
ata4294967295: failed to start port (errno=-19)


-- 
Meelis Roos (mroos@linux.ee)
