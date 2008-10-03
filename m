Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYJCPwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYJCPwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYJCPvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:51:12 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:55701 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYJCPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:51:10 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 17:50:58 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031750.59047.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 3. Oktober 2008 schrieb Linus Torvalds:
> Ok, I can repro it. I couldn't see it before because I usually don't have 
> PREEMPT even enabled.  Enabling PREEMPT and PREEMPT_DEBUG gets me the 
> messages too. Jesse?

I ow enabled FRAMEBUFFERS and increased the log size to actually get the first 
one. Its different from yours, but should be the same problem.
According to grep I have 265 warnings in dmesg.


[    0.853027] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    0.867831] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.882588] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.897300] e1000e 0000:00:19.0: setting latency timer to 64
[    0.897456] ------------[ cut here ]------------
[    0.912011] WARNING: at drivers/net/e1000e/ich8lan.c:399 
e1000_acquire_swflag_ich8lan+0xe7/0xf0()
[    0.926825] Modules linked in:
[    0.941486] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-00055-gb5ff7df #34
[    0.956340]  [<c04da2c1>] ? printk+0x18/0x1f
[    0.971205]  [<c0141ae4>] warn_on_slowpath+0x54/0x80
[    0.986110]  [<c013741b>] ? kunmap_atomic+0x3b/0xc0
[    1.001016]  [<c0134dd3>] ? change_page_attr_set_clr+0xc3/0x1b0
[    1.015966]  [<c0319a67>] e1000_acquire_swflag_ich8lan+0xe7/0xf0
[    1.030827]  [<c013507f>] ? _set_memory_uc+0x1f/0x30
[    1.045530]  [<c031e48c>] e1000e_read_phy_reg_igp+0x1c/0x70
[    1.060097]  [<c031e54e>] e1000e_get_phy_id+0x1e/0x80
[    1.074481]  [<c031e5cf>] e1000e_determine_phy_address+0x1f/0x50
[    1.088705]  [<c031a87f>] e1000_get_variants_ich8lan+0xdf/0x250
[    1.102774]  [<c04cea3f>] e1000_probe+0x40f/0xc80
[    1.116727]  [<c01e5056>] ? sysfs_addrm_finish+0x16/0x200
[    1.130557]  [<c01e4833>] ? sysfs_add_one+0x13/0x50
[    1.144120]  [<c01e48c1>] ? sysfs_addrm_start+0x51/0x90
[    1.144128]  [<c02a0d65>] ? pci_match_device+0xb5/0xc0
[    1.144136]  [<c02a156e>] pci_device_probe+0x5e/0x80
[    1.144143]  [<c030aeb2>] driver_probe_device+0x82/0x1a0
[    1.144152]  [<c030b041>] __driver_attach+0x71/0x80
[    1.144159]  [<c030a7c3>] bus_for_each_dev+0x53/0x80
[    1.144165]  [<c02a14b0>] ? pci_device_remove+0x0/0x40
[    1.144172]  [<c030ad39>] driver_attach+0x19/0x20
[    1.144179]  [<c030afd0>] ? __driver_attach+0x0/0x80
[    1.144186]  [<c030a197>] bus_add_driver+0x1a7/0x220
[    1.144193]  [<c02a14b0>] ? pci_device_remove+0x0/0x40
[    1.144200]  [<c030b1e9>] driver_register+0x69/0x150
[    1.144206]  [<c0315040>] ? fan_write+0x0/0x3c0
[    1.144213]  [<c06a8080>] ? e1000_init_module+0x0/0x70
[    1.144221]  [<c02a178a>] __pci_register_driver+0x4a/0xa0
[    1.144228]  [<c06a8080>] ? e1000_init_module+0x0/0x70
[    1.144235]  [<c06a80c8>] e1000_init_module+0x48/0x70
[    1.144241]  [<c01012f6>] do_one_initcall+0x26/0x170
[    1.144248]  [<c01ddab4>] ? create_proc_entry+0x54/0xb0
[    1.144255]  [<c017502e>] ? register_irq_proc+0xbe/0xe0
[    1.144264]  [<c0175098>] ? init_irq_proc+0x48/0x60
[    1.144271]  [<c068b89d>] kernel_init+0x11a/0x17d
[    1.144279]  [<c068b783>] ? kernel_init+0x0/0x17d
[    1.144285]  [<c011d207>] kernel_thread_helper+0x7/0x10
